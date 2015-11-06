#import <PhotoColleSDK/DCPhotoColleSDK.h>

#import "DCADetailedContentListSettingViewController.h"

#import "DCAAppDelegate.h"
#import "DCADetailedContentInfoListArguments.h"

@interface DCADetailedContentListSettingViewController ()

@end

@implementation DCADetailedContentListSettingViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Custom initialization
    DCAAppDelegate *app = (DCAAppDelegate *)[[UIApplication sharedApplication] delegate];
    id dateFilter = app.detailedContentInfoListArguments.dateFilter;
    NSDate *dateValue = (dateFilter != nil) ? [dateFilter getDate] : [NSDate date];
    NSString *maxResults = (app.detailedContentInfoListArguments.maxResults != nil) ?
    [app.detailedContentInfoListArguments.maxResults stringValue] : @"";
    NSString *start = (app.detailedContentInfoListArguments.start != nil) ?
    [app.detailedContentInfoListArguments.start stringValue] : @"";
    kDateFilterType filterType = kFilterIsNil;
    if (dateFilter != nil) {
        if ([dateFilter isMemberOfClass:[DCUploadDateFilter class]]) {
            filterType = kFilterIsUpload;
        } else {
            filterType = kFilterIsModified;
        }
    }
    
    // setup our data source
    NSMutableDictionary *item1 = [@{ kTitleKey : @"projectionType",
                                     kValueKey : [NSNumber numberWithInt:app.detailedContentInfoListArguments.projectionType],
                                     kTypeKey  : [NSNumber numberWithInt:kTypeProjectionTypePicker] }
                                  mutableCopy];
    NSMutableDictionary *item2 = [@{ kTitleKey : @"fileType",
                                     kValueKey : [NSNumber numberWithInt:app.detailedContentInfoListArguments.fileType],
                                     kTypeKey  : [NSNumber numberWithInt:kTypeFileTypePicker] }
                                  mutableCopy];
    NSMutableDictionary *item3 = [@{ kTitleKey : @"forDustbox",
                                     kValueKey : [NSNumber numberWithBool:app.detailedContentInfoListArguments.forDustbox],
                                     kTypeKey  : [NSNumber numberWithInt:kTypeBool] }
                                  mutableCopy];
    NSMutableDictionary *item4 = [@{ kTitleKey : @"dateFilter type",
                                     kValueKey : [NSNumber numberWithInt:filterType],
                                     kTypeKey  : [NSNumber numberWithInt:kTypeDateFilterPicker] }
                                  mutableCopy];
    NSMutableDictionary *item5 = [@{ kTitleKey : @"dateFilter",
                                     kValueKey : dateValue,
                                     kTypeKey  : [NSNumber numberWithInt:kTypeDate] }
                                  mutableCopy];
    NSMutableDictionary *item6 = [@{ kTitleKey : @"maxResults",
                                     kValueKey : maxResults,
                                     kTypeKey  : [NSNumber numberWithInt:kTypeNumber] }
                                  mutableCopy];
    NSMutableDictionary *item7 = [@{ kTitleKey : @"start",
                                     kValueKey : start,
                                     kTypeKey  : [NSNumber numberWithInt:kTypeNumber] }
                                  mutableCopy];
    NSMutableDictionary *item8 = [@{ kTitleKey : @"sortType",
                                     kValueKey : [NSNumber numberWithInt:app.detailedContentInfoListArguments.sortType],
                                     kTypeKey  : [NSNumber numberWithInt:kTypeSortTypePicker] }
                                  mutableCopy];
    
    self.dataArray = @[item1, item2, item3, item4, item5, item6, item7, item8];
}

- (void)viewWillDisappear:(BOOL)animated
{
    int projectionType = [[self.dataArray[0] valueForKey:kValueKey] intValue];
    int fileType = [[self.dataArray[1] valueForKey:kValueKey] intValue];
    BOOL forDustbox = [[self.dataArray[2] valueForKey:kValueKey] boolValue];
    kDateFilterType filterType = [[self.dataArray[3] valueForKey:kValueKey] intValue];
    NSDate *dateFilterValue = [self.dataArray[4] valueForKey:kValueKey];
    NSString *maxResultsStr = [self.dataArray[5] valueForKey:kValueKey];
    NSString *startStr = [self.dataArray[6] valueForKey:kValueKey];
    DCSortType sortType = [[self.dataArray[7] valueForKey:kValueKey] intValue];
    
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
    app.detailedContentInfoListArguments.projectionType = projectionType;
    app.detailedContentInfoListArguments.fileType = fileType;
    app.detailedContentInfoListArguments.forDustbox = forDustbox;
    app.detailedContentInfoListArguments.dateFilter = dateFilter;
    app.detailedContentInfoListArguments.maxResults = maxResults;
    app.detailedContentInfoListArguments.start = start;
    app.detailedContentInfoListArguments.sortType = sortType;
    
    [super viewWillDisappear:animated];
}

@end
