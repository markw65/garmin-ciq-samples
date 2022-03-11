//
// Copyright 2019-2021 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//

import Toybox.Application.Storage;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.WatchUi;

//! Display the current download status
class BulkDownloadView extends WatchUi.View {
    private var _lines as Array<String>;

    //! Constructor
    public function initialize() {
        View.initialize();
        _lines = ["Start/Stop to Sync", "Menu to Reset"] as Array<String>;
    }

    //! Display text and successful download count
    //! @param dc Device context
    public function onUpdate(dc as Dc) as Void {
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
        dc.clear();

        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);

        var font = Graphics.FONT_SMALL;
        var cx = dc.getWidth() / 2;
        var cy = dc.getHeight() / 2;
        var dy = dc.getFontHeight(font);

        cy -= (_lines.size() * dy) / 2;
        for (var i = 0; i < _lines.size(); ++i) {
            dc.drawText(
                cx,
                cy,
                font,
                _lines[i],
                Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER
            );
            cy += dy;
        }

        var successfulDownloads = Storage.getValue(
            $.ID_TOTAL_SUCCESSFUL_DOWNLOADS
        );
        if (successfulDownloads instanceof Number) {
            if (successfulDownloads > 0) {
                var downloadStatus = Lang.format("$1$ downloaded", [
                    successfulDownloads,
                ]);
                dc.drawText(
                    cx,
                    cy,
                    font,
                    downloadStatus,
                    Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER
                );
            }
        }
    }

    //! Set an array of strings to display
    //! @param displayText Strings to display
    public function setText(displayText as Array<String>) as Void {
        _lines = displayText;
        WatchUi.requestUpdate();
    }
}
