//
//  PKTestPlugin.h
//  PathKeeper
//
//  Created by Dirkjan Krijnders on 11/7/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "PKPlugins/PKExportPluginProtocol.h"

@interface PKTestPlugin : NSObject <PKExportPluginProtocol> {
	NSManagedObjectModel* managedObjectModel;
}

@end
