//
//  GerenralValidationError.swift
//  Three
//
//  Created by Mohamed Elmemy on 15/04/2024.
//

import Foundation
//MARK: - GerenralValidationError

enum GerenralValidationError: Error {
    case terms
    case emptySchool
    case emptySickness
    case shortSickness
    case emptyPassword
     case emptyCountryCode
    case emptyCity
    case shortPassword
    case passwordContainsSpaces
    case emptyConfirmPassword
    case shortConfirmPassword
    case emptyNewPassword
    case shortNewPassword
    case emptyOldPassword
    case shortOldPassword
    case emptyConfirmNewPassword
    case notMatchPasswords
    case emptyChildAge
    case longChildAge
    case emptyStartTime
    case emptyStartDate
    case emptyEndDate
    case emptyEndTime
    case startTimeAfterEndTime
    case startDateAfterEndTime
    case emptyImage
    //MARK: - Register Data
    case emptyProfilePicture
    case emptyName
    case emptyContractPeriod
    case emptyRentalPeriod
    case emptyDeviceCount
    case emptyServiceTypeId
   case emptySerialNumber
    case emptyDeviceModel
    case emptyFacilities
    case emptyDescriptionMalfunction
    case emptyRate
    case emptyGrade
    case emptyChildName
    case shortName
    case shortPhone
    case longName
    case emptyMail
    case sameTimeError
    case wrongMail
    case emptyPhone
    case emptyCityId
    case emptyActivityType
    case emptyActivityDescription
    case noDataChannge
    case emptyVerificationCode
    case emptyPhoneNumber
    case incorrectPhoneNumberCode

    case incorrectVerificationCode
    
    case emptyTitle
    case emptyMessage
    
    
    //Plan
    case emptyProperties
    case emptyPrice
    case emptyPackageName
    
    
    case emptySubCategoryId
    
    
    
    //MARK: - Bank -
    case bankAccountHolder
    case bankName
    case bankTransferImage
    case fromBankName
    case bankAccountNumber
    case shortBankAccountNumber
    case emptyIbanNumber
    case invalidIbanNumber
    case emptyStcPay
    
    //MARK: - Location
    case emptyAddress
    
    //MARK: - Order
    case emptyFeathers
    case emptyCancelReason
    
    
    //MARK: - Provider Register
    case emptyStoreName
    case emptyStoreDescription
    case emptyCommercialRegister
    case emptyNationalID
    case emptyStoreImageData
    
}


