//
// Copyright 2016-2021 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//

import Toybox.Ant;
import Toybox.Lang;
import Toybox.System;

public const ANT_DATA_PACKET_SIZE = 8;

class BurstChannelManager {

    private const BURST_TX_MESSAGE_COUNT = 50;

    private var _listener as TestBurstListener;
    private var _masterChannel as BurstChannel;
    private var _slaveChannel as BurstChannel;

    //! Constructor
    public function initialize() {
        _listener = new $.TestBurstListener();
        _masterChannel = new $.BurstChannel(Ant.CHANNEL_TYPE_TX_NOT_RX, _listener);
        _slaveChannel = new $.BurstChannel(Ant.CHANNEL_TYPE_RX_NOT_TX, _listener);
    }

    //! Sends a burst over the master channel
    public function sendBurst() as Void {
        var burst = new Ant.BurstPayload();
        for (var i = 0; i < BURST_TX_MESSAGE_COUNT; i++) {
            // Populate a new burst packet
            var data = new [$.ANT_DATA_PACKET_SIZE] as Array<Number>;
            for (var j = 0; j < $.ANT_DATA_PACKET_SIZE; j++) {
                data[j] = i;
            }

            // Add the packet to the BurstPayload
            burst.add(data);
        }

        _masterChannel.sendBurst(burst);
    }

    //! Wrapper function that retrieves the current BurstStatistics
    //! @return The BurstStatistics gathered by the TestBurstListener
    public function getBurstStatistics() as BurstStatistics {
        return _listener.getBurstStatistics();
    }
}

class BurstChannel extends Ant.GenericChannel {
    private const DEVICE_NUMBER = 123;
    private const DEVICE_TYPE = 1;
    private const FREQUENCY = 66;
    private const PERIOD_1_HZ = 32768;
    private const TRANS_TYPE = 0;

    private var _transmissionCounter as Number;

    //! Constructor.
    //! Initializes the channel object, sets the burst listener and opens the channel
    //! @param channelType Type of channel to use
    //! @param listener The BurstListener to assign
    public function initialize(channelType as ChannelType, listener as BurstListener) {
        // Get the channel
        var chanAssign = new Ant.ChannelAssignment(
                channelType,
                Ant.NETWORK_PUBLIC);
        GenericChannel.initialize(method(:onMessage), chanAssign);

        // Set the configuration
        var deviceCfg = new Ant.DeviceConfig({
            :deviceNumber => DEVICE_NUMBER,
            :deviceType => DEVICE_TYPE,
            :transmissionType => TRANS_TYPE,
            :messagePeriod => PERIOD_1_HZ,
            :radioFrequency => FREQUENCY});
        GenericChannel.setDeviceConfig(deviceCfg);

        // Set the listener for burst messages
        GenericChannel.setBurstListener(listener);

        // Open the channel
        GenericChannel.open();

        // Reset the transmission counter
        _transmissionCounter = 0;
    }

    //! Ant.Message handler
    //! @param msg The Message received over the channel
    public function onMessage(msg as Message) as Void {
        var payload = msg.getPayload();
        if ((Ant.MSG_ID_CHANNEL_RESPONSE_EVENT == msg.messageId) && (Ant.MSG_ID_RF_EVENT == payload[0])) {
            var eventCode = payload[1];
            if (Ant.MSG_CODE_EVENT_TX == eventCode) {
                // Create and populate the data payload
                var data = new [$.ANT_DATA_PACKET_SIZE] as Array<Number>;
                for (var i = 0; i < $.ANT_DATA_PACKET_SIZE; i++) {
                    data[i] = _transmissionCounter;
                }
                _transmissionCounter++;

                // Form the message
                var message = new Ant.Message();
                message.setPayload(data);

                // Set the broadcast buffer
                GenericChannel.sendBroadcast(message);
            } else if (Ant.MSG_CODE_EVENT_CHANNEL_CLOSED == eventCode) {
                // Reopen the channel if it closed due to search timeout
                GenericChannel.open();
            }
        }
    }

}

//! An extension of BurstListener that handles burst related events
class TestBurstListener extends Ant.BurstListener {
    private var _burstStatistics as BurstStatistics;

    //! Constructor
    public function initialize() {
        _burstStatistics = new $.BurstStatistics();
        BurstListener.initialize();
    }

    //! Callback when a burst transmission completes successfully
    public function onTransmitComplete() as Void {
        _burstStatistics.onTxSuccess();
        System.println("onTransmitComplete");
    }

    //! Callback when a burst transmission fails over the air
    //! @param errorCode The type of burst failure that occurred, see Ant.BURST_ERROR_XXX
    public function onTransmitFail(errorCode as BurstError) as Void {
        _burstStatistics.onTxFail();
        System.println("onTransmitFail-" + errorCode);
    }

    //! Callback when a burst reception fails over the air
    //! @param errorCode The type of burst failure that occurred, see Ant.BURST_ERROR_XXX
    public function onReceiveFail(errorCode as BurstError) as Void {
        _burstStatistics.onRxFail();
        System.println("onReceiveFail-" + errorCode);
    }

    //! Callback when a burst reception completes successfully
    //! @param burstPayload The burst data received across the channel
    public function onReceiveComplete(burstPayload as BurstPayload) as Void {
        _burstStatistics.onRxSuccess();
        printPayload(burstPayload);
        System.println("onReceiveComplete");
    }

    //! Get the burst statistics of this listener
    //! @return The burst statistics object
    public function getBurstStatistics() as BurstStatistics {
        return _burstStatistics;
    }

    //! Iterates over a burst payload to print each packet
    //! @param burstPayload The burst data to display
    private function printPayload(burstPayload as BurstPayload) as Void {
        var itr = new Ant.BurstPayloadIterator(burstPayload);
        var payload = itr.next();
        while (null != payload) {
            System.println("payload " + payload);
            payload = itr.next();
        }
    }
}

//! Keeps track of the number of successful / failed
//! receptions and transmissions
class BurstStatistics {
    private var _rxFailCount as Number;
    private var _rxSuccessCount as Number;
    private var _txFailCount as Number;
    private var _txSuccessCount as Number;

    //! Constructor
    public function initialize() {
        _rxFailCount = 0;
        _rxSuccessCount = 0;
        _txFailCount = 0;
        _txSuccessCount = 0;
    }

    //! Update the count when a receive fails
    public function onRxFail() as Void {
        _rxFailCount++;
    }

    //! Get the count of reception fails
    //! @return Number of reception fails
    public function getRxFailCount() as Number {
        return _rxFailCount;
    }

    //! Update the count when a receive succeeds
    public function onRxSuccess() as Void {
        _rxSuccessCount++;
    }

    //! Get the count of reception successes
    //! @return Number of reception successes
    public function getRxSuccessCount() as Number {
        return _rxSuccessCount;
    }

    //! Update the count when a transmission fails
    public function onTxFail() as Void {
        _txFailCount++;
    }

    //! Get the count of transmission fails
    //! @return Number of transmission fails
    public function getTxFailCount() as Number {
        return _txFailCount;
    }

    //! Update the count when a transmission succeeds
    public function onTxSuccess() as Void {
        _txSuccessCount++;
    }

    //! Get the count of transmission successes
    //! @return Number of transmission successes
    public function getTxSuccessCount() as Number {
        return _txSuccessCount;
    }
}