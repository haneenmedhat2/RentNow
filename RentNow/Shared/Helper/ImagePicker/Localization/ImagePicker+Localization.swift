//
//  ImagePicker+Localization.swift
//  App
//
//  Created by MGAbouarab on 08/01/2024.
//

import Foundation

extension String {
    var imagePickerLocalizable: String {
        return NSLocalizedString(self, tableName: "ImagePickerLocalizable", bundle: Bundle.main, value: "", comment: "")
    }
}
