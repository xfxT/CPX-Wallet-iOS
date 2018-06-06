//
//  ApexMorePanelController.m
//  Apex
//
//  Created by chinapex on 2018/6/5.
//  Copyright © 2018年 Gary. All rights reserved.
//

#import "ApexMorePanelController.h"
#import "ApexMoreTopCell.h"
#import "ApexMoreFuncCell.h"
#import "ApexCreatWalletController.h"
#import "ApexSendMoneyController.h"
#import "ApexScanAction.h"

@interface ApexMorePanelController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation ApexMorePanelController

#pragma mark - ------life cycle------
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
}

#pragma mark - ------private------
- (void)initUI{
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.equalTo(self.view);
        make.width.mas_equalTo(scaleWidth375(150));
    }];
    
    [self.tableView registerClass:[ApexMoreTopCell class] forCellReuseIdentifier:@"topCell"];
    [self.tableView registerClass:[ApexMoreFuncCell class] forCellReuseIdentifier:@"funcCell"];
}


#pragma mark - ------public------

#pragma mark - ------delegate & datasource------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        ApexMoreTopCell *topCell = [tableView dequeueReusableCellWithIdentifier:@"topCell" forIndexPath:indexPath];
        topCell.walletArr = self.walletsArr;
        return topCell;
    }else{
        ApexMoreFuncCell *funcCell = [tableView dequeueReusableCellWithIdentifier:@"funcCell" forIndexPath:indexPath];
        return funcCell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return self.walletsArr.count * 40;
    }else{
        return 40*2;
    }
}

#pragma mark - ------eventResponse------
- (void)routeEventWithName:(NSString *)eventName userInfo:(NSDictionary *)userinfo{
    if ([eventName isEqualToString:RouteNameEvent_FuncCellDidClickScan]){
        [ApexScanAction shareScanHelper].curWallet = self.curWallet;
        [ApexScanAction scanActionOnViewController:self];
    }else if ([eventName isEqualToString:RouteNameEvent_FuncCellDidClickCreat]){
        ApexCreatWalletController *wvc = [[ApexCreatWalletController alloc] init];
        [self directlyPushToViewControllerWithSelfDeleted:wvc];
    }
}

#pragma mark - ------getter & setter------
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}
@end
