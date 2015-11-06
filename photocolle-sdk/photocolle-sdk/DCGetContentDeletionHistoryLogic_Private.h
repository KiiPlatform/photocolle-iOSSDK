#import "DCGetContentDeletionHistoryLogic.h"

@interface DCGetContentDeletionHistoryLogic ()

+ (NSNumber *)startFromJSON:(NSDictionary *)json error:(NSError **)error;
+ (NSNumber *)nextPageFromJSON:(NSDictionary *)json error:(NSError **)error;
+ (NSNumber *)contenCntFromJSON:(NSDictionary *)json error:(NSError **)error;

@end
