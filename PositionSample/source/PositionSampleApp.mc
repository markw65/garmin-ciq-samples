//!
//! Copyright 2015-2021 by Garmin Ltd. or its subsidiaries.
//! Subject to Garmin SDK License Agreement and Wearables
//! Application Developer Agreement.
//!

import Toybox.Application;
import Toybox.Lang;
import Toybox.Position;
import Toybox.WatchUi;

//! This app displays information about the user's position
class PositionSampleApp extends Application.AppBase {
    private var _positionView as PositionSampleView;

    //! Constructor
    public function initialize() {
        AppBase.initialize();
        _positionView = new $.PositionSampleView();
    }

    //! Handle app startup
    //! @param state Startup arguments
    public function onStart(state as Dictionary?) as Void {
        Position.enableLocationEvents(
            Position.LOCATION_CONTINUOUS,
            method(:onPosition)
        );
    }

    //! Handle app shutdown
    //! @param state Shutdown arguments
    public function onStop(state as Dictionary?) as Void {
        Position.enableLocationEvents(
            Position.LOCATION_DISABLE,
            method(:onPosition)
        );
    }

    //! Update the current position
    //! @param info Position information
    public function onPosition(info as Info) as Void {
        _positionView.setPosition(info);
    }

    //! Return the initial view for the app
    //! @return Array [View]
    public function getInitialView() as Array<Views or InputDelegates>? {
        return [_positionView] as Array<Views>;
    }
}
