//
// Copyright 2019-2021 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//

import Toybox.BluetoothLowEnergy;

class ProfileManager {
    public const THINGY_CONFIGURATION_SERVICE = BluetoothLowEnergy.longToUuid(0xEF6801009B354933L, 0x9B1052FFA9740042L);

    public const THINGY_SOUND_SERVICE         = BluetoothLowEnergy.longToUuid(0xEF6805009B354933L, 0x9B1052FFA9740042L);
    public const SOUND_CONFIG_CHARACTERISTIC  = BluetoothLowEnergy.longToUuid(0xEF6805019B354933L, 0x9B1052FFA9740042L);
    public const SPEAKER_DATA_CHARACTERISTIC  = BluetoothLowEnergy.longToUuid(0xEF6805029B354933L, 0x9B1052FFA9740042L);

    private const _soundProfileDef = {
        :uuid => THINGY_SOUND_SERVICE,
        :characteristics => [{
            :uuid => SOUND_CONFIG_CHARACTERISTIC
        }, {
            :uuid => SPEAKER_DATA_CHARACTERISTIC
        }]
    };

    //! Register the bluetooth profile
    public function registerProfiles() as Void {
        BluetoothLowEnergy.registerProfile(_soundProfileDef);
    }
}
