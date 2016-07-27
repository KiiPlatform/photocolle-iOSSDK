#import <photocolle_iOSSDK/DCPhotoColleSDK.h>

#import "DCAImageViewController.h"
#import "DCAAppDelegate.h"
#import "DCAMiscUtils.h"

@interface DCAImageViewController ()

@property (nonatomic, readwrite, weak) UIActivityIndicatorView *indicator;

- (void)setImage;
- (void)load;
- (void)showIndicator;
- (void)hideIndicator;

@end

@implementation DCAImageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self load];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)load
{
    [self showIndicator];
    [self performSelectorInBackground:@selector(setImage) withObject:nil];
}

- (void)setImage
{
    @synchronized (self) {
        @autoreleasepool {
            DCAAppDelegate *app =
                (DCAAppDelegate *)[[UIApplication sharedApplication] delegate];
            NSError *error = nil;
            DCContentBodyInfo *info =
                [app.photoColle getContentBodyInfoWithFileType:DCFILETYPE_IMAGE
                                                   contentGUID:self.guid
                                                    resizeType:DCRESIZETYPE_ORIGINAL
                                                         error:&error];
            if (error != nil) {
                [DCAMiscUtils showErrorDialogOnMainThreadWithError:error];
            } else {
                [info.inputStream open];
                NSData *data = [DCAMiscUtils toDataFromStream:info.inputStream];
                [info.inputStream close];
                UIImage *image = [UIImage imageWithData:data];
                [self.imageView performSelectorOnMainThread:@selector(setImage:)
                                                 withObject:image
                                              waitUntilDone:YES];
            }
            [self performSelectorOnMainThread:@selector(hideIndicator)
                                   withObject:nil
                                waitUntilDone:YES];
        }
    }
}

- (void)showIndicator
{
    if (self.indicator == nil) {
        self.indicator = [DCAMiscUtils createIndicator];
        self.indicator.center = self.view.center;
    }
    [self.view addSubview:self.indicator];
    [self.indicator startAnimating];
}

- (void)hideIndicator
{
    [self.indicator stopAnimating];
    [self.indicator removeFromSuperview];
}

@end
