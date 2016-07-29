/*
 * Copyright (c) Microsoft Corporation. All rights reserved.
 */

#import "AVASenderUtils.h"

@implementation AVASenderUtils

+ (BOOL)isRecoverableError:(NSInteger)statusCode {
  return statusCode >= 500 || statusCode == 408 || statusCode == 429;
}

+ (NSInteger)getstatusCode:(NSURLResponse *)response {
  NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
  return httpResponse.statusCode;
}

+ (BOOL)isNoInternetConnectionError:(NSError *)error {
  return ([error.domain isEqualToString:NSURLErrorDomain] && (error.code == NSURLErrorNotConnectedToInternet));
}

+ (BOOL)isRequestCanceledError:(NSError *)error {
  return ([error.domain isEqualToString:NSURLErrorDomain] && (error.code == NSURLErrorCancelled));
}

@end
