//
//  ServerListViewController.swift
//  PhoneXpad
//
//  Created by Admin on 22/01/2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

class ServerListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var tableView: UITableView!
    
    var networkSniffer = NetworkSniffer()

    @IBAction func SearchBtnClick(_ sender: UIButton) {
        tableView.reloadData()
        Sniff()
    }
    
    func Sniff() {
        print("Start sniffing")
        networkSniffer.Sniff(port: SocketData.port!, message: SocketData.connectionMessage, pView: progressView, tView: tableView)
    }
    
    private func CheckIfServerIsOnline(server: PhoneXpadServer, cell: UITableViewCell) -> UITableViewCell {
        
        var isOnline = false
        
        if let name = networkSniffer.IsServiceOnline(ip: server.Ip!, port: Int32(SocketData.port!), message: SocketData.connectionMessage){
            isOnline =  name == server.Name
        }
        
        if isOnline {
            cell.detailTextLabel?.text = server.Ip! + " - online"
            cell.detailTextLabel?.textColor = UIColor.green
        } else {
            cell.detailTextLabel?.text = server.Ip! + " - offline"
            cell.detailTextLabel?.textColor = UIColor.red
        }
        
        return cell
    }
    
    //MARK: - tableView methods
    // number of rows in section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return SocketData.getRecentlyConnected().count
        case 1:
            return networkSniffer.sniffedServers.count
        default:
            return 0
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    // filling cell content
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        switch indexPath.section {
        case 0:
            let server = SocketData.getRecentlyConnected()[indexPath.row]
            cell.textLabel?.text = server.Name
            cell = CheckIfServerIsOnline(server: server, cell: cell)
        case 1:
            let server = networkSniffer.sniffedServers[indexPath.row]
            cell.textLabel?.text = server.Name
            cell.detailTextLabel?.text = server.Ip
        default:
            cell.textLabel?.text = "error"
        }
        return cell
    }
    
    // click on row
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var selectedServer : PhoneXpadServer? = nil
        
        switch indexPath.section {
        case 0:
            selectedServer = SocketData.getRecentlyConnected()[indexPath.row]
        case 1:
            selectedServer = networkSniffer.sniffedServers[indexPath.row]
            SocketData.appendServer(pxps: selectedServer!)
                default:
            return
        }
        
        if let pxs = selectedServer {
            SocketData.serverName = pxs.Name
            SocketData.serverIp = pxs.Ip
            networkSniffer.StopSniffing()
            performSegue(withIdentifier: "controller", sender: self)
        }
    }
    
    // section headers titles
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Recently connected"
        case 1:
            return "Local servers"
        default:
            return ""
        }
    }
    
    //MARK: - view life cycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        Sniff()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        networkSniffer.StopSniffing()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
