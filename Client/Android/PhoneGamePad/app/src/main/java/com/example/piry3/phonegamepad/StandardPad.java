package com.example.piry3.phonegamepad;

import android.hardware.Sensor;
import android.hardware.SensorEvent;
import android.hardware.SensorEventListener;
import android.hardware.SensorManager;
import android.os.AsyncTask;
import android.os.Handler;
import android.os.Vibrator;
import android.provider.Settings;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.util.Log;
import android.view.KeyEvent;
import android.view.MotionEvent;
import android.view.View;
import android.view.Window;
import android.view.WindowManager;
import android.widget.Button;
import android.widget.ImageButton;
import android.widget.ImageView;

import java.io.IOException;
import java.net.Socket;

import io.github.controlwear.virtual.joystick.android.JoystickView;

public class StandardPad extends AppCompatActivity implements SensorEventListener {

    private static Boolean useAccelerometerAsLeftStick = false;
    private Button Xbtn, Ybtn, Abtn, Bbtn, StartBtn, BackBtn, LeftBumper, RightBumper;
    private ImageButton UpBtn, DownBtn, LeftBtn, RightBtn;
    private ImageView accImageView;
    private JoystickView joystickLeft, joystickRight;
    private SensorManager sm;


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        this.requestWindowFeature(Window.FEATURE_NO_TITLE);
        this.getWindow().setFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN, WindowManager.LayoutParams.FLAG_FULLSCREEN);
        setContentView(R.layout.activity_standard_pad);
        accImageView = (ImageView) findViewById(R.id.AccImageView);

        LoadButtons();
        SetButtonsOnTouchListeners();
        LoadSensors();
        LoadJoySticks();
        SetAccVisibility();
        PadManager.StartCommunication();
    }

    private void LoadButtons() {
        Xbtn = (Button) findViewById(R.id.buttonX);
        Ybtn = (Button) findViewById(R.id.buttonY);
        Abtn = (Button) findViewById(R.id.buttonA);
        Bbtn = (Button) findViewById(R.id.buttonB);
        StartBtn = (Button) findViewById(R.id.buttonStart);
        BackBtn = (Button) findViewById(R.id.buttonBack);
        UpBtn = (ImageButton) findViewById(R.id.buttonUp);
        DownBtn = (ImageButton) findViewById(R.id.buttonDown);
        LeftBtn = (ImageButton) findViewById(R.id.buttonLeft);
        RightBtn = (ImageButton) findViewById(R.id.buttonRight);
        LeftBumper = (Button) findViewById(R.id.buttonLB);
        RightBumper = (Button) findViewById(R.id.buttonRB);
    }

    private void LoadSensors() {
        sm = (SensorManager) getSystemService(SENSOR_SERVICE);
        Sensor accelerometer = sm.getDefaultSensor(Sensor.TYPE_ACCELEROMETER);
        sm.registerListener(this, accelerometer, SensorManager.SENSOR_DELAY_NORMAL);
    }

    private void DisableSensors(){
        sm.unregisterListener(this);
    }

    private void LoadJoySticks() {
        joystickLeft = (JoystickView) findViewById(R.id.joystickView_left);
        joystickLeft.setOnMoveListener(new JoystickView.OnMoveListener() {
            @Override
            public void onMove(int angle, int strength) {
                if (!useAccelerometerAsLeftStick) {
                    double radAngle = Math.toRadians((double) angle);
                    double s = (strength * 7) / 100;
                    double x = s * Math.sin(radAngle);
                    double y = s * Math.cos(radAngle);

                    PadManager.xpad.LeftStickY = x;
                    PadManager.xpad.LeftStickX = y;
                }
            }
        }, 17);

        joystickRight = (JoystickView) findViewById(R.id.joystickView_right);
        joystickRight.setOnMoveListener(new JoystickView.OnMoveListener() {
            @Override
            public void onMove(int angle, int strength) {

                double radAngle = Math.toRadians((double) angle);
                double s = (strength * 7) / 100;
                double x = s * Math.sin(radAngle);
                double y = s * Math.cos(radAngle);

                PadManager.xpad.RightStickY = x;
                PadManager.xpad.RightStickX = y;
            }
        }, 17);
    }

    private void SetButtonsOnTouchListeners() {

        View.OnTouchListener onTouchListener = new View.OnTouchListener() {
            @Override
            public boolean onTouch(View v, MotionEvent event) {
                String tag = (String) v.getTag();
                try {
                    switch (event.getAction()) {
                        case MotionEvent.ACTION_DOWN:
                            PadManager.xpad.getClass().getField(tag).setInt(PadManager.xpad, 1);
                            return true;
                        case MotionEvent.ACTION_UP:
                            PadManager.xpad.getClass().getField(tag).setInt(PadManager.xpad, 0);
                            return true;
                    }
                } catch (NoSuchFieldException e) {
                    e.printStackTrace();
                } catch (IllegalAccessException e) {
                    e.printStackTrace();
                }
                return false;
            }
        };

        Xbtn.setOnTouchListener(onTouchListener);
        Ybtn.setOnTouchListener(onTouchListener);
        Abtn.setOnTouchListener(onTouchListener);
        Bbtn.setOnTouchListener(onTouchListener);
        StartBtn.setOnTouchListener(onTouchListener);
        BackBtn.setOnTouchListener(onTouchListener);
        UpBtn.setOnTouchListener(onTouchListener);
        DownBtn.setOnTouchListener(onTouchListener);
        LeftBtn.setOnTouchListener(onTouchListener);
        RightBtn.setOnTouchListener(onTouchListener);
        LeftBumper.setOnTouchListener(onTouchListener);
        RightBumper.setOnTouchListener(onTouchListener);
    }

    @Override
    public void onSensorChanged(SensorEvent event) {
        if (event.sensor.getType() == Sensor.TYPE_ACCELEROMETER && useAccelerometerAsLeftStick) {
            PadManager.xpad.LeftStickY = -event.values[0];
            PadManager.xpad.LeftStickX = event.values[1];
        }
    }

    @Override
    public void onAccuracyChanged(Sensor sensor, int accuracy) {

    }

    public void switchOnClick(View view) {
        useAccelerometerAsLeftStick = !useAccelerometerAsLeftStick;
        SetAccVisibility();
    }

    private void SetAccVisibility() {
        if (useAccelerometerAsLeftStick) {
            accImageView.setVisibility(View.VISIBLE);
            joystickLeft.setVisibility(View.INVISIBLE);
        } else {
            accImageView.setVisibility(View.GONE);
            joystickLeft.setVisibility(View.VISIBLE);
        }
    }

    @Override
    public boolean onKeyDown(int keyCode, KeyEvent event) {
        int state = 1;
        switch (keyCode){
            case KeyEvent.KEYCODE_VOLUME_DOWN: PadManager.xpad.arrowDown = state; break;
            case KeyEvent.KEYCODE_VOLUME_UP: PadManager.xpad.arrowUp = state; break;
            default: return super.onKeyDown(keyCode, event);
        }
        return true;
    }

    @Override
    public boolean onKeyUp(int keyCode, KeyEvent event) {
        int state = 0;
        switch (keyCode){
            case KeyEvent.KEYCODE_VOLUME_DOWN: PadManager.xpad.arrowDown = state; break;
            case KeyEvent.KEYCODE_VOLUME_UP: PadManager.xpad.arrowUp = state; break;
            default: return super.onKeyUp(keyCode, event);
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
