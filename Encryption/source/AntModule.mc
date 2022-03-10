//
// Copyright 2017-2021 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//

import Toybox.Ant;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;

module AntModule {
    // Channel configuration
    const CHANNEL_PERIOD = 8070;
    const DEVICE_NUMBER = 1234;
    const DEVICE_TYPE = 120;
    const TRANSMISSION_TYPE = 1;
    const RADIO_FREQUENCY = 77;

    // Range Constants
    const MIN_BYTE_VALUE = 0x00;
    const MAX_BYTE_VALUE = 0xFF;
    const SEND_DATA_MAX_INDEX = 3;
    const MAX_DATA_LENGTH = 24;
    const NEW_MESSAGE_LENGTH = 8;

    // Encryption-related constants
    const ENCRYPTION_DECIMATION_RATE = 1;
    const ENCRYPTION_ID_SLAVE = 0xAAAAAAAA;
    const ENCRYPTION_ID_MASTER = 0x11111111;
    const ENCRYPTION_KEY = [1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1] as Array<Number>;
    const ENCRYPTION_USER_INFO_STRING = [1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1] as Array<Number>;

    // Message indexes
    const MESSAGE_ID_INDEX = 0;
    const MESSAGE_CODE_INDEX = 1;

    // See the commented data below for the text representation
    const SEND_DATA = [
        [0x1,0x48,0x65,0x6c,0x6c,0x6f,0x5f,0x5f] as Array<Number>,
        [0x2,0x57,0x6f,0x72,0x6c,0x64,0x21,0x5f] as Array<Number>,
        [0x3,0x43,0x6f,0x6e,0x6e,0x65,0x63,0x74] as Array<Number>,
        [0x4,0x49,0x51,0x5f,0x5f,0x5f,0x5f,0x5f] as Array<Number>] as Array< Array<Number> >;
     // [0x01,"H","e","l","l","o","_","_"],
     // [0x02,"W","o","r","l","d","!","_"],
     // [0x03,"C","o","n","n","e","c","t"],
     // [0x04,"I","Q","_","_","_","_","_"]];

