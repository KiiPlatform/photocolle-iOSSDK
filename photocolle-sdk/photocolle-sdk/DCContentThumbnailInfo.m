#import "DCContentThumbnailInfo.h"
#import "DCContentThumbnailInfo_Private.h"

@implementation DCContentThumbnailInfo

- (id)initWithGUID:(DCContentGUID *)guid
          mimeType:(DCMimeType)mimeType
    thumbnailBytes:(NSData *)thumbnailBytes
{
    self = [super init];
    if (self != nil) {
        self.guid = guid;
        self.mimeType = mimeType;
        self.thumbnailBytes = thumbnailBytes;
    }
    return self;
}

@end
