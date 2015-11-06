#import <Foundation/Foundation.h>
#import "DCErrors.h"

@interface DCErrorUtils : NSObject

+ (NSError *)httpRelatedErrorFromHttpResponse:(NSHTTPURLResponse *)httpResponse
                                         data:(NSData *)data;
+ (NSError *)applicationLayerErrorFromJSON:(NSDictionary *)json;
+ (NSError *)responseBodyParseErrorWithDescription:(NSString *)description;
+ (NSError *)responseBodyParseErrorWithCause:(NSError *)cause;
+ (NSError *)authenticationContextAccessErrorWithReason:(DCAuthenticationContextAccessErrorReason) reason
                                                  cause:(NSError *)cause;
+ (NSError *)authenticationContextAccessErrorWithReason:(DCAuthenticationContextAccessErrorReason) reason;
+ (NSError *)uploadErrorFromJSON:(NSDictionary *)json;
+ (NSError *)connectionErrorWithCause:(NSError *)cause;
+ (NSError *)connectionErrorWithDescription:(NSString *)description;
+ (NSError *)authenticationCancelError;
+ (NSError *)authenticationGrantError;
+ (NSError *)toAuthenticationRelatedErrorFromString:(NSString *)str;
+ (NSError *)toAuthenticationRelatedError:(NSError *)error;
+ (NSError *)authenticationErrorWithReason:(DCAuthenticationErrorReason)reason;

@end
