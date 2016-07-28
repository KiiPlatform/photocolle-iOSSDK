#import "DCErrorUtils.h"
#import "DCErrors_Private.h"
#import "DCMiscUtils.h"
#import "GTMOAuth2Authentication.h"

@implementation DCErrorUtils

+ (NSError *)httpRelatedErrorFromHttpResponse:(NSHTTPURLResponse *)httpResponse
                                         data:(NSData *)data
{
    NSAssert(httpResponse != nil, @"httpResponse must not be nil");
    if ([DCErrorUtils isTokenExpired:httpResponse] != NO) {
        return [DCErrorUtils tokenExpiredError];
    }
    return [DCErrorUtils httpErrorFromHttpResponse:httpResponse data:data];
}

+ (NSError *)httpErrorFromHttpResponse:(NSHTTPURLResponse *)httpResponse
                                  data:(NSData *)data
{
    NSAssert(httpResponse != nil, @"httpResponse must not be nil");
    NSDictionary *userInfo =
        [NSDictionary dictionaryWithObjectsAndKeys:
            [NSNumber numberWithInteger:httpResponse.statusCode],
            @"statusCode",
            [NSHTTPURLResponse
                localizedStringForStatusCode:httpResponse.statusCode],
            @"reasonPhrase",
            data,
            @"responseBody",
            nil];
    return [NSError errorWithDomain:DCHttpErrorDomain
                               code:0
                           userInfo:userInfo];
}

+ (NSError *)applicationLayerErrorFromJSON:(NSDictionary *)json
{
    NSAssert(json != nil, @"json must not be nil");
    NSError *cause = nil;
    NSNumber *errorCode = [DCMiscUtils numberForKey:@"err_cd"
                                           fromJSON:json
                                              error:&cause];
    if (cause != nil) {
        return [DCErrorUtils responseBodyParseErrorWithCause:cause];
    }

    int code = [DCErrorUtils toErrorCodeFromInt:errorCode.intValue
                                          error:&cause];
    if (cause != nil) {
        return [DCErrorUtils responseBodyParseErrorWithCause:cause];
    }
    
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    NSString * paramName = [DCMiscUtils optStringForKey:@"param_name"
                                               fromJSON:json
                                                  error:&cause];
    if (cause != nil) {
        return [DCErrorUtils responseBodyParseErrorWithCause:cause];
    }
    if (paramName != nil) {
        [userInfo setObject:paramName forKey:@"paramName"];
    }
    NSString * paramValue = [DCMiscUtils optStringForKey:@"param_value"
                                                fromJSON:json
                                                   error:&cause];
    if (cause != nil) {
        return [DCErrorUtils responseBodyParseErrorWithCause:cause];
    }
    if (paramName != nil) {
        [userInfo setObject:paramValue forKey:@"paramValue"];
    }
    return [NSError
             errorWithDomain:DCApplicationLayerErrorDomain
                        code:code
                    userInfo:userInfo];
}

+ (NSError *)responseBodyParseErrorWithDescription:(NSString *)description
{
    return [DCErrorUtils
             responseBodyParseErrorWithCode:0
                                   userInfo:[NSDictionary
                                              dictionaryWithObjectsAndKeys:
                                                description,
                                                NSLocalizedDescriptionKey,
                                                nil]];
}

+ (NSError *)responseBodyParseErrorWithCause:(NSError *)cause
{
    // To avoid nesting same error domain, copied NSError is returned.
    if ([cause.domain isEqualToString:DCResponseBodyParseErrorDomain] == YES) {
        return [DCErrorUtils responseBodyParseErrorWithCode:cause.code
                                                   userInfo:cause.userInfo];
    }
    return [DCErrorUtils
             responseBodyParseErrorWithCode:0
                                   userInfo:[NSDictionary
                                              dictionaryWithObjectsAndKeys:
                                                cause, NSUnderlyingErrorKey,
                                                nil]];
}

+ (NSError *)responseBodyParseErrorWithCode:(NSInteger)code
                                   userInfo:(NSDictionary *)userInfo
{
    return [NSError errorWithDomain:DCResponseBodyParseErrorDomain
                               code:0
                           userInfo:userInfo];
}

