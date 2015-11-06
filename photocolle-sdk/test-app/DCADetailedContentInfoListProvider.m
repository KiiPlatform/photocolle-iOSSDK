#import "DCADetailedContentInfoListProvider.h"

#import "DCDetailedContentInfo.h"
#import "DCDetailedContentInfoListResponse.h"
#import "DCPhotoColle.h"
#import "DCEnumerations.h"
#import "DCADataProviding.h"
#import "DCNamedTagHead.h"
#import "DCAAppDelegate.h"
#import "DCADetailedContentInfoListArguments.h"

@interface DCADetailedContentInfoProvider : NSObject <DCADataProviding>

@property (nonatomic, readwrite, strong) DCDetailedContentInfo *info;

- (id)initWithInfo:(DCDetailedContentInfo *)info;
+ (id)providerWithInfo:(DCDetailedContentInfo *)info;

@end

@implementation DCADetailedContentInfoProvider

- (id)initWithInfo:(DCDetailedContentInfo *)info
{
    self = [super init];
    if (self != nil) {
        self.info = info;
    }
    return self;
}

+ (id)providerWithInfo:(DCDetailedContentInfo *)info
{
    return [[DCADetailedContentInfoProvider alloc] initWithInfo:info];
}

- (NSString *)label
{
    return self.info.guid.stringValue;
}

- (NSString *)jsonString
{
    NSArray *persons = [DCADetailedContentInfoProvider
                        toArrayFromNamedTagHeadList:self.info.persons];
    NSArray *events = [DCADetailedContentInfoProvider
                       toArrayFromNamedTagHeadList:self.info.events];
    NSArray *favorites = [DCADetailedContentInfoProvider
                          toArrayFromNamedTagHeadList:self.info.favorites];
    NSArray *places = [DCADetailedContentInfoProvider
                       toArrayFromNamedTagHeadList:self.info.places];
    NSArray *yearMonths = [DCADetailedContentInfoProvider
                        toArrayFromNamedTagHeadList:self.info.yearMonths];

    NSDictionary *json = [NSDictionary dictionaryWithObjectsAndKeys:
                          self.info.guid.stringValue, @"guid",
                          self.info.name, @"name",
                          [NSNumber numberWithInt:self.info.fileType], @"fileType",
                          [self.info.exifCameraDate description], @"exifCameraDate",
                          [self.info.modifiedDate description], @"modifiedDate",
                          [self.info.uploadedDate description], @"uploadDate",
                          [NSNumber numberWithLongLong:self.info.fileDataSize], @"fileDataSize",
                          [NSNumber numberWithBool:self.info.resizable], @"resizable",
                          self.info.score, @"score",
                          self.info.orientation, @"orientation",
                          persons, @"persons",
                          events, @"events",
                          favorites, @"favorites",
                          places, @"places",
                          yearMonths, @"yearMonths",
                          nil];
    NSData *data =
    [NSJSONSerialization dataWithJSONObject:json
                                    options:NSJSONWritingPrettyPrinted
                                      error:nil];
    return [[NSString alloc] initWithData:data
                                 encoding:NSUTF8StringEncoding];
}

- (DCContentGUID *)id
{
    return self.info.guid;
}

+ (NSArray *)toArrayFromNamedTagHeadList:(NSArray *)list
{
    NSMutableArray *retval = [NSMutableArray array];
    for (DCNamedTagHead *head in list) {
        NSDictionary *json = [DCADetailedContentInfoProvider toJsonFromNamedTagHead:head];
        [retval addObject:json];
    }
    return [NSArray arrayWithArray:retval];
}

+ (NSDictionary *)toJsonFromNamedTagHead:(DCNamedTagHead *)head
{
    return [NSDictionary dictionaryWithObjectsAndKeys:
            head.guid.stringValue, @"guid",
            head.name, @"name",
            nil];
}

@end

@interface DCADetailedContentInfoListProvider ()

@property (nonatomic, readwrite, strong) NSArray *objects;

@end

@implementation DCADetailedContentInfoListProvider

- (NSInteger)count
{
    return self.objects.count;
}

- (id <DCADataProviding>)objectAtIndex:(NSInteger)index
{
    DCDetailedContentInfo *info = [self.objects objectAtIndex:index];
    return [DCADetailedContentInfoProvider providerWithInfo:info];
}

- (BOOL)retrieveDataWithPhotoColle:(DCPhotoColle *)photoColle
                             error:(NSError **)error
{
    DCAAppDelegate *app = (DCAAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    DCDetailedContentInfoListResponse *result = (DCDetailedContentInfoListResponse *)
    [photoColle getContentIDListWithTagsWithProjectionType:app.detailedContentInfoListArguments.projectionType
                                                  fileType:app.detailedContentInfoListArguments.fileType
                                              criteriaList:app.detailedContentInfoListArguments.criteriaList
                                                forDustbox:app.detailedContentInfoListArguments.forDustbox
                                                dateFilter:app.detailedContentInfoListArguments.dateFilter
                                                maxResults:app.detailedContentInfoListArguments.maxResults
                                                     start:app.detailedContentInfoListArguments.start
                                                  sortType:app.detailedContentInfoListArguments.sortType
                                                     error:error];
    if (*error != nil) {
        return NO;
    }
    self.objects = result.list;
    return YES;
}

@end
