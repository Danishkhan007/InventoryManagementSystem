//
//  HomeScreenViewController.swift
//  SIMS
//
//  Created by Mohd Danish Khan  on 20/04/19.
//  Copyright © 2019 Mohd Danish Khan. All rights reserved.
//

import UIKit
import Firebase

class HomeScreenViewController: UIViewController {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var searchEqButton: UIButton!
    @IBOutlet weak var viewInventoryButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.activityIndicator.startAnimating()
        //--------------Firebase Data Read Operation ------------------//
        let ref = Database.database().reference(withPath: "sims")
        ref.observe(.value, with: { snapshot in
            
             DataManager.dataManagerInstance.equipmentList = []
        
            //if the reference have some values
            if snapshot.childrenCount > 0 {
                
                //clearing the list
                DataManager.dataManagerInstance.equipmentList.removeAll()
                
                //iterating through all the values
                for equipment in snapshot.children.allObjects as! [DataSnapshot] {
                    //getting values
                    let equipmentObject = equipment.value as? [String: AnyObject]
                    
                    //creating artist object with model and fetched values
                    let equipment = EquipmentModel(dictionary: equipmentObject!)
                    
                    //appending it to list
                    DataManager.dataManagerInstance.equipmentList.append(equipment)
                }
            }
            self.activityIndicator.stopAnimating()
            self.activityIndicator.isHidden = true
        });
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "searchInvSegue" || segue.identifier == "showInvSegue") {
            if let destinationVC = segue.destination as? InventoryViewController {
                destinationVC.isSearchBarReq = (segue.identifier == "searchInvSegue")
            }
        }
    }
    
    //----------------- Controll buttons ---------------//
    
    @IBAction func logOutPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "logoutSegue", sender: self)
    }
    
    @IBAction func onSearchEqPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "searchInvSegue", sender: self)
    }
    
    @IBAction func onViewInvPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "showInvSegue", sender: self)
    }
    
    // MARK: - Navigation
    @IBAction func unwindToHomeScreen(segue: UIStoryboardSegue) {
        dismiss(animated: true, completion: nil)
    }
    
}


