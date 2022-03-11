//
// Copyright 2019-2021 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//

import Toybox.Application.Storage;
import Toybox.Communications;
import Toybox.Lang;

//! Responds to sync requests
class BulkDownloadDelegate extends Communications.SyncDelegate {
    private var _colors as Array<Number>;

    private var _colorsDownloaded as Number;
    private var _colorsToDownload as Number;

    //! Constructor
    public function initialize() {
        SyncDelegate.initialize();

        var colors = Storage.getValue($.ID_COLORS_TO_DOWNLOAD);
        if (colors != null) {
            _colors = colors as Array<Number>;
        } else {
            _colors = [
                0xffffff, 0xaaaaaa, 0x555555, 0xff0000, 0xaa0000, 0xff5500,
                0xffaa00, 0x00ff00, 0x00aa00, 0x00aaff, 0x0000ff, 0xaa00ff,
                0xff00ff,
            ] as Array<Number>;
        }

        _colorsDownloaded = 0;
        _colorsToDownload = 0;
    }

    //! Called by the system to determine if a sync is needed
    //! @return true if sync is needed, false otherwise
    public function isSyncNeeded() as Boolean {
        return _colors.size() != 0;
    }

    //! Called by the system when starting a bulk sync.
    public function onStartSync() as Void {
        _colorsToDownload = _colors.size();

        startNextDownload();
    }

    //! Called by the system when finishing a bulk sync.
    public function onStopSync() as Void {
        Communications.cancelAllRequests();
        Communications.notifySyncComplete(null);
    }

    //! Start processing the next download, or terminate syncing.
    private function startNextDownload() as Void {
        if (_colors.size() == 0) {
            Communications.notifySyncComplete(null);
        } else {
            downloadColor(_colors[0]);
        }
    }

    //! Initiate a request to download an image of the given color
    //! @param colorId The id of the color to download
    private function downloadColor(colorId as Number) as Void {
        var params = {};

        var options = {
            :dithering => Communications.IMAGE_DITHERING_NONE,
        };

        var deviceSettings = System.getDeviceSettings();

        var downloadUrl = Lang.format(
            "https://dummyimage.com/$1$x$2$/$3$.png",
            [
                deviceSettings.screenWidth,
                deviceSettings.screenHeight,
                colorId.format("%06X"),
            ]
        );

        // create a request delegate so we can associate colorId with the
        // downloaded image
        var requestDelegate = new $.BulkDownloadRequestDelegate(
            self.method(:onDownloadComplete)
        );
        requestDelegate.makeImageRequest(downloadUrl, params, options);
    }

    //! Handle download completion
    //! @param code The server response code or BLE error
    public function onDownloadComplete(code as Number) as Void {
        if (code == 200) {
            // download was successful, so remove it from the pending list
            _colors = _colors.slice(1, null);
            Storage.setValue($.ID_COLORS_TO_DOWNLOAD, _colors);

            // cache the count of successful downloads
            var successfulDownloads = Storage.getValue(
                $.ID_TOTAL_SUCCESSFUL_DOWNLOADS
            );
            if (successfulDownloads instanceof Number) {
                ++successfulDownloads;
                Storage.setValue(
                    $.ID_TOTAL_SUCCESSFUL_DOWNLOADS,
                    successfulDownloads
                );
            }

            // update the progress indicator
            ++_colorsDownloaded;
            Communications.notifySyncProgress(
                (100 * _colorsDownloaded) / _colorsToDownload
            );

            // start the next download, or terminate syncing
            startNextDownload();
        } else {
            Communications.notifySyncComplete(
                Lang.format("Error: $1$", [code])
            );
        }
    }
}
