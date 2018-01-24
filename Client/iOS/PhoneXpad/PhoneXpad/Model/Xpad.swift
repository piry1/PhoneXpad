//
//  Xpad.swift
//  PhoneXpad
//
//  Created by Admin on 20/01/2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import Foundation

/**
 Interface of Xbox 360 gamepad
 */
public class Xpad{
    //MARK: - variables
    public var padId : String = ""
    //Sticks
    public var LeftStickX : Float = 0.0
    public var LeftStickY : Float = 0.0
    public var RightStickX : Float = 0.0
    public var RightStickY : Float = 0.0
    //Buttons
    public var Xbtn : Int = 0
    public var Ybtn : Int = 0
    public var Abtn : Int = 0
    public var Bbtn: Int = 0
    //Arrows
    public var arrowUp: Int = 0
    public var arrowDown : Int = 0
    public var arrowLeft : Int = 0
    public var arrowRight : Int = 0
    //Triggers
    public var LeftTriger : Float = 0.0
    public var RightTriger : Float = 0.0
    //Bumpers
    public var LeftBumper : Int = 0
    public var RightBumper : Int = 0
    //System
    public var Back : Int = 0
    public var Start : Int = 0
    public var Guide : Int = 0
    //Mmotors
    public var SmallMotor : Int = 0
    public var BigMotor  : Int = 0
    public let MotorFlag : UInt8 = 0x08
    
    //MARK: - methods
    public init(deviceId : String) {
        padId = deviceId
    }
    
    public func DisconnectString() -> String {
        return padId + "|" + "disconnect"
    }
    
    public func ConnectString() -> String {
        return  padId + "|" + "connect"
    }
    
    public func toString() -> String {
        return "\(padId)|\(LeftStickX)|\(LeftStickY)|\(RightStickX)|\(RightStickY)|\(Xbtn)|\(Ybtn)|\(Abtn)|\(Bbtn)|\(arrowUp)|\(arrowDown)|\(arrowLeft)|\(arrowRight)|\(LeftTriger)|\(RightTriger)|\(LeftBumper)|\(RightBumper)|\(Back)|\(Start)|\(Guide)"
    }
}
