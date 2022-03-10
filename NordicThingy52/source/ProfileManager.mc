//
// Copyright 2019-2021 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//

import Toybox.BluetoothLowEnergy;

class ProfileManager {
    public const THINGY_ENVIRONMENTAL_SERVICE = BluetoothLowEnergy.longToUuid(0xEF6802009B354933L, 0x9B1052FFA9740042L);
    public const TEMPERATURE_CHARACTERISTIC   = BluetoothLowEnergy.longToUuid(0xEF6802019B354933L, 0x9B1052FFA9740042L);
    public const PRESSURE_CHARACTERISTIC      = BluetoothLowEnergy.longToUuid(0xEF6802029B354933L, 0x9B1052FFA9740042L);
    public const HUMIDITY_CHARACTERISTIC      = BluetoothLowEnergy.longToUuid(0xEF6802039B354933L, 0x9B1052FFA9740042L);
    public const AIR_QUALITY_CHARACTERISTIC   = BluetoothLowEnergy.longToUuid(0xEF6802049B354933L, 0x9B1052FFA9740042L);

    public const THINGY_CONFIGURATION_SERVICE = BluetoothLowEnergy.longToUuid(0xEF6801009B354933L, 0x9B1052FFA9740042L);

    private const _envProfileDef = {
        :uuid => THINGY_ENVIRONMENTAL_SERVICE,
        :characteristics => [{
            :uuid => TEMPERATURE_CHARACTERISTIC,
            :descriptors => [BluetoothLowEnergy.cccdUuid()]
        }, {
            :uuid => PRESSURE_CHARACTERISTIC,
            :descriptors => [BluetoothLowEnergy.cccdUuid()]
        }, {
            :uuid => HUMIDITY_CHARACTERISTIC,
            :descriptors => [BluetoothLowEnergy.cccdUuid()]
        }, {
            :uuid => AIR_QUALITY_CHARACTERISTIC,
            :descriptors => [BluetoothLowEnergy.cccdUuid()]
        }]
    };

    //! Register the bluetooth profile
    public function registerProfiles() as Void {
        BluetoothLowEnergy.registerProfile(_envProfileDef);
    }
}
