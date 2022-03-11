//
// Copyright 2016-2021 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//

import Toybox.Attention;
import Toybox.Lang;
import Toybox.WatchUi;

//! Handle button view behavior
class ButtonDelegate extends WatchUi.BehaviorDelegate {
    //! Constructor
    public function initialize() {
        BehaviorDelegate.initialize();
    }

    //! Handle the back event
    //! @return true if handled, false otherwise
    public function onBack() as Boolean {
        WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
        return true;
    }

    //! Handle going to the previous view
    //! @return true if handled, false otherwise
    public function onPreviousPage() as Boolean {
        WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
        return true;
    }

    //! Vibrate on menu event
    //! @return true if handled, false otherwise
    public function onMenu() as Boolean {
        if (Attention has :vibrate) {
            var vibrateData = [
                new Attention.VibeProfile(25, 100),
                new Attention.VibeProfile(50, 100),
                new Attention.VibeProfile(75, 100),
                new Attention.VibeProfile(100, 100),
                new Attention.VibeProfile(75, 100),
                new Attention.VibeProfile(50, 100),
                new Attention.VibeProfile(25, 100),
            ] as Array<VibeProfile>;

            Attention.vibrate(vibrateData);
        }
        return true;
    }
}
