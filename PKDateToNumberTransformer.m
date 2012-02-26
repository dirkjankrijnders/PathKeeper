//
//  PKDateToNumberTransformer.m
//  PathKeeper
//
//  Created by Dirkjan Krijnders on 11/21/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "PKDateToNumberTransformer.h"


@implementation PKDateToNumberTransformer

+ (Class)transformedValueClass
{
    return [NSDecimalNumber class];
}

+ (BOOL)allowsReverseTransformation
{
    return YES;
}

- (id)transformedValue:(id)value
{
	return [NSDecimalNumber numberWithInt:[value timeIntervalSince1970]];
};

- (id)reverseTransformedValue:(id)value
{
	return [NSDate dateWithTimeIntervalSince1970:[value intValue]];
};

@end
