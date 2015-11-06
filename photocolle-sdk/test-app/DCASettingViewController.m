#import "DCASettingViewController.h"
#import "DCEnumerations.h"
#import "DCAAppDelegate.h"
#import "DCATagListArguments.h"

#define EMBEDDED_PICKER (DeviceSystemMajorVersion() >= 7)

static float const kPickerAnimationDuration = 0.40;

static int const kPickerTag = 98;
static int const kDatePickerTag = 99;

static NSString * const kPropertyCellID = @"propertyCell";
static NSString * const kDatePickerCellID = @"datePickerCell";
static NSString * const kPickerCellID = @"pickerCell";

NSString * const kTitleKey = @"title";
NSString * const kValueKey = @"value";
NSString * const kTypeKey = @"type";

@interface DCASettingViewController ()

@property (nonatomic, strong) NSDateFormatter *dateFormatter;

@property (nonatomic, strong) NSIndexPath *pickerIndexPath;
@property (nonatomic) kDataType pickerType;

@property (assign) NSInteger pickerCellRowHeight;

@property (nonatomic, strong) IBOutlet UIDatePicker *datePickerView;

@property (nonatomic, strong) IBOutlet UIPickerView *pickerView;

@property (nonatomic, strong) NSIndexPath *alertIndexPath;

// this button appears only when the date picker is shown (iOS 6.1.x or earlier)
@property (nonatomic, strong) IBOutlet UIBarButtonItem *doneButton;

@end

@implementation DCASettingViewController

NSUInteger DeviceSystemMajorVersion()
{
    static NSUInteger _deviceSystemMajorVersion = -1;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _deviceSystemMajorVersion = [[[[[UIDevice currentDevice] systemVersion] componentsSeparatedByString:@"."] objectAtIndex:0] intValue];
    });

    return _deviceSystemMajorVersion;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.dateFormatter = [[NSDateFormatter alloc] init];
    [self.dateFormatter setDateStyle:NSDateFormatterShortStyle];
    [self.dateFormatter setTimeStyle:NSDateFormatterShortStyle];

    // obtain the picker view cell's height, works because the cell was pre-defined in our storyboard
    UITableViewCell *pickerViewCellToCheck =
    [self.tableView dequeueReusableCellWithIdentifier:kDatePickerCellID];
    self.pickerCellRowHeight = pickerViewCellToCheck.frame.size.height;

    self.pickerType = kTypeNone;

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(localeChanged:)
                                                 name:NSCurrentLocaleDidChangeNotification
                                               object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:NSCurrentLocaleDidChangeNotification
                                                  object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
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

#pragma mark - Picker view data source

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    int retval = 0;
    switch (self.pickerType) {
        case kTypeCategoryPicker:
            retval = 6;
            break;
        case kTypeFileTypePicker:
            retval = 4;
            break;
        case kTypeFileTypeWithOutAllPicker:
            retval = 3;
            break;
        case kTypeDateFilterPicker:
            retval = 3;
            break;
        case kTypeSortTypePicker:
            retval = 7;
            break;
        case kTypeSortTypeWithOutScoreDescPicker:
            retval = 6;
            break;
        case kTypeProjectionTypePicker:
            retval = 3;
            break;
        default:
            break;
    }
    return retval;
}

#pragma mark - Picker view delegate

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 50.0;
}

- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row
            forComponent:(NSInteger)component
{
    NSString *retval = @"Error";
    switch (self.pickerType) {
        case kTypeCategoryPicker:
            retval = [self getCategory:row];
            break;
        case kTypeFileTypePicker:
            retval = [self getFileType:row];
            break;
        case kTypeFileTypeWithOutAllPicker:
            retval = [self getFileType:(row + 1)];
            break;
        case kTypeDateFilterPicker:
            retval = [self getDateFilterType:row];
            break;
        case kTypeSortTypePicker:
        case kTypeSortTypeWithOutScoreDescPicker:
            retval = [self getSortType:row];
            break;
        case kTypeProjectionTypePicker:
            retval = [self getProjectionType:row];
            break;
        default:
            break;
    }
    return retval;
}

- (NSString *)getCategory:(int)num
{
    NSString *retval = nil;
    switch (num) {
        case 0:
            retval = @"ALL";
            break;
        case 1:
            retval = @"PERSON";
            break;
        case 2:
            retval = @"EVENT";
            break;
        case 3:
            retval = @"FAVORITE";
            break;
        case 4:
            retval = @"PLACEMENT";
            break;
        case 5:
            retval = @"YEAR_MONTH";
            break;
    }
    return retval;
}

