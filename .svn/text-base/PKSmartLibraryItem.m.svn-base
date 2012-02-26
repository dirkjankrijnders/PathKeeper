// 
//  PKSmartLibraryItem.m
//  PathKeeper
//
//  Created by Dirkjan Krijnders on 10/25/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "PKSmartLibraryItem.h"


@implementation PKSmartLibraryItem 

@dynamic title;
@dynamic predicate;
@dynamic order;

- (NSString*) displayName
{
	return [self title];
};

- (NSPredicate*) filterPredicate;
{
	return [self predicate];
};

#pragma mark Outline view citizen

-(int) numberOfChildren
{
	return 0;
};

-(bool) isItemExpandable
{
	return NO;
}

@end
