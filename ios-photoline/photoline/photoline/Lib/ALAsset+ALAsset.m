//
//  ALAsset+ALAsset.m
//  photoline
//
//  Created by Muhammed Salih on 31/10/15.
//  Copyright © 2015 Muhammed Salih T A. All rights reserved.
//

#import "ALAsset+ALAsset.h"

@implementation ALAsset (ALAsset)
// in the .m
- (NSDate *) date
{
    return [self valueForProperty:ALAssetPropertyDate];
}
- (NSDate *) day{
    NSDate *datDate = [self valueForProperty:ALAssetPropertyDate];
    if( datDate == nil ) {
        datDate = [NSDate date];
    }
    NSDateComponents* comps = [[NSCalendar currentCalendar] components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:datDate];
    return [[NSCalendar currentCalendar] dateFromComponents:comps];
}

@end
