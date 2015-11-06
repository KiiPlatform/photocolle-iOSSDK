#import "DCContentThumbnailInfoList.h"
#import "DCContentThumbnailInfoList_Private.h"

@implementation DCContentThumbnailInfoList

- (id)initWithList:(NSArray *)list ngList:(NSArray *)ngList
{
    self = [super init];
    if (self != nil) {
        self.list = list;
        self.ngList = ngList;
    }
    return self;
}

@end
