//
//  NSDateDecimalValue.m
//  PathKeeper
//
//  Created by Dirkjan Krijnders on 6/13/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "NSDateDecimalValue.h"
#import <CorePlot/CorePlot.h>

@implementation NSDate(NSDateDecimalValue)
- (NSDecimal) decimalValue
{
	return CPTDecimalFromDouble([self timeIntervalSince1970]);
}

@end
