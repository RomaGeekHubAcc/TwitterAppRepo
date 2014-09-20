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
        $l(@"\n\n Error in loginWith_iOS_account -> %@",error);
    }];
}

//-(BOOL) verifyCredentials {
//    [self.twitter verifyCredentialsWithSuccessBlock:^(NSString *userName){
//        NSLog(@"\n\n-----verifyCredentialsWithSuccess----");
//        //        [self getUserTweets];
//        
//    }errorBlock:^(NSError *error) {
//        NSLog(@"\n\n---Error -> %@", error);
//    }];
//    retu
//}

@end
