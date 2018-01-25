//
//  NetworkSniffer.swift
//  PhoneXpad
//
//  Created by Admin on 22/01/2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import Foundation
import PlainPing
import SwiftSocket
import UIKit

/**
 Allow searching local network for specified services.
 */
public class NetworkSniffer {
    
    //MARK: - public vars
    /** Array of servers that weare found during sniffing process */
    public var sniffedServers = [PhoneXpadServer]() {didSet {
        self.tableView?.reloadData()
        }}    // list of ips that have online server
    
    //MARK: - private vars
    private var reachableAdresses = [String]()   // list of reachable addresses
    private var adressList = [String]()         // list os ips that will be checked if reachable
    private let timeout = 0.05                // how long to wait for resopnse
    private var progressView: UIProgressView? = nil
    private var tableView : UITableView? = nil
    private var timer = Timer()
    
    //MARK: - public methods
    /**
     Sinffing loacl network for servers on specified port. Server have to respond to specified message
     
     - parameters:
     - message: Message that server have to respond to
     - port: Port on which is server listening
     - pView: UIProgressView that will show current process status
     - tView: UITableView that will be updated when new server is found
     */
    public func Sniff (port: Int, message: String, pView: UIProgressView? = nil, tView: UITableView? = nil){
        progressView = pView
        tableView = tView
        if let pv = progressView { pv.progress = 0 }
        
        GenerateAdresses(base: IpManager.GetBaseIp())
        ClearResultsArrays()
        StartSniffingProcess(port: port, message: message)
    }
    
    public func StopSniffing(){
        timer.invalidate()
    }
    
    //MARK: - private support functios
    
    private func ClearResultsArrays(){
        reachableAdresses.removeAll()
        sniffedServers.removeAll()
    }
    /** Generate 254 adresses adding endings to base IP adress */
    private    func GenerateAdresses(base: String){
        adressList.removeAll()
        for index in 1...254 {
            adressList.append(base + String(index))
        }
    }
    
    //MARK: - private sniffing functions
    
    /** Start sniffing process checkig mutiple adresses witch time interval */
    private  func StartSniffingProcess(port: Int, message: String){
        let step = 1.0 / Float(adressList.count)
        timer.invalidate()
        print("start sniffing")
        timer  = Timer.scheduledTimer(withTimeInterval: timeout, repeats: true) { [weak self] _ in
            guard self!.adressList.count > 0 else {
                self?.timer.invalidate()
                self?.tableView?.reloadData()
                print("end sniffing")
                return
            }
            let ip = self?.adressList.removeFirst()
            
            self?.progressView?.progress += step
            self?.CheckAdressReachability(ip: ip!, port: port, message: message)
        }
    }
    
    /** Check if adress is reachable in network */
    private func CheckAdressReachability(ip: String, port: Int, message: String) {
        PlainPing.ping(ip, withTimeout: timeout, completionBlock: { (timeElapsed:Double?, error:Error?) in
            
            if let latency = timeElapsed {
                print("\(ip) is reachable. response time: \(latency)")
                self.reachableAdresses.append(ip)
                if let response = self.IsServiceOnline(ip: ip, port: Int32(port), message: message){
                    self.sniffedServers.append(PhoneXpadServer(name: response, ip : ip ))
                }
            }
        })
    }
    
    /** chceck if service is online on specified port */
    public func IsServiceOnline(ip: String, port : Int32, message: String, timeout: Int = 1) -> String? {
        let client = TCPClient(address: ip, port: port)
        
        switch client.connect(timeout: timeout) {
        case .success:
            switch client.send(string: message) {
            case .success:
                guard let data = client.read(128, timeout: timeout) else { return nil }
                if let response = String(bytes: data, encoding: .utf8) {
                    print("response: " + response)
                    return response
                }
            case .failure(let error):
                print(error)
            }
        case .failure(let error):
            print(error)
        }
        
        client.close()
        return nil
    }
    
    
    
}
