//
//  NearbyVenuesOperation.h
//  CoreDataTalk
//
//  Created by Anoop Ranganath on 1/22/11.
//  Copyright 2011 Anoop Ranganath. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "BaseDataOperation.h"

@interface NearbyVenuesOperation : BaseDataOperation {

}

- (id)initWithLocation:(CLLocation *)location;

@end
