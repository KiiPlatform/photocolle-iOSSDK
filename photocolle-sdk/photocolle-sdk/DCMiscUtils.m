#import "DCMiscUtils.h"
#import "DCErrorUtils.h"
#import "DCExceptionUtils.h"
#import "cdecode.h"

static NSString * const AUTH_URL_KEY = @"authorityUrl";
static NSString * const TOKEN_URL_KEY = @"tokenUrl";
static NSString * const PHOTOCOLLE_URL_KEY = @"photocolleUrl";
static NSString * const LOGGING_KEY = @"logging";
static NSString * const SDK_SETTING = @"photocolle_sdk_setting.plist";

@implementation DCMiscUtils

+ (NSURL *)urlForAuthorization
{
    return [DCMiscUtils getURLForKey:AUTH_URL_KEY
                        fromResource:SDK_SETTING];
}

+ (NSURL *)urlForToken
{
    return [DCMiscUtils getURLForKey:TOKEN_URL_KEY
                        fromResource:SDK_SETTING];
}

+ (NSURL *)urlForPhotoColleService
{
    return [DCMiscUtils getURLForKey:PHOTOCOLLE_URL_KEY
                        fromResource:SDK_SETTING];
}

+ (BOOL)isLoggable
{
    return [DCMiscUtils getBooleanForKey:LOGGING_KEY
                            fromResource:SDK_SETTING
                            defaultValue:NO];
}

+ (NSString *)deleteLastSlash:(NSString *)str
{
    if (str == nil) {
        return nil;
    }
    NSString *retval = str;
    const unichar SLASH = [@"/" characterAtIndex:0];
    while ([retval length] > 0) {
        NSUInteger lastIndex = [retval length] - 1;
        if ([retval characterAtIndex:lastIndex] != SLASH) {
            break;
        }
        retval = [retval substringToIndex:lastIndex];
    }
    return retval;
}

+ (NSURL *)getURLForKey:(NSString *)key
           fromResource:(NSString *)file
{
    NSString *str =
        [DCMiscUtils deleteLastSlash:[DCMiscUtils getStringForKey:key
                                                  fromResource:file
                                                  defaultValue:nil]];
    return str == nil ? nil : [NSURL URLWithString:str];
}

+ (NSString *)getStringForKey:(NSString *)key
                 fromResource:(NSString *)file
                 defaultValue:(NSString *)defaultValue
{
    NSAssert(key != nil, @"key must not be nil");
    NSAssert(file != nil, @"file must not be nil");

    NSDictionary *dict = [DCMiscUtils getResourceDictionary:file];
    NSString *retval = [dict objectForKey:key];
    if (retval == nil) {
        return defaultValue;
    }
    return retval;
}

+ (BOOL)getBooleanForKey:(NSString *)key
            fromResource:(NSString *)file
            defaultValue:(BOOL)defaultValue
{
    NSAssert(key != nil, @"key must not be nil");
    NSAssert(file != nil, @"file must not be nil");
    
    NSDictionary *dict = [DCMiscUtils getResourceDictionary:file];
    NSNumber *retval = [dict objectForKey:key];
    if (retval == nil) {
        return defaultValue;
    }
    return [retval boolValue];
}

+ (NSDictionary *)getResourceDictionary:(NSString *)file
{
    NSAssert(file != nil, @"file must not be nil");

    NSInputStream *stream = nil;
    @try {
        stream = [DCMiscUtils openResourceInputStream:file];
        if (stream == nil) {
            return nil;
        }
        [stream open];
        // NSPropertyListReadOptions currently not implemented so 0 is used.
        // https://developer.apple.com/library/ios/#documentation/Cocoa/Reference/Foundation/Classes/NSPropertyListSerialization_Class/Reference/Reference.html#//apple_ref/occ/cl/NSPropertyListSerialization
        NSPropertyListFormat format = NSPropertyListOpenStepFormat;
        return (NSDictionary *)[NSPropertyListSerialization
                                 propertyListWithStream:stream
                                                options:0
                                                 format:&format
                                                  error:nil];
    } @finally {
        [stream close];
    }
}

+ (NSInputStream *)openResourceInputStream:(NSString *)file
{
    NSAssert(file != nil, @"file must not be nil.");

    NSString *path = [[NSBundle mainBundle] pathForResource:file ofType:nil];
    if (path == nil) {
        return nil;
    }
    return [NSInputStream inputStreamWithFileAtPath:path];
}

+ (NSString *)getUTCString:(NSDate *)date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss'Z'";
    return [formatter stringFromDate:date];
}

+ (NSMutableURLRequest *)toPostRequestFromURL:(NSURL *)url
{
    NSMutableURLRequest *retval = [NSMutableURLRequest requestWithURL:url];
    [retval setHTTPMethod:@"POST"];
    // FIXME: timeout time should be decided by setting.
    [retval setTimeoutInterval:60];
    return retval;
}

