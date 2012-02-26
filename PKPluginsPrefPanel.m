//
//  PKPluginsPrefPanel.m
//  PathKeeper
//
//  Created by Dirkjan Krijnders on 11/8/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "PKPluginsPrefPanel.h"


@implementation PKPluginsPrefPanel

@synthesize pluginManager;

- (id) init
{
	self = [super init];
	if (self != nil) {
		[self setPluginManager:[PKExportPluginManager shared]];		
	}
	return self;
}

-(void) awakeFromNib
{
	[self setPluginManager:[PKExportPluginManager shared]];		
}

@end
