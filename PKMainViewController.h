//
//  PKMainViewController.h
//  PathKeeper
//
//  Created by Dirkjan Krijnders on 8/3/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "XSViewController.h"

@class PKDetailViewController;

@interface PKMainViewController : XSViewController {
	IBOutlet NSTableView*		oTableView;
	IBOutlet NSView*			oRightView;
	PKDetailViewController*		detailViewController;
}
- (void) trackSelectionChanged:(NSNotification*)n;

@property (assign) PKDetailViewController* detailViewController;

@end
