//
//  ViewController.m
//  SimpleDatabaseInterface
//
//  Created by Salvador Aguinaga on 9/12/14.
//  Copyright (c) 2014 abitofalchemy. All rights reserved.
//

#import "ViewController.h"

#define CLOUD_SERVER_URL @"http://ec2-23-23-18-45.compute-1.amazonaws.com"

@interface ViewController ()

@end

@implementation ViewController
{
    // The custom UIWebView that will handle the authentication.
    MySQLAuthentication *authenticationWebView;
    
    // The activity indicator (spinner) to inform the user that the
    // authentication process is busy communicating with the server.
    UIActivityIndicatorView *activityIndicator;
    
    UIButton* loginButton;
    UIButton* registerButton;
    UInt16 buttonSelected;
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
    headerLabel.text = @"Login or Register (MySQL)";
    headerLabel.textAlignment = NSTextAlignmentCenter;
    headerLabel.textColor = [UIColor darkTextColor];
    [self.view addSubview:headerLabel];
    [headerLabel setCenter:CGPointMake(self.view.center.x, headerLabel.center.y)];
    
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

    loginButton = [[UIButton alloc] initWithFrame:CGRectZero];
    loginButton.frame = buttonFrame;
    loginButton.backgroundColor = [UIColor blueColor];
    loginButton.titleLabel.textColor = [UIColor whiteColor];
    [loginButton setTitle:@"Login" forState:UIControlStateNormal];
    [loginButton addTarget:self action:@selector(submitLogin:)
           forControlEvents:(UIControlEventTouchUpInside)];
    loginButton.layer.borderColor = [UIColor blueColor].CGColor;
    loginButton.layer.borderWidth = 2.0;
    loginButton.layer.cornerRadius = 8.0;
    loginButton.tag = 10;
    [self.view addSubview:loginButton];
    [loginButton setCenter:self.view.center];
    
    registerButton = [[UIButton alloc] initWithFrame:CGRectZero];
    registerButton.frame = buttonFrame;
    registerButton.backgroundColor = [UIColor blueColor];
    registerButton.titleLabel.textColor = [UIColor whiteColor];
    [registerButton setTitle:@"Register" forState:UIControlStateNormal];
    [registerButton addTarget:self action:@selector(submitLogin:)
          forControlEvents:(UIControlEventTouchUpInside)];
    registerButton.layer.borderColor = [UIColor blueColor].CGColor;
    registerButton.layer.borderWidth = 2.0;
    registerButton.layer.cornerRadius = 8.0;
    registerButton.tag = 11;
    [self.view addSubview:registerButton];
    [registerButton setCenter:CGPointMake(loginButton.center.x, self.view.center.y + 1.2*registerButton.frame.size.height)];
    
    [username setHidden:YES];
    [passwordTextField setHidden:YES];
    [phoneNumber setHidden:YES];
    
    buttonSelected = 0;
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
    NSLog(@"tag = %d", sender.tag);
    if (sender.tag == 10)
    {
        [registerButton setHidden:YES];
        headerLabel.text = @"Login (MySQL Back-end)";

        if (buttonSelected == 0){
            buttonSelected = 1;
            [username setHidden:NO];
            [passwordTextField setHidden:NO];
        } else if (buttonSelected == 1) {
            if ([self validateBasicInputForTextFields])
                return; // there is a problem
            [self loginUserAction];
            

        }
    }
    else {
        [loginButton setHidden:YES];
        headerLabel.text = @"Register (MySQL Back-end)";

        if (buttonSelected == 0){
            buttonSelected = 1;
            [username setHidden:NO];
            [passwordTextField setHidden:NO];
        } else if (buttonSelected == 1) {
            if ([self validateBasicInputForTextFields])
                return; // there is a problem
            [self registerUserWithEmail:username.text
                           plusPassword:passwordTextField.text]; 
        }
    }
    
    
    /* Query the Server
    */
    
}
-(void) loginUserAction {
    
    NSLog(@"You've pressed the Login button");
    if ([self userInCloudStoreWithEmail:username.text
                           plusPassword:passwordTextField.text])
    {
        
    } else {
        
    }
}
-(void) registerUserWithEmail:(NSString *)emailStr
                 plusPassword:(NSString*)passwordStr
{

    NSLog(@"You've pressed the Register button");
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
        
        // Make the token POSt request.
        [authenticationWebView postToken:requestParameters];
        
        // Add activity spinner.
        activityIndicator =
        [[UIActivityIndicatorView alloc]
         initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        activityIndicator.frame =CGRectMake(self.view.frame.size.width/2-25,
                                            self.view.frame.size.height/2-50,50,50);
        
        activityIndicator.color = [UIColor grayColor];
        
        [activityIndicator startAnimating];
    }
    
}

-(BOOL) validateBasicInputForTextFields
{
    if ([username.text isEqualToString:@""] /*|| [phoneNumber.text isEqualToString:@""] */|| [passwordTextField.text isEqualToString:@""])
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
                      result:(NSMutableDictionary *)result
{
    // Display the result parameters on the iPhone screen.
    if (success) {
        NSLog(@"results");
        [username setHidden:YES];
        [passwordTextField setHidden:YES];
        [loginButton setHidden:YES];
        [headerLabel setText:@"Successful Login"];
        
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
