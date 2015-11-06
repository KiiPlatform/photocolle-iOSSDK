#import "DCEnumerationsUtils.h"
#import "DCErrorUtils.h"
#import "DCExceptionUtils.h"

@implementation DCEnumerationsUtils

+ (NSNumber *)toNSNumberFromDCFiletype:(DCFileType)fileType
{
    switch (fileType) {
        case DCFILETYPE_ALL:
            return [NSNumber numberWithInt:0];
        case DCFILETYPE_IMAGE:
            return [NSNumber numberWithInt:1];
        case DCFILETYPE_VIDEO:
            return [NSNumber numberWithInt:2];
        case DCFILETYPE_SLIDE_MOVIE:
            return [NSNumber numberWithInt:3];
        default:
            [DCExceptionUtils raiseOutOfRangeExceptionWithReason:
                [NSString stringWithFormat:@"unknown DCFileType:%ld",
                    (long)fileType]];
    }
}

+ (NSNumber *)toNSNumberFromDCSortType:(DCSortType)sortType
{
    switch (sortType) {
        case DCSORTTYPE_CREATION_DATETIME_DESC:
            return [NSNumber numberWithInt:1];
        case DCSORTTYPE_CREATION_DATETIME_ASC:
            return [NSNumber numberWithInt:2];
        case DCSORTTYPE_MODIFICATION_DATETIME_DESC:
            return [NSNumber numberWithInt:3];
        case DCSORTTYPE_MODIFICATION_DATETIME_ASC:
            return [NSNumber numberWithInt:4];
        case DCSORTTYPE_UPLOAD_DATETIME_ASC:
            return [NSNumber numberWithInt:5];
        case DCSORTTYPE_UPLOAD_DATETIME_DESC:
            return [NSNumber numberWithInt:6];
        case DCSORTTYPE_SCORE_DESC:
            return [NSNumber numberWithInt:7];
        default:
            [DCExceptionUtils raiseOutOfRangeExceptionWithReason:
                [NSString stringWithFormat:@"unknown DCSortType:%ld",
                    (long)sortType]];
    }
}

+ (NSNumber *)toNSNumberFromDCTagType:(DCTagType)tagType
{
    switch (tagType) {
        case DCTAGTYPE_PERSON:
            return [NSNumber numberWithInt:1];
        case DCTAGTYPE_EVENT:
            return [NSNumber numberWithInt:2];
        case DCTAGTYPE_FAVORITE:
            return [NSNumber numberWithInt:3];
        case DCTAGTYPE_PLACEMENT:
            return [NSNumber numberWithInt:4];
        case DCTAGTYPE_YEAR_MONTH:
            return [NSNumber numberWithInt:5];
        default:
            [DCExceptionUtils raiseOutOfRangeExceptionWithReason:
                [NSString stringWithFormat:@"unknown DCTagType:%ld",
                    (long)tagType]];
    }
}

+ (NSNumber *)toNSNumberFromDCCategory:(DCCategory)category
{
    switch (category) {
        case DCCATEGORY_ALL:
            return [NSNumber numberWithInt:0];
        case DCCATEGORY_PERSON:
            return [NSNumber numberWithInt:1];
        case DCCATEGORY_EVENT:
            return [NSNumber numberWithInt:2];
        case DCCATEGORY_FAVORITE:
            return [NSNumber numberWithInt:3];
        case DCCATEGORY_PLACEMENT:
            return [NSNumber numberWithInt:4];
        case DCCATEGORY_YEAR_MONTH:
            return [NSNumber numberWithInt:5];
        default:
            [DCExceptionUtils raiseOutOfRangeExceptionWithReason:
                [NSString stringWithFormat:@"unknown DCCategory:%ld",
                    (long)category]];
    }
}

+ (NSNumber *)toNSNumberFromDCResizeType:(DCResizeType)resizeType
{
    switch (resizeType) {
        case DCRESIZETYPE_ORIGINAL:
            return [NSNumber numberWithInt:1];
        case DCRESIZETYPE_RESIZED_IMAGE:
            return [NSNumber numberWithInt:2];
        case DCRESIZETYPE_RESIZED_VIDEO:
            return [NSNumber numberWithInt:3];
        default:
            [DCExceptionUtils raiseOutOfRangeExceptionWithReason:
                [NSString stringWithFormat:@"unknown DCResizeType:%ld",
                    (long)resizeType]];
    }
}

