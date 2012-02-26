//
//  PKPluginsPrefPanel.h
//  PathKeeper
//
//  Created by Dirkjan Krijnders on 11/8/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "XSViewController.h"
#import "PKExportPluginManager.h"


@interface PKPluginsPrefPanel : XSViewController {
	PKExportPluginManager* pluginManager;
}

@property (retain, nonatomic) PKExportPluginManager* pluginManager;

@end
