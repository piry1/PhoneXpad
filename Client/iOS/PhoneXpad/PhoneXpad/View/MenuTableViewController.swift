//
//  MenuTableViewController.swift
//  PhoneXpad
//
//  Created by Admin on 26/01/2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

class MenuTableViewController: UITableViewController {

    @IBOutlet weak var connectedPC: UITableViewCell!
    
    private func checkConnectedServer(){
        
        let serverName = SocketData.serverName
        let serverIp = SocketData.serverIp
        
        if serverIp != nil && serverName != nil {
            connectedPC.textLabel?.text = serverName
            connectedPC.detailTextLabel?.text = serverIp
            connectedPC.imageView?.image = UIImage(named: "pc-on")
            connectedPC.accessoryType = UITableViewCellAccessoryType.checkmark
        } else{
            connectedPC.textLabel?.text = "No connected PC"
            connectedPC.detailTextLabel?.text = "0.0.0.0"
            connectedPC.imageView?.image = UIImage(named: "pc-off")
            connectedPC.accessoryType = UITableViewCellAccessoryType.none
        }
        
    }
    
    
    //MARK: - life cycle methods
    
    override func viewWillAppear(_ animated: Bool) {
        checkConnectedServer()
        print("checking server")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    

}
