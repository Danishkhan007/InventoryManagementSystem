//
//  AddEquipment.swift
//  SIMS
//
//  Created by Mohd Danish Khan  on 20/04/19.
//  Copyright © 2019 Mohd Danish Khan. All rights reserved.
//

import UIKit
import Firebase

class AddEquimentViewController: UIViewController {
    
    @IBOutlet weak var equipmentIDTextField: UITextField!
    @IBOutlet weak var equipmentNameTextField: UITextField!
    
    @IBOutlet weak var equipmentMakeTextField: UITextField!
    @IBOutlet weak var equipmentModelTextField: UITextField!
    @IBOutlet weak var equipmentCategoryTextField: UITextField!
    @IBOutlet weak var equipmentLocationTextField: UITextField!
    @IBOutlet weak var dateCheckedTextField: UITextField!
    @IBOutlet weak var equipmentConditionTextField: UITextField!
    @IBOutlet weak var commentsTextField: UITextField!
    
    @IBOutlet weak var addEqScrollView: UIScrollView!
    @IBOutlet weak var conditionPicker: UIPickerView!
    
    var pickerData: [String] = [String]()

    var activeTextField: UITextField?
    //defining firebase reference var
    var refSIMSDatabase: DatabaseReference!
    override func viewDidLoad() {
        super.viewDidLoad()
        activeTextField = self.equipmentConditionTextField
        refSIMSDatabase = Database.database().reference().child("sims");
        
        pickerData = ["New", "Good", "Average", "Bad", "Not Working"]
        
        self.conditionPicker.isHidden = true
        self.equipmentConditionTextField.inputView = self.conditionPicker
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

    @IBAction func UploadImage(_ sender: UIButton) {
        let uploadVC = self.storyboard?.instantiateViewController(withIdentifier: "UploadImageViewController") as! UploadImageViewController
        self.navigationController?.pushViewController(uploadVC, animated: true)
    }
    
    @IBAction func addEquipmentButton(_ sender: UIButton) {
            //generating a new key inside artists node
            //and also getting the generated key
            let key = refSIMSDatabase.childByAutoId().key
            
            //creating artist with the given values
        if (self.validateEntries() == false) {
            self.alertUtil(title: "Attention", message: "Please enter all the fields")
            return
        }
            let equipment = [
                            "Id":key,
                            "equipmentSerialNo": equipmentIDTextField.text! as String,
                            "equipmentName": equipmentNameTextField.text! as String,
                            "equipmentMake": equipmentMakeTextField.text! as String,
                            "equipmentModel": equipmentModelTextField.text! as String,
                            "equipmentCategory": equipmentCategoryTextField.text! as String,
                            "equipmentLocation": equipmentLocationTextField.text! as String,
                            "dateChecked":dateCheckedTextField.text! as String,
                            "equipmentCondition":equipmentConditionTextField.text! as String,
                            "comments":commentsTextField.text! as String,
            ]
            
            //adding the artist inside the generated unique key
            refSIMSDatabase.child(key).setValue(equipment)
        self.alertUtil(title: "Success", message: "Equipment is successfully added in database");
    }
    
   func validateEntries() -> Bool{
        var isValid = true
    
        if (equipmentIDTextField.text == "" ||
            equipmentNameTextField.text == "" ||
            equipmentMakeTextField.text == "" ||
            equipmentModelTextField.text == "" ||
            equipmentCategoryTextField.text == "" ||
            equipmentLocationTextField.text == "" ||
            dateCheckedTextField.text == "" ||
            equipmentConditionTextField.text == "" ||
            commentsTextField.text == "") {
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

extension AddEquimentViewController: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if (textField == self.equipmentConditionTextField)
        {
            self.conditionPicker.isHidden = false
            return false
        }
        return true
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.activeTextField = textField
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case self.equipmentIDTextField:
            self.equipmentNameTextField.becomeFirstResponder()
            break
        case self.equipmentNameTextField:
            self.equipmentMakeTextField.becomeFirstResponder()
            break
        case self.equipmentMakeTextField:
            self.equipmentModelTextField.becomeFirstResponder()
            break
        case self.equipmentModelTextField:
            self.equipmentCategoryTextField.becomeFirstResponder()
            break
        case self.equipmentCategoryTextField:
            self.equipmentLocationTextField.becomeFirstResponder()
            break
        case self.equipmentLocationTextField:
            self.dateCheckedTextField.becomeFirstResponder()
            break
        default:
            textField.resignFirstResponder()
        }
        return true
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            
            let contentInsets: UIEdgeInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardSize.height, right: 0.0)
            
            addEqScrollView.contentInset = contentInsets
            addEqScrollView.scrollIndicatorInsets = contentInsets
            
            var aRect: CGRect = self.view.frame
            aRect.size.height -= keyboardSize.height
            
            if let activeField = activeTextField {
                if !aRect.contains(activeField.frame.origin) {
                    self.addEqScrollView.scrollRectToVisible(activeField.frame, animated: true)
                    
                }
            }
        }
    }
    
    
    @objc func keyboardWillHide(notification: NSNotification) {
        let contentInsets: UIEdgeInsets = .zero
        //Reset the keyboard position
        self.addEqScrollView.contentInset = contentInsets
        self.addEqScrollView.scrollIndicatorInsets = contentInsets
    }
}

extension AddEquimentViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    // Number of columns of data
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // The number of rows of data
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
     // The data to return fopr the row and component (column) that's being passed in
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.equipmentConditionTextField.text = pickerData[row]
        self.conditionPicker.isHidden = true
    }
}


