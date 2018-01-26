//
//  PadManager.swift
//  PhoneXpad
//
//  Created by Admin on 21/01/2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import Foundation
import SwiftSocket
import UIKit
import CoreMotion

public class PadManager {
    
    public  var xpad: Xpad = Xpad(deviceId: UIDevice.current.identifierForVendor!.uuidString)
    private let client = TCPClient(address: SocketData.serverIp!, port: Int32(SocketData.port!))
   // private let client = TCPClient(address: "172.20.10.2", port: 1234)
    private var timer = Timer()
    private var timer2 = Timer()
    private let updateInterval = 0.01
    private var motionManager = CMMotionManager()
    private var i = 0
    
    init(){
        // StartMotionMonitorWithIntervals()
        StartMotionMonitor()
    }
    
    // send xpad status to server app
    public func StartCommunicationWithServer() {
        timer.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: updateInterval, repeats: true) { [weak self] _ in
            self?.SendMessage(msg: (self?.xpad.toString())!)
        }
    }
    
    private func StartMotionMonitorWithIntervals(){
        
        timer2.invalidate()
        timer2  = Timer.scheduledTimer(withTimeInterval: 10, repeats: true) { [weak self] _ in
            //self?.i += 1
            //let pos = (self?.xpad.RightStickX)! < Float(0) ? -(self?.xpad.RightStickX)! : self?.xpad.RightStickX
        
           // if self!.i > 10 && pos! < Float(0.01) {
                self?.StartMotionMonitor()
              //  self?.i = 0
               // print("reset")
           // }
        }
    }
    
    private func StartMotionMonitor(){
        motionManager.stopDeviceMotionUpdates()
        motionManager.deviceMotionUpdateInterval = updateInterval
        motionManager.startDeviceMotionUpdates(to: OperationQueue.current!){ (data,error) in
            if let attitude = data?.attitude {
               // print(attitude.pitch)
                self.xpad.RightStickY = self.ConvertMotion(rad : attitude.pitch)
                self.xpad.RightStickX = self.ConvertMotion(rad : attitude.roll)
            }
        }
    }
    
    private func ConvertMotion(rad: Double) -> Float {
        let maxRad = 0.7
        let maxValue = 6.0
        var value = rad
        value = value > maxRad ? maxRad : value
        value = value < -maxRad ? -maxRad : value
        
        return Float(value * (maxValue / maxRad))
    }
    
    // stop sending xpad status
    public func StopCommunicationWithServer(){
        stopTimer()
    }
    
    public func DisconnectPad() {
        StopCommunicationWithServer()
        SendMessage(msg: xpad.DisconnectString())
    }
    
    public func ConnectPad(){
        SendMessage(msg: xpad.ConnectString())
    }
    
    private func stopTimer() {
        timer.invalidate()
        timer2.invalidate()
    }
    
    deinit {
        stopTimer()
        motionManager.stopDeviceMotionUpdates()
    }
    
    // Set messtge to xpad server
    private func SendMessage(msg: String){
        
        switch client.connect(timeout: 1) {
        case .success:
            switch client.send(string: msg) {
            case .success:
                guard let data = client.read(128,timeout: 1) else { return }
                if !SetVibrations(data: data) {
                    if let response = String(bytes: data, encoding: .utf8) {
                        print("response: " + response)
                    }
                }
            case .failure(let error):
                print(error)
            }
        case .failure(let error):
            print(error)
        }
        client.close()
    }
    
    // Set Vibrations for xpad
    private func SetVibrations(data: [UInt8]) -> Bool{
        if data[0] == xpad.MotorFlag{
            xpad.BigMotor = Int(data[1])
            xpad.SmallMotor = Int(data[2])
            return true
        }
        return false
    }
    
    private func Vibrate(){
      //TODO
    }
    
    public func SetBoolBtns(btnName: String, isPressed: Bool){
        let value = isPressed ? 1 : 0
        
        switch btnName {
        case "A" : xpad.Abtn = value
        case "B" : xpad.Bbtn = value
        case "Y" : xpad.Ybtn = value
        case "X" : xpad.Xbtn = value
        case "arrowUp" : xpad.arrowUp = value
        case "arrowDown" : xpad.arrowDown = value
        case "arrowLeft" : xpad.arrowLeft = value
        case "arrpRight" : xpad.arrowRight = value
        case "Back" : xpad.Back = value
        case "Guide" : xpad.Guide = value
        case "Start" : xpad.Start = value
        case "LB" : xpad.LeftBumper = value
        case "RB" : xpad.RightBumper = value
        default:
            return
        }
        
    }
    
}

