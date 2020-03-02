//
//  Locations.h
//  FreeNowTest
//
//  Created by Venkata Subbaiah Sama on 04/08/19.
//  Copyright © 2019 Venkata. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Locations : NSObject

@property (nonatomic) NSString *firstLatitude;
@property (nonatomic) NSString *firstLongitude;
@property (nonatomic) NSString *secondLatitude;
@property (nonatomic) NSString *secondLongitude;

-(instancetype)initWithDefault;
-(instancetype) initWithLocationFirstLat:(NSString *)firstLat
                            FirstLon:(NSString *)firstLon
                       secondLat:(NSString *)secondLat
                      secondLon:(NSString *)secondLong;
@end

NS_ASSUME_NONNULL_END
