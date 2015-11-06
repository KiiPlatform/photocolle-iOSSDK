#import "DCYearMonthTag.h"
#import "DCYearMonthTag_Private.h"
#import "DCTag_Private.h"

@implementation DCYearMonthTag

- (id)initWithGuid:(DCContentGUID *)guid
              name:(NSString *)name
     contentsCount:(int)contentsCount
{
    self = [super initWithType:DCTAGTYPE_YEAR_MONTH
                          guid:guid
                          name:name
                 contentsCount:contentsCount];
    return self;
}

@end
