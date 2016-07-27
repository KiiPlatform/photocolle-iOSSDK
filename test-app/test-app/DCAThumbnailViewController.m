#import <photocolle_iOSSDK/DCPhotoColleSDK.h>

#import "DCAThumbnailViewController.h"
#import "DCAAppDelegate.h"
#import "DCAMiscUtils.h"

@interface DCAThumbnailViewController ()

@property (nonatomic, readwrite, weak) UIActivityIndicatorView *indicator;

- (void)setThumbnail;
- (void)load;
- (void)showIndicator;
- (void)hideIndicator;
+ (NSString*)toJSON:(DCContentThumbnailInfo *)info;

@end

@implementation DCAThumbnailViewController

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
    [self performSelectorInBackground:@selector(setThumbnail) withObject:nil];
}

- (void)setThumbnail
{
    @autoreleasepool {
        DCAAppDelegate *app =
            (DCAAppDelegate *)[[UIApplication sharedApplication] delegate];
        NSError *error = nil;
        DCContentThumbnailInfoList *info =
            [app.photoColle getContentThumbnailInfoWithContentGUIDArray:[NSArray arrayWithObject:self.guid]
                                                                  error:&error];
        if (error != nil) {
            [DCAMiscUtils showErrorDialogOnMainThreadWithError:error];
        } else {
            NSString *content =
                [[self class] toJSON:[info.list objectAtIndex:0]];
            [self.textView performSelectorOnMainThread:@selector(setText:)
                                            withObject:content
                                         waitUntilDone:YES];
        }
        [self performSelectorOnMainThread:@selector(hideIndicator)
                               withObject:nil
                            waitUntilDone:YES];
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

+ (NSString*)toJSON:(DCContentThumbnailInfo *)info
{
    NSDictionary *json = [NSDictionary dictionaryWithObjectsAndKeys:
             info.guid.stringValue, @"guid",
             [NSNumber numberWithInt:info.mimeType], @"mimeType",
             [DCAMiscUtils encodeBase64FromData:info.thumbnailBytes],
             @"thumbnail",  nil];
    NSData *data =
        [NSJSONSerialization dataWithJSONObject:json
                                        options:NSJSONWritingPrettyPrinted
                                          error:nil];
    return [[NSString alloc] initWithData:data
                                 encoding:NSUTF8StringEncoding];
}

@end
