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
    int _lastPage;
}

@synthesize size = _size;
@synthesize searchString = _searchString;

-(PIDataProvider*)init
{
    PIDataProvider* obj = [super init];
    _posts = [[NSMutableArray alloc] init];
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
    _request = nil;
    
    _size = 0;
    _lastPage = 1;
    [_posts removeAllObjects];
    
    [self dataRequest];
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
    
    _size = [json[@"total"] integerValue];


    
    for(id postData in json[@"posts"])
    {
        [_posts addObject:[PIPostItem createFromData:postData]];
    }

    //NSLog(@"data size: %d", [_posts count]);
    [_cbLoadObj performSelector:_cbLoadSel withObject:self];
    _request = nil;
}

- (PIPostItem*)getItem:(int)i
{
    if (i>=[_posts count])
    {
        [self loadMore];
        return nil;
    }
    return (PIPostItem*)[_posts objectAtIndex:i];
}

-(void)loadMore
{
    if(_request != nil) return;
    _lastPage++;
    [self dataRequest];
}

-(void)dataRequest
{
    if(_request != nil) return;
    
    NSString *urlString = [NSString stringWithFormat:@"http://idol.max/api/get-posts?numberposts=10&paged=%d", _lastPage];
    if ( _searchString!=nil && [_searchString length]!=0 )
    {
        NSString * _se = [PIDataProvider encodeURIComponen: _searchString];
        urlString = [NSString stringWithFormat:@"%@&s=%@", urlString, _se];
    }
    
    _request = [PIAsyncRequest createWithUrl:urlString];
    [_request runAndOnFinishNotifyObject:self withSelector:@selector(onDataLoad:)];

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
