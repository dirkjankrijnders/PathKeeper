//
//  PKArrayCountValueTransformer.m
//  PathKeeper
//
//  Created by Dirkjan Krijnders on 4/18/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "PKNotArrayCountValueTransformer.h"


@implementation PKNotArrayCountValueTransformer

+ (Class)transformedValueClass
{
    return [NSNumber class];
}

+ (BOOL)allowsReverseTransformation
{
    return NO;
}

- (id)transformedValue:(id)value
{
	BOOL ret;
	if ([value respondsToSelector: @selector(count)]) 
		ret = [value count] > 0;
	else
		ret = NO;
	
	return ([NSNumber numberWithBool:!ret]);
}

@end
