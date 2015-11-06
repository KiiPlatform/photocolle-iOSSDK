#import "DCGetContentIDListLogic.h"

@class DCContentInfoListResponse;
@class DCContentInfo;

@interface DCGetContentIDListLogic ()

+ (DCContentInfoListResponse *)toDCContentInfoListResponse:(NSDictionary *)json
                                                     error:(NSError **)error;
+ (NSArray *)toDCContentInfoList:(NSArray *)jsonArray
                           error:(NSError **)error;
+ (DCContentInfo *)toDCContentInfoFromJSON:(NSDictionary *)json
                                     error:(NSError **)error;
+ (NSNumber *)startFromJSON:(NSDictionary *)json error:(NSError **)error;
+ (NSNumber *)nextPageFromJSON:(NSDictionary *)json error:(NSError **)error;
+ (NSString *)guidFromJSON:(NSDictionary *)json error:(NSError **)error;
+ (NSString *)contentNameFromJSON:(NSDictionary *)json error:(NSError **)error;
+ (NSNumber *)contentCntFromJSON:(NSDictionary *)json error:(NSError **)error;

@end
