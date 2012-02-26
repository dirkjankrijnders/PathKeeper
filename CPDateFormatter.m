//
//  CPDateFormatter.m
//  PathKeeper
//
//  Created by Dirkjan Krijnders on 7/31/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "CPDateFormatter.h"


@implementation CPDateFormatter

@synthesize dateFormatter;

#pragma mark -
#pragma mark Init/Dealloc

- (id) init
{
	return [self initWithDateFormatter:[[[NSDateFormatter alloc] init] autorelease]];
}

- (id) initWithDateFormatter:(NSDateFormatter*)_dateFormatter
{
	self = [super init];
	if (self != nil) {
		self.dateFormatter = _dateFormatter;
	}
	return self;	
}

- (void) dealloc
{
	self.dateFormatter = nil;
	[super dealloc];
}


-(NSString*) stringForObjectValue:(NSDecimalNumber*)tickLocation
{
	NSDate* date = [NSDate dateWithTimeIntervalSince1970:[tickLocation doubleValue]];
	return [dateFormatter stringFromDate:date];
}

@end
