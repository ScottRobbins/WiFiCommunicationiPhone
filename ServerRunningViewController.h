//
//  ServerRunningViewController.h
//  Mobile Touch
//
//  Created by Samuel Scott Robbins on 10/5/14.
//  Copyright (c) 2014 Scott Robbins. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ServerRunningViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextView *receivedTextView;
@property (weak, nonatomic) IBOutlet UITextField *sendTextField;

- (IBAction)sendButtonClicked:(id)sender;
@end
