//
//  BaseDataOperation.m
//  CoreDataTalk
//
//  Created by Anoop Ranganath on 1/22/11.
//  Copyright 2011 Anoop Ranganath. All rights reserved.
//

#import "BaseDataOperation.h"
#import "JSONKit.h"
#import "CoreDataTalkAppDelegate.h"

@interface BaseDataOperation()

@property (nonatomic, readwrite, retain) ASIHTTPRequest *request;
@property (nonatomic, readwrite, retain) NSDictionary *responseDictionary;

@end

@implementation BaseDataOperation

static NSOperationQueue *dataQueue = nil;

+ (void)initialize {
	if (self == [BaseDataOperation class]) {
		dataQueue = [[NSOperationQueue alloc] init];
		[dataQueue setMaxConcurrentOperationCount:1];
	}
}

@synthesize request = _request,
			responseDictionary = _responseDictionary;

- (id)initWithURL:(NSURL *)aURL {
	if (self = [super init]) {
		self.request = [ASIHTTPRequest requestWithURL:aURL];
		self.request.delegate = self;
	}
	return self;
}

- (void)startRequest {
	NSLog(@"Request Starting: %@", [[self.request url] absoluteString]);
	[self.request startAsynchronous];
}

- (void)requestFinished:(ASIHTTPRequest *)request {
	self.responseDictionary = [[request responseData] objectFromJSONData];
	[dataQueue addOperation:self];
}

- (void)requestFailed:(ASIHTTPRequest *)request {
	NSLog(@"Request Failed: %@\n%@", [[request url] absoluteString], [request.error localizedDescription]);
}

- (void)main {
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	NSPersistentStoreCoordinator *psc = ((CoreDataTalkAppDelegate *) [UIApplication sharedApplication].delegate).persistentStoreCoordinator;
	NSManagedObjectContext *moc = [[NSManagedObjectContext alloc] init];
	[moc setPersistentStoreCoordinator:psc];
	
	[self updateManagedObjectContext:moc];
	
	[moc save:nil];
	[moc release];
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void)updateManagedObjectContext:(NSManagedObjectContext *)moc {
	[NSException raise:NSInternalInconsistencyException
				format:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)];
}

- (void)dealloc {
	if (self.request) {
		[self.request clearDelegatesAndCancel];
		self.request = nil;		
	}
	self.responseDictionary = nil;
	[super dealloc];
}


@end
