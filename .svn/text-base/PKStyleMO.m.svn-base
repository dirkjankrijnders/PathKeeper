// 
//  PKStyleMO.m
//  PathKeeper
//
//  Created by Dirkjan Krijnders on 10/25/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "PKStyleMO.h"

#import "PKTrackCategory.h"
#import "NSColorHexValue.h"

@implementation PKStyleMO 

@dynamic name;
@dynamic id;
@dynamic linewidth;
@dynamic colour;
@dynamic categories;

- (NSXMLElement*) asKMLNode
{
	NSXMLElement* styleElement = [[[NSXMLElement alloc] initWithName:@"Style"] autorelease];
	[styleElement addAttribute:[NSXMLNode attributeWithName:@"id" stringValue:[self id]]];
	NSXMLElement* lineStyleElement = [NSXMLElement elementWithName:@"LineStyle"];
	[lineStyleElement addChild:[NSXMLElement elementWithName:@"width" stringValue:[NSString stringWithFormat:@"%@", [self linewidth]]]];
	[lineStyleElement addChild:[NSXMLElement elementWithName:@"color" stringValue:[[self colour] hexadecimalValueWithAlpha:YES]]];
	NSLog(@"Color: %@", [self colour]);
	[styleElement addChild:lineStyleElement];
	return styleElement;
};


@end
