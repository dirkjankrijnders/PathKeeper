//
//  GPXImportOperation.m
//  AtlasExplorer
//
//  Created by Dirkjan Krijnders on 2/27/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "GPXImportOperation.h"
#import "PKTrackMO.h"
#import "SmartGroup.h"
#import "pathKeeper_AppDelegate.h"

/*@interface GPXImportOperation ()
@property (readwrite, copy) NSURL* url;
@end
*/
@implementation GPXImportOperation
NSString * const kPKDuplicateCategoryName = @"Duplicate tracks";

//@synthesize url;
/*
- (id) initWithURL:(NSURL*)aFile andtempMOContext:(NSManagedObjectContext*)atempMOContext {
	if ( self = [super init] ){
		self.url = aFile;
		tempMOContext = atempMOContext;
		trackCount = 0;
		self.title = [url absoluteString];
	}
	NSLog(@"GPXImporter created with %@", url);
	return self;
};
*/
- (void) main{
	[self setTitle:@"GPX Import"];

	BOOL success;
	dateFormatter = [[NSDateFormatter alloc]
									  initWithDateFormat:@"%Y-%m-%dT%H:%M:%SZ" allowNaturalLanguage:NO];

    if (gpxParser) // gpxParser is an NSXMLParser instance variable
        [gpxParser release];
	NSLog(@"We start parsing with url: %@", url);
	// Creating a temporary Managed Object Context to import the tracks to.
	tempMOContext = [[NSManagedObjectContext alloc] init];
	[tempMOContext setPersistentStoreCoordinator:[MOContext persistentStoreCoordinator]];
	[tempMOContext setUndoManager:nil];
	
	// Cache the entities for track and waypoint
	trackEntity = [NSEntityDescription entityForName:@"Track"								   
											  inManagedObjectContext:tempMOContext];
	pointEntity = [NSEntityDescription entityForName:@"Waypoint"								   
							  inManagedObjectContext:tempMOContext];
	/*	// Register for did save notifications:
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(handleMocWasSavedNotification:)
												 name:NSManagedObjectContextDidSaveNotification object:nil];
*/
	//	NSManagedObjectContextDidSaveNotification
	
    gpxParser = [[NSXMLParser alloc] initWithContentsOfURL:url];	
    [gpxParser setDelegate:self];
    [gpxParser setShouldResolveExternalEntities:YES];
	currentStringValue = nil;
	
	pool = [[NSAutoreleasePool alloc] init];
	NSFetchRequest* duplicateCategoryFetchRequest = [[NSFetchRequest alloc] init];
	NSEntityDescription* entity = [NSEntityDescription entityForName:@"Category"
											 inManagedObjectContext:tempMOContext];
	NSPredicate* duplicateCategoryPredicate = [NSPredicate predicateWithFormat:@"name == %@",kPKDuplicateCategoryName];

	[duplicateCategoryFetchRequest setEntity:entity];
	
	[duplicateCategoryFetchRequest setPredicate:duplicateCategoryPredicate];
	
	NSError* error;
	NSArray* results;
	@try {
		results = [tempMOContext executeFetchRequest:duplicateCategoryFetchRequest error:&error];
	} @catch (NSException* ex) {
		NSLog(@"%@", ex);
		return;
	}
//	NSLog(@"Error: %@", error);
	if ([results count] > 0)
	{
		duplicateCategory = [results objectAtIndex:0];
		NSLog(@"Found 'duplicate' category: %@", duplicateCategory);
	} else
	{
		duplicateCategory = [[PKTrackCategory alloc] initWithEntity:entity insertIntoManagedObjectContext:tempMOContext];
		[duplicateCategory setName:kPKDuplicateCategoryName];
		[duplicateCategory setHide:[NSNumber numberWithInt:1]];
		NSLog(@"Created 'duplicate' category: %@", duplicateCategory);
	}
	
	thisImportCategory = [[PKTrackCategory alloc] initWithEntity:entity insertIntoManagedObjectContext:tempMOContext];
	[thisImportCategory setName:[NSString stringWithFormat:@"ImportGroup %@", [NSDate date]]];
	[thisImportCategory setHide:[NSNumber numberWithInt:0]];
	[tempMOContext assignObject:thisImportCategory toPersistentStore:[(pathKeeper_AppDelegate*)[NSApp delegate] primaryStore]];
	
	entity = [NSEntityDescription entityForName:@"SmartGroup"
						 inManagedObjectContext:tempMOContext];
	SmartGroup* importSmartGroup = [[SmartGroup alloc] initWithEntity:entity insertIntoManagedObjectContext:tempMOContext];
	[importSmartGroup setName:[NSString stringWithFormat:@"Import %@", [NSDate date]]];
	NSPredicate* importGroupPredicate = [NSPredicate predicateWithFormat:@"categories.name contains %@", [thisImportCategory name]];
	[importSmartGroup setPredicate:importGroupPredicate];
	[tempMOContext assignObject:importSmartGroup toPersistentStore:[(pathKeeper_AppDelegate*)[NSApp delegate] primaryStore]];
	
	success = [gpxParser parse]; // return value not used
//	NSError* error;
	[tempMOContext processPendingChanges];
	if (![tempMOContext save:&error])
		NSLog(@"Saving failed: %@, info: %@", error, [error userInfo]);
	
	[tempMOContext reset];
	
}

