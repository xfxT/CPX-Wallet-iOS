//
//  ApexCreatWalletController.m
//  Apex
//
//  Created by chinapex on 2018/5/7.
//  Copyright © 2018年 Chinapex. All rights reserved.
//

#import "ApexCreatWalletController.h"
#import "ApexAlertTextField.h"
#import "ApexImportWalletController.h"
#import "ApexWalletManager.h"
#import "ApexPrepareBackUpController.h"

#define RouteEventName_CallCreatWalletApi @"RouteEventName_CallCreatWalletApi"
#define RouteNameEvent_GoToImportWallet @"RouteNameEvent_GoToImportWallet"

@interface ApexCreatWalletController ()
@property (nonatomic, strong) UIImageView *backIV;
@property (nonatomic, strong) UIView *tipsView;
@property (nonatomic, strong) UILabel *tipsL;
@property (nonatomic, strong) UILabel *titleL;
@property (nonatomic, strong) UIButton *privacyAgreeBtn;
@property (nonatomic, strong) UILabel *privacyAgreeLable;
@property (nonatomic, strong) ApexAlertTextField *walletNameL;
@property (nonatomic, strong) ApexAlertTextField *passWordL;
@property (nonatomic, strong) ApexAlertTextField *repeatPassWordL;
@property (nonatomic, strong) UIButton *importBtn;
@property (nonatomic, strong) UIButton *creatBtn;
@property (nonatomic, strong) RACSignal *combineSignal;
@end

@implementation ApexCreatWalletController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [_walletNameL becomeFirstResponder];
}


