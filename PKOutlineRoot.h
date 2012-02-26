//
//  PKTrackOutlineRoot.h
//  PathKeeper
//
//  Created by Dirkjan Krijnders on 8/8/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface PKOutlineRoot : NSObject {
	NSString*				displayName;
	NSArrayController*		arrayController;
}

@property (retain) NSString* displayName;
@property (retain) NSArrayController* arrayController;

- (int) numberOfChildren;

@end
