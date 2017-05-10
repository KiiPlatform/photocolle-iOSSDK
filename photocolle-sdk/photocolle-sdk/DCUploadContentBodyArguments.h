#import "DCArguments.h"
#import "DCEnumerations.h"

/*!
 * @class DCUploadContentBodyArguments
 * @abstract Arguments for DCUploadContentBodyLogic.
 */
@interface DCUploadContentBodyArguments : DCArguments

/*!
 * @property fileType
 * @abstract File type of upload content.
 */
@property (nonatomic, readonly) DCFileType fileType;

/*!
 * @property title
 * @abstract Title of upload content.
 */
@property (nonatomic, readonly) NSString *fileName;

/*!
 * @property size
 * @abstract Size of upload content.
 */
@property (nonatomic, readonly) long long size;
/*!
 * @property mimeType
 * @abstract MIME type of upload content.
 */
@property (nonatomic, readonly) DCMimeType mimeType;

/*!
 * @property bodyData
 * @abstract bodyData of upload content.
 */
@property (nonatomic, readonly) NSData *bodyData;

/*!
 * @method argumentsWithContext:fileType:title:size:mimeType:inputStream:
 * @abstract Create this class instance.
 * @param context Context of an authentication.
 * @param fileType File type of upload content.
 * @param fileName File name of upload content.
 * @param size Size of upload content.
 * @param mimeType MIME type of upload content.
 * @param bodyData bodyData of upload content.
 * @return Created instance.
 */
+ (id)argumentsWithContext:(DCAuthenticationContext *)context
                  fileType:(DCFileType)fileType
                  fileName:(NSString *)fileName
                      size:(long long)size
                  mimeType:(DCMimeType)mimeType
                  bodyData:(NSData *)bodyData;

/*!
 * @method dealloc
 * @abstract Deallocate this instance.
 */
- (void)dealloc;

@end
