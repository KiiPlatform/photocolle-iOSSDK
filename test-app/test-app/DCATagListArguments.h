#import <Foundation/Foundation.h>
#import <PhotoColleSDK/DCEnumerations.h>

@interface DCATagListArguments : NSObject

@property (nonatomic, readwrite) DCCategory category;

@property (nonatomic, readwrite) DCFileType fileType;

@property (nonatomic, readwrite, strong) NSDate *minDateModified;

- (id)init;

@end
