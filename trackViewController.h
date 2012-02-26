//
//  trackViewController.h
//  PathKeeper
//
//  Created by Dirkjan Krijnders on 7/27/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "XSViewController.h"

@interface trackViewController : XSViewController {
	
	- (int)outlineView:(NSOutlineView *)outlineView numberOfChildrenOfItem:(id)item
	{
		return (item == nil) ? 1 : 0 ; //[item numberOfChildren];
	}
	
	
}

@end
