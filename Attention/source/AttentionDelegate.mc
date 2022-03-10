//
// Copyright 2015-2021 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//

import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;

//! Input handler for the attention view
class AttentionDelegate extends WatchUi.InputDelegate {
    private var _view as AttentionView;

    //! Constructor
    //! @param view The app view
    public function initialize(view as AttentionView) {
        InputDelegate.initialize();
        _view = view;
    }

    //! Handle key events
    //! @param evt The key event that occurred
    //! @return true if handled, false otherwise
    public function onKey(evt as KeyEvent) as Boolean {
        var key = evt.getKey();
        if (WatchUi.KEY_DOWN == key) {
            _view.incIndex();
        } else if (WatchUi.KEY_UP == key) {
            _view.decIndex();
        } else if (WatchUi.KEY_ENTER == key) {
            _view.action();
        } else if (WatchUi.KEY_START == key) {
            _view.action();
        } else {
            return false;
        }
        WatchUi.requestUpdate();
        return true;
    }

    //! Handle touchscreen taps
    //! @param evt The click event that occurred
    //! @return true if handled, false otherwise
    public function onTap(evt as ClickEvent) as Boolean {
        if (WatchUi.CLICK_TYPE_TAP == evt.getType()) {
            var coords = evt.getCoordinates();
            _view.setIndexFromYVal(coords[1]);
            WatchUi.requestUpdate();
            _view.action();
        }
        return true;
    }

    //! Handle enter events
    //! @return true if handled, false otherwise
    public function onSelect() as Boolean {
        _view.action();
        return true;
    }

    // Handle swipe events
    //! @param evt The swipe event that occurred
    //! @return true if handled, false otherwise
    public function onSwipe(evt as SwipeEvent) as Boolean {
        var direction = evt.getDirection();
        if (WatchUi.SWIPE_DOWN == direction) {
            _view.incIndex();
        } else if (WatchUi.SWIPE_UP == direction) {
            _view.decIndex();
        } else if (WatchUi.SWIPE_LEFT == direction) {
            _view.decIndex();
        } else if (WatchUi.SWIPE_RIGHT == direction) {
            _view.incIndex();
        }
        WatchUi.requestUpdate();
        return true;
    }

}
