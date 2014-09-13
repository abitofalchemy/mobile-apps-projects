//
//  MySQLAuthentication.m
//  SimpleDatabaseInterface
//
//  Created by Salvador Aguinaga on 9/12/14.
//  Copyright (c) 2014 abitofalchemy. All rights reserved.
//

#import "MySQLAuthentication.h"

@implementation MySQLAuthentication
{
    NSDictionary *requestParameters;
    NSMutableDictionary *resultParameters;
}

@synthesize authenticationDelegate;
- (id)initWithFrame:(CGRect)frame {
    NSLog(@"MySQLAuthentication initWithframe");
    
    self = [super initWithFrame:frame];
    if (self) {
        // Set UIWebViewDelegate to self
        //
        // When https requests are made to this UIWebView, the delegate methods
        // in this class will be called to handle the responses.
        self.delegate = self;
    }
    return self;
}

/**
 * This is the entry method to the class. It builds the URL and executes
 * the token request
 */
- (void)getToken: (NSDictionary *)request {
    NSLog(@"MySQLAuthentication getToken");
    
    requestParameters = request;
    
    // Build the initial request URL. We store this globally to the class
    // because a failed request may be retried, and no request variables would
    // have changed.
    //
    // Note that parameters with special characters must be URL Encoded. In
    // this case, the redirectUrl contains slashes so it is encoded.
    
    NSURL *myUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@"
                                         @"/loginUser?username=%@"
                                         @"&password=%@",
                                         requestParameters[@"authenticatingServerBaseUrl"],
                                         requestParameters[@"username"],
                                         requestParameters[@"password"]]
                    ];
    
    
    NSMutableURLRequest *myRequest = [NSMutableURLRequest requestWithURL:myUrl
                                                             cachePolicy:NSURLCacheStorageAllowed
                                                         timeoutInterval:60.0];
    
    [myRequest setHTTPShouldHandleCookies:YES];
    
    [self loadRequest:myRequest];
}
- (void) postToken: (NSDictionary *)request {
    NSLog(@"MySQLAuthentication postToken");
    
    requestParameters = request;
    
    // Build the initial request URL. We store this globally to the class
    // because a failed request may be retried, and no request variables would
    // have changed.
    //
    // Note that parameters with special characters must be URL Encoded. In
    // this case, the redirectUrl contains slashes so it is encoded.
    
    NSString *urlString = [NSString stringWithFormat:@"%@"
                           @"/addCLTestResult?userid=%@"
                           @"&facility_id=%@"
                           @"&result_value=%@"
                           @"&result_date=%@"
                           @"&product_id=%@"
                           @"&lot_number=%@"
                           @"&test_notes=%@",
                           requestParameters[@"authenticatingServerBaseUrl"],
                           requestParameters[@"userId"],
                           requestParameters[@"facilityId"],
                           requestParameters[@"resultValue"],
                           requestParameters[@"resultDate"],
                           requestParameters[@"productId"],
                           requestParameters[@"lotNumber"],
                           requestParameters[@"testNotes"]];
    
    // 14Aug14/SA: Added a mechanism to avoid problems with the html post string
    NSString* urlTextEscaped = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *newUrl = [NSURL URLWithString: urlTextEscaped];
    NSLog(@"newUrl:%@", newUrl);
    
    NSMutableURLRequest *myRequest = [NSMutableURLRequest requestWithURL:newUrl
                                                             cachePolicy:NSURLCacheStorageAllowed
                                                         timeoutInterval:60.0];
    
    [myRequest setHTTPShouldHandleCookies:YES];
    
    [self loadRequest:myRequest];
}


/**
 * After a URL request is created, but before the request is made, this
 * callback method executes. Inspect the URL to see what the request is.
 * During sign in, a series of "redirects" are sent to the UIWebView "browser",
 * and each executes as soon as it is sent. We want to watch for the
 * "Redirect URI" - because it is not meant to be called, but instead contains
 * the token and other information that we requested.
 */
