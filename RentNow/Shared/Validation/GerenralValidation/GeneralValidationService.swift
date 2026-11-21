//
//  GeneralValidationService.swift
//  Three
//
//  Created by Mohamed Elmemy on 15/04/2024.
//

import Foundation


struct GeneralValidationService {
    
    //MARK: - Name
    static func validate(name: String?) throws -> String {
        guard let name = name, !name.trimWhiteSpace().isEmpty , name != "" else {
            throw GerenralValidationError.emptyName
        }
        return name
    }
    
    //MARK: - ContractPeriod
    static func validate(contractPeriod: String?) throws -> String {
        guard let contractPeriod = contractPeriod, !contractPeriod.trimWhiteSpace().isEmpty , contractPeriod != ""else {
            throw GerenralValidationError.emptyContractPeriod
        }
        return contractPeriod
    }
    
    static func validate(serialNumber: String?) throws -> String {
        guard let serialNumber = serialNumber, !serialNumber.trimWhiteSpace().isEmpty , serialNumber != ""else {
            throw GerenralValidationError.emptySerialNumber
        }
        return serialNumber
    }
    
    
    static func validate(deviceCount: String?) throws -> String {
        guard let deviceCount = deviceCount, !deviceCount.trimWhiteSpace().isEmpty , deviceCount != ""else {
            throw GerenralValidationError.emptyDeviceCount
        }
        return deviceCount
    }
    
    static func validate(deviceModel: String?) throws -> String {
        guard let deviceModel = deviceModel, !deviceModel.trimWhiteSpace().isEmpty , deviceModel != ""else {
            throw GerenralValidationError.emptyDeviceModel
        }
        return deviceModel
    }
    static func validate(facilities: String?) throws -> String {
        guard let facilities = facilities, !facilities.trimWhiteSpace().isEmpty , facilities != ""else {
            throw GerenralValidationError.emptyFacilities
        }
        return facilities
    }
    
    static func validate(descriptionMalfunction: String?) throws -> String {
        guard let descriptionMalfunction = descriptionMalfunction, !descriptionMalfunction.trimWhiteSpace().isEmpty , descriptionMalfunction != ""else {
            throw GerenralValidationError.emptyDescriptionMalfunction
        }
        return descriptionMalfunction
    }
    
    
    
    static func validate(serviceTypeId: String?) throws -> String {
        guard let serviceTypeId = serviceTypeId, !serviceTypeId.trimWhiteSpace().isEmpty , serviceTypeId != ""else {
            throw GerenralValidationError.emptyServiceTypeId
        }
        return serviceTypeId
    }
   
  
    
    
    static func validate(rate: String?) throws -> String {
        guard let rate = rate, !rate.trimWhiteSpace().isEmpty else {
            throw GerenralValidationError.emptyRate
        }
        return rate
    }
    
    //Contact Us Data
    static func validate(title: String?) throws -> String {
        guard let title = title, !title.trimWhiteSpace().isEmpty else {
            throw GerenralValidationError.emptyTitle
        }
        return title
    }
    
    static func validate(message: String?) throws -> String {
        guard let message = message, !message.trimWhiteSpace().isEmpty else {
            throw GerenralValidationError.emptyMessage
        }
        return message
    }
    
    
    //MARK: - Email -
    static func validate(email: String?) throws -> String {
        guard let email = email, !email.trimWhiteSpace().isEmpty else {
            throw GerenralValidationError.emptyMail
        }
        guard email.isValidEmail() else{
            throw GerenralValidationError.wrongMail
        }
        return email
    }
    
    
    //MARK: - Passwords -
    static func validate(password: String?) throws -> String {
        guard let password = password, !password.trimWhiteSpace().isEmpty else {
            throw GerenralValidationError.emptyPassword
        }
        guard password == password.trimWhiteSpace() else {
            throw GerenralValidationError.passwordContainsSpaces
        }
        guard password.count > 5 else {
            throw GerenralValidationError.shortPassword
        }
        return password
    }
    
    static func validate(countryCode: String?) throws -> String {
        guard let countryCode = countryCode, !countryCode.trimWhiteSpace().isEmpty else {
            throw GerenralValidationError.emptyCountryCode
        }
        return countryCode
    }
    
    static func validate(city: String?) throws -> String {
        guard let city = city, !city.trimWhiteSpace().isEmpty else {
            throw GerenralValidationError.emptyCity
        }
        return city
    }
    static func validate(code: String?) throws -> String {
        guard let code = code, !code.trimWhiteSpace().isEmpty else {
            throw GerenralValidationError.emptyVerificationCode
        }
        guard code.count > 3 else {
            throw GerenralValidationError.incorrectVerificationCode
        }
        return code
    }