- (NSString *)getFileType:(int)num
{
    NSString *retval = nil;
    switch (num) {
        case 0:
            retval = @"ALL";
            break;
        case 1:
            retval = @"IMAGE";
            break;
        case 2:
            retval = @"VIDEO";
            break;
        case 3:
            retval = @"SLIDE_MOVIE";
            break;
    }
    return retval;
}

- (NSString *)getDateFilterType:(int)num
{
    NSString *retval = nil;
    switch (num) {
        case 0:
            retval = @"Nil";
            break;
        case 1:
            retval = @"Upload";
            break;
        case 2:
            retval = @"Modified";
            break;
    }
    return retval;
}

- (NSString *)getSortType:(int)num
{
    NSString *retval = nil;
    switch (num) {
        case 0:
            retval = @"CREATION DESC";
            break;
        case 1:
            retval = @"CREATION ASC";
            break;
        case 2:
            retval = @"MODIFICATION DESC";
            break;
        case 3:
            retval = @"MODIFICATION ASC";
            break;
        case 4:
            retval = @"UPLOAD ASC";
            break;
        case 5:
            retval = @"UPLOAD DESC";
            break;
        case 6:
            retval = @"SCORE DESC";
            break;
    }
    return retval;
}

- (NSString *)getProjectionType:(int)num
{
    NSString *retval = nil;
    switch (num) {
        case 0:
            retval = @"File Count";
            break;
        case 1:
            retval = @"All Details";
            break;
        case 2:
            retval = @"Without Tags";
            break;
    }
    return retval;
}

- (void)pickerView:(UIPickerView *)pickerView
      didSelectRow:(NSInteger)row
       inComponent:(NSInteger)component
{
    int targetIndex;
    NSIndexPath *targetedCellIndexPath = nil;
    if ([self hasInlinePicker]) {
        targetedCellIndexPath = [NSIndexPath indexPathForRow:self.pickerIndexPath.row - 1 inSection:0];
        targetIndex = self.pickerIndexPath.row - 1;
    } else {
        targetedCellIndexPath = [self.tableView indexPathForSelectedRow];
        targetIndex = targetedCellIndexPath.row;
    }
    NSDictionary *itemData = self.dataArray[targetIndex];
    NSNumber *value = [self convertRow:row
                           toValueType:[[itemData valueForKey:kTypeKey] intValue]];
    [itemData setValue:value forKey:kValueKey];

    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:targetedCellIndexPath];

    switch (self.pickerType) {
        case kTypeCategoryPicker:
            cell.detailTextLabel.text = [self getCategory:row];
            break;
        case kTypeFileTypePicker:
            cell.detailTextLabel.text = [self getFileType:row];
            break;
        case kTypeFileTypeWithOutAllPicker:
            cell.detailTextLabel.text = [self getFileType:(row + 1)];
            break;
        case kTypeDateFilterPicker:
            cell.detailTextLabel.text = [self getDateFilterType:row];
            break;
        case kTypeSortTypePicker:
        case kTypeSortTypeWithOutScoreDescPicker:
            cell.detailTextLabel.text = [self getSortType:row];
            break;
        case kTypeProjectionTypePicker:
            cell.detailTextLabel.text = [self getProjectionType:row];
            break;
        default:
            break;
    }
}

- (NSNumber *)convertRow:(int)row toValueType:(kDataType)type
{
    NSNumber *retval = nil;
    switch (type) {
        case kTypeCategoryPicker:
            retval = [NSNumber numberWithInt:row];
            break;
        case kTypeFileTypePicker:
            retval = [NSNumber numberWithInt:row];
            break;
        case kTypeFileTypeWithOutAllPicker:
            retval = [NSNumber numberWithInt:(row + 1)];
            break;
        case kTypeDateFilterPicker:
            retval = [self toFilterType:row];
            break;
        case kTypeSortTypePicker:
        case kTypeSortTypeWithOutScoreDescPicker:
            retval = [self toSortType:row];
            break;
        case kTypeProjectionTypePicker:
            retval = [self toProjectionType:row];
            break;
        default:
            break;
    }
    return retval;
}

