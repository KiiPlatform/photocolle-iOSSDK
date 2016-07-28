#import "DCOAuth2Authentication_Private.h"

#import "DCSessionFetcherService.h"

static NSString * const KEY_ORIGINAL = @"original-docomo";
static NSString * const KEY_ACCESSTOKEN = @"accessToken-docomo";
static NSString * const KEY_EXPIRATIONDATE = @"expirationDate-docomo";
static NSString * const KEY_ACCESSIBILITY = @"accessibility-docomo";

static NSString * const WHEN_UNLOCKED = @"WHEN_UNLOCKED";
static NSString * const AFTER_FIRST_UNLOCK = @"AFTER_FIRST_UNLOCK";
static NSString * const ALWAYS = @"ALWAYS";
static NSString * const WHEN_UNLOCKED_THIS_DEVICE_ONLY =
    @"WHEN_UNLOCKED_THIS_DEVICE_ONLY";
static NSString * const AFTER_FIRST_UNLOCK_THIS_DEVICE_ONLY =
    @"AFTER_FIRST_UNLOCK_THIS_DEVICE_ONLY";
static NSString * const ALWAYS_THI_SDEVICE_ONLY = @"ALWAYS_THI_SDEVICE_ONLY";

@implementation DCOAuth2Authentication

- (NSString *)persistenceResponseString
{
    if (self.accessToken == nil || self.refreshToken == nil) {
        return [super persistenceResponseString];
    }  else {
        NSMutableDictionary *dict =
            [NSMutableDictionary dictionaryWithDictionary:@{
                KEY_ORIGINAL : [super persistenceResponseString],
                KEY_ACCESSTOKEN : self.accessToken
                }
            ];
        if (self.expirationDate != nil) {
            NSString *date =
                [DCOAuth2Authentication toStringFromDate:self.expirationDate];
            [dict setValue:date forKey:KEY_EXPIRATIONDATE];
        }
        if (self.accessibility != NULL) {
            NSString *accessibility = [DCOAuth2Authentication
                               toStringFromCFTypeRef:self.accessibility];
            [dict setValue:accessibility forKey:KEY_ACCESSIBILITY];
        }
        return [DCGTMOAuth2Authentication
                 encodedQueryParametersForDictionary:dict];
    }
}

- (void)setKeysForResponseString:(NSString *)str
{
    NSDictionary *dict =
        [DCGTMOAuth2Authentication dictionaryWithResponseString:str];
    if ([dict objectForKey:KEY_ORIGINAL] == nil) {
        [super setKeysForResponseString:str];
    } else {
        [super setKeysForResponseString:[dict objectForKey:KEY_ORIGINAL]];
        self.accessToken = [dict objectForKey:KEY_ACCESSTOKEN];
        NSString *date = [dict objectForKey:KEY_EXPIRATIONDATE];
        if (date != nil) {
            self.expirationDate =
                [DCOAuth2Authentication toDateFromString:date];
        }
        CFTypeRef accessibility =
            [DCOAuth2Authentication toCFTypeRefFromString:
                                       [dict objectForKey:KEY_ACCESSIBILITY]];
        if (accessibility != NULL) {
            self.accessibility = accessibility;
        }
    }
}

+ (NSString *)toStringFromDate:(NSDate *)date
{
    return [NSString stringWithFormat:@"%f", [date timeIntervalSince1970]];
}

+ (NSDate *)toDateFromString:(NSString *)string
{
    return [NSDate dateWithTimeIntervalSince1970:[string doubleValue]];
}

+ (NSString *)toStringFromCFTypeRef:(CFTypeRef)ref
{
    if (ref == kSecAttrAccessibleWhenUnlocked) {
        return WHEN_UNLOCKED;
    } else if (ref == kSecAttrAccessibleAfterFirstUnlock) {
        return AFTER_FIRST_UNLOCK;
    } else if (ref == kSecAttrAccessibleAlways) {
        return ALWAYS;
    } else if (ref == kSecAttrAccessibleWhenUnlockedThisDeviceOnly) {
        return WHEN_UNLOCKED_THIS_DEVICE_ONLY;
    } else if (ref ==
               kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly) {
        return AFTER_FIRST_UNLOCK_THIS_DEVICE_ONLY;
    } else if (ref == kSecAttrAccessibleAlwaysThisDeviceOnly) {
        return ALWAYS_THI_SDEVICE_ONLY;
    }
    return nil;
}

+ (CFTypeRef)toCFTypeRefFromString:(NSString *)string
{
    if ([WHEN_UNLOCKED isEqualToString:string] != NO) {
        return kSecAttrAccessibleWhenUnlocked;
    } else if ([AFTER_FIRST_UNLOCK isEqualToString:string] != NO) {
        return kSecAttrAccessibleAfterFirstUnlock;
    } else if ([ALWAYS isEqualToString:string] != NO) {
        return kSecAttrAccessibleAlways;
    } else if ([WHEN_UNLOCKED_THIS_DEVICE_ONLY isEqualToString:string] != NO) {
        return kSecAttrAccessibleWhenUnlockedThisDeviceOnly;
    } else if ([AFTER_FIRST_UNLOCK_THIS_DEVICE_ONLY isEqualToString:string]
            != NO) {
        return kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly;
    } else if ([ALWAYS_THI_SDEVICE_ONLY isEqualToString:string] != NO) {
        return kSecAttrAccessibleAlwaysThisDeviceOnly;
    }
    return NULL;
}

@end
