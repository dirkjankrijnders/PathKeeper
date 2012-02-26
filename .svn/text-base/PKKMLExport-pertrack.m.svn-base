//
//  PKKMLExport.m
//  PathKeeper
//
//  Created by Dirkjan Krijnders on 10/18/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "PKKMLExport-pertrack.h"
#import "PKTrackMO.h"
#import "PKStyleMO.h"
#import "Group.h"
#import "GroupKMLExport.h"

@implementation PKKMLExportPerTrack

-(void) main
{
	[self setTitle:@"Google earth export"];
	// Creating a temporary Managed Object Context to import the tracks to.
	NSManagedObjectContext* tempMOContext = [[NSManagedObjectContext alloc] init];
	[tempMOContext setPersistentStoreCoordinator:[MOContext persistentStoreCoordinator]];
	[tempMOContext setUndoManager:nil];
	
	NSError* err = nil;
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : NSTemporaryDirectory();

	NSString *googleEarthASPath = [basePath stringByAppendingPathComponent:@"Google Earth"];
	NSURL* furl = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"myplaces" ofType:@"kml"]];

	NSLog(@"myplaces.kml template: %@", furl);
	mMyPlacesDoc = [[NSXMLDocument alloc] initWithContentsOfURL:furl
														options:(NSXMLNodePreserveWhitespace|NSXMLNodePreserveCDATA)
														  error:&err];
	
    if (mMyPlacesDoc == nil) {
        mMyPlacesDoc = [[NSXMLDocument alloc] initWithContentsOfURL:furl
															options:NSXMLDocumentTidyXML
															  error:&err];
    }
	
    if (mMyPlacesDoc == nil)  {
        if (err) {
            [self handleError:err];
        }
        return;
    }
	
    if (err) {
        [self handleError:err];
    }
	NSXMLElement *documentNode = [[mMyPlacesDoc nodesForXPath:@"/kml/Document/Folder/Document" error:&err] objectAtIndex:0];
	NSError *error = nil;
	NSArray *tracks;
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity;
	
	/* Exporting all styles*/
	entity = [NSEntityDescription entityForName:@"Style" inManagedObjectContext:tempMOContext];
	[fetchRequest setEntity:entity];
	NSArray* styles = [tempMOContext executeFetchRequest:fetchRequest error:&error];
	for (PKStyleMO* style in styles)
		[documentNode addChild:[style asKMLNode]];
	
	/* Exporting all tracks */
	@try {
		entity = [NSEntityDescription entityForName:@"Track"
							 inManagedObjectContext:tempMOContext];
	} @catch (NSException* ex) {
		NSLog(@"%@", ex);
		[fetchRequest release];
		return;
	}
	[fetchRequest setEntity:entity];
	tracks = [tempMOContext executeFetchRequest:fetchRequest error:&error];
	
	NSArray* sortDescriptors = [NSArray arrayWithObjects:[[NSSortDescriptor alloc] initWithKey:@"startDate" ascending:YES],nil];

	NSXMLElement* trackElement;
	//NSMapTable* trackToElementMap = [NSMapTable mapTableWithWeakToWeakObjects];
	NSMutableDictionary* trackToElementDict = [NSMutableDictionary dictionary];
	for (PKTrackMO* track in [tracks sortedArrayUsingDescriptors:sortDescriptors])
	{
		NSXMLElement* notVisible = [[NSXMLElement alloc] initWithName:@"visibility" stringValue:@"0"];
		trackElement = [track asKMLFileAtPath:googleEarthASPath templateKMLPath:furl];
		[trackElement addChild:notVisible];
		[documentNode addChild:trackElement];
		[trackToElementDict setObject:trackElement forKey:[track objectID]];
		[notVisible release];
	};
	
	/* Export all groups */
	entity = [NSEntityDescription entityForName:@"Group" inManagedObjectContext:tempMOContext];
	NSArray* groupSortDescriptors = [NSArray arrayWithObjects:[[NSSortDescriptor alloc] initWithKey:@"order" ascending:YES],nil];
	[fetchRequest setEntity:entity];
	NSArray* groups = [tempMOContext executeFetchRequest:fetchRequest error:&error];
	
	NSXMLElement* groupElement;
	for (Group* group in [groups sortedArrayUsingDescriptors:groupSortDescriptors])
	{
		groupElement = [group asKMLNode];
		for (PKTrackMO* track in [[[group tracks] allObjects] sortedArrayUsingDescriptors:sortDescriptors])
		{
			[groupElement addChild:[[trackToElementDict objectForKey:[track objectID]] copy]];
		}
		NSLog(@"Group export: %@", groupElement);
		[documentNode addChild:groupElement];
	}
	
	/* Write out the KML Document */
	NSData* xmlData = [mMyPlacesDoc XMLData];
	
	// if (![xmlData writeToFile:[googleEarthASPath stringByAppendingPathComponent:@"myplaces.kml"] atomically:YES]) {
	if (![xmlData writeToFile:[googleEarthASPath stringByAppendingPathComponent:@"myplaces.kml"] options:NSAtomicWrite error:&error]) {
        NSBeep();
        NSLog(@"Could not write document out: %@", error);
    }
	[fetchRequest release];
};

@end
