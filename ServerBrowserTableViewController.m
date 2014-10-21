//
//  ServerBrowserTableViewController.m
//  Mobile Touch
//
//  Created by Samuel Scott Robbins on 10/5/14.
//  Copyright (c) 2014 Scott Robbins. All rights reserved.
//

#import "ServerBrowserTableViewController.h"
#import "AppDelegate.h"
#import "Server.h"

@interface ServerBrowserTableViewController ()

@end

@implementation ServerBrowserTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(serviceAdded:) name:@"ServiceAdded" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(serviceRemoved:) name:@"ServiceRemoved" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ServerDidConnect:) name:@"ServerDidConnect" object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];

    return (appDelegate.services != nil) ? [appDelegate.services count] : 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    
    cell.textLabel.text = (appDelegate.services != nil) ? [[appDelegate.services objectAtIndex:indexPath.row] name] : @"No Services Found";
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];

    UITableViewCell *cellSelected = [tableView cellForRowAtIndexPath:indexPath];
    
    if ([cellSelected.textLabel.text isEqualToString:@"No Services Found"]) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    } else {
        // Connect to the service
        [appDelegate.server connectToRemoteService:[appDelegate.services objectAtIndex:indexPath.row]];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"Connections";
}

- (void)ServerDidConnect:(NSNotification *)notification {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)serviceAdded:(id)randomVarIDontUse {
    [self.tableView reloadData];
}

- (void)serviceRemoved:(id)randomVarIDontUse {
    [self.tableView reloadData];
}

@end
