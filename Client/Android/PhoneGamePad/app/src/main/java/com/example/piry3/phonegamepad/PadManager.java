package com.example.piry3.phonegamepad;

import android.content.Context;
import android.hardware.Sensor;
import android.hardware.SensorEvent;
import android.hardware.SensorEventListener;
import android.os.AsyncTask;
import android.os.Handler;
import android.os.Vibrator;
import android.provider.Settings;
import android.util.Log;

import java.io.IOException;
import java.net.Socket;
import java.util.Arrays;
import java.util.concurrent.ExecutionException;

/**
 * Created by piry3 on 05.12.2017.
 */

public class PadManager implements SensorEventListener {

    public static Xpad xpad;

    private static boolean canSend = true;
    private static Handler handler = new Handler();
    private static Vibrator vibrator;

    public static void Init(Context context){
        xpad = new Xpad(Settings.Secure.getString(context.getContentResolver(), Settings.Secure.ANDROID_ID));
        vibrator = (Vibrator) context.getSystemService(context.VIBRATOR_SERVICE);
    }

    public static void StartCommunication() {
        canSend = true;
        handler.postDelayed(new Runnable() {
            public void run() {
                new PcConnection().execute(xpad.toString());
                if (canSend)
                    handler.postDelayed(this, PcConnection.delay);
                Vibrate();
            }
        }, PcConnection.delay);
    }

    public static void StopCommunication(){
        canSend = false;
    }

    public static void DisconnectPad() throws ExecutionException, InterruptedException {
        new PcConnection().execute(xpad.DisconnectString()).get();
    }

    public static void ConnectPad(){
        new PcConnection().execute(xpad.ConnectString());
    }

    private static void Vibrate(){
        int delay = PcConnection.delay;
        if (xpad.BigMotor == 0 && xpad.SmallMotor == 0) {
            vibrator.cancel();
            return;
        }

        int max = 255;
        long[] pattern;

        if (xpad.BigMotor == 0) {
            int small = (((xpad.SmallMotor * delay) / max));
            pattern = new long[]{0, small, (int) delay - small};
        } else {
            int big = ((xpad.BigMotor * (delay)) / max) + delay / 3;
            pattern = new long[]{0, big, (int) delay - big};
        }

        vibrator.vibrate(pattern, 0);
    }

    @Override
    public void onSensorChanged(SensorEvent event) {

    }

    @Override
    public void onAccuracyChanged(Sensor sensor, int accuracy) {

    }
}