+ (NSError *)authenticationContextAccessErrorWithReason:(DCAuthenticationContextAccessErrorReason) reason
{
    return [DCErrorUtils authenticationContextAccessErrorWithReason:reason
                                                           userInfo:nil];
}

+ (NSError *)authenticationContextAccessErrorWithReason:(DCAuthenticationContextAccessErrorReason) reason
                                                  cause:(NSError *)cause
{
    NSDictionary *userInfo = nil;
    if (cause != nil) {
        userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                                   cause, NSUnderlyingErrorKey, nil];
    }
    return [DCErrorUtils authenticationContextAccessErrorWithReason:reason
                                                           userInfo:userInfo];
}

+ (NSError *)uploadErrorFromJSON:(NSDictionary *)json
{
    NSError *cause = nil;
    NSArray *array = [DCMiscUtils arrayForKey:@"err_list"
                                     fromJSON:json
                                        error:&cause];
    if (cause != nil) {
        return [DCErrorUtils responseBodyParseErrorWithCause:cause];
    }
    NSArray *errItems = [DCErrorUtils toErrorItemsFromJSONArray:array
                                                          error:&cause];
    if (cause != nil) {
        return [DCErrorUtils responseBodyParseErrorWithCause:cause];
    }
    return [NSError errorWithDomain:DCUploadErrorDomain
                               code:0
                           userInfo:[NSDictionary dictionaryWithObjectsAndKeys:
                                                  errItems, @"errorItems",
                                                  nil]];
}

+ (NSArray *)toErrorItemsFromJSONArray:(NSArray *)array
                                 error:(NSError **)error
{
    NSAssert(array != nil, @"array must not be nil");
    NSAssert(error != nil, @"error must not be nil");
    NSMutableArray *retval = [NSMutableArray array];
    for (NSDictionary *json in array) {
        DCUploadErrorItem *item =
            [DCErrorUtils toErrorItemFromJSONObject:json
                                              error:error];
        if (*error != nil) {
            return nil;
        }
        [retval addObject:item];
    }
    return retval;
}

+ (DCUploadErrorItem *)toErrorItemFromJSONObject:(NSDictionary *)json
                                           error:(NSError **)error
{
    NSAssert(json != nil, @"json must not be nil");
    NSAssert(error != nil, @"error must not be nil");
    DCApplicationLayerErrorCode errorCode =
        [DCErrorUtils uploadErrorCodeFromJson:json
                                        error:error];
    if (*error != nil) {
        return nil;
    }
    NSString *name = [DCErrorUtils errorItemNameFromJSON:json
                                                   error:error];
    if (*error != nil) {
        return nil;
    }

    return [[DCUploadErrorItem alloc] initWithName:name errorCode:errorCode];
}

+ (DCApplicationLayerErrorCode)uploadErrorCodeFromJson:(NSDictionary *)json
                                                 error:(NSError **)error
{
    NSAssert(json != nil, @"json must not be nil");
    NSAssert(error != nil, @"error must not be nil");
    NSString *str = [DCMiscUtils stringForKey:@"err_cd"
                                     fromJSON:json
                                        error:error];
    if (*error != nil) {
        return DCAPPLICATIONLAYERERRORCODE_PARAMETER_ERROR;
    }
    int code = 0;
    if ([[NSScanner scannerWithString:str] scanInt:&code] == NO) {
        *error = [DCErrorUtils responseBodyParseErrorWithDescription:
                [NSString stringWithFormat:
                    @"Fail to scan error code: %@", str]];
        return DCAPPLICATIONLAYERERRORCODE_PARAMETER_ERROR;
    }
    return [DCErrorUtils toErrorCodeFromInt:code error:error];
}

+ (NSString *)errorItemNameFromJSON:(NSDictionary *)json
                              error:(NSError **)error
{
    NSAssert(json != nil, @"json must not be nil");
    NSAssert(error != nil, @"error must not be nil");
    NSString *retval = [DCMiscUtils stringForKey:@"err_item"
                                        fromJSON:json
                                           error:error];
    if (*error != nil) {
        return nil;
    }
    if ([retval length] < 1 || [retval length] > 255) {
        *error = [DCErrorUtils responseBodyParseErrorWithDescription:
                [NSString stringWithFormat:
                    @"err_item is out of range: %lu",
                          (unsigned long)[retval length]]];
        return nil;
    }
    return retval;
}

