//
// Copyright 2016-2021 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//

import Toybox.ActivityRecording;
import Toybox.Lang;
import Toybox.Math;
import Toybox.Sensor;
import Toybox.SensorLogging;
import Toybox.System;
import Toybox.WatchUi;

//! Processes accelerometer data and counts pitches
class PitchCounterProcess {
    // --- Min duration for the pause feature, [samples]
    private const NUM_FEATURE = 20;

    // --- Min duration between pitches, [samples]
    private const TIME_PTC = 20;

    // --- High level detection threshold
    private const HIGH_THR = 6.0f;

    // --- Low level detection threshold
    private const LOW_THR = -4.2f;

    // --- Pause feature threshold: positive and negative ones
    private const QP_THR = 2.0f;
    private const QN_THR = -QP_THR;

    // --- Pause range: number of samples * 40 ms each
    private const Q_RANGE = (100 * 40);

    private var _x as Array<Float> = [0.0] as Array<Float>;
    private var _y as Array<Number> = [0] as Array<Number>;
    private var _z as Array<Number> = [0] as Array<Number>;
    private var _filter as FirFilter?;
    private var _pauseCount as Number = 0;
    private var _pauseTime as Number = 0;
    private var _skipSample as Number = 25;
    private var _pitchCount as Number = 0;
    private var _logger as SensorLogger?;
    private var _session as Session?;

    private var _accX1 as Float = 0.0;
    private var _accX2 as Float = 0.0;

    private var _accZ1 as Number = 0;
    private var _accZ2 as Number = 0;

    private var _minX as Float or Number = 0;
    private var _maxX as Float or Number = 0;

    private var _minZ as Float or Number = 0;
    private var _maxZ as Float or Number = 0;

    //! Constructor
    public function initialize() {
        // initialize FIR filter
        var options = {:coefficients => [-0.0278f, 0.9444f, -0.0278f] as Array<Float>, :gain => 0.001f};
        try {
            _filter = new Math.FirFilter(options);
            _logger = new SensorLogging.SensorLogger({:accelerometer => {:enabled => true}});
            _session = ActivityRecording.createSession({:name=>"PitchCounter", :sport=>ActivityRecording.SPORT_GENERIC, :sensorLogger =>_logger as SensorLogger});
        } catch (e) {
            System.println(e.getErrorMessage());
        }
    }

    //! Callback to receive accel data
    //! @param sensorData The Sensor Data object
    public function accelCallback(sensorData as SensorData) as Void {
        var accelData = sensorData.accelerometerData;
        if (accelData != null) {
            var filter = _filter;
            if (filter != null) {
                _x = filter.apply(accelData.x);
            }
            _y = accelData.y;
            _z = accelData.z;
            onAccelData();
        }
    }

    //! Start pitch counter
    public function onStart() as Void {
        // initialize accelerometer
        var options = {:period => 1, :accelerometer => {:enabled => true, :sampleRate => 25}};
        try {
            Sensor.registerSensorDataListener(method(:accelCallback), options);
            var session = _session;
            if (session != null) {
                session.start();
            }
        } catch(e) {
            System.println(e.getErrorMessage());
        }
    }

    //! Stop pitch counter
    public function onStop() as Void {
        Sensor.unregisterSensorDataListener();
        var session = _session;
        if (session != null) {
            session.stop();
        }
    }

    //! Return current pitch count
    //! @return The number of pitches counted
    public function getCount() as Number {
        return _pitchCount;
    }

    //! Get the total number of logged samples
    //! @return The number of samples
    public function getSamples() as Number? {
        var logger = _logger;
        if (logger != null) {
            return logger.getStats().sampleCount;
        }
        return null;
    }

    //! Get the total number of seconds of logged data
    //! @return The number of seconds of logged data
    public function getPeriod() as Number? {
        var logger = _logger;
        if (logger != null) {
            return logger.getStats().samplePeriod;
        }
        return null;
    }

    //! Process new accel data
    private function onAccelData() as Void {
        var cur_acc_x = 0;
        var cur_acc_y = 0;
        var cur_acc_z = 0;
        var time = 0;

        for (var i = 0; i < _x.size(); ++i) {
            cur_acc_x = _x[i];
            cur_acc_y = _y[i];
            cur_acc_z = _z[i];

            if (_skipSample > 0) {
                _skipSample--;
            } else {
                // --- Pause feature?
                if ((cur_acc_x < QP_THR) && (cur_acc_x > QN_THR) && (cur_acc_y < QP_THR) &&
                   (cur_acc_y > QN_THR) && (cur_acc_z < QP_THR) && (cur_acc_z > QN_THR)) {
                    _pauseCount++;

                    // --- Long enough pause before a pitch?
                    if (_pauseCount > NUM_FEATURE) {
                        _pauseCount = NUM_FEATURE;
                        _pauseTime = time;
                    }
                } else {
                    _pauseTime = 0;
                }

                _minX = min(min(_accX1, _accX2), cur_acc_x);
                _maxX = max(max(_accX1, _accX2), cur_acc_x);

                _minZ = min(min(_accZ1, _accZ2), cur_acc_z);
                _maxZ = max(max(_accZ1, _accZ2), cur_acc_z);

                // --- Pitching motion?
                if ((time - _pauseTime < Q_RANGE) && (((_minZ < LOW_THR) && (_maxX > HIGH_THR)) || ((_minZ < LOW_THR) && (_minX < LOW_THR)))) {

                    // --- A new pitch detected
                    _pitchCount++;

                    // --- Next pitch should be farther in time than TIME_PTC
                    _skipSample = TIME_PTC;

                    // --- Clear the previous accelerometer values for X and Z channels
                    _accX2 = 0.0;
                    _accX1 = 0.0;
                    _accZ2 = 0;
                    _accZ1 = 0;

                    // --- Reset pause feature counter
                    _pauseCount = 0;
                    _pauseTime = 0;
                } else {
                    // --- Update 3 elements of acceleration for X
                    _accX2 = _accX1;
                    _accX1 = cur_acc_x;

                    // --- Update 3 elements of acceleration for Z
                    _accZ2 = _accZ1;
                    _accZ1 = cur_acc_z;
                }
            }
            time++;
        }
        WatchUi.requestUpdate();
    }


    //! Return min of two values
    //! @param a First value
    //! @param b Second value
    //! @return The smaller of the given values
    private function min(a as Float or Number, b as Float or Number) as Float or Number {
        if (a < b) {
            return a;
        } else {
            return b;
        }
    }

    //! Return max of two values
    //! @param a First value
    //! @param b Second value
    //! @return The larger of the given values
    private function max(a as Float or Number, b as Float or Number) as Float or Number {
        if (a > b) {
            return a;
        } else {
            return b;
        }
    }
}
