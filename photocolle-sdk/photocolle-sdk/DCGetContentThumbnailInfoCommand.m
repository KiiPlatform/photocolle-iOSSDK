#import "DCGetContentThumbnailInfoCommand.h"
#import "DCGetContentThumbnailInfoLogic.h"

@implementation DCGetContentThumbnailInfoCommand

- (id)initWithBaseURL:(NSURL *)baseURL
{
    DCGetContentThumbnailInfoLogic *logic =
        [[DCGetContentThumbnailInfoLogic alloc] init];
    self = [super initWithLogic:logic baseURL:baseURL];
    return self;
}

@end
