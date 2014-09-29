//
//  TwitterAccountManager.m
//  TwitterApp
//
//  Created by Roman Rybachenko on 9/20/14.
//
//


#import "TwitterAPIManager.h"


@interface TwitterAPIManager ()

@end

@implementation TwitterAPIManager


+(instancetype) sharedInstance {
    static TwitterAPIManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [TwitterAPIManager new];
        manager.userName = [[NSUserDefaults standardUserDefaults] valueForKey:TWITTER_USER_NAME_KEY];
    });
    
    return manager;
}


#pragma mark - Interface Methods

-(void) getUserTimelineWithScreenName:(NSString *)userName completionBlock:(CompletionBlock)completion {
    [[TwitterAPIManager sharedInstance].twitter verifyCredentialsWithSuccessBlock:^(NSString *userName) {
        
        if (userName) {
            [[TwitterAPIManager sharedInstance].twitter getUserTimelineWithScreenName:userName
                                                                         successBlock:^(NSArray *statuses){
                                                                             self.userName = userName;
                                                                             completion(YES, statuses, nil);
                                                                         } errorBlock:^(NSError *error){
                                                                             completion(NO, nil, error);
                                                                             $l("----- getUserTimeline error -> %@", error.debugDescription);
                                                                         }];
        }
        
    } errorBlock:^(NSError *error) {
        $l("--- verifyCredentials error -> %@", error.debugDescription);
    }];
}

-(void) getHomeTimelineSinceId:(NSString *)sinceId count:(NSUInteger)count completionBlock:(CompletionBlock)complition {
    [self.twitter getHomeTimelineSinceID:sinceId
                                   count:count
                            successBlock:^(NSArray *statuses) {
                                
                                complition(YES, statuses, nil);
                                
                            } errorBlock:^(NSError *error) {
                                complition(NO, nil, error);
                                $l(@"getHomeTimelineSinceID error - > %@", error);
                            }];
}

-(void) onlyAutentificationWithCompletion:(CompletionBlock)completion {
    
    NSString *oauthToken = [[NSUserDefaults standardUserDefaults] valueForKey:TWITTER_API_OAUTH_TOKEN_KEY];
    NSString *oauthSecret = [[NSUserDefaults standardUserDefaults] valueForKey:TWITTER_API_OAUTH_SECRET_KEY];;
    
    self.twitter = [STTwitterAPI twitterAPIWithOAuthConsumerKey:TWITTER_CONSUMER_KEY consumerSecret:TWITTER_CONSUMER_SECRET oauthToken:oauthToken oauthTokenSecret:oauthSecret];
    
    [self.twitter verifyCredentialsWithSuccessBlock:^(NSString *username) {
        self.userName = username;
        self.isAuthorized = YES;
        completion(YES, username, nil);
        
    } errorBlock:^(NSError *error) {
        completion(NO, nil, error);
    }];
}

-(void) authorizeWithIOSAccountCompletion:(CompletionBlock)completion {
    self.twitter = [STTwitterAPI twitterAPIOSWithFirstAccount];
    
    [self.twitter verifyCredentialsWithSuccessBlock:^(NSString *username) {
        self.userName = username;
        self.isAuthorized = YES;
        completion(YES, username, nil);
        $l(@"\n\n----loginWith_iOS_account success !! \nUserName = %@", username);
        
    } errorBlock:^(NSError *error) {
        completion(NO, nil, error);
        $l(@"\n\n Error in loginWith_iOS_account -> %@", error);
    }];
}

-(void) authrizeWithWebBrowserWithComlition:(CompletionBlock)completion {
    self.twitter = [STTwitterAPI twitterAPIWithOAuthConsumerKey:TWITTER_CONSUMER_KEY
                                                 consumerSecret:TWITTER_CONSUMER_SECRET];
    
    [self.twitter postTokenRequest:^(NSURL *url, NSString *oauthToken) {
        
        $l(@"-- url: %@", url);
        $l(@"-- oauthToken: %@", oauthToken);
        
        
        completion(YES, url, nil);
        
    } authenticateInsteadOfAuthorize:NO
                   forceLogin:@(YES)
                   screenName:nil
                oauthCallback:@"myappRR://twitter_access_tokens/"
                   errorBlock:^(NSError *error) {
                       completion(NO, nil, error);
                       NSLog(@"-- error: %@", error);
                   }];
}

-(void) sendOauthVerifier:(NSString *)verifier complition:(CompletionBlock)complition {
    [self.twitter postAccessTokenRequestWithPIN:verifier
                                   successBlock:^(NSString *oauthToken, NSString *oauthTokenSecret, NSString *userID, NSString *screenName) {
                                       
                                       $l("\n\n--oauthToken = %@\n--oauthTokenSecret = %@\n--userID = %@\n--screenName = %@", oauthToken, oauthTokenSecret, userID, screenName);
                                       
                                       self.userName = screenName;
                                       
                                       [[NSUserDefaults standardUserDefaults] setObject:screenName forKey:TWITTER_USER_NAME_KEY];
                                       [[NSUserDefaults standardUserDefaults] setObject:oauthToken
                                                                                 forKey:TWITTER_API_OAUTH_TOKEN_KEY];
                                       [[NSUserDefaults standardUserDefaults] setObject:oauthTokenSecret
                                                                                 forKey:TWITTER_API_OAUTH_SECRET_KEY];
                                       [[NSUserDefaults standardUserDefaults] synchronize];
                                       
                                       complition(YES, nil, nil);
                                       
                                   }   errorBlock:^(NSError *error) {
                                       complition(NO, nil, error);
                                   }];
}


-(void) sendTweet:(NSString *)tweetMessage withCompletionBlock:(CompletionBlock)complition {
    [self.twitter postStatusUpdate:tweetMessage
                 inReplyToStatusID:nil
                          latitude:nil
                         longitude:nil
                           placeID:nil
                displayCoordinates:nil
                          trimUser:nil
                      successBlock:^(NSDictionary *satusses) {
                          complition(YES, satusses, nil);
                      } errorBlock:^(NSError *error) {
                          complition(NO, nil, error);
                      }];
}

-(void) finishTwitterSession {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:TWITTER_USER_NAME_KEY];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:TWITTER_API_OAUTH_TOKEN_KEY];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:TWITTER_API_OAUTH_SECRET_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
    self.twitter = nil;
    self.userName = nil;
    self.isAuthorized = NO;
}


@end
