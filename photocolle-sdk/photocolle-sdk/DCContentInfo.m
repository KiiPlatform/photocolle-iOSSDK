#import "DCContentInfo.h"
#import "DCContentInfo_Private.h"

@implementation DCContentInfo

- (id)initWithGUID:(DCContentGUID *)guid
              name:(NSString *)name
          fileType:(DCFileType)fileType
    exifCameraDate:(NSDate *)exifCameraDate
      modifiedDate:(NSDate *)modifiedDate
      uploadedDate:(NSDate *)uploadedDate
      fileDataSize:(long long)fileDataSize
         resizable:(BOOL)resizable
{
    self = [super init];
    if (self != nil) {
        self.guid = guid;
        self.name = name;
        self.fileType = fileType;
        self.exifCameraDate = exifCameraDate;
        self.modifiedDate = modifiedDate;
        self.uploadedDate = uploadedDate;
        self.fileDataSize = fileDataSize;
        self.resizable = resizable;
    }
    return self;
}

@end
