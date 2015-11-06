#import "DCDetailedContentInfo.h"

@interface DCDetailedContentInfo ()

@property (nonatomic, readwrite, strong) NSString *ratio;
@property (nonatomic, readwrite, strong) NSNumber *score;
@property (nonatomic, readwrite, strong) NSNumber *orientation;
@property (nonatomic, readwrite, strong) NSArray *persons;
@property (nonatomic, readwrite, strong) NSArray *events;
@property (nonatomic, readwrite, strong) NSArray *favorites;
@property (nonatomic, readwrite, strong) NSArray *places;
@property (nonatomic, readwrite, strong) NSArray *yearMonths;

- (id)initWithGUID:(DCContentGUID *)guid
              name:(NSString *)name
          fileType:(DCFileType)fileType
    exifCameraDate:(NSDate *)exifCameraDate
      modifiedDate:(NSDate *)modifiedDate
      uploadedDate:(NSDate *)uploadedDate
      fileDataSize:(long long)fileDataSize
         resizable:(BOOL)resizable
             ratio:(NSString *)ratio
             score:(NSNumber *)score
       orientation:(NSNumber *)orientation
           persons:(NSArray *)persons
            events:(NSArray*)events
         favorites:(NSArray*)favorites
            places:(NSArray*)places
        yearMonths:(NSArray*)yearMonths;

@end
