//
//  ServerRunningViewController.m
//  Mobile Touch
//
//  Created by Samuel Scott Robbins on 10/5/14.
//  Copyright (c) 2014 Scott Robbins. All rights reserved.
//

#import "ServerRunningViewController.h"
#import "ServerBrowserTableViewController.h"
#import "AppDelegate.h"
#import "Server.h"

@interface ServerRunningViewController () < UITextFieldDelegate>

@end

@implementation ServerRunningViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.sendTextField.delegate = self;
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
   
    if (appDelegate.connectedToService) {
        // do stuff here
    } else {
        [self presentViewControllerToSelectService];
    }
    
    // receive notification of message
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(messageReceived:)
                                                 name:@"MessageReceived"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(selectService:)
                                                 name:@"ConnectionLost"
                                               object:nil];

}

- (void)presentViewControllerToSelectService
{
    ServerBrowserTableViewController *viewController = (ServerBrowserTableViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"ServerBrowserTableViewController"];
    
    [self.navigationController presentViewController:viewController animated:YES completion:nil];
}

- (void)selectService:(NSNotification *)notification {
    // Bring up available connections
    [self presentViewControllerToSelectService];
}

- (void)messageReceived: (NSNotification *)notification {
    NSDictionary *respondeDict = [notification userInfo];
    if ([respondeDict objectForKey:@"message"]) {
        NSString *message = [respondeDict valueForKey:@"message"];
        self.receivedTextView.text = message;
    }
    
}

- (IBAction)textFieldDidEndEditing:(UITextField *)textField {
    [textField resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)sendButtonClicked:(id)sender {
    NSDictionary *sendDataDict = [NSDictionary dictionaryWithObject:self.sendTextField.text forKey:@"message"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"MessageSending" object:nil userInfo:sendDataDict];
}

@end
