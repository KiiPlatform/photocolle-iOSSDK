#import "DCAEntryPointSettingViewController.h"
#import "DCAAppDelegate.h"

#import "DCScope.h"

@interface DCAEntryPointSettingViewController ()

@property (nonatomic, readwrite) NSArray *labels;

@end

@implementation DCAEntryPointSettingViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.labels = @[
            [DCScope photoGetContentsList],
            [DCScope photoGetContent],
            [DCScope photoUploadContent],
            [DCScope photoGetVacantSize],
            [DCScope photoUpdateRotateInfo],
            [DCScope photoUpdateTrashInfo],
            [DCScope photoGetGroupInfo],
            [DCScope phonebookAllowedFriendsBidirectional],
            [DCScope phonebookPostFeed],
            [DCScope phonebookAddContact],
            [DCScope databoxAll],
            [DCScope userid] ];

    DCAAppDelegate *app = (DCAAppDelegate *)[[UIApplication sharedApplication] delegate];

    NSMutableArray *items = [NSMutableArray array];

    for (NSString *label in self.labels) {
        NSNumber *value = [NSNumber numberWithInt:[app.scopes containsObject:label]];
        NSMutableDictionary *item = [@{ kTitleKey : label,
                                         kValueKey : value,
                                         kTypeKey  : [NSNumber numberWithInt:kTypeBool] }
                                      mutableCopy];
        [items addObject:item];
    }
    
    self.dataArray = [NSArray arrayWithArray:items];
}

- (void)viewWillDisappear:(BOOL)animated
{
    NSMutableArray *scopes = [NSMutableArray array];
    for (int i = 0; i < self.labels.count; ++i) {
        BOOL checked = [[self.dataArray[i] valueForKey:kValueKey] boolValue];
        if (checked != NO) {
            [scopes addObject:self.labels[i]];
        }
    }

    DCAAppDelegate *app = (DCAAppDelegate *)[[UIApplication sharedApplication] delegate];
    [app.scopes removeAllObjects];
    [app.scopes addObjectsFromArray:scopes];

    [super viewWillDisappear:animated];
}

@end
