//
//  BaseManagedObject.m
//  CoreDataTalk
//
//  Created by Anoop Ranganath on 1/22/11.
//  Copyright 2011 Anoop Ranganath. All rights reserved.
//

#import "BaseManagedObject.h"

@interface BaseManagedObject()

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSMutableDictionary *)threadCache;
+ (NSMutableDictionary *)entityCache;
+ (NSArray *)fetchOrInsertWithIds:(NSArray *)ids relationshipKeyPaths:(NSArray *)keyPaths managedObjectContext:(NSManagedObjectContext *)moc;
+ (BaseManagedObject *)fetchOrInsertWithId:(NSString *)anId managedObjectContext:(NSManagedObjectContext *)moc;
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;

@end

@implementation BaseManagedObject

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	[NSException raise:NSInternalInconsistencyException
				format:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)];
	return nil;
}

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	[NSException raise:NSInternalInconsistencyException
				format:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)];
	return nil;
}

+ (NSString *)idKeyName {
	// This turns Venue into venueId or Category into categoryId
	return [NSString stringWithFormat:@"%@Id", [NSStringFromClass(self) lowercaseString]];
}

+ (NSMutableDictionary *)threadCache {
	// NSManagedObjectContext is not thread safe, so we store the cache in a threadDictionary
	NSMutableDictionary *cacheDictionary = [[[NSThread currentThread] threadDictionary] objectForKey:@"BaseManagedObjectCache"];
	if (cacheDictionary == nil) {
		cacheDictionary = [NSMutableDictionary dictionary];
		[[[NSThread currentThread] threadDictionary] setObject:cacheDictionary forKey:@"BaseManagedObjectCache"];
	}
	return cacheDictionary;
}

+ (NSMutableDictionary *)entityCache {
	NSMutableDictionary *entityDictionary = [[self threadCache] objectForKey:NSStringFromClass(self)];
	if (entityDictionary == nil) {
		entityDictionary = [NSMutableDictionary dictionary];
		[[self threadCache] setObject:entityDictionary forKey:NSStringFromClass(self)];
	}
	return entityDictionary;
}

+ (BaseManagedObject *)fetchOrInsertWithId:(NSString *)anId managedObjectContext:(NSManagedObjectContext *)moc {
	if ([[self entityCache] objectForKey:anId]) {
		return [[self entityCache] objectForKey:anId];
	}
	NSArray *entities = [self fetchOrInsertWithIds:[NSArray arrayWithObject:anId]
							  relationshipKeyPaths:nil
							  managedObjectContext:moc];
	BaseManagedObject *entity = nil;
	if ([entities count] == 0) {
		entity = [self insertInManagedObjectContext:moc];
	} else if ([entities count] == 1) {
		entity = [entities objectAtIndex:0];
	} else {
		[NSException raise:NSInternalInconsistencyException format:@"Found %d %@ with Id: %@", 
		 [entities count], NSStringFromClass(self), anId];
	}
	return entity;
}

+ (NSArray *)fetchOrInsertWithIds:(NSArray *)ids relationshipKeyPaths:(NSArray *)keyPaths managedObjectContext:(NSManagedObjectContext *)moc {
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	[fetchRequest setEntity:[self entityInManagedObjectContext:moc]];
	[fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"%K IN %@", [self idKeyName], ids]];
	if (keyPaths != nil) {
		[fetchRequest setRelationshipKeyPathsForPrefetching:keyPaths];
	}
	NSArray *entities = [moc executeFetchRequest:fetchRequest error:nil];
	return entities;
}

+ (NSArray *)flattenIds:(NSArray *)ids {
	NSMutableSet *idSet = [NSMutableSet set];
	for (id element in ids) {
		if ([element isKindOfClass:[NSArray class]]) {
			[idSet addObjectsFromArray:[self flattenIds:element]];
		} else {
			[idSet addObject:element];
		}
	}
	return [idSet allObjects];
}

+ (void)primeCacheWithIds:(NSArray *)ids managedObjectContext:(NSManagedObjectContext *)moc {
	[self primeCacheWithIds:ids relationshipKeyPaths:nil managedObjectContext:moc];
}

+ (void)primeCacheWithIds:(NSArray *)ids relationshipKeyPaths:(NSArray *)keyPaths managedObjectContext:(NSManagedObjectContext *)moc {
	ids = [self flattenIds:ids];
	NSMutableArray *entities = [NSMutableArray arrayWithArray:[self fetchOrInsertWithIds:ids relationshipKeyPaths:keyPaths managedObjectContext:moc]];
	NSArray *entityIds = [entities valueForKeyPath:[self idKeyName]];
	for (NSString *anId in ids) {
		if (![entityIds containsObject:anId]) {
			BaseManagedObject *entity = [self insertInManagedObjectContext:moc];
			[entity setValue:anId forKey:[self idKeyName]];
			[entities addObject:entity];
		}
	}
	NSMutableDictionary *entityCache = [self entityCache];
	for (id entity in entities) {
		[entityCache setObject:entity forKey:[entity valueForKey:[self idKeyName]]];
	}
}

+ (void)flushCache {
	NSMutableDictionary *cacheDictionary = [[[NSThread currentThread] threadDictionary] objectForKey:@"BaseManagedObjectCache"];
	if (cacheDictionary == nil) {
		cacheDictionary = [NSMutableDictionary dictionary];
		[[[NSThread currentThread] threadDictionary] setObject:cacheDictionary forKey:@"BaseManagedObjectCache"];
	}
	[cacheDictionary removeObjectForKey:NSStringFromClass(self)];
}

+ (id)updateOrInsertWithDictionary:(NSDictionary *)aDictionary managedObjectContext:(NSManagedObjectContext *)moc {
	BaseManagedObject *entity = [self fetchOrInsertWithId:[aDictionary objectForKey:@"id"] managedObjectContext:moc];
	[entity updateWithDictionary:aDictionary];
	return entity;
}

- (void)updateWithDictionary:(NSDictionary *)aDictionary {
	[NSException raise:NSInternalInconsistencyException
				format:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)];
}

@end
