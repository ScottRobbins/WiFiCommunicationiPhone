//
//  AppDelegate.h
//  Mobile Touch
//
//  Created by Samuel Scott Robbins on 10/5/14.
//  Copyright (c) 2014 Scott Robbins. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Server.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, ServerDelegate> {
   // Server *_server;
}

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) Server *server;
@property (strong, nonatomic) NSMutableArray *services;
@property BOOL connectedToService;

@end

