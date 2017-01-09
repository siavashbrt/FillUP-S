//
//  ViewController.swift
//  FillUP-Skeleton
//
//  Created by Siavash Baratchi on 1/8/17.
//  Copyright © 2017 Siavash Baratchi. All rights reserved.
//

import UIKit

class RootViewController: UIViewController {

    let userClass = Users()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        view.backgroundColor = .yellow
        
        //For UnbalancedView
        perform(#selector(findTheRightView), with: nil, afterDelay: 0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func findTheRightView() {
        
        let isLoggedIn = userClass.isLoggedIn
        let logInPage = LoginPageViewController()
        let mainPage = MainViewController()
        
        switch  isLoggedIn {
        case true:
            self.navigatePages(viewController: logInPage)
            break
        default:
            self.navigatePages(viewController: mainPage)
        }
    }
    
    fileprivate func navigatePages(viewController: UIViewController) {
        
        let navigatePage = viewController
        navigationController?.present(navigatePage, animated: true, completion: nil)
    }
}

