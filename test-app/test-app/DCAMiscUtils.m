#import "DCAMiscUtils.h"

const static char BASE64TABLE[] =
    "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";

@interface UIAlertView (DCAExtention)

- (void)showAndRelease;

@end

@implementation UIAlertView (DCAExtention)

- (void)showAndRelease
{
    [self show];
}


@end

@implementation DCAMiscUtils

+ (NSString *)getClientId
{
    return [DCAMiscUtils getSettingForKey:@"clientId"];
}

+ (NSString *)getClientSecret
{
    return [DCAMiscUtils getSettingForKey:@"clientSecret"];
}

+ (NSString *)getSettingForKey:(NSString *)key
{
    NSAssert(key != nil, @"key must not be nil");

    return [DCAMiscUtils getStringForKey:key
                            fromResource:@"photocolle_setting.plist"
                            defaultValue:nil];
}

+ (NSString *)getStringForKey:(NSString *)key
                 fromResource:(NSString *)file
                 defaultValue:(NSString *)defaultValue
{
    NSAssert(key != nil, @"key must not be nil");
    NSAssert(file != nil, @"file must not be nil");

    NSDictionary *dict = [DCAMiscUtils getResourceDictionary:file];
    NSString *retval = [dict objectForKey:key];
    if (retval == nil) {
        return defaultValue;
    }
    return retval;
}

+ (NSDictionary *)getResourceDictionary:(NSString *)file
{
    NSAssert(file != nil, @"file must not be nil");

    NSInputStream *stream = nil;
    @try {
        stream = [DCAMiscUtils openResourceInputStream:file];
        if (stream == nil) {
            return nil;
        }
        [stream open];
        // NSPropertyListReadOptions currently not implemented so 0 is used.
        // https://developer.apple.com/library/ios/#documentation/Cocoa/Reference/Foundation/Classes/NSPropertyListSerialization_Class/Reference/Reference.html#//apple_ref/occ/cl/NSPropertyListSerialization
        NSPropertyListFormat format = NSPropertyListOpenStepFormat;
        return (NSDictionary *)[NSPropertyListSerialization
                                 propertyListWithStream:stream
                                                options:0
                                                 format:&format
                                                  error:nil];
    } @finally {
        [stream close];
    }
}

+ (NSInputStream *)openResourceInputStream:(NSString *)file
{
    NSAssert(file != nil, @"file must not be nil.");

    NSString *path = [[NSBundle mainBundle] pathForResource:file ofType:nil];
    if (path == nil) {
        return nil;
    }
    return [NSInputStream inputStreamWithFileAtPath:path];
}

+ (void)showDialogWithTitle:(NSString *)title
                    message:(NSString *)message
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:message
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

+ (void)showDialogOnMainThreadWithTitle:(NSString *)title
                                message:(NSString *)message;
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:message
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert performSelectorOnMainThread:@selector(showAndRelease)
                            withObject:nil
                         waitUntilDone:YES];

}

+ (void)showErrorDialogOnMainThreadWithError:(NSError *)error
{
    [DCAMiscUtils showDialogOnMainThreadWithTitle:@"Error"
                                          message:[error description]];
}

+ (NSData *)toDataFromStream:(NSInputStream *)stream
{
    NSMutableData *retval = [NSMutableData data];
    uint8_t buf[1024];
    while ([stream hasBytesAvailable] != NO) {
        NSInteger size = [stream read:buf maxLength:1024];
        [retval appendBytes:buf length:size];
    }
    return retval;
}

+ (NSString *)encodeBase64FromData:(NSData *)data
{
    NSInputStream *stream = [NSInputStream inputStreamWithData:data];
    @try {
        [stream open];
        return [DCAMiscUtils encodeBase64FromStream:stream];
    } @finally {
        [stream close];
    }
}

+ (NSString *)encodeBase64FromStream:(NSInputStream *)stream
{
    uint8_t buf[3];
    char str[5];
    NSMutableString *retval = [NSMutableString string];
    while ([stream hasBytesAvailable] != NO) {
        buf[0] = buf[1] = buf[2] = 0;
        NSInteger size = [stream read:buf
                            maxLength:(sizeof(buf)/sizeof(buf[0]))];
        str[0] = BASE64TABLE[(buf[0] >> 2) & (0x3f)];
        str[1] = BASE64TABLE[
                (((buf[0] & 0x03) << 4) & 0x30) | ((buf[1] >> 4) & 0x0f)];
        str[2] = BASE64TABLE[((buf[1] << 2) & 0x3C) | ((buf[2] >> 6) & 0x03)];
        str[3] = BASE64TABLE[(buf[2] >> 2) & 0x3f];
        str[4] = '\0';
        switch (size) {
            case 1:
                str[2] = '=';
                str[3] = '=';
                break;
            case 2:
                str[3] = '=';
                break;
            case 3:
                // Nothing to do.
                break;
            case 0:
            default:
                // Error case;
                [NSException raise:@"RuntimeException" format:@"invalid size."];
                return nil;
        }
        [retval appendFormat:@"%s", str];
    }
    return retval;
}

+ (UIActivityIndicatorView *)createIndicator
{
    UIActivityIndicatorView *retval =
        [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    retval.color = [UIColor blackColor];
    return retval;
}

@end
