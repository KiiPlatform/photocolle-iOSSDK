#import "DCPersonTag.h"
#import "DCPersonTag_Private.h"
#import "DCTag_Private.h"
#import "DCExceptionUtils.h"

@implementation DCPersonTag

- (id)initWithGuid:(DCContentGUID *)guid
              name:(NSString *)name
     contentsCount:(int)contentsCount
         birthDate:(NSDate *)birthDate
{
    self = [super initWithType:DCTAGTYPE_PERSON
                          guid:guid
                          name:name
                 contentsCount:contentsCount];
    if (self != nil) {
        self.birthDate = birthDate;
    }
    return self;
}

@end
