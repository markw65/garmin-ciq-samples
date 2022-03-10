//
// Copyright 2019-2021 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//

import Toybox.Lang;
import Toybox.WatchUi;

class ScanDelegate extends WatchUi.BehaviorDelegate {
    private var _scanDataModel as ScanDataModel;
    private var _viewController as ViewController;

    //! Constructor
    //! @param scanDataModel The model containing the scan results
    //! @param viewController Object that controls pushing new views
    public function initialize(scanDataModel as ScanDataModel, viewController as ViewController) {
        BehaviorDelegate.initialize();

        _scanDataModel = scanDataModel;
        _viewController = viewController;
    }

    //! Handle menu button press
    //! @return true if handled, false otherwise
    public function onMenu() as Boolean {
        _viewController.pushScanMenu();
        return true;
    }

    //! Handle the select action
    //! @return true if handled, false otherwise
    public function onSelect() as Boolean {
        var displayResult = _scanDataModel.getDisplayResult();
        if (null != displayResult) {
            _viewController.pushDeviceView(displayResult);
        }
        return true;
    }

    //! Handle next page behavior
    //! @return true if handled, false otherwise
    public function onNextPage() as Boolean {
        _scanDataModel.nextResult();
        return true;
    }

    //! Handle previous page behavior
    //! @return true if handled, false otherwise
    public function onPreviousPage() as Boolean {
        _scanDataModel.previousResult();
        return true;
    }
}
