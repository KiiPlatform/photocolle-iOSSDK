#import <photocolle_iOSSDK/DCPhotoColleSDK.h>

#import "DCAContentListSettingViewController.h"

#import "DCAAppDelegate.h"
#import "DCAContentInfoListArguments.h"

@interface DCAContentListSettingViewController ()

@end

@implementation DCAContentListSettingViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Custom initialization
    DCAAppDelegate *app = (DCAAppDelegate *)[[UIApplication sharedApplication] delegate];
    id dateFilter = app.contentInfoListArguments.dateFilter;
    NSDate *dateValue = (dateFilter != nil) ? [dateFilter getDate] : [NSDate date];
    NSString *maxResults = (app.contentInfoListArguments.maxResults != nil) ?
        [app.contentInfoListArguments.maxResults stringValue] : @"";
    NSString *start = (app.contentInfoListArguments.start != nil) ?
        [app.contentInfoListArguments.start stringValue] : @"";
    kDateFilterType filterType = kFilterIsNil;
    if (dateFilter != nil) {
        if ([dateFilter isMemberOfClass:[DCUploadDateFilter class]]) {
            filterType = kFilterIsUpload;
        } else {
            filterType = kFilterIsModified;
        }
    }

    // setup our data source
    NSMutableDictionary *item1 = [@{ kTitleKey : @"fileType",
                                     kValueKey : [NSNumber numberWithInt:app.contentInfoListArguments.fileType],
                                     kTypeKey  : [NSNumber numberWithInt:kTypeFileTypeWithOutAllPicker] }
                                  mutableCopy];
    NSMutableDictionary *item2 = [@{ kTitleKey : @"forDustbox",
                                     kValueKey : [NSNumber numberWithBool:app.contentInfoListArguments.forDustbox],
                                     kTypeKey  : [NSNumber numberWithInt:kTypeBool] }
                                  mutableCopy];
    NSMutableDictionary *item3 = [@{ kTitleKey : @"dateFilter type",
                                     kValueKey : [NSNumber numberWithInt:filterType],
                                     kTypeKey  : [NSNumber numberWithInt:kTypeDateFilterPicker] }
                                  mutableCopy];
    NSMutableDictionary *item4 = [@{ kTitleKey : @"dateFilter",
                                     kValueKey : dateValue,
                                     kTypeKey  : [NSNumber numberWithInt:kTypeDate] }
                                  mutableCopy];
    NSMutableDictionary *item5 = [@{ kTitleKey : @"maxResults",
                                     kValueKey : maxResults,
                                     kTypeKey  : [NSNumber numberWithInt:kTypeNumber] }
                                  mutableCopy];
    NSMutableDictionary *item6 = [@{ kTitleKey : @"start",
                                     kValueKey : start,
                                     kTypeKey  : [NSNumber numberWithInt:kTypeNumber] }
                                  mutableCopy];
    NSMutableDictionary *item7 = [@{ kTitleKey : @"sortType",
                                     kValueKey : [NSNumber numberWithInt:app.contentInfoListArguments.sortType],
                                     kTypeKey  : [NSNumber numberWithInt:kTypeSortTypeWithOutScoreDescPicker] }
                                  mutableCopy];

    self.dataArray = @[item1, item2, item3, item4, item5, item6, item7];
}

- (void)viewWillDisappear:(BOOL)animated
{
    int fileType = [[self.dataArray[0] valueForKey:kValueKey] intValue];
    BOOL forDustbox = [[self.dataArray[1] valueForKey:kValueKey] boolValue];
    kDateFilterType filterType = [[self.dataArray[2] valueForKey:kValueKey] intValue];
    NSDate *dateFilterValue = [self.dataArray[3] valueForKey:kValueKey];
    NSString *maxResultsStr = [self.dataArray[4] valueForKey:kValueKey];
    NSString *startStr = [self.dataArray[5] valueForKey:kValueKey];
    DCSortType sortType = [[self.dataArray[6] valueForKey:kValueKey] intValue];

    id<DCDateFiltering> dateFilter = nil;
    switch (filterType) {
        case kFilterIsUpload:
            dateFilter = [[DCUploadDateFilter alloc] initWithDate:dateFilterValue];
            break;
        case kFilterIsModified:
            dateFilter = [[DCModifiedDateFilter alloc] initWithDate:dateFilterValue];
            break;
        case kFilterIsNil:
        default:
            break;
    }

    NSNumber *maxResults = nil;
    NSNumber *start = nil;
    if (maxResultsStr.length > 0) {
        maxResults = [NSNumber numberWithInt:[maxResultsStr intValue]];
    }
    if (startStr.length > 0) {
        start = [NSNumber numberWithInt:[startStr intValue]];
    }

    DCAAppDelegate *app = (DCAAppDelegate *)[[UIApplication sharedApplication] delegate];
    app.contentInfoListArguments.fileType = fileType;
    app.contentInfoListArguments.forDustbox = forDustbox;
    app.contentInfoListArguments.dateFilter = dateFilter;
    app.contentInfoListArguments.maxResults = maxResults;
    app.contentInfoListArguments.start = start;
    app.contentInfoListArguments.sortType = sortType;

    [super viewWillDisappear:animated];
}

@end
