//
// Copyright 2015-2021 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//

import Toybox.FitContributor;
import Toybox.Lang;

class MO2FitContributor {
    // Field ids
    private enum FieldId {
        FIELD_CURR_HEMO_CONC,
        FIELD_LAP_HEMO_CONC,
        FIELD_AVG_HEMO_CONC,
        FIELD_CURR_HEMO_PERCENT,
        FIELD_LAP_HEMO_PERCENT,
        FIELD_AVG_HEMO_PERCENT
    }

    // Variables for computing averages
    private var _hCLapAverage as Numeric = 0.0;
    private var _hCSessionAverage as Numeric = 0.0;
    private var _hPLapAverage as Numeric = 0.0;
    private var _hPSessionAverage as Numeric = 0.0;
    private var _lapRecordCount as Number = 0;
    private var _sessionRecordCount as Number = 0;
    private var _timerRunning as Boolean = false;

    // FIT Contributions variables
    private var _currentHCField as Field;
    private var _lapAverageHCField as Field;
    private var _sessionAverageHCField as Field;
    private var _currentHPField as Field;
    private var _lapAverageHPField as Field;
    private var _sessionAverageHPField as Field;

    //! Constructor
    //! @param dataField Data field to use to create fields
    public function initialize(dataField as MO2Field) {
        _currentHCField = dataField.createField("currHemoConc", FIELD_CURR_HEMO_CONC, FitContributor.DATA_TYPE_UINT16, { :nativeNum=>54, :mesgType=>FitContributor.MESG_TYPE_RECORD, :units=>"g/dl" });
        _lapAverageHCField = dataField.createField("lapHemoConc", FIELD_LAP_HEMO_CONC, FitContributor.DATA_TYPE_UINT16, { :nativeNum=>84, :mesgType=>FitContributor.MESG_TYPE_LAP, :units=>"g/dl" });
        _sessionAverageHCField = dataField.createField("avgHemoConc", FIELD_AVG_HEMO_CONC, FitContributor.DATA_TYPE_UINT16, { :nativeNum=>95, :mesgType=>FitContributor.MESG_TYPE_SESSION, :units=>"g/dl" });

        _currentHPField = dataField.createField("currHemoPerc", FIELD_CURR_HEMO_PERCENT, FitContributor.DATA_TYPE_UINT16, { :nativeNum=>57, :mesgType=>FitContributor.MESG_TYPE_RECORD, :units=>"%" });
        _lapAverageHPField = dataField.createField("lapHemoConc", FIELD_LAP_HEMO_PERCENT, FitContributor.DATA_TYPE_UINT16, { :nativeNum=>87, :mesgType=>FitContributor.MESG_TYPE_LAP, :units=>"%" });
        _sessionAverageHPField = dataField.createField("avgHemoConc", FIELD_AVG_HEMO_PERCENT, FitContributor.DATA_TYPE_UINT16, { :nativeNum=>98, :mesgType=>FitContributor.MESG_TYPE_SESSION, :units=>"%" });

        _currentHCField.setData(0);
        _lapAverageHCField.setData(0);
        _sessionAverageHCField.setData(0);

        _currentHPField.setData(0);
        _lapAverageHPField.setData(0);
        _sessionAverageHPField.setData(0);

    }

    //! Update data and fields
    //! @param sensor The ANT channel and data
    public function compute(sensor as MO2Sensor?) as Void {
        if (sensor != null) {
            var hemoConc = sensor.getData().getTotalHemoConcentration();
            var hemoPerc = sensor.getData().getCurrentHemoPercent();

            // Hemoglobin Concentration is stored in 1/100ths g/dL fixed point
            _currentHCField.setData(toFixed(hemoConc, 100));
            // Saturated Hemoglobin Percent is stored in 1/10ths % fixed point
            _currentHPField.setData(toFixed(hemoPerc, 10));

            if (_timerRunning) {
                // Update lap/session data and record counts
                _lapRecordCount++;
                _sessionRecordCount++;
                _hCLapAverage += hemoConc;
                _hCSessionAverage += hemoConc;
                _hPLapAverage += hemoPerc;
                _hPSessionAverage += hemoPerc;

                // Update lap/session FIT Contributions
                _lapAverageHCField.setData(toFixed(_hCLapAverage / _lapRecordCount, 100));
                _sessionAverageHCField.setData(toFixed(_hCSessionAverage / _sessionRecordCount, 100));

                _lapAverageHPField.setData(toFixed(_hPLapAverage / _lapRecordCount, 10));
                _sessionAverageHPField.setData(toFixed(_hPSessionAverage / _sessionRecordCount, 10));
            }
        }
    }

    //! Convert to fixed value
    //! @param value Value to fix
    //! @param scale Scale to use
    //! @return Fixed value
    private function toFixed(value as Numeric, scale as Number) as Number {
        return ((value * scale) + 0.5).toNumber();
    }

    //! Set whether the timer is running
    //! @param state Whether the timer is running
    public function setTimerRunning(state as Boolean) as Void {
        _timerRunning = state;
    }

    //! Handle lap event
    public function onTimerLap() as Void {
        _lapRecordCount = 0;
        _hCLapAverage = 0.0;
        _hPLapAverage = 0.0;
    }

    //! Handle timer reset
    public function onTimerReset() as Void {
        _sessionRecordCount = 0;
        _hCSessionAverage = 0.0;
        _hPSessionAverage = 0.0;
    }

}