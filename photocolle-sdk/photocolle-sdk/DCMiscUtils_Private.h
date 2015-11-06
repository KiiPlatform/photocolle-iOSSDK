#import "DCMiscUtils.h"

@interface DCMiscUtils ()

+ (NSURL *)getURLForKey:(NSString *)key
           fromResource:(NSString *)file;
+ (NSString *)getStringForKey:(NSString *)key
                 fromResource:(NSString *)file
                 defaultValue:(NSString *)defaultValue;
+ (NSString *)getResourceDictionary:(NSString *)file;
+ (NSInputStream *)openResourceInputStream:(NSString *)file;
+ (id)objectForKey:(NSString *)key
          fromJSON:(NSDictionary *)json
           asClass:(Class)class
             error:(NSError **)error;
+ (id)optObjectForKey:(NSString *)key
             fromJSON:(NSDictionary *)json
              asClass:(Class)class
                error:(NSError **)error;
+ (NSTimeInterval)fromTimeToTimeInterval:(NSString *)time
                                   error:(NSError **)error;

@end
