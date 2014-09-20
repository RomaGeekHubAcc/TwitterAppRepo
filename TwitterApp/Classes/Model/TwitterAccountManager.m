//
//  TwitterAccountManager.m
//  TwitterApp
//
//  Created by Roman Rybachenko on 9/20/14.
//
//


#import "STTwitter.h"

#import "TwitterAccountManager.h"


@interface TwitterAccountManager ()

@property (nonatomic, strong) STTwitterAPI *twitter;

@end

@implementation TwitterAccountManager


+(instancetype) sharedInstance {
    static TwitterAccountManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [TwitterAccountManager new];
    });
    
    return manager;
}

#pragma mark - Interface Methods

-(void) loginWithIOSAccount {
    
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
