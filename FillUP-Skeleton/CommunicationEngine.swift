//
//  CommunicationEngine.swift
//  FillUP-Skeleton
//
//  Created by Siavash Baratchi on 3/6/17.
//  Copyright © 2017 Siavash Baratchi. All rights reserved.
//

import Foundation
import MessageUI

class ViewController: UIViewController, MFMessageComposeViewControllerDelegate {
    
    var phoneNumber:String = "503"
    
    
    @IBAction func sendText(sender: UIButton) {
        if (MFMessageComposeViewController.canSendText()) {
            let controller = MFMessageComposeViewController()
            controller.body = "Message Body"
            controller.recipients = [phoneNumber]
            controller.messageComposeDelegate = self
        }
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController!, didFinishWith result: MessageComposeResult) {
        //... handle sms screen actions
    }
    
}
