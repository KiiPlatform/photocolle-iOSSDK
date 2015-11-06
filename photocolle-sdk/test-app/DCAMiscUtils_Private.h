#import "DCAMiscUtils.h"

@interface DCAMiscUtils ()

+ (NSString *)getStringForKey:(NSString *)key
                 fromResource:(NSString *)file
                 defaultValue:(NSString *)defaultValue;
+ (NSString *)getResourceDictionary:(NSString *)file;
+ (NSInputStream *)openResourceInputStream:(NSString *)file;

@end
