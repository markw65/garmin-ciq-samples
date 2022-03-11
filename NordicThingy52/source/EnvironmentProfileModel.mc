//
// Copyright 2019-2021 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//

import Toybox.BluetoothLowEnergy;
import Toybox.Lang;
import Toybox.WatchUi;

class EnvironmentProfileModel {
    private var _service as Service?;
    private var _profileManager as ProfileManager;
    private var _pendingNotifies as Array<Characteristic>;

    private var _temperature as Numeric?;
    private var _pressure as Numeric?;
    private var _humidity as Numeric?;
    private var _eco2 as Numeric?;
    private var _tvoc as Numeric?;

    //! Constructor
    //! @param delegate The BLE delegate for the model
    //! @param profileManager The profile manager for this model
    //! @param device The current device
    public function initialize(
        delegate as ThingyDelegate,
        profileManager as ProfileManager,
        device as Device
    ) {
        delegate.notifyDescriptorWrite(self);
        delegate.notifyCharacteristicChanged(self);

        _profileManager = profileManager;
        _service = device.getService(
            profileManager.THINGY_ENVIRONMENTAL_SERVICE
        );

        _pendingNotifies = [] as Array<Characteristic>;

        var service = _service;
        if (service != null) {
            var characteristic = service.getCharacteristic(
                profileManager.TEMPERATURE_CHARACTERISTIC
            );
            if (null != characteristic) {
                _pendingNotifies = _pendingNotifies.add(characteristic);
            }

            characteristic = service.getCharacteristic(
                profileManager.PRESSURE_CHARACTERISTIC
            );
            if (null != characteristic) {
                _pendingNotifies = _pendingNotifies.add(characteristic);
            }

            characteristic = service.getCharacteristic(
                profileManager.HUMIDITY_CHARACTERISTIC
            );
            if (null != characteristic) {
                _pendingNotifies = _pendingNotifies.add(characteristic);
            }

            characteristic = service.getCharacteristic(
                profileManager.AIR_QUALITY_CHARACTERISTIC
            );
            if (null != characteristic) {
                _pendingNotifies = _pendingNotifies.add(characteristic);
            }
        }

        activateNextNotification();
    }

    //! Handle a characteristic being changed
    //! @param char The characteristic that changed
    //! @param value The updated value of the characteristic
    public function onCharacteristicChanged(
        char as Characteristic,
        value as ByteArray
    ) as Void {
        switch (char.getUuid()) {
            case _profileManager.TEMPERATURE_CHARACTERISTIC:
                processTemperatureValue(value);
                break;

            case _profileManager.PRESSURE_CHARACTERISTIC:
                processPressureValue(value);
                break;

            case _profileManager.HUMIDITY_CHARACTERISTIC:
                processHumidityValue(value);
                break;

            case _profileManager.AIR_QUALITY_CHARACTERISTIC:
                processAirQualityValue(value);
                break;
        }
    }

    //! Handle the completion of a write operation on a descriptor
    //! @param descriptor The descriptor that was written
    //! @param status The BluetoothLowEnergy status indicating the result of the operation
    public function onDescriptorWrite(
        descriptor as Descriptor,
        status as Status
    ) as Void {
        if (BluetoothLowEnergy.cccdUuid().equals(descriptor.getUuid())) {
            processCccdWrite();
        }
    }

    //! Get the temperature
    //! @return The temperature
    public function getTemperature() as Numeric? {
        return _temperature;
    }

    //! Get the pressure
    //! @return The pressure
    public function getPressure() as Numeric? {
        return _pressure;
    }

    //! Get the humidity
    //! @return The humidity
    public function getHumidity() as Numeric? {
        return _humidity;
    }

    //! Get the ECO2 value
    //! @return The ECO2 value
    public function getEco2() as Numeric? {
        return _eco2;
    }

    //! Get the TVOC value
    //! @return The TVOC value
    public function getTvoc() as Numeric? {
        return _tvoc;
    }

    //! Write the next notification to the descriptor
    private function activateNextNotification() as Void {
        if (_pendingNotifies.size() == 0) {
            return;
        }

        var char = _pendingNotifies[0];
        var cccd = char.getDescriptor(BluetoothLowEnergy.cccdUuid());
        if (cccd != null) {
            cccd.requestWrite([0x01, 0x00]b);
        }
    }

    //! Process a CCCD write operation
    private function processCccdWrite() as Void {
        if (_pendingNotifies.size() > 1) {
            _pendingNotifies = _pendingNotifies.slice(
                1,
                _pendingNotifies.size()
            );
            activateNextNotification();
        } else {
            _pendingNotifies = [] as Array<Characteristic>;
        }
    }

    //! Process and set the air quality values
    //! @param value The new air quality value
    private function processAirQualityValue(value as ByteArray) as Void {
        _eco2 = value.decodeNumber(Lang.NUMBER_FORMAT_UINT16, {});
        _tvoc = value.decodeNumber(Lang.NUMBER_FORMAT_UINT16, { :offset => 2 });
        WatchUi.requestUpdate();
    }

    //! Process and set the humidity value
    //! @param value The new humidity value
    private function processHumidityValue(value as ByteArray) as Void {
        _humidity = value.decodeNumber(Lang.NUMBER_FORMAT_UINT8, {});
        WatchUi.requestUpdate();
    }

    //! Process and set the pressure value
    //! @param value The new pressure value
    private function processPressureValue(value as ByteArray) as Void {
        _pressure =
            value.decodeNumber(Lang.NUMBER_FORMAT_SINT32, {}) +
            value.decodeNumber(Lang.NUMBER_FORMAT_UINT8, { :offset => 4 }) /
                100.0;
        WatchUi.requestUpdate();
    }

    //! Process and set the temperature value
    //! @param value The new temperature value
    private function processTemperatureValue(value as ByteArray) as Void {
        _temperature =
            value.decodeNumber(Lang.NUMBER_FORMAT_SINT8, {}) +
            value.decodeNumber(Lang.NUMBER_FORMAT_UINT8, { :offset => 1 }) /
                100.0;
        WatchUi.requestUpdate();
    }
}
