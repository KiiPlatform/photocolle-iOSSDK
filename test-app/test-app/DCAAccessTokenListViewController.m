#import <PhotoColleSDK/DCPhotoColleSDK.h>

#import "DCAAccessTokenListViewController.h"

#import "DCAAccessTokenEditViewController.h"

@interface DCAAccessTokenListViewController ()
@property (nonatomic, readwrite, strong) NSMutableArray *list;
@property (nonatomic, readwrite, strong) NSString *targetStoreKey;
@end

@implementation DCAAccessTokenListViewController

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

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    UIBarButtonItem *composeButton = [[UIBarButtonItem alloc]
                                      initWithBarButtonSystemItem:UIBarButtonSystemItemTrash
                                      target:self
                                      action:@selector(trash:)];
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:composeButton, nil];

    [self updateList];
}

- (void)updateList
{
    self.list = [NSMutableArray array];

    NSMutableDictionary *query = [NSMutableDictionary dictionary];
    [query setObject:(__bridge id)(kSecClassGenericPassword) forKey:(__bridge id)kSecClass];
    [query setObject:(__bridge id)(kCFBooleanTrue) forKey:(__bridge id)kSecReturnAttributes];
    [query setObject:(__bridge id)(kSecMatchLimitAll) forKey:(__bridge id)kSecMatchLimit];

    CFArrayRef result = nil;
    OSStatus err = SecItemCopyMatching((__bridge CFDictionaryRef)query, (CFTypeRef *)&result);

    if (err == noErr) {
        NSArray *array = (__bridge NSArray *)result;
        for (int i = 0; i < array.count; ++i) {
            NSDictionary *dict = [array objectAtIndex:i];
            NSString *svce = [dict valueForKey:(__bridge id)(kSecAttrService)];
            if ([svce hasPrefix:@"DCAAuthKey"] == NO && [svce hasSuffix:@"-docomo"] == YES) {
                [self.list addObject:[svce stringByReplacingOccurrencesOfString:@"-docomo"
                                                                     withString:@""]];
            }
        }
    }
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"
                                                            forIndexPath:indexPath];
    cell.textLabel.text = [self.list objectAtIndex:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.targetStoreKey = [self.list objectAtIndex:indexPath.row];

    [self performSegueWithIdentifier:@"Edit" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSString *identifier = [segue identifier];
    if ([identifier isEqualToString:@"Edit"] != NO) {
        DCAAccessTokenEditViewController *controller =
            [segue destinationViewController];
        controller.storeKey = self.targetStoreKey;
    }
}

- (void)trash:(id)sender
{
    [DCAuthenticationContext removeAllWithError:nil];

    [self updateList];
    [self updateViewConstraints];
}

@end
