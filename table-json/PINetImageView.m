//
//  PINetImageView.m
//  table-json
//
//  Created by Maxim Berezhnoy on 11.09.14.
//  Copyright (c) 2014 Maxim Berezhnoy. All rights reserved.
//

#import "PINetImageView.h"
#import "PIAsyncRequest.h"

@implementation PINetImageView {
    PIAsyncRequest * _request;
}

@synthesize imgUrl = _imgUrl;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)setImgUrl:(NSString *)imgUrl
{
    [_request interrupt];
    _imgUrl = imgUrl;
    
    if ( [self loadImageFromCache:imgUrl] ) return;

    self.image = nil;
    self.animationImages = [PINetImageView getLoadingFrames];
    self.animationDuration = 1;
    [self startAnimating];

    [_request runAndOnFinishNotifyObject:self withSelector:@selector(onDataLoad:)];
}

-(void)onDataLoad:(PIAsyncRequest*)rq
{
    [self setImageData:rq.responseData];

    NSURLCache *urlCache = [NSURLCache sharedURLCache];
    NSCachedURLResponse *cachedResponse = [[NSCachedURLResponse alloc] initWithResponse:rq.response data:rq.responseData];
    [urlCache storeCachedResponse:cachedResponse forRequest:rq.request];
}

-(void)setImageData:(NSData*)data
{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.animationImages = nil;
        [self stopAnimating];
        self.image = [UIImage imageWithData: data];
    });
}

-(BOOL)loadImageFromCache:(NSString*)url
{
    _request = [PIAsyncRequest createWithUrl:url];
    _request.request.cachePolicy = NSURLRequestReturnCacheDataElseLoad;

    NSURLCache *urlCache = [NSURLCache sharedURLCache];
    NSCachedURLResponse *cachedResponse = [urlCache cachedResponseForRequest:_request.request];
    
    if ( cachedResponse==nil ) return NO;

    //process redirect
    if ( [cachedResponse.response isKindOfClass:[NSHTTPURLResponse class]] )
    {
        NSHTTPURLResponse * res = (NSHTTPURLResponse*)cachedResponse.response;
        if ( 301==[res statusCode] )
        {
            NSDictionary* headers = [res allHeaderFields];
            return [self loadImageFromCache:headers[@"location"] ];
        }
    }
    
//    NSLog(@"set from cache: %@", _imgUrl);
    [self setImageData:cachedResponse.data];
    return YES;
}

+(NSArray*)getLoadingFrames
{
    static NSArray * frames;
    if (frames) return  frames;
    
    UIImage * sprite = [UIImage imageNamed:@"loading"];
    int duration = sprite.size.width / sprite.size.height;
    NSMutableArray * mframes = [[NSMutableArray alloc] init];
    UIImage * frame;
    for (int i=0; i<duration; i++)
    {
        frame = [UIImage imageWithCGImage:CGImageCreateWithImageInRect([sprite CGImage], CGRectMake(i*sprite.size.height, 0, sprite.size.height, sprite.size.height))];
        [mframes addObject:frame];
    }
    frames = [[NSArray alloc] initWithArray:mframes];
    return  frames;
}

@end
