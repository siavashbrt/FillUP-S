//
//  SettingsTableViewController.swift
//  FillUP-Skeleton
//
//  Created by Kiarash Teymoury on 1/16/17.
//  Copyright © 2017 Siavash Baratchi. All rights reserved.
//

import UIKit
import Firebase

class SettingsTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        handleNavBarButtons()
    }
    
    internal func handleNavBarButtons() {
        
        let logoutBtn = UIBarButtonItem(title: "LogOut", style: .plain, target: self, action: #selector(onLogout(sender:)))
        navigationItem.rightBarButtonItem = logoutBtn
    }

    internal func onLogout(sender: UIBarButtonItem) {

        do {
            
            try FIRAuth.auth()?.signOut()
            
        } catch let error {
            print(error)
        }
        
        UserDefaults.standard.setValue("", forKey: KEY_UID)
        self.dismiss(animated: false, completion: nil)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {

        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return 0
    }
}
