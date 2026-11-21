//
//  ImagePicker.swift
//  App
//
//  Created by MGAbouarab on 08/01/2024.
//

import UIKit

//MARK: - Image -
class ImagePicker: NSObject {
    
    private enum Keys {
        case pickImage
        case camera
        case gallery
        case cancel
        
        var value: String {
            switch self {
            case .pickImage:
                return "Pick Image".imagePickerLocalizable
            case .camera:
                return "Camera".imagePickerLocalizable
            case .gallery:
                return "Gallery".imagePickerLocalizable
            case .cancel:
                return "Cancel".imagePickerLocalizable
            }
        }
        
    }

    //MARK: - Properties -
    private var picker = UIImagePickerController()
    private lazy var alert = UIAlertController(title: Keys.pickImage.value, message: nil, preferredStyle: .actionSheet)
    private var pickImageCallback : ((_ image: UIImage, _ imageData: Data?) -> ())?
    private let allowEdit: Bool

    private var keyWindow: UIWindow? {
        UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first { $0.isKeyWindow }
    }
    
    //MARK: - Initializers -
    init(allowEdit: Bool = false) {
        self.allowEdit = allowEdit
    }
    
    //MARK: - Private Methods -
    private func setupAlert() {
        
        let cameraAction = UIAlertAction(title: Keys.camera.value, style: .default){
            UIAlertAction in
            self.openCamera()
        }
        let galleryAction = UIAlertAction(title: Keys.gallery.value, style: .default){
            UIAlertAction in
            self.openGallery()
        }
        let cancelAction = UIAlertAction(title: Keys.cancel.value, style: .cancel){
            UIAlertAction in
        }
        
        // Add the actions
        picker.delegate = self
        picker.allowsEditing = self.allowEdit
        alert.addAction(cameraAction)
        alert.addAction(galleryAction)
        alert.addAction(cancelAction)
        alert.view.tintColor = .main
    }
    private func openCamera(){
        alert.dismiss(animated: true, completion: nil)
        if(UIImagePickerController .isSourceTypeAvailable(.camera)){
            picker.sourceType = .camera
            guard let window = keyWindow else { return }
            window.topViewController()?.present(picker, animated: true, completion: nil)
        } else {
            print("this device has no camera")
        }
    }
    private func openGallery(){
        alert.dismiss(animated: true, completion: nil)
        picker.sourceType = .photoLibrary
        guard let window = keyWindow else { return }
        window.topViewController()?.present(picker, animated: true, completion: nil)
    }
    
    func pickImage(_ callback: @escaping ((_ image: UIImage, _ imageData: Data?) -> ())) {

        self.setupAlert()

        guard let window = keyWindow else { return }
        window.endEditing(true)
        pickImageCallback = callback

        alert.popoverPresentationController?.sourceView = window.topViewController()?.view
        window.topViewController()?.present(alert, animated: true, completion: nil)
    }
    
    //MARK: - Deinit -
    deinit {
        print(" is deinit, No memory leak found")
    }
    
}
extension ImagePicker: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[ allowEdit ? .editedImage : .originalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        
        var quality: CGFloat = 1
        
        #if DEBUG
        quality = 0.1
        #endif
        
        pickImageCallback?(image, image.jpegData(compressionQuality: quality))
    }
}

