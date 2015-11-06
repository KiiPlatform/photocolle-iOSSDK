#import "DCADetailedContentInfoListArguments.h"

@implementation DCADetailedContentInfoListArguments

- (id)init
{
    self = [super init];
    if (self != nil) {
        self.projectionType = DCPROJECTIONTYPE_ALL_DETAILS;
        self.fileType = DCFILETYPE_IMAGE;
        self.criteriaList = nil;
        self.forDustbox = NO;
        self.dateFilter = nil;
        self.maxResults = nil;
        self.start = nil;
        self.sortType = DCSORTTYPE_CREATION_DATETIME_ASC;
    }
    return self;
}

@end