- (NSNumber *)toFilterType:(int)row
{
    NSNumber *retval = nil;
    switch (row) {
        case 0:
            retval = [NSNumber numberWithInt:kFilterIsNil];
            break;
        case 1:
            retval = [NSNumber numberWithInt:kFilterIsUpload];
            break;
        case 2:
            retval = [NSNumber numberWithInt:kFilterIsModified];
            break;
        default:
            break;
    }
    return retval;
}

- (NSNumber *)toSortType:(int)row
{
    NSNumber *retval = nil;
    switch (row) {
        case 0:
            retval = [NSNumber numberWithInt:DCSORTTYPE_CREATION_DATETIME_DESC];
            break;
        case 1:
            retval = [NSNumber numberWithInt:DCSORTTYPE_CREATION_DATETIME_ASC];
            break;
        case 2:
            retval = [NSNumber numberWithInt:DCSORTTYPE_MODIFICATION_DATETIME_DESC];
            break;
        case 3:
            retval = [NSNumber numberWithInt:DCSORTTYPE_MODIFICATION_DATETIME_ASC];
            break;
        case 4:
            retval = [NSNumber numberWithInt:DCSORTTYPE_UPLOAD_DATETIME_ASC];
            break;
        case 5:
            retval = [NSNumber numberWithInt:DCSORTTYPE_UPLOAD_DATETIME_DESC];
            break;
        case 6:
            retval = [NSNumber numberWithInt:DCSORTTYPE_SCORE_DESC];
            break;
        default:
            break;
    }
    return retval;
}

- (NSNumber *)toProjectionType:(int)row
{
    NSNumber *retval = nil;
    switch (row) {
        case 0:
            retval = [NSNumber numberWithInt:DCPROJECTIONTYPE_FILE_COUNT];
            break;
        case 1:
            retval = [NSNumber numberWithInt:DCPROJECTIONTYPE_ALL_DETAILS];
            break;
        case 2:
            retval = [NSNumber numberWithInt:DCPROJECTIONTYPE_DETAILS_WITHOUT_TAGS];
            break;
        default:
            break;
    }
    return retval;
}

- (void)localeChanged:(NSNotification *)notif
{
    // the user changed the locale (region format) in Settings,
    // so we are notified here to update the date format in the table view cells.
    [self.tableView reloadData];
}

- (BOOL)hasPickerForIndexPath:(NSIndexPath *)indexPath
{
    BOOL hasDatePicker = NO;

    NSInteger targetedRow = indexPath.row;
    targetedRow++;

    UITableViewCell *checkDatePickerCell =
    [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:targetedRow inSection:0]];
    UIDatePicker *checkDatePicker = (UIDatePicker *)[checkDatePickerCell viewWithTag:kDatePickerTag];

    hasDatePicker = (checkDatePicker != nil);
    return hasDatePicker;
}

- (void)updatePicker
{
    if (self.pickerIndexPath != nil) {
        UITableViewCell *associatedPickerCell =
            [self.tableView cellForRowAtIndexPath:self.pickerIndexPath];
        switch (self.pickerType) {
            case kTypeDate:
            {
                UIDatePicker *targetedDatePicker =
                    (UIDatePicker *)[associatedPickerCell viewWithTag:kDatePickerTag];
                if (targetedDatePicker != nil) {
                    NSDictionary *itemData = self.dataArray[self.pickerIndexPath.row - 1];
                    [targetedDatePicker setDate:[itemData valueForKey:kValueKey]
                                       animated:NO];
                }
                break;
            }
            case kTypeCategoryPicker:
            case kTypeFileTypePicker:
            case kTypeDateFilterPicker:
            {
                UIPickerView *targetPicker =
                    (UIPickerView *)[associatedPickerCell viewWithTag:kPickerTag];
                if (targetPicker != nil) {
                    [targetPicker reloadAllComponents];
                    NSDictionary *itemData = self.dataArray[self.pickerIndexPath.row - 1];
                    [targetPicker selectRow:[[itemData valueForKey:kValueKey] intValue]
                                inComponent:0
                                   animated:NO];
                }
                break;
            }
            case kTypeFileTypeWithOutAllPicker:
            case kTypeSortTypePicker:
            case kTypeSortTypeWithOutScoreDescPicker:
            case kTypeProjectionTypePicker:
            {
                UIPickerView *targetPicker =
                (UIPickerView *)[associatedPickerCell viewWithTag:kPickerTag];
                if (targetPicker != nil) {
                    [targetPicker reloadAllComponents];
                    NSDictionary *itemData = self.dataArray[self.pickerIndexPath.row - 1];
                    [targetPicker selectRow:([[itemData valueForKey:kValueKey] intValue] - 1)
                                inComponent:0
                                   animated:NO];
                }
                break;
            }
            default:
                break;
        }
    }
}

