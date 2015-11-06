#import "DCGetContentBodyInfoCommand.h"
#import "DCGetContentBodyInfoLogic.h"

@implementation DCGetContentBodyInfoCommand

- (id)initWithBaseURL:(NSURL *)baseURL
{
    DCGetContentBodyInfoLogic *logic =
        [[DCGetContentBodyInfoLogic alloc] init];
    self = [super initWithLogic:logic baseURL:baseURL];
    return self;
}

@end
