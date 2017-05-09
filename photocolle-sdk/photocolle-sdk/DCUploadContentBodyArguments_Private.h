#import "DCUploadContentBodyArguments.h"

@interface DCUploadContentBodyArguments ()

@property (nonatomic, readwrite) DCFileType fileType;
@property (nonatomic, readwrite, strong) NSString *fileName;
@property (nonatomic, readwrite) long long size;
@property (nonatomic, readwrite) DCMimeType mimeType;
@property (nonatomic, readwrite, strong) NSData *bodyData;

/*!
 * @method initWithContext:fileType:title:size:mimeType:inputStream:
 * @abstract Create this class instance.
 * @param context Context of an authentication.
 * @param fileType File type of upload content.
 * @param size Size of upload content.
 * @param mimeType MIME type of upload content.
 * @return Created instance.
 */
- (id)initWithContext:(DCAuthenticationContext *)context
             fileType:(DCFileType)fileType
             fileName:(NSString *)fileName
                 size:(long long)size
             mimeType:(DCMimeType)mimeType
             bodyData:(NSData *)bodyData;

+ (BOOL)isValidExtension:(NSString *)fileName
            withMimeType:(DCMimeType)mimeType;

@end
