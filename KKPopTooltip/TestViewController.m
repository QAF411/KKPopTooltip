//
//  TestViewController.m
//  KKPopTooltip
//
//  Created by 刘继新 on 2020/7/14.
//  Copyright © 2020 刘继新. All rights reserved.
//

#import "TestViewController.h"
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>
#import "KKPopTooltip.h"
#import "LFBubbleView.h"

@interface TestViewController ()<DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *footerButtom;
@property (weak, nonatomic) IBOutlet UIButton *footeRightButton;
@property (nonatomic, strong) LFBubbleView *bubbleView;

@end

@implementation TestViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"KKTooltip";
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;

    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(rightClick:)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCamera target:self action:@selector(leftClick:)];
    
//    [self performSelector:@selector(startTooltip) withObject:nil afterDelay:0.5];
//
//
//    [KKPopTooltip showPointing:CGPointMake(self.view.frame.size.width/2, 200) inView:self.view message:@"指定一个点弹出" arrowPosition:TooltipArrowPositionTop];
    
    NSString *strTip = @"这个是用来演示的文字";
    NSMutableAttributedString *str2 = [[NSMutableAttributedString alloc] initWithString:strTip];
    [str2 addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, 3)];
    [str2 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:10] range:NSMakeRange(3, 7)];
    
    [_bubbleView removeFromSuperview];
    _bubbleView  = [[LFBubbleView alloc] initWithFrame:CGRectMake(0, 0, 684/2.0, 106/2.0)];
    _bubbleView.direction = LFTriangleDirection_Up;
    _bubbleView.lbTitle.attributedText = str2;
    _bubbleView.color = [UIColor blackColor];
    _bubbleView.cornerRadius = 10;
    _bubbleView.triangleH = 8;
    _bubbleView.triangleW = 12;
    _bubbleView.triangleXY = 20;
    [self.view addSubview:_bubbleView];
//    [_bubbleView showInPoint:CGPointMake(self.navigationItem.leftBarButtonItem.center.x, self.navigationItem.rightBarButtonItem.center.y - 8)];
    [_bubbleView showInPoint:[self showAtBarButtonItem:self.navigationItem.leftBarButtonItem contentView:self.view]];
}

- (CGPoint)showAtBarButtonItem:(UIBarButtonItem *)barButtonItem contentView:(UIView *)contentView  {
//    if (![barButtonItem isKindOfClass:[UIBarButtonItem class]]) {return nil; }
    UIView *targetView = (UIView *)[barButtonItem performSelector:@selector(view)];
    UIView *containerView = [UIApplication sharedApplication].keyWindow;
    
    CGRect rect = [containerView convertRect:targetView.frame fromView:targetView.superview];
    CGPoint point = CGPointMake(rect.origin.x + rect.size.width/2, rect.origin.y + rect.size.height);
    return point;
}

- (void)rightClick:(id)sender {
    NSArray *items = @[@{@"icon":@"sm_message", @"title":@" 发起群聊"},
                       @{@"icon":@"add", @"title":@" 添加朋友"},
                       @{@"icon":@"qrcode", @"title":@" 扫一扫"},
                       @{@"icon":@"card", @"title":@" 收付款"}];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 44 * items.count)];
    NSInteger index = 0;
    for (NSDictionary *dic in items) {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, index * 44, 100, 44)];
        [btn setImage:[UIImage imageNamed:dic[@"icon"]] forState:UIControlStateNormal];
        [btn setTitle:dic[@"title"] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:16];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(menuBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:btn];
        if (index < items.count - 1) {
            CALayer *line = [[CALayer alloc] init];
            line.frame = CGRectMake(0, 44 - 0.5, 100, 0.5f);
            line.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1].CGColor;
            [btn.layer addSublayer:line];
        }
        index++;
    }
    KKPopTooltip *pop = [KKPopTooltip showAtBarButtonItem:self.navigationItem.rightBarButtonItem contentView:view arrowPosition:TooltipArrowPositionTop];
    pop.userInteractionEnabled = false;
    pop.tag = 100;
}

- (void)menuBtnClick:(UIButton *)btn {
    KKPopTooltip *pop = (KKPopTooltip *)[[UIApplication sharedApplication].keyWindow viewWithTag:100];
    [pop dismissAnimation:YES];
}

- (void)leftClick:(id)sender {
//    KKPopTooltip *pop = [KKPopTooltip showAtBarButtonItem:sender message:@"when you verification is completed and “Thank you” appears , please click “OK” or “Done”" arrowPosition:TooltipArrowPositionTop];
//    pop.contentView.backgroundColor = [UIColor blackColor];
    
    NSString *strTip = @"when you verification is completed and “Thank you” appears , please click “OK” or “Done”";
    NSMutableAttributedString *str2 = [[NSMutableAttributedString alloc] initWithString:strTip];
    [str2 addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(74, 14)];
    
    [KKPopTooltip showAtBarButtonItem:sender message:str2 arrowPosition:TooltipArrowPositionTop];
    
//    [str2 addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, 3)];
//    [str2 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:10] range:NSMakeRange(3, 7)];
    
}

- (IBAction)footerButtomClick:(id)sender {
    [KKPopTooltip showPointingAtView:self.footerButtom inView:self.view message:@"添加照片、视频" arrowPosition:TooltipArrowPositionBottom];
}

- (IBAction)footeRightButtonClick:(id)sender {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 25)];
    for (NSInteger index = 0; index < 6; index++) {
        UIView *itemview = [[UIView alloc] initWithFrame:CGRectMake(10 + index * 30, 0, 25, 25)];
        itemview.backgroundColor = [UIColor redColor];
        itemview.layer.cornerRadius = 25/2.0;
        [view addSubview:itemview];
    }
    [KKPopTooltip showPointingAtView:self.footeRightButton inView:self.view contentView:view arrowPosition:TooltipArrowPositionBottom];
}

- (void)startTooltip {
    [self leftClick:self.navigationItem.leftBarButtonItem];
}

#pragma mark - DZNEmptyDataSetSource & Delegate

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *text = @"TopsTech Direct";
    UIFont *font = [UIFont boldSystemFontOfSize:20.0];
    UIColor *textColor = [UIColor blackColor];
    NSMutableDictionary *attributes = [NSMutableDictionary new];
    if (font) [attributes setObject:font forKey:NSFontAttributeName];
    if (textColor) [attributes setObject:textColor forKey:NSForegroundColorAttributeName];
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *text = @"将私人照片、视频和消息发送至个人或群。";
    UIFont *font = [UIFont systemFontOfSize:15.0];
    UIColor *textColor = [UIColor blackColor];
    NSMutableDictionary *attributes = [NSMutableDictionary new];
    if (font) [attributes setObject:font forKey:NSFontAttributeName];
    if (textColor) [attributes setObject:textColor forKey:NSForegroundColorAttributeName];
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"message.png"];
}

- (NSAttributedString *)buttonTitleForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state {
    return [[NSAttributedString alloc] initWithString:@"发消息" attributes:@{NSForegroundColorAttributeName:[UIColor blueColor]}];
}

- (void)emptyDataSet:(UIScrollView *)scrollView didTapButton:(UIButton *)button {
    [KKPopTooltip showPointingAtView:button inView:self.view message:@"将私人照片、视频和消息发送至个人或群" arrowPosition:TooltipArrowPositionTop];
}

@end
