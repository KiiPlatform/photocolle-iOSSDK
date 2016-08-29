/* Copyright (c) 2014 Google Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

/* 2015 Kii corp.
 *
 * Prefixes are changed from GTM to DCGTM.
 *
 * Targets of changing prefix are all classes, protocols, extensions,
 * categoriesconst values, comments and etc.
 */

#if !defined(__has_feature) || !__has_feature(objc_arc)
#error "This file requires ARC support."
#endif

#import "GTMSessionFetcherLogViewController.h"

#if !STRIP_DCGTM_FETCH_LOGGING && !STRIP_DCGTM_SESSIONLOGVIEWCONTROLLER

#import <objc/runtime.h>

#import "GTMSessionFetcher.h"
#import "GTMSessionFetcherLogging.h"

static NSString *const kHTTPLogsCell = @"kDCGTMHTTPLogsCell";

// A minimal controller will be used to wrap a web view for displaying the
// log files.
@interface DCGTMSessionFetcherLoggingWebViewController : UIViewController<UIWebViewDelegate>
- (id)initWithURL:(NSURL *)htmlURL title:(NSString *)title opensScrolledToEnd:(BOOL)opensScrolled;
@end

#pragma mark - Table View Controller

@interface DCGTMSessionFetcherLogViewController ()
@property (nonatomic, copy) void (^callbackBlock)(void);
@end

@implementation DCGTMSessionFetcherLogViewController {
  NSArray *logsFolderURLs_;
  BOOL opensScrolledToEnd_;
}

@synthesize callbackBlock = callbackBlock_;

- (instancetype)initWithStyle:(UITableViewStyle)style {
  self = [super initWithStyle:style];
  if (self) {
    self.title = @"HTTP Logs";

    // Find all folders containing logs.
    NSError *error;
    NSFileManager *fm = [NSFileManager defaultManager];
    NSString *logsFolderPath = [DCGTMSessionFetcher loggingDirectory];
    NSString *processName = [DCGTMSessionFetcher loggingProcessName];

    NSURL *logsURL = [NSURL fileURLWithPath:logsFolderPath];
    NSMutableArray *mutableURLs =
        [[fm contentsOfDirectoryAtURL:logsURL
           includingPropertiesForKeys:@[ NSURLCreationDateKey ]
                              options:0
                                error:&error] mutableCopy];

    // Remove non-log files that lack the process name prefix,
    // and remove the "newest" symlink.
    NSString *symlinkSuffix = [DCGTMSessionFetcher symlinkNameSuffix];
    NSIndexSet *nonLogIndexes = [mutableURLs indexesOfObjectsPassingTest:
        ^BOOL(id obj, NSUInteger idx, BOOL *stop) {
      NSString *name = [obj lastPathComponent];
         return (![name hasPrefix:processName]
                 || [name hasSuffix:symlinkSuffix]);
    }];
    [mutableURLs removeObjectsAtIndexes:nonLogIndexes];

    // Sort to put the newest logs at the top of the list.
    [mutableURLs sortUsingComparator:^NSComparisonResult(NSURL *url1,
                                                         NSURL *url2) {
      NSDate *date1, *date2;
      [url1 getResourceValue:&date1 forKey:NSURLCreationDateKey error:NULL];
      [url2 getResourceValue:&date2 forKey:NSURLCreationDateKey error:NULL];
      return [date2 compare:date1];
    }];
    logsFolderURLs_ = mutableURLs;
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];

  // Avoid silent failure if this was not added to a UINavigationController.
  //
  // The method +controllerWithTarget:selector: can be used to create a
  // temporary UINavigationController.
  NSAssert(self.navigationController != nil, @"Need a UINavigationController");
}

- (void)setOpensScrolledToEnd:(BOOL)opensScrolledToEnd {
  opensScrolledToEnd_ = opensScrolledToEnd;
}

#pragma mark -

