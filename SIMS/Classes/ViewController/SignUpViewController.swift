//
//  SignUpViewController.swift
//  SIMS
//
//  Created by Mohd Danish Khan  on 20/04/19.
//  Copyright © 2019 Mohd Danish Khan. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class SignUpViewController: UIViewController {
    
    @IBOutlet var emailTextField: UITextField!
    
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var confrimPasswordTextField: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var signUpScrollView: UIScrollView!
    
    @IBOutlet weak var signUpView: UIView!
    
    var activeTextField: UITextField?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.activityIndicator.isHidden = true
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
    
    
    private func setKeyboardHadling() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    
    
    @IBAction func onSignUpClicked(sender: UIButton) {
        self.activityIndicator.isHidden = false
        self.activityIndicator.startAnimating()
        if (validateFields() == false) {
            self.stopActivityIndicator()
            return
        }
        Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
            
            if error == nil {
                print("You have successfully signed up")
                
                let alertController = UIAlertController(title: "Successful", message:
                    "You have successfully Signed Up. Please Login To Continue", preferredStyle: .alert)
                
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: {action in self.navigateToLogin()})
                alertController.addAction(defaultAction)
                
                self.present(alertController, animated: true, completion: nil)

                
            } else {
                let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(defaultAction)
                
                self.present(alertController, animated: true, completion: nil)
            }
            self.stopActivityIndicator()
        }
    }
    
    func stopActivityIndicator() {
        self.activityIndicator.stopAnimating()
        self.activityIndicator.isHidden = true
    }
    
    func navigateToLogin() {
        self.performSegue(withIdentifier: "unwindSegueToLogin", sender: self)
    }
    
    // Validation method
    func validateFields() -> Bool {
        var isValid: Bool = true
        if (self.emailTextField.text == "" || self.passwordTextField.text == "" || self.confrimPasswordTextField.text == "") {
            self.alertUtil(title: "Alert", message: "Please enter all details");
            isValid = false
        } else if (self.passwordTextField.text != self.confrimPasswordTextField.text) {
            self.alertUtil(title: "Alert", message: "Confirm/Password mismatch");
            isValid = false
        }
        return isValid
    }
    
    // Helper method
    func alertUtil(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
}

extension SignUpViewController: UITextFieldDelegate {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.activeTextField = textField
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case self.emailTextField:
            self.passwordTextField.becomeFirstResponder()
            break
        case self.passwordTextField:
            self.confrimPasswordTextField.becomeFirstResponder()
            break
        default:
            textField.resignFirstResponder()
        }
        return true
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            
            let contentInsets: UIEdgeInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardSize.height, right: 0.0)
            
            signUpScrollView.contentInset = contentInsets
            signUpScrollView.scrollIndicatorInsets = contentInsets
            
            var aRect: CGRect = self.view.frame
            aRect.size.height -= keyboardSize.height
            
            if let activeField = activeTextField {
                if !aRect.contains(activeField.frame.origin) {
                    self.signUpScrollView.scrollRectToVisible(activeField.frame, animated: true)
                    
                }
            }
        }
    }
    
    
    @objc func keyboardWillHide(notification: NSNotification) {
        let contentInsets: UIEdgeInsets = .zero
        //Reset the keyboard position
        self.signUpScrollView.contentInset = contentInsets
        self.signUpScrollView.scrollIndicatorInsets = contentInsets
    }
}