/*! Determines if the UITableViewController has a UIDatePicker in any of its cells.
 */
- (BOOL)hasInlinePicker
{
    return (self.pickerIndexPath != nil);
}

- (BOOL)indexPathHasPicker:(NSIndexPath *)indexPath
{
    return ([self hasInlinePicker] && self.pickerIndexPath.row == indexPath.row);
}


#pragma mark - UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return ([self indexPathHasPicker:indexPath] ? self.pickerCellRowHeight : self.tableView.rowHeight);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger retval = self.dataArray.count;
    if ([self hasInlinePicker]) {
        // we have a date picker, so allow for it in the number of rows in this section.
        ++retval;
    }
    return retval;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;

    NSString *cellID = kPropertyCellID;

    if ([self indexPathHasPicker:indexPath]) {
        switch (self.pickerType) {
            case kTypeDate:
                cellID = kDatePickerCellID;
                break;
            case kTypeCategoryPicker:
            case kTypeFileTypePicker:
            case kTypeFileTypeWithOutAllPicker:
            case kTypeDateFilterPicker:
            case kTypeSortTypePicker:
            case kTypeSortTypeWithOutScoreDescPicker:
            case kTypeProjectionTypePicker:
                cellID = kPickerCellID;
                break;
            case kTypeBool:
            case kTypeNumber:
                // cellID is kPropertyCellID, no change.;
            default:
                break;
        }
    }

    cell = [tableView dequeueReusableCellWithIdentifier:cellID];

    if ([cellID isEqualToString:kDatePickerCellID] ||
        [cellID isEqualToString:kPickerCellID]) {
        return cell;
    }

    NSInteger modelRow = indexPath.row;
    if (self.pickerIndexPath != nil && self.pickerIndexPath.row < indexPath.row) {
        modelRow--;
    }
    NSDictionary *itemData = [self.dataArray objectAtIndex:modelRow];

    cell.textLabel.text = [itemData valueForKey:kTitleKey];
    switch ([[itemData valueForKey:kTypeKey] intValue]) {
        case kTypeDate:
            cell.detailTextLabel.text = [self.dateFormatter stringFromDate:[itemData valueForKey:kValueKey]];
            break;
        case kTypeCategoryPicker:
            cell.detailTextLabel.text = [self getCategory:[[itemData valueForKey:kValueKey] intValue]];
            break;
        case kTypeFileTypePicker:
        case kTypeFileTypeWithOutAllPicker:
            cell.detailTextLabel.text = [self getFileType:[[itemData valueForKey:kValueKey] intValue]];
            break;
        case kTypeBool:
        {
            cell.detailTextLabel.text = @"";
            if ([[itemData valueForKey:kValueKey] boolValue] != NO) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            } else {
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
        }
            break;
        case kTypeDateFilterPicker:
            cell.detailTextLabel.text = [self getDateFilterType:[[itemData valueForKey:kValueKey] intValue]];
            break;
        case kTypeSortTypePicker:
        case kTypeSortTypeWithOutScoreDescPicker:
            cell.detailTextLabel.text = [self getSortType:([[itemData valueForKey:kValueKey] intValue] - 1)];
            break;
        case kTypeProjectionTypePicker:
            cell.detailTextLabel.text =
                [self getProjectionType:([[itemData valueForKey:kValueKey] intValue] - 1)];
            break;
        case kTypeNumber:
        {
            NSString *v = [itemData valueForKey:kValueKey];
            cell.detailTextLabel.text = (v.length > 0) ? v : @"nil";
            break;
        }
        default:
            break;
    }
	return cell;
}

- (void)togglePickerForSelectedIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView beginUpdates];

    NSArray *indexPaths = @[[NSIndexPath indexPathForRow:indexPath.row + 1 inSection:0]];

    if ([self hasPickerForIndexPath:indexPath]) {
        [self.tableView deleteRowsAtIndexPaths:indexPaths
                              withRowAnimation:UITableViewRowAnimationFade];
    } else {
        [self.tableView insertRowsAtIndexPaths:indexPaths
                              withRowAnimation:UITableViewRowAnimationFade];
    }

    [self.tableView endUpdates];
}

