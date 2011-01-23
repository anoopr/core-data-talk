//
//  BaseManagedObject.h
//  CoreDataTalk
//
//  Created by Anoop Ranganath on 1/22/11.
//  Copyright 2011 Anoop Ranganath. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface BaseManagedObject : NSManagedObject {

}

+ (void)primeCacheWithIds:(NSArray *)ids managedObjectContext:(NSManagedObjectContext *)moc;
+ (void)primeCacheWithIds:(NSArray *)ids relationshipKeyPaths:(NSArray *)keyPaths managedObjectContext:(NSManagedObjectContext *)moc;
+ (void)flushCache;
+ (id)updateOrInsertWithDictionary:(NSDictionary *)aDictionary managedObjectContext:(NSManagedObjectContext *)moc;
- (void)updateWithDictionary:(NSDictionary *)aDictionary;

@end
