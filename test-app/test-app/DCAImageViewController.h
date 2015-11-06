#import <UIKit/UIKit.h>

@class DCContentGUID;

@interface DCAImageViewController : UIViewController

@property (nonatomic, weak) IBOutlet UIImageView *imageView;

@property (nonatomic, readwrite, strong) DCContentGUID *guid;

@end
