//
// Copyright 2016-2021 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//

import Toybox.Application;
import Toybox.Lang;
import Toybox.Timer;
import Toybox.WatchUi;

//! This application demonstrates bursting over a Generic Channel in Ant
class GenericChannelBurstApp extends Application.AppBase {
    private const UI_UPDATE_PERIOD_MS = 250;

    private var _channelManager as BurstChannelManager;
    private var _uiTimer as Timer.Timer;

    //! Constructor.
    public function initialize() {
        AppBase.initialize();
        _channelManager = new $.BurstChannelManager();
        _uiTimer = new Timer.Timer();
    }

    //! Handle app startup
    //! @param state Startup arguments
    public function onStart(state as Dictionary?) as Void {
        _uiTimer.start(method(:updateScreen), UI_UPDATE_PERIOD_MS, true);
    }

    //! Handle app shutdown
    //! @param state Shutdown arguments
    public function onStop(state as Dictionary?) as Void {
        _uiTimer.stop();
    }

    //! Return the initial views for the app
    //! @return Array Pair [View, InputDelegate]
    public function getInitialView() as Array<Views or InputDelegates>? {
        return [
            new $.GenericChannelBurstView(_channelManager),
            new $.GenericChannelBurstDelegate(_channelManager),
        ] as Array<Views or InputDelegates>;
    }

    //! A wrapper function to allow the timer to request a screen update
    public function updateScreen() as Void {
        WatchUi.requestUpdate();
    }
}