    static func validate(phone: String?) throws -> String {
        guard let phone = phone, !phone.trimWhiteSpace().isEmpty else {
            throw GerenralValidationError.emptyPhoneNumber
        }
        guard phone.count >= 9 else {
            throw GerenralValidationError.incorrectPhoneNumberCode
        }
        return phone
    }
    
    
    static func validate(confirmPassword: String?) throws -> String {
        guard let confirmPassword = confirmPassword, !confirmPassword.trimWhiteSpace().isEmpty else {
            throw GerenralValidationError.emptyConfirmPassword
        }
        guard confirmPassword == confirmPassword.trimWhiteSpace() else {
            throw GerenralValidationError.passwordContainsSpaces
        }
        guard confirmPassword.count > 5 else {
            throw GerenralValidationError.shortConfirmPassword
        }

        return confirmPassword
    }
    
    
    static func validate(newPassword: String?) throws -> String {
        guard let newPassword = newPassword, !newPassword.trimWhiteSpace().isEmpty else {
            throw GerenralValidationError.emptyNewPassword
        }
        guard newPassword == newPassword.trimWhiteSpace() else {
            throw GerenralValidationError.passwordContainsSpaces
        }
        guard newPassword.count > 5 else {
            throw GerenralValidationError.shortNewPassword
        }
        return newPassword
    }
    static func validate(oldPassword: String?) throws -> String {
        guard let oldPassword = oldPassword, !oldPassword.trimWhiteSpace().isEmpty else {
            throw GerenralValidationError.emptyOldPassword
        }
        guard oldPassword == oldPassword.trimWhiteSpace() else {
            throw GerenralValidationError.passwordContainsSpaces
        }
        guard oldPassword.count > 5 else {
            throw GerenralValidationError.shortOldPassword
        }
        return oldPassword
    }
    
    static func validate(newPassword: String?, confirmNewPassword: String?) throws -> String {
        guard let newPassword = newPassword, let confirmNewPassword = confirmNewPassword, !confirmNewPassword.trimWhiteSpace().isEmpty else {
            throw GerenralValidationError.emptyConfirmNewPassword
        }
        guard newPassword == confirmNewPassword else {
            throw GerenralValidationError.notMatchPasswords
        }
        return newPassword
    }
    static func validate(newPassword: String, confirmPassword: String?) throws -> String {
        guard let confirmPassword = confirmPassword, !confirmPassword.trimWhiteSpace().isEmpty else {
            throw GerenralValidationError.emptyConfirmPassword
        }
        guard newPassword == confirmPassword else {
            throw GerenralValidationError.notMatchPasswords
        }
        return newPassword
    }
    
    static func validate(termsAgreed: Bool) throws {
        guard termsAgreed else {
            throw GerenralValidationError.terms
        }
    }
    
  
    
    static func validate(childName: String?) throws -> String {
        guard let childName = childName, !childName.trimWhiteSpace().isEmpty , childName != "" else {
            throw GerenralValidationError.emptyChildName
        }
        guard childName.count > 1 else {
            throw GerenralValidationError.shortName
        }
        guard childName.count < 61 else {
            throw GerenralValidationError.longName
        }
        return childName
    }
    
    static func validate(childAge: String?) throws -> String {
        guard let childAge = childAge, !childAge.trimWhiteSpace().isEmpty , childAge != "" else {
            throw GerenralValidationError.emptyChildAge
        }
       
        guard childAge.count < 3 else {
            throw GerenralValidationError.longChildAge
        }
        
        return childAge
    }
    
   
    static func validate(grade: String?) throws -> String {
        guard let grade = grade, !grade.trimWhiteSpace().isEmpty , grade != "" else {
            throw GerenralValidationError.emptyGrade
        }
        return grade
    }
    
    static func validate(startTime: String?) throws -> String {
        guard let startTime = startTime, !startTime.trimWhiteSpace().isEmpty , startTime != "" else {
            throw GerenralValidationError.emptyStartTime
        }
        return startTime
    }
    
    static func validate(endTime: String?) throws -> String {
        guard let endTime = endTime, !endTime.trimWhiteSpace().isEmpty , endTime != "" else {
            throw GerenralValidationError.emptyEndTime
        }
        return endTime
    }
    
    
    static func validate(startDate: String?) throws -> String {
        guard let startDate = startDate, !startDate.trimWhiteSpace().isEmpty , startDate != "" else {
            throw GerenralValidationError.emptyStartDate
        }
        return startDate
    }

    static func validate(endDate: String?) throws -> String {
        guard let endDate = endDate, !endDate.trimWhiteSpace().isEmpty , endDate != "" else {
            throw GerenralValidationError.emptyEndDate
        }
        return endDate
    }

    static func validate(rentalPeriod: String?) throws -> String {
        guard let rentalPeriod = rentalPeriod, !rentalPeriod.trimWhiteSpace().isEmpty , rentalPeriod != "" else {
            throw GerenralValidationError.emptyRentalPeriod
        }
        return rentalPeriod
    }



