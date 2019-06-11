//
//  RCTAppleHealthKit+Queries.m
//  RCTAppleHealthKit
//
//  Created by Greg Wilson on 2016-06-26.
//  This source code is licensed under the MIT-style license found in the
//  LICENSE file in the root directory of this source tree.
//

#import "RCTAppleHealthKit+Queries.h"

#import <React/RCTBridgeModule.h>
#import <React/RCTEventDispatcher.h>

@implementation RCTAppleHealthKit (Queries)

- (void)fetchHealthRecordData:(HKClinicalType *)clinicalType
                    predicate:(NSPredicate *)predicate
                    ascending:(BOOL)asc
                        limit:(NSUInteger)lim
                   completion:(void (^)(NSArray *, NSError *))completion {
    
    NSSortDescriptor *timeSortDescriptor = [[NSSortDescriptor alloc] initWithKey:HKSampleSortIdentifierEndDate
                                                                       ascending:asc];
    
    // declare the block
    void (^handlerBlock)(HKSampleQuery *query, NSArray *results, NSError *error);
    // create and assign the block
    handlerBlock = ^(HKSampleQuery *query, NSArray *results, NSError *error) {
        if (!results) {
            if (completion) {
                completion(nil, error);
            }
            return;
        }
        
        if (completion) {
            NSMutableArray *data = [NSMutableArray arrayWithCapacity:1];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                for (HKClinicalRecord *response in results) {
                    //NSError *error;
                    //NSDictionary *json = [NSJSONSerialization JSONObjectWithData:response.FHIRResource.data options:kNilOptions error:&error];
                    NSDictionary *obj = @{ @"displayName": response.displayName, @"FHIRResource": response.FHIRResource.data};
                    [data addObject:obj];
                }
                
                completion(data, error);
            });
        }
    };
    
    HKSampleQuery *query = [[HKSampleQuery alloc] initWithSampleType:clinicalType
                                                           predicate:predicate
                                                               limit:lim
                                                     sortDescriptors:@[timeSortDescriptor]
                                                      resultsHandler:handlerBlock];
    
    [self.healthStore executeQuery:query];
}

@end
