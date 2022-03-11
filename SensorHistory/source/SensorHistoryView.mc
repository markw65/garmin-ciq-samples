//
// Copyright 2016-2021 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//

import Toybox.Graphics;
import Toybox.Lang;
import Toybox.SensorHistory;
import Toybox.Time.Gregorian;
import Toybox.WatchUi;

//! Display graph of current sensor data
class SensorHistoryView extends WatchUi.View {
    private var _index as Number = 0;

    private
    var _sensorSymbols as Array<Symbol> = [
        :getHeartRateHistory,
        :getTemperatureHistory,
        :getPressureHistory,
        :getElevationHistory,
        :getOxygenSaturationHistory,
    ] as Array<Symbol>;

    private
    var _sensorLabel as Array<String> = [
        "Heart Rate",
        "Temperature",
        "Pressure",
        "Elevation",
        "Oxygen Saturation",
    ] as Array<String>;

    private
    var _sensorMin as Array<Number> = [50, 0, 50000, 0, 80] as Array<Number>;

    private
    var _sensorRange as Array<Number> = [140, 45, 60000, 6000, 20] as Array<Number>;

    //! Constructor
    public function initialize() {
        View.initialize();
    }

    //! Get the iterator for the current sensor
    //! @return The iterator for the current sensor
    private function getIterator() as SensorHistoryIterator? {
        if (
            Toybox has :SensorHistory &&
            SensorHistory has _sensorSymbols[_index]
        ) {
            var getMethod = new Lang.Method(
                SensorHistory,
                _sensorSymbols[_index]
            );
            return getMethod.invoke({});
        }
        return null;
    }

    //! Update the view
    //! @param dc Device context
    public function onUpdate(dc as Dc) as Void {
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
        dc.clear();

        if (Toybox has :SensorHistory) {
            var sensorIter = getIterator();
            if (sensorIter != null) {
                var previous = sensorIter.next();
                var sample = sensorIter.next();
                var x = 15;
                var min = sensorIter.getMin();
                var max = sensorIter.getMax();
                var firstSampleTime = null;
                var lastSampleTime = null;
                var graphBottom = dc.getHeight() / 2 + 45;
                var graphHeight = 90;
                var dataOffset = _sensorMin[_index].toFloat();
                var dataScale = _sensorRange[_index].toFloat();
                var gotValidData = false;
                dc.setColor(Graphics.COLOR_GREEN, Graphics.COLOR_GREEN);

                while (null != previous && null != sample) {
                    if (null == firstSampleTime) {
                        firstSampleTime = previous.when;
                    }

                    var previousData = previous.data;
                    var sampleData = sample.data;
                    if (sampleData != null && previousData != null) {
                        lastSampleTime = sample.when;
                        var y1 =
                            graphBottom -
                            ((previousData - dataOffset) / dataScale) *
                                graphHeight;
                        var y2 =
                            graphBottom -
                            ((sampleData - dataOffset) / dataScale) *
                                graphHeight;
                        dc.drawLine(x, y1, x + 1, y2);
                        gotValidData = true;
                    }

                    ++x;
                    previous = sample;
                    sample = sensorIter.next();
                }

                if (gotValidData) {
                    var font = Graphics.FONT_XTINY;
                    var fontHeight = dc.getFontHeight(font);

                    // draw the min/max hr values
                    dc.setColor(
                        Graphics.COLOR_WHITE,
                        Graphics.COLOR_TRANSPARENT
                    );
                    if (max == null) {
                        max = "?";
                    } else {
                        max = max.format("%d");
                    }

                    if (min == null) {
                        min = "?";
                    } else {
                        min = min.format("%d");
                    }
                    dc.drawText(
                        dc.getWidth() / 2,
                        1 * fontHeight,
                        font,
                        _sensorLabel[_index],
                        Graphics.TEXT_JUSTIFY_CENTER
                    );
                    dc.drawText(
                        dc.getWidth() / 2,
                        2 * fontHeight,
                        font,
                        "Min: " + min + " Max: " + max,
                        Graphics.TEXT_JUSTIFY_CENTER
                    );

                    // draw the start/end times
                    if (firstSampleTime != null && lastSampleTime != null) {
                        var startInfo = Gregorian.info(
                            firstSampleTime,
                            Time.FORMAT_SHORT
                        );
                        var endInfo = Gregorian.info(
                            lastSampleTime,
                            Time.FORMAT_SHORT
                        );

                        var startString = Lang.format("$1$/$2$ $3$:$4$:$5$", [
                            (startInfo.month as Number).format("%d"),
                            startInfo.day.format("%d"),
                            startInfo.hour.format("%02d"),
                            startInfo.min.format("%02d"),
                            startInfo.sec.format("%02d"),
                        ]);

                        var endString = Lang.format("$1$/$2$ $3$:$4$:$5$", [
                            (endInfo.month as Number).format("%d"),
                            endInfo.day.format("%d"),
                            endInfo.hour.format("%02d"),
                            endInfo.min.format("%02d"),
                            endInfo.sec.format("%02d"),
                        ]);

                        dc.drawText(
                            dc.getWidth() / 2,
                            dc.getHeight() - 3 * fontHeight,
                            font,
                            "Start: " + startString,
                            Graphics.TEXT_JUSTIFY_CENTER
                        );
                        dc.drawText(
                            dc.getWidth() / 2,
                            dc.getHeight() - 2 * fontHeight,
                            font,
                            "End: " + endString,
                            Graphics.TEXT_JUSTIFY_CENTER
                        );
                    }
                } else {
                    var message = _sensorLabel[_index] + "\nNo data available.";
                    dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
                    dc.drawText(
                        dc.getWidth() / 2,
                        dc.getHeight() / 2,
                        Graphics.FONT_MEDIUM,
                        message,
                        Graphics.TEXT_JUSTIFY_CENTER |
                            Graphics.TEXT_JUSTIFY_VCENTER
                    );
                }
            } else {
                var message = _sensorLabel[_index] + "\nSensor not available";
                dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
                dc.drawText(
                    dc.getWidth() / 2,
                    dc.getHeight() / 2,
                    Graphics.FONT_MEDIUM,
                    message,
                    Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER
                );
            }
        } else {
            dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
            var message = "Sensor History\nNot Supported";
            dc.drawText(
                dc.getWidth() / 2,
                dc.getHeight() / 2,
                Graphics.FONT_MEDIUM,
                message,
                Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER
            );
        }
    }

    //! Go to next sensor graph
    public function nextSensor() as Void {
        _index++;
        _index %= _sensorSymbols.size();
    }

    //! Go to previous sensor graph
    public function previousSensor() as Void {
        _index += _sensorSymbols.size() - 1;
        _index %= _sensorSymbols.size();
    }
}