- (BOOL)webView: (UIWebView *)webView
shouldStartLoadWithRequest: (NSURLRequest *)request
 navigationType: (UIWebViewNavigationType)navigationType
{
    
    //NSLog(@"Loading:  %@",request.URL.absoluteString);
    
    
    NSURLConnection *conn = [NSURLConnection connectionWithRequest:request delegate:self];
    if (conn == nil) {
        NSLog(@"cannot create connection");
    }
    //
    // Search for the redirect URI in the request URI. It should be at
    // position 0. If not found, return "YES" to allow the request to be made.
    //    if ([[request.URL.absoluteString lowercaseString]
    //         rangeOfString:[requestParameters[@"redirectUrl"]
    //                        lowercaseString]].location != 0)
    //    {
    //
    //             return YES;
    //
    //         // If the redirect URI was found, parse the parameters and return
    //         // "NO" because we do not want to load the redirect URI in the
    //         // browser.
    //         } else {
    
    //             NSArray *urlArray = [request.URL.absoluteString
    //                                  componentsSeparatedByString:@"#"];
    //             NSArray *parameterArray = [NSArray new];
    //             resultParameters = [NSMutableDictionary new];
    //
    //             // Parse the token and other parameters from the URI string
    //             if ([urlArray count] > 0) {
    //                parameterArray = [urlArray[1] componentsSeparatedByString:@"&"];
    //                for (NSString *item in parameterArray) {
    //                     [resultParameters
    //                        setObject:[item
    //                        componentsSeparatedByString:@"="][1]
    //                        forKey:[item componentsSeparatedByString:@"="][0]];
    //                }
    //             }
    return YES;
    
    //         }
}

/**
 * Fires when loading of data from the http request begins - and turns on the
 * activity indicator.
 */
- (void)webViewDidStartLoad:(UIWebView *)webView {
    NSLog(@"MySQLAuthentication  webViewDidStartLoad");
    
    [authenticationDelegate displayActivityIndicator];
}

/**
 * Fires when loading of data from the http request is complete - and turns off
 * the activity indicator. If the internet is disconnected, leave the activity
 * spinner in place and display a message.
 */
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    NSLog(@"MySQLAuthentication  webViewDidFinishLoad");
    
    NSString *someHTML = [webView stringByEvaluatingJavaScriptFromString:@"document.body.innerHTML"];
    NSLog(@"webView Did Finish Load :: %@", someHTML);//
    NSError *error = nil;
    NSData *jsonData = [[self convertHTML:someHTML] dataUsingEncoding:NSASCIIStringEncoding];
    NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:jsonData
                                                             options:kNilOptions error:&error];
    
    resultParameters = [[NSMutableDictionary alloc] initWithDictionary:jsonDict];
    
    //NSLog(@"JSON: %@",[jsonDict objectForKey:@"customer_id"]);
    
    
    NSRange start,end;
    start = [someHTML rangeOfString:@">"];
    end   = [[someHTML substringFromIndex:start.location] rangeOfString:@"<"];
    
    NSString *cloudRecordUID = [someHTML substringWithRange:NSMakeRange(start.location+1, end.location -1)];
    if (jsonDict)
    {
        if ([[jsonDict valueForKey:@"customer_id"] isEqualToNumber:[NSNumber numberWithBool:NO]])
            [self authenticationFailure];
        else {
            [authenticationDelegate hideActivityIndicator];
            [self removeFromSuperview];
            NSLog(@"webViewDidFinishLoad : cloudRecordUID: %@", cloudRecordUID);
            [self authenticationComplete];
        }
        
    }   else if ([cloudRecordUID isEqualToString:@""])
        [self authenticationFailure];
    else {
        resultParameters = [[NSMutableDictionary alloc] initWithObjects:@[cloudRecordUID] forKeys:@[@"cloudRecordUID"]];
        [authenticationDelegate hideActivityIndicator];
        [self removeFromSuperview];
        NSLog(@"webViewDidFinishLoad :: %@", cloudRecordUID);
        [self authenticationComplete];
    }
    
    
    
    
}

