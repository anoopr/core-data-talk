// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Category.h instead.

#import <CoreData/CoreData.h>
#import "BaseManagedObject.h"

@class Venue;
@class Venue;





@interface CategoryID : NSManagedObjectID {}
@end

@interface _Category : BaseManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (CategoryID*)objectID;



@property (nonatomic, retain) NSString *categoryId;

//- (BOOL)validateCategoryId:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) NSString *name;

//- (BOOL)validateName:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) NSString *iconUrl;

//- (BOOL)validateIconUrl:(id*)value_ error:(NSError**)error_;




@property (nonatomic, retain) NSSet* venues;
- (NSMutableSet*)venuesSet;



@property (nonatomic, retain) NSSet* primaryVenues;
- (NSMutableSet*)primaryVenuesSet;




@end

@interface _Category (CoreDataGeneratedAccessors)

- (void)addVenues:(NSSet*)value_;
- (void)removeVenues:(NSSet*)value_;
- (void)addVenuesObject:(Venue*)value_;
- (void)removeVenuesObject:(Venue*)value_;

- (void)addPrimaryVenues:(NSSet*)value_;
- (void)removePrimaryVenues:(NSSet*)value_;
- (void)addPrimaryVenuesObject:(Venue*)value_;
- (void)removePrimaryVenuesObject:(Venue*)value_;

@end

@interface _Category (CoreDataGeneratedPrimitiveAccessors)

- (NSString*)primitiveCategoryId;
- (void)setPrimitiveCategoryId:(NSString*)value;


- (NSString*)primitiveName;
- (void)setPrimitiveName:(NSString*)value;


- (NSString*)primitiveIconUrl;
- (void)setPrimitiveIconUrl:(NSString*)value;




- (NSMutableSet*)primitiveVenues;
- (void)setPrimitiveVenues:(NSMutableSet*)value;



- (NSMutableSet*)primitivePrimaryVenues;
- (void)setPrimitivePrimaryVenues:(NSMutableSet*)value;


@end
