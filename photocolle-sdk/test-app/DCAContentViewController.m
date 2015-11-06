#import "DCAContentViewController.h"
#import "DCADataProviding.h"
#import "DCAImageViewController.h"
#import "DCAThumbnailViewController.h"

@interface DCAContentViewController ()

@end

@implementation DCAContentViewController

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
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSString *identifier = [segue identifier];
    if ([identifier isEqualToString:@"showImage"] != NO) {
        DCAImageViewController *controller = [segue destinationViewController];
        controller.title = @"Image";
        controller.guid = [self.provider id];
    } else if ([identifier isEqualToString:@"showThumbnail"] != NO) {
        DCAThumbnailViewController *controller = [segue destinationViewController];
        controller.title = @"Thumbnail";
        controller.guid = [self.provider id];
    }

}


@end
