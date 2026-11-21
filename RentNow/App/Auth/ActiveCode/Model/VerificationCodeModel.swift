//
//  VerificationCodeModel.swift
//  Holool
//
//  Created by Elshamy on 11/11/2025.
//



struct ActiveCodeModel {
    var code: String?
    var phoneNumber: String?
    var countryCode: String?
    var currentType:ActiveType?
    
}

enum ActiveType: Hashable {
    case activeAccount
    case forgetPassword
}
