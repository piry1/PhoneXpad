package com.example.piry3.phonegamepad;

import android.hardware.Sensor;
import android.hardware.SensorEvent;
import android.hardware.SensorEventListener;
import android.hardware.SensorManager;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.view.KeyEvent;
import android.view.Window;
import android.view.WindowManager;

public class Joystick extends AppCompatActivity implements SensorEventListener {

    SensorManager sm;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        this.requestWindowFeature(Window.FEATURE_NO_TITLE);
        this.getWindow().setFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN, WindowManager.LayoutParams.FLAG_FULLSCREEN);
        setContentView(R.layout.activity_joystick);

        LoadSensors();
        PadManager.StartCommunication();
    }

    private void LoadSensors() {
        sm = (SensorManager) getSystemService(SENSOR_SERVICE);
        Sensor accelerometer = sm.getDefaultSensor(Sensor.TYPE_ACCELEROMETER);
        sm.registerListener(this, accelerometer, SensorManager.SENSOR_DELAY_NORMAL);
    }

    private void DisableSensors(){
        sm.unregisterListener(this);
    }

    @Override
    public void onSensorChanged(SensorEvent event) {
        if (event.sensor.getType() == Sensor.TYPE_ACCELEROMETER) {
            PadManager.xpad.LeftStickY = event.values[0];
            PadManager.xpad.LeftStickX = event.values[2];
        }
    }

    @Override
    public void onAccuracyChanged(Sensor sensor, int accuracy) {

    }

    @Override
    public boolean onKeyDown(int keyCode, KeyEvent event) {
        int state = 1;
        switch (keyCode) {
            case KeyEvent.KEYCODE_VOLUME_DOWN:
                PadManager.xpad.arrowDown = state;
                break;
            case KeyEvent.KEYCODE_VOLUME_UP:
                PadManager.xpad.arrowUp = state;
                break;
            default:
                return super.onKeyDown(keyCode, event);
        }
        return true;
    }

    @Override
    public boolean onKeyUp(int keyCode, KeyEvent event) {
        int state = 0;
        switch (keyCode) {
            case KeyEvent.KEYCODE_VOLUME_DOWN:
                PadManager.xpad.arrowDown = state;
                break;
            case KeyEvent.KEYCODE_VOLUME_UP:
                PadManager.xpad.arrowUp = state;
                break;
            default:
                return super.onKeyUp(keyCode, event);
        }
        return true;
    }

    @Override
    protected void onStop() {
        super.onStop();
        PadManager.StopCommunication();
        DisableSensors();
    }
}
