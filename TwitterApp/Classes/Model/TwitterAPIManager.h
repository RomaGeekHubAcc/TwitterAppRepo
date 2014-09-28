//
//  TwitterAccountManager.h
//  TwitterApp
//
//  Created by Roman Rybachenko on 9/20/14.
//
//

#import "STTwitter.h"

#import <Foundation/Foundation.h>

typedef void (^CompletionBlock) (BOOL success, id responce, NSError *error);

@interface TwitterAPIManager : NSObject

@property (nonatomic, strong) STTwitterAPI *twitter;

@property (nonatomic, strong) NSString *userName;
@property (nonatomic, assign) BOOL isAuthorized;

+(instancetype) sharedInstance;

-(void) authorizeWithIOSAccountCompletion:(CompletionBlock)completion;
-(void) authrizeWithWebBrowserWithComlition:(CompletionBlock)completion;
-(void) onlyAutentificationWithCompletion:(CompletionBlock)completion;

-(void) finishTwitterSession;

-(void) getHomeTimelineSinceId:(NSString *)sinceId count:(NSUInteger)count completionBlock:(CompletionBlock)complition;
-(void) getUserTimelineWithScreenName:(NSString *)userName completionBlock:(CompletionBlock)completion;


-(void) sendOauthVerifier:(NSString *)verifier complition:(CompletionBlock)complition;
-(void) sendTweet:(NSString *)tweetMessage withCompletionBlock:(CompletionBlock)complition;

@end
