#import <PhotoColleSDK/DCPhotoColleSDK.h>

#import "DCATagListProvider.h"

#import "DCADataProviding.h"
#import "DCATagListSettingViewController.h"
#import "DCAAppDelegate.h"
#import "DCATagListArguments.h"

@interface DCATagProvider : NSObject <DCADataProviding>

@property (nonatomic, readwrite, strong) DCTag *tag;

- (id)initWithTag:(DCTag *)tag;
+ (id)providerWithTag:(DCTag *)tag;

@end

@implementation DCATagProvider

- (id)initWithTag:(DCTag *)tag
{
    self = [super init];
    if (self != nil) {
        self.tag = tag;
    }
    return self;
}

+ (id)providerWithTag:(DCTag *)tag
{
    return [[DCATagProvider alloc] initWithTag:tag];
}

- (NSString *)label
{
    return self.tag.name;
}

- (NSString *)jsonString
{
    NSDictionary *json = nil;
    if (self.tag.type == DCTAGTYPE_PERSON) {
        json = [DCATagProvider toJsonFromPersonTag:(DCPersonTag *)self.tag];
    } else {
        json = [DCATagProvider toJsonFromTag:self.tag];
    }
    NSData *data =
    [NSJSONSerialization dataWithJSONObject:json
                                    options:NSJSONWritingPrettyPrinted
                                      error:nil];
    return [[NSString alloc] initWithData:data
                                 encoding:NSUTF8StringEncoding];
}

- (DCContentGUID *)id
{
    return self.tag.guid;
}

+ (NSDictionary *)toJsonFromPersonTag:(DCPersonTag *)tag
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd'T'hh:mm:ss'Z'";
    return [NSDictionary dictionaryWithObjectsAndKeys:
            [DCATagProvider toTagTypeName:tag.type], @"type",
            tag.guid.stringValue, @"guid",
            tag.name, @"name",
            [NSNumber numberWithInt:tag.contentsCount], @"count",
            [formatter stringFromDate:tag.birthDate], @"birth",
            nil];
}

+ (NSDictionary *)toJsonFromTag:(DCTag *)tag
{
    return [NSDictionary dictionaryWithObjectsAndKeys:
            [DCATagProvider toTagTypeName:tag.type], @"type",
            tag.guid.stringValue, @"guid",
            tag.name, @"name",
            [NSNumber numberWithInt:tag.contentsCount], @"count",
            nil];
}

+ (NSString *)toTagTypeName:(DCTagType)type
{
    switch (type) {
        case DCTAGTYPE_PERSON:
            return @"person";
        case DCTAGTYPE_EVENT:
            return @"event";
        case DCTAGTYPE_FAVORITE:
            return @"favorite";
        case DCTAGTYPE_PLACEMENT:
            return @"placement";
        case DCTAGTYPE_YEAR_MONTH:
            return @"year_month";
        default:
            return @"unknown";
    }
}

@end

@interface DCATagListProvider ()

@property (nonatomic, readwrite, strong) NSArray *objects;

@end

@implementation DCATagListProvider

- (NSInteger)count
{
    return self.objects.count;
}

- (id <DCADataProviding>)objectAtIndex:(NSInteger)index
{
    DCTag *tag = [self.objects objectAtIndex:index];
    return [DCATagProvider providerWithTag:tag];
}

- (BOOL)retrieveDataWithPhotoColle:(DCPhotoColle *)photoColle
                             error:(NSError **)error
{
    DCAAppDelegate *app = (DCAAppDelegate *)[[UIApplication sharedApplication] delegate];

    DCTagListResponse *result = (DCTagListResponse *)
    [photoColle getTagIDListWithCategory:app.tagListArguments.category
                                fileType:app.tagListArguments.fileType
                         minDateModified:app.tagListArguments.minDateModified
                                   error:error];
    if (*error != nil) {
        return NO;
    }
    self.objects = result.list;
    return YES;
}

@end
