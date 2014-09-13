//
//  PIAsyncRequest.h
//  table-json
//
//  Created by Maxim Berezhnoy on 11.09.14.
//  Copyright (c) 2014 Maxim Berezhnoy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PIAsyncRequest : NSObject <NSURLConnectionDelegate>

@property (readonly) NSString * url;
@property (readonly) NSMutableURLRequest *request;
@property (readonly) BOOL isFinished;
@property (readonly) NSMutableData * responseData;


-(PIAsyncRequest*)initWithUrl:(NSString*)url;
-(void)onFinishNotifyObject:(id)object withSelector:(SEL)selector;
-(void)run;
-(void)runAndOnFinishNotifyObject:(id)object withSelector:(SEL)selector;
-(void)interrupt;

+(PIAsyncRequest*)createWithUrl:(NSString*)url;

@end
