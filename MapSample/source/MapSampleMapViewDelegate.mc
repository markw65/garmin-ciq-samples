//
// Copyright 2018-2021 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//

import Toybox.Lang;
import Toybox.WatchUi;

//! Input handler for the map views
class MapSampleMapDelegate extends WatchUi.BehaviorDelegate {

    private var _view as MapView;

    //! Constructor
    //! @param view The associated map view
    public function initialize(view as MapView) {
        BehaviorDelegate.initialize();
        _view = view;
    }

    //! Handle the back event
    //! @return true if handled, false otherwise
    public function onBack() as Boolean {
        // if current mode is preview mode them pop the view
        if (_view.getMapMode() == WatchUi.MAP_MODE_PREVIEW) {
            WatchUi.popView(WatchUi.SLIDE_UP);
        } else {
            // if browse mode change the mode to preview
            _view.setMapMode(WatchUi.MAP_MODE_PREVIEW);
        }
        return true;
    }

    //! Handle the select button
    //! @return true if handled, false otherwise
    public function onSelect() as Boolean {
        // on enter button press change the map view to browse mode
        _view.setMapMode(WatchUi.MAP_MODE_BROWSE);
        return true;
    }
}