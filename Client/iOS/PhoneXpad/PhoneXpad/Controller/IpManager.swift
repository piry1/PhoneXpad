//
//  IpManager.swift
//  PhoneXpad
//
//  Created by Admin on 22/01/2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import Foundation
/**
 Allow to check current device IP
 */
public class IpManager{
    //MARK: - public
    /**
     Get phone IP adress without last part
     - returns:
     Device IP without last part for example 192.168.1. instead of 192.168.1.5
     */
    public static func GetBaseIp() -> String {
        var ip = GetIP()
        var i = 0
        
        for char in ip.reversed() {
            if char != "." {
                i += 1
            }else{
                break
            }
            print("last to remove: \(i)")
        }
        ip.removeLast(i)
        return ip
    }
    
    /**
     Check phone IP adress
     - returns:
     Phone WiFi IP or 172.20.10.1
     */
    public static func GetIP() -> String {
        if let ip = getWiFiAddress(){
            return ip
        }
        else {
            return "172.20.10.1"
        }
    }
    
    //MARK: - private
    // Return IP address of WiFi interface (en0) as a String, or `nil`
    private static func getWiFiAddress() -> String? {
        var address : String?
        
        // Get list of all interfaces on the local machine:
        var ifaddr : UnsafeMutablePointer<ifaddrs>?
        guard getifaddrs(&ifaddr) == 0 else { return nil }
        guard let firstAddr = ifaddr else { return nil }
        
        // For each interface ...
        for ifptr in sequence(first: firstAddr, next: { $0.pointee.ifa_next }) {
            let interface = ifptr.pointee
            
            // Check for IPv4 or IPv6 interface:
            let addrFamily = interface.ifa_addr.pointee.sa_family
            if addrFamily == UInt8(AF_INET) || addrFamily == UInt8(AF_INET6) {
                
                // Check interface name:
                let name = String(cString: interface.ifa_name)
                if  name == "en0" {
                    
                    // Convert interface address to a human readable string:
                    var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                    getnameinfo(interface.ifa_addr, socklen_t(interface.ifa_addr.pointee.sa_len),
                                &hostname, socklen_t(hostname.count),
                                nil, socklen_t(0), NI_NUMERICHOST)
                    address = String(cString: hostname)
                }
            }
        }
        freeifaddrs(ifaddr)
        
        return address
    }
    
}
