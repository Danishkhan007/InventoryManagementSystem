//
//  UploadImageViewController.swift
//  SIMS
//
//  Created by Nikita More on 24/4/19.
//  Copyright © 2019 Mohd Danish Khan. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseCore

class UploadImageViewController: UIViewController, UITextFieldDelegate{
    
    
    @IBOutlet weak var imageUploadScrollView: UIScrollView!
    @IBOutlet weak var imageTitleTextField: UITextField!
    @IBOutlet weak var myImageView: UIImageView!
    @IBOutlet weak var txtText: UITextField!
    

    //------- Life cycle methods ----------//
    override func viewDidLoad() {
        super.viewDidLoad()
        self.ref = Database.database().reference()
        let tapGesture = UITapGestureRecognizer()
        tapGesture.addTarget(self, action: #selector(openGallery(tapGesture:)))
        myImageView.isUserInteractionEnabled = true
        myImageView.addGestureRecognizer(tapGesture)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.setKeyboardHadling()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    //-----//
    
    @IBAction func cameraButtonClicked(_ sender: UIBarButtonItem) {
    }
    
    var ref = DatabaseReference.init()
    
    @IBAction func saveButtonClicked(_ sender: UIButton)
    {
        
        self.saveFIRData()
        
    }
    
    func saveFIRData(){
        
        self.uploadImage(self.myImageView.image!)
        { url in
            // Assume an empty name
            var nameText = ""
            
            if let textFieldValue = self.txtText.text {
                nameText = textFieldValue
            }
            
            self.saveImage(name: nameText, profileURL: url!){ success in
                if success != nil{
                    print("Complete success")
                }
                
                
            }
        }
    }
    
    
    @objc func openGallery( tapGesture: UITapGestureRecognizer)
    {
        self.setupImagePicker()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //handling textfield return
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

let imagePicker = UIImagePickerController()

extension UploadImageViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    
    func setupImagePicker()
    {
        if UIImagePickerController.isSourceTypeAvailable(.camera)
        {
            imagePicker.sourceType = .camera
            imagePicker.delegate = self
            imagePicker.isEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
        else{
            imagePicker.sourceType = .photoLibrary
            imagePicker.delegate = self
            imagePicker.isEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        myImageView.image = image
        self.dismiss(animated: true, completion: nil)
        
        
    }
}

extension UploadImageViewController{
    
    func uploadImage(_ image:UIImage, completion: @escaping ((_ url:URL?) -> ())){
        let storageRef = Storage.storage().reference().child("myimage.png")
        
        let imgData = myImageView.image?.pngData()
        let metaData = StorageMetadata()
        
        metaData.contentType = "image/png"
        storageRef.putData(imgData! , metadata: metaData) { (metadata, error) in
            if error == nil{
                print("success")
                storageRef.downloadURL(completion: { (url, error) in
                    completion(url)
                })
            }else {
                print("Error in saving the image")
                completion(nil)
            }
        }
    }
    
    func saveImage(name: String, profileURL: URL, completion: @escaping ((_ url:URL?) -> ())){
        
        let dict = ["name":"Item", "text": txtText.text!, "profileUrl":profileURL.absoluteString] as [String: Any]
        self.ref.child("chat").childByAutoId().setValue(dict)
        
    }
    
    
    //---------Keyboard Handling ----------------//
    private func setKeyboardHadling() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            
            let contentInsets: UIEdgeInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardSize.height, right: 0.0)
            
            imageUploadScrollView.contentInset = contentInsets
            imageUploadScrollView.scrollIndicatorInsets = contentInsets
            
            var aRect: CGRect = self.view.frame
            aRect.size.height -= keyboardSize.height
            
            if !aRect.contains(self.imageTitleTextField.frame.origin) {
                self.imageUploadScrollView.scrollRectToVisible(self.imageTitleTextField.frame, animated: true)
                
            }
        }
    }
    @IBAction func hideKeyboard(_ sender: UITapGestureRecognizer) {
        self.txtText.resignFirstResponder()
    }
    
    
    @objc func keyboardWillHide(notification: NSNotification) {
        let contentInsets: UIEdgeInsets = .zero
        //Reset the keyboard position
        self.imageUploadScrollView.contentInset = contentInsets
        self.imageUploadScrollView.scrollIndicatorInsets = contentInsets
    }

}