+ (DCApplicationLayerErrorCode)toErrorCodeFromInt:(int)code
                                             error:(NSError **)error
{
    NSAssert(error != nil, @"error must not be nil");
    switch (code) {
        case 100:
            return DCAPPLICATIONLAYERERRORCODE_PARAMETER_ERROR;
        case 101:
            return DCAPPLICATIONLAYERERRORCODE_TARGET_NOT_FOUND;
        case 110:
            return DCAPPLICATIONLAYERERRORCODE_TIMEOUT;
        case 113:
            return DCAPPLICATIONLAYERERRORCODE_NO_RESULTS;
        case 900:
            return DCAPPLICATIONLAYERERRORCODE_SERVER_ERROR;
        case 1101:
            return DCAPPLICATIONLAYERERRORCODE_CONTENTS_DUPLICATED;
        case 1102:
            return DCAPPLICATIONLAYERERRORCODE_CAPACITY_OVER;
        case 1103:
            return DCAPPLICATIONLAYERERRORCODE_FAIL_TO_GET_FREE_SPACE;
        case 1104:
            return DCAPPLICATIONLAYERERRORCODE_FAIL_TO_GET_MAXIMUM_SPACE;
        case 1105:
            return DCAPPLICATIONLAYERERRORCODE_CONTENTS_NOT_FOUND;
        case 1110:
            return DCAPPLICATIONLAYERERRORCODE_MANDATORY_PARAMETER_MISSED;
        case 1111:
            return DCAPPLICATIONLAYERERRORCODE_PARAMETER_SIZE_UNMATCHED;
        case 1112:
            return DCAPPLICATIONLAYERERRORCODE_PARAMETER_TYPE_UNMATCHED;
        case 1113:
            return DCAPPLICATIONLAYERERRORCODE_PARAMETER_VALUE_INVALID;
        default:
            *error = [DCErrorUtils responseBodyParseErrorWithDescription:
                    [NSString stringWithFormat:
                        @"Fail to convert DCApplicationLayerErrorCode: %d",
                              code]];
            return DCAPPLICATIONLAYERERRORCODE_PARAMETER_ERROR;
    }
}

+ (BOOL)isTokenExpired:(NSHTTPURLResponse *)response
{
    NSAssert(response != nil, @"httpResponse must not be nil");
    if (response.statusCode != 401) {
        return NO;
    } else if (response.allHeaderFields == nil) {
        return NO;
    }
    NSString *value = nil;
    for (NSString *key in response.allHeaderFields.allKeys) {
        if ([key caseInsensitiveCompare:@"WWW-Authenticate"] == NSOrderedSame) {
            value = [DCMiscUtils stringForKey:key
                                     fromJSON:response.allHeaderFields
                                        error:nil];
            break;
        }
    }
    if (value == nil) {
        return NO;
    }
    for (NSString *str in [value componentsSeparatedByString:@" "]) {
        if ([str isEqualToString:@"error=invalid_token"] == YES) {
            return YES;
        }
    }
    return NO;
}

+ (NSError *)tokenExpiredError
{
    return [NSError errorWithDomain:DCTokenExpiredErrorDomain
                               code:0
                           userInfo:nil];
}

+ (NSError *)authenticationContextAccessErrorWithReason:(DCAuthenticationContextAccessErrorReason) reason
                                               userInfo:(NSDictionary *)userInfo;
{
    return [NSError errorWithDomain:DCAuthenticationContextAccessErrorDomain
                               code:reason
                           userInfo:userInfo];
}

+ (NSError *)connectionErrorWithCause:(NSError *)cause
{
    return [NSError errorWithDomain:DCConnectionErrorDomain
                               code:0
                           userInfo:[NSDictionary dictionaryWithObjectsAndKeys:
                                                    cause, NSUnderlyingErrorKey,
                                                    nil]];
}

+ (NSError *)connectionErrorWithDescription:(NSString *)description
{
    return [NSError errorWithDomain:DCConnectionErrorDomain
                               code:0
                           userInfo:[NSDictionary dictionaryWithObjectsAndKeys:
                                                    description,
                                                    NSLocalizedDescriptionKey,
                                                    nil]];
}

+ (NSError *)authenticationCancelError
{
    return [NSError errorWithDomain:DCAuthenticationCanceledErrorDomain
                               code:0
                           userInfo:nil];
}

