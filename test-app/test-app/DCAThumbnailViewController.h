#import <UIKit/UIKit.h>

@class DCContentGUID;

@interface DCAThumbnailViewController : UIViewController

@property (nonatomic, weak) IBOutlet UITextView *textView;

@property (nonatomic, readwrite, strong) DCContentGUID *guid;

@end