    // ASCII Table needed for showing Data byte values.
    const HEX_TO_ASCII = [
        " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ",
        " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ",
        " ", "!", "\"", "#","$", "%", "&", "'", "(", ")", "*", "+", ",", "-", ".", "/",
        "0", "1", "2", "3", "4", "5", "6", "7", "8", "9", ":", ";", "<", "=", ">", "?",
        "@", "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O",
        "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z", "[", "\\", "]", "^", "_",
        "`", "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o",
        "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z", "{", "|", "}", "~", "",
        " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ",
        " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ",
        " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ",
        " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ",
        " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ",
        " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ",
        " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ",
        " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " "] as Array<String>;

    class AntSensor extends Ant.GenericChannel {

        private var _cryptoConfig as CryptoConfig;
        private var _data as String;
        private var _deviceCfg as DeviceConfig;
        private var _encrypted as Boolean;
        private var _index as Number;
        private var _isMaster as Boolean;
        private var _searching as Boolean;

        //! Constructor, initializes AntSensor and configures and opens channel
        //! @param isChannelTypeMaster Boolean that indicates if the channel should
        //!  be a master or a slave
        public function initialize(isChannelTypeMaster as Boolean) {
            // Initialize class variables
            _cryptoConfig = new Ant.CryptoConfig({});
            _index = 0;
            _data = WatchUi.loadResource($.Rez.Strings.Uninitialized) as String;
            _deviceCfg = new Ant.DeviceConfig({});
            _encrypted = false;
            _isMaster = isChannelTypeMaster;
            _searching = !_isMaster;

            // Try to create crypto configs and channel assignments
             try {
                var chanAssign;
                if (_isMaster) {
                    // Create master crypto config
                    _cryptoConfig = new Ant.CryptoConfig({
                        :encryptionId => $.AntModule.ENCRYPTION_ID_MASTER,
                        :encryptionKey => $.AntModule.ENCRYPTION_KEY,
                        :decimationRate => $.AntModule.ENCRYPTION_DECIMATION_RATE
                    });

                    // Create master channel assignment
                    chanAssign = new Ant.ChannelAssignment(
                        Ant.CHANNEL_TYPE_TX_NOT_RX,
                        Ant.NETWORK_PUBLIC);

                } else {
                    // Create slave crypto config
                    _cryptoConfig = new Ant.CryptoConfig({
                        :encryptionId => $.AntModule.ENCRYPTION_ID_SLAVE,
                        :encryptionKey => $.AntModule.ENCRYPTION_KEY,
                        :userInfoString => $.AntModule.ENCRYPTION_USER_INFO_STRING,
                        :decimationRate => $.AntModule.ENCRYPTION_DECIMATION_RATE
                    });

                    // Create slave channel assignment
                    chanAssign = new Ant.ChannelAssignment(
                        Ant.CHANNEL_TYPE_RX_NOT_TX,
                        Ant.NETWORK_PUBLIC);
                }

                // Initialize Channel
                GenericChannel.initialize(method(:onMessage), chanAssign);

                // Set the configuration
                _deviceCfg = new Ant.DeviceConfig({
                    :deviceNumber => $.AntModule.DEVICE_NUMBER,
                    :deviceType => $.AntModule.DEVICE_TYPE,
                    :transmissionType => $.AntModule.TRANSMISSION_TYPE,
                    :messagePeriod => $.AntModule.CHANNEL_PERIOD,
                    :radioFrequency => $.AntModule.RADIO_FREQUENCY
                });
                GenericChannel.setDeviceConfig(_deviceCfg);

            } catch(ex) {
                System.println("Error creating the crypto config");
            }
        }

        //! Opens the generic channel
        //! @return true if channel is successfully opened, false otherwise
        public function open() as Boolean {
            return GenericChannel.open();
        }

        //! Enables encryption for master and decryption for slave
        public function enableChannelEncryption() as Void {
            try {
                if (!_searching && !_encrypted){
                    GenericChannel.enableEncryption(_cryptoConfig);
                    _encrypted = true;
                } else {
                    System.println("Failed to enable encryption, still searching");
                }
            } catch (ex instanceof EncryptionInvalidSettingsException) {
                System.println("Failed to enable encryption, cryptoConfig has an invalid parameter");
            } catch (ex instanceof UnableToAcquireEncryptedChannelException) {
                System.println("Failed to enable encryption, please ensure you are not using more encrypted channels than are available");
            } catch (ex) {
                System.println("Failed to enable encryption, reason unknown");
            }
        }

        //! Disables encryption for master and decryption for slave
        public function disableEncryption() as Void {
            try {
                if (_encrypted) {
                    GenericChannel.disableEncryption();
                    _encrypted = false;
                }
            } catch (ex instanceof EncryptionInvalidSettingsException) {
                System.println("Failed to disable encryption as cryptoConfig has an invalid parameter");
            } catch (ex) {
                System.println("Failed to disable encryption, reason unknown");
            }
        }

        //! On Ant Message, parses message
        //! @param msg Ant.Message object
        public function onMessage(msg as Message) as Void {
            // Parse the payload
            var payload = msg.getPayload();
            if (Ant.MSG_ID_CHANNEL_RESPONSE_EVENT == msg.messageId) {
                if (Ant.MSG_ID_RF_EVENT == payload[$.AntModule.MESSAGE_ID_INDEX]) {
                    switch (payload[$.AntModule.MESSAGE_CODE_INDEX]) {
                        case Ant.MSG_CODE_EVENT_CHANNEL_CLOSED:
                            // Channel closed, re-open
                            open();
                            break;
                        case Ant.MSG_CODE_EVENT_RX_FAIL_GO_TO_SEARCH:
                            _searching = true;
                            break;
                        case Ant.MSG_CODE_EVENT_CRYPTO_NEGOTIATION_FAIL:
                            _encrypted = false;
                            break;
                         case Ant.MSG_CODE_EVENT_CRYPTO_NEGOTIATION_SUCCESS:
                            _encrypted = true;
                            break;
                         case Ant.MSG_CODE_EVENT_TX:
                            // Update data and send out the next part of the message
                             var message = new Ant.Message();
                             _index++;
                             if ($.AntModule.SEND_DATA_MAX_INDEX < _index) {
                                 _index = 0;
                             }
                             var toSend = $.AntModule.SEND_DATA[_index];
                             updateData(toSend);
                             message.setPayload(toSend);
                             GenericChannel.sendBroadcast(message);
                             break;
                    }
                }
            } else if (Ant.MSG_ID_BROADCAST_DATA == msg.messageId) {
                if (_searching) {
                    _searching = false;
                }
                // Update data to received message
                updateData(payload);
                // Update the UI
                WatchUi.requestUpdate();
            }
        }

        //! Get whether the sensor is encrypted
        //! @return true if encrypted, false otherwise
        public function isEncrypted() as Boolean {
            return _encrypted;
        }

        //! Get whether the sensor is searching
        //! @return true if searching, false otherwise
        public function isSearching() as Boolean {
            return _searching;
        }

        //! Get whether the channel is master
        //! @return true if master, false otherwise
        public function isMaster() as Boolean {
            return _isMaster;
        }

        //! Get the sensor data
        //! @return The data
        public function getData() as String {
            return _data;
        }

        //! Get the device configuration
        //! @return The device configuration
        public function getDeviceConfig() as DeviceConfig {
            return _deviceCfg;
        }

        //! Adds the new message to data
        //! Maintains data stays within MAX_DATA_LENGTH
        //! @param bArray Array with the message you want to add to data
        private function updateData(bArray as Array<Number>) as Void {
            if (_data.length() >= $.AntModule.MAX_DATA_LENGTH) {
                var newData = _data.substring($.AntModule.NEW_MESSAGE_LENGTH, $.AntModule.MAX_DATA_LENGTH);
                if (newData != null) {
                    _data = newData;
                } else {
                    System.println("Failed to update the data");
                    return;
                }
            }
            _data = _data + DecodeByteToASCII(bArray);
        }

        //! Decode an array and return its ascii string equivalent
        //! @param bytes Array of integers representing the bytes to decode
        //! @return an ascii string equivalent to the given array
        private function DecodeByteToASCII(bytes as Array<Number>) as String {
            var str = "";
            for (var i = 0; i < bytes.size(); i++) {
                var curByte = bytes[i];
                if (($.AntModule.MIN_BYTE_VALUE <= curByte) && (curByte <= $.AntModule.MAX_BYTE_VALUE)) {
                    str += $.AntModule.HEX_TO_ASCII[curByte];
                } else {
                    str += "-";
                }
            }
            return str;
        }
    }
}