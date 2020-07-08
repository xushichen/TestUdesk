//
//  UdeskNewsCell.m
//  UdeskSDK
//
//  Created by xuchen on 2019/1/21.
//  Copyright © 2019 Udesk. All rights reserved.
//

#import "UdeskNewsCell.h"
#import "UdeskNewsMessage.h"
#import "Udesk_YYWebImage.h"
#import "UdeskSDKShow.h"
#import "UIView+UdeskSDK.h"

static NSString *kUDNewsTopAskQuestionCellId = @"kUDNewsTopAskQuestionCellId";

@interface UdeskNewsTopAskOptionsCell : UITableViewCell

@property (nonatomic, strong) UIImageView *optionTagImageView;
@property (nonatomic, strong) UILabel *optionTitleLabel;

@end

@implementation UdeskNewsTopAskOptionsCell

- (UIImageView *)optionTagImageView {
    if (!_optionTagImageView) {
        _optionTagImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _optionTagImageView.image = [UIImage udDefaultListTag];
        _optionTagImageView.backgroundColor = [UIColor clearColor];
        [self addSubview:_optionTagImageView];
    }
    return _optionTagImageView;
}

- (UILabel *)optionTitleLabel {
    if (!_optionTitleLabel) {
        _optionTitleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _optionTitleLabel.font = [UIFont systemFontOfSize:15];
        _optionTitleLabel.numberOfLines = 0;
        _optionTitleLabel.textColor = [UIColor colorWithRed:0.255f  green:0.557f  blue:0.949f alpha:1];
        _optionTitleLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:_optionTitleLabel];
    }
    return _optionTitleLabel;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.optionTagImageView.frame = CGRectMake(kUDBubbleToNewsHorizontalSpacing, kUDBubbleToNewsVerticalSpacing, kUDNewsOptionTagWidth, kUDNewsOptionTagHeight);
    
    CGFloat titleX = self.optionTagImageView.udRight+kUDNewsOptionToTagHorizontalSpacing;
    self.optionTitleLabel.frame = CGRectMake(titleX, kUDNewsTopAskQuestionVerticalSpacing, self.udWidth-titleX-kUDBubbleToNewsHorizontalSpacing, self.udHeight-kUDBubbleToNewsVerticalSpacing);
}

@end

@interface UdeskNewsCell()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>

@property (nonatomic, strong) UILabel *newsTitleLabel;
@property (nonatomic, strong) UILabel *newsDescLabel;
@property (nonatomic, strong) UIImageView *newsImageView;

@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UITableView *topAskTableView;

@end

@implementation UdeskNewsCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    
    _newsTitleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _newsTitleLabel.numberOfLines = 2;
    _newsTitleLabel.font = [UIFont systemFontOfSize:16];
    _newsTitleLabel.textColor = [UIColor colorWithRed:0.129f  green:0.129f  blue:0.129f alpha:1];
    _newsTitleLabel.backgroundColor = [UIColor clearColor];
    [self.bubbleImageView addSubview:_newsTitleLabel];
    
    _newsDescLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _newsDescLabel.numberOfLines = 2;
    _newsDescLabel.font = [UIFont systemFontOfSize:12];
    _newsDescLabel.backgroundColor = [UIColor clearColor];
    _newsDescLabel.textColor = [UIColor colorWithRed:0.455f  green:0.459f  blue:0.471f alpha:1];
    [self.bubbleImageView addSubview:_newsDescLabel];
    
    _newsImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self.bubbleImageView addSubview:_newsImageView];
    
    _lineView = [[UIView alloc] initWithFrame:CGRectZero];
    _lineView.backgroundColor = [UIColor colorWithRed:0.953f  green:0.961f  blue:0.965f alpha:1];
    [self.bubbleImageView addSubview:_lineView];
    
    _topAskTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _topAskTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _topAskTableView.delegate = self;
    _topAskTableView.dataSource = self;
    _topAskTableView.sectionFooterHeight = 0;
    _topAskTableView.tableFooterView = [UIView new];
    _topAskTableView.backgroundColor = [UIColor clearColor];
    [self.bubbleImageView addSubview:_topAskTableView];
    
    [_topAskTableView registerClass:[UdeskNewsTopAskOptionsCell class] forCellReuseIdentifier:kUDNewsTopAskQuestionCellId];
    
    //添加图片点击手势
    UITapGestureRecognizer *tapContentImage = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapNewsMessageViewAction:)];
    tapContentImage.delegate = self;
    [self.bubbleImageView addGestureRecognizer:tapContentImage];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if (CGRectContainsPoint([self.topAskTableView bounds], [touch locationInView:self.topAskTableView])){
        return NO;
    }
    
    return YES;
}

- (void)tapNewsMessageViewAction:(UITapGestureRecognizer *)tap {
    
    [UdeskSDKShow pushWebViewOnViewController:[UdeskSDKUtil currentViewController] URL:[NSURL URLWithString:self.baseMessage.message.newsAnswerUrl]];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.baseMessage.message.topAsk.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    UdeskMessageTopAsk *topAsk = self.baseMessage.message.topAsk[section];
    if (self.baseMessage.message.topAsk.count == 1) {
        return topAsk.optionsList.count;
    }
    return topAsk.isUnfold ? topAsk.optionsList.count : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UdeskNewsTopAskOptionsCell *cell = [tableView dequeueReusableCellWithIdentifier:kUDNewsTopAskQuestionCellId forIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (self.baseMessage.message.topAsk.count > indexPath.section) {
        
        if (self.baseMessage.message.topAsk.count > indexPath.section) {
            UdeskMessageTopAsk *topAsk = self.baseMessage.message.topAsk[indexPath.section];
            if (topAsk.optionsList.count > indexPath.row) {
                UdeskMessageOption *option = topAsk.optionsList[indexPath.row];
                cell.optionTitleLabel.text = option.value;
            }
        }
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UdeskNewsMessage *newsMessage = (UdeskNewsMessage *)self.baseMessage;
    if (!newsMessage || ![newsMessage isKindOfClass:[UdeskNewsMessage class]]) return 0;
    if (indexPath.row >= newsMessage.questionHeightArray.count) return 0;
    
    NSNumber *height = newsMessage.questionHeightArray[indexPath.row];
    
    return height.floatValue;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self didSelectRobotHitMessageAtIndexPath:indexPath];
}

- (void)updateCellWithMessage:(UdeskBaseMessage *)baseMessage {
    [super updateCellWithMessage:baseMessage];
    
    UdeskNewsMessage *newsMessage = (UdeskNewsMessage *)baseMessage;
    if (!newsMessage || ![newsMessage isKindOfClass:[UdeskNewsMessage class]]) return;
    
    self.newsTitleLabel.attributedText = newsMessage.titleAttributedString;
    self.newsTitleLabel.frame = newsMessage.titleFrame;
    
    self.newsDescLabel.attributedText = newsMessage.descAttributedString;
    self.newsDescLabel.frame = newsMessage.descFrame;
    
    self.newsImageView.frame = newsMessage.imgFrame;
    NSURL *url = [NSURL URLWithString:[newsMessage.imgURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    [self.newsImageView udesk_yy_setImageWithURL:url placeholder:[UIImage udDefaultLoadingImage]];
    
    self.lineView.frame = newsMessage.lineFrame;
    
    self.topAskTableView.frame = newsMessage.topAskFrame;
    [self.topAskTableView reloadData];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
