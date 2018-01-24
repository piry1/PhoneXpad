package com.example.piry3.phonegamepad;

import android.os.AsyncTask;
import android.util.Log;

import java.io.IOException;
import java.net.Socket;
import java.util.Arrays;

/**
 * Created by piry3 on 04.12.2017.
 */

public class PcConnection extends AsyncTask<String, Void, byte[]> {
    static String ip = "";
    final static int port = 1234;
    final static int delay = 20;

    @Override
    protected byte[] doInBackground(String... params) {
        byte[] b = new byte[200];

        try {
            Socket s = new Socket(ip, port);
            s.getOutputStream().write(params[0].getBytes());
            int size = s.getInputStream().read(b);
            b = Arrays.copyOfRange(b, 0, size);
            s.close();
        } catch (IOException e) {
            Log.e("error", e.getMessage());
        }
        return b;
    }

    @Override
    protected void onPostExecute(byte[] b) {
        super.onPostExecute(b);
        if (b[0] == PadManager.xpad.MotorFlag) {
            PadManager.xpad.BigMotor = (short) b[1];
            PadManager.xpad.SmallMotor = (short) b[2];
        }
    }
}
