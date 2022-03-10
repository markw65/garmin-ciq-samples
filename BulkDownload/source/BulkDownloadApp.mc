//
// Copyright 2019-2021 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//

import Toybox.Application;
import Toybox.Application.Storage;
import Toybox.Communications;
import Toybox.Lang;
import Toybox.WatchUi;

const ID_TOTAL_SUCCESSFUL_DOWNLOADS = 's';
const ID_COLORS_TO_DOWNLOAD = 'p';

//! This app demonstrates how to use the bulk download
//! features in the Communications API.
class BulkDownloadApp extends Application.AppBase {

    //! Constructor
    public function initialize() {
        AppBase.initialize();
    }

    //! Handle app startup
    //! @param state Startup arguments
    public function onStart(state as Dictionary?) as Void {
    }

    //! Handle app shutdown
    //! @param state Shutdown arguments
    public function onStop(state as Dictionary?) as Void {
    }

    //! Return the initial view for the app
    //! @return Array Pair [View, Delegate]
    public function getInitialView() as Array<Views or InputDelegates>? {

        // Initialize the successful download count to 0
        var successfulDownloads = Storage.getValue($.ID_TOTAL_SUCCESSFUL_DOWNLOADS);
        if (successfulDownloads == null) {
            Storage.setValue($.ID_TOTAL_SUCCESSFUL_DOWNLOADS, 0);
        }

        var view = new $.BulkDownloadView();
        return [view, new $.BulkDownloadBehaviorDelegate(view)] as Array<Views or InputDelegates>;
    }

    //! getSyncDelegate is called by the system when a request is made
    //! to start a bulk data sync via Communications.startSync()
    //! @return The sync delegate to use
    public function getSyncDelegate() as SyncDelegate? {
        return new $.BulkDownloadDelegate();
    }

}
