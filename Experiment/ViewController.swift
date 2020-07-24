//
//  ViewController.swift
//  Experiment
//
//  Created by tardigrade on 19/07/20.
//  Copyright © 2020 tardigrade. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    @IBOutlet weak var imagePicker: UIImageView!
    @IBOutlet weak var galleryBtn: UIBarButtonItem!
    @IBOutlet weak var cameraBtn: UIBarButtonItem!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var shareBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    
    let memeTextAttributes: [NSAttributedString.Key: Any] = [
        NSAttributedString.Key.strokeColor: UIColor.black,
        NSAttributedString.Key.foregroundColor: UIColor.white,
        NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSAttributedString.Key.strokeWidth: 2
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Default Text
        topTextField.text = "TOP"
        bottomTextField.text = "BOTTOM"
        // Center Text
        topTextField.textAlignment = .center
        bottomTextField.textAlignment = .center
        // Default Text Attributes
        topTextField.defaultTextAttributes = memeTextAttributes
        bottomTextField.defaultTextAttributes = memeTextAttributes
        // Set Delegates
        topTextField.delegate = self
        bottomTextField.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Disable camera if it's not available
        cameraBtn.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        
        // Disable Share Button until meme is completed
        shareBtn.isEnabled = false
        
        // Subscribe to Keyboard Notifications
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        unsubscribeFromKeyboardNotifications()
    }

    @IBAction func pickAnImageFromGallery(_ sender: UIBarButtonItem) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = .photoLibrary
        // Enable Share Btn
        shareBtn.isEnabled = true
        present(pickerController, animated: true, completion: nil)
    }
       
    @IBAction func pickAnImageFromCamera(_ sender: UIBarButtonItem) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = .camera
        // Enable Share Btn
        shareBtn.isEnabled = true
        present(pickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            imagePicker.image = image
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.text == "TOP" || textField.text == "BOTTOM" {
            textField.text = ""
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification ,object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        view.frame.origin.y -= getKeyboardHeight(notification)
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        view.frame.origin.y = 0
    }
    
    func getKeyboardHeight(_ notification: Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    
    @IBAction func shareButtonPressed(_ sender: UIButton) {
        print("SHARE_BTN_PRESSED")
        
        // Generate Memed image
        let memedImage = generateMemedImage()
        // let myText = "Test Text"

        let shareController: UIActivityViewController = UIActivityViewController(activityItems: [(memedImage)], applicationActivities: nil)
        
        shareController.completionWithItemsHandler = {(activityType: UIActivity.ActivityType?, completed: Bool, returnedItems: [Any]?, error: Error?) in
            if !completed {
                // User canceled
                return
            }
            // User completed activity
            self.save()
        }
        
        self.present(shareController, animated: true, completion: nil)
    }
    
    func save() {
        print("SAVE_MEMED_IMAGE")
        let meme = Meme(topText: topTextField.text!, bottomText: topTextField.text!, originalImage: imagePicker.image!, memedImage: generateMemedImage())
    }
    
    func generateMemedImage() -> UIImage {
        // Hide toolbar and navbar
        // self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        // Show toolbar and navbar
        // self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        return memedImage
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        print("CANCEL_BTN_PRESSED")
        // Reset textFields and imagePicker
        topTextField.text = "TOP"
        bottomTextField.text = "BOTTOM"
        imagePicker.image = nil
    }
    
}

