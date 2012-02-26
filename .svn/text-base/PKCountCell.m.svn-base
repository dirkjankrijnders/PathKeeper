//
//  PKCountCell.m
//  PathKeeper
//
//  Created by Dirkjan Krijnders on 4/19/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "PKCountCell.h"


@implementation PKCountCell

// #define kPSMUnifiedObjectCounterRadius 7.0
#define khOffset 2
#define kvOffset 1

- (void)drawWithFrame:(NSRect)frameRect inView:(NSView *)controlView
{
	NSRect counterStringRect;
	NSArray* objs = [NSArray arrayWithObjects:[NSColor whiteColor], [NSFont fontWithName:@"Helvetica" size:10], nil ];
	NSArray* keys = [NSArray arrayWithObjects:NSForegroundColorAttributeName, NSFontAttributeName, nil];
	NSDictionary* attr = [NSDictionary dictionaryWithObjects:objs forKeys:keys];
	NSAttributedString *counterString = [[NSAttributedString alloc] initWithString:[self stringValue] attributes:attr];//[self attributedObjectCountValueForTabCell:cell];
	counterStringRect.size = [counterString size];
	
	float kPSMUnifiedObjectCounterRadius = (counterStringRect.size.height + 2) / 2;
	
	NSRect myRect = NSMakeRect(frameRect.origin.x + frameRect.size.width - counterStringRect.size.width - (2 * kPSMUnifiedObjectCounterRadius)  - khOffset,
						frameRect.origin.y + (frameRect.size.height - counterStringRect.size.height) / 2 - kvOffset,
						counterStringRect.size.width + (2 * kPSMUnifiedObjectCounterRadius),
						counterString.size.height);

	[[NSColor colorWithCalibratedRed:0.5529f green:0.5921f blue:0.7176f alpha:1.0f] set];
//	[[NSColor colorWithCalibratedWhite:0.3 alpha:0.6] set];
	NSBezierPath *path = [NSBezierPath bezierPath];
	//        NSRect myRect = cellFrame;
//	myRect.origin.y -= 1.0;
	//NSPoint tmpPoint = NSMakePoint(myRect.origin.x, myRect.origin.y);
	NSPoint tmpPoint = NSMakePoint(myRect.origin.x + kPSMUnifiedObjectCounterRadius, myRect.origin.y);
	[path moveToPoint:tmpPoint];
	[path lineToPoint:NSMakePoint(myRect.origin.x + myRect.size.width - kPSMUnifiedObjectCounterRadius, myRect.origin.y)];
	[path appendBezierPathWithArcWithCenter:NSMakePoint(myRect.origin.x + myRect.size.width - kPSMUnifiedObjectCounterRadius, myRect.origin.y + kPSMUnifiedObjectCounterRadius) radius:kPSMUnifiedObjectCounterRadius startAngle:270.0 endAngle:90.0];
	[path lineToPoint:NSMakePoint(myRect.origin.x + kPSMUnifiedObjectCounterRadius, myRect.origin.y + myRect.size.height + 2)];
	[path appendBezierPathWithArcWithCenter:NSMakePoint(myRect.origin.x + kPSMUnifiedObjectCounterRadius, myRect.origin.y + kPSMUnifiedObjectCounterRadius) radius:kPSMUnifiedObjectCounterRadius startAngle:90.0 endAngle:270.0];
	[path fill];
	
	// draw attributed string centered in area
	[[NSColor colorWithCalibratedWhite:1.0 alpha:0.6] set];
	counterStringRect.origin.x = myRect.origin.x + ((myRect.size.width - counterStringRect.size.width) / 2.0) + 1;
	counterStringRect.origin.y = myRect.origin.y + ((myRect.size.height - counterStringRect.size.height) / 2.0) + 1.5;
	[counterString drawInRect:counterStringRect];
	[counterString release];
	//    }
	
};

@end
