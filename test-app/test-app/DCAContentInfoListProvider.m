#import <photocolle_iOSSDK/DCPhotoColleSDK.h>

#import "DCAContentInfoListProvider.h"

#import "DCADataProviding.h"
#import "DCAAppDelegate.h"
#import "DCAContentInfoListArguments.h"

@interface DCAContentInfoProvider : NSObject <DCADataProviding>

@property (nonatomic, readwrite, strong) DCContentInfo *info;

- (id)initWithInfo:(DCContentInfo *)info;
+ (id)providerWithInfo:(DCContentInfo *)info;

@end

@implementation DCAContentInfoProvider

- (id)initWithInfo:(DCContentInfo *)info
{
    self = [super init];
    if (self != nil) {
        self.info = info;
    }
    return self;
}

+ (id)providerWithInfo:(DCContentInfo *)info
{
    return [[DCAContentInfoProvider alloc] initWithInfo:info];
}

- (NSString *)label
{
    return self.info.guid.stringValue;
}

- (NSString *)jsonString
{
    NSDictionary *json = [NSDictionary dictionaryWithObjectsAndKeys:
             self.info.guid.stringValue, @"guid",
             self.info.name, @"name",
             [NSNumber numberWithInt:self.info.fileType], @"fileType",
             [self.info.exifCameraDate description], @"exifCameraDate",
             [self.info.modifiedDate description], @"modifiedDate",
             [self.info.uploadedDate description], @"uploadDate",
             [NSNumber numberWithLongLong:self.info.fileDataSize], @"fileDataSize",
             [NSNumber numberWithBool:self.info.resizable], @"resizable", nil];
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

@end

@interface DCAContentInfoListProvider ()

@property (nonatomic, readwrite, strong) NSArray *objects;

@end

@implementation DCAContentInfoListProvider

- (NSInteger)count
{
    return self.objects.count;
}

- (id <DCADataProviding>)objectAtIndex:(NSInteger)index
{
    DCContentInfo *info = [self.objects objectAtIndex:index];
    return [DCAContentInfoProvider providerWithInfo:info];
}

- (BOOL)retrieveDataWithPhotoColle:(DCPhotoColle *)photoColle
                             error:(NSError **)error
{
    DCAAppDelegate *app = (DCAAppDelegate *)[[UIApplication sharedApplication] delegate];

    DCContentInfoListResponse *result = (DCContentInfoListResponse *)
        [photoColle getContentIDListWithFileType:app.contentInfoListArguments.fileType
                                      forDustbox:app.contentInfoListArguments.forDustbox
                                      dateFilter:app.contentInfoListArguments.dateFilter
                                      maxResults:app.contentInfoListArguments.maxResults
                                           start:app.contentInfoListArguments.start
                                        sortType:app.contentInfoListArguments.sortType
                                           error:error];
    if (*error != nil) {
        return NO;
    }
    self.objects = result.list;
    return YES;
}

@end
