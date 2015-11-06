#import "DCListResponse.h"
#import "DCListResponse_Private.h"

@implementation DCListResponse

- (DCListResponse *)initWithCount:(int)count
                            start:(int)start
                         nextPage:(int)nextPage
                             list:(NSArray *)list
{
    self = [super init];
    if (self != nil) {
        self.count = count;
        self.start = start;
        self.nextPage = nextPage;
        self.list = list;
    }
    return self;
}

@end
