//
//  RegisterViewController.swift
//  FillUP-Skeleton
//
//  Created by Kiarash Teymoury on 1/8/17.
//  Copyright © 2017 Siavash Baratchi. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn

class RegisterViewController: LoginViewController {

    //Overrideing the viewdidLoad
    override func viewDidLoad() {
        
        view.backgroundColor = darkBlue
        
        setupPageLayout()
    }
}
