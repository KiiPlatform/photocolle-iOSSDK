#import <UIKit/UIKit.h>

@interface DCAAccessTokenEditViewController : UIViewController

@property (nonatomic, readwrite, strong) NSString *storeKey;

@property (nonatomic, weak) IBOutlet UILabel *storeKeyLabel;

@property (nonatomic, weak) IBOutlet UITextField *accessTokenTextField;

@property (nonatomic, weak) IBOutlet UITextField *expiredDateTextField;

@property (nonatomic, weak) IBOutlet UITextField *refreshTokenTextField;

@end
