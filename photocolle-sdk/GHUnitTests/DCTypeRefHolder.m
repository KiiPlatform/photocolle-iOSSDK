#import "DCTypeRefHolder.h"

@implementation DCTypeRefHolder

+ (instancetype)holder:(CFTypeRef)ref
{
    DCTypeRefHolder *retval = [[DCTypeRefHolder alloc] init];
    if (retval != nil) {
        retval.ref = ref;
    }
    return retval;
}

- (NSString *)description
{
    if (self.ref == kSecAttrAccessibleWhenUnlocked) {
        return @"kSecAttrAccessibleWhenUnlocked";
    } else if (self.ref == kSecAttrAccessibleAfterFirstUnlock) {
        return @"kSecAttrAccessibleAfterFirstUnlock";
    } else if (self.ref == kSecAttrAccessibleAlways) {
        return @"kSecAttrAccessibleAlways";
    } else if (self.ref == kSecAttrAccessibleWhenUnlockedThisDeviceOnly) {
        return @"kSecAttrAccessibleWhenUnlockedThisDeviceOnly";
    } else if (self.ref == kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly) {
        return @"kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly";
    } else if (self.ref == kSecAttrAccessibleAlwaysThisDeviceOnly) {
        return @"kSecAttrAccessibleAlwaysThisDeviceOnly";
    }
    return nil;
}

@end
