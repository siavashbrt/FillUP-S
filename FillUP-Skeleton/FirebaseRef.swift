//
//  FirebaseRef.swift
//  FillUP-Skeleton
//
//  Created by Kiarash Teymoury on 1/11/17.
//  Copyright © 2017 Siavash Baratchi. All rights reserved.
//

import UIKit
import FirebaseDatabase

//Our Firebase URL
let URL_Base = FIRDatabase.database().reference()

class FirebaseRef {
    
    static let dataBase = FirebaseRef()
    
    //For the users
    private var _REF_USERS = URL_Base.child("users")
    
    
    var REF_USERS:FIRDatabaseReference {
        return _REF_USERS
    }
    
    var currentUser:FIRDatabaseReference {
        get {
            
            //Get currentUser UID
            let uid = UserDefaults.standard.value(forKey: KEY_UID) as! String
            let user = FirebaseRef.dataBase.REF_USERS.child(uid)
            
            return user
        }
    }
    
    func createFirebaseUser(_ uid:String, user: Dictionary<String,AnyObject>) {
        
        //Create the user
        REF_USERS.child("\(uid)/user").setValue(user)
        
        //Save Key For LoggedIn and Save it in memory
        UserDefaults.standard.set(uid, forKey: KEY_UID)
    }
}
