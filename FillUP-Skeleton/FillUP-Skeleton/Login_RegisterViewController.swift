//
//  LoginPageViewController.swift
//  FillUP-Skeleton
//
//  Created by Kiarash Teymoury on 1/8/17.
//  Copyright © 2017 Siavash Baratchi. All rights reserved.
//

import UIKit

class Login_RegisterViewController: UIViewController {
    
    lazy var loginBtn:UIButton = {
        let button = UIButton()
            button.backgroundColor = .lightGray
            button.setTitle("Login", for: .normal)
            button.addTarget(self, action: #selector(onLoginBtn(_:)), for: .touchUpInside)
            button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    lazy var registerBtn:UIButton = {
        let button = UIButton()
            button.backgroundColor = .lightGray
            button.setTitle("Register", for: .normal)
            button.addTarget(self, action: #selector(onRegisterBtn(_:)), for: .touchUpInside)
            button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let userClass = Users()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //Hide The NavBar on Top
        self.navigationController?.isNavigationBarHidden = true
        self.view.backgroundColor = .white
        self.setupPageLayout()
        
        //Fixes the unbalance view warning
        self.perform(#selector(findTheRightView), with: nil, afterDelay: 0)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //Determines whether the user is Still loggein or not
    internal func findTheRightView() {
        
        if UserDefaults.standard.value(forKey: KEY_UID) != nil  {
            
            print("NO USER IS LOGGED IN")
            return
            
        } else {
         
            print("USER IS LOGGED IN")
            self.navigatePages(viewController: MainViewController())
        }
    }
    
    fileprivate func setupPageLayout() {
        
        //Add Register To View
        view.addSubview(registerBtn)
        
        //Register Layout Constraints
        registerBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        registerBtn.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -30).isActive = true
        registerBtn.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30).isActive = true
        
        //Add Login To View
        view.addSubview(loginBtn)
        
        loginBtn.centerXAnchor.constraint(equalTo: registerBtn.centerXAnchor).isActive = true
        loginBtn.widthAnchor.constraint(equalTo: registerBtn.widthAnchor).isActive = true
        loginBtn.bottomAnchor.constraint(equalTo: registerBtn.topAnchor, constant: -5).isActive = true
    }
    
    fileprivate func navigatePages(viewController: UIViewController) {
        
        let navigatePage = viewController
        navigationController?.present(navigatePage, animated: true, completion: nil)
    }
    
    func onLoginBtn(_ sender: UIButton) {
        
        print("Login Pressed")
        self.navigatePages(viewController: LoginViewController())
    }
    
    func onRegisterBtn(_ sender: UIButton) {
        
        print("Register Pressed")
        self.navigatePages(viewController: RegisterViewController())
    }
}
