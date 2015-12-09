//
//  SummaryTableViewCell.m
//  ListeningStory
//
//  Created by 丁伟 on 15/11/26.
//  Copyright (c) 2015年 丁伟. All rights reserved.
//

#import "SummaryTableViewCell.h"
#import "UIImageView+WebCache.h"
@interface SummaryTableViewCell()
@property (strong, nonatomic) IBOutlet UIImageView *storyImage;
@property (strong, nonatomic) IBOutlet UILabel *storyTitle;
@property (strong, nonatomic) IBOutlet UILabel *storyReadedCount;

@end

@implementation SummaryTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

-(void)setModel:(SummaryModel *)model{
    _model =model;
    
//    [_storyImage sd_setImageWithURL:[NSURL URLWithString:[_model.imageUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] placeholderImage:[UIImage imageNamed:@"loading"]];
    
    [_storyImage sd_setImageWithURL:[NSURL URLWithString:[_model.imageUrl  stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] placeholderImage:[UIImage imageNamed:@"loading"] options:SDWebImageRetryFailed];
    
    _storyTitle.text =model.storyTitle;
    _storyReadedCount.text = [NSString stringWithFormat:@"浏览次数:%@",model.count];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
