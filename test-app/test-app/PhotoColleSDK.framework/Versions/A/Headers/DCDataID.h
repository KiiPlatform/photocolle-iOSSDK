#import <Foundation/Foundation.h>
#import "DCDTO.h"

/*!
 * File id of uploaded content.
 */
@interface DCDataID : NSObject<DCDTO>

/*!
 * String representation of file id.
 */
@property (nonatomic, readonly) NSString *stringValue;

@end
