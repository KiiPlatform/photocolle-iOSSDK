#import "DCUploadContentBodyLogic.h"
#import "DCUploadContentBodyArguments.h"
#import "DCMiscUtils.h"
#import "DCCommand.h"
#import "DCEnumerationsUtils.h"
#import "DCErrorUtils.h"
#import "DCDataID_Private.h"
#import "DCExceptionUtils.h"
#import "GTMMIMEDocument.h"

static NSString * const DEFAULT_URL =
    @"https://xlb.photocolle-docomo.com/file_a2/1.0/docomo/create";

@implementation DCUploadContentBodyLogic

- (NSMutableURLRequest *)createRequestWithURL:(NSURL *)url
                                    arguments:(DCArguments *)arguments
                                        error:(NSError **)error
{
    NSAssert(url != nil, @"url must not be nil.");
    NSAssert(arguments != nil, @"arguments must not be nil.");
    NSAssert([arguments isKindOfClass:[DCUploadContentBodyArguments class]]
             != NO, @"arguments type must be DCUploadContentBodyArguments");
    NSAssert(error != nil, @"error must not be nil.");
    
    DCUploadContentBodyArguments *args = (DCUploadContentBodyArguments*)arguments;

    DCGTMMIMEDocument *document = [DCGTMMIMEDocument MIMEDocument];
    [DCUploadContentBodyLogic
          putPartWithName:@"type"
              stringValue:[DCUploadContentBodyLogic getFileType:args.fileType]
               toDocument:document];
    [DCUploadContentBodyLogic putPartWithName:@"title"
                                  stringValue:args.fileName
                                   toDocument:document];
    [DCUploadContentBodyLogic
          putPartWithName:@"size"
              stringValue:[NSString stringWithFormat:@"%lld", args.size]
               toDocument:document];
    [DCUploadContentBodyLogic
          putPartWithName:@"mime_type"
              stringValue:[DCEnumerationsUtils
                            toNSStringFromDCMimeType:args.mimeType]
               toDocument:document];
    [DCUploadContentBodyLogic putPartWithName:@"file"
                                     fileName:args.fileName
                                     bodyData:args.bodyData
                                   toDocument:document];

    NSInputStream *inputStream = nil;
    NSString *boundary = nil;
    unsigned long long len = 0;

    [document generateInputStream:&inputStream
                      length:&len
                    boundary:&boundary];
    if (inputStream == nil) {
        [DCExceptionUtils
          raiseUnexpectedExceptionWithReason:@"fail to generate input stream"];
    }

    // create request.
    NSMutableURLRequest *retval = [DCMiscUtils toPostRequestFromURL:url];
    if ([DCCommand signRequest:retval withContext:args.context error:error]
            == NO) {
        return nil;
    }
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    [retval addValue:contentType forHTTPHeaderField:@"Content-Type"];
    NSString *contentLength = [NSString stringWithFormat:@"%llu", len];
    [retval addValue:contentLength forHTTPHeaderField:@"Content-Length"];
    [retval setHTTPBodyStream:inputStream];
    return retval;
}

- (id)parseResponse:(NSURLResponse *)response
               data:(NSData *)data
              error:(NSError **)error
{
    NSAssert(error != nil, @"error must not be nil.");

    // check response.
    NSAssert(response != nil, @"response must not be nil.");
    NSAssert([response isKindOfClass:[NSHTTPURLResponse class]] != NO,
             @"response type must be NSHTTPURLResponse");
    NSHTTPURLResponse * httpResponse = (NSHTTPURLResponse *)response;
    if (httpResponse.statusCode != 200) {
        *error = [DCErrorUtils httpRelatedErrorFromHttpResponse:httpResponse
                                                           data:data];
        return nil;
    }
    
    // check data.
    NSAssert(data != nil, @"data must not be nil.");
    NSDictionary *json = [DCMiscUtils JSONObjectWithData:data error:error];
    if (*error != nil) {
        return nil;
    }
    NSString *result = [DCMiscUtils stringForKey:@"result"
                                        fromJSON:json
                                           error:error];
    if (*error != nil) {
        return nil;
    }
    if ([result isEqualToString:@"0"] != NO) {
        return [DCUploadContentBodyLogic toDCDataID:json error:error];
    } else if ([result isEqualToString:@"1"] != NO) {
        *error = [DCErrorUtils uploadErrorFromJSON:json];
        return nil;
    } else {
        *error = [DCErrorUtils responseBodyParseErrorWithDescription:
                  [NSString stringWithFormat:@"result is out of range: %@",
                   result]];
        return nil;
    }
}

- (NSURL *)getDefaultURL
{
    return [NSURL URLWithString:DEFAULT_URL];
}

+ (NSString *)getFileType:(DCFileType)fileType
{
    switch (fileType) {
        case DCFILETYPE_IMAGE:
            return @"Image";
        case DCFILETYPE_VIDEO:
            return @"Video";
        case DCFILETYPE_SLIDE_MOVIE:
        default:
            [DCExceptionUtils raiseOutOfRangeExceptionWithReason:
                [NSString stringWithFormat:@"unsupport DCFileType:%ld",
                    (long)fileType]];
    }
    return nil;
}

+ (void)putPartWithName:(NSString *)name
            stringValue:(NSString *)stringValue
             toDocument:(DCGTMMIMEDocument *)document
{
    NSAssert(name != nil, @"name must not be nil.");
    NSAssert(stringValue != nil, @"stringValue must not be nil.");
    NSAssert(document != nil, @"document must not be nil.");

    NSString *value =
        [NSString stringWithFormat:@"form-data; name=\"%@\"", name];
    [document addPartWithHeaders:[NSDictionary
                                   dictionaryWithObject:value
                                                 forKey:@"Content-Disposition"]
                            body:[stringValue
                                   dataUsingEncoding:NSUTF8StringEncoding]];
}

+ (void)putPartWithName:(NSString *)name
               fileName:(NSString *)fileName
               bodyData:(NSData *)bodyData
             toDocument:(DCGTMMIMEDocument *)document
{
    NSAssert(name != nil, @"name must not be nil.");
    NSAssert(fileName != nil, @"fileName must not be nil.");
    NSAssert(bodyData != nil, @"bodyData must not be nil.");
    NSAssert(document != nil, @"document must not be nil.");

    NSString *contentDispositionValue =
        [NSString stringWithFormat:@"form-data; name=\"%@\"; filename=\"%@\"",
                  name, fileName];
    [document addPartWithHeaders:[NSDictionary dictionaryWithObjectsAndKeys:
                                               contentDispositionValue,
                                               @"Content-Disposition",
                                               @"application/octet-stream",
                                               @"Content-Type", nil]
                            body:bodyData];
}

+ (DCDataID *)toDCDataID:(NSDictionary *)json error:(NSError **)error
{
    NSAssert(json != nil, @"json must not be nil.");
    NSAssert(error != nil, @"error must not be nil.");

    NSError *cause = nil;
    NSString *dataId = [DCMiscUtils stringForKey:@"data_id"
                                        fromJSON:json
                                           error:&cause];
    if (cause != nil) {
        *error = [DCErrorUtils responseBodyParseErrorWithCause:cause];
        return nil;
    }

    return [[DCDataID alloc] initWithID:dataId];
}

@end
