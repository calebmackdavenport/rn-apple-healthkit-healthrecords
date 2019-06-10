//
//  RCTAppleHealthKit+Methods_Activity.m
//  RCTAppleHealthKit
//
//  Created by Alexander Vallorosi on 4/27/17.
//  This source code is licensed under the MIT-style license found in the
//  LICENSE file in the root directory of this source tree.

#import "RCTAppleHealthKit+Methods_Immunization.h"
#import "RCTAppleHealthKit+Queries.h"

@implementation RCTAppleHealthKit (Methods_Immunization)

- (void)immunization_getImmunizationRecords:(NSDictionary *)input callback:(RCTResponseSenderBlock)callback
{
    [self fetchHealthRecordData:[HKClinicalType clinicalTypeForIdentifier:HKClinicalTypeIdentifierImmunizationRecord]
               predicate:nil
               ascending:false
                   limit:HKObjectQueryNoLimit
                          completion:^(NSArray *results, NSError *error) {
                              if(results){
                                  callback(@[[NSNull null], results]);
                                  return;
                              } else {
                                  NSLog(@"error getting allergies: %@", error);
                                  callback(@[RCTMakeError(@"error getting immunizations", nil, nil)]);
                                  return;
                              }
                          }];
}

@end
