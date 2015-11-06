#import "DCUploadContentBodyArguments.h"
#import "DCUploadContentBodyArguments_Private.h"
#import "DCEnumerationsUtils.h"
#import "DCExceptionUtils.h"

@implementation DCUploadContentBodyArguments

+ (id)argumentsWithContext:(DCAuthenticationContext *)context
                  fileType:(DCFileType)fileType
                  fileName:(NSString *)fileName
                      size:(long long)size
                  mimeType:(DCMimeType)mimeType
                  bodyData:(NSData *)bodyData;
{
    if (context == nil) {
        [DCExceptionUtils
            raiseNilAssignedExceptionWithReason:@"context must not be nil"];
    }
    if ([DCEnumerationsUtils isValidUploadingFileType:fileType] == NO) {
        [DCExceptionUtils raiseOutOfRangeExceptionWithReason:
                [NSString stringWithFormat:@"fileType is invalid: %ld",
                    (long)fileType]];
    }
    if ([DCEnumerationsUtils isValidMimeType:mimeType] == NO) {
        [DCExceptionUtils raiseOutOfRangeExceptionWithReason:
                [NSString stringWithFormat:@"mimeType is invalid: %ld",
                    (long)mimeType]];
    } else if ([DCUploadContentBodyArguments isValidCombinationOfMimeType:mimeType
                                                                 fileType:fileType] == NO) {
        [DCExceptionUtils raiseOutOfRangeExceptionWithReason:
         @"This combination of FileType and MimeType is invalid."];
    }
    if (fileName == nil) {
        [DCExceptionUtils
            raiseNilAssignedExceptionWithReason:@"fileName must not be nil"];
    } else if ([fileName length] < 1 || [fileName length] > 255) {
        [DCExceptionUtils
            raiseOutOfRangeExceptionWithReason:
                [NSString stringWithFormat:
                    @"length of fileName is out of range: %lu",
                    (unsigned long)[fileName length]]];
    } else if ([DCUploadContentBodyArguments
                    isValidExtension:fileName withMimeType:mimeType] == NO) {
        [DCExceptionUtils
            raiseOutOfRangeExceptionWithReason:
                [NSString stringWithFormat:
                    @"extension of fileName is wrong: %@", fileName]];
    }
    if (size < 1 || size > [DCUploadContentBodyArguments getMaxSize:fileType]) {
        [DCExceptionUtils
            raiseOutOfRangeExceptionWithReason:
                [NSString stringWithFormat:@"size is out of range: %lld", size]];
    }
    if (bodyData == nil) {
        [DCExceptionUtils
            raiseNilAssignedExceptionWithReason:@"bodyData must not be nil"];
    }

    return [[DCUploadContentBodyArguments alloc] initWithContext:context
                                                        fileType:fileType
                                                        fileName:fileName
                                                            size:size
                                                        mimeType:mimeType
                                                        bodyData:bodyData];
}

- (id)initWithContext:(DCAuthenticationContext *)context
             fileType:(DCFileType)fileType
             fileName:(NSString *)fileName
                 size:(long long)size
             mimeType:(DCMimeType)mimeType
             bodyData:(NSData *)bodyData
{
    self = [super initWithContext:context];
    if (self != nil) {
        self.fileType = fileType;
        self.fileName = fileName;
        self.size = size;
        self.mimeType = mimeType;
        self.bodyData = bodyData;
    }
    return self;
}

- (void)dealloc
{
    self.fileName = nil;
    self.bodyData = nil;
}

+ (BOOL)isValidExtension:(NSString *)fileName
            withMimeType:(DCMimeType)mimeType
{
    // TODO: implement me.
    // https://github.com/KiiCorp/photocolleSDK/issues/474
    return YES;
}

+ (long long)getMaxSize:(DCFileType)fileType
{
    long long retval = 0;
    switch (fileType) {
        case DCFILETYPE_IMAGE:
            retval = 30 * 1024 * 1024;
            break;
        case DCFILETYPE_VIDEO:
            retval = 100 * 1024 * 1024;
            break;
        case DCFILETYPE_SLIDE_MOVIE:
        default:
            @throw [NSException exceptionWithName:NSInvalidArgumentException
                                           reason:@"Unsupport file type."
                                         userInfo:nil];
    }
    return retval;
}

+ (BOOL)isValidCombinationOfMimeType:(DCMimeType)mimeType
                            fileType:(DCFileType)fileType
{
    switch (mimeType) {
        case DCMIMETYPE_JPEG:
        case DCMIMETYPE_PJPEG:
            return (fileType == DCFILETYPE_IMAGE ? YES : NO);
        case DCMIMETYPE_AVI:
        case DCMIMETYPE_MP4:
        case DCMIMETYPE_MPEG:
        case DCMIMETYPE_QUICKTIME:
        case DCMIMETYPE_THREE_GP:
        case DCMIMETYPE_VND_MTS:
            return (fileType == DCFILETYPE_VIDEO ? YES : NO);
        default:
            [DCExceptionUtils raiseUnexpectedExceptionWithReason:
             [NSString stringWithFormat:@"Unknown MimeType: %ld",
                 (long)mimeType]];
    }
}

@end
