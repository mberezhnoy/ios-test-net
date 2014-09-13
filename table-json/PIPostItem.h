//
//  PIPostItem.h
//  table-json
//
//  Created by Maxim Berezhnoy on 10.09.14.
//  Copyright (c) 2014 Maxim Berezhnoy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PIPostItem : NSObject

@property (nonatomic, copy) NSString * title;
@property (nonatomic, copy) NSString * text;
@property (nonatomic, copy) NSString * format;
@property (nonatomic, copy) NSString * thumb;
@property (nonatomic, copy) NSString * image;

+(PIPostItem*)createFromData: (NSDictionary*)data;

@end
