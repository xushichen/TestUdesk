//
//  UdeskVideoCallMessage.m
//  UdeskSDK
//
//  Created by xuchen on 2017/12/6.
//  Copyright © 2017年 Udesk. All rights reserved.
//

#import "UdeskVideoCallMessage.h"
#import "UdeskVideoCallCell.h"

/** 聊天气泡和其中的文字水平间距 */
static CGFloat const kUDBubbleToCallTextHorizontalSpacing = 14.0;
/** 聊天气泡和其中的文字垂直间距 */
static CGFloat const kUDBubbleToCallTextVerticalSpacing = 9.0;

@interface UdeskVideoCallMessage()

//文本frame(包括下方留白)
@property (nonatomic, assign, readwrite) CGRect  textFrame;
/** 消息的文字 */
@property (nonatomic, copy  , readwrite) NSAttributedString *cellText;

@end

@implementation UdeskVideoCallMessage

- (instancetype)initWithMessage:(UdeskMessage *)message displayTimestamp:(BOOL)displayTimestamp
{
    self = [super initWithMessage:message displayTimestamp:displayTimestamp];
    if (self) {
        
        [self layoutTextMessage];
    }
    return self;
}

- (void)layoutTextMessage {
    
    @try {
        
        if (!self.message.content || [NSNull isEqual:self.message.content]) return;
        if ([UdeskSDKUtil isBlankString:self.message.content]) return;
        
        
        UIColor *color = [UdeskSDKConfig customConfig].sdkStyle.agentTextColor;
        if (self.message.messageFrom == UDMessageTypeSending) {
            color = [UdeskSDKConfig customConfig].sdkStyle.customerTextColor;
        }
        
        //设置字体颜色
        NSDictionary *dictAttr1 = @{NSForegroundColorAttributeName:color,
                                    NSFontAttributeName:[UdeskSDKConfig customConfig].sdkStyle.messageContentFont
                                    };
        NSAttributedString *attr1 = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"  %@",self.message.content] attributes:dictAttr1];
        
        //创建富文本
        NSMutableAttributedString *mAttr = [[NSMutableAttributedString alloc] initWithAttributedString:attr1];
        
        //NSTextAttachment可以将要插入的图片作为特殊字符处理
        NSTextAttachment *attch = [[NSTextAttachment alloc] init];
        //定义图片内容及位置和大小
        attch.image = self.message.messageFrom == UDMessageTypeSending ? [UIImage udDefaultVideoCallImage] : [UIImage udDefaultVideoCallReceiveImage];
        attch.bounds = CGRectMake(0, 0, 20, 13);
        //创建带有图片的富文本
        NSAttributedString *string = [NSAttributedString attributedStringWithAttachment:attch];
        //将图片放在第一位
        [mAttr insertAttributedString:string atIndex:0];
        
        self.cellText = mAttr;
        
        CGSize textSize = [UdeskStringSizeUtil sizeWithAttributedText:mAttr size:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)];
        
        switch (self.message.messageFrom) {
            case UDMessageTypeSending:{
                
                //文本气泡frame
                CGFloat bubbleWidth = textSize.width+(kUDBubbleToCallTextHorizontalSpacing*2);
                CGFloat bubbleX = UD_SCREEN_WIDTH-kUDBubbleToHorizontalEdgeSpacing-bubbleWidth;
                self.bubbleFrame = CGRectMake(bubbleX, CGRectGetMaxY(self.avatarFrame)+kUDAvatarToBubbleSpacing, bubbleWidth, textSize.height+(kUDBubbleToCallTextVerticalSpacing*2));
                //文本frame
                self.textFrame = CGRectMake(kUDBubbleToCallTextHorizontalSpacing, kUDBubbleToCallTextVerticalSpacing, textSize.width, textSize.height);
                
                break;
            }
            case UDMessageTypeReceiving:{
                
                //接收文字气泡frame
                self.bubbleFrame = CGRectMake(kUDBubbleToHorizontalEdgeSpacing, CGRectGetMaxY(self.avatarFrame)+kUDAvatarToBubbleSpacing, textSize.width+(kUDBubbleToCallTextHorizontalSpacing*2), textSize.height+(kUDBubbleToCallTextVerticalSpacing*2));
                //接收文字frame
                self.textFrame = CGRectMake(kUDBubbleToCallTextHorizontalSpacing, kUDBubbleToCallTextVerticalSpacing, textSize.width, textSize.height);
                
                break;
            }
                
            default:
                break;
        }
        
        //cell高度
        self.cellHeight = self.bubbleFrame.size.height+self.bubbleFrame.origin.y+kUDCellBottomMargin;
        
    } @catch (NSException *exception) {
        NSLog(@"%@",exception);
    } @finally {
    }
}

- (UITableViewCell *)getCellWithReuseIdentifier:(NSString *)cellReuseIdentifer {
    
    return [[UdeskVideoCallCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellReuseIdentifer];
}

@end
