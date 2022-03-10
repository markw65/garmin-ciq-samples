//
// Copyright 2015-2021 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//

import Toybox.Lang;
import Toybox.WatchUi;

class MO2Delegate extends WatchUi.InputDelegate {
    private var _index as Number;
    private var _sensor as MO2Sensor;

    //! Constructor
    //! @param sensor ANT channel and data
    //! @param index Number indicating the current view
    public function initialize(sensor as MO2Sensor, index as Number) {
        InputDelegate.initialize();

        _sensor = sensor;
        _index = index;
    }

    //! Go to the next page
    private function onNextPage() as Void {
        _index = (_index + 1) % 4;
        WatchUi.switchToView(getView(), getDelegate(), WatchUi.SLIDE_LEFT);
    }

    //! Go to the previous page
    private function onPreviousPage() as Void {
        _index = _index - 1;
        if (_index < 0) {
            _index = 3;
        }
        _index = _index % 4;
        WatchUi.switchToView(getView(), getDelegate(), WatchUi.SLIDE_RIGHT);
    }

    //! Handle the touch screen swipe event
    //! @param evt The swipe event that occurred
    //! @return true if handled, false otherwise
    public function onSwipe(evt as SwipeEvent) as Boolean {
        if (evt.getDirection() == WatchUi.SWIPE_LEFT) {
            onNextPage();
        } else if (evt.getDirection() == WatchUi.SWIPE_RIGHT) {
            onPreviousPage();
        }
        return true;
    }

    //! Handle a screen tap event
    //! @param evt The click event that occurred
    //! @return true if handled, false otherwise
    public function onTap(evt as ClickEvent) as Boolean {
        if (_index == 3) {
            _sensor.setTime();
        }
        return true;
    }

    //! Handle a physical button being pressed and released
    //! @param evt The key event that occurred
    //! @return true if handled, false otherwise
    public function onKey(evt as KeyEvent) as Boolean {
        var key = evt.getKey();
        if (WatchUi.KEY_DOWN == key) {
            onNextPage();
        } else if (WatchUi.KEY_UP == key) {
            onPreviousPage();
        }
        return true;
    }

    //! Get a new view based on the current index
    //! @return The view
    private function getView() as MainView or DataView or GraphView or CommandView {
        var view;

        if (0 == _index) {
            view = new $.MainView(_sensor, _index);
        } else if (1 == _index) {
            view = new $.DataView(_sensor, _index);
        } else if (2 == _index) {
            view = new $.GraphView(_sensor, _index);
        } else {
            view = new $.CommandView(_sensor, _index);
        }

        return view;
    }

    //! Get a new delegate
    //! @return The delegate
    private function getDelegate() as MO2Delegate {
        var delegate = new $.MO2Delegate(_sensor, _index);
        return delegate;
    }

}
