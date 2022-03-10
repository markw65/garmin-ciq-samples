//
// Copyright 2016-2021 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//

import Toybox.Activity;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.Time;
import Toybox.WatchUi;

//! The data field alert
class DataFieldAlertView extends WatchUi.DataFieldAlert {

    //! Constructor
    public function initialize() {
        DataFieldAlert.initialize();
    }

    //! Update the view
    //! @param dc Device context
    public function onUpdate(dc as Dc) as Void {
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
        dc.clear();
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);

        dc.drawText(dc.getWidth() / 2, dc.getHeight() / 2 - 30, Graphics.FONT_SMALL, "Alert: 10 sec elapsed", Graphics.TEXT_JUSTIFY_CENTER);
    }
}

//! Data field that shows HR, distance, and time
class DataField extends WatchUi.SimpleDataField {
    private const METERS_TO_MILES = 0.000621371;
    private const MILLISECONDS_TO_SECONDS = 0.001;

    private var _counter as Number;
    private var _alertDisplayed as Boolean;

    //! Constructor
    public function initialize() {
        SimpleDataField.initialize();
        label = "HR, Dist, Timer";
        _counter = 0;
        _alertDisplayed = false;
    }

    //! Get the information to show in the data field
    //! @param info The updated Activity.Info object
    //! @return The data to show
    public function compute(info as Info) as Numeric or Duration or String or Null {
        var value_picked = "--";

        // Cycle between heart rate (int), distance (float), and stopwatch time (Duration)
        if ((_counter == 0) && (info.currentHeartRate != null)) {
            value_picked = info.currentHeartRate;
        } else if (_counter == 1) {
            var elapsedDistance = info.elapsedDistance;
            if (elapsedDistance != null) {
                value_picked = elapsedDistance * METERS_TO_MILES;
            }
        } else if (_counter == 2) {
            var timerTime = info.timerTime;
            if (timerTime != null) {
                var options = {:seconds => (timerTime *  MILLISECONDS_TO_SECONDS).toNumber()};
                value_picked = Time.Gregorian.duration(options);

                if ((WatchUi.DataField has :showAlert) && ((timerTime * MILLISECONDS_TO_SECONDS) > 10.000f)
                    && !_alertDisplayed) {
                    WatchUi.DataField.showAlert(new $.DataFieldAlertView());
                    _alertDisplayed = true;
                }
            }
        }

        _counter++;
        if (_counter > 2) {
            _counter = 0;
        }

        return value_picked;
    }
}