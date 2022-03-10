//
// Copyright 2015-2021 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//

import Toybox.Application;
import Toybox.Lang;
import Toybox.Position;
import Toybox.WatchUi;

//! This app starts a FIT recording on a menu press and then
//! stops and saves it on the next menu press.
class RecordSampleApp extends Application.AppBase {

    private var _recordSampleView as RecordSampleView?;

    //! Constructor
    public function initialize() {
        AppBase.initialize();
    }

    //! Handle app startup and enable location events to make sure GPS is on
    //! @param state Startup arguments
    public function onStart(state as Dictionary?) as Void {
        Position.enableLocationEvents(Position.LOCATION_CONTINUOUS, method(:onPosition));
    }

    //! Handle app shutdown
    //! @param state Shutdown arguments
    public function onStop(state as Dictionary?) as Void {
        var recordSampleView = _recordSampleView;
        if (recordSampleView != null) {
            recordSampleView.stopRecording();
        }
        Position.enableLocationEvents(Position.LOCATION_DISABLE, method(:onPosition));
    }

    //! Handle location updates
    //! @param info Position.Info object
    public function onPosition(info as Info) as Void {
    }

    //! Return the initial view for the app
    //! @return Array Pair [View, InputDelegate]
    public function getInitialView() as Array<Views or InputDelegates>? {
        _recordSampleView = new $.RecordSampleView();
        return [_recordSampleView, new $.BaseInputDelegate(_recordSampleView)] as Array<Views or InputDelegates>;
    }

}