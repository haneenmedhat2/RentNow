//
//  AppDocumentPickerField.swift
//  RentNow
//

import SwiftUI
import UniformTypeIdentifiers

struct AppDocumentPickerField: View {
    let title: String
    @Binding var documentURL: URL?
    @Binding var documentName: String
    @Binding var documentError: String?

    @State private var showingPicker = false

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .expoSystemFont(size: FontSize.normal, weight: .medium)

            if let _ = documentURL {
                // Selected file display
                HStack(spacing: 8) {
                    Image(systemName: "doc.fill")
                        .foregroundColor(.mainColor)
                        .font(.system(size: 20))

                    Text(documentName)
                        .expoSystemFont(size: FontSize.normal, weight: .medium)
                        .foregroundColor(.text)
                        .lineLimit(1)

                    Spacer()

                    Button {
                        documentURL = nil
                        documentName = ""
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 22))
                            .foregroundColor(.red)
                    }
                }
                .padding(12)
                .glassyBackground(cornerRadius: 12)
            } else {
                // Pick button
                Button {
                    showingPicker = true
                } label: {
                    HStack(spacing: 8) {
                        Image("selectImage")
                            .resizable()
                            .frame(width: 50, height: 50)

                        Spacer()
                    }
                    .frame(minHeight: 50)
                    .padding(12)
                }
                .buttonStyle(PlainButtonStyle())
                .overlay(RoundedRectangle(cornerRadius: 12).stroke(
                    (documentError != nil) ? Color.red : Color.clear,
                    lineWidth: 0.7
                ))
            }

            if documentError != nil {
                HStack {
                    Text(documentError ?? "")
                        .expoSystemFont(size: FontSize.normal, weight: .medium)
                        .foregroundColor(.red)
                        .padding(8)
                    Spacer()
                }
            }
        }
        .padding(.horizontal, 16)
        .sheet(isPresented: $showingPicker) {
            DocumentPickerView(onPick: { url in
                documentURL = url
                documentName = url.lastPathComponent
                documentError = nil
            })
        }
    }
}

// MARK: - Document Picker UIViewControllerRepresentable
struct DocumentPickerView: UIViewControllerRepresentable {
    let onPick: (URL) -> Void

    func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
        let picker = UIDocumentPickerViewController(forOpeningContentTypes: [UTType.pdf])
        picker.delegate = context.coordinator
        picker.allowsMultipleSelection = false
        return picker
    }

    func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(onPick: onPick)
    }

    class Coordinator: NSObject, UIDocumentPickerDelegate {
        let onPick: (URL) -> Void

        init(onPick: @escaping (URL) -> Void) {
            self.onPick = onPick
        }

        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            guard let url = urls.first else { return }
            // Start accessing security-scoped resource
            guard url.startAccessingSecurityScopedResource() else { return }
            defer { url.stopAccessingSecurityScopedResource() }

            // Copy to temp directory for persistent access
            let tempDir = FileManager.default.temporaryDirectory
            let tempURL = tempDir.appendingPathComponent(url.lastPathComponent)
            try? FileManager.default.removeItem(at: tempURL)
            try? FileManager.default.copyItem(at: url, to: tempURL)

            onPick(tempURL)
        }
    }
}
