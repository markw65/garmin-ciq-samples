//
// Copyright 2016-2021 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//

import Toybox.Lang;
import Toybox.WatchUi;

//! Input delegate for the ball view
class AccelMagDelegate extends WatchUi.BehaviorDelegate {
    private var _parentView as AccelMagView;

    //! Constructor
    //! @param view The AccelMagView to operate on
    public function initialize(view as AccelMagView) {
        BehaviorDelegate.initialize();
        _parentView = view;
    }

    //! Kick the ball when they do a select action.
    //! @return true if event was handled, false otherwise
    public function onSelect() as Boolean {
        _parentView.kickBall();
        return true;
    }
}