//
// Copyright 2019-2021 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//

import Toybox.BluetoothLowEnergy;

class ProfileManager {
    public
    const THINGY_CONFIGURATION_SERVICE = BluetoothLowEnergy.longToUuid(
        0xef6801009b354933l,
        0x9b1052ffa9740042l
    );

    public
    const THINGY_SOUND_SERVICE = BluetoothLowEnergy.longToUuid(
        0xef6805009b354933l,
        0x9b1052ffa9740042l
    );
    public
    const SOUND_CONFIG_CHARACTERISTIC = BluetoothLowEnergy.longToUuid(
        0xef6805019b354933l,
        0x9b1052ffa9740042l
    );
    public
    const SPEAKER_DATA_CHARACTERISTIC = BluetoothLowEnergy.longToUuid(
        0xef6805029b354933l,
        0x9b1052ffa9740042l
    );

    private
    const _soundProfileDef = {
        :uuid => THINGY_SOUND_SERVICE,
        :characteristics
        =>
        [
            {
                :uuid => SOUND_CONFIG_CHARACTERISTIC,
            },
            {
                :uuid => SPEAKER_DATA_CHARACTERISTIC,
            },
        ],
    };

    //! Register the bluetooth profile
    public function registerProfiles() as Void {
        BluetoothLowEnergy.registerProfile(_soundProfileDef);
    }
}
