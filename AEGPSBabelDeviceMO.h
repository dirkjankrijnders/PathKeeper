//
//  AEGPSBabelDeviceMO.h
//  AtlasExplorer
//
//  Created by Dirkjan Krijnders on 3/24/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>


@interface AEGPSBabelDeviceMO :  NSManagedObject  
{
}

@property (retain) NSString * Filename;
@property (retain) NSNumber * hasWaypoint;
@property (retain) NSNumber * hasTrack;
@property (retain) NSString * Protocol;

@end


