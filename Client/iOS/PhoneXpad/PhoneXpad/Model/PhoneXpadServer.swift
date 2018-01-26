//
//  PhoneXpadServer.swift
//  PhoneXpad
//
//  Created by Admin on 22/01/2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import Foundation

public class PhoneXpadServer : NSObject, NSCoding {
    public var Name : String? = nil
    public var Ip : String? = nil
    public var isOnline : Bool? = nil
    
    init(name: String, ip: String, isOnline: Bool = false) {
        self.Name = name
        self.Ip = ip
        self.isOnline = isOnline
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(self.Name, forKey: "name")
        aCoder.encode(self.Ip, forKey: "ip")
    }
    
    public required convenience init?(coder aDecoder: NSCoder) {
        guard let name = aDecoder.decodeObject(forKey: "name") as? String,
            let ip = aDecoder.decodeObject(forKey: "ip") as? String
            else { return nil }
        
        self.init(name: name, ip: ip)
    }
    
    public override func isEqual(_ object: Any?) -> Bool {
        guard let pxps = object as? PhoneXpadServer else { return false }
        
        if pxps.Name == self.Name && pxps.Ip == self.Ip {
            return true
        }
        return false
    }
}
