#import "DCModifiedDateFilter.h"
#import "DCModifiedDateFilter_Private.h"
#import "DCMiscUtils.h"
#import "DCExceptionUtils.h"

static NSString *const FILTER_NAME = @"min_date_modified";

@implementation DCModifiedDateFilter

- (id)initWithDate:(NSDate *)date
{
    if (date == nil) {
        [DCExceptionUtils raiseInvalidArgumentExceptionWithReason:
            @"date must not be nil."];
    }

    self = [super init];
    if (self != nil) {
        self.date = date;
    }
    return self;
}

- (NSDate *)getDate
{
    return self.date;
}

- (NSString *)getFilterName
{
    return FILTER_NAME;
}

- (NSString *)getFilterValue
{
    return [DCMiscUtils getUTCString:self.date];
}

@end