- (void)displayInlinePickerForRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView beginUpdates];

    BOOL before = NO;
    if ([self hasInlinePicker]) {
        before = self.pickerIndexPath.row <= indexPath.row;
    }

    BOOL sameCellClicked = (self.pickerIndexPath.row - 1 == indexPath.row);

    if ([self hasInlinePicker]) {
        [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.pickerIndexPath.row
                                                                    inSection:0]]
                              withRowAnimation:UITableViewRowAnimationFade];
        self.pickerIndexPath = nil;
    }

    if (!sameCellClicked) {
        NSInteger rowToReveal = (before ? indexPath.row - 1 : indexPath.row);
        NSIndexPath *indexPathToReveal = [NSIndexPath indexPathForRow:rowToReveal inSection:0];

        [self togglePickerForSelectedIndexPath:indexPathToReveal];
        self.pickerIndexPath = [NSIndexPath indexPathForRow:indexPathToReveal.row + 1 inSection:0];
    }

    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];

    [self.tableView endUpdates];

    [self updatePicker];
}

- (void)displayExternalPicker:(UIView *)pickerView
                    indexPath:(NSIndexPath *)indexPath
{
    if (pickerView.superview == nil) {
        CGRect startFrame = pickerView.frame;
        CGRect endFrame = pickerView.frame;

        startFrame.origin.y = self.view.frame.size.height;

        endFrame.origin.y = startFrame.origin.y - endFrame.size.height;

        pickerView.frame = startFrame;

        [self.view addSubview:pickerView];

        [UIView animateWithDuration:kPickerAnimationDuration
                         animations:^{ pickerView.frame = endFrame; }
                         completion:^(BOOL finished) {
                             self.navigationItem.rightBarButtonItem = self.doneButton;
                         }];
    }
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    int row = indexPath.row;
    if ([self hasInlinePicker] && self.pickerIndexPath.row <= row) {
        --row;
    }
    NSDictionary *itemData = [self.dataArray objectAtIndex:row];

    if (EMBEDDED_PICKER) {
        [self selectRowByEmbeddedPickerAtTableView:tableView
                                         indexPath:indexPath
                                          itemData:itemData];
    } else {
        [self selectRowByExternalPickerAtTableView:tableView
                                         indexPath:indexPath
                                          itemData:itemData];
    }
}

- (void)selectRowByEmbeddedPickerAtTableView:(UITableView *)tableView
                                   indexPath:(NSIndexPath *)indexPath
                                    itemData:(NSDictionary *)itemData
{
    switch ([[itemData valueForKey:kTypeKey] intValue]) {
        case kTypeDate:
            self.pickerType = kTypeDate;
            [self displayInlinePickerForRowAtIndexPath:indexPath];
            break;
        case kTypeCategoryPicker:
            self.pickerType = kTypeCategoryPicker;
            [self displayInlinePickerForRowAtIndexPath:indexPath];
            break;
        case kTypeFileTypePicker:
            self.pickerType = kTypeFileTypePicker;
            [self displayInlinePickerForRowAtIndexPath:indexPath];
            break;
        case kTypeFileTypeWithOutAllPicker:
            self.pickerType = kTypeFileTypeWithOutAllPicker;
            [self displayInlinePickerForRowAtIndexPath:indexPath];
            break;
        case kTypeDateFilterPicker:
            self.pickerType = kTypeDateFilterPicker;
            [self displayInlinePickerForRowAtIndexPath:indexPath];
            break;
        case kTypeSortTypePicker:
            self.pickerType = kTypeSortTypePicker;
            [self displayInlinePickerForRowAtIndexPath:indexPath];
            break;
        case kTypeSortTypeWithOutScoreDescPicker:
            self.pickerType = kTypeSortTypeWithOutScoreDescPicker;
            [self displayInlinePickerForRowAtIndexPath:indexPath];
            break;
        case kTypeProjectionTypePicker:
            self.pickerType = kTypeProjectionTypePicker;
            [self displayInlinePickerForRowAtIndexPath:indexPath];
            break;
        case kTypeBool:
            self.pickerType = kTypeBool;
            [self updateBoolRowAtTableView:tableView
                                 indexPath:indexPath
                                  itemData:itemData];
            break;
        case kTypeNumber:
            self.pickerType = kTypeNumber;
            [self showNumberInputAlert:indexPath
                              itemData:itemData];
            break;
        default:
            break;
    }
}