/**
 * This UIWebView delegate fires when the load completes with a network error.
 * However, error 102 is actually a success condition - when the URL to be
 * loaded is the redirect URI. Other error conditions display a message.
 */
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    NSLog(@"MySQLAuthentication didFailLoadWithError");
    
    // This error was created by the "shouldStartLoadWithRequest" method above
    // by returning "NO" on purpose. We returned "NO" because we intercepted the
    // redirect URI in the returned URL, which, and it indicates that the token
    // (or an error message) have been received.
    //    [UIView animateWithDuration:3.0 animations:^{
    //
    //    }];
    
    switch  (error.code) {
        case 102:
            [self loadRequest:[NSURLRequest
                               requestWithURL:[NSURL URLWithString:@"about:blank"]]];
            [self authenticationComplete];
            // Sign in failed for an unknown reason. Display an error message. Note
            // that failure to connect to the internet is already handled so this
            // condition should never occur unless a bug in the code messes up the
            // URL request. If it does happen, it displays an error message in an
            // alert box for the developer to see.
            break;
        case -1009:
            NSLog(@"Unexpected error.code = %i, %@",error.code, error.debugDescription);
            [[[UIAlertView alloc] initWithTitle:@"Connection Error"
                                        message:error.localizedDescription
                                       delegate:nil
                              cancelButtonTitle:@"Dismiss"
                              otherButtonTitles:nil, nil] show];
            break;
        default:
            NSLog(@"Unexpected error.code = %i,\n%@",error.code,error.debugDescription);
            break;
    }
    
    [authenticationDelegate hideActivityIndicator];
    [self removeFromSuperview];
    
    
    
}

/**
 * We are done. Notify the parent UIViewController that we have token.
 */
- (void)authenticationComplete {
    NSLog(@"MySQLAuthentication authenticationComplete");
    NSLog(@"MySQLAuthentication resultParameters: %@", resultParameters);
    
    [authenticationDelegate authenticatedSuccess: YES result:resultParameters];
}

/**
 * We don't do anything special with a timeout failure - just pass through to
 * authenticationFailure. However, you could add code to restart the login
 * automatically for a second try.
 */
- (void)requestTimedOut {
    NSLog(@"MySQLAuthentication requestTimedOut");
    
    [self authenticationFailure];
}

/**
 * We failed to get a token and/or the internet connection was lost during the
 * attempt. If it was the internet connection that was lost, then you have to
 * kill the UIWebView's loading attempt.
 */
- (void)authenticationFailure {
    NSLog(@"MySQLAuthentication authenticationFailure!!");
    
    [self stopLoading];
    [authenticationDelegate hideActivityIndicator];
    [self removeFromSuperview];
    
    [[[UIAlertView alloc] initWithTitle:@"Error Authenticating"
                                message:@"Invalid input - Please try again!"
                               delegate:nil
                      cancelButtonTitle:@"Dismiss"
                      otherButtonTitles:nil, nil] show];
    
    [authenticationDelegate authenticatedSuccess: NO result:resultParameters];
    
}

/**
 * Method added to NSString to perform URLEncoding.
 *
 * Apple's built in method, stringByAddingPercentEscapesUsingEncoding, does not
 * encode "/" or "&", which is a known bug. So we roll our own here.
 */
-(NSString*) urlEncode: (NSString *)string
{
    NSString *encodedString = (NSString *)CFBridgingRelease(
                                                            CFURLCreateStringByAddingPercentEscapes(
                                                                                                    NULL,
                                                                                                    (CFStringRef)string,
                                                                                                    NULL,
                                                                                                    (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                                                    kCFStringEncodingUTF8 ));
    return encodedString;
}
-(NSString *)convertHTML:(NSString *)html {
    
    NSScanner *myScanner;
    NSString *text = nil;
    myScanner = [NSScanner scannerWithString:html];
    
    while ([myScanner isAtEnd] == NO) {
        
        [myScanner scanUpToString:@"<" intoString:NULL] ;
        
        [myScanner scanUpToString:@">" intoString:&text] ;
        
        html = [html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>", text] withString:@""];
    }
    //
    html = [html stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    return html;
}
@end
