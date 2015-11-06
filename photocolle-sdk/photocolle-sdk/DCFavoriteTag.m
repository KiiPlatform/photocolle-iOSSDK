#import "DCFavoriteTag.h"
#import "DCFavoriteTag_Private.h"
#import "DCTag_Private.h"

@implementation DCFavoriteTag

- (id)initWithGuid:(DCContentGUID *)guid
              name:(NSString *)name
     contentsCount:(int)contentsCount
{
    self = [super initWithType:DCTAGTYPE_FAVORITE
                          guid:guid
                          name:name
                 contentsCount:contentsCount];
    return self;
}

@end
