#import "DCAAccessTokenEditViewController.h"

#import "DCAMiscUtils.h"
#import "DCAuthenticationContext_Private.h"
#import "DCOAuth2Authentication.h"
#import "DCAuthority.h"

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

    self.accessTokenTextField.text = self.target.authentication.accessToken;
    self.expiredDateTextField.text = [self dateToString:self.target.authentication.expirationDate];
    self.refreshTokenTextField.text = self.target.authentication.refreshToken;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)editAccessToken:(id)sender
{
    self.target.authentication.accessToken = self.accessTokenTextField.text;
}

- (IBAction)editExpiredDate:(id)sender
{
    double interval = [self.expiredDateTextField.text doubleValue];
    self.target.authentication.expirationDate = [NSDate dateWithTimeIntervalSince1970:interval];
}

- (IBAction)editRefreshToken:(id)sender
{
    self.target.authentication.refreshToken = self.refreshTokenTextField.text;
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
    self.target.authentication.accessToken = @"dummy";
    self.accessTokenTextField.text = @"dummy";

    [self saveAuthenticate];
}

- (IBAction)changeExpiredTime:(id)sender
{
    self.target.authentication.expirationDate =
        [NSDate dateWithTimeIntervalSince1970:1];
    self.expiredDateTextField.text = [self dateToString:self.target.authentication.expirationDate];

    [self saveAuthenticate];
    [self updateTextField];
}

- (IBAction)changeRefreshToken:(id)sender
{
    self.target.authentication.refreshToken = @"dummy";
    self.refreshTokenTextField.text = @"dummy";

    [self saveAuthenticate];
}

- (IBAction)changeAll:(id)sender
{
    self.target.authentication.accessToken = @"dummy";
    self.accessTokenTextField.text = @"dummy";
    self.target.authentication.expirationDate = [NSDate date];
    self.expiredDateTextField.text = [self dateToString:self.target.authentication.expirationDate];
    self.target.authentication.refreshToken = @"dummy";
    self.refreshTokenTextField.text = @"dummy";

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
