//!
//! Copyright 2015-2021 by Garmin Ltd. or its subsidiaries.
//! Subject to Garmin SDK License Agreement and Wearables
//! Application Developer Agreement.
//!

import Toybox.Graphics;
import Toybox.Position;
import Toybox.WatchUi;

//! This view displays the position information
class PositionSampleView extends WatchUi.View {
    private var _posnInfo as Info?;

    //! Constructor
    public function initialize() {
        View.initialize();
    }

    //! Load your resources here
    //! @param dc Device context
    public function onLayout(dc as Dc) as Void {}

    //! Handle view being hidden
    public function onHide() as Void {}

    //! Restore the state of the app and prepare the view to be shown
    public function onShow() as Void {}

    //! Update the view
    //! @param dc Device context
    public function onUpdate(dc as Dc) as Void {
        // Set background color
        dc.setColor(Graphics.COLOR_TRANSPARENT, Graphics.COLOR_BLACK);
        dc.clear();
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        var posnInfo = _posnInfo;
        if (posnInfo != null) {
            var position = posnInfo.position;
            if (position != null) {
                var string =
                    "Location lat = " + position.toDegrees()[0].toString();
                dc.drawText(
                    dc.getWidth() / 2,
                    dc.getHeight() / 2 - 40,
                    Graphics.FONT_SMALL,
                    string,
                    Graphics.TEXT_JUSTIFY_CENTER
                );
                string =
                    "Location long = " + position.toDegrees()[1].toString();
                dc.drawText(
                    dc.getWidth() / 2,
                    dc.getHeight() / 2 - 20,
                    Graphics.FONT_SMALL,
                    string,
                    Graphics.TEXT_JUSTIFY_CENTER
                );
            }

            var speed = posnInfo.speed;
            if (speed != null) {
                var string = "speed = " + speed.toString();
                dc.drawText(
                    dc.getWidth() / 2,
                    dc.getHeight() / 2,
                    Graphics.FONT_SMALL,
                    string,
                    Graphics.TEXT_JUSTIFY_CENTER
                );
            }

            var altitude = posnInfo.altitude;
            if (altitude != null) {
                var string = "alt = " + altitude.toString();
                dc.drawText(
                    dc.getWidth() / 2,
                    dc.getHeight() / 2 + 20,
                    Graphics.FONT_SMALL,
                    string,
                    Graphics.TEXT_JUSTIFY_CENTER
                );
            }

            var heading = posnInfo.heading;
            if (heading != null) {
                var string = "heading = " + heading.toString();
                dc.drawText(
                    dc.getWidth() / 2,
                    dc.getHeight() / 2 + 40,
                    Graphics.FONT_SMALL,
                    string,
                    Graphics.TEXT_JUSTIFY_CENTER
                );
            }
        } else {
            dc.drawText(
                dc.getWidth() / 2,
                dc.getHeight() / 2,
                Graphics.FONT_SMALL,
                "No position info",
                Graphics.TEXT_JUSTIFY_CENTER
            );
        }
    }

    //! Set the position
    //! @param info Position information
    public function setPosition(info as Info) as Void {
        _posnInfo = info;
        WatchUi.requestUpdate();
    }
}
