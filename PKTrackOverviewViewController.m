//
//  PKTrackOverviewViewController.m
//  PathKeeper
//
//  Created by Dirkjan Krijnders on 8/5/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "PKTrackOverviewViewController.h"
#import "PKGPSSelectionViewController.h"
#import "PKTrackMO.h"

@implementation PKTrackOverviewViewController

#pragma mark Tokenfield delegate protocol implementation
- (NSArray *)tokenField:(NSTokenField *)tokenFieldArg 
completionsForSubstring:(NSString *)substring 
		   indexOfToken:(NSInteger)tokenIndex 
	indexOfSelectedItem:(NSInteger *)selectedIndex
{
	NSManagedObjectContext *moc = [[NSApp delegate] managedObjectContext];
	NSEntityDescription *entityDescription = [NSEntityDescription
											  entityForName:@"Category" inManagedObjectContext:moc];
	
	NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
	[request setEntity:entityDescription];
	NSError* error =  nil;
//	NSPredicate* namePredicate = [NSPredicate predicateWithFormat:@"name == %@", [sender title]];
//	[request setPredicate:namePredicate];
	NSArray *categoriesObjects = [moc executeFetchRequest:request error:&error];
	NSMutableArray *categoryNames = [NSMutableArray arrayWithCapacity:[categoriesObjects count]];
	for (NSManagedObject* category in categoriesObjects)
		if ([[category valueForKey:@"name"] hasPrefix:substring])
			[categoryNames addObject:[category valueForKey:@"name"]];
		
	NSLog(@"Completions for %@: %@", substring, categoryNames);
	
	return categoryNames;
};

- (id) tokenField:(NSTokenField *)tokenFieldArg representedObjectForEditingString:(NSString*)tokenString
{
	PKTrackCategory* cat = [self categoryForString:tokenString];
	if (cat == nil)
	{
		NSManagedObjectContext *moc = [[NSApp delegate] managedObjectContext];
		cat = [NSEntityDescription insertNewObjectForEntityForName:@"Category" 
											inManagedObjectContext:moc];
		[cat setValue:tokenString forKey:@"name"];
//		[cat addTracksObject:[self representedObject]];
		};
	NSLog(@"Tokenfield recieved: %@, returns: %@", tokenString, cat);
	return cat;
};

-(NSString* ) tokenField:(NSTokenField *)tokenFieldArg editingStringForRepresentedObject:(id)object
{
	NSLog(@"editingString for %@", object);
	//	return [object valueForKey:@"name"];
	return object;
};

-(NSString* ) tokenField:(NSTokenField *)tokenFieldArg displayStringForRepresentedObject:(id)object
{
	NSLog(@"displayString for %@", object);
	return [object valueForKey:@"name"];
//	return object;
}

- (NSArray *)tokenField:(NSTokenField *)tokenField shouldAddObjects:(NSArray *)tokens atIndex:(NSUInteger)index
{
//	[(PKTrackMO*)[self representedObject] addCategories:[NSSet setWithArray:tokens]];
	NSLog(@"shouldAddObjects: %@ atIndex: %li", tokens, (unsigned long)index);
	return tokens;
};

- (IBAction) commitCategoryField:(id)sender
{
	NSLog(@"Commiting: %@", [categoriesField objectValue]);
//	PKTrackMO* track;
	for (PKTrackMO* track in [self representedObject])
		[track setCategories:[NSSet setWithArray:[categoriesField objectValue]]];
};

#pragma mark Other member functions

- (void) setRepresentedObject:(id)rO
{
	[super setRepresentedObject:rO];

	if ([rO count] > 1)
		NSLog(@"Multiple selection not supported!");
	else
		[categoriesField setObjectValue:[[(PKTrackMO*)[rO objectAtIndex:0] categories] allObjects]];

//	NSLog(@"Represented Object: %@", [self representedObject]);
};
 

- (IBAction) recalculateTrackStatistics:(id)sender{
	for (PKTrackMO* track in [self representedObject])
		[track recalculateStatistics:self];
}

- (PKTrackCategory*) categoryForString:(NSString*)tokenString
{
	NSManagedObjectContext *moc = [[NSApp delegate] managedObjectContext];
	NSEntityDescription *entityDescription = [NSEntityDescription
											  entityForName:@"Category" inManagedObjectContext:moc];
	
	NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
	[request setEntity:entityDescription];
	NSError* error =  nil;
	NSPredicate* namePredicate = [NSPredicate predicateWithFormat:@"name == %@", tokenString];
	[request setPredicate:namePredicate];
	NSArray *categories = [moc executeFetchRequest:request error:&error];
	if ([categories count] > 0)
		return [categories objectAtIndex:0];
	else
		return nil;
};


/*- (id)initWithNibName:(NSString *)name bundle:(NSBundle *)bundle windowController:(XSWindowController *)windowController;
{
	if (![super initWithNibName:name bundle:bundle windowController:windowController])
		return nil;
	PKGPSSelectionViewController* GPSOverviewViewController = [[[PKGPSSelectionViewController alloc] initWithNibName:@"GPSSelectionView" bundle:nil windowController:windowController] autorelease];
	[self addChild:GPSOverviewViewController];
//	[self setCurrentViewController:GPSOverviewViewController];	
//	[self setCurrentWindowController:windowController];
	
	return self;
};

- (void) loadView 
{
	[super loadView];
	NSView* contentView = [self.view.subviews objectAtIndex:1];
	NSView* GPSOverviewView = [[self.children objectAtIndex:0] view];
	[GPSOverviewView setFrame:[contentView bounds]];
	
	[GPSOverviewView setAutoresizingMask:(NSViewWidthSizable | NSViewHeightSizable)];
	[contentView addSubview:GPSOverviewView];
//	[segmentedControl setSelectedSegment:0];
}*/

@end
