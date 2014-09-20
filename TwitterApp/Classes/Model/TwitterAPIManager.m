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

-(void) authorizeWithIOSAccountCompletion:(RequestCallback)completion {
    self.twitter = [STTwitterAPI twitterAPIOSWithFirstAccount];
    
    [self.twitter verifyCredentialsWithSuccessBlock:^(NSString *username) {
        self.userName = username;
        completion(YES, username);
        $l(@"\n\n----loginWith_iOS_account success !! \nUserName = %@", username);
        
    } errorBlock:^(NSError *error) {
        completion(NO, error);
        $l(@"\n\n Error in loginWith_iOS_account -> %@",error);
    }];
}

-(void) getHomeTimelineSinceId:(NSString *)sinceId count:(NSUInteger)count completionBlock:(RequestCallback)complition {
    [self.twitter getHomeTimelineSinceID:sinceId
                              count:20
                       successBlock:^(NSArray *statuses) {
                           
                           complition(YES, statuses);
                           
                       } errorBlock:^(NSError *error) {
                           complition(NO, error);
                           $l(@"getHomeTimelineSinceID error - > %@", error);
                       }];
}



@end
