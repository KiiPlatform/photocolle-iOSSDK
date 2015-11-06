#import <PhotoColleSDK/DCPhotoColleSDK.h>

#import "DCAUploadDelegate.h"
#import "DCAAppDelegate.h"
#import "DCAMiscUtils.h"

@interface DCAUploadDelegate ()

@property (nonatomic, readwrite, strong) UIImage *imageToSend;
@property (nonatomic, readwrite, weak) UIActivityIndicatorView *indicator;
@property (nonatomic, readwrite, weak) UIImagePickerController *currentPicker;

- (void)load;
- (void)sendImage;
- (void)showIndicator;
- (void)hideIndicator;

@end

@implementation DCAUploadDelegate

- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    self.currentPicker = picker;
    self.imageToSend = [info objectForKey:UIImagePickerControllerOriginalImage];
    UIAlertView *alert =
        [[UIAlertView alloc] initWithTitle:@"Upload"
                                   message:@"Do you wan to upload?"
                                  delegate:self
                         cancelButtonTitle:@"Cancel"
                         otherButtonTitles:@"OK", nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView
clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([@"OK" isEqualToString:[alertView buttonTitleAtIndex:buttonIndex]]
            != NO) {
        [self load];
    }
}

- (void)load
{
    [self showIndicator];
    [self performSelectorInBackground:@selector(sendImage) withObject:nil];
}

- (void)sendImage
{
    @synchronized (self) {
        @autoreleasepool {
            NSError *error = nil;
            NSData *data = [NSData dataWithData:UIImageJPEGRepresentation(self.imageToSend, 1.0)];
            NSString *title = [NSString stringWithFormat:@"%lld.jpg",
                                        (long long)([[NSDate date] timeIntervalSince1970] * 1000)];
            DCDataID *id = self.uploadFunc(DCFILETYPE_IMAGE,
                                           title,
                                           DCMIMETYPE_JPEG,
                                           data,
                                           &error);

            NSString *message = nil;
            if (error != nil) {
                message = [error description];
            } else {
                message = [NSString stringWithFormat:@"Success: %@", id.stringValue];
            }
            self.imageToSend = nil;
            [self performSelectorOnMainThread:@selector(hideIndicator)
                                   withObject:nil
                                waitUntilDone:YES];
            [DCAMiscUtils showDialogOnMainThreadWithTitle:@"Result"
                                                  message:message];
        }
    }
}

- (void)showIndicator
{
    if (self.indicator == nil) {
        self.indicator = [DCAMiscUtils createIndicator];
        self.indicator.center = self.currentPicker.view.center;
    }
    [self.currentPicker.view addSubview:self.indicator];
    [self.indicator startAnimating];
}

- (void)hideIndicator
{
    [self.indicator stopAnimating];
    [self.indicator removeFromSuperview];
}

@end
