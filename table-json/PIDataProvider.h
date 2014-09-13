//
//  PIDataProvider.h
//  table-json
//
//  Created by Maxim Berezhnoy on 10.09.14.
//  Copyright (c) 2014 Maxim Berezhnoy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PIPostItem.h"
#import "PIAsyncRequest.h"

@interface PIDataProvider : NSObject 

@property (readonly) int size;
@property (readwrite,nonatomic) NSString * searchString;

- (void)onLoadNotifyObject:(id)object withSelector:(SEL)selector;
- (void)startRequest;
- (PIPostItem*)getItem:(int)i;

+(NSString *) encodeURIComponen: (NSString*)s;

@end
