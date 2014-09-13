//
//  PIPostItem.m
//  table-json
//
//  Created by Maxim Berezhnoy on 10.09.14.
//  Copyright (c) 2014 Maxim Berezhnoy. All rights reserved.
//

#import "PIPostItem.h"

@implementation PIPostItem

+(PIPostItem*)createFromData: (NSDictionary*)data
{
    PIPostItem* obj =[[PIPostItem alloc] init];
    
    obj.title  = data[@"title"];
    obj.text   = data[@"text"];
    obj.format = data[@"format"];
    obj.thumb  = data[@"thumb"];
    obj.image  = data[@"img"];
    
    return obj;
}

@end
