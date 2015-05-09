//
//  ViewController.m
//  PusherTest
//
//  Created by Phil Leggetter on 09/05/2015.
//  Copyright (c) 2015 Phil Leggetter. All rights reserved.
//

#import "ViewController.h"

#import <Pusher/Pusher.h>

@interface ViewController ()<PTPusherDelegate> {
    PTPusher *_client;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"viewDidLoad");
    
    // self.client is a strong instance variable of class PTPusher
    _client = [PTPusher pusherWithKey:@"abb988cdb65953f56d6e" delegate:self encrypted:YES cluster:@"useast2"];
    
    // subscribe to channel and bind to event
    PTPusherChannel *channel = [_client subscribeToChannelNamed:@"chat"];
    [channel bindToEventNamed:@"new-message" handleWithBlock:^(PTPusherEvent *channelEvent) {
        // channelEvent.data is a NSDictianary of the JSON object received
        NSString *message = [channelEvent.data objectForKey:@"text"];
        NSLog(@"message received: %@", message);
    }];
    
    [_client connect];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//////////////////////////////////
#pragma mark - Pusher Delegate Connection
//////////////////////////////////

- (void)pusher:(PTPusher *)pusher connectionDidConnect:(PTPusherConnection *)connection
{
    NSLog(@"[Pusher] connected to %@", [connection.URL absoluteString]);
}

- (void)pusher:(PTPusher *)pusher connection:(PTPusherConnection *)connection failedWithError:(NSError *)error
{
    if (error) {
        NSLog(@"[Pusher] connection failed: %@", [error localizedDescription]);
    } else {
        NSLog(@"[Pusher] connection failed");
    }
}

- (void)pusher:(PTPusher *)pusher connection:(PTPusherConnection *)connection didDisconnectWithError:(NSError *)error willAttemptReconnect:(BOOL)reconnect
{
    if (error) {
        NSLog(@"[Pusher] didDisconnectWithError: %@ willAttemptReconnect: %@", [error localizedDescription], (reconnect ? @"YES" : @"NO"));
    } else {
        NSLog(@"[Pusher] disconnected");
    }
}

- (BOOL)pusher:(PTPusher *)pusher connectionWillConnect:(PTPusherConnection *)connection
{
    return YES;
}

- (BOOL)pusher:(PTPusher *)pusher connectionWillAutomaticallyReconnect:(PTPusherConnection *)connection afterDelay:(NSTimeInterval)delay
{
    return YES;
}

@end
