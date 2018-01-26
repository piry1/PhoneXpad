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
    
    var recentlyConnected = SocketData.getRecentlyConnected()
    var networkSniffer = NetworkSniffer()
    var timer = Timer()
    
    @IBAction func SearchBtnClick(_ sender: UIButton) {
        progressView.progress = 0.0
        tableView.reloadData()
        Sniff()
    }
    
    func checkRecentlyConnected(){
        
        timer.invalidate()
        var i = recentlyConnected.count - 1
        
        timer  = Timer.scheduledTimer(withTimeInterval: 0.5 , repeats: true) { [weak self] _ in
            guard i >= 0 else {
                self?.timer.invalidate()
                return
            }
            
            if let name = self?.networkSniffer.IsServiceOnline(ip: (self?.recentlyConnected[i].Ip!)!, port: Int32(SocketData.port!), message: SocketData.connectionMessage){
                self?.recentlyConnected[i].isOnline =  name == self?.recentlyConnected[i].Name
            }
            
            if (self?.recentlyConnected[i].isOnline)! {
                self?.tableView.beginUpdates()
                let ip = IndexPath(row: i,section: 0)
                self?.tableView.reloadRows(at: [ip], with: UITableViewRowAnimation.automatic)
                self?.tableView.endUpdates()
            }
      
            i -= 1
        }
    }
    
    func Sniff() {
        print("Start sniffing")
        networkSniffer.Sniff(port: SocketData.port!, message: SocketData.connectionMessage, pView: progressView, tView: tableView)
    }
    
    private func CheckIfServerIsOnline(server: PhoneXpadServer, cell: UITableViewCell) -> UITableViewCell {
        
        if server.isOnline! {
            cell.detailTextLabel?.textColor = UIColor(red:0.10, green:0.57, blue:0.48, alpha:1.0) // green
            cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
            cell.imageView?.image = UIImage(named: "pc-on")
        } else {
            cell.detailTextLabel?.textColor = UIColor.gray
            cell.accessoryType = UITableViewCellAccessoryType.none
            cell.imageView?.image = UIImage(named: "pc-off")
        }
        
        return cell
    }
    
    //MARK: - tableView methods
    // number of rows in section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return recentlyConnected.count
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
            let server = recentlyConnected[indexPath.row]
            cell.textLabel?.text = server.Name
            cell.detailTextLabel?.text = server.Ip!
            cell = CheckIfServerIsOnline(server: server, cell: cell)
        case 1:
            let server = networkSniffer.sniffedServers[indexPath.row]
            cell.textLabel?.text = server.Name
            cell.detailTextLabel?.text = server.Ip!
            cell.imageView?.image = UIImage(named: "pc-on")
            cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
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
            selectedServer = recentlyConnected[indexPath.row]
        case 1:
            selectedServer = networkSniffer.sniffedServers[indexPath.row]
            selectedServer?.isOnline = true
            SocketData.appendServer(pxps: selectedServer!)
        default:
            return
        }
        
        if let pxs = selectedServer {
            guard pxs.isOnline! else { return }
            SocketData.serverName = pxs.Name
            SocketData.serverIp = pxs.Ip
            networkSniffer.StopSniffing()
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if indexPath.section == 0{
            return true
        }
        return false
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            if indexPath.section == 0{
                SocketData.removeAt(index: indexPath.row)
                recentlyConnected = SocketData.getRecentlyConnected()
                tableView.beginUpdates()
                tableView.deleteRows(at: [indexPath], with: .automatic)
                tableView.endUpdates()
            }
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
        tableView.reloadData()
        checkRecentlyConnected()
        Sniff()
    }
    
    override func viewWillAppear(_ animated: Bool) {
          recentlyConnected = SocketData.getRecentlyConnected()
        for i in 0...recentlyConnected.count - 1 {
            recentlyConnected[i].isOnline = false
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        networkSniffer.StopSniffing()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
