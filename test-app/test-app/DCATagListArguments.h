#import <Foundation/Foundation.h>
#import <photocolle_iOSSDK/DCPhotoColleSDK.h>

@interface DCATagListArguments : NSObject

@property (nonatomic, readwrite) DCCategory category;

@property (nonatomic, readwrite) DCFileType fileType;

@property (nonatomic, readwrite, strong) NSDate *minDateModified;

- (id)init;

@end
