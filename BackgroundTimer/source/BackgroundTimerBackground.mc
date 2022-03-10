//
// Copyright 2017-2021 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//

import Toybox.Application.Storage;
import Toybox.Background;
import Toybox.Lang;
import Toybox.System;

//! The Service Delegate is the main entry point for background processes.
//! Our onTemporalEvent() method will run each time our periodic event
//! is triggered by the system. This indicates a set timer has expired, and
//! we should attempt to notify the user.
(:background)
class BackgroundTimerServiceDelegate extends System.ServiceDelegate {

    //! Constructor
    public function initialize() {
        ServiceDelegate.initialize();
    }

    //! If our timer expires, it means the application timer ran out,
    //! and the main application is not open. Prompt the user to let them
    //! know the timer expired.
    public function onTemporalEvent() as Void {

        // Use background resources if they are available
        if (Application has :loadResource) {
            Background.requestApplicationWake(Application.loadResource($.Rez.Strings.TimerExpired) as String);
        } else {
            Background.requestApplicationWake("Your timer has expired!");
        }

        // Write to Storage, this will trigger onStorageChanged() method in foreground app
        if (Application has :onStorageChanged) {
            Storage.setValue("1", 1);
        }

        Background.exit(true);
    }
}
