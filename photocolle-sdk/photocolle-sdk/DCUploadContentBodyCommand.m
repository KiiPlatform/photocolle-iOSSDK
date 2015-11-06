#import "DCUploadContentBodyCommand.h"
#import "DCUploadContentBodyLogic.h"

@implementation DCUploadContentBodyCommand

- (id)initWithBaseURL:(NSURL *)baseURL
{
    DCUploadContentBodyLogic *logic =
        [[DCUploadContentBodyLogic alloc] init];
    self = [super initWithLogic:logic baseURL:baseURL];
    return self;
}

@end
