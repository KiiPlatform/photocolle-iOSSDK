#import <Foundation/Foundation.h>
#import "DCDTO.h"
#import "DCEnumerations.h"

/*!
 * Content body information received from server.
 */
@interface DCContentBodyInfo : NSObject<DCDTO>

/*!
  MIME type of this content. See DCMimeType for details.
 */
@property (nonatomic, readonly) DCMimeType contentType;

/*!
 * InputStream object which contains body data.
 */
@property (nonatomic, readonly) NSInputStream *inputStream;

@end