+ (NSString *)toNSStringFromDCProjectionType:(DCProjectionType)projectionType
{
    switch (projectionType) {
        case DCPROJECTIONTYPE_FILE_COUNT:
            return @"1";
        case DCPROJECTIONTYPE_ALL_DETAILS:
            return @"2";
        case DCPROJECTIONTYPE_DETAILS_WITHOUT_TAGS:
            return @"3";
        default:
            [DCExceptionUtils raiseOutOfRangeExceptionWithReason:
                [NSString stringWithFormat:@"unknown DCProjectionType:%ld",
                    (long)projectionType]];
    }
}

+ (NSString *)toNSStringFromDCMimeType:(DCMimeType)mimeType
{
    switch (mimeType) {
        case DCMIMETYPE_JPEG:
            return @"image/jpeg";
        case DCMIMETYPE_PJPEG:
            return @"image/pjpeg";
        case DCMIMETYPE_THREE_GP:
            return @"video/3gpp";
        case DCMIMETYPE_AVI:
            return @"video/avi";
        case DCMIMETYPE_QUICKTIME:
            return @"video/quicktime";
        case DCMIMETYPE_MP4:
            return @"video/mp4";
        case DCMIMETYPE_VND_MTS:
            return @"video/vnd.mts";
        case DCMIMETYPE_MPEG:
            return @"video/mpeg";
        default:
            [DCExceptionUtils raiseOutOfRangeExceptionWithReason:
                [NSString stringWithFormat:@"unknown DCMimeType:%ld",
                    (long)mimeType]];
    }
}

+ (DCFileType)toDCFileTypeFromInt:(int)value error:(NSError **)error
{
    NSAssert(error != nil, @"error must not be nil.");

    switch (value) {
        case 0:
            return DCFILETYPE_ALL;
        case 1:
            return DCFILETYPE_IMAGE;
        case 2:
            return DCFILETYPE_VIDEO;
        case 3:
            return DCFILETYPE_SLIDE_MOVIE;
        default:
            *error = [DCErrorUtils responseBodyParseErrorWithDescription:
                    [NSString stringWithFormat:
                        @"Fail to convert to DCFileType: %d",
                              value]];
            return DCFILETYPE_IMAGE;
    }
}

+ (DCScore)toDCScoreFromInt:(int)value error:(NSError **)error
{
    NSAssert(error != nil, @"error must not be nil.");

    switch (value) {
        case 1:
            return DCSCORE_SCORE_1;
        case 2:
            return DCSCORE_SCORE_2;
        case 3:
            return DCSCORE_SCORE_3;
        case 4:
            return DCSCORE_SCORE_4;
        case 5:
            return DCSCORE_SCORE_5;
        default:
            *error = [DCErrorUtils responseBodyParseErrorWithDescription:
                    [NSString stringWithFormat:
                        @"Fail to convert to DCScore: %d",
                              value]];
            return DCSCORE_SCORE_1;
    }
}

+ (DCOrientation)toDCOrientationFromInt:(int)value error:(NSError **)error
{
    NSAssert(error != nil, @"error must not be nil.");

    switch (value) {
        case 0:
            return DCORIENTATION_ROTATE_0;
        case 90:
            return DCORIENTATION_ROTATE_90;
        case 180:
            return DCORIENTATION_ROTATE_180;
        case 270:
            return DCORIENTATION_ROTATE_270;
        default:
            *error = [DCErrorUtils responseBodyParseErrorWithDescription:
                    [NSString stringWithFormat:
                        @"Fail to convert to DCOrientation: %d",
                              value]];
            return DCORIENTATION_ROTATE_0;
    }
}

