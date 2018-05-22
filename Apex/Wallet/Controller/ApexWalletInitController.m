//
//  ApexWalletInitController.m
//  Apex
//
//  Created by chinapex on 2018/5/7.
//  Copyright © 2018年 Chinapex. All rights reserved.
//

#import "ApexWalletInitController.h"
#import "ApexCreatWalletController.h"
#import "ApexImportWalletController.h"


#define RouteEventName_CreatWallet @"RouteEventName_CreatWallet"
#define RouteEventName_ImportWallet @"RouteEventName_ImportWallet"

@interface ApexWalletInitController ()
@property (nonatomic, strong) ZJNButton *creatWalletBtn;
@property (nonatomic, strong) ZJNButton *importWalletBtn;
@property (nonatomic, strong) UIImageView *backIV;
@property (nonatomic, strong) UIImageView *logoIV;
@end

@implementation ApexWalletInitController
#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated{
    self.navigationController.navigationBar.hidden = NO;
    [super viewWillDisappear:animated];
}

#pragma mark - private
- (void)initUI{
    [self.view addSubview:self.backIV];
    
    [self.view addSubview:self.creatWalletBtn];
    [self.view addSubview:self.importWalletBtn];
    [self.view addSubview:self.logoIV];
    
    [self.logoIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(scaleWidth375(174));
        make.centerX.equalTo(self.view.mas_centerX);
        make.width.mas_equalTo(scaleWidth375(194));
        make.height.mas_equalTo(scaleHeight667(45));
    }];
    
    [self.creatWalletBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(self.logoIV).offset(scaleHeight667(179));
        make.width.mas_equalTo(scaleWidth375(165));
        make.height.mas_equalTo(scaleHeight667(40));
    }];
    
    [self.importWalletBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(self.creatWalletBtn.mas_bottom).offset(15);
        make.width.mas_equalTo(scaleWidth375(165));
        make.height.mas_equalTo(scaleHeight667(40));
    }];
}

- (void)routeEventWithName:(NSString *)eventName userInfo:(NSDictionary *)userinfo{
    
    if ([eventName isEqualToString:RouteEventName_CreatWallet]) {
        /**< 创建钱包 */
        ApexCreatWalletController *cwvc = [[ApexCreatWalletController alloc] init];
        cwvc.didFinishCreatSub = self.didFinishCreatSub;
        [self.navigationController pushViewController:cwvc animated:YES];
        
    }else{
        /**< 导入钱包 */
        [self showMessage:@"暂未开放"];
//        ApexImportWalletController *iwvc = [[ApexImportWalletController alloc] init];
//        [self.navigationController pushViewController:iwvc animated:YES];
        
    }
    
    [super routeEventWithName:eventName userInfo:userinfo];
}

#pragma mark - public

#pragma mark - delegate & datasource

#pragma mark - getter & setter
- (ZJNButton *)creatWalletBtn{
    if (!_creatWalletBtn) {
        _creatWalletBtn = [[ZJNButton alloc] init];
        _creatWalletBtn.backgroundColor = [UIColor colorWithHexString:@"4C8EFA"];
        [_creatWalletBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _creatWalletBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_creatWalletBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_creatWalletBtn setTitle:@"创建钱包" forState:UIControlStateNormal];
        _creatWalletBtn.layer.cornerRadius = 6;
        [[[_creatWalletBtn rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(__kindof UIControl * _Nullable x) {
            [self routeEventWithName:RouteEventName_CreatWallet userInfo:@{}];
        }];
    }
    return _creatWalletBtn;
}

- (ZJNButton *)importWalletBtn{
    if (!_importWalletBtn) {
        _importWalletBtn = [[ZJNButton alloc] init];
        _importWalletBtn.backgroundColor = [UIColor colorWithHexString:@"4C8EFA"];
        [_importWalletBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _importWalletBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_importWalletBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_importWalletBtn setTitle:@"导入钱包" forState:UIControlStateNormal];
        _importWalletBtn.layer.cornerRadius = 6;
        [[[_importWalletBtn rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(__kindof UIControl * _Nullable x) {
            [self routeEventWithName:RouteEventName_ImportWallet userInfo:@{}];
        }];
    }
    return _importWalletBtn;
}

- (UIImageView *)backIV{
    if (!_backIV) {
        _backIV = [[UIImageView alloc] initWithFrame:self.view.frame];
        _backIV.image = [UIImage imageNamed:@"bg-1"];
    }
    return _backIV;
}

- (UIImageView *)logoIV{
    if (!_logoIV) {
        _logoIV = [[UIImageView alloc] init];
        _logoIV.image = [UIImage imageNamed:@"logo-1"];
    }
    return _logoIV;
}

@end