//
//  PKOverviewViewController.h
//  PathKeeper
//
//  Created by Dirkjan Krijnders on 8/3/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "XSViewController.h"

@interface PKGPSSelectionViewController : XSViewController {
	IBOutlet NSPopUpButton*			oGPSRecieverSelector;
	IBOutlet NSObjectController*	oGPSRecieverController;
	IBOutlet NSArrayController*		oGPSRecieversController;
}

- (void) fixGPSRecieverDropDown;
- (void)selectReciever:(id)sender;

@end
