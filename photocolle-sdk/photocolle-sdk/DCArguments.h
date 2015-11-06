#import <Foundation/Foundation.h>

@class DCAuthenticationContext;

/*!
 * @class DCArguments
 * @abstract Base class for various arguments class.
 */
@interface DCArguments : NSObject

@property (nonatomic, readonly) DCAuthenticationContext *context;

- (id)initWithContext:(DCAuthenticationContext *)context;

@end
