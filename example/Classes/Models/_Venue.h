// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Venue.h instead.

#import <CoreData/CoreData.h>
#import "BaseManagedObject.h"

@class Category;
@class Category;




@interface VenueID : NSManagedObjectID {}
@end

@interface _Venue : BaseManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (VenueID*)objectID;



@property (nonatomic, retain) NSString *name;

//- (BOOL)validateName:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) NSString *venueId;

//- (BOOL)validateVenueId:(id*)value_ error:(NSError**)error_;




@property (nonatomic, retain) NSSet* categories;
- (NSMutableSet*)categoriesSet;



@property (nonatomic, retain) Category* primaryCategory;
//- (BOOL)validatePrimaryCategory:(id*)value_ error:(NSError**)error_;




@end

@interface _Venue (CoreDataGeneratedAccessors)

- (void)addCategories:(NSSet*)value_;
- (void)removeCategories:(NSSet*)value_;
- (void)addCategoriesObject:(Category*)value_;
- (void)removeCategoriesObject:(Category*)value_;

@end

@interface _Venue (CoreDataGeneratedPrimitiveAccessors)

- (NSString*)primitiveName;
- (void)setPrimitiveName:(NSString*)value;


- (NSString*)primitiveVenueId;
- (void)setPrimitiveVenueId:(NSString*)value;




- (NSMutableSet*)primitiveCategories;
- (void)setPrimitiveCategories:(NSMutableSet*)value;



- (Category*)primitivePrimaryCategory;
- (void)setPrimitivePrimaryCategory:(Category*)value;


@end
