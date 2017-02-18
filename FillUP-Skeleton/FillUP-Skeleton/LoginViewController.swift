//
//  LogIn-RegisterViewController.swift
//  FillUP-Skeleton
//
//  Created by Kiarash Teymoury on 1/8/17.
//  Copyright © 2017 Siavash Baratchi. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn

class LoginViewController: UIViewController, GIDSignInUIDelegate {

    lazy var googleLogin_Register:GIDSignInButton = {
        let button = GIDSignInButton()
            button.translatesAutoresizingMaskIntoConstraints = false
       return button
    }()
    
    lazy var backBtn:UIButton = {
        let button = UIButton()
            button.setImage(UIImage(named: "Back"), for: .normal)
            button.addTarget(self, action: #selector(onBackBtn(_:)), for: .touchUpInside)
            button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate = self
        
        setupPageLayout()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupPageLayout() {
        
        //Add Back Button
        view.addSubview(backBtn)
        
        //Back Button Layout Constraints
        backBtn.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -30).isActive = true
        backBtn.topAnchor.constraint(equalTo: view.topAnchor, constant: 30).isActive = true
        
        //Add Google Button To the page
        view.addSubview(googleLogin_Register)
        
        //Layout Constraints
        googleLogin_Register.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        googleLogin_Register.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -30).isActive = true
        googleLogin_Register.topAnchor.constraint(equalTo: backBtn.bottomAnchor, constant: 50).isActive = true
    }
    
    func onBackBtn(_ sender: UIButton) {
        
        self.dismiss(animated: true, completion: nil)
    }
}

//MARK - Extension LoginIn to Google
extension LoginViewController: GIDSignInDelegate {
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        
        if let err = error {
            print("Failed Sigining into Google", err)
            return
        }
        
        guard let idToken = user.authentication.idToken else {return}
        guard let accessToken = user.authentication.accessToken else {return}
        let credentials = FIRGoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken)
        
        FIRAuth.auth()?.signIn(with: credentials, completion: { (user, error) in
            
            if let err = error {
                print("Failed To Create Firebase User", err)
                return
            }
            
            guard let userUID = user?.uid, let name = user?.displayName, let email = user?.email else {return}
            
            let userDetailsDic = ["Name":name,"Email":email]
            
            FirebaseRef.dataBase.createFirebaseUser(userUID, user: userDetailsDic as Dictionary<String, AnyObject>)
            print("Successfully Created Firebase User", userUID)
        })
        
        print("Successfully Loged In to google")
        let mainPage = MainViewController()
        self.present(mainPage, animated: true, completion: nil)
    }
}
