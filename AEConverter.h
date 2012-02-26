//
//  AEConverter.h
//  AtlasExplorer
//
//  Created by Dirkjan Krijnders on 1/13/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

typedef enum 
{
	millimeter = 0,
	centimeter,
	decimeter,
	meter,
	decameter,
	hectometer,
	kilometer,
	kilometer10,
	kilometer100,
	megameter
} AEDistanceunit;

typedef struct _AEDistance
{
	double value;
	AEDistanceunit unit;
} AEDistance;

@interface AEConverter : NSObject {

}

+ (NSNumber*) UTMToLongitude:(NSInteger)numx withUTMZone:(NSInteger)zone;
+ (NSNumber*) UTMToLatitude: (NSInteger)numy withUTMZone:(NSInteger)zone;

+ (NSNumber*) degreesToDegrees:(float)degrees withFractionalMinutes:(float)fractionalMinutes atHemisphere:(NSString*)hemisphere;
+ (NSNumber*) distanceFrom:(NSPoint)fromLL To:(NSPoint)toLL;

+ (AEDistance) niceRoundDistanceFor:(double)unroundedNumber;
+ (NSString*) shortUnitForDistance:(AEDistance)distance;
//+ (NSNumber*) 
@end
