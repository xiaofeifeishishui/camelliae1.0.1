//
//  CMLCommentListTVCell.m
//  camelliae1.0.1
//
//  Created by 张越 on 16/4/26.
//  Copyright © 2016年 张越. All rights reserved.
//

#import "CMLCommentListTVCell.h"
#import "CommonFont.h"
#import "CommonNumber.h"
#import "NetWorkTask.h"
#import "UIColor+SDExspand.h"

#define UserImageLeftMargin     36
#define UserImageTopMargin      31
#define UserImageHeightAndwidth 70
#define NickNameLeftMargin      20

@interface CMLCommentListTVCell ()

@property (nonatomic,strong) UIImageView *userImage;

@property (nonatomic,strong) UILabel *nickNameLabel;

@property (nonatomic,strong) UILabel *commentContentLabel;

@property (nonatomic,strong) UILabel *timeLabel;

@end

@implementation CMLCommentListTVCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self loadViews];
    }
    return self;
}


- (void) loadViews{

    self.userImage = [[UIImageView alloc] init];
    [self.contentView addSubview:self.userImage];
    
    self.nickNameLabel = [[UILabel alloc] init];
    self.nickNameLabel.font = KSystemFontSize12;
    [self.contentView  addSubview:self.nickNameLabel];
    
    self.commentContentLabel = [[UILabel alloc] init];
    self.commentContentLabel.font = KSystemFontSize11;
    self.commentContentLabel.numberOfLines = 0;
    [self.contentView  addSubview:self.commentContentLabel];
    
    self.timeLabel = [[UILabel alloc] init];
    self.timeLabel.font = KSystemFontSize12;
    self.timeLabel.textColor = [UIColor CMLCommentTimeGrayColor];
    [self.contentView  addSubview:self.timeLabel];
    
    
}

- (CGFloat) refreshTableViewCell{

    self.userImage.frame = CGRectMake(UserImageLeftMargin*Proportion,
                                      UserImageTopMargin*Proportion,
                                      UserImageHeightAndwidth*Proportion,
                                      UserImageHeightAndwidth*Proportion);
    self.userImage.layer.cornerRadius = UserImageHeightAndwidth*Proportion/2.0;
    [NetWorkTask setImageView:self.userImage WithURL:[NSURL URLWithString:self.imageUrl] placeholderImage:nil];
    
    self.nickNameLabel.text = self.nickName;
    [self.nickNameLabel sizeToFit];
    self.nickNameLabel.frame = CGRectMake(NickNameLeftMargin*Proportion + CGRectGetMaxX(self.userImage.frame),
                                          self.userImage.center.y - self.nickNameLabel.frame.size.height/2.0,
                                          self.nickNameLabel.frame.size.width,
                                          self.nickNameLabel.frame.size.height);
    self.timeLabel.text = self.publishTime;
    [self.timeLabel sizeToFit];
    self.timeLabel.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - UserImageLeftMargin*Proportion - self.timeLabel.frame.size.width,
                                      self.nickNameLabel.frame.origin.y,
                                      self.timeLabel.frame.size.width,
                                      self.timeLabel.frame.size.height);
    self.commentContentLabel.text = self.commentContent;
    CGRect rectOfCommentLabel = [self.commentContent boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - self.nickNameLabel.frame.origin.x - UserImageLeftMargin*Proportion, 10000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:KSystemFontSize11} context:nil];
    self.commentContentLabel.frame = CGRectMake(self.nickNameLabel.frame.origin.x,
                                                CGRectGetMaxY(self.nickNameLabel.frame) + UserImageTopMargin*Proportion,
                                                [UIScreen mainScreen].bounds.size.width - UserImageLeftMargin*Proportion - self.nickNameLabel.frame.origin.x ,
                                                rectOfCommentLabel.size.height);
    
    return UserImageTopMargin*Proportion*2 + CGRectGetMaxY(self.nickNameLabel.frame) + self.commentContentLabel.frame.size.height;

}
@end
