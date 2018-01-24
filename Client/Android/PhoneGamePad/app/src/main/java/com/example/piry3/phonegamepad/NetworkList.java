package com.example.piry3.phonegamepad;

import android.app.Activity;
import android.content.Intent;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.ListView;
import android.widget.ProgressBar;

import java.util.List;

public class NetworkList extends AppCompatActivity {

    private ListView list;
    private ProgressBar progressBar;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_network_list);

        list = (ListView) findViewById(R.id.NetworkList);
        progressBar = (ProgressBar) findViewById(R.id.progressBar);

        list.setClickable(true);
        list.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> arg0, View arg1, int position, long arg3) {

                String name = (String) list.getItemAtPosition(position);
                String ip = name.split(":")[1];
                Intent myLocalIntent = getIntent();
                Bundle bundle = new Bundle();
                bundle.putString("ip", ip);
                myLocalIntent.putExtras(bundle);
                setResult(Activity.RESULT_OK, myLocalIntent);
                finish();
            }
        });

        SearchOnClick(null);
    }


    public ListView GetListView() {
        return list;
    }

    public void SetAdapter(List<String> data) {
        ArrayAdapter<String> adapter = new ArrayAdapter<String>(this, R.layout.row, data);
        list.setAdapter(adapter);
    }

    public void SetProgress(int progress) {
        progressBar.setProgress(progress);
    }

    protected void SearchOnClick(View view) {
        if (progressBar.getProgress() == 0) {
            NetworkSniffTask nst = new NetworkSniffTask(this);
            nst.execute();
        }
    }

}
