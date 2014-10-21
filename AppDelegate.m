//
//  AppDelegate.m
//  Mobile Touch
//
//  Created by Samuel Scott Robbins on 10/5/14.
//  Copyright (c) 2014 Scott Robbins. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    NSString *type = @"TestingProtocol";
    _server = [[Server alloc] initWithProtocol:type];
    _server.delegate = self;
    NSError *error = nil;
    if(![_server start:&error]) {
        NSLog(@"error = %@", error);
    }
    _services = [[NSMutableArray alloc] init];
    _connectedToService = NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(sendMessage:)
                                                 name:@"MessageSending"
                                               object:nil];

    return YES;
}

#pragma mark - Server Methods!!!!
- (void)serverRemoteConnectionComplete:(Server *)server {
    NSLog(@"Server Started");
    // this is called when the remote side finishes joining with the socket as
    // notification that the other side has made its connection with this side
    _server = server;
    _connectedToService = YES;
    // running view controller can run now. (connected to other device)
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ServerDidConnect" object:nil userInfo:nil];
}

- (void)serverStopped:(Server *)server {
    NSLog(@"Server stopped");
    // running view controller cannot win anymore...Probably send an nsnotification
    _connectedToService = NO;
}

- (void)server:(Server *)server didNotStart:(NSDictionary *)errorDict {
    NSLog(@"Server did not start %@", errorDict);
    _connectedToService = NO;
}

- (void)server:(Server *)server didAcceptData:(NSData *)data {
    NSLog(@"Server did accept data %@", data);
    NSString *message = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    if(nil != message || [message length] > 0) {
        // This is a valid message
        NSDictionary *responseDict = [NSDictionary dictionaryWithObject:message forKey:@"message"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"MessageReceived" object:nil userInfo:responseDict];
    } else {
        // this is an invalid message
    }
}

- (void)server:(Server *)server lostConnection:(NSDictionary *)errorDict {
    NSLog(@"Server lost connection %@", errorDict);
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ConnectionLost" object:nil userInfo:nil];
    // respond after losing connection
    _connectedToService = NO;
}

- (void)serviceAdded:(NSNetService *)service moreComing:(BOOL)more {
    // Add the service to the list...probably send a notification
    [_services addObject:service];
    if(!more) {
        // send notification for other viewcontroller to reload its tableview if necessary
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ServiceAdded" object:nil userInfo:nil];
    }
}

- (void)serviceRemoved:(NSNetService *)service moreComing:(BOOL)more {
        // service removed, take it out of the list...probably send a notification
    
    [_services removeObject:service];
    if(!more) {
        // Send notification for other viewcontroller to reload tableview
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ServiceRemoved" object:nil userInfo:nil];
    }

}

-(void)sendMessage:(NSNotification *)notification {
    NSDictionary *respondeDict = [notification userInfo];
    
    if ([respondeDict objectForKey:@"message"]) {
        NSString *message = [respondeDict valueForKey:@"message"];
        NSData *data = [message dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error = nil;
        [self.server sendData:data error:&error];
    }
}


# pragma mark - APP DELEGATE METHODS
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
