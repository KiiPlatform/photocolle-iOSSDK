#import <photocolle_iOSSDK/DCPhotoColleSDK.h>

#import "DCADeletionListProvider.h"

#import "DCADataProviding.h"
#import "DCAAppDelegate.h"
#import "DCADeletionListArguments.h"

@interface DCAContentGUIDProvider : NSObject <DCADataProviding>

@property (nonatomic, readwrite, strong) DCContentGUID *guid;

- (id)initWithGuid:(DCContentGUID *)guid;
+ (id)providerWithGuid:(DCContentGUID *)guid;

@end

@implementation DCAContentGUIDProvider

- (id)initWithGuid:(DCContentGUID *)guid
{
    self = [super init];
    if (self != nil) {
        self.guid = guid;
    }
    return self;
}

+ (id)providerWithGuid:(DCContentGUID *)guid
{
    return [[DCAContentGUIDProvider alloc] initWithGuid:guid];
}

- (NSString *)label
{
    return self.guid.stringValue;
}

- (NSString *)jsonString
{
    NSDictionary *json = [NSDictionary dictionaryWithObjectsAndKeys:
                          self.guid.stringValue, @"guid", nil];
    NSData *data =
    [NSJSONSerialization dataWithJSONObject:json
                                    options:NSJSONWritingPrettyPrinted
                                      error:nil];
    return [[NSString alloc] initWithData:data
                                 encoding:NSUTF8StringEncoding];
}

- (DCContentGUID *)id
{
    return self.guid;
}

@end

@interface DCADeletionListProvider ()

@property (nonatomic, readwrite, strong) NSArray *objects;

@end

@implementation DCADeletionListProvider

- (NSInteger)count
{
    return [self.objects count];
}

- (id <DCADataProviding>)objectAtIndex:(NSInteger)index
{
    DCContentGUID *guid = [self.objects objectAtIndex:index];
    return [DCAContentGUIDProvider providerWithGuid:guid];
}

- (BOOL)retrieveDataWithPhotoColle:(DCPhotoColle *)photocolle
                             error:(NSError **)error
{
    DCAAppDelegate *app = (DCAAppDelegate *)[[UIApplication sharedApplication] delegate];

    DCContentGUIDListResponse *result = (DCContentGUIDListResponse *)
        [photocolle getContentDeletionHistoryWithFileType:app.deletionListArguments.fileType
                                           minDateDeleted:app.deletionListArguments.minDateDeleted
                                               maxResults:app.deletionListArguments.maxResults
                                                    start:app.deletionListArguments.start
                                                    error:error];
    if (*error != nil) {
        return NO;
    }
    self.objects = result.list;
    return YES;
}


@end
