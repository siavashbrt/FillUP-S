//
//  Extensions.swift
//  FillUP-Skeleton
//
//  Created by Kiarash Teymoury on 1/9/17.
//  Copyright © 2017 Siavash Baratchi. All rights reserved.
//

import Foundation
import UIKit

//UseFull Extension for autolayout and constraints
extension UIView {
    
    func addConstraintsWithFormat(format:String, view:UIView...) {
        
        var viewDictionary = [String:AnyObject]()
        for(index, view) in view.enumerated() {
            
            let key = "v\(index)"
            view.translatesAutoresizingMaskIntoConstraints = false
            viewDictionary[key] = view
        }
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutFormatOptions(), metrics: nil, views: viewDictionary))
    }
}
