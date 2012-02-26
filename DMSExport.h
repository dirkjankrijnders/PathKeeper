//
//  DMSExport.h
//  PathKeeper
//
//  Created by Dirkjan Krijnders on 1/2/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "PKPlugins/PKExportPluginProtocol.h"

@interface DMSExport : NSObject <PKExportPluginProtocol> {
	NSManagedObjectModel* managedObjectModel;
}

@end
