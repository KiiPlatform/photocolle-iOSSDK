#import <PhotoColleSDK/DCPhotoColleSDK.h>

#import "DCACapacityViewController.h"

#import "DCAAppDelegate.h"
#import "DCAMiscUtils.h"

@interface DCACapacityViewController ()

@property (nonatomic, readwrite, weak) UIActivityIndicatorView *indicator;

- (void)load;
- (void)showCapacity;
- (void)showIndicator;
- (void)hideIndicator;
@end

@implementation DCACapacityViewController

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
    [self performSelectorInBackground:@selector(showCapacity) withObject:nil];
}

- (void)showCapacity
{
    @synchronized (self) {
        @autoreleasepool {
            DCAAppDelegate *app =
                (DCAAppDelegate *)[[UIApplication sharedApplication] delegate];
            NSError *error = nil;
            DCCapacityInfo *info = [app.photoColle getCapacityInfoWithError:&error];
            if (error != nil) {
                [DCAMiscUtils showErrorDialogOnMainThreadWithError:error];
            } else {
                [self.textView performSelectorOnMainThread:@selector(setText:)
                                                withObject:[[self class] toJSON:info]
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

+ (NSString *)toJSON:(DCCapacityInfo *)info
{
    NSDictionary *json = [NSDictionary dictionaryWithObjectsAndKeys:
            [NSNumber numberWithLongLong:info.maxSpace], @"maxSpace",
            [NSNumber numberWithLongLong:info.freeSpace], @"freeSpace", nil];
    NSData *data =
        [NSJSONSerialization dataWithJSONObject:json
                                        options:NSJSONWritingPrettyPrinted
                                          error:nil];
    return [[NSString alloc] initWithData:data
                                 encoding:NSUTF8StringEncoding];
}

@end
