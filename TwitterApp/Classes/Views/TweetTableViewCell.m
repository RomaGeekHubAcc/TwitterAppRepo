//
//  TweetTableViewCell.m
//  TwitterApp
//
//  Created by Roman Rybachenko on 9/20/14.
//
//

#import <SDWebImage/UIImageView+WebCache.h>

#import "TweetTableViewCell.h"


static NSString * const textKey = @"text";
static NSString * const userKey = @"user";
static NSString * const profileUrlKey = @"profile_background_image_url";
static NSString * const profileNameKey = @"name";


@implementation TweetTableViewCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - Interface methods

-(void) setContentWithDicctionary:(NSDictionary *)dict {
    NSDictionary *user = dict[userKey];
    
//    $l("user = %@", user);
    NSString *profileImageUrlStr = user[profileUrlKey];
    [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:profileImageUrlStr]
                            placeholderImage:[UIImage imageNamed:@"placeholder_icon"]];
    self.senderNameLaber.text = user[profileNameKey];
    self.tweetTextLabel.text = dict[textKey];
//    NSArray *allKeys = [user allKeys];
    
//    $l("\n\ndict -> %@", dict);
}

@end
