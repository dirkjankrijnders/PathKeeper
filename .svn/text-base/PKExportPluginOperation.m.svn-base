//
//  PKExportPluginOperation.m
//  PathKeeper
//
//  Created by Dirkjan Krijnders on 11/8/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "PKExportPluginOperation.h"
#import "JDKTempDirectory.h"


@implementation PKExportPluginOperation

@synthesize trackObjectIDs;
@synthesize plugin;

- (void) main
{
	NSManagedObjectContext* tempMOContext = [[NSManagedObjectContext alloc] init];
	[tempMOContext setPersistentStoreCoordinator:[MOContext persistentStoreCoordinator]];
	[tempMOContext setUndoManager:nil];
	
	NSString *tempPath = uniqueTemporaryDirectory();
	
	if (nil == tempPath)
		NSLog(@"No temporary directory available, should fail...");

	NSError *error;
	
	[plugin shouldBeginExport];
	NSLog(@"Beginning export!");
	[plugin willBeginExportToPath:tempPath];
	
	NSUInteger index = 0;
	for (NSManagedObjectID* objectID in trackObjectIDs)
	{
		NSData* gpxData = nil;
		NSData* kmlData = nil;
		
		PKTrackMO* track = (PKTrackMO*)[tempMOContext objectWithID:objectID];
		
		NSLog(@"%@", [track name]);
		if ([plugin shouldExportTrackAtIndex:index])
		{
			[plugin exportTrackAtIndex:index];
			if ([plugin shouldWriteGPXDataForTrackMO:track data:gpxData toPath:@"" forTrackAtIndex:index])
			{
				[self setTitle:[NSString stringWithFormat:@"Exporting %d/%d: %@", index, [trackObjectIDs count], [track name]]];
				[plugin didWriteGPXDataToPath:@"" forTrackAtIndex:index];
			}
			NSString* filename = [NSString stringWithFormat:@"%@/%@-%@.kml", tempPath, [track name], [track startDate]];
			if ([plugin shouldWriteKMLDataForTrackMO:track data:kmlData toPath:filename forTrackAtIndex:index])
			{
				[self setTitle:[NSString stringWithFormat:@"Exporting %d/%d: %@ to %@", index, [trackObjectIDs count], [track name], filename]];
//				NSLog(@"%@", [NSString stringWithFormat:@"Exporting %d/%d: %@ to %@", index, [trackObjectIDs count], [track name], filename]);
				[track asKMLFileAtPath:tempPath templateKMLPath:@""];
				[plugin didWriteKMLDataToPath:filename forTrackAtIndex:index];
				[[NSFileManager defaultManager] removeItemAtPath:filename error:&error];
			}
		}
		index++;
	}
	[plugin didFinishExport];
	
	[tempMOContext release];
}

@end
