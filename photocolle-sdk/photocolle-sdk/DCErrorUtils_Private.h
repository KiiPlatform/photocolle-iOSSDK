#import "DCErrorUtils.h"

@class DCErrorItem;

@interface DCErrorUtils ()

+ (NSError *)httpErrorFromHttpResponse:(NSHTTPURLResponse *)httpResponse;
+ (NSError *)responseBodyParseErrorWithCode:(NSInteger)code
                                   userInfo:(NSDictionary *)userInfo;
+ (NSArray *)toErrorItemsFromJSONArray:(NSArray *)array
                                 error:(NSError **)error;
+ (DCErrorItem *)toErrorItemFromJSONObject:(NSDictionary *)json
                                     error:(NSError **)error;
+ (DCApplicationLayerErrorCode)uploadErrorCodeFromJson:(NSDictionary *)json
                                                 error:(NSError **)error;
+ (NSString *)errorItemNameFromJSON:(NSDictionary *)json
                              error:(NSError **)error;
+ (DCApplicationLayerErrorCode) toErrorCodeFromInt:(int)code
                                             error:(NSError **)error;

+ (BOOL)isTokenExpired:(NSData *)data;
+ (NSError *)tokenExpiredError;
+ (NSError *)authenticationContextAccessErrorWithReason:(DCAuthenticationContextAccessErrorReason) reason
                                               userInfo:(NSDictionary *)userInfo;
+ (NSString *)getAuthenticateErrorReason:(NSDictionary *)userInfo;
@end
