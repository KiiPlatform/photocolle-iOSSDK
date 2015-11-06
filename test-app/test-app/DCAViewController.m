#import <PhotoColleSDK/DCPhotoColleSDK.h>

#import "DCAViewController.h"
#import "DCAMiscUtils.h"
#import "DCAAppDelegate.h"
#import "DCAContentInfoListProvider.h"
#import "DCAContentListViewController.h"
#import "DCADetailedContentInfoListProvider.h"
#import "DCATagListViewController.h"
#import "DCATagListProvider.h"
#import "DCADeletionListViewController.h"
#import "DCADeletionListProvider.h"
#import "DCAUploadDelegate.h"
#import "DCADetailedContentListViewController.h"

@interface DCAViewController ()
@property (nonatomic, readonly) NSString *consumerKey;
@property (nonatomic, readonly) NSString *consumerSecret;
@property (nonatomic, readonly) NSString *extScope;
@property (nonatomic, readwrite, strong) id pickerDelegateHolder;
@end

@implementation DCAViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    UIBarButtonItem *storeKeyButton = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemEdit
                                       target:self
                                       action:@selector(storeKey:)];
    UIBarButtonItem *composeButton = [[UIBarButtonItem alloc]
                                      initWithBarButtonSystemItem:UIBarButtonSystemItemCompose
                                      target:self
                                      action:@selector(compose:)];
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:storeKeyButton, composeButton, nil];

    DCAAppDelegate *app = (DCAAppDelegate *)[[UIApplication sharedApplication] delegate];
    app.authenticationKey = @"test01";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)authenticate
{
    DCAAppDelegate *app = (DCAAppDelegate *)[[UIApplication sharedApplication] delegate];
    [DCAuthority
      authenticateOnNavigationController:self.navigationController
                            withClientId:[DCAMiscUtils getClientId]
                            clientSecret:[DCAMiscUtils getClientSecret]
                             redirectUri:self.redirectUri
                                  scopes:[NSArray arrayWithArray:app.scopes]
                                storeKey:app.authenticationKey
                           accessibility:kSecAttrAccessibleWhenUnlocked
                                   block:^(DCAuthenticationContext * context,
                                           NSError *error) {
            NSString *message = @"Success to authenticate.";
            if (error != nil) {
                message = [error description];
            }
            [DCAMiscUtils showDialogWithTitle:@"Authentication"
                                      message:message];
        }
     ];

}

- (NSString *)redirectUri
{
    return [DCAMiscUtils getSettingForKey:@"redirectUri"];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSString *identifier = [segue identifier];
    if ([identifier isEqualToString:@"showContentInfoList"] != NO) {
        DCAContentListViewController *controller =
            [segue destinationViewController];
        controller.title = @"ID List";
        DCAContentInfoListProvider * provider =
            [[DCAContentInfoListProvider alloc] init];
        controller.provider = provider;
    } else if ([identifier isEqualToString:@"showDetaildContentInfoList"]
               != NO) {
        DCADetailedContentListViewController *controller =
            [segue destinationViewController];
        controller.title = @"Detailed ID List";
        DCADetailedContentInfoListProvider * provider =
            [[DCADetailedContentInfoListProvider alloc] init];
        controller.provider = provider;
    } else if ([identifier isEqualToString:@"showTags"] != NO) {
        DCATagListViewController *controller =
            [segue destinationViewController];
        controller.title = @"Tag List";
        DCATagListProvider * provider = [[DCATagListProvider alloc] init];
        controller.provider = provider;
    } else if ([identifier isEqualToString:@"showDeletion"] != NO) {
        DCADeletionListViewController *controller =
            [segue destinationViewController];
        controller.title = @"Deletion List";
        DCADeletionListProvider * provider =
            [[DCADeletionListProvider alloc] init];
        controller.provider = provider;
    }
}

- (IBAction)uploadByData:(id)sender
{
    DCAAppDelegate *app = (DCAAppDelegate *)
        [[UIApplication sharedApplication] delegate];
    [self showImagePicker:^DCDataID *(DCFileType fileType,
                                        NSString* fileName,
                                        DCMimeType mimeType,
                                        NSData *data,
                                        NSError **error) {
        return [app.photoColle uploadContentBodyWithFileType:fileType
                                                    fileName:fileName
                                                        size:[data length]
                                                    mimeType:mimeType
                                                    bodyData:data
                                                       error:error];
    }];
}

- (IBAction)uploadByStream:(id)sender
{
    DCAAppDelegate *app = (DCAAppDelegate *)
        [[UIApplication sharedApplication] delegate];
    [self showImagePicker:^DCDataID *(DCFileType fileType,
                                        NSString* fileName,
                                        DCMimeType mimeType,
                                        NSData *data,
                                        NSError **error) {
        return [app.photoColle uploadContentBodyWithFileType:fileType
                                                    fileName:fileName
                                                        size:[data length]
                                                    mimeType:mimeType
                                                  bodyStream:[NSInputStream inputStreamWithData:data]
                                                       error:error];
    }];
}

- (void)showImagePicker:(DCAUploadFunc)uploadFunc
{
    DCAUploadDelegate *delegate = [[DCAUploadDelegate alloc] init];
    delegate.uploadFunc = uploadFunc;

    // UIImagePickerController.delegate is assign, need to keep delegate object.
    self.pickerDelegateHolder = delegate;
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = delegate;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.wantsFullScreenLayout = YES;
    picker.allowsEditing = NO;
    [self presentViewController:picker animated:YES completion:nil];
}

- (void)compose:(id)sender
{
    [self performSegueWithIdentifier:@"Setting" sender:self];
}

- (void)storeKey:(id)sender
{
    DCAAppDelegate *app = (DCAAppDelegate *)[[UIApplication sharedApplication] delegate];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Store Key"
                                                    message:nil
                                                   delegate:self
                                          cancelButtonTitle:@"Cancel"
                                          otherButtonTitles:@"Change", nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    UITextField *field = [alert textFieldAtIndex:0];
    field.text = app.authenticationKey;
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == alertView.cancelButtonIndex) {
        return;
    }

    NSString *text = [[alertView textFieldAtIndex:0] text];
    DCAAppDelegate *app = (DCAAppDelegate *)[[UIApplication sharedApplication] delegate];
    if ([@"nil" isEqualToString:text] != NO) {
        app.authenticationKey = nil;
    } else {
        app.authenticationKey = text;
    }
}

@end