+ (NSError *)authenticationGrantError
{
    return [DCErrorUtils authenticationErrorWithReason:
            DCAUTHENTICATIONERRORREASON_INVALID_GRANT];
}

+ (NSError *)toAuthenticationRelatedErrorFromString:(NSString *)str
{
    if (str == nil) {
        return nil;
    }

    if ([str isEqualToString:@"access_denied"] != NO) {
        return [DCErrorUtils authenticationCancelError];
    }

    if ([str isEqualToString:@"invalid_request"] != NO) {
        return [DCErrorUtils authenticationErrorWithReason:
                DCAUTHENTICATIONERRORREASON_INVALID_REQUEST];
    } else if ([str isEqualToString:@"unsupported_response_type"] != NO) {
        return [DCErrorUtils authenticationErrorWithReason:
                DCAUTHENTICATIONERRORREASON_UNSUPPORTED_RESPONSE_TYPE];
    } else if ([str isEqualToString:@"server_error"] != NO) {
        return [DCErrorUtils authenticationErrorWithReason:
                DCAUTHENTICATIONERRORREASON_SERVER_ERROR];
    } else if ([str isEqualToString:@"invalid_grant"] != NO) {
        return [DCErrorUtils authenticationErrorWithReason:
                DCAUTHENTICATIONERRORREASON_INVALID_GRANT];
    } else if ([str isEqualToString:@"invalid_client"] != NO) {
        return [DCErrorUtils authenticationErrorWithReason:
                DCAUTHENTICATIONERRORREASON_INVALID_CLIENT];
    } else if ([str isEqualToString:@"unauthorized_client"] != NO) {
        return [DCErrorUtils authenticationErrorWithReason:
                DCAUTHENTICATIONERRORREASON_UNAUTHORIZED_CLIENT];
    } else if ([str isEqualToString:@"unsupported_grant_type"] != NO) {
        return [DCErrorUtils authenticationErrorWithReason:
                DCAUTHENTICATIONERRORREASON_UNSUPPORTED_GRANT_TYPE];
    } else if ([str isEqualToString:@"invalid_scope"] != NO) {
        return [DCErrorUtils authenticationErrorWithReason:
                DCAUTHENTICATIONERRORREASON_INVALID_SCOPE];
    } else if ([str isEqualToString:@"temporarily_unavailable"] != NO) {
        return [DCErrorUtils authenticationErrorWithReason:
                DCAUTHENTICATIONERRORREASON_TEMPORARILY_UNAVAILABLE];
    }

    // if unknown error code is notified, this might be server error.
    return nil;
}

+ (NSError *)authenticationErrorWithReason:(DCAuthenticationErrorReason)reason
{
    return [NSError errorWithDomain:DCAuthenticationErrorDomain
                               code:reason
                           userInfo:nil];
}

+ (NSError *)toAuthenticationRelatedError:(NSError *)error
{
    if ([error.domain isEqualToString:kDCGTMOAuth2ErrorDomain] == NO) {
        return error;
    }
    switch (error.code) {
        case DCGTMOAuth2ErrorWindowClosed:
            return [DCErrorUtils authenticationCancelError];
        case DCGTMOAuth2ErrorAuthorizationFailed:
            {
                NSError *retval = [DCErrorUtils
                        toAuthenticationRelatedErrorFromString:
                            [DCErrorUtils
                              getAuthenticateErrorReason:error.userInfo]];
                return retval != nil ? retval : error;
            }
        case DCGTMOAuth2ErrorTokenExpired:
            return [DCErrorUtils authenticationGrantError];
        case DCGTMOAuth2ErrorTokenUnavailable:
        case DCGTMOAuth2ErrorUnauthorizableRequest:
        default:
            return error;
    }
}

+ (NSString *)getAuthenticateErrorReason:(NSDictionary *)userInfo
{
    NSDictionary *dictionary =
        (NSDictionary *)[userInfo objectForKey:kDCGTMOAuth2ErrorJSONKey];
    dictionary = dictionary == nil ? userInfo : dictionary;
    return [DCMiscUtils stringForKey:kDCGTMOAuth2ErrorMessageKey
                            fromJSON:dictionary
                               error:nil];
}

@end
