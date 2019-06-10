//
//  RCTAppleHealthKit+Queries.h
//  RCTAppleHealthKit
//
//  Created by Greg Wilson on 2016-06-26.
//  This source code is licensed under the MIT-style license found in the
//  LICENSE file in the root directory of this source tree.
//

#import "RCTAppleHealthKit.h"

@interface RCTAppleHealthKit (Queries)

- (void)fetchHealthRecordData:(HKClinicalType *)quantityType
             predicate:(NSPredicate *)predicate
             ascending:(BOOL)asc
                 limit:(NSUInteger)lim
            completion:(void (^)(NSArray *, NSError *))completion;

@end
