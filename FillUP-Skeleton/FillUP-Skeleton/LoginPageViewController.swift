//
//  LoginPageViewController.swift
//  FillUP-Skeleton
//
//  Created by Kiarash Teymoury on 1/8/17.
//  Copyright © 2017 Siavash Baratchi. All rights reserved.
//

import UIKit

class LoginPageViewController: UIViewController {

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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        view.backgroundColor = .white
        print("Login-Register")
        
        setupPageLayout()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    func onLoginBtn(_ sender: UIButton) {
        
        print("Login Pressed")
        
        let loginPage = LogInViewController()
        self.present(loginPage, animated: true, completion: nil)
    }
    
    func onRegisterBtn(_ sender: UIButton) {
        
        print("Register Pressed")
    }
}
