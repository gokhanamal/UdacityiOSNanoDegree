//
//  ViewController.swift
//  MeMe v1
//
//  Created by Gokhan Namal on 2.04.2020.
//  Copyright © 2020 Gokhan Namal. All rights reserved.
//

import UIKit

class MemeViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var topToolbar: UIToolbar!
    @IBOutlet weak var bottomToolbar: UIToolbar!
    
    let pickerController = UIImagePickerController()
    var activeTextField: TextFieldType = .top
    
    enum TextFieldType:Int {
        case top = 0, bottom
    }
    
    struct Meme {
        let topText: String
        let bottomText: String
        let originalImage: UIImage
        let memedImage: UIImage
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        shareButton.isEnabled = false
        self.configureTextField(topTextField, text: "TOP")
        self.configureTextField(bottomTextField, text: "BOTTOM")
        setDelegates()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotification()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unSubscribeToKeyboardNotification()
    }
    
    func setDelegates() {
        pickerController.delegate = self
        topTextField.delegate = self
        bottomTextField.delegate = self
    }
    
    func configureTextField(_ textField: UITextField?, text: String) {
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.white,
            .font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            .strokeColor: UIColor.black,
            .strokeWidth: -3,
        ]
        textField?.defaultTextAttributes = attributes
        textField?.textAlignment = .center
        textField?.textColor = .white
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            imageView.image = image
        }
        self.dismiss(animated: true, completion: nil)
        shareButton.isEnabled = true
    }
    
    func subscribeToKeyboardNotification(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func unSubscribeToKeyboardNotification(){
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(_ notification: Notification ) {
        if self.activeTextField == .bottom {
            view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification ) {
        view.frame.origin.y = 0
    }
    
    func getKeyboardHeight(_ notification: Notification) -> CGFloat {
        let userInfo = notification.userInfo
        guard let keyboardSize = userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return 0 }
        return keyboardSize.cgRectValue.height
    }
    
    func save(_ meme: Meme) {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        appDelegate.memes.append(meme)
    }
    
    func share() {
        let meme = generateMeme()
        let controller = UIActivityViewController(activityItems: [meme.memedImage], applicationActivities: nil)
        controller.completionWithItemsHandler = { activity, success, items, error in
            if success {
                self.save(meme)
            }
        }
        
        self.present(controller,animated: true)
    }

    func generateMeme() -> Meme {
        let frame = self.view.frame
        
        self.topToolbar.isHidden = true
        self.bottomToolbar.isHidden = true
        
        UIGraphicsBeginImageContext(frame.size)
        view.drawHierarchy(in: frame, afterScreenUpdates: true)
        let memedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        self.topToolbar.isHidden = false
        self.bottomToolbar.isHidden = false
        
        let meme = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, originalImage: imageView.image!, memedImage: memedImage)
        return meme
    }
}

extension MemeViewController: UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.activeTextField = TextFieldType(rawValue: textField.tag)!
        switch self.activeTextField {
        case .top:
            topTextField.text = ""
        case .bottom:
            bottomTextField.text = ""
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
}

extension MemeViewController {
    @IBAction func onPressShare(_ sender: Any) {
        self.share()
    }
    
    @IBAction func pickAnImage(_ sender: Any) {
        pickImageFrom(source: .photoLibrary)
    }
    
    @IBAction func openCamera(_ sender: Any) {
        pickImageFrom(source: .camera)
    }
    
    func pickImageFrom(source: UIImagePickerController.SourceType) {
        self.view.endEditing(true)
        pickerController.sourceType = source
        self.present(pickerController, animated: true)
    }
    
    @IBAction func onPressCancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
