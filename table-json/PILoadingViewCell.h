//
//  PILoadingViewCell.h
//  table-json
//
//  Created by Maxim Berezhnoy on 16.09.14.
//  Copyright (c) 2014 Maxim Berezhnoy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PILoadingViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *loadingIm;

-(void)animatimate;

@end
