//
// Copyright 2018-2021 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//

import Toybox.Graphics;
import Toybox.Lang;
import Toybox.Position;
import Toybox.System;
import Toybox.WatchUi;

//! This view shows a map on the screen with markers and a polyline
class MapSampleMapView extends WatchUi.MapView {
    //! Constructor
    public function initialize() {
        MapView.initialize();

        // set the current mode for the map to be preview
        setMapMode(WatchUi.MAP_MODE_PREVIEW);

        // create a new polyline
        var polyline = new WatchUi.MapPolyline();

        // set the color of the line
        polyline.setColor(Graphics.COLOR_RED);

        // set width of the line
        polyline.setWidth(2);

        // add locations to the polyline
        polyline.addLocation(
            new Position.Location({
                :latitude => 38.85391,
                :longitude => -94.7963,
                :format => :degrees,
            })
        );
        polyline.addLocation(
            new Position.Location({
                :latitude => 38.85465,
                :longitude => -94.79922,
                :format => :degrees,
            })
        );
        polyline.addLocation(
            new Position.Location({
                :latitude => 38.85508,
                :longitude => -94.79959,
                :format => :degrees,
            })
        );
        polyline.addLocation(
            new Position.Location({
                :latitude => 38.85557,
                :longitude => -94.79864,
                :format => :degrees,
            })
        );
        polyline.addLocation(
            new Position.Location({
                :latitude => 38.85629,
                :longitude => -94.79882,
                :format => :degrees,
            })
        );
        polyline.addLocation(
            new Position.Location({
                :latitude => 38.85583,
                :longitude => -94.79942,
                :format => :degrees,
            })
        );
        polyline.addLocation(
            new Position.Location({
                :latitude => 38.85695,
                :longitude => -94.80051,
                :format => :degrees,
            })
        );

        // add the polyline to the map
        MapView.setPolyline(polyline);

        // create map markers array
        var map_markers = [] as Array<MapMarker>;

        // create a map marker at a location on the map
        var marker = new WatchUi.MapMarker(
            new Position.Location({
                :latitude => 38.85391,
                :longitude => -94.7963,
                :format => :degrees,
            })
        );
        marker.setIcon(
            WatchUi.loadResource($.Rez.Drawables.MapPin) as BitmapResource,
            12,
            24
        );
        marker.setLabel("Custom Icon");
        map_markers.add(marker);

        marker = new WatchUi.MapMarker(
            new Position.Location({
                :latitude => 38.85557,
                :longitude => -94.79864,
                :format => :degrees,
            })
        );
        marker.setIcon(
            WatchUi.loadResource($.Rez.Drawables.MapPin) as BitmapResource,
            12,
            24
        );
        marker.setLabel("Custom Icon");
        map_markers.add(marker);

        marker = new WatchUi.MapMarker(
            new Position.Location({
                :latitude => 38.85508,
                :longitude => -94.79959,
                :format => :degrees,
            })
        );
        marker.setIcon(WatchUi.MAP_MARKER_ICON_PIN, 0, 0);
        marker.setLabel("Predefined Icon");
        map_markers.add(marker);

        // add map markers to the map
        MapView.setMapMarker(map_markers);

        // create the bounding box for the map area
        var top_left = new Position.Location({
            :latitude => 38.85695,
            :longitude => -94.80051,
            :format => :degrees,
        });
        var bottom_right = new Position.Location({
            :latitude => 38.85391,
            :longitude => -94.7963,
            :format => :degrees,
        });
        MapView.setMapVisibleArea(top_left, bottom_right);

        // set the bound box for the screen area to focus the map on
        MapView.setScreenVisibleArea(
            0,
            0,
            System.getDeviceSettings().screenWidth,
            System.getDeviceSettings().screenHeight / 2
        );
    }

    //! Load your resources here
    //! @param dc Device context
    public function onLayout(dc as Dc) as Void {}

    //! Called when this View is brought to the foreground. Restore
    //! the state of this View and prepare it to be shown. This includes
    //! loading resources into memory.
    public function onShow() as Void {}

    //! Update the view
    //! @param dc Device context
    public function onUpdate(dc as Dc) as Void {
        // call the parent onUpdate function to redraw the layout
        MapView.onUpdate(dc);
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_TRANSPARENT);
        dc.drawText(
            dc.getWidth() / 2, // gets the width of the device and divides by 2
            dc.getHeight() / 2, // gets the height of the device and divides by 2
            Graphics.FONT_LARGE, // sets the font size
            "Hello World", // the String to display
            Graphics.TEXT_JUSTIFY_CENTER // sets the justification for the text
        );
    }
}
