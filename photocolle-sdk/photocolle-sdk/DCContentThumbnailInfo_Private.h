#import "DCContentThumbnailInfo.h"

@interface DCContentThumbnailInfo ()

@property (nonatomic, readwrite, strong) DCContentGUID *guid;
@property (nonatomic, readwrite) DCMimeType mimeType;
@property (nonatomic, readwrite, strong) NSData *thumbnailBytes;

- (id)initWithGUID:(DCContentGUID *)guid
          mimeType:(DCMimeType)mimeType
    thumbnailBytes:(NSData *)thumbnailBytes;

@end
