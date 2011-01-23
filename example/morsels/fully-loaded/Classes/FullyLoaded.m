//
//  FullyLoaded.m
//  FullyLoaded
//
//  Created by Anoop Ranganath on 1/1/11.
//  Copyright 2011 Anoop Ranganath. All rights reserved.
//
//  
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//  
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//  
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

#import "FullyLoaded.h"
#import "SynthesizeSingleton.h"
#import "ASINetworkQueue.h"
#import "ASIHTTPRequest.h"

@interface FullyLoaded()

@property (nonatomic, readwrite, retain) ASINetworkQueue *networkQueue;
@property (nonatomic, readwrite, retain) NSOperationQueue *responseQueue;
@property (nonatomic, readwrite, retain) NSTimer *queueSuspensionTimer;
@property (nonatomic, readwrite, retain) NSMutableDictionary *imageCache;
@property (nonatomic, readwrite, retain) NSString *imageCachePath;
@property (nonatomic, readwrite, retain) NSMutableSet *inProgressURLStrings;
@property (nonatomic, readwrite, retain) NSMutableArray *pendingURLStrings;

@end

@implementation FullyLoaded

SYNTHESIZE_SINGLETON_FOR_CLASS(FullyLoaded);

@synthesize networkQueue = _networkQueue,
			responseQueue = _responseQueue,
			queueSuspensionTimer = _queueSuspensionTimer,
			pendingURLStrings = _pendingURLStrings,
			imageCache = _imageCache,
			imageCachePath = _imageCachePath,
			inProgressURLStrings = _inProgressURLStrings;

- (id)init {
	if (self = [super init]) {
		self.networkQueue = [[[ASINetworkQueue alloc] init] autorelease];
		self.networkQueue.delegate = self;
		self.networkQueue.requestDidFinishSelector = @selector(queuedRequestFinished:);
		self.networkQueue.requestDidFailSelector = @selector(queuedRequestFailed:);
		[self.networkQueue go];
		
		self.responseQueue = [[[NSOperationQueue alloc] init] autorelease];
		
		self.pendingURLStrings = [[NSMutableArray alloc] init];
		self.inProgressURLStrings = [[NSMutableSet alloc] init];
		self.imageCache = [[NSMutableDictionary alloc] init];
		self.imageCachePath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] 
							   stringByAppendingPathComponent:@"images"];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resume) name:FLIdleNotification object:nil];
	}
	return self;
}

- (void)resume {
//	NSLog(@"Resume");
	[self.networkQueue setSuspended:NO];
	[self.responseQueue setSuspended:NO];
	int pendingCount = [self.pendingURLStrings count];
	for (int i=0; i<pendingCount; i++) {
		[self enqueueURLString:[self.pendingURLStrings lastObject]];
		[self.pendingURLStrings removeLastObject];
	}
}

- (void)suspend {
//	NSLog(@"Suspend");
	[self.networkQueue setSuspended:YES];
	[self.responseQueue setSuspended:YES];
	[[NSNotificationQueue defaultQueue] enqueueNotification:[NSNotification notificationWithName:FLIdleNotification object:self ] 
											   postingStyle:NSPostWhenIdle];	
}

- (void)emptyCache {
//	NSLog(@"Emptying Cache");
	[self.imageCache removeAllObjects];
}

- (UIImage *)imageForURL:(NSString *)aURLString {
	if (aURLString == nil)
		return nil;
	
	UIImage *image = nil;
	if ((image = [self.imageCache objectForKey:aURLString])) {
		return image;
	} else if ((image = [UIImage imageWithContentsOfFile:[self pathForImage:aURLString]])) {
		[self.imageCache setObject:image forKey:aURLString];
		return image;
	} else if (![self.inProgressURLStrings containsObject:aURLString]) {
		[self.inProgressURLStrings addObject:aURLString];
		if ([self.networkQueue isSuspended]) {
//			NSLog(@"Pending: %@", aURLString);
			[self.pendingURLStrings addObject:aURLString];
		} else {
			[self enqueueURLString:aURLString];
		}
	}
	return nil;
}

- (NSString *)pathForImage:(NSString *)aURLString {
	NSURL *url = [NSURL URLWithString:aURLString];
	NSString *targetPath = [self.imageCachePath stringByAppendingPathComponent:[url host]];
	return [targetPath stringByAppendingPathComponent:[url path]];	
}

- (NSString *)directoryForImage:(NSString *)aURLString {
	return [[self pathForImage:aURLString] stringByDeletingLastPathComponent];
}

- (void)enqueueURLString:(NSString *)aURLString {
//	NSLog(@"Enqueuing: %@", [[request url] absoluteString]);
	[[NSFileManager defaultManager] createDirectoryAtPath:[self directoryForImage:aURLString] withIntermediateDirectories:YES attributes:nil error:nil];
	ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:aURLString]];
	request.downloadDestinationPath = [self pathForImage:aURLString]; 
	[self.networkQueue addOperation:request];
}

- (void)queuedRequestFinished:(ASIHTTPRequest *)request {
	NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(loadImageOnMainThread:) object:request];
	[self.responseQueue addOperation:operation];
	[operation release];
}

- (void)queuedRequestFailed:(ASIHTTPRequest *)request {
	NSLog(@"Failed: %@", [[request url] absoluteString]);
	[self.inProgressURLStrings removeObject:[[request url] absoluteString]];	
}

- (void)loadImageOnMainThread:(ASIHTTPRequest *)request {
	[self performSelectorOnMainThread:@selector(loadImage:) withObject:request waitUntilDone:YES];
}

- (void)loadImage:(ASIHTTPRequest *)request {
//	NSLog(@"Handling: %@", [[request url] absoluteString]);
	UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfFile:[self pathForImage:[[request url] absoluteString]]]];
	[self.imageCache setObject:image forKey:[[request url] absoluteString]];
	[self.inProgressURLStrings removeObject:[[request url] absoluteString]];
	[[NSNotificationCenter defaultCenter] postNotificationName:FLImageLoadedNotification
														object:self];	
}

- (void)dealloc {
	self.networkQueue = nil;
	self.queueSuspensionTimer = nil;
	self.imageCache = nil;
	self.imageCachePath = nil;
	self.inProgressURLStrings = nil;
	[super dealloc];
}

@end
