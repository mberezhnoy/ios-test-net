//
//  PIDataProvider.m
//  table-json
//
//  Created by Maxim Berezhnoy on 10.09.14.
//  Copyright (c) 2014 Maxim Berezhnoy. All rights reserved.
//

#import "PIDataProvider.h"

@implementation PIDataProvider {
    PIAsyncRequest * _request;
    id _cbLoadObj;
    SEL _cbLoadSel;
    NSMutableArray * _posts;
}

@synthesize size = _size;
@synthesize searchString = _searchString;

-(PIDataProvider*)init
{
    PIDataProvider* obj = [super init];
    _posts = [[NSMutableArray alloc] init];
    _size = 0;
    return  obj;
}

-(void)setSearchString:(NSString *)searchString
{
    _searchString = searchString;
    [self startRequest];
}

-(void)startRequest
{
    [_request interrupt];
    
    NSString *urlString = @"http://idol.max/api/get-posts?numberposts=100";
    if ( _searchString!=nil && [_searchString length]!=0 )
    {
        NSString * _se = [PIDataProvider encodeURIComponen: _searchString];
        urlString = [NSString stringWithFormat:@"%@&s=%@", urlString, _se];
    }
    //NSLog(@"serch: %@ url: %@", _searchString, urlString);
    
    _request = [PIAsyncRequest createWithUrl:urlString];
    [_request runAndOnFinishNotifyObject:self withSelector:@selector(onDataLoad:)];
}

- (void)onLoadNotifyObject:(id)object withSelector:(SEL)selector
{
    _cbLoadObj = object;
    _cbLoadSel = selector;
}

-(void)onDataLoad:(PIAsyncRequest*)rq
{
    NSError * error;
    
    NSMutableDictionary  * json = [NSJSONSerialization JSONObjectWithData:rq.responseData
                                                       options: NSJSONReadingMutableContainers
                                                       error: &error];
    
    if ( !json[@"ok"]) return;
    
    _size = [json[@"posts"] count];
    
//    NSLog(@"response %@ for %@ from:%@", json[@"total"], _searchString, rq.url);
    
    [_posts removeAllObjects];
    
    for(id postData in json[@"posts"])
    {
        [_posts addObject:[PIPostItem createFromData:postData]];
    }

    NSLog(@"data size: %d", [_posts count]);
    [_cbLoadObj performSelector:_cbLoadSel withObject:self];    
}

- (PIPostItem*)getItem:(int)i
{
    return (PIPostItem*)[_posts objectAtIndex:i];
}

+(NSString *) encodeURIComponen: (NSString*)s
{
    
    static NSString * const kLegalCharactersToBeEscaped = @"!*'();:@&=+$,/?%#[]";
    return (__bridge_transfer NSString *)CFURLCreateStringByAddingPercentEscapes(
                                                                                 NULL,
                                                                                 (__bridge CFStringRef)s,
                                                                                 NULL,
                                                                                 (__bridge CFStringRef)kLegalCharactersToBeEscaped,
                                                                                 kCFStringEncodingUTF8 );
}


@end
