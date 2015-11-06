#import "DCOAuth2Authentication.h"

@interface DCOAuth2Authentication ()

+ (NSString *)toStringFromDate:(NSDate *)date;
+ (NSDate *)toDateFromString:(NSString *)string;
+ (NSString *)toStringFromCFTypeRef:(CFTypeRef)ref;
+ (CFTypeRef)toCFTypeRefFromString:(NSString *)string;

@end
