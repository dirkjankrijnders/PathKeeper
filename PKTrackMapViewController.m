//
//  PKTrackMapViewController.m
//  PathKeeper
//
//  Created by Dirkjan Krijnders on 8/3/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "PKTrackMapViewController.h"
#import "PKTrackMO.h"
#import "PKTrackMO+RM.h"
#import "PKWaypointMO.h"
#import "PKStyleMO.h"
#import "PKTrackCategory.h"

#import "RMLatLong.h"
#import "RMMapView.h"
#import "RMPath.h"
//#import "RMLayerSet.h"

#import "XSWindowController.h"

@implementation PKTrackMapViewController

- (void) setRepresentedObject:(id)rO
{
    [RMMapView class]; // Here to keep the linker at bay;

	[super setRepresentedObject:rO];
	NSArray* points = [[rO objectAtIndex:0] valueForKey:@"sortedPoints"];// objectAtIndex:0];
	NSNumber* longitude = [(PKWaypointMO*)[points objectAtIndex:0] longitude];
	NSNumber* latitude = [(PKWaypointMO*)[points objectAtIndex:0] latitude];
	CLLocationCoordinate2D point;
	point.latitude = [latitude floatValue];
	point.longitude = [longitude floatValue];

	if (!trackView)
		return;
	
	RMLayerCollection* overlaySet = [[trackView contents] overlay];
    
	[paths release];
	[trackView moveToLatLong:point];
	paths = [[NSMutableArray alloc] init];
	for (PKTrackMO* track in [self currentTracks])
        for (PKTrackCategory* cat in [track categories]){
            if ([cat style] != nil)
                [paths addObject:[track RMPathForContents:[trackView contents] style:[cat style]]];
        }
	[overlaySet setSublayers:paths];

	[trackView setNeedsDisplay:YES];
};

- (NSSet*) currentTracks
{
	if ([[self representedObject] isKindOfClass:[NSSet class]])
		return [self representedObject];
	
	if ([[self representedObject] isKindOfClass:[NSArray class]])
		return [NSSet setWithArray:[self representedObject]];
	
	if ([[self representedObject] isMemberOfClass:[PKTrackMO class]])
		return [NSSet setWithObject:[self representedObject]];
	
	return [NSSet set];
};

- (IBAction) zoomOut:(id)sender
{
	[trackView zoomByFactor:0.7	near:CGPointMake(trackView.bounds.size.width / 2, trackView.bounds.size.height / 2)];
}

- (IBAction) zoomIn:(id)sender
{
	[trackView zoomByFactor:(1/0.7)	near:CGPointMake(trackView.bounds.size.width / 2, trackView.bounds.size.height / 2)];
}

- (IBAction) moveEast:(id)sender
{
	[trackView moveBy:CGSizeMake(-20.0f, 0.0f)];
}

- (IBAction) moveSouth:(id)sender
{
	[trackView moveBy:CGSizeMake(0.0f, 20.0f)];
}

- (IBAction) moveWest:(id)sender
{
	[trackView moveBy:CGSizeMake(20.0f, 0.0f)];
}

- (IBAction) moveNorth:(id)sender
{
	[trackView moveBy:CGSizeMake(0.0f, -20.0f)];
}

- (void) mouseDown:(NSEvent *)theEvent 
{
	NSLog(@"Mouse down event: %@", theEvent);
    BOOL keepOn = YES;
//    BOOL isInside = YES;
    NSPoint mouseLoc;
	
    while (keepOn) {
        theEvent = [[(XSWindowController*)[self windowController] window] nextEventMatchingMask: NSLeftMouseUpMask |
					NSLeftMouseDraggedMask];
        mouseLoc = [trackView convertPoint:[theEvent locationInWindow] fromView:nil];
//        isInside = [self mouse:mouseLoc inRect:[self bounds]];
		NSLog(@"Mouse dragged event: %@", theEvent);
		
        switch ([theEvent type]) {
            case NSLeftMouseDragged:
				NSLog(@"Mouse dragged event: %@", theEvent);
//				[self highlight:isInside];
				break;
            case NSLeftMouseUp:
//				if (isInside) [self doSomethingSignificant];
//				[self highlight:NO];
				keepOn = NO;
				break;
            default:
				/* Ignore any other kind of event. */
				break;
        }
		
    };
	
    return;
}
@end
