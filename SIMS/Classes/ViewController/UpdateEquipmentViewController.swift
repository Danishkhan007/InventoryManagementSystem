//
//  UpdateEquipmentViewController.swift
//  SIMS
//
//  Created by Mohd Danish Khan  on 20/04/19.
//  Copyright © 2019 Mohd Danish Khan. All rights reserved.
//

import UIKit
import Firebase

class UpdateEquipmentViewController: UIViewController {
    
    @IBOutlet weak var equipmentIDTextField: UITextField!
    @IBOutlet weak var equipmentNameTextField: UITextField!
    
    @IBOutlet weak var equipmentMakeTextField: UITextField!
    @IBOutlet weak var equipmentModelTextField: UITextField!
    @IBOutlet weak var equipmentCategoryTextField: UITextField!
    @IBOutlet weak var equipmentLocationTextField: UITextField!
    @IBOutlet weak var dateCheckedTextField: UITextField!
    @IBOutlet weak var equipmentConditionTextField: UITextField!
    @IBOutlet weak var commentsTextField: UITextView!
    @IBOutlet weak var updateEqScroll: UIScrollView!
    
    @IBOutlet weak var conditionPicker: UIPickerView!
    
    var pickerData: [String] = [String]()
    var activeTextField: UITextField?
    //defining firebase reference var
    var refSIMSDatabase: DatabaseReference!
    var equipment: EquipmentModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        activeTextField = equipmentConditionTextField
        self.configUI()
        
        //Firebase Database Reference:
        refSIMSDatabase = Database.database().reference().child("sims").child(equipment!.equipmentId)
        
        pickerData = ["New", "Good", "Average", "Bad", "Not Working"]

        self.conditionPicker.isHidden = true
        self.equipmentConditionTextField.inputView = self.conditionPicker
    }
    
    // Configure the UI with seleted Equipment to update.
    func configUI() {
        equipmentIDTextField.text = equipment!.equipmentSerialNo
        equipmentNameTextField.text = equipment!.equipmentName
        equipmentMakeTextField.text = equipment!.equipmentMake
        equipmentCategoryTextField.text = equipment!.equipmentCategory
        equipmentModelTextField.text = equipment!.equipmentModel
        equipmentLocationTextField.text = equipment!.equipmentLocation
        dateCheckedTextField.text = equipment!.equipmentDateChecked
        equipmentConditionTextField.text = equipment!.equipmentCondition
        commentsTextField.text = equipment!.equipmentComments
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
    
    
    @IBAction func updateEquipmentButton(_ sender: UIButton) {
        //generating a new key inside artists node
        
        //creating artist with the given values
        if (self.validateEntries() == false) {
            self.alertUtil(title: "Attention", message: "Please enter all the fields")
            return
        }
        let equipment = [
                         "equipmentId": equipmentIDTextField.text! as String,
                         "equipmentName": equipmentNameTextField.text! as String,
                         "equipmentMake": equipmentMakeTextField.text! as String,
                         "equipmentModel": equipmentModelTextField.text! as String,
                         "equipmentCategory": equipmentCategoryTextField.text! as String,
                         "equipmentLocation": equipmentLocationTextField.text! as String,
                         "dateChecked":dateCheckedTextField.text! as String,
                         "equipmentCondition":equipmentConditionTextField.text! as String,
                         "comments":commentsTextField.text! as String,
                         ]
        
        //updating the equipment values in inventory
        refSIMSDatabase.updateChildValues(equipment)
        self.alertUtil(title: "Success", message: "Equipment is successfully updated in database");
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

extension UpdateEquipmentViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.activeTextField = textField
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if (textField == self.equipmentConditionTextField) {
            self.conditionPicker.isHidden = false
            return false
        }
        return true
    }
    
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            
            let contentInsets: UIEdgeInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardSize.height, right: 0.0)
            
            updateEqScroll.contentInset = contentInsets
            updateEqScroll.scrollIndicatorInsets = contentInsets
            
            var aRect: CGRect = self.view.frame
            aRect.size.height -= keyboardSize.height
            
            if let activeField = activeTextField {
                if !aRect.contains(activeField.frame.origin) {
                    self.updateEqScroll.scrollRectToVisible(activeField.frame, animated: true)
                    
                }
            }
        }
    }
    
    
    @objc func keyboardWillHide(notification: NSNotification) {
        let contentInsets: UIEdgeInsets = .zero
        //Reset the keyboard position
        self.updateEqScroll.contentInset = contentInsets
        self.updateEqScroll.scrollIndicatorInsets = contentInsets
    }

}

extension UpdateEquipmentViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
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





