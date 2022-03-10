//
// Copyright 2018-2021 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//

import Toybox.Lang;
import Toybox.WatchUi;

//! Input handler to respond to menu selections
class MapSampleMenuDelegate extends WatchUi.MenuInputDelegate {

    //! Constructor
    public function initialize() {
        MenuInputDelegate.initialize();
    }

    //! Push the map view corresponding to the selected menu item
    //! @param item Symbol identifier of the menu item that was chosen
    public function onMenuItem(item as Symbol) as Void {
        if (item == :view_map) {
            var mapView = new $.MapSampleMapView();
            WatchUi.pushView(mapView, new $.MapSampleMapDelegate(mapView), WatchUi.SLIDE_UP);
        } else if (item == :track_map) {
            var trackView = new $.MapSampleTrackView();
            WatchUi.pushView(trackView, new $.MapSampleMapDelegate(trackView), WatchUi.SLIDE_UP);
        } else {
            WatchUi.requestUpdate();
        }
    }
}