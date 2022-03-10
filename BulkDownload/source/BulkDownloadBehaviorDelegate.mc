//
// Copyright 2019-2021 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//

import Toybox.Application.Storage;
import Toybox.Communications;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;

//! Handle input on the main view
class BulkDownloadBehaviorDelegate extends WatchUi.BehaviorDelegate {
    private var _view as BulkDownloadView;

    //! Constructor
    //! @param view The app view
    public function initialize(view as BulkDownloadView) {
        BehaviorDelegate.initialize();
        _view = view;
    }

    //! Handle selection request
    //! @return true if handled, false otherwise
    public function onSelect() as Boolean {

        var hasWiFiSupport = false;
        var hasLteSupport = false;

        var possibleConnection = false;

        var deviceSettings = System.getDeviceSettings();
        var wifiStatus = deviceSettings.connectionInfo[:wifi];
        if (wifiStatus != null) {
            hasWiFiSupport = true;

            if (wifiStatus.state != System.CONNECTION_STATE_NOT_INITIALIZED) {
                possibleConnection = true;
            }
        }

        var lteStatus = deviceSettings.connectionInfo[:lte];
        if (lteStatus != null) {
            hasLteSupport = true;

            if (lteStatus.state != System.CONNECTION_STATE_NOT_INITIALIZED) {
                possibleConnection = true;
            }
        }

        if (possibleConnection) {
            Communications.startSync();
            _view.setText(["Sync", "Complete"] as Array<String>);
        } else if (hasWiFiSupport && !hasLteSupport) {
            _view.setText(["WiFi", "Not", "Configured"] as Array<String>);
        } else if (!hasWiFiSupport && hasLteSupport) {
            _view.setText(["LTE", "Not", "Configured"] as Array<String>);
        } else {
            _view.setText(["WiFi/LTE", "Not", "Configured"] as Array<String>);
        }

        WatchUi.requestUpdate();
        return true;
    }

    //! Handle menu request
    //! @return true if handled, false otherwise
    public function onMenu() as Boolean {
        Storage.deleteValue($.ID_COLORS_TO_DOWNLOAD);
        Storage.setValue($.ID_TOTAL_SUCCESSFUL_DOWNLOADS, 0);
        _view.setText(["Reset", "Successful"] as Array<String>);

        WatchUi.requestUpdate();
        return true;
    }
}
