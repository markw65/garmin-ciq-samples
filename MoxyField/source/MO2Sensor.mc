//
// Copyright 2015-2021 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//

import Toybox.Ant;
import Toybox.Lang;
import Toybox.Time;

const PAGE_NUMBER = 1;

class MO2Sensor extends Ant.GenericChannel {
    private const DEVICE_TYPE = 31;
    private const PERIOD = 8192;

    private var _chanAssign as ChannelAssignment;
    private var _data as MO2Data;
    private var _deviceCfg as DeviceConfig;
    private var _pastEventCount as Number?;
    private var _searching as Boolean;

    class MO2Data {
        private var _eventCount as Number;
        private var _utcTimeSet as Boolean;
        private var _totalHemoConcentration as Float;
        private var _previousHemoPercent as Float;
        private var _currentHemoPercent as Float;

        //! Constructor
        public function initialize() {
            _eventCount = 0;
            _utcTimeSet = false;
            _totalHemoConcentration = 0.0;
            _previousHemoPercent = 0.0;
            _currentHemoPercent = 0.0;
        }

        //! Get the event count
        //! @return Event count
        public function getEventCount() as Number {
            return _eventCount;
        }

        //! Get whether the UTC time is set
        //! @return true if UTC time set, false otherwise
        public function isUtcTimeSet() as Boolean {
            return _utcTimeSet;
        }

        //! Get the total hemoglobin concentration
        //! @return The total hemoglobin concentration
        public function getTotalHemoConcentration() as Numeric {
            return _totalHemoConcentration;
        }

        //! Get the previous hemoglobin percent
        //! @return The previous hemoglobin percent
        public function getPreviousHemoPercent() as Numeric {
            return _previousHemoPercent;
        }

        //! Get the current hemoglobin percent
        //! @return The current hemoglobin percent
        public function getCurrentHemoPercent() as Numeric {
            return _currentHemoPercent;
        }

        //! Parse the payload to get the current data values
        //! @param payload ANT data payload
        public function parse(payload as Array<Number>) as Void {
            _eventCount = parseEventCount(payload);
            _utcTimeSet = parseTimeSet(payload);
            _totalHemoConcentration = parseTotalHemo(payload);
            _previousHemoPercent = parsePrevHemo(payload);
            _currentHemoPercent = parseCurrentHemo(payload);
        }

        //! Get the event count from payload
        //! @param payload ANT data payload
        //! @return The event count
        private function parseEventCount(payload as Array<Number>) as Number {
           return payload[1];
        }

        //! Get whether the time is set from payload
        //! @param payload ANT data payload
        //! @return Whether the time is set
        private function parseTimeSet(payload as Array<Number>) as Boolean {
            if (payload[2] & 0x1) {
               return true;
            } else {
               return false;
            }
        }

        //! Get total hemoglobin value from payload
        //! @param payload ANT data payload
        //! @return Total hemoglobin value
        private function parseTotalHemo(payload as Array<Number>) as Float {
           return ((payload[4] | ((payload[5] & 0x0F) << 8))) / 100f;
        }

        //! Get previous hemoglobin value from payload
        //! @param payload ANT data payload
        //! @return Previous hemoglobin value
        private function parsePrevHemo(payload as Array<Number>) as Float {
           return ((payload[5] >> 4) | ((payload[6] & 0x3F) << 4)) / 10f;
        }

        //! Get current hemoglobin value from payload
        //! @param payload ANT data payload
        //! @return Current hemoglobin value
        private function parseCurrentHemo(payload as Array<Number>) as Float {
           return ((payload[6] >> 6) | (payload[7] << 2)) / 10f;
        }
    }

    //! Constructor
    public function initialize() {
        // Get the channel
        _chanAssign = new Ant.ChannelAssignment(
            Ant.CHANNEL_TYPE_RX_NOT_TX,
            Ant.NETWORK_PLUS);
        GenericChannel.initialize(method(:onMessage), _chanAssign);

        // Set the configuration
        _deviceCfg = new Ant.DeviceConfig({
            :deviceNumber => 0,                 // Wildcard our search
            :deviceType => DEVICE_TYPE,
            :transmissionType => 0,
            :messagePeriod => PERIOD,
            :radioFrequency => 57,              // Ant+ Frequency
            :searchTimeoutLowPriority => 10,    // Timeout in 25s
            :searchThreshold => 0});            // Pair to all transmitting sensors
        GenericChannel.setDeviceConfig(_deviceCfg);

        _data = new MO2Data();
        _searching = true;
    }

    //! Open an ANT channel
    //! @return true if channel opened successfully, false otherwise
    public function open() as Boolean {
        // Open the channel
        var open = GenericChannel.open();

        _data = new MO2Data();
        _pastEventCount = 0;
        _searching = true;
        return open;
    }

    //! Close the ANT sensor and save the session
    public function closeSensor() as Void {
        GenericChannel.close();
    }

    //! Set the current time
    public function setTime() as Void {
        if (!_searching && _data.isUtcTimeSet()) {
            // Create and populate the data payload
            var payload = new Array<Number>[8];
            payload[0] = 0x10;  // Command data page
            payload[1] = 0x00;  // Set time command
            payload[2] = 0xFF;  // Reserved
            payload[3] = 0;     // Signed 2's complement value indicating local time offset in 15m intervals

            // Set the current time
            var moment = Time.now();
            for (var i = 0; i < 4; i++) {
                payload[i + 4] = ((moment.value() >> i) & 0x000000FF);
            }

            // Form and send the message
            var message = new Ant.Message();
            message.setPayload(payload);
            GenericChannel.sendAcknowledge(message);
        }
    }

    //! Update when a message is received
    //! @param msg The ANT message
    public function onMessage(msg as Message) as Void {
        // Parse the payload
        var payload = msg.getPayload();

        if ((Ant.MSG_ID_BROADCAST_DATA == msg.messageId) && ($.PAGE_NUMBER == (payload[0].toNumber() & 0xFF))) {
            // Were we searching?
            if (_searching) {
                _searching = false;
                // Update our device configuration primarily to see the device number of the sensor we paired to
                _deviceCfg = GenericChannel.getDeviceConfig();
            }
            _data.parse(msg.getPayload());
            // Update the event count
            _pastEventCount = _data.getEventCount();
        } else if ((Ant.MSG_ID_CHANNEL_RESPONSE_EVENT == msg.messageId) && (Ant.MSG_ID_RF_EVENT == (payload[0] & 0xFF))) {
            if (Ant.MSG_CODE_EVENT_CHANNEL_CLOSED == (payload[1] & 0xFF)) {
                // Channel closed, re-open
                open();
            } else if (Ant.MSG_CODE_EVENT_RX_FAIL_GO_TO_SEARCH == (payload[1] & 0xFF)) {
                _searching = true;
            }
        }
    }

    //! Get the data for this sensor
    //! @return Data object
    public function getData() as MO2Data {
        return _data;
    }

    //! Get whether the channel is searching
    //! @return true if searching, false otherwise
    public function isSearching() as Boolean {
        return _searching;
    }
}