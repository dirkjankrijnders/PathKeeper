//
//  PKKMLExport.m
//  PathKeeper
//
//  Created by Dirkjan Krijnders on 10/18/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "PKKMLExport.h"
#import "PKTrackMO.h"
#import "PKStyleMO.h"

@implementation PKKMLExport

-(void) main
{
	[self setTitle:@"Google earth export - oud"];
	NSError* err = nil;
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
	entity = [NSEntityDescription entityForName:@"Style" inManagedObjectContext:MOContext];
	[fetchRequest setEntity:entity];
	NSArray* styles = [MOContext executeFetchRequest:fetchRequest error:&error];
	for (PKStyleMO* style in styles)
		[documentNode addChild:[style asKMLNode]];
	
	/* Exporting all tracks */
	@try {
		entity = [NSEntityDescription entityForName:@"Track"
							 inManagedObjectContext:MOContext];
	} @catch (NSException* ex) {
		NSLog(@"%@", ex);
		[fetchRequest release];
		return;
	}
	[fetchRequest setEntity:entity];
	tracks = [MOContext executeFetchRequest:fetchRequest error:&error];
	
	NSArray* sortDescriptors = [NSArray arrayWithObjects:[[NSSortDescriptor alloc] initWithKey:@"startDate" ascending:YES],nil];

	for (PKTrackMO* track in [tracks sortedArrayUsingDescriptors:sortDescriptors])
	{
		[documentNode addChild:[track asKMLNodeWithPoints:YES]];
	};
	
	/* Write out the KML Document */
	NSData* xmlData = [mMyPlacesDoc XMLData];
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : NSTemporaryDirectory();
	NSString *googleEarthASPath = [basePath stringByAppendingPathComponent:@"Google Earth"];
	
	// if (![xmlData writeToFile:[googleEarthASPath stringByAppendingPathComponent:@"myplaces.kml"] atomically:YES]) {
	if (![xmlData writeToFile:[googleEarthASPath stringByAppendingPathComponent:@"myplaces.kml"] options:NSAtomicWrite error:&error]) {
        NSBeep();
        NSLog(@"Could not write document out: %@", error);
    }
	[fetchRequest release];
};

@end
