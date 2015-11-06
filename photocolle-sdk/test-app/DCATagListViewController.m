#import "DCATagListViewController.h"
#import "DCATagViewController.h"
#import "DCADataListProviding.h"

@interface DCATagListViewController ()

@end

@implementation DCATagListViewController

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
    if ([identifier isEqualToString:@"showTag"] != NO) {
        DCATagViewController *controller = [segue destinationViewController];
        controller.title = @"Tag";
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        controller.provider = [self.provider objectAtIndex:indexPath.row];
    }
}

- (void)compose:(id)sender
{
    [self performSegueWithIdentifier:@"Setting" sender:self];
}

@end
