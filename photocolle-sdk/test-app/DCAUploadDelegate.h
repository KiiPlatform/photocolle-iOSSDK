#import <UIKit/UIKit.h>
#import "DCEnumerations.h"

@class DCDataID;

typedef DCDataID *(^DCAUploadFunc)(DCFileType fileType,
                                   NSString* fileName,
                                   DCMimeType mimeType,
                                   NSData *data,
                                   NSError **error);

@interface DCAUploadDelegate : NSObject<
        UINavigationControllerDelegate, UIImagePickerControllerDelegate,
            UIAlertViewDelegate>

@property (nonatomic, readwrite, strong) DCAUploadFunc uploadFunc;

@end