+ (DCMimeType)toDCMimeTypeFromString:(NSString *)value error:(NSError **)error;
{
    NSAssert(error != nil, @"error must not be nil.");

    if ([@"image/jpeg" isEqualToString:value] == YES) {
        return DCMIMETYPE_JPEG;
    } else if ([@"image/pjpeg" isEqualToString:value] == YES) {
        return DCMIMETYPE_PJPEG;
    } else if ([@"video/3gpp" isEqualToString:value] == YES) {
        return DCMIMETYPE_THREE_GP;
    } else if ([@"video/avi" isEqualToString:value] == YES) {
        return DCMIMETYPE_AVI;
    } else if ([@"video/quicktime" isEqualToString:value] == YES) {
        return DCMIMETYPE_QUICKTIME;
    } else if ([@"video/mp4" isEqualToString:value] == YES) {
        return DCMIMETYPE_MP4;
    } else if ([@"video/vnd.mts" isEqualToString:value] == YES) {
        return DCMIMETYPE_VND_MTS;
    } else if ([@"video/mpeg" isEqualToString:value] == YES) {
        return DCMIMETYPE_MPEG;
    } else {
        *error = [DCErrorUtils responseBodyParseErrorWithDescription:
                [NSString stringWithFormat:@"Fail to convert to DCMimeType: %@",
                          value]];
        return DCMIMETYPE_JPEG;
    }
}

+ (BOOL)isValidFileType:(DCFileType)fileType
{
    switch (fileType) {
        case DCFILETYPE_IMAGE:
            return YES;
        case DCFILETYPE_VIDEO:
            return YES;
        case DCFILETYPE_SLIDE_MOVIE:
            return YES;
        default:
            return NO;
    }
}

+ (BOOL)isValidFileTypeWithAll:(DCFileType)fileType
{
    switch (fileType) {
        case DCFILETYPE_ALL:
            return YES;
        case DCFILETYPE_IMAGE:
            return YES;
        case DCFILETYPE_VIDEO:
            return YES;
        case DCFILETYPE_SLIDE_MOVIE:
            return YES;
        default:
            return NO;
    }
}

+ (BOOL)isValidUploadingFileType:(DCFileType)fileType
{
    switch (fileType) {
        case DCFILETYPE_IMAGE:
            return YES;
        case DCFILETYPE_VIDEO:
            return YES;
        case DCFILETYPE_SLIDE_MOVIE:
        default:
            return NO;
    }
}

+ (BOOL)isValidTagType:(DCTagType)tagType
{
    switch (tagType) {
        case DCTAGTYPE_PERSON:
            return YES;
        case DCTAGTYPE_EVENT:
            return YES;
        case DCTAGTYPE_FAVORITE:
            return YES;
        case DCTAGTYPE_PLACEMENT:
            return YES;
        case DCTAGTYPE_YEAR_MONTH:
            return YES;
        default:
            return NO;
    }
}

+ (BOOL)isValidMimeType:(DCMimeType)mimeType
{
    switch (mimeType) {
        case DCMIMETYPE_JPEG:
            return YES;
        case DCMIMETYPE_PJPEG:
            return YES;
        case DCMIMETYPE_THREE_GP:
            return YES;
        case DCMIMETYPE_AVI:
            return YES;
        case DCMIMETYPE_QUICKTIME:
            return YES;
        case DCMIMETYPE_MP4:
            return YES;
        case DCMIMETYPE_VND_MTS:
            return YES;
        case DCMIMETYPE_MPEG:
            return YES;
        default:
            return NO;
    }
}

+ (BOOL)isValidProjectionType:(DCProjectionType)projectionType
{
    switch (projectionType) {
        case DCPROJECTIONTYPE_ALL_DETAILS:
            return YES;
        case DCPROJECTIONTYPE_DETAILS_WITHOUT_TAGS:
            return YES;
        case DCPROJECTIONTYPE_FILE_COUNT:
            return YES;
        default:
            return NO;
    }
}

+ (BOOL)isValidCategory:(DCCategory)category
{
    switch (category) {
        case DCCATEGORY_ALL:
            return YES;
        case DCCATEGORY_PERSON:
            return YES;
        case DCCATEGORY_EVENT:
            return YES;
        case DCCATEGORY_FAVORITE:
            return YES;
        case DCCATEGORY_PLACEMENT:
            return YES;
        case DCCATEGORY_YEAR_MONTH:
            return YES;
        default:
            return NO;
    }
}

+ (BOOL)isValidResizeType:(DCResizeType)resizeType
{
    switch (resizeType) {
        case DCRESIZETYPE_ORIGINAL:
            return YES;
        case DCRESIZETYPE_RESIZED_IMAGE:
            return YES;
        case DCRESIZETYPE_RESIZED_VIDEO:
            return YES;
        default:
            return NO;
    }
}

@end
