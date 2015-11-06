#import "DCAContentInfoListArguments.h"

@implementation DCAContentInfoListArguments

- (id)init
{
    self = [super init];
    if (self != nil) {
        self.fileType = DCFILETYPE_IMAGE;
        self.forDustbox = NO;
        self.dateFilter = nil;
        self.maxResults = nil;
        self.start = nil;
        self.sortType = DCSORTTYPE_CREATION_DATETIME_ASC;
    }
    return self;
}

@end
