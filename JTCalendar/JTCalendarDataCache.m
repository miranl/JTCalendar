//
//  JTCalendarDataCache.m
//  JTCalendar
//
//  Created by Jonathan Tribouharet
//

#import "JTCalendarDataCache.h"

#import "JTCalendar.h"

@interface JTCalendarDataCache(){
    NSMutableDictionary *events;
    NSDateFormatter *dateFormatter;
};

@end

@implementation JTCalendarDataCache

- (instancetype)init
{
    self = [super init];
    if(!self){
        return nil;
    }
    
    dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    events = [NSMutableDictionary new];
    
    return self;
}

- (void)reloadData
{
    [events removeAllObjects];
}

- (NSInteger)haveEvent:(NSDate *)date
{
    if(!self.calendarManager.dataSource){
        return 0;
    }
    
    if(!self.calendarManager.calendarAppearance.useCacheSystem){
        return [self.calendarManager.dataSource calendarHaveEvent:self.calendarManager date:date];
    }
    
    NSInteger haveEvent;
    NSString *key = [dateFormatter stringFromDate:date];

    if(events[key] != nil){
        haveEvent = [events[key] integerValue];
    }
    else{
        haveEvent = [self.calendarManager.dataSource calendarHaveEvent:self.calendarManager date:date];
    }
    
    return haveEvent;
}

@end