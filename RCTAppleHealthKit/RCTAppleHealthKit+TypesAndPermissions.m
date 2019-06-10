//
//  RCTAppleHealthKit+TypesAndPermissions.m
//  RCTAppleHealthKit
//
//  Created by Greg Wilson on 2016-06-26.
//  This source code is licensed under the MIT-style license found in the
//  LICENSE file in the root directory of this source tree.
//

#import "RCTAppleHealthKit+TypesAndPermissions.h"

@implementation RCTAppleHealthKit (TypesAndPermissions)


#pragma mark - HealthKit Permissions

- (NSDictionary *)readPermsDict {
    NSDictionary *readPerms = @{
        // Health Records
        @"Allergies" : [HKObjectType clinicalTypeForIdentifier: HKClinicalTypeIdentifierAllergyRecord],
        @"Medications" : [HKObjectType clinicalTypeForIdentifier: HKClinicalTypeIdentifierMedicationRecord],
        @"Conditions" : [HKObjectType clinicalTypeForIdentifier: HKClinicalTypeIdentifierConditionRecord],
        @"Immunizations" : [HKObjectType clinicalTypeForIdentifier: HKClinicalTypeIdentifierImmunizationRecord],
        @"Procedures" : [HKObjectType clinicalTypeForIdentifier: HKClinicalTypeIdentifierProcedureRecord],
        @"Labs" : [HKObjectType clinicalTypeForIdentifier: HKClinicalTypeIdentifierLabResultRecord],
        @"ClinicalVitals" : [HKObjectType clinicalTypeForIdentifier: HKClinicalTypeIdentifierVitalSignRecord],
    };
    return readPerms;
}

// Returns HealthKit read permissions from options array
- (NSSet *)getReadPermsFromOptions:(NSArray *)options {
    NSDictionary *readPermDict = [self readPermsDict];
    NSMutableSet *readPermSet = [NSMutableSet setWithCapacity:1];

    for(int i=0; i<[options count]; i++) {
        NSString *optionKey = options[i];
        HKObjectType *val = [readPermDict objectForKey:optionKey];
        if(val != nil) {
            [readPermSet addObject:val];
        }
    }
    return readPermSet;
}

- (NSString *)getAuthorizationStatusString:(HKAuthorizationStatus)status {
    switch (status) {
        case HKAuthorizationStatusNotDetermined:
            return @"NotDetermined";
        case HKAuthorizationStatusSharingDenied:
            return @"SharingDenied";
        case HKAuthorizationStatusSharingAuthorized:
            return @"SharingAuthorized";
    }
}

@end
