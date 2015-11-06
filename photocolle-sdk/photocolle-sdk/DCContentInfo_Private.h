#import "DCContentInfo.h"

@interface DCContentInfo ()

@property (nonatomic, readwrite, strong) DCContentGUID *guid;

@property (nonatomic, readwrite, strong) NSString *name;

@property (nonatomic, readwrite) DCFileType fileType;

@property (nonatomic, readwrite, strong) NSDate *exifCameraDate;

@property (nonatomic, readwrite, strong) NSDate *modifiedDate;

@property (nonatomic, readwrite, strong) NSDate *uploadedDate;

@property (nonatomic, readwrite) long long fileDataSize;

@property (nonatomic, readwrite) BOOL resizable;

- (id)initWithGUID:(DCContentGUID *)guid
              name:(NSString *)name
          fileType:(DCFileType)fileType
    exifCameraDate:(NSDate *)exifCameraDate
      modifiedDate:(NSDate *)modifiedDate
      uploadedDate:(NSDate *)uploadedDate
      fileDataSize:(long long)fileDataSize
         resizable:(BOOL)resizable;

@end
