//
//  PIAsyncRequest.m
//  table-json
//
//  Created by Maxim Berezhnoy on 11.09.14.
//  Copyright (c) 2014 Maxim Berezhnoy. All rights reserved.
//

#import "PIAsyncRequest.h"

@implementation PIAsyncRequest {
    NSURLConnection *_connection;
    
    id _сbFinishObj;
    SEL _сbFinishSel;
}

@synthesize url = _url;
@synthesize request = _request;
@synthesize isFinished = _isFinished;
@synthesize responseData = _responseData;

- (PIAsyncRequest*)init
{
    PIAsyncRequest* obj=[super init];
    _responseData = [[NSMutableData alloc] init];
    _isFinished = NO;
    return obj;
}

-(PIAsyncRequest*)initWithUrl:(NSString*)url
{
    PIAsyncRequest* obj=[self init];
    _url = url;
    _request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:_url]];
    return obj;
}

-(void)onFinishNotifyObject:(id)object withSelector:(SEL)selector
{
    _сbFinishObj = object;
    _сbFinishSel = selector;
}

-(void)run
{
    _connection = [[NSURLConnection alloc] initWithRequest:_request delegate:self];
}

-(void)runAndOnFinishNotifyObject:(id)object withSelector:(SEL)selector
{
    [self onFinishNotifyObject: object withSelector:selector];
    [self run];
}

-(void)interrupt
{
    [_connection cancel];
}

+(PIAsyncRequest*)createWithUrl:(NSString*)url
{
    PIAsyncRequest* obj=[[PIAsyncRequest alloc] initWithUrl:url];
    return obj;
}

#pragma mark NSURLConnectionDelegate
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [_responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"PIAsyncRequest: fail load data");
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    _isFinished = YES;
    
    [_сbFinishObj performSelector:_сbFinishSel withObject:self];
}

@end
