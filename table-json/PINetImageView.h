//
//  PINetImageView.h
//  table-json
//
//  Created by Maxim Berezhnoy on 11.09.14.
//  Copyright (c) 2014 Maxim Berezhnoy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PINetImageView : UIImageView

@property (readwrite,nonatomic) NSString * imgUrl;

+(NSArray*)getLoadingFrames;

@end
