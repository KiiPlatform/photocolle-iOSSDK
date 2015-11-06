#import <Foundation/Foundation.h>
#import "DCEnumerations.h"

@interface DCEnumerationsUtils : NSObject

+ (NSNumber *)toNSNumberFromDCFiletype:(DCFileType)fileType;
+ (NSNumber *)toNSNumberFromDCSortType:(DCSortType)sortType;
+ (NSNumber *)toNSNumberFromDCTagType:(DCTagType)tagType;
+ (NSNumber *)toNSNumberFromDCCategory:(DCCategory)category;
+ (NSNumber *)toNSNumberFromDCResizeType:(DCResizeType)resizeType;
+ (NSString *)toNSStringFromDCProjectionType:(DCProjectionType)projectionType;
+ (NSString *)toNSStringFromDCMimeType:(DCMimeType)mimeType;

+ (DCFileType)toDCFileTypeFromInt:(int)value error:(NSError **)error;
+ (DCScore)toDCScoreFromInt:(int)value error:(NSError **)error;
+ (DCOrientation)toDCOrientationFromInt:(int)value error:(NSError **)error;
+ (DCMimeType)toDCMimeTypeFromString:(NSString *)value error:(NSError **)error;

+ (BOOL)isValidFileType:(DCFileType)fileType;
+ (BOOL)isValidFileTypeWithAll:(DCFileType)fileType;
+ (BOOL)isValidUploadingFileType:(DCFileType)fileType;
+ (BOOL)isValidTagType:(DCTagType)tagType;
+ (BOOL)isValidMimeType:(DCMimeType)mimeType;
+ (BOOL)isValidProjectionType:(DCProjectionType)projectionType;
+ (BOOL)isValidCategory:(DCCategory)category;
+ (BOOL)isValidResizeType:(DCResizeType)resizeType;

@end
