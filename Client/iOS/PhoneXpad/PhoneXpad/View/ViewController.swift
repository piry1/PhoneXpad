//
//  ViewController.swift
//  PhoneXpad
//
//  Created by Admin on 20/01/2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit
import CoreMotion
import SwiftSocket

class ViewController: UIViewController {
    
    var motionManager = CMMotionManager()
    var padManager = PadManager()
    
    public var serverIp : String = ""
    
    @IBAction func SendData(_ sender: UIButton) {
        padManager.DisconnectPad()              
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        padManager.ConnectPad()
        padManager.StartCommunicationWithServer()
    }
    
    @IBAction func BtnUp(_ sender: UIButton) {
        let btn = sender as UIButton
        //print("button up: " + btn.titleLabel!.text!)
        padManager.SetBoolBtns(btnName: btn.titleLabel!.text!, isPressed: false)
    }
    
    @IBAction func BtnDown(_ sender: UIButton) {
        let btn = sender as UIButton
        //print("button down: " + btn.titleLabel!.text!)
        padManager.SetBoolBtns(btnName: btn.titleLabel!.text!, isPressed: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //StartMotionMonitor()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }

}