- (void)selectRowByExternalPickerAtTableView:(UITableView *)tableView
                                   indexPath:(NSIndexPath *)indexPath
                                    itemData:(NSDictionary *)itemData
{
    switch ([[itemData valueForKey:kTypeKey] intValue]) {
        case kTypeDate:
            [self externalDatePickerAtTableView:tableView
                                      indexPath:indexPath
                                       itemData:itemData];
            break;
        case kTypeCategoryPicker:
            [self externalCategoryPickerAtTableView:tableView
                                          indexPath:indexPath
                                           itemData:itemData];
            break;
        case kTypeFileTypePicker:
        case kTypeFileTypeWithOutAllPicker:
            [self externalFileTypePickerAtTableView:tableView
                                          indexPath:indexPath
                                           itemData:itemData];
            break;
        case kTypeDateFilterPicker:
            [self externalDateFilterTypePickerAtTableView:tableView
                                                indexPath:indexPath
                                                 itemData:itemData];
            break;
        case kTypeSortTypePicker:
        case kTypeSortTypeWithOutScoreDescPicker:
            [self externalSortTypePickerAtTableView:tableView
                                          indexPath:indexPath
                                           itemData:itemData];
            break;
        case kTypeProjectionTypePicker:
            [self externalProjectionTypePickerAtTableView:tableView
                                                indexPath:indexPath
                                                 itemData:itemData];
            break;
        case kTypeBool:
            [self externalBoolAtTableView:tableView
                                indexPath:indexPath
                                 itemData:itemData];
            break;
        case kTypeNumber:
            [self externalNumberAtIndexPath:indexPath
                                   itemData:itemData];
            break;
        default:
            break;
    }
}

- (void)externalDatePickerAtTableView:(UITableView *)tableView
                            indexPath:(NSIndexPath *)indexPath
                             itemData:(NSDictionary *)itemData
{
    int before = self.pickerType;
    switch (before) {
        case kTypeCategoryPicker:
        case kTypeFileTypePicker:
        case kTypeFileTypeWithOutAllPicker:
        case kTypeDateFilterPicker:
        case kTypeSortTypePicker:
        case kTypeSortTypeWithOutScoreDescPicker:
        case kTypeProjectionTypePicker:
            self.pickerType = kTypeNone;
            [self closePicker:self.pickerView];
            break;
        default:
            self.pickerType = kTypeDate;
            [self.datePickerView setDate:[itemData valueForKey:kValueKey]
                                animated:YES];
            [self displayExternalPicker:self.datePickerView
                              indexPath:indexPath];
            break;
    }
}

- (void)externalCategoryPickerAtTableView:(UITableView *)tableView
                                indexPath:(NSIndexPath *)indexPath
                                 itemData:(NSDictionary *)itemData
{
    int before = self.pickerType;
    switch (before) {
        case kTypeDate:
            self.pickerType = kTypeNone;
            [self closePicker:self.datePickerView];
            break;
        case kTypeFileTypePicker:
        case kTypeFileTypeWithOutAllPicker:
        case kTypeDateFilterPicker:
        case kTypeSortTypePicker:
        case kTypeSortTypeWithOutScoreDescPicker:
        case kTypeProjectionTypePicker:
            self.pickerType = kTypeNone;
            [self closePicker:self.pickerView];
            break;
        default:
            self.pickerType = kTypeCategoryPicker;
            [self.pickerView reloadAllComponents];
            [self.pickerView selectRow:[[itemData valueForKey:kValueKey] intValue]
                           inComponent:0
                              animated:NO];
            [self displayExternalPicker:self.pickerView
                              indexPath:indexPath];
            break;
    }
}

- (void)externalFileTypePickerAtTableView:(UITableView *)tableView
                                indexPath:(NSIndexPath *)indexPath
                                 itemData:(NSDictionary *)itemData
{
    int before = self.pickerType;
    switch (before) {
        case kTypeDate:
            self.pickerType = kTypeNone;
            [self closePicker:self.datePickerView];
            break;
        case kTypeCategoryPicker:
        case kTypeDateFilterPicker:
        case kTypeSortTypePicker:
        case kTypeSortTypeWithOutScoreDescPicker:
        case kTypeProjectionTypePicker:
            self.pickerType = kTypeNone;
            [self closePicker:self.pickerView];
            break;
        default:
        {
            self.pickerType = [[itemData valueForKey:kTypeKey] intValue];
            int row = [[itemData valueForKey:kValueKey] intValue];
            if (self.pickerType == kTypeFileTypeWithOutAllPicker) {
                --row;
            }
            [self.pickerView reloadAllComponents];
            [self.pickerView selectRow:row
                           inComponent:0
                              animated:NO];
            [self displayExternalPicker:self.pickerView
                              indexPath:indexPath];
            break;
        }
    }
}

