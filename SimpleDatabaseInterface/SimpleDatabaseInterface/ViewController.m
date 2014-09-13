//
//  ViewController.m
//  SimpleDatabaseInterface
//
//  Created by Salvador Aguinaga on 9/12/14.
//  Copyright (c) 2014 abitofalchemy. All rights reserved.
//

#import "ViewController.h"

#define CLOUD_SERVER_URL @"http://dsg1.crc.nd.edu/apiConnect.svc"

@interface ViewController ()

@end

@implementation ViewController
{
    // The custom UIWebView that will handle the authentication.
    MySQLAuthentication *authenticationWebView;
    
    // The activity indicator (spinner) to inform the user that the
    // authentication process is busy communicating with the server.
    UIActivityIndicatorView *activityIndicator;
}
@synthesize username          = _username;
@synthesize phoneNumber       = _phoneNumber;
@synthesize passwordTextField = _passwordTextField;
@synthesize headerLabel       = _headerLabel;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    CGRect headerLabelFrame = CGRectMake(20.0f, 60, 280.0f, 31.0f);
    headerLabel = [[UILabel alloc] initWithFrame:headerLabelFrame];
    headerLabel.text = @"Login to MySQL DB";
    headerLabel.textColor = [UIColor darkTextColor];
    [self.view addSubview:headerLabel];
    
    CGRect passwordTextFieldFrame = CGRectMake(20.0f, 100.0f, 280.0f, 31.0f);
    username = [[UITextField alloc] initWithFrame:passwordTextFieldFrame];
    username.placeholder = @"Username";
    username.backgroundColor = [UIColor whiteColor];
    username.textColor = [UIColor blackColor];
    username.font = [UIFont systemFontOfSize:14.0f];
    username.borderStyle = UITextBorderStyleRoundedRect;
    username.clearButtonMode = UITextFieldViewModeWhileEditing;
    username.returnKeyType = UIReturnKeyDone;
    username.textAlignment = NSTextAlignmentLeft;
    username.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    username.tag = 1;
    username.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [self.view addSubview:username];
    
    passwordTextField = [[UITextField alloc] initWithFrame:passwordTextFieldFrame];
    passwordTextField.placeholder = @"Password";
    passwordTextField.backgroundColor = [UIColor whiteColor];
    passwordTextField.textColor = [UIColor blackColor];
    passwordTextField.font = [UIFont systemFontOfSize:14.0f];
    passwordTextField.borderStyle = UITextBorderStyleRoundedRect;
    passwordTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    passwordTextField.returnKeyType = UIReturnKeyDone;
    passwordTextField.textAlignment = NSTextAlignmentLeft;
    passwordTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    passwordTextField.tag = 2;
    passwordTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [self.view addSubview:passwordTextField];
    [passwordTextField setCenter:CGPointMake(username.center.x, username.center.y + passwordTextField.frame.size.height*1.5)];
    
    phoneNumber = [[UITextField alloc] initWithFrame:passwordTextFieldFrame];
    phoneNumber.placeholder = @"(574) 333 0123";
    phoneNumber.backgroundColor = [UIColor whiteColor];
    phoneNumber.textColor = [UIColor blackColor];
    phoneNumber.font = [UIFont systemFontOfSize:14.0f];
    phoneNumber.borderStyle = UITextBorderStyleRoundedRect;
    phoneNumber.clearButtonMode = UITextFieldViewModeWhileEditing;
    phoneNumber.keyboardType = UIKeyboardTypeNamePhonePad;
    phoneNumber.returnKeyType = UIReturnKeyDone;
    phoneNumber.textAlignment = NSTextAlignmentLeft;
    phoneNumber.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    phoneNumber.tag = 3;
    phoneNumber.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [self.view addSubview:phoneNumber];
    [phoneNumber setCenter:CGPointMake(passwordTextField.center.x, passwordTextField.center.y + phoneNumber.frame.size.height*1.5)];
    
    CGRect buttonFrame = CGRectMake(0, 0, 160.0, 50.0);

    UIButton* submitButton = [[UIButton alloc] initWithFrame:CGRectZero];
    submitButton.frame = buttonFrame;
    submitButton.backgroundColor = [UIColor blueColor];
    submitButton.titleLabel.textColor = [UIColor whiteColor];
    [submitButton setTitle:@"Submit" forState:UIControlStateNormal];
    [submitButton addTarget:self action:@selector(submitLogin:)
           forControlEvents:(UIControlEventTouchUpInside)];
    submitButton.layer.borderColor = [UIColor blueColor].CGColor;
    submitButton.layer.borderWidth = 2.0;
    submitButton.layer.cornerRadius = 8.0;
    [self.view addSubview:submitButton];
    [submitButton setCenter:self.view.center];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - TextField delegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.username resignFirstResponder];
    return YES;
}
#pragma mark - Button Action Methods
-(void) submitLogin:(UIButton*) sender
{
    NSLog(@"You've pressed the Submit button");
    
    if ([self validateBasicInputForTextFields])
        return; // there is a problem
    
    // Query the Server
    if ([self userInCloudStoreWithEmail:username.text
                           plusPassword:passwordTextField.text])
    {
        
    } else {
        
    }
    
}
-(BOOL) validateBasicInputForTextFields
{
    if ([username.text isEqualToString:@""] || [phoneNumber.text isEqualToString:@""] || [passwordTextField.text isEqualToString:@""])
    {
        // if either of the fields is empty return an error
        headerLabel.text = @"One of your input fields is empty";
        headerLabel.layer.shadowColor = [UIColor blueColor].CGColor;
        headerLabel.layer.shadowOffset = CGSizeMake(1.0,1.0);
        headerLabel.layer.shadowRadius = 5.0;
        headerLabel.layer.shadowOpacity = 0.9;
        
        return YES;
    } else
        return NO;
}
#pragma mark - TextField delegate methods
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    NSString *nameTextField;
    
    nameTextField = username.text;
    
    if ( [self isUsernameNew:username.text])
    {
        //[loginBtnLabel replaceObjectAtIndex:0 withObject:@"Register"];
        //[self.tableView reloadData];
        //self.tableView set[username setText:nameTextField];
        //[self reloadSection:1 withRowAnimation:UITableViewRowAnimationNone];
        //NSLog(@"[ Register Email]");
    }
}
/**
 * Display the Activity Indicator. This is a delagate method from
 * OCLC_AuthenticationUIWebView.
 */
