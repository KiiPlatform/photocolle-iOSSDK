#import <photocolle_iOSSDK/DCPhotoColleSDK.h>

#import "DCAListViewController.h"
#import "DCAAppDelegate.h"
#import "DCAMiscUtils.h"
#import "DCADataListProviding.h"
#import "DCADataProviding.h"

@interface DCAListViewController ()

@property (nonatomic, readwrite, weak) UIActivityIndicatorView *indicator;

- (void)refresh:(id)sender;
- (void)compose:(id)sender;
- (void)load;
- (void)showIndicator;
- (void)hideIndicator;
- (void)retrieveData;

@end

@implementation DCAListViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    UIBarButtonItem *refreshButton =
        [[UIBarButtonItem alloc]
           initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
                                target:self
                                action:@selector(refresh:)];
    UIBarButtonItem *composeButton = [[UIBarButtonItem alloc]
            initWithBarButtonSystemItem:UIBarButtonSystemItemCompose
                                 target:self
                                 action:@selector(compose:)];
    self.navigationItem.rightBarButtonItems =
        [NSArray arrayWithObjects:refreshButton, composeButton, nil];
     self.navigationItem.title = self.title;
     [self load];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return [self.provider count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell =
        [tableView dequeueReusableCellWithIdentifier:@"Cell"
                                        forIndexPath:indexPath];
    cell.textLabel.text = [[self.provider objectAtIndex:indexPath.row] label];
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     */
}

- (void)refresh:(id)sender
{
    [self load];
}

- (void)compose:(id)sender
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Attention"
                                                    message:@"Setting is unsupported in this."
                                                   delegate:nil
                                          cancelButtonTitle:nil
                                          otherButtonTitles:@"OK", nil];
    [alert show];
}

- (void)load
{
    [self showIndicator];
    [self performSelectorInBackground:@selector(retrieveData) withObject:nil];
}


- (void)retrieveData
{
    @synchronized (self) {
        @autoreleasepool {
            DCAAppDelegate *app =
                (DCAAppDelegate *)[[UIApplication sharedApplication] delegate];
            NSError *error = nil;
            [self.provider retrieveDataWithPhotoColle:app.photoColle
                                                error:&error];
            if (error != nil) {
                [DCAMiscUtils showErrorDialogOnMainThreadWithError:error];
            }
            [self.tableView performSelectorOnMainThread:@selector(reloadData)
                                             withObject:nil
                                          waitUntilDone:YES];

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
