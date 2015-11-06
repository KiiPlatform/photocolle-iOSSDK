#import "DCPhotoColle_Private.h"
#import "DCMiscUtils.h"
#import "DCGetContentIDListCommand.h"
#import "DCGetContentIDListArguments.h"
#import "DCGetContentIDListWithTagsCommand.h"
#import "DCGetContentIDListWithTagsArguments.h"
#import "DCGetTagIDListCommand.h"
#import "DCGetTagIDListArguments.h"
#import "DCGetContentDeletionHistoryCommand.h"
#import "DCGetContentDeletionHistoryArguments.h"
#import "DCGetContentBodyInfoCommand.h"
#import "DCGetContentBodyInfoArguments.h"
#import "DCGetContentThumbnailInfoCommand.h"
#import "DCGetContentThumbnailInfoArguments.h"
#import "DCUploadContentBodyCommand.h"
#import "DCUploadContentBodyArguments.h"
#import "DCGetCapacityInfoCommand.h"
#import "DCGetCapacityInfoArguments.h"
#import "DCExceptionUtils.h"

@implementation DCPhotoColle

- (DCPhotoColle *)initWithDCAuthenticationContext:
        (DCAuthenticationContext *)authenticationContext
{
    if (authenticationContext == nil) {
        [DCExceptionUtils raiseInvalidArgumentExceptionWithReason:
            @"authenticationContext must not be nil."];
    }

    self = [super init];
    if (self != nil) {
        self.dcAuthenticationContext = authenticationContext;
        self.baseUrl = [DCMiscUtils urlForPhotoColleService];
    }
    return self;
}

- (DCContentInfoListResponse *)
        getContentIDListWithFileType:(DCFileType)fileType
                          forDustbox:(BOOL)forDustbox
                          dateFilter:(id <DCDateFiltering>)dateFilter
                          maxResults:(NSNumber *)maxResults
                               start:(NSNumber *)start
                            sortType:(DCSortType)sortType
                               error:(NSError **)error
{
    DCContentInfoListResponse *retval = nil;
    NSError *cause = nil;
    DCGetContentIDListCommand *command =
        [[DCGetContentIDListCommand alloc] initWithBaseURL:self.baseUrl];
    DCGetContentIDListArguments *arguments =
        [DCGetContentIDListArguments
            argumentsWithContext:self.dcAuthenticationContext
                        fileType:fileType
                      forDustbox:forDustbox
                      dateFilter:dateFilter
                      maxResults:maxResults
                           start:start
                        sortType:sortType];
    retval = [command executeWithArgument:arguments error:&cause];
    if (error != nil) {
        *error = cause;
    }
    return retval;
}

- (DCDetailedContentInfoListResponse *)
        getContentIDListWithTagsWithProjectionType:(DCProjectionType)projectionType
                                          fileType:(DCFileType)fileType
                                      criteriaList:(NSArray *)criteriaList
                                        forDustbox:(BOOL)forDustbox
                                        dateFilter:(id <DCDateFiltering>)dateFilter
                                        maxResults:(NSNumber *)maxResults
                                             start:(NSNumber *)start
                                          sortType:(DCSortType)sortType
                                             error:(NSError **)error
{
    DCDetailedContentInfoListResponse *retval = nil;
    NSError *cause = nil;
    DCGetContentIDListWithTagsCommand *command =
        [[DCGetContentIDListWithTagsCommand alloc]
           initWithBaseURL:self.baseUrl];
    DCGetContentIDListWithTagsArguments *arguments =
        [DCGetContentIDListWithTagsArguments
           argumentsWithContext:self.dcAuthenticationContext
                 projectionType:projectionType
                       fileType:fileType
                   criteriaList:criteriaList
                     forDustbox:forDustbox
                     dateFilter:dateFilter
                     maxResults:maxResults
                          start:start
                       sortType:sortType];
    retval = [command executeWithArgument:arguments error:&cause];
    if (error != nil) {
        *error = cause;
    }
    return retval;
}

- (DCTagListResponse *)getTagIDListWithCategory:(DCCategory)category
                                       fileType:(DCFileType)fileType
                                minDateModified:(NSDate *)minDateModified
                                          error:(NSError **)error
{
    DCTagListResponse *retval = nil;
    NSError *cause = nil;
    DCGetTagIDListCommand *command =
        [[DCGetTagIDListCommand alloc] initWithBaseURL:self.baseUrl];
    DCGetTagIDListArguments *arguments =
        [DCGetTagIDListArguments
           argumentsWithContext:self.dcAuthenticationContext
                       category:category
                       fileType:fileType
                minDateModified:minDateModified];
    retval = [command executeWithArgument:arguments error:&cause];
    if (error != nil) {
        *error = cause;
    }
    return retval;
}

