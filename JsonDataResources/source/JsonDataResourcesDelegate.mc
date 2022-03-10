//
// Copyright 2016-2021 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//

import Toybox.Lang;
import Toybox.WatchUi;

//! Handle input for the JsonResourcesView
class BaseInputDelegate extends WatchUi.BehaviorDelegate {
    private var _jsonRecordIndex as Number = 0;

    // An array of all defined JSON resource record IDs
    // Note that these do not get loaded into memory until
    // WatchUi.loadResource is called on one of them.
    private const _jsonResourceIds =
        [
        $.Rez.JsonData.arrayResource,
        $.Rez.JsonData.dictionaryResource,
        $.Rez.JsonData.mixedArrayResource,
        $.Rez.JsonData.singleValue,
        $.Rez.JsonData.dictionaryFromFile,
        $.Rez.JsonData.arrayFromFile
        ] as Array<Symbol>;

    private var _view as JsonDataResourcesView;

    //! Constructor
    //! @param view The JsonResourcesView to operate on
    public function initialize(view as JsonDataResourcesView) {
        BehaviorDelegate.initialize();
        _view = view;
    }

    //! Handle the menu event
    //! @return true if handled, false otherwise
    public function onMenu() as Boolean {
        if (_jsonRecordIndex == (_jsonResourceIds.size() - 1)) {
            _jsonRecordIndex = 0;
        } else {
            _jsonRecordIndex++;
        }

        _view.loadJsonRecord(_jsonResourceIds[_jsonRecordIndex]);
        return true;
    }
}