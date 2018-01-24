package com.example.piry3.phonegamepad;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.database.Cursor;
import android.hardware.Sensor;
import android.hardware.SensorEvent;
import android.hardware.SensorEventListener;
import android.hardware.SensorManager;
import android.net.ConnectivityManager;
import android.net.NetworkInfo;
import android.net.Uri;
import android.net.wifi.WifiInfo;
import android.net.wifi.WifiManager;
import android.os.AsyncTask;
import android.os.Bundle;
import android.os.Handler;
import android.os.Vibrator;
import android.provider.ContactsContract;
import android.provider.Settings;
import android.support.v7.app.AppCompatActivity;
import android.text.format.Formatter;
import android.util.Log;
import android.view.MotionEvent;
import android.view.View;
import android.view.Window;
import android.view.WindowManager;
import android.widget.Button;
import android.widget.CompoundButton;
import android.widget.Switch;
import android.widget.TextView;

import java.io.IOException;
import java.net.Socket;
import java.util.concurrent.ExecutionException;

import io.github.controlwear.virtual.joystick.android.JoystickView;

import static android.view.View.*;

public class MainActivity extends AppCompatActivity {

    Switch connectionSwitch;
    TextView ipTextView;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        connectionSwitch = (Switch) findViewById(R.id.ConnectionSwitch);
        ipTextView = (TextView) findViewById(R.id.ipTextView);
        ipTextView.setText(PcConnection.ip);

        PadManager.Init(this);

        connectionSwitch.setOnCheckedChangeListener(new CompoundButton.OnCheckedChangeListener() {
            public void onCheckedChanged(CompoundButton buttonView, boolean isChecked) {
                if (isChecked && PcConnection.ip == "") {
                    Intent networkList = new Intent(MainActivity.this, NetworkList.class);
                    startActivityForResult(networkList, 101);
                } else if (!isChecked) {
                    try {
                        PadManager.DisconnectPad();
                    } catch (Exception e) {
                        e.printStackTrace();
                    }
                    PcConnection.ip = "";
                    ipTextView.setText(PcConnection.ip);
                }
            }
        });

    }

    protected void StartStandardPad(View view) {

        if (connectionSwitch.isChecked()) {
            Intent pad = new Intent(MainActivity.this, StandardPad.class);
            startActivity(pad);
        }

    }

    protected void StartJoystick(View view) {

        if (connectionSwitch.isChecked()) {
            Intent joy = new Intent(MainActivity.this, Joystick.class);
            startActivity(joy);
        }

    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);

        if ((requestCode == 101) && (resultCode == Activity.RESULT_OK)) {
            Bundle bundle = data.getExtras();
            PcConnection.ip = bundle.getString("ip");
            PadManager.ConnectPad();
            ipTextView.setText(PcConnection.ip);
        }
    }
}