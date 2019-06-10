//
//  RCTAppleHealthKit.m
//  RCTAppleHealthKit
//
//  Created by Greg Wilson on 2016-06-26.
//  This source code is licensed under the MIT-style license found in the
//  LICENSE file in the root directory of this source tree.
//

#import "RCTAppleHealthKit.h"
#import "RCTAppleHealthKit+TypesAndPermissions.h"

#import "RCTAppleHealthKit+Methods_Allergy.h"
#import "RCTAppleHealthKit+Methods_Medication.h"
#import "RCTAppleHealthKit+Methods_Condition.h"
#import "RCTAppleHealthKit+Methods_Immunization.h"
#import "RCTAppleHealthKit+Methods_Procedure.h"
#import "RCTAppleHealthKit+Methods_Lab.h"
#import "RCTAppleHealthKit+Methods_ClinicalVitals.h"

#import <React/RCTBridgeModule.h>
#import <React/RCTEventDispatcher.h>

@implementation RCTAppleHealthKit

@synthesize bridge = _bridge;

RCT_EXPORT_MODULE();

RCT_EXPORT_METHOD(isAvailable:(RCTResponseSenderBlock)callback)
{
    [self isHealthKitAvailable:callback];
}

RCT_EXPORT_METHOD(initHealthKit:(NSDictionary *)input callback:(RCTResponseSenderBlock)callback)
{
    [self initializeHealthKit:input callback:callback];
}

// Begin Health Records
RCT_EXPORT_METHOD(getAllergyRecords:(NSDictionary *)input callback:(RCTResponseSenderBlock)callback)
{
    [self allergy_getAllergyRecords:input callback:callback];
}
RCT_EXPORT_METHOD(getMedicationRecords:(NSDictionary *)input callback:(RCTResponseSenderBlock)callback)
{
    [self medication_getMedicationRecords:input callback:callback];
}
RCT_EXPORT_METHOD(getConditionRecords:(NSDictionary *)input callback:(RCTResponseSenderBlock)callback)
{
    [self condition_getConditionRecords:input callback:callback];
}
RCT_EXPORT_METHOD(getImmunizationRecords:(NSDictionary *)input callback:(RCTResponseSenderBlock)callback)
{
    [self immunization_getImmunizationRecords:input callback:callback];
}
RCT_EXPORT_METHOD(getProcedureRecords:(NSDictionary *)input callback:(RCTResponseSenderBlock)callback)
{
    [self procedure_getProcedureRecords:input callback:callback];
}
RCT_EXPORT_METHOD(getLabRecords:(NSDictionary *)input callback:(RCTResponseSenderBlock)callback)
{
    [self lab_getLabRecords:input callback:callback];
}
RCT_EXPORT_METHOD(getClinicalVitalRecords:(NSDictionary *)input callback:(RCTResponseSenderBlock)callback)
{
    [self clinicalVitals_getClinicalVitalsRecords:input callback:callback];
}
// End Health Records

- (void)isHealthKitAvailable:(RCTResponseSenderBlock)callback
{
    BOOL isAvailable = NO;
    if ([HKHealthStore isHealthDataAvailable]) {
        isAvailable = YES;
    }
    callback(@[[NSNull null], @(isAvailable)]);
}


- (void)initializeHealthKit:(NSDictionary *)input callback:(RCTResponseSenderBlock)callback
{
    self.healthStore = [[HKHealthStore alloc] init];

    if ([HKHealthStore isHealthDataAvailable]) {
        NSSet *writeDataTypes;
        NSSet *readDataTypes;

        // get permissions from input object provided by JS options argument
        NSDictionary* permissions =[input objectForKey:@"permissions"];
        if(permissions != nil){
            NSArray* readPermsArray = [permissions objectForKey:@"read"];
            NSSet* readPerms = [self getReadPermsFromOptions:readPermsArray];

            if(readPerms != nil) {
                readDataTypes = readPerms;
            }
        } else {
            callback(@[RCTMakeError(@"permissions must be provided in the initialization options", nil, nil)]);
            return;
        }

        // make sure at least 1 permission is provided
        if(!readDataTypes){
            callback(@[RCTMakeError(@"at least 1 permission must be set in options.permissions", nil, nil)]);
            return;
        }

        [self.healthStore requestAuthorizationToShareTypes:writeDataTypes readTypes:readDataTypes completion:^(BOOL success, NSError *error) {
            if (!success) {
                callback(@[RCTJSErrorFromNSError(error)]);
                return;
            } else {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    callback(@[[NSNull null], @true]);
                });
            }
        }];
    } else {
        callback(@[RCTMakeError(@"HealthKit data is not available", nil, nil)]);
    }
}

RCT_EXPORT_METHOD(authorizationStatusForType:(NSString *)type
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject
{
    if (self.healthStore == nil) {
        self.healthStore = [[HKHealthStore alloc] init];
    }

    if ([HKHealthStore isHealthDataAvailable]) {
        NSString *status = [self getAuthorizationStatusString:[self.healthStore authorizationStatusForType:objectType]];
        resolve(status);
    } else {
        reject(@"HealthKit data is not available", nil, nil);
    }
})

- (void)getModuleInfo:(NSDictionary *)input callback:(RCTResponseSenderBlock)callback
{
    NSDictionary *info = @{
            @"name" : @"rn-apple-healthkit-healthrecords",
            @"description" : @"A React Native bridge module for interacting with Apple Health Records data",
            @"className" : @"RCTAppleHealthKit",
            @"author": @"Mack Davenport",
    };
    callback(@[[NSNull null], info]);
}

@end
