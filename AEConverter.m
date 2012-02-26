//
//  AEConverter.m
//  AtlasExplorer
//
//  Created by Dirkjan Krijnders on 1/13/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "AEConverter.h"


@implementation AEConverter
+ (NSNumber*) UTMToLongitude:(NSInteger)numx withUTMZone:(NSInteger)zone {
	return [NSNumber numberWithFloat:5.2f];
};

+ (NSNumber*) UTMToLatitude: (NSInteger)numy withUTMZone:(NSInteger)zone {
	return [NSNumber numberWithFloat:52.2f];
};

+ (NSNumber*) degreesToDegrees:(float)degrees withFractionalMinutes:(float)fractionalMinutes atHemisphere:(NSString*)hemisphere {
	float result = degrees;
	result += fractionalMinutes / 60;
//	result += (fractionalMinutes - floor(fractionalMinutes)) 
	if (([hemisphere isEqualToString:@"S"]) || ([hemisphere isEqualToString:@"W"]))
		result = -result;
	
	return [NSNumber numberWithFloat:result];
}

+ (NSNumber*) distanceFrom:(NSPoint)fromLL To:(NSPoint)toLL {
	float R = 6371000; // m
	double dLat = (toLL.y - fromLL.y) / 180 * pi;
	double dLon = (toLL.x - fromLL.x) / 180 * pi;
	double a = sin(dLat/2) * sin(dLat/2) +	
		cos(fromLL.y / 180 * pi) * cos(toLL.y / 180 * pi) * 
		sin(dLon/2) * sin(dLon/2); 
	
	double c = 2 * atan2(sqrt(a), sqrt(1-a)); 
	return [NSNumber numberWithDouble:(R * c)];
}

+ (AEDistance) niceRoundDistanceFor:(double)unroundedNumber
{
	AEDistance returnValue;
	AEDistanceunit unit = meter;
	if (unroundedNumber > 10)
	{
		while (unroundedNumber > 10) 
		{
			unit++;
			unroundedNumber /= 10;
		}
//		unroundedNumber *= 10;
//		unit --;
	}
	else
	{
		while (unroundedNumber < 10) 
		{
			unit--;
			unroundedNumber *= 10;
		}
//		unit++;
	}
	returnValue.value = round(unroundedNumber);
	returnValue.unit = unit;
	return returnValue;
}

+ (NSString*) shortUnitForDistance:(AEDistance)distance
{
	NSArray* temp = [NSArray arrayWithObjects:@"mm",@"cm",@"10 cm",@"0.1 m",@"m",@"10 m",@"100 m",@"km",@"10 km", @"100 km", @"1000 km",nil];
	return [temp objectAtIndex:distance.unit];
};

@end
