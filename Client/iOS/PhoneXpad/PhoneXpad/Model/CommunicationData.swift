//
//  CommunicationData.swift
//  PhoneXpad
//
//  Created by Admin on 22/01/2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import Foundation

/**
 Data used in communication with PC server
 */
public class SocketData {
    /** Server IP adress */
    public static var serverIp : String? = nil
    /** Service port */
    public static var port: Int? = 1234
    /** Service name */
    public static var serverName : String? = nil
    /** Message required to start communication */
    public static let connectionMessage = "ppm"
    
    private static var recentlyConnected: [PhoneXpadServer]? = nil
    
    private static func loadRecentlyConnected(){
        
        if let data = UserDefaults.standard.object(forKey: "recentlyConnected") as! Data? {
            recentlyConnected = NSKeyedUnarchiver.unarchiveObject(with:  data) as? [PhoneXpadServer]
        } else {
            recentlyConnected = [PhoneXpadServer]()
            saveRecentlyConnected()
        }
    }
    
    public static func getRecentlyConnected() -> [PhoneXpadServer] {
        
        if recentlyConnected == nil {
            loadRecentlyConnected()
        }
        return recentlyConnected!
    }
    
    public static func appendServer(pxps: PhoneXpadServer) {
        
        if recentlyConnected == nil {
            loadRecentlyConnected()
        }
        
        guard !(recentlyConnected?.contains(pxps))! else { return }
        recentlyConnected!.append(pxps)
        saveRecentlyConnected()
    }

    public static func removeAt(index: Int){
        recentlyConnected?.remove(at: index)
        saveRecentlyConnected()
    }
    
    private static func saveRecentlyConnected(){
        let encodedData = NSKeyedArchiver.archivedData(withRootObject: recentlyConnected!)
        UserDefaults.standard.set(encodedData, forKey: "recentlyConnected")
    }
}
