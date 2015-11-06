#import <Foundation/Foundation.h>
#import "DCDTO.h"

/*!
 * Server capacity information.
 */
@interface DCCapacityInfo : NSObject<DCDTO>

/*!
 * Maximum space size of server.
 */
@property (nonatomic, readonly) long long maxSpace;

/*!
 * Free space size of server.
 */
@property (nonatomic, readonly) long long freeSpace;

@end
