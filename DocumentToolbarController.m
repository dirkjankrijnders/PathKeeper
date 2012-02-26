//
//  DocumentToolbarController.m
//  PathKeeper
//
//  Created by Dirkjan Krijnders on 7/17/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "DocumentToolbarController.h"


@implementation DocumentToolbarController

- (IBAction)importGPXaction:(id)sender {
	[document openGPXFile:sender];
}
@end