- (void) displayActivityIndicator {
    [self.view addSubview:activityIndicator];
}

/**
 * Hide the Activity Indicator. This is a delagate method from
 * OCLC_AuthenticationUIWebView.
 */
- (void) hideActivityIndicator {
    [activityIndicator removeFromSuperview];
}
- (void) displayNoAuthenticationParametersMessage {
    
    NSLog(@"NO AUTHENTICATION PARAMETERS");
    return;
}
/**
 * This callback is executed when the UIWebView has completed the token request.
 * We dispose of the UIWebView and display the results.
 *
 * @success - A boolean. If false, a timeout or loss of connection may have
 *            occured. In that case, result may be null.
 *
 * @result - NSDictionary object containing the parameters and values that
 *           were returned on the redirect URI.
 */
- (void)authenticatedSuccess:(BOOL)success
                      result:(NSMutableDictionary *)result {
    //NSLog(@"\n\n%d\n%@\n\n",success,result);
    
    //    _resultParameters = result;
    //
    //    // Start the Access Token expiration timer if an "expires_in" parameter was
    //    // returned.
    //    if ([result objectForKey:@"expires_in"] != nil) {
    //
    //        accessTokenTimeRemaining =
    //        [[result objectForKey:@"expires_in"] floatValue];
    //
    //        // Make sure the timer wasn't already defined. If so, null it out.
    //        if (accessTokenExpirationTimer.isValid) {
    //            [accessTokenExpirationTimer invalidate];
    //        }
    //
    //        // Create a new 1 second long, repeating timer so we can count down the
    //        // remaining seconds in the access token's lifetime.
    //        // Calls decrementAccessTokenTimer: below every second when active.
    //        accessTokenExpirationTimer = [NSTimer
    //                                      scheduledTimerWithTimeInterval:1.0
    //                                      target:self
    //                                      selector:@selector(decrementAccessTokenTimer:)
    //                                      userInfo:nil
    //                                      repeats:YES];
    //
    //        // If no token time remaining was sent, display a "n/a" message
    //    } else {
    //        [accessTokenTimeRemainingLabel
    //         setText: @"Error in Authentication Process"];
    //    }
    //
    //    // Dispose of the custom UIWebView.
    //    // We use the webview once for signing in. To sign in again, we create a
    //    // new one. They are not meant for re-use!
    //    [authenticationWebView removeFromSuperview];
    //    authenticationWebView = nil;
    //
    //    // Create the resultParametersLabel if it does not exist
    //    if (resultParametersLabel == nil) {
    //        resultParametersLabel = [[UILabel alloc]
    //                                 initWithFrame:CGRectMake
    //                                 (10, 20, self.view.frame.size.width - 20,
    //                                  self.view.frame.size.height - 100)];
    //        [resultParametersLabel
    //         setFont:[UIFont fontWithName:@"Courier New" size:11.0f]];
    //        [resultParametersLabel setTextColor:[UIColor blackColor]];
    //        resultParametersLabel.numberOfLines=20;
    //        [self.view addSubview:resultParametersLabel];
    //    }
    
    // Display the result parameters on the iPhone screen.
    if (success) {
        NSLog(@"%@", [result objectForKey:@"facilities"]);
        
    } else {
        //resultParametersLabel.text =
        //[NSString stringWithFormat:@"FAILURE\n%@",result];
        //isAccessTokenValid = NO;
        
        NSLog(@"%@",[NSString stringWithFormat:@"FAILURE\n%@",result]);
        return;
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

//
- (BOOL) isUserInNSUserDefaults: (NSString *)user havingPassword: (NSString *)pass
{
    BOOL returnVal = NO;
    // look for the saved search location in NSUserDefaults
    //NSLog(@"isUserInNSUserDefuaults");
    NSUserDefaults *userInLocal = [NSUserDefaults standardUserDefaults];
    NSString *adminKey = [userInLocal objectForKey:@"adminUser"];
    NSString *passwKey = [userInLocal objectForKey:@"adminPass"];
    
    if (adminKey == nil || passwKey == nil) {
        returnVal = NO;
    } else {
        if (![adminKey isEqualToString:user] )
        {
            returnVal = NO;
        } else if (![passwKey isEqualToString:pass]){
            returnVal = NO;
        } else {
            
            //if ([adminKey isEqualToString:user] && [passwKey isEqualToString:pass]) {
            NSLog(@"*** in NSUserDefaults and a match ***");
            returnVal = YES;
        }
        
    }
    return returnVal;
}

- (BOOL) isUsernameNew: (NSString *)userStr
{   // is username (admin) text entered a new user?
    retVal = NO;
    
    NSUserDefaults *userInLocal = [NSUserDefaults standardUserDefaults];
    NSString *adminKey = [userInLocal objectForKey:@"adminUser"];
    if ([adminKey isEqualToString:userStr] )
    {
        return NO;
    } else {
        // user must be new
        
        
        return retVal;
    }
}

- (BOOL) userInCloudStoreWithEmail:(NSString *)emailStr
                      plusPassword:(NSString*)passwordStr
{
    // Load the authentication parameters into _requestParameters.
    NSDictionary *requestParameters = [[NSDictionary alloc]
                                       initWithObjects:@[CLOUD_SERVER_URL,emailStr,passwordStr]
                                       forKeys:@[@"authenticatingServerBaseUrl",@"username",@"password"]];
    
    NSLog(@"\n\n**************\n%@\n**************\n\n",requestParameters);
    
    // If the parameters are null, the user probably forgot to set them
    // in the authenticationList.plist properties file.
    if ([requestParameters[@"username"] isEqualToString:@""] ||
        [requestParameters[@"password"] isEqualToString:@""] )
    {
        
        [self displayNoAuthenticationParametersMessage];
        
    } else {
        
        // Create our custom UIWebView so that it fills the iPhone screen.
        authenticationWebView = [[MySQLAuthentication alloc]
                                 initWithFrame:CGRectMake
                                 (0, 20, self.view.frame.size.width,
                                  self.view.frame.size.height-100)];
        
        // Our custom UIWebView has a delegate so that it can tell this class that
        // it is done authenticating.
        authenticationWebView.authenticationDelegate = self;
        authenticationWebView.layer.cornerRadius = 8.0;
        authenticationWebView.layer.borderWidth  = 2.0;
        authenticationWebView.layer.borderColor  = [UIColor whiteColor].CGColor;
        [authenticationWebView setBackgroundColor:[UIColor clearColor]];
        [authenticationWebView setAlpha:0.5f];
        
        // Add our custom UIWebView to this view controllers screen.
        [self.view addSubview:authenticationWebView];
        
        // Make the token request.
        [authenticationWebView getToken:requestParameters];
        
        // Add activity spinner.
        activityIndicator =
        [[UIActivityIndicatorView alloc]
         initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        activityIndicator.frame =CGRectMake(self.view.frame.size.width/2-25,
                                            self.view.frame.size.height/2-50,50,50);
        
        activityIndicator.color = [UIColor grayColor];
        
        [activityIndicator startAnimating];
    }
    
    return NO;
}


@end
