//
// Copyright 2016-2021 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//

import Toybox.ActivityMonitor;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.WatchUi;

//! Show the activity monitor history
class HistoryView extends WatchUi.View {

    //! Constructor
    public function initialize() {
        View.initialize();
    }

    //! Load the layout
    //! @param dc Draw context
    public function onLayout(dc as Dc) as Void {
        setLayout($.Rez.Layouts.HistoryLayout(dc));
    }

    //! Handle the update event
    //! @param dc Draw context
    public function onUpdate(dc as Dc) as Void {
        View.onUpdate(dc);

        var actHistArray = ActivityMonitor.getHistory();
        var padding = 5;
        var string = "";
        var fontHeight = Graphics.getFontHeight(Graphics.FONT_TINY);

        if (actHistArray.size() > 0) {
            dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
            // Loop through array of history items
            for (var i = 0; i < actHistArray.size(); i += 1) {
                dc.drawText(padding, padding + fontHeight * (i + 2), Graphics.FONT_TINY, (i + 1).toString(), Graphics.TEXT_JUSTIFY_LEFT);
                var curHistory = actHistArray[i];
                // Validate that each element is non-null
                if (null != curHistory) {
                    var steps = curHistory.steps;
                    var stepGoal = curHistory.stepGoal;
                    if ((null != steps) && (null != stepGoal)) {
                        string = steps.toString() + " / " + stepGoal.toString();
                        dc.drawText(dc.getWidth() / 2, padding + fontHeight * (i + 2), Graphics.FONT_TINY, string, Graphics.TEXT_JUSTIFY_CENTER);
                        // Check if the device supports floors climbed info and validate that element is non-null
                        if (curHistory has :floorsClimbed) {
                            var floorsClimbed = curHistory.floorsClimbed;
                            if (null != floorsClimbed) {
                                dc.drawText(dc.getWidth(), padding + fontHeight * (i + 2), Graphics.FONT_TINY, floorsClimbed.toString(), Graphics.TEXT_JUSTIFY_RIGHT);
                            }
                        }
                    }
                }
            }
        }
    }
}