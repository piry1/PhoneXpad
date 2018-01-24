package com.example.piry3.phonegamepad;

import android.content.Context;
import android.net.ConnectivityManager;
import android.net.NetworkInfo;
import android.net.wifi.WifiInfo;
import android.net.wifi.WifiManager;
import android.nfc.Tag;
import android.os.AsyncTask;
import android.provider.SyncStateContract;
import android.text.format.Formatter;
import android.util.Log;
import android.util.Xml;
import android.widget.ArrayAdapter;
import android.widget.ListView;
import android.widget.ProgressBar;

import java.io.IOException;
import java.lang.ref.WeakReference;
import java.lang.reflect.Array;
import java.lang.reflect.Method;
import java.net.InetAddress;
import java.net.Socket;
import java.net.UnknownHostException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

/**
 * Created by piry3 on 18.11.2017.
 */
class NetworkSniffTask extends AsyncTask<Void, Void, List<String>> {

    private static final String TAG = SyncStateContract.Constants.DATA + "nstask";

    private WeakReference<Context> mContextRef;
    private NetworkList NetList;

    public NetworkSniffTask(NetworkList context) {
        NetList = context;
        mContextRef = new WeakReference<Context>(context);
    }

    @Override
    protected List<String> doInBackground(Void... voids) {
        List<String> results = new ArrayList<>();
        try {
            Context context = mContextRef.get();

            if (context != null) {

                ConnectivityManager cm = (ConnectivityManager) context.getSystemService(Context.CONNECTIVITY_SERVICE);
                NetworkInfo activeNetwork = cm.getActiveNetworkInfo();
                WifiManager wm = (WifiManager) context.getSystemService(Context.WIFI_SERVICE);
                Method method = wm.getClass().getDeclaredMethod("getWifiApState");
                String ipString = "";
                final int AP_STATE_ENABLED = 13;

                if ((Integer) method.invoke(wm, (Object[]) null) == AP_STATE_ENABLED) {
                    ipString = "192.168.43.1";
                } else {
                    WifiInfo connectionInfo = wm.getConnectionInfo();
                    int ipAddress = connectionInfo.getIpAddress();
                    ipString = Formatter.formatIpAddress(ipAddress);
                }

                String prefix = ipString.substring(0, ipString.lastIndexOf(".") + 1);

                Log.e(TAG, prefix);
                for (int i = 2; i < 255; i++) {
                    NetList.SetProgress((int) (i * 100 / 254));
                    String testIp = prefix + String.valueOf(i);
                    InetAddress address = InetAddress.getByName(testIp);
                    boolean reachable = address.isReachable(20);
                    String hostName = address.getCanonicalHostName();

                    if (reachable) {
                        //  Log.e(TAG, "Host: " + String.valueOf(hostName) + "(" + String.valueOf(testIp) + ") is reachable!");
                        try {
                            Socket s = new Socket(testIp, 1234);
                            String message = "ppm";
                            byte[] b = new byte[50];
                            s.getOutputStream().write(message.getBytes());
                            int size = s.getInputStream().read(b);
                            b = Arrays.copyOfRange(b, 0, size);
                            String back = new String(b, "US-ASCII");
                            if (size != 0) {
                                Log.i(TAG, String.valueOf(testIp));
                                results.add(back + ":" + testIp);
                            }
                            s.close();
                        } catch (Exception ex) {
                            Log.e(TAG, ex.getMessage());
                        }

                    }
                }
            }
        } catch (Throwable t) {
            Log.e(TAG, "Well that's not good.", t);
        }
        Log.i(TAG, "DONE SERCHING");
        return results;
    }

    @Override
    protected void onPostExecute(List<String> result) {
        super.onPostExecute(result);
        NetList.SetProgress(0);
        final ListView list = NetList.GetListView();
        ArrayAdapter<String> adapter = new ArrayAdapter<String>(NetList, R.layout.row, result);
        list.setAdapter(adapter);
    }
}