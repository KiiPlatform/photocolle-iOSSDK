#import "DCErrors.h"

@interface DCUploadErrorItem ()

- (id)initWithName:(NSString *)name
         errorCode:(DCApplicationLayerErrorCode)errorCode;

@property (nonatomic, readwrite, strong) NSString *name;
@property (nonatomic, readwrite) DCApplicationLayerErrorCode errorCode;

@end