/*- (void)handleMocWasSavedNotification:(NSNotification *)aNotification
{
	//		NSLog(@"Save notification recieved");
	[self performSelectorOnMainThread:@selector (updateManagedObjectContext:) withObject:aNotification waitUntilDone:NO];
}*/

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    if ( [elementName isEqualToString:@"trk"]) {
		NSLog(@"Track found");
		currentTrack = [[PKTrackMO alloc] initWithEntity:trackEntity insertIntoManagedObjectContext:tempMOContext];
		[tempMOContext assignObject:currentTrack toPersistentStore:[[NSApp delegate] primaryStore]];
		
		trackCount++;
		waypointCount = 0;
		[currentTrack setValue:[NSString stringWithFormat:@"Track %i", trackCount] forKey:@"name"];
		[currentTrack setValue:[NSDate date] forKey:@"ReadOn"];
		[currentTrack addCategoriesObject:thisImportCategory];
		
		lastTrackWaypoint = nil;
		
		return;
    }
	
	
    if ( [elementName isEqualToString:@"trkpt"] ) {
		waypointCount++;
//		NSLog(@"Waypoint found");
//		currentTrackWaypoint = [NSEntityDescription insertNewObjectForEntityForName:@"TrackWaypoint" 
//															 inManagedObjectContext:tempMOContext];
//		currentWaypoint = [NSEntityDescription insertNewObjectForEntityForName:@"Waypoint" 
//														inManagedObjectContext:tempMOContext];
		currentWaypoint = [[PKWaypointMO alloc] initWithEntity:pointEntity insertIntoManagedObjectContext:tempMOContext];
		[tempMOContext assignObject:currentWaypoint toPersistentStore:[[NSApp delegate] primaryStore]];
		
		[currentWaypoint setValue:[NSNumber numberWithDouble:[[attributeDict objectForKey:@"lat"] doubleValue]] forKey:@"latitude"];
		[currentWaypoint setValue:[NSNumber numberWithDouble:[[attributeDict objectForKey:@"lon"] doubleValue]] forKey:@"longitude"];
		[currentWaypoint setValue:[NSNumber numberWithInt:waypointCount] forKey:@"order"];
//		[currentWaypoint setValue:[NSNumber numberWithDouble:[[attributeDict objectForKey:@"ele"] doubleValue]] forKey:@"altitude"];
//		[currentWaypoint setValue:@"Wp"	forKey:@"Name"];
//		[currentTrackWaypoint setValue:[NSNumber numberWithInt:waypointCount] forKey:@"Index"];
//		[currentTrackWaypoint setValue:currentWaypoint forKey:@"Waypoint"];
//		NSLog(@"Track: %@ adding point: %@", currentTrack, currentWaypoint);
//		NSLog(@"MO: %@", tempMOContext);
		[currentTrack addPointsObject:currentWaypoint]; //  See http://developer.apple.com/documentation/Cocoa/Conceptual/CoreData/Articles/cdUsingMOs.html#//apple_ref/doc/uid/TP40001803-212651
        return;
    }
    if ( [elementName isEqualToString:@"ele"] ) {
		currentElevation = 0;
	}
	if ( [elementName isEqualToString:@"time"] ) {
		currentDate = [NSDate date];
	}
	if ([self isCancelled])
		[gpxParser abortParsing];
	
}

