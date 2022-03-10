//
// Copyright 2019-2021 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//

import Toybox.Graphics;
import Toybox.WatchUi;

class ScanView extends WatchUi.View {
    private var _scanDataModel as ScanDataModel;

    //! Constructor
    //! @param scanDataModel The model containing the scan results
    public function initialize(scanDataModel as ScanDataModel) {
        View.initialize();

        _scanDataModel = scanDataModel;
    }

    //! Load your resources here
    //! @param dc Device context
    public function onLayout(dc as Dc) as Void {
    }

    //! Called when this View is brought to the foreground. Restore
    //! the state of this View and prepare it to be shown. This includes
    //! loading resources into memory.
    public function onShow() as Void {
    }

    //! Update the view
    //! @param dc Device context
    public function onUpdate(dc as Dc) as Void {
        var displayResult = _scanDataModel.getDisplayResult();

        var str = "Device: " + _scanDataModel.getDisplayIndex() + "/" + _scanDataModel.getResultCount();

        if (null != displayResult) {
            str += "\nName:\n" + displayResult.getDeviceName() + "\nRSSI: " + displayResult.getRssi() + " dbm";
        }

        var strDimen = dc.getTextDimensions(str, Graphics.FONT_SMALL);
        var textOffset = dc.getHeight() / 2;
        textOffset -= strDimen[1] / 2;

        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_WHITE);
        dc.clear();
        dc.drawText(dc.getWidth() / 2, textOffset, Graphics.FONT_SMALL, str, Graphics.TEXT_JUSTIFY_CENTER);
    }

    //! Called when this View is removed from the screen. Save the
    //! state of this View here. This includes freeing resources from
    //! memory.
    public function onHide() as Void {
    }

}
