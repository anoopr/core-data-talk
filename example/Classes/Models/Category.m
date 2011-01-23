#import "Category.h"

@implementation Category

- (void)updateWithDictionary:(NSDictionary *)aDictionary {
	self.categoryId = [aDictionary objectForKey:@"id"];
	self.name = [aDictionary objectForKey:@"name"];
	self.iconUrl = [aDictionary objectForKey:@"icon"];
}

@end
