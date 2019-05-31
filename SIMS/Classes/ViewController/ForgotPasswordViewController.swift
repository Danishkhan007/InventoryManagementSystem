//
//  ForgotPasswordViewController.swift
//  SIMS
//
//  Created by Mohd Danish Khan  on 20/04/19.
//  Copyright © 2019 Mohd Danish Khan. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class ForgotPasswordViewController: UIViewController {
    
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.activityIndicator.isHidden = true
    }
    
    @IBAction func onResetPasswordClicked(_ sender: UIButton) {
        self.activityIndicator.isHidden = false
        self.activityIndicator.startAnimating()
        if (self.validateFields()) {
            Auth.auth().sendPasswordReset(withEmail: self.emailTextField.text!) { error in
                if (error == nil) {
                    
                    let alertController = UIAlertController(title: "Password Reset", message:
                        "Link has been sent to your mail. Please use the link to reset password", preferredStyle: .alert)
                    
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: {action in self.navigateToLogin()})
                    alertController.addAction(defaultAction)
                    
                    self.present(alertController, animated: true, completion: nil)
                    
                } else {
                    self.alertUtil(title: "Error", message: "Invalid Email")
                }
                self.activityIndicator.stopAnimating()
                self.activityIndicator.isHidden = true

            }
        }
        
    }
    
    func navigateToLogin() {
        self.performSegue(withIdentifier: "unwindSegueToLogin", sender: self)
    }
    
    func validateFields() -> Bool {
        var isValid: Bool = true
        if (self.emailTextField.text == "" ) {
            isValid = false;
        }
        return isValid
    }
    
    func alertUtil(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    
    
}
