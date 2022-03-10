//
// Copyright 2016-2021 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//

import Toybox.Lang;
import Toybox.WatchUi;

class GenericChannelBurstDelegate extends WatchUi.BehaviorDelegate {

    private var _channelManager as BurstChannelManager;

    //! Constructor
    //! @param aChannelManager The channel manager in use
    public function initialize(aChannelManager as BurstChannelManager) {
        _channelManager = aChannelManager;
        BehaviorDelegate.initialize();
    }

    //! Sends a burst message when the menu button is pressed
    //! @return true if handled, false otherwise
    public function onMenu() as Boolean {
        _channelManager.sendBurst();
        return true;
    }

}