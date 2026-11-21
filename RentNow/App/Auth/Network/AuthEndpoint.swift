//
//  AuthEndpoint.swift
//  LOH-2024
//
//  Created by Elshamy on 14/07/2024.
//

import Foundation
import Alamofire

struct AuthEndpoints {
    private init() {}
}

struct AuthEndpoint {
    static func login (phone:String , countryCode:String, password:String ) -> Endpoint<BaseResponse<User>> {
        return .init(
            method: .post,
            path: "Auth/Login",
            body: [
                "phone": phone,
                "password": password,
                "phoneCode": countryCode,
                "device": [
                    "deviceId": UserDefaults.pushNotificationToken,
                    "deviceType": "IOS",
                    "projectName": "rent"
                ]
            ]
        )
    }
    static func countryCode() -> Endpoint<BaseResponse<[Country]>> {
        return .init(
            method: .get,
            path: "Lookups/GetActiveCountries"

        )
    }

    static func registrationFormData() -> Endpoint<BaseResponse<RegistrationFormData>> {
        return .init(
            method: .get,
            path: "Auth/RegistrationFormData"
        )
    }



    static func getCities(countryId:Int) -> Endpoint<BaseResponse<[City]>> {
        return .init(
            method: .get,
            path: "Lookups/GetCitiesByCountryId/\(countryId)"
            
        )
    }
    
    
    static func register(
        userName: String,
        phone: String,
        countryCode:String,
        nationalId: String,
        countryId: Int,
        cityId: Int,
        password: String,
        confirmPassword: String,
        imageData: Data?
    ) -> Endpoint<BaseResponse<Bool>> {
        var uploads: [UploadData]? = nil
        if let data = imageData {
            uploads = [UploadData(key: "Image", data: data, mimeType: .jpeg)]
        }

        return .init(
            method: .post,
            path: "Auth/Register",
            body: [
                "UserName": userName,
                "PhoneCode":countryCode,
                "Phone": phone,
                "NationalId": nationalId,
                "CountryId": countryId,
                "CityId": cityId,
                "Password": password,
                "ConfirmPassword": confirmPassword,
                "Device.DeviceId": UserDefaults.pushNotificationToken,
                "Device.DeviceType": DeviceInfo.deviceType,
                "Device.ProjectName": DeviceInfo.projectName
            ],
            uploads: uploads,
            encoding: .formData
        )
    }
    
    static func activeCode(countryCode:String,phone:String,code:String) -> Endpoint<BaseResponse<User>> {
         return .init(method: .post,
                      path: "Auth/ConfirmCode" ,
                      body: [
                         "phoneNumber": phone,
                         "code":code,
                         "phoneCode":countryCode,
                         "deviceId": UserDefaults.pushNotificationToken,
                         "deviceType": DeviceInfo.deviceType,
                         "projectName": DeviceInfo.projectName
                      ]
         )
     }
    static func ChangeLanguage(language:String) -> Endpoint<BaseResponse<Bool>> {
        return .init(method: .patch,
                     path: "change-lang" ,
                     queries: [
                        "lang": language
                     ]
        )
    }
    
  
    
    static func resendCode(countryCode:String,phone:String) -> Endpoint<BaseResponse<Bool>> {
        return .init(method: .post,
                     path: "Auth/ResendCode" ,
                     body:  [
                        "phoneNumber": phone,
                        "phoneCode":countryCode,
                     ]
        )
    }
    
    // password
    static func forgotPassword(countryCode:String,phone: String) -> Endpoint<BaseResponse<Bool>> {
        return .init(
            method: .post,
            path: "Auth/ForgotPassword",
            body: [
                "PhoneCode":countryCode,
                "phone": phone
            ]
        )
    }
    
    
    static func resendForgotPasswordCode(countryCode:String,phone: String) -> Endpoint<BaseResponse<Bool>> {
        return .init(
            method: .post,
            path: "Auth/ResendForgotPasswordCode",
            body: [
                "PhoneCode":countryCode,
                "phone": phone
            ]
        )
    }
    
    static func resetPassword(password:String, confirmPassword:String, countryCode:String, phone:String?) -> Endpoint<BaseResponse<Bool>> {
        return .init(method: .post,
                     path: "Auth/ResetPassword" ,
                     body: [
                        "phoneCode":countryCode,
                        "phone": phone,
                        "newPassword": password,
                        "confirmPassword": confirmPassword
                     ]
        )
    }
    /////////////////////////////////////
    
    
    static func forgetPasswordCheckCode(countryCode:String,phone:String,code:String) -> Endpoint<BaseResponse<Bool>> {
        return .init(method: .post,
                     path: "Auth/VerifyForgotPasswordCode" ,
                     body: [
                        "PhoneCode":countryCode,
                        "phone": phone,
                        "code":code
//                        ,
//                        "country_code":countryCode
                   
                     ]
        
        
        
        )
    }
    
    static func activePhoneCode(code:Int) -> Endpoint<BaseResponse<Bool>> {
        return .init(method: .post,
                     path: "change-phone-check-code" ,
                     body: [
                        "code":code
                     ],
                     headerType: .authorized(token: UserDefaults.accessToken ?? "")
        
        
        
        )
    }
    


    
    static func resendPhoneCode(countryCode:String,phone:String ,password:String) -> Endpoint<BaseResponse<Bool>> {
        return .init(method: .post,
                     path: "change-phone-resend-code" ,
                     body:  [
                        "PhoneCode":countryCode,
                        "phone": phone,
                        "password":password
                     ]
        )
    }
    
    
 
    
    

 



}
