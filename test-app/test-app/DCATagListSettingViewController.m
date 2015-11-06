#import "DCATagListSettingViewController.h"
#import "DCAAppDelegate.h"
#import "DCATagListArguments.h"

@interface DCATagListSettingViewController ()

@end

@implementation DCATagListSettingViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Custom initialization
    DCAAppDelegate *app = (DCAAppDelegate *)[[UIApplication sharedApplication] delegate];
    NSDate *minDateModified = app.tagListArguments.minDateModified;
    NSDate *dateValue = (minDateModified != nil) ? minDateModified : [NSDate date];

    // setup our data source
    NSMutableDictionary *item1 = [@{ kTitleKey : @"category",
                                     kValueKey : [NSNumber numberWithInt:app.tagListArguments.category],
                                     kTypeKey  : [NSNumber numberWithInt:kTypeCategoryPicker] }
                                  mutableCopy];
    NSMutableDictionary *item2 = [@{ kTitleKey : @"fileType",
                                     kValueKey : [NSNumber numberWithInt:app.tagListArguments.fileType],
                                     kTypeKey  : [NSNumber numberWithInt:kTypeFileTypePicker] }
                                  mutableCopy];
    NSMutableDictionary *item3 = [@{ kTitleKey : @"minDateModified as nil",
                                     kValueKey : [NSNumber numberWithBool:(minDateModified == nil)],
                                     kTypeKey  : [NSNumber numberWithInt:kTypeBool] }
                                  mutableCopy];
    NSMutableDictionary *item4 = [@{ kTitleKey : @"minDateModified",
                                     kValueKey : dateValue,
                                     kTypeKey  : [NSNumber numberWithInt:kTypeDate] }
                                  mutableCopy];
    self.dataArray = @[item1, item2, item3, item4];
}

- (void)viewWillDisappear:(BOOL)animated
{
    int category = [[self.dataArray[0] valueForKey:kValueKey] intValue];
    int fileType = [[self.dataArray[1] valueForKey:kValueKey] intValue];
    BOOL isNil = [[self.dataArray[2] valueForKey:kValueKey] boolValue];
    NSDate *minDateModified = [self.dataArray[3] valueForKey:kValueKey];

    DCAAppDelegate *app = (DCAAppDelegate *)[[UIApplication sharedApplication] delegate];
    app.tagListArguments.category = category;
    app.tagListArguments.fileType = fileType;
    app.tagListArguments.minDateModified = (isNil ? nil : minDateModified);

    [super viewWillDisappear:animated];
}

@end
