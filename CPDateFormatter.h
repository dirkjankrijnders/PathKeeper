//
//  CPDateFormatter.h
//  PathKeeper
//
//  Created by Dirkjan Krijnders on 7/31/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface CPDateFormatter : NSNumberFormatter {
	NSDateFormatter *dateFormatter;
}

- (id) initWithDateFormatter:(NSDateFormatter*)_dateFormatter;

@property (retain) NSDateFormatter* dateFormatter;

@end
