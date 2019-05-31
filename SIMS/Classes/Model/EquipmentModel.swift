//
//  EquipmentModel.swift
//  SIMS
//
//  Created by Mohd Danish Khan  on 20/04/19.
//  Copyright © 2019 Mohd Danish Khan. All rights reserved.
//

import Foundation
import Firebase

class EquipmentModel {
//    private var _equipmentRef: Firebase!
    
    private var _equipmentSerialNo: String!
    private var _equipmentName: String!
    private var _equipmentMake: String!
    private var _equipmentModel: String!
    private var _equipmentCategory: String!
    private var _equipmentLocation: String!
    private var _equipmentDateChecked: String!
    private var _equipmentCondition: String!
    private var _equipementComments: String!
    private var _equipmentId: String!
    
    var equipmentId: String {
        return _equipmentId
    }
    
    var equipmentSerialNo: String {
        return _equipmentSerialNo
    }
    
    var equipmentName: String {
        return _equipmentName
    }
    
    var equipmentMake: String {
        return _equipmentMake
    }
    
    var equipmentModel: String {
        return _equipmentModel
    }
    
    var equipmentCategory: String {
        return _equipmentCategory
    }
    
    var equipmentLocation: String {
        return _equipmentLocation
    }
    
    var equipmentCondition: String {
        return _equipmentCondition
    }
    
    var equipmentComments: String {
        return _equipementComments
    }
    
    var equipmentDateChecked: String {
        return _equipmentDateChecked
    }
    
    // Initialize the new Equipment
    
    init(dictionary: Dictionary<String, AnyObject>) {
                
        if let eqId = dictionary["Id"] as? String {
            self._equipmentId = eqId
        }
        
        if let eqName = dictionary["equipmentName"] as? String {
            self._equipmentName = eqName
        }
        
        if let eqMake = dictionary["equipmentMake"] as? String {
            self._equipmentMake = eqMake
        }
        
        if let eqModel = dictionary["equipmentModel"] as? String {
            self._equipmentModel = eqModel
        }
        
        if let eqCategory = dictionary["equipmentCategory"] as? String {
            self._equipmentCategory = eqCategory
        }
        
        if let eqLocation = dictionary["equipmentLocation"] as? String {
            self._equipmentLocation = eqLocation
        }
        
        if let eqSno = dictionary["equipmentSerialNo"] as? String {
            self._equipmentSerialNo = eqSno
        }
        
        if let eqDateChecked = dictionary["dateChecked"] as? String {
            self._equipmentDateChecked = eqDateChecked
        }
        
        if let eqCondition = dictionary["equipmentCondition"] as? String {
            self._equipmentCondition = eqCondition
        }
        
        if let eqComments = dictionary["comments"] as? String {
            self._equipementComments = eqComments
        }
    }
}
