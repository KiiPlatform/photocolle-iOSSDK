#import "DCContentBodyInfo.h"
#import "DCContentBodyInfo_Private.h"

@implementation DCContentBodyInfo

- (id)initWithContentType:(DCMimeType)contentType
              inputStream:(NSInputStream *)inputStream
{
    self = [super init];
    if (self != nil) {
        self.contentType = contentType;
        self.inputStream = inputStream;
    }
    return self;
}

- (void)dealloc
{
    [self.inputStream close];
    self.inputStream = nil;
}

@end
