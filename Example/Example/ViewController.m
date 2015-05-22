//
//  ViewController.m
//  Example
//
//  Created by Jonathan Tribouharet.
//

#import "ViewController.h"

@interface ViewController (){
    NSMutableDictionary *eventsByDate;
}

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.calendar = [JTCalendar new];
    
    eventsByDate = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                [NSNumber numberWithInt:1], @"15-05-2015",
                [NSNumber numberWithInt:2], @"20-05-2015",
                [NSNumber numberWithInt:1], @"29-05-2015",
                [NSNumber numberWithInt:2], @"31-05-2015",
                [NSNumber numberWithInt:2], @"08-06-2015",
                [NSNumber numberWithInt:2], @"30-07-2015",
                    nil];
    
    // All modifications on calendarAppearance have to be done before setMenuMonthsView and setContentView
    // Or you will have to call reloadAppearance
    {
        self.calendar.calendarAppearance.calendar.firstWeekday = 2; // Sunday == 1, Saturday == 7
        self.calendar.calendarAppearance.dayCircleRatio = 9. / 10.;
        self.calendar.calendarAppearance.ratioContentMenu = 2.;
        self.calendar.calendarAppearance.focusSelectedDayChangeMode = YES;
        
        // Customize the text for each month
        self.calendar.calendarAppearance.monthBlock = ^NSString *(NSDate *date, JTCalendar *jt_calendar){
            NSCalendar *calendar = jt_calendar.calendarAppearance.calendar;
            NSDateComponents *comps = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth fromDate:date];
            NSInteger currentMonthIndex = comps.month;
            
            static NSDateFormatter *dateFormatter;
            if(!dateFormatter){
                dateFormatter = [NSDateFormatter new];
                dateFormatter.timeZone = jt_calendar.calendarAppearance.calendar.timeZone;
            }
            
            while(currentMonthIndex <= 0){
                currentMonthIndex += 12;
            }
            
            NSString *monthText = [[dateFormatter standaloneMonthSymbols][currentMonthIndex - 1] capitalizedString];
            
            return [NSString stringWithFormat:@"%ld\n%@", comps.year, monthText];
        };
    }
   
    [self.calendar setMenuMonthsView:self.calendarMenuView];
    [self.calendar setContentView:self.calendarContentView];
    [self.calendar setDataSource:self];
    
    // [self createRandomEvents];
    
    [self.calendar reloadData];
}

- (void)viewDidLayoutSubviews
{
    [self.calendar repositionViews];
}

#pragma mark - JTCalendarDataSource

- (NSInteger)calendarHaveEvent:(JTCalendar *)calendar date:(NSDate *)date
{
    /*
    NSLog(@"calederHaveEvent was called with date=> %@", date);
    NSString *key = [[self dateFormatter] stringFromDate:date];
    if(eventsByDate[key] && [eventsByDate[key] count] > 0){
        return 1;
    }
    */
    
    NSString *key = [[self dateFormatter] stringFromDate:date];
    // NSLog(@"key=> %@", key);
    
    if (eventsByDate[key]) {
        NSNumber *num = [eventsByDate objectForKey:key];
        // NSLog(@"num=> %@", num);
        if ([num isEqualToNumber:[NSNumber numberWithInt:SCEventTypeEvent]]) { // normal event
            return SCEventTypeEvent;
        } else if ([num isEqualToNumber:[NSNumber numberWithInt:SCEventTypeMatch]]) { // match
            return SCEventTypeMatch;
        }
    }
    
    return SCEventTypeNoEvent;
}

- (void)calendarDidDateSelected:(JTCalendar *)calendar date:(NSDate *)date
{
    NSString *key = [[self dateFormatter] stringFromDate:date];
    NSArray *events = eventsByDate[key];
    
    // NSLog(@"Date: %@ - %ld events", date, [events count]);
}

- (NSString *)calendarGetMatchImage:(JTCalendar *)caledar date:(NSDate *)date
{
    // NSString *key = [[self dateFormatter] stringFromDate:date];
    
    return @"http://www.nkmaribor.com/Img/Grbi/nkmb1.png";
}

- (void)calendarDidLoadPreviousPage
{
    NSLog(@"Previous page loaded");
}

- (void)calendarDidLoadNextPage
{
    NSLog(@"Next page loaded");
}

#pragma mark - Transition examples

- (void)transitionExample
{
    CGFloat newHeight = 300;
    if(self.calendar.calendarAppearance.isWeekMode){
        newHeight = 75.;
    }
    
    [UIView animateWithDuration:.5
                     animations:^{
                         self.calendarContentViewHeight.constant = newHeight;
                         [self.view layoutIfNeeded];
                     }];
    
    [UIView animateWithDuration:.25
                     animations:^{
                         self.calendarContentView.layer.opacity = 0;
                     }
                     completion:^(BOOL finished) {
                         [self.calendar reloadAppearance];
                         
                         [UIView animateWithDuration:.25
                                          animations:^{
                                              self.calendarContentView.layer.opacity = 1;
                                          }];
                     }];
}

#pragma mark - Fake data

- (NSDateFormatter *)dateFormatter
{
    static NSDateFormatter *dateFormatter;
    if(!dateFormatter){
        dateFormatter = [NSDateFormatter new];
        dateFormatter.dateFormat = @"dd-MM-yyyy";
    }
    
    return dateFormatter;
}

@end
