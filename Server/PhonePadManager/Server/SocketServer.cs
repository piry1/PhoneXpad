using ScpDriverInterface;
using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Net;
using System.Net.Sockets;
using System.Text;
using System.Threading;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;
using PhonePadManager.Controller;

namespace PhonePadManager.Server
{
    internal static class SocketServer
    {
        static private Thread responseThread;
        static TcpListener serverSocket;
        private static TextBox tb;
        public delegate void UpdateTextCallback(string message);
        static ControllersManager controllersManager = new ControllersManager();

        public static void Start(TextBox textBox)
        {
            tb = textBox;
            serverSocket = new TcpListener(IPAddress.Any, 1234);
            serverSocket.Start();
            responseThread = new Thread(ResponseThread);
            responseThread.Start();
        }

        public static void Stop()
        {
            new ScpBus().UnplugAll();
            serverSocket.Stop();
            responseThread.Abort();
        }

        private static void ResponseThread()
        {
            Socket client;
            byte[] data = new byte[256];

            while (true)
            {
                client = serverSocket.AcceptSocket();

                if (client.ReceiveBufferSize != 0)
                {
                    int size = client.Receive(data);
                    string s = "";
                    for (int i = 0; i < size; i++)
                        s += Convert.ToChar(data[i]);
                    if(s == "ppm")
                    {
                        client.Send(Encoding.UTF8.GetBytes("piry"));                    
                    }
                    else if (s != "")
                    {
                        tb.Dispatcher.Invoke(new UpdateTextCallback(UpdateText), new object[] { s });
                        try
                        {
                            var motors = controllersManager.SetControllers(s);
                            client.Send(motors);
                        }
                        catch (Exception e)
                        {
                            tb.Dispatcher.Invoke(new UpdateTextCallback(UpdateText), new object[] { e.Message });
                        }
                    }


                }
                client.Close();
            }

        }

        private static void UpdateText(string message)
        {
            if (message != "")
            {
                var s = message.Replace('|', '\n');
                tb.Text = s;
                try
                {
                    //  controllersManager.SetControllers(message);
                }
                catch (Exception e)
                {
                    tb.Text = e.Message;
                }
            }
        }

    }
}
