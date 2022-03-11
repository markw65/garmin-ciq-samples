//
// Copyright 2016-2021 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//

import Toybox.Graphics;
import Toybox.Lang;
import Toybox.WatchUi;

//! Show the pitch counter data
class PitchCounterView extends WatchUi.View {
    private var _labelCount as Text?;
    private var _labelSamples as Text?;
    private var _labelPeriod as Text?;
    private var _pitchCounter as PitchCounterProcess;

    //! Constructor
    public function initialize() {
        View.initialize();
        _pitchCounter = new $.PitchCounterProcess();
    }

    //! Set the layout
    //! @param dc Device context
    public function onLayout(dc) as Void {
        setLayout($.Rez.Layouts.MainLayout(dc));
        _labelCount = View.findDrawableById("id_pitch_count") as Text;
        _labelSamples = View.findDrawableById("id_pitch_samples") as Text;
        _labelPeriod = View.findDrawableById("id_pitch_period") as Text;
    }

    //! Called when this View is brought to the foreground. Restore
    //! the state of this View and prepare it to be shown. This includes
    //! loading resources into memory.
    public function onShow() as Void {
        _pitchCounter.onStart();
    }

    //! Update the view
    //! @param dc Device Context
    public function onUpdate(dc as Dc) as Void {
        var labelCount = _labelCount;
        if (labelCount != null) {
            labelCount.setText("Count: " + _pitchCounter.getCount());
        }

        var labelSamples = _labelSamples;
        if (labelSamples != null) {
            labelSamples.setText("Samples: " + _pitchCounter.getSamples());
        }

        var labelPeriod = _labelPeriod;
        if (labelPeriod != null) {
            labelPeriod.setText("Period: " + _pitchCounter.getPeriod());
        }
        View.onUpdate(dc);
    }

    //! Called when this View is removed from the screen. Save the
    //! state of this View here. This includes freeing resources from
    //! memory.
    public function onHide() as Void {
        _pitchCounter.onStop();
    }
}
