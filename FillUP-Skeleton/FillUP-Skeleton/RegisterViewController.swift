//
//  RegisterViewController.swift
//  FillUP-Skeleton
//
//  Created by Kiarash Teymoury on 1/8/17.
//  Copyright © 2017 Siavash Baratchi. All rights reserved.
//

import UIKit

class RegisterViewController: LoginViewController {

    //Overrideing the viewdidLoad
    override func viewDidLoad() {
        
        view.backgroundColor = .white
        
        //Set Google Button for the login Page
        googleLogin_Register.setTitle("Register With Google", for: .normal)
        
        setupPageLayout()
    }
    
    //Overriding the button functionality
    override func onGoogleLogin_Register(_ sender: UIButton) {
        
        print("Signed Up With GOOGLE")
        
        let mainPage = MainViewController()
        self.present(mainPage, animated: true, completion: nil)
    }
}
