//
// Copyright 2017-2021 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//

import Toybox.Graphics;
import Toybox.Lang;
import Toybox.Timer;
import Toybox.WatchUi;

//! Show the AntSensor data
class AntView extends WatchUi.View {

    private const _uiUpdatePeriodMs = 500;

    private var _sensor as AntModule.AntSensor;
    private var _uiTimer as Timer.Timer;

    //! Constructor
    //! @param antSensor an AntModule.AntSensor
    public function initialize(antSensor as AntModule.AntSensor) {
        // Initializes parent
        View.initialize();

        // Set class variables
        _sensor = antSensor;
        _uiTimer = new Timer.Timer();
    }

    //! Stop the ui timer when the screen is no longer being displayed
    public function onHide() as Void {
        _uiTimer.stop();
    }

    //! Loads layout
    //! @param dc Device Context
    public function onLayout(dc as Dc) as Void {
        setLayout($.Rez.Layouts.AntView(dc));
        // The default title for the page is "Slave" if the channel is master, update the title to "Master"
        if (_sensor.isMaster()) {
            (View.findDrawableById("antChannelType") as Text).setText(WatchUi.loadResource($.Rez.Strings.Master) as String);
        }
    }

    //! Start the ui timer when the view is displayed
    public function onShow() as Void {
        _uiTimer.start(method(:updateScreen), _uiUpdatePeriodMs, true);
    }

    //! Update the view
    //! @param dc Device Context
    public function onUpdate(dc as Dc) as Void {
        if (true == _sensor.isSearching()) {
                // If channel is in searching state display a red searching label
                (View.findDrawableById("status") as Text).setColor(Graphics.COLOR_RED);
                (View.findDrawableById("status") as Text).setText(WatchUi.loadResource($.Rez.Strings.Searching) as String);
        } else {
            if (true == _sensor.isEncrypted()) {
                // If the channel is encrypted display a green encrypted label
                (View.findDrawableById("status") as Text).setColor(Graphics.COLOR_GREEN);
                (View.findDrawableById("status") as Text).setText(WatchUi.loadResource($.Rez.Strings.Encrypted) as String + _sensor.getDeviceConfig().deviceNumber.toString());
            } else {
                // If the channel is not encrypted display a red encrypted label
                (View.findDrawableById("status") as Text).setColor(Graphics.COLOR_RED);
                (View.findDrawableById("status") as Text).setText(WatchUi.loadResource($.Rez.Strings.Unencrypted) as String + _sensor.getDeviceConfig().deviceNumber.toString());
            }
            // Update the data label value
            (View.findDrawableById("data") as Text).setText(_sensor.getData());
        }
        // Call the parent onUpdate function to redraw the layout
        View.onUpdate(dc);
    }

    //! A wrapper function to allow the timer to request a screen update
    public function updateScreen() as Void {
        WatchUi.requestUpdate();
    }
}