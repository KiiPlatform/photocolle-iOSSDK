#import <Foundation/Foundation.h>

/*!
 * This class is base class for various container of response <font>list</font> classes.
 */
@interface DCListResponse : NSObject

/*!
 * Value of count.
 */
@property (nonatomic, readonly) int count;

/*!
 * Value of nextPage.
 */
@property (nonatomic, readonly) int nextPage;

/*!
 * Value of start.
 */
@property (nonatomic, readonly) int start;

/*!
 * Response list.
 */
@property (nonatomic, readonly) NSArray *list ;

@end
