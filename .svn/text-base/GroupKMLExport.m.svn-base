//
//  GroupKMLExport.m
//  PathKeeper
//
//  Created by Dirkjan Krijnders on 10/3/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "GroupKMLExport.h"


@implementation Group(KMLExport)
- (NSXMLElement*)asKMLNode
{
	NSXMLElement* groupElement = [[[NSXMLElement alloc] initWithName:@"Folder"] autorelease];
	[groupElement addChild:[NSXMLElement elementWithName:@"name" stringValue:[self name]]];
	return groupElement;
}

@end
