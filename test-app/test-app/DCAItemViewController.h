#import <UIKit/UIKit.h>

@protocol DCADataProviding;

@interface DCAItemViewController : UIViewController

@property (nonatomic, weak) IBOutlet UITextView *textView;

@property (nonatomic, readwrite, strong) id <DCADataProviding> provider;

@end