+ (NSDictionary *)JSONObjectWithData:(NSData *)data error:(NSError **)error
{
    if (data == nil) {
        if (error != nil) {
            *error = [DCErrorUtils responseBodyParseErrorWithDescription:
                                     @"data must not be nil"];
        }
        return nil;
    }
    NSError *cause = nil;
    id retval =
        [NSJSONSerialization JSONObjectWithData:data
                                        options:NSJSONReadingAllowFragments
                                          error:&cause];
    if (cause != nil) {
        if (error != nil) {
            *error = cause;
        }
        return nil;
    }
    if ([retval isKindOfClass:[NSDictionary class]] == NO) {
        if (error != nil) {
            *error = [DCErrorUtils responseBodyParseErrorWithDescription:
                                     @"JSON must be object."];
        }
        return nil;
    }
    return (NSDictionary *)retval;
}

+ (id)objectForKey:(NSString *)key
          fromJSON:(NSDictionary *)json
           asClass:(Class)class
             error:(NSError **)error
{
    if (key == nil) {
        if (error != nil) {
            *error = [DCErrorUtils responseBodyParseErrorWithDescription:
                                     @"key must not be nil."];
        }
        return nil;
    }
    if (json == nil) {
        if (error != nil) {
            *error = [DCErrorUtils responseBodyParseErrorWithDescription:
                                     @"json must not be nil."];
        }
        return nil;
    }
    id retval = [json objectForKey:key];
    if ([retval isKindOfClass:class] == NO) {
        if (error != nil) {
            *error = [DCErrorUtils responseBodyParseErrorWithDescription:
                    [NSString stringWithFormat:@"Class must be %@ but %@",
                              NSStringFromClass(class),
                              NSStringFromClass([retval class])]];
        }
        return nil;
    }
    return retval;
}

+ (NSNumber *)numberForKey:(NSString *)key
                  fromJSON:(NSDictionary *)json
                     error:(NSError **)error
{
    return (NSNumber *)[DCMiscUtils objectForKey:key
                                        fromJSON:json
                                         asClass:[NSNumber class]
                                           error:error];
}

+ (NSNumber *)numberForKey:(NSString *)key
                  fromJSON:(NSDictionary *)json
          withRangeMinimum:(int)minimum
                   maximum:(int)maximum
                     error:(NSError **)error
{
    NSNumber *retval = [DCMiscUtils numberForKey:key fromJSON:json error:error];
    if (retval == nil) {
        return nil;
    } else if ([retval intValue] < minimum || [retval intValue] > maximum) {
        if (error != nil) {
            *error = [DCErrorUtils responseBodyParseErrorWithDescription:
                    [NSString stringWithFormat:@"%@ is out of range: %d",
                              key, [retval intValue]]];
        }
        return nil;
    }
    return retval;
}

+ (NSNumber *)numberForKey:(NSString *)key
                  fromJSON:(NSDictionary *)json
          withRangeMinimum:(int)minimum
                     error:(NSError **)error
{
    NSNumber *retval = [DCMiscUtils numberForKey:key fromJSON:json error:error];
    if (retval == nil) {
        return nil;
    } else if ([retval intValue] < minimum) {
        if (error != nil) {
            *error = [DCErrorUtils responseBodyParseErrorWithDescription:
                    [NSString stringWithFormat:@"%@ is out of range: %d", key,
                              [retval intValue]]];
        }
        return nil;
    }
    return retval;
}

+ (NSArray *)arrayForKey:(NSString *)key
                fromJSON:(NSDictionary *)json
                   error:(NSError **)error
{
    return (NSArray *)[DCMiscUtils objectForKey:key
                                       fromJSON:json
                                        asClass:[NSArray class]
                                          error:error];
}

+ (NSArray *)arrayForKey:(NSString *)key
                fromJSON:(NSDictionary *)json
  withLengthRangeMinimum:(int)minimum
                 maximum:(int)maximum
                   error:(NSError **)error
{
    NSArray *retval = (NSArray *)[DCMiscUtils arrayForKey:key
                                                 fromJSON:json
                                                    error:error];
    if (retval == nil) {
        return nil;
    } else if ([retval count] < minimum || [retval count] > maximum) {
        if (error != nil) {
            *error = [DCErrorUtils responseBodyParseErrorWithDescription:
                      [NSString stringWithFormat:@"%@ is out of range: %lu",
                       key, (unsigned long)[retval count]]];
        }
        return nil;
    }
    return retval;
}

+ (NSString *)stringForKey:(NSString *)key
                  fromJSON:(NSDictionary *)json
                     error:(NSError **)error
{
    return (NSString *)[DCMiscUtils objectForKey:key
                                       fromJSON:json
                                        asClass:[NSString class]
                                          error:error];
}

