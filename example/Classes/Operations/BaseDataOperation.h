//
//  BaseDataOperation.h
//  CoreDataTalk
//
//  Created by Anoop Ranganath on 1/22/11.
//  Copyright 2011 Anoop Ranganath. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"

@interface BaseDataOperation : NSOperation {

}

@property (nonatomic, readonly, retain) ASIHTTPRequest *request;
@property (nonatomic, readonly, retain) NSDictionary *responseDictionary;

- (id)initWithURL:(NSURL *)aURL;
- (void)startRequest;
- (void)updateManagedObjectContext:(NSManagedObjectContext *)moc;

@end
