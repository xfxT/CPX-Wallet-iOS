//
//  ApexWalletManager.h
//  Apex
//
//  Created by chinapex on 2018/5/21.
//  Copyright © 2018年 Chinapex. All rights reserved.
//

#import <Foundation/Foundation.h>
#define walletsKey @"walletsKey"
@interface ApexWalletManager : NSObject
+ (void)saveWallet:(NSString*)wallet;
+ (id)getWalletsArr;
@end