'use strict'

let { AppleHealthKit } = require('react-native').NativeModules;

import { Permissions } from './Constants/Permissions'

let HealthKit = Object.assign({}, AppleHealthKit, {
	Constants: {
		Permissions: Permissions
	}
});

export default HealthKit
module.exports = HealthKit;
