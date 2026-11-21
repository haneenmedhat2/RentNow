//
//  DefaultNetworkExecuter.swift
//  App
//
//  Created by MGAbouarab on 25/12/2023.
//

import Foundation
import Alamofire

struct DefaultNetworkExecuter: NetworkExecuter {
    private let session: Session

    init(session: Session = .default) {
        self.session = session
    }

    func execute(_ request: any Requestable, progress progressHandler: ((_ progress: Int)-> Void)? = nil) async throws -> Data {

        let urlRequest = try request.asURLRequest()
        let url = urlRequest.url?.absoluteString
        let requestID = UUID().uuidString

        #if DEBUG
        logRequest(request, url: url, requestID: requestID)
        #endif

        let shouldUseFormData = request.encoding == .formData || !(request.uploads?.isEmpty ?? true)
        if shouldUseFormData {
            return try await upload(request, urlRequest: urlRequest, url: url, requestID: requestID, progress: progressHandler)
        }
        return try await send(urlRequest, url: url, requestID: requestID)
    }

    private func send(_ urlRequest: URLRequest, url: String?, requestID: String) async throws -> Data {
        let result = await session.request(urlRequest).serializingData().result
        return try handle(result, url: url, requestID: requestID)
    }

    private func upload(_ request: any Requestable, urlRequest originalRequest: URLRequest, url: String?, requestID: String, progress progressHandler: ((_ progress: Int)-> Void)?) async throws -> Data {
        var urlRequest = originalRequest
        urlRequest.httpBody = nil
        let result = await session.upload(multipartFormData: { multipartFormData in
            if let parameters = request.body?.compactMapValues({$0}) {
                for (key, value) in parameters {
//                    multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
                    self.append(value: value, withName: key, to: multipartFormData)

                }
            }
            for item in request.uploads ?? [] {
                multipartFormData.append(item.data, withName: item.key, fileName: item.filenameWithExtension, mimeType: item.mimeType.rawValue)

            }
        }, with: urlRequest).uploadProgress(queue: .main) { progress in
            let value = Int(progress.fractionCompleted*100)
            progressHandler?(value)
            print("the Progress is \(value) %")
        }.serializingData().result
        return try self.handle(result, url: url, requestID: requestID)
    }


    private func handle(_ result: Result<Data,AFError>, url: String?, requestID: String) throws -> Data {
        switch result {
        case .success(let data):
            #if DEBUG
            self.logResponse(data: data, url: url, requestID: requestID)

            // Handle empty response — synthesize success JSON to avoid decode crash
            if data.isEmpty {
                print("⚠️⚠️ WARNING: Server returned empty response (0 bytes) for \(url ?? "unknown")")
                let synthetic = "{\"key\":\"success\",\"message\":\"\",\"data\":null}"
                return synthetic.data(using: .utf8) ?? data
            }
            #endif
            // Detect non-standard error response (e.g. {"error":"...","errorId":"...","timestamp":"..."})
            // Server occasionally returns this format instead of BaseResponse on HTTP 500.
            if let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
               json["key"] == nil {
                let errorMessage = (json["error"] as? String) ?? "Something went wrong"
                if let syntheticData = try? JSONSerialization.data(
                    withJSONObject: ["key": "fail", "message": errorMessage, "data": NSNull()]
                ) {
                    return syntheticData
                }
            }
            return data
        case .failure(let error):
            // Empty response body (server returned 2xx with no content) — synthesize success JSON
            if case .responseSerializationFailed(let reason) = error,
               case .inputDataNilOrZeroLength = reason {
                let synthetic = "{\"key\":\"success\",\"message\":\"\",\"data\":null}"
                return synthetic.data(using: .utf8) ?? Data()
            }

            // Silently convert cancellation to CancellationError — no logging, no toast
            if case .explicitlyCancelled = error {
                throw CancellationError()
            }

            #if DEBUG
            // Log detailed error information
            print("\n❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌")
            print("❌❌ NETWORK ERROR [\(requestID)] for \(safeURL(url)):")
            print("Error Description: \(error.localizedDescription)")
            print("Error Type: \(error)")
            if let underlyingError = error.underlyingError {
                print("Underlying Error: \(underlyingError.localizedDescription)")
                print("Underlying Error Details: \(underlyingError)")
            }
            if let responseCode = error.responseCode {
                print("HTTP Status Code: \(responseCode)")
            }
            print("❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌\n")
            #endif

            // Check for no internet connection error
            if let underlyingError = error.underlyingError as NSError?,
               underlyingError.code == NSURLErrorNotConnectedToInternet ||
               underlyingError.code == NSURLErrorNetworkConnectionLost {
                DispatchQueue.main.async {
                    NoInternetAlertManager.shared.showNoInternetAlert()
                }
            }

            throw error
        }
    }