#pragma mark - private
- (void)initUI{
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.navigationController lt_setBackgroundColor:[UIColor clearColor]];
    self.navigationItem.titleView = self.titleL;
    
    [self.view addSubview:self.walletNameL];
    [self.view addSubview:self.passWordL];
    [self.view addSubview:self.repeatPassWordL];
    [self.view addSubview:self.creatBtn];
    [self.view addSubview:self.backIV];
    [self.view addSubview:self.tipsView];
    [self.view addSubview:self.privacyAgreeBtn];
    [self.view addSubview:self.privacyAgreeLable];
    [self.view addSubview:self.importBtn];
    [self.tipsView addSubview:self.tipsL];
    
    [self.backIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.height.mas_equalTo(scaleHeight667(192));
    }];
    
    [self.tipsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.width.mas_equalTo(scaleWidth375(290));
        make.height.mas_equalTo(scaleHeight667(160));
        make.top.equalTo(self.backIV).offset(scaleHeight667(96));
    }];
    
    [self.walletNameL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tipsView.mas_bottom).offset(35);
        make.centerX.equalTo(self.view.mas_centerX);
        make.width.mas_equalTo(scaleWidth375(231));
        make.height.mas_equalTo(44);
    }];
    
    [self.passWordL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.walletNameL.mas_bottom).offset(30);
        make.left.right.equalTo(self.walletNameL);
        make.height.equalTo(self.walletNameL);
    }];
    
    [self.repeatPassWordL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.passWordL.mas_bottom).offset(30);
        make.left.right.equalTo(self.walletNameL);
        make.height.equalTo(self.walletNameL);
    }];
    
    
    [self.privacyAgreeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.walletNameL);
        make.top.equalTo(self.repeatPassWordL.mas_bottom).offset(30);
        make.width.height.mas_equalTo(20);
    }];
    
    [self.privacyAgreeLable  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.privacyAgreeBtn.mas_right).offset(15);
        make.centerY.equalTo(self.privacyAgreeBtn.mas_centerY);
    }];
    
    [self.creatBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.privacyAgreeLable.mas_bottom).offset(40);
        make.centerX.equalTo(self.view.mas_centerX);
        make.width.mas_equalTo(scaleWidth375(165));
        make.height.mas_equalTo(40);
    }];
    
    [self.importBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.creatBtn.mas_bottom).offset(15);
        make.centerX.equalTo(self.view.mas_centerX);
        make.width.mas_equalTo(scaleWidth375(80));
        make.height.mas_equalTo(scaleHeight667(30));
    }];
    
    [self.tipsL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tipsL.superview).offset(10);
        make.bottom.equalTo(self.tipsL.superview).offset(-10);
        make.left.equalTo(self.tipsL.superview).offset(10);
        make.right.equalTo(self.tipsL.superview).offset(-10);
    }];

    RAC(self.creatBtn, enabled) = self.combineSignal;
}
- (void)routeEventWithName:(NSString *)eventName userInfo:(NSDictionary *)userinfo{
    
    if ([eventName isEqualToString:RouteEventName_CallCreatWalletApi]) {
        
        NeomobileWallet *wallet = [self creatWallet];
        
        if (wallet == nil) {
            return;
        }
        ApexPrepareBackUpController *vc = [[ApexPrepareBackUpController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        vc.address = wallet.address;
        vc.BackupCompleteBlock = ^{
            if (self.didFinishCreatSub) {
                [self.didFinishCreatSub sendNext:@""];
            }
        };
        [self.navigationController pushViewController:vc animated:YES];

    }else if ([eventName isEqualToString:RouteNameEvent_GoToImportWallet]){
//        [self showMessage:@"正在开发中..."];
        ApexImportWalletController *importVC = [[ApexImportWalletController alloc] init];
        [self.navigationController pushViewController:importVC animated:YES];
    }
    
    
    [super routeEventWithName:eventName userInfo:userinfo];
}

//创建钱包
- (NeomobileWallet*)creatWallet{
    NSError *err = nil;
    NSError *keystoreErr = nil;
    
    NeomobileWallet *wallet = NeomobileNew(&err);
    if (err) {
        [self showMessage:[NSString stringWithFormat:@"钱包创建失败: %@",err]];
        return nil;
    }
//    NSLog(@"%@",[wallet mnemonic:mnemonicEnglish error:nil]);
    NSString *keystore = [wallet toKeyStore:self.passWordL.text error:&keystoreErr];
    if (keystoreErr) {
        [self showMessage:[NSString stringWithFormat:@"keystore创建失败: %@",keystoreErr]];
        return nil;
    }
    
    NSString *address = wallet.address;
    
    [PDKeyChain save:KEYCHAIN_KEY(address) data:keystore];
    
    [ApexWalletManager saveWallet:[NSString stringWithFormat:@"%@/%@",address, self.walletNameL.text]];
    
    return wallet;
}

#pragma mark - public

#pragma mark - delegate & datasource

#pragma mark - getter & setter
- (RACSignal *)combineSignal{
    if (!_combineSignal) {
        _combineSignal = [RACSignal combineLatest:@[self.walletNameL.rac_textSignal, self.passWordL.rac_textSignal, self.repeatPassWordL.rac_textSignal, RACObserve(self.privacyAgreeBtn, selected),RACObserve(self.walletNameL, isAlertShowing),RACObserve(self.passWordL, isAlertShowing),RACObserve(self.repeatPassWordL, isAlertShowing)] reduce:^id (NSString *walletName, NSString*passw, NSString*rePassw, NSNumber* selected,NSNumber* nameAlert,NSNumber* passAlert,NSNumber* repeatAlert){
            BOOL flag = false;
            if (walletName.length != 0 && passw.length >= 6 && [rePassw isEqualToString:passw] && selected.boolValue && !nameAlert.boolValue && !passAlert.boolValue && !repeatAlert.boolValue) {
                flag = true;
            }
            return @(flag);
        }];
    }
    return _combineSignal;
}

- (UIImageView *)backIV{
    if (!_backIV) {
        _backIV = [[UIImageView alloc] init];
        _backIV.image = [UIImage imageNamed:@"Background"];
    }
    return _backIV;
}

- (UIView *)tipsView{
    if (!_tipsView) {
        _tipsView = [[UIView alloc] init];
        _tipsView.backgroundColor = [UIColor whiteColor];
        _tipsView.layer.cornerRadius = 6;
        _tipsView.layer.shadowColor = [UIColor darkGrayColor].CGColor;
        _tipsView.layer.shadowOffset = CGSizeMake(0, 1);
        _tipsView.layer.shadowOpacity = 0.5;
    }
    return _tipsView;
}

- (UILabel *)titleL{
    if (!_titleL) {
        _titleL = [[UILabel alloc] init];
        _titleL.frame = CGRectMake(152, 30, 72.5, 25);
        _titleL.text = @"创建钱包";
        _titleL.font = [UIFont fontWithName:@"PingFangSC-Regular" size:18];
        _titleL.textColor = [UIColor colorWithRed:255/255 green:255/255 blue:255/255 alpha:1];
    }
    return _titleL;
}

- (ApexAlertTextField *)walletNameL{
    if (!_walletNameL) {
        _walletNameL = [[ApexAlertTextField alloc] initWithFrame:CGRectZero];
        _walletNameL.font = [UIFont systemFontOfSize:13];
        _walletNameL.floatingLabelYPadding = 5;
        // 浮动式标签的正常字体颜色
        _walletNameL.floatingLabelTextColor = [UIColor colorWithHexString:@"555555"];
        // 输入框成为第一响应者时,浮动标签的文字颜色.
        _walletNameL.floatingLabelActiveTextColor = [ApexUIHelper mainThemeColor];
        // 指明当输入文字时,是否下调基准线(baseline).设置为YES(非默认值),意味着占位内容会和输入内容对齐.
        _walletNameL.keepBaseline = YES;
        // 设置占位符文字和浮动式标签的文字.
        [_walletNameL setPlaceholder:@"钱包名称"
                             floatingTitle:@"钱包名称"];
        _walletNameL.alertString = @"请输入最多八个字符";
        _walletNameL.alertShowConditionBlock = ^BOOL(NSString *text) {
            if (text.length <= 8 && text.length > 0) {
                return false;
            }
            return true;
        };
        _walletNameL.clearButtonMode = UITextFieldViewModeWhileEditing;
        
        
    }
    return _walletNameL;
}

- (ApexAlertTextField *)passWordL{
    if (!_passWordL) {
        _passWordL = [[ApexAlertTextField alloc] initWithFrame:CGRectZero];
        _passWordL.font = [UIFont systemFontOfSize:13];
        _passWordL.floatingLabelYPadding = 5;
        // 浮动式标签的正常字体颜色
        _passWordL.floatingLabelTextColor = [UIColor colorWithHexString:@"555555"];
        // 输入框成为第一响应者时,浮动标签的文字颜色.
        _passWordL.floatingLabelActiveTextColor = [ApexUIHelper mainThemeColor];
        // 指明当输入文字时,是否下调基准线(baseline).设置为YES(非默认值),意味着占位内容会和输入内容对齐.
        _passWordL.keepBaseline = YES;
        // 设置占位符文字和浮动式标签的文字.
        [_passWordL setPlaceholder:@"密码(不少于6个字符)"
                       floatingTitle:@"密码"];
        _passWordL.clearButtonMode = UITextFieldViewModeWhileEditing;
        
        _passWordL.alertString = @"不少于6个字符";
        _passWordL.alertShowConditionBlock = ^BOOL(NSString *text) {
            if (text.length<6) {
                return true;
            }
            return false;
        };
        
        _passWordL.secureTextEntry = YES;
    }
    return _passWordL;
}

- (ApexAlertTextField *)repeatPassWordL{
    if (!_repeatPassWordL) {
        _repeatPassWordL = [[ApexAlertTextField alloc] initWithFrame:CGRectZero];
        _repeatPassWordL.font = [UIFont systemFontOfSize:13];
        _repeatPassWordL.floatingLabelYPadding = 5;
        // 浮动式标签的正常字体颜色
        _repeatPassWordL.floatingLabelTextColor = [UIColor colorWithHexString:@"555555"];
        // 输入框成为第一响应者时,浮动标签的文字颜色.
        _repeatPassWordL.floatingLabelActiveTextColor = [ApexUIHelper mainThemeColor];
        // 指明当输入文字时,是否下调基准线(baseline).设置为YES(非默认值),意味着占位内容会和输入内容对齐.
        _repeatPassWordL.keepBaseline = YES;
        // 设置占位符文字和浮动式标签的文字.
        [_repeatPassWordL setPlaceholder:@"重复密码(不少于6个字符)"
                     floatingTitle:@"重复密码"];
        _repeatPassWordL.clearButtonMode = UITextFieldViewModeWhileEditing;
        
        @weakify(self);
        _repeatPassWordL.alertString = @"输入密码不相符";
        _repeatPassWordL.alertShowConditionBlock = ^BOOL(NSString *text) {
            @strongify(self)
            
            if ([text isEqualToString:self.passWordL.text]) {
                return false;
            }
            return true;
        };
        
        _repeatPassWordL.secureTextEntry = YES;
    }
    return _repeatPassWordL;
}

- (UIButton *)creatBtn{
    if (!_creatBtn) {
        _creatBtn = [[UIButton alloc] init];
        _creatBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [_creatBtn setTitle:@"确定" forState:UIControlStateNormal];
        _creatBtn.layer.cornerRadius = 6;
        [[RACObserve(_creatBtn, enabled) takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSNumber *x) {
            if (x.boolValue) {
                [_creatBtn setBackgroundColor:[ApexUIHelper mainThemeColor]];
            }else{
                [_creatBtn setBackgroundColor:[ApexUIHelper grayColor]];
            }
        }];
        _creatBtn.enabled = false;
        [[_creatBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            [self routeEventWithName:RouteEventName_CallCreatWalletApi userInfo:@{}];
        }];
    }
    return _creatBtn;
}

- (UIButton *)privacyAgreeBtn{
    if (!_privacyAgreeBtn) {
        _privacyAgreeBtn = [[UIButton alloc] init];
        [_privacyAgreeBtn setImage:[UIImage imageNamed:@"Group 3-1"] forState:UIControlStateNormal];
        [_privacyAgreeBtn setImage:[UIImage imageNamed:@"Group 4"] forState:UIControlStateSelected];
        [_privacyAgreeBtn setEnlargeEdge:20];
        [[_privacyAgreeBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            _privacyAgreeBtn.selected = !_privacyAgreeBtn.selected;
        }];
    }
    return _privacyAgreeBtn;
}

- (UILabel *)privacyAgreeLable{
    if (!_privacyAgreeLable) {
        _privacyAgreeLable = [[UILabel alloc] init];
        _privacyAgreeLable.font = [UIFont systemFontOfSize:10];
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"我已仔细阅读并同意服务及隐私条款"];
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:NSMakeRange(9, 7)];
        _privacyAgreeLable.attributedText = str;
    }
    return _privacyAgreeLable;
}

