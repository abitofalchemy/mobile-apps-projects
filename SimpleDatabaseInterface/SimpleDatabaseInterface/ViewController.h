//
//  ViewController.h
//  SimpleDatabaseInterface
//
//  Created by Salvador Aguinaga on 9/12/14.
//  Copyright (c) 2014 abitofalchemy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MySQLAuthentication.h"

@interface ViewController : UIViewController <AuthenticationDelegate>
{
    UITextField *username;
    UITextField *passwordTextField;
    UITextField *phoneNumber;
    BOOL        retVal;
    UILabel* headerLabel;


}
@property(nonatomic, weak) UITextField *username;
@property(nonatomic, weak) UITextField *passwordTextField;
@property(nonatomic, weak) UITextField *phoneNumber;
@property(nonatomic, weak) UILabel* headerLabel;

@end
