#import "DCEventTag.h"
#import "DCEventTag_Private.h"
#import "DCTag_Private.h"

@implementation DCEventTag

- (id)initWithGuid:(DCContentGUID *)guid
              name:(NSString *)name
     contentsCount:(int)contentsCount
{
    self = [super initWithType:DCTAGTYPE_EVENT
                          guid:guid
                          name:name
                 contentsCount:contentsCount];
    return self;
}

@end
