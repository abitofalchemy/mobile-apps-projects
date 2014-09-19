//
//  MySQLAuthentication.h
//  SimpleDatabaseInterface
//
//  Created by Salvador Aguinaga on 9/12/14.
//  Copyright (c) 2014 abitofalchemy. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol AuthenticationDelegate <NSObject>
- (void)authenticatedSuccess: (BOOL) success result: (NSDictionary *) result;
- (void)registrationSuccess: (BOOL) success result: (NSString *) result;
- (void)displayActivityIndicator;
- (void)hideActivityIndicator;
@end


@interface MySQLAuthentication : UIWebView <UIWebViewDelegate> {
    id <AuthenticationDelegate> authenticationDelegate;
}
// The delegate for handling the authenticatedSuccess and activity indicator
// callbacks
@property (strong, nonatomic) id <AuthenticationDelegate>authenticationDelegate;

// Entry point to the class. Initiates a token request and returns the result
// using the authenticatedSuccess delegate method.
//
// Request parameters are passed in an NSDictionary object
- (void) getToken:  (NSDictionary *)request;
- (void) postToken: (NSDictionary *)request;

@end