- (void)externalDateFilterTypePickerAtTableView:(UITableView *)tableView
                                      indexPath:(NSIndexPath *)indexPath
                                       itemData:(NSDictionary *)itemData
{
    int before = self.pickerType;
    switch (before) {
        case kTypeDate:
            self.pickerType = kTypeNone;
            [self closePicker:self.datePickerView];
            break;
        case kTypeCategoryPicker:
        case kTypeFileTypePicker:
        case kTypeFileTypeWithOutAllPicker:
        case kTypeSortTypePicker:
        case kTypeSortTypeWithOutScoreDescPicker:
        case kTypeProjectionTypePicker:
            self.pickerType = kTypeNone;
            [self closePicker:self.pickerView];
            break;
        default:
        {
            self.pickerType = kTypeDateFilterPicker;
            int row = [[itemData valueForKey:kValueKey] intValue];
            [self.pickerView reloadAllComponents];
            [self.pickerView selectRow:row
                           inComponent:0
                              animated:NO];
            [self displayExternalPicker:self.pickerView
                              indexPath:indexPath];
            break;
        }
    }
}

- (void)externalSortTypePickerAtTableView:(UITableView *)tableView
                                indexPath:(NSIndexPath *)indexPath
                                 itemData:(NSDictionary *)itemData
{
    int before = self.pickerType;
    switch (before) {
        case kTypeDate:
            self.pickerType = kTypeNone;
            [self closePicker:self.datePickerView];
            break;
        case kTypeCategoryPicker:
        case kTypeFileTypePicker:
        case kTypeFileTypeWithOutAllPicker:
        case kTypeDateFilterPicker:
        case kTypeProjectionTypePicker:
            self.pickerType = kTypeNone;
            [self closePicker:self.pickerView];
            break;
        default:
        {
            self.pickerType = [[itemData valueForKey:kTypeKey] intValue];
            int row = [[itemData valueForKey:kValueKey] intValue] - 1;
            [self.pickerView reloadAllComponents];
            [self.pickerView selectRow:row
                           inComponent:0
                              animated:NO];
            [self displayExternalPicker:self.pickerView
                              indexPath:indexPath];
            break;
        }
    }
}

- (void)externalProjectionTypePickerAtTableView:(UITableView *)tableView
                                      indexPath:(NSIndexPath *)indexPath
                                       itemData:(NSDictionary *)itemData
{
    int before = self.pickerType;
    switch (before) {
        case kTypeDate:
            self.pickerType = kTypeNone;
            [self closePicker:self.datePickerView];
            break;
        case kTypeCategoryPicker:
        case kTypeFileTypePicker:
        case kTypeFileTypeWithOutAllPicker:
        case kTypeDateFilterPicker:
        case kTypeSortTypePicker:
        case kTypeSortTypeWithOutScoreDescPicker:
            self.pickerType = kTypeNone;
            [self closePicker:self.pickerView];
            break;
        default:
        {
            self.pickerType = kTypeProjectionTypePicker;
            int row = [[itemData valueForKey:kValueKey] intValue] - 1;
            [self.pickerView reloadAllComponents];
            [self.pickerView selectRow:row
                           inComponent:0
                              animated:NO];
            [self displayExternalPicker:self.pickerView
                              indexPath:indexPath];
            break;
        }
    }
}

- (void)externalBoolAtTableView:(UITableView *)tableView
                      indexPath:(NSIndexPath *)indexPath
                       itemData:(NSDictionary *)itemData
{
    int before = self.pickerType;
    self.pickerType = kTypeBool;
    switch (before) {
        case kTypeCategoryPicker:
        case kTypeFileTypePicker:
        case kTypeFileTypeWithOutAllPicker:
        case kTypeDateFilterPicker:
        case kTypeSortTypePicker:
        case kTypeSortTypeWithOutScoreDescPicker:
        case kTypeProjectionTypePicker:
            [self closePicker:self.pickerView];
            break;
        case kTypeDate:
            [self closePicker:self.datePickerView];
            break;
        default:
            [self updateBoolRowAtTableView:tableView
                                 indexPath:indexPath
                                  itemData:itemData];
            break;
    }
}

