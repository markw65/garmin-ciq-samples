//
// Copyright 2019-2021 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//

import Toybox.BluetoothLowEnergy;

class ProfileManager {
    public
    const THINGY_ENVIRONMENTAL_SERVICE = BluetoothLowEnergy.longToUuid(
        0xef6802009b354933l,
        0x9b1052ffa9740042l
    );
    public
    const TEMPERATURE_CHARACTERISTIC = BluetoothLowEnergy.longToUuid(
        0xef6802019b354933l,
        0x9b1052ffa9740042l
    );
    public
    const PRESSURE_CHARACTERISTIC = BluetoothLowEnergy.longToUuid(
        0xef6802029b354933l,
        0x9b1052ffa9740042l
    );
    public
    const HUMIDITY_CHARACTERISTIC = BluetoothLowEnergy.longToUuid(
        0xef6802039b354933l,
        0x9b1052ffa9740042l
    );
    public
    const AIR_QUALITY_CHARACTERISTIC = BluetoothLowEnergy.longToUuid(
        0xef6802049b354933l,
        0x9b1052ffa9740042l
    );

    public
    const THINGY_CONFIGURATION_SERVICE = BluetoothLowEnergy.longToUuid(
        0xef6801009b354933l,
        0x9b1052ffa9740042l
    );

    private
    const _envProfileDef = {
        :uuid => THINGY_ENVIRONMENTAL_SERVICE,
        :characteristics
        =>
        [
            {
                :uuid => TEMPERATURE_CHARACTERISTIC,
                :descriptors => [BluetoothLowEnergy.cccdUuid()],
            },
            {
                :uuid => PRESSURE_CHARACTERISTIC,
                :descriptors => [BluetoothLowEnergy.cccdUuid()],
            },
            {
                :uuid => HUMIDITY_CHARACTERISTIC,
                :descriptors => [BluetoothLowEnergy.cccdUuid()],
            },
            {
                :uuid => AIR_QUALITY_CHARACTERISTIC,
                :descriptors => [BluetoothLowEnergy.cccdUuid()],
            },
        ],
    };

    //! Register the bluetooth profile
    public function registerProfiles() as Void {
        BluetoothLowEnergy.registerProfile(_envProfileDef);
    }
}
