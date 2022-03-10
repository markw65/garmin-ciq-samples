//
// Copyright 2015-2021 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//

import Toybox.Lang;
import Toybox.WatchUi;

//! Input handler for the main primate views
class PrimatesDelegate extends WatchUi.BehaviorDelegate {
    private var _index as Number;
    private const NUM_PAGES = 3;

    //! Constructor
    //! @param index The current page index
    public function initialize(index as Number) {
        BehaviorDelegate.initialize();
        _index = index;
    }

    //! Handle going to the next view
    //! @return true if handled, false otherwise
    public function onNextPage() as Boolean {
        var nextPage = (_index + 1) % NUM_PAGES;
        var view = new $.PrimatesView(nextPage);
        var delegate = new $.PrimatesDelegate(nextPage);
        WatchUi.switchToView(view, delegate, WatchUi.SLIDE_LEFT);

        return true;
    }

    //! Handle going to the previous view
    //! @return true if handled, false otherwise
    public function onPreviousPage() as Boolean {
        var prevPage = (_index + NUM_PAGES - 1) % NUM_PAGES;
        var view = new $.PrimatesView(prevPage);
        var delegate = new $.PrimatesDelegate(prevPage);
        WatchUi.switchToView(view, delegate, WatchUi.SLIDE_RIGHT);

        return true;
    }

    //! On select behavior show the detail view
    //! @return true if handled, false otherwise
    public function onSelect() as Boolean {
        if (_index == 0) {
            WatchUi.pushView(new $.ApesView(), new $.DetailsDelegate(), WatchUi.SLIDE_UP);
        } else if (_index == 1) {
            WatchUi.pushView(new $.MonkeysView(), new $.DetailsDelegate(), WatchUi.SLIDE_UP);
        } else if (_index == 2) {
            WatchUi.pushView(new $.ProsimiansView(), new $.DetailsDelegate(), WatchUi.SLIDE_UP);
        }
        return true;
    }
}
