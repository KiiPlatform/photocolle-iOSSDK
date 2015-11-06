#import <Foundation/Foundation.h>
#import "DCEnumerations.h"

@interface DCMiscUtils : NSObject

+ (NSURL *)urlForAuthorization;
+ (NSURL *)urlForToken;
+ (NSURL *)urlForPhotoColleService;
+ (BOOL)isLoggable;
+ (NSString *)deleteLastSlash:(NSString *)str;
+ (NSString *)getUTCString:(NSDate *)date;
+ (NSMutableURLRequest *)toPostRequestFromURL:(NSURL *)url;
+ (NSDictionary *)JSONObjectWithData:(NSData *)data error:(NSError **)error;
// FIXME: A fragment of method name fromJSON should be fromDictionary.
+ (NSNumber *)numberForKey:(NSString *)key
                  fromJSON:(NSDictionary *)json
                     error:(NSError **)error;
+ (NSNumber *)numberForKey:(NSString *)key
                  fromJSON:(NSDictionary *)json
          withRangeMinimum:(int)minimum
                   maximum:(int)maximum
                     error:(NSError **)error;
+ (NSNumber *)numberForKey:(NSString *)key
                  fromJSON:(NSDictionary *)json
          withRangeMinimum:(int)minimum
                     error:(NSError **)error;
+ (NSArray *)arrayForKey:(NSString *)key
                fromJSON:(NSDictionary *)json
                   error:(NSError **)error;
+ (NSArray *)arrayForKey:(NSString *)key
                fromJSON:(NSDictionary *)json
  withLengthRangeMinimum:(int)minimum
                 maximum:(int)maximum
                   error:(NSError **)error;
+ (NSString *)stringForKey:(NSString *)key
                  fromJSON:(NSDictionary *)json
                     error:(NSError **)error;
+ (NSString *)stringForKey:(NSString *)key
                  fromJSON:(NSDictionary *)json
    withLengthRangeMinimum:(int)minimum
                   maximum:(int)maximum
                     error:(NSError **)error;
+ (NSDate *)dateForKey:(NSString *)key
              fromJSON:(NSDictionary *)json
                 error:(NSError **)error;
+ (NSString *)optStringForKey:(NSString *)key
                     fromJSON:(NSDictionary *)json
                        error:(NSError **)error;
+ (NSNumber *)optNumberForKey:(NSString *)key
                     fromJSON:(NSDictionary *)json
                        error:(NSError **)error;
+ (NSNumber *)optNumberForKey:(NSString *)key
                     fromJSON:(NSDictionary *)json
                 defaultValue:(NSNumber *)defaultValue
                        error:(NSError **)error;
+ (NSNumber *)optNumberForKey:(NSString *)key
                     fromJSON:(NSDictionary *)json
                 defaultValue:(NSNumber *)defaultValue
             withRangeMinimum:(int)minimum
                        error:(NSError **)error;
+ (NSArray *)optArrayForKey:(NSString *)key
                   fromJSON:(NSDictionary *)json
                      error:(NSError **)error;
+ (NSArray *)optArrayForKey:(NSString *)key
                   fromJSON:(NSDictionary *)json
     withLengthRangeMinimum:(int)minimum
                    maximum:(int)maximum
                      error:(NSError **)error;
+ (NSDate *)parseAs3339:(NSString *)str error:(NSError **)error;
+ (NSData *)dataFromBase64String:(NSString *)base64String;
+ (NSData *)toDataFromInputStream:(NSInputStream *)stream;
+ (NSString *)firstMatched:(NSString *)str
                 toPattern:(NSString *)pattern
                   options:(NSRegularExpressionOptions)options
                     error:(NSError **)error;
+ (BOOL)isNilOrEmptyStrig:(NSString *)str;
+ (NSArray *)removeDuplicatedItems:(NSArray *)array;

@end
