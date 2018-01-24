package com.example.piry3.phonegamepad;

/**
 * Created by piry3 on 15.11.2017.
 */

public class Xpad {
    public String padId = "";
    //Sticks
    public double LeftStickX = 0.0;
    public double LeftStickY = 0.0;
    public double RightStickX = 0.0;
    public double RightStickY = 0.0;
    //Buttons
    public int Xbtn = 0;
    public int Ybtn = 0;
    public int Abtn = 0;
    public int Bbtn = 0;
    //Arrows
    public int arrowUp = 0;
    public int arrowDown = 0;
    public int arrowLeft = 0;
    public int arrowRight = 0;
    //Triggers
    public double LeftTriger = 0.0;
    public double RightTriger = 0.0;
    //Bumpers
    public int LeftBumper = 0;
    public int RightBumper = 0;
    //System
    public int Back = 0;
    public int Start = 0;
    public int Guide = 0;
    //Mmotors
    public int SmallMotor = 0;
    public int BigMotor = 0;
    public final byte MotorFlag = 0x08;

    public Xpad(String androidId) {
        padId = androidId;
    }

    public String DisconnectString(){
        return padId + "|" + "disconnect";
    }

    public String ConnectString(){
        return  padId + "|" + "connect";
    }

    @Override
    public String toString() {
        return padId + "|" + LeftStickX + "|" + LeftStickY + "|" + RightStickX + "|" + RightStickY + "|" +
                Xbtn + "|" + Ybtn + "|" + Abtn + "|" + Bbtn + "|" + arrowUp + "|" + arrowDown + "|" +
                arrowLeft + "|" + arrowRight + "|" + LeftTriger + "|" + RightTriger + "|" +
                LeftBumper + "|" + RightBumper + "|" + Back + "|" + Start + "|" + Guide;
    }

}
