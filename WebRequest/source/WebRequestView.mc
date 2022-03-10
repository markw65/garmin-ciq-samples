//
// Copyright 2015-2021 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//

import Toybox.Graphics;
import Toybox.Lang;
import Toybox.WatchUi;

//! Shows the web request result
class WebRequestView extends WatchUi.View {
    private var _message as String = "Press menu or\nselect button";

    //! Constructor
    public function initialize() {
        WatchUi.View.initialize();
    }

    //! Load your resources here
    //! @param dc Device context
    public function onLayout(dc as Dc) as Void {
    }

    //! Restore the state of the app and prepare the view to be shown
    public function onShow() as Void {
    }

    //! Update the view
    //! @param dc Device Context
    public function onUpdate(dc as Dc) as Void {
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
        dc.clear();
        dc.drawText(dc.getWidth() / 2, dc.getHeight() / 2, Graphics.FONT_MEDIUM, _message, Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
    }

    //! Called when this View is removed from the screen. Save the
    //! state of your app here.
    public function onHide() as Void {
    }

    //! Show the result or status of the web request
    //! @param args Data from the web request, or error message
    public function onReceive(args as Dictionary or String or Null) as Void {
        if (args instanceof String) {
            _message = args;
        } else if (args instanceof Dictionary) {
            // Print the arguments duplicated and returned by jsonplaceholder.typicode.com
            var keys = args.keys();
            _message = "";
            for (var i = 0; i < keys.size(); i++) {
                _message += Lang.format("$1$: $2$\n", [keys[i], args[keys[i]]]);
            }
        }
        WatchUi.requestUpdate();
    }
}
