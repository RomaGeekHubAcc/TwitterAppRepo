//
//  TweetTableViewCell.h
//  TwitterApp
//
//  Created by Roman Rybachenko on 9/20/14.
//
//


@interface TweetTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *senderNameLaber;
@property (weak, nonatomic) IBOutlet UILabel *tweetTextLabel;

-(void) setContentWithDicctionary:(NSDictionary *)dict;

@end
