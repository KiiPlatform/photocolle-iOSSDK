#import <Foundation/Foundation.h>

@interface DCAMiscUtils : NSObject

+ (NSString *)getClientId;
+ (NSString *)getClientSecret;
+ (NSString *)getSettingForKey:(NSString *)key;
+ (void)showDialogWithTitle:(NSString *)title
                    message:(NSString *)message;
+ (void)showErrorDialogOnMainThreadWithError:(NSError *)error;
+ (void)showDialogOnMainThreadWithTitle:(NSString *)title
                                message:(NSString *)message;
+ (NSData *)toDataFromStream:(NSInputStream *)stream;
+ (NSString *)encodeBase64FromData:(NSData *)data;
+ (NSString *)encodeBase64FromStream:(NSInputStream *)stream;
+ (UIActivityIndicatorView *)createIndicator;

@end
