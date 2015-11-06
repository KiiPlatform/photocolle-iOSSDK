#import "DCPlacementTag.h"
#import "DCPlacementTag_Private.h"
#import "DCTag_Private.h"

@implementation DCPlacementTag

- (id)initWithGuid:(DCContentGUID *)guid
              name:(NSString *)name
     contentsCount:(int)contentsCount
{
    self = [super initWithType:DCTAGTYPE_PLACEMENT
                          guid:guid
                          name:name
                 contentsCount:contentsCount];
    return self;
}

@end
