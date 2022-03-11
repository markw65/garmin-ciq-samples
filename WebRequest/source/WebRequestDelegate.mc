//
// Copyright 2016-2021 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//

import Toybox.Communications;
import Toybox.Lang;
import Toybox.WatchUi;

//! Creates a web request on menu / select events
class WebRequestDelegate extends WatchUi.BehaviorDelegate {
    private var _notify as Method(args as Dictionary or String or Null) as Void;

    //! Set up the callback to the view
    //! @param handler Callback method for when data is received
    public function initialize(
        handler as Method(args as Dictionary or String or Null) as Void
    ) {
        WatchUi.BehaviorDelegate.initialize();
        _notify = handler;
    }

    //! On a menu event, make a web request
    //! @return true if handled, false otherwise
    public function onMenu() as Boolean {
        makeRequest();
        return true;
    }

    //! On a select event, make a web request
    //! @return true if handled, false otherwise
    public function onSelect() as Boolean {
        makeRequest();
        return true;
    }

    //! Make the web request
    private function makeRequest() as Void {
        _notify.invoke("Executing\nRequest");

        var options = {
            :responseType => Communications.HTTP_RESPONSE_CONTENT_TYPE_JSON,
            :headers
            =>
            {
                "Content-Type"
                =>
                Communications.REQUEST_CONTENT_TYPE_URL_ENCODED,
            },
        };

        Communications.makeWebRequest(
            "https://jsonplaceholder.typicode.com/todos/115",
            {},
            options,
            method(:onReceive)
        );
    }

    //! Receive the data from the web request
    //! @param responseCode The server response code
    //! @param data Content from a successful request
    public function onReceive(
        responseCode as Number,
        data as Dictionary?
    ) as Void {
        if (responseCode == 200) {
            _notify.invoke(data);
        } else {
            _notify.invoke("Failed to load\nError: " + responseCode.toString());
        }
    }
}