- (UIButton *)importBtn{
    if (!_importBtn) {
        _importBtn = [[UIButton alloc] init];
        [_importBtn setTitle:@"导入钱包" forState:UIControlStateNormal];
        _importBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [_importBtn setTitleColor:[ApexUIHelper textColor] forState:UIControlStateNormal];
        [ApexUIHelper addLineInView:_importBtn color:[ApexUIHelper textColor] edge:UIEdgeInsetsMake(-1, 0, 0, 0)];
        [[_importBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            [self routeEventWithName:RouteNameEvent_GoToImportWallet userInfo:@{}];
        }];
    }
    return _importBtn;
}

- (UILabel *)tipsL{
    if (!_tipsL) {
        _tipsL = [[UILabel alloc] init];
        _tipsL.text = @"您将在这个设备上生成一个新的加密的脱机钱包。我们建议选择一个强密码，确保您的资金安全。PS：生成一个强大安全的钱包是一个高度计算密集型的任务，可能需要几分钟。这个过程将在后台执行，期间您仍然可用您的手机，一旦我们完成了您的钱包，我们会让你知道。";
        _tipsL.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
        _tipsL.textColor = [UIColor colorWithRed:102/255 green:102/255 blue:102/255 alpha:1];
        _tipsL.textAlignment = NSTextAlignmentCenter;
        _tipsL.numberOfLines = 0;
    }
    return _tipsL;
}

@end