    #if DEBUG
    private func logRequest(_ request: any Requestable, url: String?, requestID: String) {
        print("\n🚀 REQUEST [\(requestID)]")
        print("URL: \(safeURL(url))")
        print("Method: \(request.method.rawValue)")
        if let body = request.body {
            let values = body.compactMapValues { $0 }
            print("Body: \(redacted(values))")
        }
        if let uploads = request.uploads, !uploads.isEmpty {
            print("Uploads: \(uploads.count) file(s)")
        }
    }

    private func logResponse(data: Data, url: String?, requestID: String) {
        print("\n⚡️ RESPONSE [\(requestID)] for \(safeURL(url))")
        if let object = try? JSONSerialization.jsonObject(with: data),
           let sanitized = try? JSONSerialization.data(withJSONObject: redacted(object), options: [.prettyPrinted, .sortedKeys, .fragmentsAllowed]),
           let text = String(data: sanitized, encoding: .utf8) {
            print(text)
        } else {
            print("\(data.count) bytes")
        }
    }

    private func safeURL(_ raw: String?) -> String {
        guard let raw, var components = URLComponents(string: raw) else { return "Unknown URL" }
        components.user = nil
        components.password = nil
        components.queryItems = components.queryItems?.map { item in
            isSensitive(item.name) ? URLQueryItem(name: item.name, value: "[REDACTED]") : item
        }
        return components.string ?? "Unknown URL"
    }

    private func redacted(_ value: Any, key: String = "") -> Any {
        if isSensitive(key) { return "[REDACTED]" }
        if let dictionary = value as? [String: Any] {
            return dictionary.reduce(into: [String: Any]()) { result, entry in
                result[entry.key] = redacted(entry.value, key: entry.key)
            }
        }
        if let array = value as? [Any] { return array.map { redacted($0) } }
        return value
    }

    private func isSensitive(_ key: String) -> Bool {
        let normalized = key.lowercased().filter { $0.isLetter || $0.isNumber }
        return ["authorization", "password", "token", "secret", "apikey", "cardnumber", "securitycode", "cvv", "cvc"].contains { normalized.contains($0) }
    }
    #endif

    private func append(value: Any, withName name: String, to multipartFormData: MultipartFormData) {
        if let array = value as? [Any] {
            for (index, item) in array.enumerated() {
                if let dict = item as? [String: Any] {
                    // مصفوفة من دكشنري
                    for (key, nestedValue) in dict {
                        let fullKey = "\(name)[\(index)][\(key)]"
                        append(value: nestedValue, withName: fullKey, to: multipartFormData)
                    }
                } else {
                    // مصفوفة عادية
                    let fullKey = "\(name)[]"
                    if let data = "\(item)".data(using: .utf8) {
                        multipartFormData.append(data, withName: fullKey)
                    }
                }
            }
        } else if let dict = value as? [String: Any] {
            for (key, nestedValue) in dict {
                let fullKey = "\(name)[\(key)]"
                append(value: nestedValue, withName: fullKey, to: multipartFormData)
            }
        } else {
            if let data = "\(value)".data(using: .utf8) {
                multipartFormData.append(data, withName: name)
            }
        }
    }
}

