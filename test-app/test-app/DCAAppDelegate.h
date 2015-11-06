#import <UIKit/UIKit.h>

@class DCPhotoColle;
@class DCATagListArguments;
@class DCADeletionListArguments;
@class DCAContentInfoListArguments;
@class DCADetailedContentInfoListArguments;

@interface DCAAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, readwrite, strong) NSString *authenticationKey;

@property (nonatomic, readonly) DCPhotoColle *photoColle;

@property (nonatomic, readonly) DCATagListArguments *tagListArguments;

@property (nonatomic, readonly) DCADeletionListArguments *deletionListArguments;

@property (nonatomic, readonly) DCAContentInfoListArguments *contentInfoListArguments;

@property (nonatomic, readonly) DCADetailedContentInfoListArguments *detailedContentInfoListArguments;

@property (nonatomic, readonly) NSMutableArray *scopes;

@end
