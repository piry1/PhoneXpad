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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return networkSniffer.sniffedServers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let server = networkSniffer.sniffedServers[indexPath.row]
        cell.textLabel?.text = server.Name
        cell.detailTextLabel?.text = server.Ip
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedServer = networkSniffer.sniffedServers[indexPath.row]
        CommunicationData.serverName = selectedServer.Name
        CommunicationData.serverIp = selectedServer.Ip
        networkSniffer.StopSniffing()
        performSegue(withIdentifier: "controller", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("server list appear")
        Sniff()
    }

    func Sniff() {
         print("Start sniffing")
         networkSniffer.Sniff(port: 1234, message: "ppm", pView: progressView, tView: tableView)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