- (NSString *)shortenedNameForURL:(NSURL *)url {
  // Remove "Processname_log_" from the start of the file name.
  NSString *name = [url lastPathComponent];
  NSString *prefix = [DCGTMSessionFetcher processNameLogPrefix];
  if ([name hasPrefix:prefix]) {
    name = [name substringFromIndex:[prefix length]];
  }
  return name;
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
  return [logsFolderURLs_ count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell *cell =
      [tableView dequeueReusableCellWithIdentifier:kHTTPLogsCell];
  if (cell == nil) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                  reuseIdentifier:kHTTPLogsCell];
    [cell.textLabel setAdjustsFontSizeToFitWidth:YES];
  }

  NSURL *url = [logsFolderURLs_ objectAtIndex:indexPath.row];
  cell.textLabel.text = [self shortenedNameForURL:url];

  return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView
    didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  NSURL *folderURL = [logsFolderURLs_ objectAtIndex:indexPath.row];
  NSString *htmlName = [DCGTMSessionFetcher htmlFileName];
  NSURL *htmlURL = [folderURL URLByAppendingPathComponent:htmlName isDirectory:NO];

  // Show the webview controller.
  NSString *title = [self shortenedNameForURL:folderURL];
  UIViewController *webViewController =
      [[DCGTMSessionFetcherLoggingWebViewController alloc] initWithURL:htmlURL
                                                               title:title
                                                  opensScrolledToEnd:opensScrolledToEnd_];

  UINavigationController *navController = [self navigationController];
  [navController pushViewController:webViewController animated:YES];

  [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark -

+ (UINavigationController *)controllerWithTarget:(id)target
                                        selector:(SEL)selector {
  UINavigationController *navController = [[UINavigationController alloc] init];
  DCGTMSessionFetcherLogViewController *logViewController =
      [[DCGTMSessionFetcherLogViewController alloc] init];
  UIBarButtonItem *barButtonItem =
      [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                    target:logViewController
                                                    action:@selector(doneButtonClicked:)];
  logViewController.navigationItem.leftBarButtonItem = barButtonItem;

  // Make a block to capture the callback and nav controller.
  void (^block)(void) = ^{
    if (target && selector) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
      [target performSelector:selector withObject:navController];
#pragma clang diagnostic pop
    }
  };
  logViewController.callbackBlock = block;

  navController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;

  [navController pushViewController:logViewController animated:NO];
  return navController;
}

- (void)doneButtonClicked:(UIBarButtonItem *)barButtonItem {
  void (^block)() = self.callbackBlock;
  block();
  self.callbackBlock = nil;
}

@end

#pragma mark - Minimal WebView Controller

@implementation DCGTMSessionFetcherLoggingWebViewController {
  BOOL opensScrolledToEnd_;
  NSURL *htmlURL_;
}

- (instancetype)initWithURL:(NSURL *)htmlURL
                      title:(NSString *)title
         opensScrolledToEnd:(BOOL)opensScrolledToEnd {
  self = [super initWithNibName:nil bundle:nil];
  if (self) {
    self.title = title;
    htmlURL_ = htmlURL;
    opensScrolledToEnd_ = opensScrolledToEnd;
  }
  return self;
}

- (void)loadView {
  UIWebView *webView = [[UIWebView alloc] init];
  webView.autoresizingMask = (UIViewAutoresizingFlexibleWidth
                              | UIViewAutoresizingFlexibleHeight);
  webView.delegate = self;
  self.view = webView;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  NSURLRequest *request = [NSURLRequest requestWithURL:htmlURL_];
  [[self webView] loadRequest:request];
}

- (void)didTapBackButton:(UIButton *)button {
  [[self webView] goBack];
}

- (UIWebView *)webView {
  return (UIWebView *)self.view;
}

#pragma mark - WebView delegate

- (void)webViewDidFinishLoad:(UIWebView *)webView {
  if (opensScrolledToEnd_) {
    // Scroll to the bottom, because the most recent entry is at the end.
    NSString* javascript = [NSString stringWithFormat:@"window.scrollBy(0, %ld);", NSIntegerMax];
    [[self webView] stringByEvaluatingJavaScriptFromString:javascript];
    opensScrolledToEnd_ = NO;
  }

  // Instead of the nav controller's back button, provide a simple
  // webview back button when it's needed.
  BOOL canGoBack = [webView canGoBack];
  UIBarButtonItem *backItem = nil;
  if (canGoBack) {
    // This hides the nav back button.
    backItem = [[UIBarButtonItem alloc] initWithTitle:@"⏎"
                                                style:UIBarButtonItemStylePlain
                                               target:self
                                               action:@selector(didTapBackButton:)];
  }
  self.navigationItem.leftBarButtonItem = backItem;
}

@end

#endif  // !STRIP_DCGTM_FETCH_LOGGING && !STRIP_DCGTM_SESSIONLOGVIEWCONTROLLER