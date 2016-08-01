#import <PhotoColleSDK/DCPhotoColleSDK.h>

#import "DCAAccessTokenEditViewController.h"

#import "DCAMiscUtils.h"

/*
  In this file, We access internal properties of PhotoColleSDK.
  The reason is to test invalid access token and/or expires date.
 */

@interface DCAAccessTokenEditViewController ()

@property (nonatomic, readwrite, strong) DCAuthenticationContext *target;
@end

@implementation DCAAccessTokenEditViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.target = [DCAuthenticationContext loadByKey:self.storeKey
                                            clientId:[DCAMiscUtils getSettingForKey:@"clientId"]
                                        clientSecret:[DCAMiscUtils getSettingForKey:@"clientSecret"]
                                               error:nil];
    [self updateTextField];
}

- (void)updateTextField
{
    self.storeKeyLabel.numberOfLines = 2;
    self.storeKeyLabel.text = [NSString stringWithFormat:@"%@\n%lf",
            self.storeKey, [self.target remainingTimeInSeconds]];

    self.accessTokenTextField.text =
        [[self.target
             valueForKey:@"authentication"] valueForKey:@"accessToken"];
    self.expiredDateTextField.text =
        [self dateToString:[[self.target
                                valueForKey:@"authentication"]
                             valueForKey:@"expirationDate"]];
    self.refreshTokenTextField.text =
        [[self.target
             valueForKey:@"authentication"] valueForKey:@"refreshToken"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)editAccessToken:(id)sender
{
    [[self.target valueForKey:@"authentication"]
          setValue:self.accessTokenTextField.text forKey:@"accessToken"];
}

- (IBAction)editExpiredDate:(id)sender
{
    double interval = [self.expiredDateTextField.text doubleValue];
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:interval];
    [[self.target valueForKey:@"authentication"]
                             setValue:date forKey:@"expirationDate"];
}

- (IBAction)editRefreshToken:(id)sender
{
    [[self.target valueForKey:@"authentication"]
      setValue:self.refreshTokenTextField.text forKey:@"refreshToken"];
}

- (IBAction)save:(id)sender
{
    [self saveAuthenticate];
}

- (IBAction)refreshToken:(id)sender
{
    [DCAuthority refreshTokenWithAuthenticationContext:self.target
                                                 block:^(DCAuthenticationContext * context,
            NSError *error)
        {
            NSString *message = @"Success to refreshToken.";
            if (error != nil) {
                message = [error description];
            } else {
                [self updateTextField];
            }
            [DCAMiscUtils showDialogWithTitle:@"Refresh token"
                                      message:message];
        }
     ];
}

- (IBAction)changeAccessToken:(id)sender
{
    [[self.target valueForKey:@"authentication"]
          setValue:@"dummy" forKey:@"accessToken"];
    self.accessTokenTextField.text =
        [[self.target valueForKey:@"authentication"]
          valueForKey:@"accessToken"];
    [self saveAuthenticate];
}

- (IBAction)changeExpiredTime:(id)sender
{
    [[self.target valueForKey:@"authentication"]
                             setValue:[NSDate dateWithTimeIntervalSince1970:1]
                               forKey:@"expirationDate"];
    self.expiredDateTextField.text =
        [self dateToString:[[self.target
                                valueForKey:@"authentication"]
                             valueForKey:@"expirationDate"]];

    [self saveAuthenticate];
    [self updateTextField];
}

- (IBAction)changeRefreshToken:(id)sender
{
    [[self.target valueForKey:@"authentication"]
      setValue:@"dummy" forKey:@"refreshToken"];
    self.refreshTokenTextField.text =
        [[self.target
             valueForKey:@"authentication"] valueForKey:@"refreshToken"];

    [self saveAuthenticate];
}

- (IBAction)changeAll:(id)sender
{
    [[self.target valueForKey:@"authentication"]
          setValue:@"dummy" forKey:@"accessToken"];
    self.accessTokenTextField.text =
        [[self.target valueForKey:@"authentication"]
          valueForKey:@"accessToken"];

    [[self.target valueForKey:@"authentication"]
                             setValue:[NSDate date] forKey:@"expirationDate"];
    self.expiredDateTextField.text =
        [self dateToString:[[self.target
                                valueForKey:@"authentication"]
                             valueForKey:@"expirationDate"]];


    [[self.target valueForKey:@"authentication"]
      setValue:@"dummy" forKey:@"refreshToken"];
    self.refreshTokenTextField.text =
        [[self.target
             valueForKey:@"authentication"] valueForKey:@"refreshToken"];

    [self saveAuthenticate];
}

- (IBAction)remove:(id)sender
{
    [DCAuthenticationContext removeByKey:self.storeKey
                                   error:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)saveAuthenticate
{
    [self.target saveByKey:self.storeKey
             accessibility:kSecAttrAccessibleWhenUnlocked
                     error:nil];
}

- (NSString *)dateToString:(NSDate *)date
{
    return [NSNumber numberWithDouble:[date timeIntervalSince1970]].stringValue;
}
@end