- (DCContentGUIDListResponse *)
        getContentDeletionHistoryWithFileType:(DCFileType)fileType
                               minDateDeleted:(NSDate *)minDateDeleted
                                   maxResults:(NSNumber *)maxResults
                                        start:(NSNumber *)start
                                        error:(NSError **)error
{
    DCContentGUIDListResponse * retval = nil;
    NSError *cause = nil;
    DCGetContentDeletionHistoryCommand *command =
        [[DCGetContentDeletionHistoryCommand alloc]
           initWithBaseURL:self.baseUrl];
    DCGetContentDeletionHistoryArguments *arguments =
        [DCGetContentDeletionHistoryArguments
           argumentsWithContext:self.dcAuthenticationContext
                       fileType:fileType
                 minDateDeleted:minDateDeleted
                     maxResults:maxResults
                          start:start];
    retval = [command executeWithArgument:arguments error:&cause];
    if (error != nil) {
        *error = cause;
    }
    return retval;
}

- (DCContentBodyInfo *)
        getContentBodyInfoWithFileType:(DCFileType)fileType
                           contentGUID:(DCContentGUID *)contentGUID
                            resizeType:(DCResizeType)resizeType
                                 error:(NSError **)error
{
    DCContentBodyInfo *retval = nil;
    NSError *cause = nil;
    DCGetContentBodyInfoCommand *command =
        [[DCGetContentBodyInfoCommand alloc] initWithBaseURL:self.baseUrl];
    DCGetContentBodyInfoArguments *arguments =
        [DCGetContentBodyInfoArguments
           argumentsWithContext:self.dcAuthenticationContext
                       fileType:fileType
                    contentGUID:contentGUID
                     resizeType:resizeType];
    retval = [command executeWithArgument:arguments error:&cause];
    if (error != nil) {
        *error = cause;
    }
    return retval;
}

-(DCContentThumbnailInfoList *)
        getContentThumbnailInfoWithContentGUIDArray:(NSArray *)contentGUIDs
                                              error:(NSError **)error
{
    DCContentThumbnailInfoList *retval = nil;
    NSError *cause = nil;
    DCGetContentThumbnailInfoCommand *command =
        [[DCGetContentThumbnailInfoCommand alloc]
           initWithBaseURL:self.baseUrl];
    DCGetContentThumbnailInfoArguments *arguments =
        [DCGetContentThumbnailInfoArguments
           argumentsWithContext:self.dcAuthenticationContext
                   contentGUIDs:contentGUIDs];
    retval = [command executeWithArgument:arguments error:&cause];
    if (error != nil) {
        *error = cause;
    }
    return retval;
}

-(DCDataID *)uploadContentBodyWithFileType:(DCFileType)fileType
                                  fileName:(NSString *)fileName
                                      size:(long long)size
                                  mimeType:(DCMimeType)mimeType
                                bodyStream:(NSInputStream *)bodyStream
                                     error:(NSError **)error
{
    // FIXME: implement command, logic and argument classes to upload image
    // with NSInputStream.
    @try {
        if (bodyStream == nil) {
            [DCExceptionUtils
              raiseNilAssignedExceptionWithReason:@"bodyStream must not be nil"];
        }
        [bodyStream open];
        NSData *bodyData = [DCMiscUtils toDataFromInputStream:bodyStream];
        return [self uploadContentBodyWithFileType:fileType
                                          fileName:fileName
                                              size:size
                                          mimeType:mimeType
                                          bodyData:bodyData
                                             error:error];
    } @finally {
        [bodyStream close];
    }
}

-(DCDataID *)uploadContentBodyWithFileType:(DCFileType)fileType
                                  fileName:(NSString *)fileName
                                      size:(long long)size
                                  mimeType:(DCMimeType)mimeType
                                  bodyData:(NSData *)bodyData
                                     error:(NSError **)error
{
    DCDataID *retval = nil;
    NSError *cause = nil;
    DCUploadContentBodyCommand *command =
        [[DCUploadContentBodyCommand alloc] initWithBaseURL:self.baseUrl];
    DCUploadContentBodyArguments *arguments =
        [DCUploadContentBodyArguments
               argumentsWithContext:self.dcAuthenticationContext
                           fileType:fileType
                           fileName:fileName
                               size:size
                           mimeType:mimeType
                           bodyData:bodyData];
    retval = [command executeWithArgument:arguments error:&cause];
    if (error != nil) {
        *error = cause;
    }
    return retval;
}

- (DCCapacityInfo *)getCapacityInfoWithError:(NSError **)error
{
    DCCapacityInfo *retval = nil;
    NSError *cause = nil;
    DCGetCapacityInfoCommand *command =
        [[DCGetCapacityInfoCommand alloc] initWithBaseURL:self.baseUrl];
    DCGetCapacityInfoArguments *arguments =
        [DCGetCapacityInfoArguments
           argumentsWithContext:self.dcAuthenticationContext];
    retval = [command executeWithArgument:arguments error:&cause];
    if (error != nil) {
        *error = cause;
    }
    return retval;
}

@end
