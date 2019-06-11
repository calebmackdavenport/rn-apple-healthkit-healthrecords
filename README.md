
# React Native Apple Healthkit Health Records
A React Native bridge module for interacting with Apple Healthkit's Health Records data.

## Health Records version
This version only retrieves health record information from Apple Healthkit [Health Records](https://developer.apple.com/documentation/healthkit/samples/accessing_health_records?language=objc).  

Simply request permission of the corresponding Health Record data you need from the list:  
`"Allergies", "ClinicalVitals", "Conditions", "Immunizations", "Labs", "Medications", "Procedures"`.  
And call the associated function to retrieve the data:  
`getAllergyRecords, getClinicalVitalRecords, getMedicationRecords, getConditionRecords, getImmunizationRecords, getProcedureRecords, getLabRecords`
  
Each response returns an array of arrays for each entry.  
Position 0 is the name of entry, position 1 is the FHIR object.  



## Installation

Install the [rn-apple-healthkit-healthrecords] package from npm:

- Run `npm install rn-apple-healthkithealthrecords --save`
- Run `react-native link rn-apple-healthkit-healthrecords`

Update `info.plist` in your React Native project
```
<key>NSHealthShareUsageDescription</key>
<string>Read and understand health data.</string>
<key>NSHealthUpdateUsageDescription</key>
<string>Share workout data with other apps.</string>
```
In XCode, turn on HealthKit and ensure Clinical Health Records is enabled under the capabilities tab. Clinical Health records access requires that your account has this feature enabled.

## Manual Installation

1. Run `npm install rn-apple-healthkit --save`
2. In XCode, in the project navigator, right click `Libraries` ➜ `Add Files to [your project's name]`
3. Go to `node_modules` ➜ `rn-apple-healthkit` and add `RCTAppleHealthkit.xcodeproj`
4. In XCode, in the project navigator, select your project. Add `libRCTAppleHealthkit.a` to your project's `Build Phases` ➜ `Link Binary With Libraries`
5. Click `RCTAppleHealthkit.xcodeproj` in the project navigator and go the `Build Settings` tab. Make sure 'All' is toggled on (instead of 'Basic'). In the `Search Paths` section, look for `Header Search Paths` and make sure it contains both `$(SRCROOT)/../../react-native/React` and `$(SRCROOT)/../../../React` - mark both as `recursive`.
6. Enable Healthkit in your application's `Capabilities`
![](https://i.imgur.com/eOCCCyv.png "Xcode Capabilities Section")
7. Compile and run

## Get Started
Initialize Healthkit. This will show the Healthkit permissions prompt for any read/write permissions set in the required `options` object.

Due to Apple's privacy model if an app user has previously denied a specific permission then they can not be prompted again for that same permission. The app user would have to go into the Apple Health app and grant the permission to your react-native app under *sources* tab.

For any data that is read from Healthkit the status/error is the same for both. This privacy restriction results in having no knowledge of whether the permission was denied (make sure it's added to the permissions options object), or the data for the specific request was nil (ex. no steps recorded today).

If new read/write permissions are added to the options object then the app user will see the Healthkit permissions prompt with the new permissions to allow.


### Sample excerpt  

`initHealthKit` requires an options object with Healthkit permission settings
```javascript
import AppleHealthKit from 'rn-apple-healthkit-healthrecords';
const PERMS = AppleHealthKit.Constants.Permissions;

let options = {
  permissions: {
      read: [ "Allergies", "ClinicalVitals", "Conditions", "Immunizations", "Labs", "Medications", "Procedures", ],
  }
 };
 
AppleHealthKit.initHealthKit(options: Object, (err: string, results: Object) => {
    if (err) {
        console.log("error initializing Healthkit: ", err);
        return;
    }

    AppleHealthKit.getAllergyRecords(null, (err, allergies) => {
        if (this._handleHealthkitError(err, 'allergies')) {
          console.log('err', err)
          return;
        }
        console.log(allergies[0])
    }

 });
```

```javascript
/* Output for Apple Health example patient with a peanut allergy */
[
  displayName: "Peanuts",
  FHIRResource: 
  {
    "id": "2",
    "resourceType": "AllergyIntolerance",
    "substance": {
      "text": "Peanuts",
      "coding": [{
        "system": "http://snomed.info/sct",
        "code": "256349002"
      }]
    },
    "recordedDate": "2015-02-18",
    "patient": {
      "display": "Candace Salinas",
      "reference": "Patient/1"
    },
    "reaction": [{
      "manifestation": [{
        "text": "Wheezing"
      }],
      "severity": "severe"
    }]
  }
]
```

## References
- Apple Healthkit Documentation [https://developer.apple.com/Healthkit/](https://developer.apple.com/Healthkit/)
