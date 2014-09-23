//
//  TwitterAccountManager.h
//  TwitterApp
//
//  Created by Roman Rybachenko on 9/20/14.
//
//


#import "STTwitterOAuth.h"

#import <Foundation/Foundation.h>

typedef void (^CompletionBlock) (BOOL success, id responce, NSError *error);

@interface TwitterAPIManager : NSObject

@property (nonatomic, strong) NSString *userName;

+(instancetype) sharedInstance;

-(void) authorizeWithIOSAccountCompletion:(CompletionBlock)completion;
-(void) authrizeWithWebBrowserWithComlition:(CompletionBlock)completion;

-(void) sendOauthVerifier:(NSString *)verifier complition:(CompletionBlock)complition;

-(void) getHomeTimelineSinceId:(NSString *)sinceId count:(NSUInteger)count completionBlock:(CompletionBlock)complition;

@end