- (void)updateBoolRowAtTableView:(UITableView *)tableView
                       indexPath:(NSIndexPath *)indexPath
                        itemData:(NSDictionary *)itemData
{
    BOOL value = ![[itemData valueForKey:kValueKey] boolValue];
    [itemData setValue:[NSNumber numberWithBool:value] forKey:kValueKey];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if ([[itemData valueForKey:kValueKey] boolValue] != NO) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
}

- (void)externalNumberAtIndexPath:(NSIndexPath *)indexPath
                         itemData:(NSDictionary *)itemData
{
    int before = self.pickerType;
    switch (before) {
        case kTypeCategoryPicker:
        case kTypeFileTypePicker:
        case kTypeFileTypeWithOutAllPicker:
        case kTypeDateFilterPicker:
        case kTypeSortTypePicker:
        case kTypeSortTypeWithOutScoreDescPicker:
        case kTypeProjectionTypePicker:
            self.pickerType = kTypeNone;
            [self closePicker:self.pickerView];
            break;
        case kTypeDate:
            self.pickerType = kTypeNone;
            [self closePicker:self.datePickerView];
            break;
        default:
            self.pickerType = kTypeNumber;
            [self showNumberInputAlert:indexPath
                              itemData:itemData];
            break;
    }
}

- (void)showNumberInputAlert:(NSIndexPath *)indexPath
                    itemData:(NSDictionary *)itemData
{
    self.alertIndexPath = indexPath;
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[itemData valueForKey:kTitleKey]
                                                    message:@"Input Numbers"
                                                   delegate:self
                                          cancelButtonTitle:@"Cancel"
                                          otherButtonTitles:@"OK", nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    UITextField *field = [alert textFieldAtIndex:0];
    field.keyboardType = UIKeyboardTypeNumberPad;
    field.text = [itemData valueForKey:kValueKey];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == alertView.cancelButtonIndex) {
        return;
    }

    NSString *value = [[alertView textFieldAtIndex:0] text];

    NSDictionary *itemData = self.dataArray[self.alertIndexPath.row];
    [itemData setValue:value forKey:kValueKey];

    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:self.alertIndexPath];
    cell.detailTextLabel.text = (value.length > 0) ? value : @"nil";
}

- (IBAction)dateAction:(id)sender
{
    NSIndexPath *targetedCellIndexPath = nil;

    if ([self hasInlinePicker]) {
        targetedCellIndexPath = [NSIndexPath indexPathForRow:self.pickerIndexPath.row - 1
                                                   inSection:0];
    } else {
        targetedCellIndexPath = [self.tableView indexPathForSelectedRow];
    }

    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:targetedCellIndexPath];
    UIDatePicker *targetedDatePicker = sender;

    NSMutableDictionary *itemData = self.dataArray[targetedCellIndexPath.row];
    [itemData setValue:targetedDatePicker.date forKey:kValueKey];

    cell.detailTextLabel.text = [self.dateFormatter stringFromDate:targetedDatePicker.date];
}

- (IBAction)doneAction:(id)sender
{
    switch (self.pickerType) {
        case kTypeDate:
            [self closePicker:self.datePickerView];
            break;
        case kTypeCategoryPicker:
        case kTypeFileTypePicker:
        case kTypeFileTypeWithOutAllPicker:
        case kTypeDateFilterPicker:
        case kTypeSortTypePicker:
        case kTypeSortTypeWithOutScoreDescPicker:
        case kTypeProjectionTypePicker:
            [self closePicker:self.pickerView];
            break;

        default:
            break;
    }
    self.pickerType = kTypeNone;
}

- (void)closePicker:(UIView *)targetPicker
{
    if (targetPicker.superview != nil) {
        CGRect pickerFrame = targetPicker.frame;
        pickerFrame.origin.y = self.view.frame.size.height;

        [UIView animateWithDuration:kPickerAnimationDuration animations:
                ^{ targetPicker.frame = pickerFrame;   }
                         completion:^(BOOL finished) {
                             [targetPicker removeFromSuperview];
                         }];

        self.navigationItem.rightBarButtonItem = nil;

        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

@end
