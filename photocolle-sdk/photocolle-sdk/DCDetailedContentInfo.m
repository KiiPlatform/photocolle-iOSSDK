#import "DCDetailedContentInfo.h"
#import "DCDetailedContentInfo_Private.h"
#import "DCContentInfo_Private.h"

@implementation DCDetailedContentInfo

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
        yearMonths:(NSArray*)yearMonths
{
    self = [self initWithGUID:guid
                         name:name
                     fileType:fileType
               exifCameraDate:exifCameraDate
                 modifiedDate:modifiedDate
                 uploadedDate:uploadedDate
                 fileDataSize:fileDataSize
                    resizable:resizable];
    if (self != nil) {
        self.ratio = ratio;
        self.score = score;
        self.orientation = orientation;
        self.persons = persons;
        self.events = events;
        self.favorites = favorites;
        self.places = places;
        self.yearMonths = yearMonths;
    }
    return self;
}

@end
