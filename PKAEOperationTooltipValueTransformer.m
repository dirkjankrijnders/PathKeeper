//
//  PKAEOperationTooltipValueTransformer.m
//  PathKeeper
//
//  Created by Dirkjan Krijnders on 4/19/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "PKAEOperationTooltipValueTransformer.h"
#import "AEOperation.h"

@implementation PKAEOperationTooltipValueTransformer

+ (Class)transformedValueClass
{
    return [NSString class];
}

+ (BOOL)allowsReverseTransformation
{
    return NO;
}

- (id)transformedValue:(id)value
{
	NSString* ret = nil;
	
	if ([value respondsToSelector: @selector(count)]) 
	{
		ret =  [NSString stringWithFormat:@"%i Operations running:\n", [value count]];
		for (AEOperation* op in value)
			ret = [ret stringByAppendingFormat:@"%@\n", [op title]];
	}
	
	return ret;
};

@end
