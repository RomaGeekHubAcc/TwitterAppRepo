//
//  TwitterAccountManager.m
//  TwitterApp
//
//  Created by Roman Rybachenko on 9/20/14.
//
//


#import "STTwitter.h"

#import "TwitterAPIManager.h"


@interface TwitterAPIManager ()

@property (nonatomic, strong) STTwitterAPI *twitter;

@end

@implementation TwitterAPIManager


+(instancetype) sharedInstance {
    static TwitterAPIManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [TwitterAPIManager new];
    });
    
    return manager;
}

#pragma mark - Interface Methods

-(void) onlyAutentificationWithCompletion:(CompletionBlock)completion {
    NSString *consumerName = [[NSUserDefaults standardUserDefaults] valueForKey:TWITTER_CONSUMER_NAME];
    NSString *consumerKey = [[NSUserDefaults standardUserDefaults] valueForKey:TWITTER_CONSUMER_KEY];
    NSString *consumerSecret = [[NSUserDefaults standardUserDefaults] valueForKey:TWITTER_CONSUMER_SECRET];
    
    self.twitter = [STTwitterAPI twitterAPIAppOnlyWithConsumerName:consumerName
                                                       consumerKey:consumerKey
                                                    consumerSecret:consumerSecret];
    [self.twitter verifyCredentialsWithSuccessBlock:^(NSString *username) {
        
        completion(YES, username, nil);
        
    } errorBlock:^(NSError *error) {
        completion(NO, nil, error);
    }];
}

-(void) authorizeWithIOSAccountCompletion:(CompletionBlock)completion {
    self.twitter = [STTwitterAPI twitterAPIOSWithFirstAccount];
    
    [self.twitter verifyCredentialsWithSuccessBlock:^(NSString *username) {
        self.userName = username;
        completion(YES, username, nil);
        $l(@"\n\n----loginWith_iOS_account success !! \nUserName = %@", username);
        
    } errorBlock:^(NSError *error) {
        completion(NO, nil, error);
        $l(@"\n\n Error in loginWith_iOS_account -> %@", error);
    }];
}

-(void) authrizeWithWebBrowserWithComlition:(CompletionBlock)completion {
    self.twitter = [STTwitterAPI twitterAPIWithOAuthConsumerKey:@"fh0vKkpAWTcDoTSAzEMwU9J9j"
                                            consumerSecret:@"hArOwdWqXkykDBdLLbJ8iTw23Z5AXSEh0VBHBS2vgPcFSWoSSo"];
    
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
                                       
                                       [[NSUserDefaults standardUserDefaults] setObject:oauthToken
                                                                                 forKey:TWITTER_API_OAUTH_TOKEN];
                                       [[NSUserDefaults standardUserDefaults] setObject:oauthTokenSecret
                                                                                 forKey:TWITTER_API_OAUTH_SECRET];
                                       [[NSUserDefaults standardUserDefaults] synchronize];
                                       
                                       complition(YES, nil, nil);
                                       
                                   }   errorBlock:^(NSError *error) {
                                       complition(NO, nil, error);
                                   }];
}



-(void) getHomeTimelineSinceId:(NSString *)sinceId count:(NSUInteger)count completionBlock:(CompletionBlock)complition {
    [self.twitter getHomeTimelineSinceID:sinceId
                              count:20
                       successBlock:^(NSArray *statuses) {
                           
                           complition(YES, statuses, nil);
                           
                       } errorBlock:^(NSError *error) {
                           complition(NO, nil, error);
                           $l(@"getHomeTimelineSinceID error - > %@", error);
                       }];
}

#pragma mark - Private methods




@end