+ (NSString *)stringForKey:(NSString *)key
                  fromJSON:(NSDictionary *)json
    withLengthRangeMinimum:(int)minimum
                   maximum:(int)maximum
                     error:(NSError **)error
{
    NSString *retval = [DCMiscUtils stringForKey:key fromJSON:json error:error];
    if (retval == nil) {
        return nil;
    } else if ([retval length] < minimum || [retval length] > maximum) {
        if (error != nil) {
            *error = [DCErrorUtils responseBodyParseErrorWithDescription:
                    [NSString stringWithFormat:
                                @"length of %@ is out of range: %lu", key,
                              (unsigned long)[retval length]]];
        }
        return nil;
    }
    return retval;
}

+ (NSDate *)dateForKey:(NSString *)key
              fromJSON:(NSDictionary *)json
                 error:(NSError **)error
{
    NSError *cause = nil;
    NSString *str = [DCMiscUtils stringForKey:key fromJSON:json error:&cause];
    if (cause != nil) {
        if (error != nil) {
            *error = cause;
        }
        return nil;
    }
    return [DCMiscUtils parseAs3339:str error:error];
}

+ (NSString *)optStringForKey:(NSString *)key
                     fromJSON:(NSDictionary *)json
                        error:(NSError **)error
{
    return (NSString *)[DCMiscUtils optObjectForKey:key
                                           fromJSON:json
                                            asClass:[NSString class]
                                              error:error];
}

+ (NSNumber *)optNumberForKey:(NSString *)key
                     fromJSON:(NSDictionary *)json
                        error:(NSError **)error
{
    return (NSNumber *)[DCMiscUtils optObjectForKey:key
                                           fromJSON:json
                                            asClass:[NSNumber class]
                                              error:error];
}

+ (NSNumber *)optNumberForKey:(NSString *)key
                     fromJSON:(NSDictionary *)json
                 defaultValue:(NSNumber *)defaultValue
                        error:(NSError **)error
{
    NSError *cause = nil;
    NSNumber *retval = [DCMiscUtils optNumberForKey:key
                                           fromJSON:json
                                              error:&cause];
    if (cause != nil) {
        if (error != nil) {
            *error = cause;
        }
        return nil;
    }

    if (retval == nil) {
        return defaultValue;
    } else {
        return retval;
    }
}

+ (NSNumber *)optNumberForKey:(NSString *)key
                     fromJSON:(NSDictionary *)json
                 defaultValue:(NSNumber *)defaultValue
             withRangeMinimum:(int)minimum
                        error:(NSError **)error
{
    NSError *cause = nil;
    NSNumber *retval = [DCMiscUtils optNumberForKey:key
                                           fromJSON:json
                                              error:&cause];
    if (cause != nil) {
        if (error != nil) {
            *error = [DCErrorUtils responseBodyParseErrorWithCause:cause];
        }
        return nil;
    } else if (retval == nil) {
        return defaultValue;
    } else if ([retval intValue] < minimum) {
        if (error != nil) {
            *error = [DCErrorUtils responseBodyParseErrorWithDescription:
                    [NSString stringWithFormat:
                        @"%@ must be equal or over 1: %d", key,
                              [retval intValue]]];
        }
        return nil;
    }
    return retval;
}

+ (NSArray *)optArrayForKey:(NSString *)key
                   fromJSON:(NSDictionary *)json
                      error:(NSError **)error
{
    return (NSArray *)[DCMiscUtils optObjectForKey:key
                                          fromJSON:json
                                           asClass:[NSArray class]
                                             error:error];
}

+ (NSArray *)optArrayForKey:(NSString *)key
                   fromJSON:(NSDictionary *)json
     withLengthRangeMinimum:(int)minimum
                    maximum:(int)maximum
                      error:(NSError **)error
{
    NSArray *retval = (NSArray *)[DCMiscUtils optArrayForKey:key
                                                    fromJSON:json
                                                       error:error];
    if (retval == nil) {
        return nil;
    } else if ([retval count] < minimum || [retval count] > maximum) {
        if (error != nil) {
            *error = [DCErrorUtils responseBodyParseErrorWithDescription:
                      [NSString stringWithFormat:@"%@ is out of range: %lu",
                       key, (unsigned long)[retval count]]];
        }
        return nil;
    }
    return retval;
}

