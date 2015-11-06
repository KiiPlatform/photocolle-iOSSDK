#import "DCErrors_Private.h"

// Error domains defined in DCErrors.h
NSString * const DCApplicationLayerErrorDomain = @"ApplicationLayerErrorDomain";
NSString * const DCAuthenticationCanceledErrorDomain =
    @"AuthenticationCanceledErrorDomain";
NSString * const DCAuthenticationContextAccessErrorDomain =
    @"AuthenticationContextAccessErrorDomain";
NSString * const DCAuthenticationContextNotFoundErrorDomain =
    @"AuthenticationContextNotFoundErrorDomain";
NSString * const DCAuthenticationErrorDomain = @"AuthenticationErrorDomain";
NSString * const DCConnectionErrorDomain = @"ConnectionErrorDomain";
NSString * const DCHttpErrorDomain = @"HttpErrorDomain";
NSString * const DCResponseBodyParseErrorDomain =
    @"ResponseBodyParseErrorDomain";
NSString * const DCTokenExpiredErrorDomain = @"TokenExpiredErrorDomain";
NSString * const DCUploadErrorDomain = @"UploadErrorDomain";

@implementation DCUploadErrorItem

- (id)initWithName:(NSString *)name
         errorCode:(DCApplicationLayerErrorCode)errorCode
{
    self = [super init];
    if (self != nil) {
        self.name = name;
        self.errorCode = errorCode;
    }
    return self;
}

@end