    static func validate(image: Data?) throws -> Data {
        guard let image = image else {
            throw GerenralValidationError.emptyImage
        }
        return image
    }

    
    static func validate(sickness: String?) throws -> String {
        guard let sickness = sickness, !sickness.trimWhiteSpace().isEmpty , sickness != "" else {
            throw GerenralValidationError.emptySickness
        }
        guard sickness.count > 1 else {
            throw GerenralValidationError.shortSickness
        }
       
        return sickness
    }
    
    static func validate(address: UserAddressesModel?) throws -> UserAddressesModel {
        guard let address = address else {
            throw GerenralValidationError.emptyAddress
        }
        
        guard address.lat != nil, address.long != nil else {
            throw GerenralValidationError.emptyAddress
        }
        return address
    }
    
}


    
//    static func validate(userRegisterData: UserRegisterDataModel?) throws -> UserRegisterDataModel {
//        guard let userData = userRegisterData else {
//            throw GerenralValidationError.emptyName
//        }
//        
//        guard let name = userData.userName, !name.trimWhiteSpace().isEmpty else {
//            throw GerenralValidationError.emptyName
//        }
//        
//        guard name.count > 1 else {
//            throw GerenralValidationError.shortName
//        }
//        guard name.count < 61 else {
//            throw GerenralValidationError.longName
//        }
//        
//        
//        guard let phone = userData.phoneNumber, !phone.trimWhiteSpace().isEmpty else {
//            throw GerenralValidationError.emptyPhone
//        }
//        
//        guard let email = userData.email, !email.trimWhiteSpace().isEmpty else {
//            throw GerenralValidationError.emptyMail
//        }
//        
//        guard email.isValidEmail() else{
//            throw GerenralValidationError.wrongMail
//        }
//        
//        
//        
//        //        guard phone.isValidPhoneNumber(pattern: #"^(009665|9665|\+9665|05|5)(5|0|3|6|4|9|1|8|7)([0-9]{7})$"#) else {
//        //            throw PhoneValidationErrors.inValidPhone
//        //        }
//        
//        guard userData.cityId != nil else {
//            throw GerenralValidationError.emptyCityId
//        }
//        
//        
//        guard let bankName = userData.bankName, !bankName.trimWhiteSpace().isEmpty else {
//            throw GerenralValidationError.bankName
//        }
//        
//        guard let accountNumber = userData.accountNumber, !accountNumber.trimWhiteSpace().isEmpty else {
//            throw GerenralValidationError.bankAccountNumber
//        }
//        
//        guard accountNumber.count >= 16 else {
//            throw GerenralValidationError.shortBankAccountNumber
//        }
//        
//        guard let password = userData.password, !password.trimWhiteSpace().isEmpty else {
//            throw GerenralValidationError.emptyPassword
//        }
//        
//        guard let confirmPassword = userData.passwordConfirmation, !confirmPassword.trimWhiteSpace().isEmpty else {
//            throw GerenralValidationError.emptyConfirmPassword
//        }
//        
//        guard password == confirmPassword else {
//            throw GerenralValidationError.notMatchPasswords
//        }
//        
//        return userData
//    }
//    
//    
//    static func validate(providerData: ProviderRegisterModel?) throws -> ProviderRegisterModel {
//        guard let providerData = providerData else {
//            throw GerenralValidationError.emptyStoreName
//        }
//        
//        // Validate image data
//        guard let imageData = providerData.imageData, !imageData.isEmpty else {
//            throw GerenralValidationError.emptyStoreImageData
//        }
//        
//        // Validate store name
//        guard let storeName = providerData.storeName, !storeName.trimWhiteSpace().isEmpty else {
//            throw GerenralValidationError.emptyStoreName
//        }
//        
//        guard storeName.count > 1 else {
//            throw GerenralValidationError.shortName
//        }
//        
//        // Validate store description
//        guard let storeDescription = providerData.storeDescription, !storeDescription.trimWhiteSpace().isEmpty else {
//            throw GerenralValidationError.emptyStoreDescription
//        }
//        
//        guard let city = providerData.city, city.id != nil else {
//            throw GerenralValidationError.emptyCityId
//        }
//        
//        guard let address = providerData.mapDesc, providerData.latitude != nil, providerData.longitude != nil else {
//            throw GerenralValidationError.emptyAddress
//        }
//    
//        // Validate commercial register
//        guard let commercialRegister = providerData.commercialRegister, !commercialRegister.trimWhiteSpace().isEmpty else {
//            throw GerenralValidationError.emptyCommercialRegister
//        }
//        
//        // Validate national ID
//        guard let nationalID = providerData.identityNum, !nationalID.trimWhiteSpace().isEmpty else {
//            throw GerenralValidationError.emptyNationalID
//        }
//        
//        // Validate bank name
//        guard let bankName = providerData.bankName, !bankName.trimWhiteSpace().isEmpty else {
//            throw GerenralValidationError.bankName
//        }
//        
//        // Validate account number
//        guard let accountNumber = providerData.accountNumber, !accountNumber.trimWhiteSpace().isEmpty else {
//            throw GerenralValidationError.bankAccountNumber
//        }
//        
//        guard accountNumber.count >= 16 else {
//            throw GerenralValidationError.shortBankAccountNumber
//        }
//        
//        // Validate email
//        guard let email = providerData.email, !email.trimWhiteSpace().isEmpty else {
//            throw GerenralValidationError.emptyMail
//        }
//        
//        guard email.isValidEmail() else {
//            throw GerenralValidationError.wrongMail
//        }
//     
//        return providerData
//    }
//    
//    
//    
//    
//    static func validate(updateData: User?) throws -> User {
//        guard let userData = updateData else {
//            throw GerenralValidationError.emptyName
//        }
//        
//        guard let name = userData.name, !name.trimWhiteSpace().isEmpty else {
//            throw GerenralValidationError.emptyName
//        }
//        
//        guard name.count > 1 else {
//            throw GerenralValidationError.shortName
//        }
//        guard name.count < 61 else {
//            throw GerenralValidationError.longName
//        }
//        
//        
//        guard let phone = userData.phone, !phone.trimWhiteSpace().isEmpty else {
//            throw GerenralValidationError.emptyPhone
//        }
//        
//        guard let email = userData.email, !email.trimWhiteSpace().isEmpty else {
//            throw GerenralValidationError.emptyMail
//        }
//        
//        guard email.isValidEmail() else{
//            throw GerenralValidationError.wrongMail
//        }
//        
//        //        guard phone.isValidPhoneNumber(pattern: #"^(009665|9665|\+9665|05|5)(5|0|3|6|4|9|1|8|7)([0-9]{7})$"#) else {
//        //            throw PhoneValidationErrors.inValidPhone
//        //        }
//        
//        guard let cityId = userData.city?.id else {
//            throw GerenralValidationError.emptyCityId
//        }
//        
//        
//        guard let bankName = userData.bankAccount?.bankName, !bankName.trimWhiteSpace().isEmpty else {
//            throw GerenralValidationError.bankName
//        }
//        
//        guard let accountNumber = userData.bankAccount?.accountNumber, !accountNumber.trimWhiteSpace().isEmpty else {
//            throw GerenralValidationError.bankAccountNumber
//        }
//        
//        guard accountNumber.count >= 16 else {
//            throw GerenralValidationError.shortBankAccountNumber
//        }
//        
//        return userData
//    }
//    
//    //MARK: - Verification code -
//    static func validate(verificationCode: String?) throws -> String {
//        guard let verificationCode = verificationCode, !verificationCode.trimWhiteSpace().isEmpty else {
//            throw GerenralValidationError.emptyVerificationCode
//        }
//        guard verificationCode.count == 4 else {
//            throw GerenralValidationError.incorrectVerificationCode
//        }
//        return verificationCode
//    }
//    
//    
//    
//    
//    //MARK: - Name
//    
//    static func validate(properties: String?) throws -> String {
//        guard let properties = properties, !properties.trimWhiteSpace().isEmpty else {
//            throw GerenralValidationError.emptyProperties
//        }
//        return properties
//    }
//    
//    
//    static func validate(price: String?) throws -> String {
//        guard let price = price, !price.trimWhiteSpace().isEmpty else {
//            throw GerenralValidationError.emptyPrice
//        }
//        return price
//    }
//    
//    
//    static func validate(packageName: String?) throws -> String {
//        guard let packageName = packageName, !packageName.trimWhiteSpace().isEmpty else {
//            throw GerenralValidationError.emptyPackageName
//        }
//        return packageName
//    }
//    
//    static func validate(subCategoryId: Int?) throws -> Int {
//        guard let subCategoryId = subCategoryId, subCategoryId != 0 else {
//            throw GerenralValidationError.emptySubCategoryId
//        }
//        return subCategoryId
//    }
//    //MARK: - Order
//    static func validate(feathers: [Int]?) throws -> [Int] {
//        guard let feathers = feathers, !feathers.isEmpty else {
//            throw GerenralValidationError.emptyFeathers
//        }
//        return feathers
//    }
//    
//    
//    static func validate(cancelReason: String?) throws -> String {
//        guard let cancelReason = cancelReason, !cancelReason.trimWhiteSpace().isEmpty else {
//            throw GerenralValidationError.emptyCancelReason
//        }
//        return cancelReason
//    }
//    
    //MARK: - Location -

  
 




struct UserAddressesModel {
    var lat: Double?
    var long: Double?
    var address: String?
    
    
}
