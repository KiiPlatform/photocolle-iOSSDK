#import <UIKit/UIKit.h>

@protocol DCADataListProviding;

@interface DCAListViewController : UITableViewController

// provider must set by user of this class.
@property (nonatomic, readwrite, strong) id <DCADataListProviding> provider;

@end