- (BOOL) checkExistence {
	NSError *fetchError = nil;
	NSArray *fetchResults;
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity;
	
	@try {
		entity = [NSEntityDescription entityForName:@"Track"
							 inManagedObjectContext:tempMOContext];
	} @catch (NSException* ex) {
		NSLog(@"%@", ex);
		return false;
	}
	[fetchRequest setEntity:entity];
	fetchResults = [tempMOContext executeFetchRequest:fetchRequest error:&fetchError];

	BOOL result = false;
	for (PKTrackMO* track in fetchResults) {
		if (track != currentTrack)
			result = result | [track isEqualToTrack:currentTrack]; // includingPoint:false];
	}
	
	[fetchRequest dealloc];
	return result;
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
	if (!currentStringValue) {
        // currentStringValue is an NSMutableString instance variable
        currentStringValue = [[NSMutableString alloc] initWithCapacity:50];
    }
    [currentStringValue appendString:string];
}



- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
//	BOOL allowDuplicates = false;
	
    if ( [elementName isEqualToString:@"trk"]) {
		if ([self checkExistence])
		{	
			NSLog(@"Track already exists!");
			[currentTrack addCategoriesObject:duplicateCategory];
		}
		[currentTrack recalculateStatistics:self];
		[currentTrack release];
		[tempMOContext processPendingChanges];
//		[MOContext lock];
		// Merge new objects back into the orginal MOContext;
//		[MOContext refreshObject:currentTrack mergeChanges:YES];
//		NSError* error = nil;
		[currentTrack setStopDate:currentDate];
		NSLog(@"Inserted objects: %li", (unsigned long)[[tempMOContext insertedObjects] count]);
//		NSLog(@"Pre - saving");
		
		[pool drain];
		pool = [[NSAutoreleasePool alloc] init];
		currentDate = [NSDate date];
		NSLog(@"%@", currentDate);
//		count = 0;
//		NSLog(@"Saving: %@", error);
//		[MOContext mergeChangesFromContextDidSaveNotification[
//		[MOContext unlock];
		
		// Check whether the track was already imported:
		//		NSLog(@"%@", currentTrack);
		//		[currentTrack release];
	}
	
	if ( [elementName isEqualToString:@"trkpt"] ) {
		[currentWaypoint setValue:[NSNumber numberWithDouble:currentElevation] forKey:@"height"];
		[currentWaypoint setValue:currentDate forKey:@"date"];
//		[currentWaypoint setValue:currentElevation forKey:@"height"];
		if (lastTrackWaypoint)
			[currentTrack addDistance:([currentTrackWaypoint distanceFromTrackWaypoint:lastTrackWaypoint] / 1000.0)];

		[lastTrackWaypoint setNextPoint:currentWaypoint];
		[currentWaypoint setPreviousPoint:lastTrackWaypoint];
		[lastTrackWaypoint release];
		lastTrackWaypoint = currentTrackWaypoint;
		[lastTrackWaypoint retain];
		[currentWaypoint release];
	}
	if ( [elementName isEqualToString:@"ele"] ) {
		currentElevation = [[currentStringValue stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] doubleValue];
		//		[currentTrackWaypoint release];
		//		[currentWaypoint release];
	}
	if ( [elementName isEqualToString:@"time"] ) {

		currentDate = [dateFormatter dateFromString:[currentStringValue stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
		if (waypointCount == 1)
			[currentTrack setStartDate:currentDate];
//		NSLog(@"DateString: %@, Date: %@, Formatter: %@",
//			  [currentStringValue stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] , 
//			  currentDate,
//			  dateFormatter);
	}
	
	[currentStringValue release];
    currentStringValue = nil;
};

@end
