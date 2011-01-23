// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Category.m instead.

#import "_Category.h"

@implementation CategoryID
@end

@implementation _Category

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Category" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Category";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Category" inManagedObjectContext:moc_];
}

- (CategoryID*)objectID {
	return (CategoryID*)[super objectID];
}




@dynamic categoryId;






@dynamic name;






@dynamic iconUrl;






@dynamic venues;

	
- (NSMutableSet*)venuesSet {
	[self willAccessValueForKey:@"venues"];
	NSMutableSet *result = [self mutableSetValueForKey:@"venues"];
	[self didAccessValueForKey:@"venues"];
	return result;
}
	

@dynamic primaryVenues;

	
- (NSMutableSet*)primaryVenuesSet {
	[self willAccessValueForKey:@"primaryVenues"];
	NSMutableSet *result = [self mutableSetValueForKey:@"primaryVenues"];
	[self didAccessValueForKey:@"primaryVenues"];
	return result;
}
	





@end
