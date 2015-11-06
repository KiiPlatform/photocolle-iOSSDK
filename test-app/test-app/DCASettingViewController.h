#import <UIKit/UIKit.h>

extern NSString * const kTitleKey;
extern NSString * const kValueKey;
extern NSString * const kTypeKey;

typedef NS_ENUM(NSInteger, kDataType) {
    kTypeNone,
    kTypeDate,
    kTypeCategoryPicker,
    kTypeBool,
    kTypeFileTypePicker,
    kTypeFileTypeWithOutAllPicker,
    kTypeDateFilterPicker,
    kTypeSortTypePicker,
    kTypeSortTypeWithOutScoreDescPicker,
    kTypeProjectionTypePicker,
    kTypeNumber
};

typedef NS_ENUM(NSInteger, kDateFilterType) {
    kFilterIsNil = 0,
    kFilterIsUpload,
    kFilterIsModified
};

@interface DCASettingViewController : UITableViewController
        <UIPickerViewDataSource, UIPickerViewDelegate, UIAlertViewDelegate>

@property (nonatomic, readwrite, strong) NSArray *dataArray;

@end
