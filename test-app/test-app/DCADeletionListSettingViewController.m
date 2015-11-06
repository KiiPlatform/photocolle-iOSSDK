#import "DCADeletionListSettingViewController.h"
#import "DCAAppDelegate.h"
#import "DCATagListArguments.h"
#import "DCADeletionListArguments.h"

@interface DCADeletionListSettingViewController ()

@end

@implementation DCADeletionListSettingViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Custom initialization
    DCAAppDelegate *app = (DCAAppDelegate *)[[UIApplication sharedApplication] delegate];
    NSDate *minDateDeleted = app.deletionListArguments.minDateDeleted;
    NSDate *dateValue = (minDateDeleted != nil) ? minDateDeleted : [NSDate date];
    NSString *maxResults = (app.deletionListArguments.maxResults != nil) ?
        [app.deletionListArguments.maxResults stringValue] : @"";
    NSString *start = (app.deletionListArguments.start != nil) ?
        [app.deletionListArguments.start stringValue] : @"";

    // setup our data source
    NSMutableDictionary *item1 = [@{ kTitleKey : @"fileType",
                                     kValueKey : [NSNumber numberWithInt:app.deletionListArguments.fileType],
                                     kTypeKey  : [NSNumber numberWithInt:kTypeFileTypeWithOutAllPicker] }
                                  mutableCopy];
    NSMutableDictionary *item2 = [@{ kTitleKey : @"minDateDeleted as nil",
                                     kValueKey : [NSNumber numberWithBool:(minDateDeleted == nil)],
                                     kTypeKey  : [NSNumber numberWithInt:kTypeBool] }
                                  mutableCopy];
    NSMutableDictionary *item3 = [@{ kTitleKey : @"minDateDeleted",
                                     kValueKey : dateValue,
                                     kTypeKey  : [NSNumber numberWithInt:kTypeDate] }
                                  mutableCopy];
    NSMutableDictionary *item4 = [@{ kTitleKey : @"maxResults",
                                     kValueKey : maxResults,
                                     kTypeKey  : [NSNumber numberWithInt:kTypeNumber] }
                                  mutableCopy];
    NSMutableDictionary *item5 = [@{ kTitleKey : @"start",
                                     kValueKey : start,
                                     kTypeKey  : [NSNumber numberWithInt:kTypeNumber] }
                                  mutableCopy];

    self.dataArray = @[item1, item2, item3, item4, item5];
}

- (void)viewWillDisappear:(BOOL)animated
{
    int fileType = [[self.dataArray[0] valueForKey:kValueKey] intValue];
    BOOL isNil = [[self.dataArray[1] valueForKey:kValueKey] boolValue];
    NSDate *minDateDeleted = [self.dataArray[2] valueForKey:kValueKey];
    NSString *maxResultsStr = [self.dataArray[3] valueForKey:kValueKey];
    NSString *startStr = [self.dataArray[4] valueForKey:kValueKey];
    NSNumber *maxResults = nil;
    NSNumber *start = nil;

    if (maxResultsStr.length > 0) {
        maxResults = [NSNumber numberWithInt:[maxResultsStr intValue]];
    }

    if (startStr.length > 0) {
        start = [NSNumber numberWithInt:[startStr intValue]];
    }

    DCAAppDelegate *app = (DCAAppDelegate *)[[UIApplication sharedApplication] delegate];
    app.deletionListArguments.fileType = fileType;
    app.deletionListArguments.minDateDeleted = (isNil ? nil : minDateDeleted);
    app.deletionListArguments.maxResults = maxResults;
    app.deletionListArguments.start = start;

    [super viewWillDisappear:animated];
}

@end