+ (NSString *)optObjectForKey:(NSString *)key
                     fromJSON:(NSDictionary *)json
                      asClass:(Class)class
                        error:(NSError **)error
{
    if (key == nil) {
        if (error != nil) {
            *error = [DCErrorUtils responseBodyParseErrorWithDescription:
                                     @"key must not be nil."];
        }
        return nil;
    }
    if (json == nil) {
        if (error != nil) {
            *error = [DCErrorUtils responseBodyParseErrorWithDescription:
                                     @"json must not be nil."];
        }
        return nil;
    }
    id retval = [json objectForKey:key];
    if (retval == nil) {
        return nil;
    } else if ([retval isKindOfClass:class] == NO) {
        if (error != nil) {
            *error = [DCErrorUtils responseBodyParseErrorWithDescription:
                    [NSString stringWithFormat:@"Class must be %@ but %@",
                              NSStringFromClass(class),
                              NSStringFromClass([retval class])]];
        }
        return nil;
    }
    return (NSString *)retval;
}

+ (NSDate *)parseAs3339:(NSString *)str error:(NSError **)error
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ss'Z'"];
    switch ([str characterAtIndex:19]) {
        case 'z':
        case 'Z':
            // TODO: if return value is nil, error should be set.
            return [formatter dateFromString:str];
        case '+':
            {
                // TODO: if fail to parse, error should be set.
                NSString *time = [str substringFromIndex:20];
                NSTimeInterval seconds =
                    [DCMiscUtils fromTimeToTimeInterval:time error:error] * -1;
                NSString *dateStr =
                    [[str substringToIndex:19] stringByAppendingString:@"Z"];
                NSDate *date = [formatter dateFromString:dateStr];
                return [NSDate dateWithTimeInterval:seconds sinceDate:date];
            }
        case '-':
            {
                // TODO: if fail to parse, error should be set.
                NSString *time = [str substringFromIndex:20];
                NSTimeInterval seconds =
                    [DCMiscUtils fromTimeToTimeInterval:time error:error];
                NSString *dateStr =
                    [[str substringToIndex:19] stringByAppendingString:@"Z"];
                NSDate *date = [formatter dateFromString:dateStr];
                return [NSDate dateWithTimeInterval:seconds sinceDate:date];
            }
        default:
            if (error != nil) {
                *error = [DCErrorUtils responseBodyParseErrorWithDescription:
                        [NSString stringWithFormat:@"Invalid date format: %@ ",
                                  str]];
            }
            return nil;
    }
}

+ (NSTimeInterval)fromTimeToTimeInterval:(NSString *)time
                                   error:(NSError **)error
{
    // TODO: check time format.
    // time formart must be HH:mm
    NSInteger hour = [[time substringToIndex:2] integerValue];
    NSInteger min =
        [[[time substringFromIndex:3] substringToIndex:2] integerValue];
    return (NSTimeInterval)(((hour * 60) + min) * 60);
}

+ (NSData *)dataFromBase64String:(NSString *)base64String
{
    NSAssert(base64String != nil, @"base64String must not be nil.");

    const char *code_in = [base64String cStringUsingEncoding:NSASCIIStringEncoding];
    unsigned long length_in = (unsigned long)[base64String length];
    char buf[length_in / 4 * 3];
    dc_base64_decodestate status;
    dc_base64_init_decodestate(&status);
    unsigned long decodeLen = dc_base64_decode_block(code_in, length_in, buf, &status);
    return [NSData dataWithBytes:buf length:decodeLen];
}

+ (NSData *)toDataFromInputStream:(NSInputStream *)stream
{
    NSMutableData *data = [NSMutableData data];
    uint8_t buf[1024];
    while ([stream hasBytesAvailable] != NO) {
        NSInteger size = [stream read:buf maxLength:sizeof(buf)/sizeof(buf[0])];
        if (size == 0) {
            break;
        } else if (size < 0) {
            [DCExceptionUtils
              raiseUnexpectedExceptionWithReason:@"fail to read stream"];
        }
        [data appendBytes:buf length:size];
    }
    return [NSData dataWithData:data];
}

+ (NSString *)firstMatched:(NSString *)str
                 toPattern:(NSString *)pattern
                   options:(NSRegularExpressionOptions)options
                     error:(NSError **)error
{
    if (str == nil) {
        return nil;
    }
    NSRegularExpression *regExp =
        [NSRegularExpression regularExpressionWithPattern:pattern
                                                  options:options
                                                    error:error];
    if (regExp == nil) {
        return nil;
    }
    return [regExp stringByReplacingMatchesInString:str
                                            options:NSMatchingReportCompletion
                                              range:NSMakeRange(0, str.length)
                                       withTemplate:@"$1"];
}

+ (BOOL)isNilOrEmptyStrig:(NSString *)str
{
    return (str == nil || [str length] == 0) ? YES : NO;
}

+ (NSArray *)removeDuplicatedItems:(NSArray *)array
{
    NSMutableArray *retval = [NSMutableArray array];
    for (id object in array) {
        if ([retval containsObject:object] == NO) {
            [retval addObject:object];
        }
    }
    return retval;
}

@end
