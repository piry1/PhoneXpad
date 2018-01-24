using ScpDriverInterface;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Windows;

namespace PhonePadManager.Controller
{
    internal class ControllersManager
    {
        public Dictionary<string, int> Controllers { get; } = new Dictionary<string, int>();

        private ScpBus scpBus = new ScpBus();
        private char separator = '|';
        private X360Controller xpad = new X360Controller();

        private int? CheckController(string phoneId)
        {
            int padId;
            try
            {
                if (Controllers.ContainsKey(phoneId)) // if pad is already plugged in
                {
                    padId = Controllers[phoneId];
                }
                else // plug new pad
                {
                    padId = Controllers.Count + 1;
                    scpBus.PlugIn(padId);
                    Controllers.Add(phoneId, padId);
                }
            }
            catch (Exception e)
            {
                MessageBox.Show(e.Message);
                return null;
            }
            return padId;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="message">PHONE_ID</param>
        private void UnplugController(string phoneId)
        {
            try
            {
                scpBus.Unplug(Controllers[phoneId]);
                Controllers.Remove(phoneId);
            }
            catch (Exception e)
            {
#if DEBUG
                MessageBox.Show(e.Message);
#endif
            }
        }

        /// <summary>
        /// Sets status of all buttons in specified controller
        /// </summary>
        /// <param name="message">PAD_ID|BTN_STAT...</param>
        public byte[] SetControllers(string message)
        {
            var m = message.Split(separator).ToList<string>();
            string phoneId = m[0];
            int? controllerId;
            byte[] outputReport = new byte[8];
            byte[] motors = new byte[3]; // state, big motor, small motor

            if (m.Count == 2)
            {
                switch (m[1])
                {
                    case "disconnect": UnplugController(phoneId); break;
                    case "connect": CheckController(phoneId); break;
                }
                return motors;
            }

            controllerId = CheckController(phoneId);

            if (controllerId.HasValue)
            {
                m.Remove(m.First());
                xpad.SetFromString(m);
                scpBus.Report(controllerId.Value, xpad.GetReport(), outputReport);

                motors[0] = outputReport[1];

                if (outputReport[1] == 0x08)
                {
                    motors[1] = outputReport[3]; // big motor
                    motors[2] = outputReport[4]; // small motor
                }
            }

            return motors;
        }
    }
}
