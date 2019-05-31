//
//  InventoryViewController.swift
//  SIMS
//
//  Created by Mohd Danish Khan  on 20/04/19.
//  Copyright © 2019 Mohd Danish Khan. All rights reserved.
//

import UIKit
import PDFKit

class InventoryViewController: UIViewController {
    
    @IBOutlet weak var inventoryList: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    //list to store all the equipment
    @IBOutlet weak var searchBarHeight: NSLayoutConstraint!
    @IBOutlet weak var navigationDwnldBtn: UIBarButtonItem!
    
    @IBOutlet weak var inventoryNavigationItem: UINavigationItem!
    
    var inventoryData: [EquipmentModel] = []
    var isSearchBarReq: Bool = true
    var searchActive : Bool = false
    var filtered:[EquipmentModel] = []
    var selectedEquipment: EquipmentModel?
    var pdfFilePath: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
       self.inventoryList.delegate = self
        if (self.isSearchBarReq) {
           self.setUpdateUISettings()
        } else {
           self.setViewOnlyUISettings()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        inventoryData = DataManager.dataManagerInstance.equipmentList
        self.inventoryList.reloadData()
    }
    
    //Set UI settings for View permission
    func setViewOnlyUISettings() {
        //disable the table cell selection when its view only
        self.inventoryList.allowsSelection = false
        //Hide the search bar, set height to 0
        self.searchBarHeight.constant = CGFloat(0)
    }
    
    //Set UI settings for Update permission
    func setUpdateUISettings() {
        
        //Set color of searchbar and table
        self.searchBar.barTintColor = UIColor.init(red: 120/255, green: 189/255, blue: 253/255, alpha: 1)
        self.inventoryList.backgroundColor = UIColor.init(red: 204/255, green: 226/255, blue: 246/255, alpha: 1)
        
        
        self.inventoryNavigationItem.rightBarButtonItem = nil
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onGeneratePDFClicked(_ sender: Any) {
        
        pdfFilePath = self.inventoryList.exportAsPdfFromTable()
        self.performSegue(withIdentifier: "viewPDFSegue", sender: self)
    }
}

//MARK:- UITableViewDelegate methods
extension InventoryViewController: UITableViewDelegate{
    //TODO:-
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         selectedEquipment = searchActive ? filtered[indexPath.row] : inventoryData[indexPath.row]
        self.performSegue(withIdentifier: "updateSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "updateSegue") {
            let updateInventoryVC = segue.destination as! UpdateEquipmentViewController
            updateInventoryVC.equipment = selectedEquipment
        }
        else if (segue.identifier == "viewPDFSegue") {
            let pdfView = segue.destination as! PdfManagerVC
            pdfView.filePath = pdfFilePath
        }
    }
}

//MARK:- UITableViewDataSource methods
extension InventoryViewController: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return (isSearchBarReq) ? "SIMS: Filtered Inventory By Serial Number" : "SIMS: Inventory Data List"
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return (isSearchBarReq) ? "SIMS: Filtered Inventory List" : "SIMS: Copyright © 2019 SIMS Inc. All rights are reserved. This document can be used for sales and monitoring purpose by SIMS employess"
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(searchActive) {
            return filtered.count
        }
        return inventoryData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // the equipment model
        let equipment: EquipmentModel
        equipment = searchActive ?  filtered[indexPath.row] : inventoryData[indexPath.row]  
        
        
        if (isSearchBarReq){
           let cell =
            tableView.dequeueReusableCell(withIdentifier: "inventoryCell" , for: indexPath) as! EquipementCell
            return setupSearchInvCell(equipment, cell: cell)
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "viewInvetoryCell", for: indexPath) as! ViewInventoryCell
            return setupViewInvCell(equipment, cell: cell)
        }
        
    }
    
    
    func setupSearchInvCell(_ equipment: EquipmentModel, cell: EquipementCell) -> UITableViewCell {
      
        
        //addind values to labels
        cell.equipmentName.text = equipment.equipmentName
        cell.equipmentMake.text = equipment.equipmentMake
        cell.equipmentModel.text = equipment.equipmentModel
        cell.equipmentCondition.text = equipment.equipmentCondition
        cell.equipmentId.text = equipment.equipmentSerialNo
        
        return cell
    }
    
    func setupViewInvCell(_ equipment: EquipmentModel, cell: ViewInventoryCell) -> UITableViewCell {
        
        let equipmentDetail = "SERIAL NO.: \(equipment.equipmentSerialNo), NAME: \(equipment.equipmentName), MAKE: \(equipment.equipmentMake), MODEL: \(equipment.equipmentModel), CATEGORY: \(equipment.equipmentCategory), LOCATION: \(equipment.equipmentLocation), DATECHECKED: \(equipment.equipmentDateChecked), CONDITION: \(equipment.equipmentCondition), COMMENTS: \(equipment.equipmentComments)"
        //addind values to labels
       cell.inventoryLbl.text = equipmentDetail
        
        return cell
    }
    
}

extension InventoryViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = true;
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        filtered = inventoryData.filter({ (equipment) -> Bool in
            let tmp: NSString = equipment.equipmentSerialNo as NSString
            
            let range = tmp.range(of: searchText, options: NSString.CompareOptions.caseInsensitive)
            return range.location != NSNotFound
        })
        if(filtered.count == 0){
            searchActive = false;
        } else {
            searchActive = true;
        }
        self.inventoryList.reloadData()
    }
}