extension GerenralValidationError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .terms:
            return "Please read and agree our terms and conditions first".localized
        case .emptyPassword:
            return "Please enter password field.".localized
        case .shortPassword:
            return "Password is too short, it should be 6 characters at least.".localized
        case .passwordContainsSpaces:
            return "Password should not contain spaces at the beginning or end.".localized
        case .emptyConfirmPassword:
            return "Please enter confirmation password".localized
        case .shortConfirmPassword:
            return "Confirm Password is too short, it should be 6 characters at least.".localized
        case .emptyNewPassword:
            return "Please enter new password field.".localized
        case .shortNewPassword:
            return "New password is too short, it should be 6 characters at least.".localized
        case .emptyOldPassword:
            return "Please enter old password field.".localized
        case .shortOldPassword:
            return "Old password is too short, it should be 6 characters at least.".localized
        case .emptyConfirmNewPassword:
            return "Please enter confirm new password field.".localized
        case .notMatchPasswords:
            return "Passwords not match.".localized
        case .emptyProfilePicture:
            return "Please pick your profile picture.".localized
        case .emptyName:
            return "Please enter name.".localized
        case .shortName:
            return "Name is too short.".localized
        case .longName:
            return "Name is too long.".localized
        case .emptyMail:
            return "Please enter email field.".localized
        case .wrongMail:
            return "Please enter correct email address.".localized
        case .emptyPhone:
            return "Please enter your phone number.".localized
        case .emptyCityId:
            return "Please select city.".localized
        case .emptyActivityType:
            return "Please select activity type.".localized
        case .emptyActivityDescription:
            return "Please enter a description of the activity".localized
            
        case .emptyVerificationCode:
            return "Please enter verification code".localized
            
        case .incorrectVerificationCode:
            return "Verification Code should be 4 digits.".localized
            
            
            
            
            //Contact Use
        case .emptyTitle:
            return "Please enter the message title.".localized
        case .emptyMessage:
            return "Please enter the message text.".localized
        case .emptyProperties:
            return "Please enter the Properties".localized
        case .emptyPrice:
            return "Please enter the Price".localized
            
        case .emptyPackageName:
            return "Please enter package name".localized
        case .emptySubCategoryId:
            return "Please select the subcategory".localized
            
            
            //MARK: - Bank -
        case .bankAccountHolder:
            return "Please enter bank account holder name".localized
        case .bankName:
            return "Please enter bank name".localized
        case .bankTransferImage:
            return "Please select bank transfer image".localized
        case .fromBankName:
            return "Please enter from bank name".localized
        case .bankAccountNumber:
            return "Please enter bank account number".localized
        case .shortBankAccountNumber:
            return "The bank account number must be at least 16 digits long".localized
            
        case .emptyIbanNumber:
            return "Please enter the IBAN number".localized
            
        case .invalidIbanNumber:
            return "Please enter a valid IBAN format consisting of 24 letters and numbers".localized
            
        case .emptyStcPay:
            return "Please enter STCPAY details here".localized
            
            
        case .emptyAddress:
            return "Please specify location".localized
            
            
        case .emptyFeathers:
            return "Please select feathers".localized
            
            
        case .emptyCancelReason:
            return "Please enter cancel reason".localized
            
            //MARK: - Provider Register
            
        case .emptyStoreImageData:
            return "Please enter store Image".localized
            
        case .emptyStoreName:
            return "Please enter store name".localized
            
        case .emptyStoreDescription:
            return "Please enter Store description".localized
            
        case .emptyCommercialRegister:
            return "Please enter Commercial register".localized
            
        case .emptyNationalID:
            return "Please enter National ID".localized
            

        case .shortPhone:
            return "phone is too short, please enter correct phone number.".localized

        case .emptyChildName:
            return "Please enter child name".localized

        case .emptyChildAge:
            return "Please enter child age".localized
      
        case .longChildAge:
            return "Child age is too long, please enter correct age.".localized
        case .emptyGrade:
            return "Please enter child grade".localized
            
        case .emptyStartTime:
            return "Please enter child attendace start time".localized
            
        case .emptyEndTime:
            return "Please enter child attendace end time".localized


        case .emptyImage:
            return "Please enter child Image".localized
        case .emptySickness:
            return "Please enter your child sickness".localized

        case .shortSickness:
            return "its too short , please enter correct reason".localized

      
        case .noDataChannge:
            return "Please change at least one field".localized
        case .sameTimeError:
            return "End date must be greater than start date".localized

        case .startTimeAfterEndTime:
            return "Start time must be before end time".localized
        case .emptyStartDate:
            return "Please enter start date".localized
        case .emptyEndDate:
            return "Please enter end date".localized
        case .startDateAfterEndTime:
            return "Start date must be before end date".localized

        case .emptySchool:
            return "please select your school".localized
        case .emptyRate:
            return "Please enter your rate".localized

        case .emptyPhoneNumber:
            return "Please enter your phone number".localized

        case .incorrectPhoneNumberCode:
            return "Please enter correct phone number".localized

        case .emptyCountryCode:
            return "Please select your country code.".localized

        case .emptyCity:
            return "Please enter your city".localized
        case .emptyContractPeriod:
            return "Please enter contract period".localized

        case .emptyRentalPeriod:
            return "Please enter rental period".localized

        case .emptyDeviceCount:
            return "Please enter device count".localized
        case .emptyServiceTypeId:
            return "Please enter service type".localized

        case .emptySerialNumber:
            return "Please enter serial number".localized

        case .emptyDeviceModel:
            return "Please choose device model".localized

        case .emptyFacilities:
            return "Please choose section within the facility".localized

        case .emptyDescriptionMalfunction:
            return "Please enter description of the malfunction".localized
        }
        
    }
}
