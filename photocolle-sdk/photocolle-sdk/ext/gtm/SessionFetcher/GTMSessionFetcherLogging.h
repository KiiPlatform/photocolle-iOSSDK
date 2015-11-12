/* Copyright 2014 Google Inc. All rights reserved.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
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

#import "GTMSessionFetcher.h"

// DCGTM HTTP Logging
//
// All traffic using DCGTMSessionFetcher can be easily logged.  Call
//
//   [DCGTMSessionFetcher setLoggingEnabled:YES];
//
// to begin generating log files.
//
// Log files are put into a folder on the desktop called "DCGTMHTTPDebugLogs"
// unless another directory is specified with +setLoggingDirectory.
//
// In the iPhone simulator, the default logs location is the user's home
// directory in ~/Library/Application Support.  On the iPhone device, the
// default logs location is the application's documents directory on the device.
//
// Tip: use the Finder's "Sort By Date" to find the most recent logs.
//
// Each run of an application gets a separate set of log files.  An html
// file is generated to simplify browsing the run's http transactions.
// The html file includes javascript links for inline viewing of uploaded
// and downloaded data.
//
// A symlink is created in the logs folder to simplify finding the html file
// for the latest run of the application; the symlink is called
//
//   AppName_http_log_newest.html
//
// For better viewing of XML logs, use Camino or Firefox rather than Safari.
//
// Each fetcher may be given a comment to be inserted as a label in the logs,
// such as
//   [fetcher setCommentWithFormat:@"retrieve item %@", itemName];
//
// Projects may define STRIP_DCGTM_FETCH_LOGGING to remove logging code.

#if !STRIP_DCGTM_FETCH_LOGGING

@interface DCGTMSessionFetcher (DCGTMSessionFetcherLogging)

// Note: the default logs directory is ~/Desktop/DCGTMHTTPDebugLogs; it will be
// created as needed.  If a custom directory is set, the directory should
// already exist.
+ (void)setLoggingDirectory:(NSString *)path;
+ (NSString *)loggingDirectory;

// client apps can turn logging on and off
+ (void)setLoggingEnabled:(BOOL)isLoggingEnabled;
+ (BOOL)isLoggingEnabled;

// client apps can turn off logging to a file if they want to only check
// the fetcher's log property
+ (void)setLoggingToFileEnabled:(BOOL)isLoggingToFileEnabled;
+ (BOOL)isLoggingToFileEnabled;

// client apps can optionally specify process name and date string used in
// log file names
+ (void)setLoggingProcessName:(NSString *)processName;
+ (NSString *)loggingProcessName;

+ (void)setLoggingDateStamp:(NSString *)dateStamp;
+ (NSString *)loggingDateStamp;

// client apps can specify the directory for the log for this specific run,
// typically to match the directory used by another fetcher class, like:
//
//   [DCGTMSessionFetcher setLogDirectoryForCurrentRun:[DCGTMHTTPFetcher logDirectoryForCurrentRun]];
//
// Setting this overrides the logging directory, process name, and date stamp when writing
// the log file.
+ (void)setLogDirectoryForCurrentRun:(NSString *)logDirectoryForCurrentRun;
+ (NSString *)logDirectoryForCurrentRun;

// Prunes old log directories that have not been modified since the provided date.
// This will not delete the current run's log directory.
+ (void)deleteLogDirectoriesOlderThanDate:(NSDate *)date;

// internal; called by fetcher
- (void)logFetchWithError:(NSError *)error;
- (NSInputStream *)loggedInputStreamForInputStream:(NSInputStream *)inputStream;
- (DCGTMSessionFetcherBodyStreamProvider)loggedStreamProviderForStreamProvider:
    (DCGTMSessionFetcherBodyStreamProvider)streamProvider;

// internal; accessors useful for viewing logs
+ (NSString *)processNameLogPrefix;
+ (NSString *)symlinkNameSuffix;
+ (NSString *)htmlFileName;

@end

#endif  // !STRIP_DCGTM_FETCH_LOGGING