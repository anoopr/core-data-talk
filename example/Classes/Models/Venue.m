#import "Venue.h"
#import "Category.h"

@implementation Venue

- (void)updateWithDictionary:(NSDictionary *)aDictionary {
	self.venueId = [aDictionary objectForKey:@"id"];
	self.name = [aDictionary objectForKey:@"name"];

	NSArray *categoryDicts = [aDictionary objectForKey:@"categories"];
	if (categoryDicts) {
		NSMutableSet *categoryEntities = [NSMutableSet set];
		for (NSDictionary *categoryDict in categoryDicts) {
			Category *category = [Category updateOrInsertWithDictionary:categoryDict managedObjectContext:[self managedObjectContext]];
			[categoryEntities addObject:category];
			if ([categoryDict objectForKey:@"primary"])
				self.primaryCategory = category;
		}
		self.categories = categoryEntities;
	}
}

@end
