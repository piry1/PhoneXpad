using ScpDriverInterface;
using System;
using System.Collections.Generic;
using System.Globalization;

namespace PhonePadManager.Controller
{
    public static class X360ControllerExtensions
    {
        private readonly static int Border = 6;
        private readonly static int stickMax = 32767;

        /// <summary>
        /// Set X360Controller buttons state from specified strings list
        /// </summary>
        /// <param name="x"></param>
        /// <param name="m"></param>
        public static void SetFromString(this X360Controller x, List<string> m)
        {
            if (m.Count >= 19)
            {
                x.LeftStickX = CalculateStick(m[0]);
                x.LeftStickY = CalculateStick(m[1]);
                x.RightStickX = CalculateStick(m[2]);
                x.RightStickY = CalculateStick(m[3]);
                //Buttons
                SetBtn(x, X360Buttons.X, m[4]);
                SetBtn(x, X360Buttons.Y, m[5]);
                SetBtn(x, X360Buttons.A, m[6]);
                SetBtn(x, X360Buttons.B, m[7]);
                //Arrows
                SetBtn(x, X360Buttons.Up, m[8]);
                SetBtn(x, X360Buttons.Down, m[9]);
                SetBtn(x, X360Buttons.Left, m[10]);
                SetBtn(x, X360Buttons.Right, m[11]);
                //Bumpers
                SetBtn(x, X360Buttons.LeftBumper, m[14]);
                SetBtn(x, X360Buttons.RightBumper, m[15]);
                //System 
                SetBtn(x, X360Buttons.Back, m[16]);
                SetBtn(x, X360Buttons.Start, m[17]);
                SetBtn(x, X360Buttons.Logo, m[18]);
            }
        }

        #region Private methods

        private static short CalculateStick(string valueString)
        {
            double value = Standarize(Double.Parse(valueString, CultureInfo.InvariantCulture));
            return (short)((stickMax * value) / Border);
        }

        private static void SetBtn(X360Controller x, X360Buttons btn, string state)
        {
            int s = int.Parse(state);

            if (s == 1)
                x.Buttons |= btn;
            else
                x.Buttons &= ~btn;
        }

        private static double Standarize(double x)
        {
            if (x > Border)
                x = Border;
            else if (x < -Border)
                x = -Border;
            return x;
        }

        #endregion
    }
}
