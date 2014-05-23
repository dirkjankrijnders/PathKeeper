//
//  GPXImportOperation.h
//  AtlasExplorer
//
//  Created by Dirkjan Krijnders on 2/27/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "AEOperation.h"
#import "PKTrackCategory.h"
#import "PKWaypointMO.h"
#import "PKTrackMO.h"

extern NSString* const kPKDuplicateCategoryName;

@interface GPXImportOperation : AEOperation <NSXMLParserDelegate> {
	PKTrackMO* currentTrack;
	PKWaypointMO* currentTrackWaypoint;
	PKWaypointMO* currentWaypoint;
	PKWaypointMO* lastTrackWaypoint;
	NSMutableString* currentStringValue;
	NSXMLParser* gpxParser;

	NSManagedObjectContext* tempMOContext;
	
	NSEntityDescription* trackEntity;
	NSEntityDescription* pointEntity;
	NSAutoreleasePool *pool;
	
	int trackCount;
	int waypointCount;
	double currentElevation;
	NSDate *currentDate;
	NSDateFormatter *dateFormatter;
	
	PKTrackCategory * duplicateCategory;
	PKTrackCategory * thisImportCategory;
}

- (void) main;

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName;
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict;

@end
