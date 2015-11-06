#import "DCADetailedContentListViewController.h"
#import "DCADetailedContentInfoListProvider.h"
#import "DCAContentViewController.h"

@interface DCADetailedContentListViewController ()

@end

@implementation DCADetailedContentListViewController

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
    if ([identifier isEqualToString:@"showItem"] != NO) {
        DCAContentViewController *controller =
            [segue destinationViewController];
        controller.title = @"Content Info";
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        controller.provider = [self.provider objectAtIndex:indexPath.row];
    }
}

- (void)compose:(id)sender
{
    [self performSegueWithIdentifier:@"Setting" sender:self];
}

@end
