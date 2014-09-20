//
//  TwitterAccountManager.h
//  TwitterApp
//
//  Created by Roman Rybachenko on 9/20/14.
//
//


#import "STTwitterOAuth.h"

#import <Foundation/Foundation.h>

typedef void (^RequestCallback) (BOOL success, id responce);

@interface TwitterAPIManager : NSObject

@property (nonatomic, strong) NSString *userName;

+(instancetype) sharedInstance;

-(void) authorizeWithIOSAccountCompletion:(RequestCallback)completion;

-(void) getHomeTimelineSinceId:(NSString *)sinceId count:(NSUInteger)count completionBlock:(RequestCallback)complition;

@end
