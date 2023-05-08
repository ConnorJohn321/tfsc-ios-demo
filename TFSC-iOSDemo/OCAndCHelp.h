//
//  OCAndCHelp.h
//
//  Created by Gavery on 2019/7/19.
//  Copyright © 2019 Gavery. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "sig.h"

NS_ASSUME_NONNULL_BEGIN


@interface OCAndCHelp : NSObject

+ (OCAndCHelp *)sharedManager;

-(void)setProfileResult:(void(^)(NSString * out_private_key , NSString * mnemonic , NSString * walletAddress))result;
-(void)importMnemonic:(NSString *)MnemonicString result:(void(^)(NSString * out_private_key , NSString * walletAddress))result;
-(void)importpridata:(NSString *)pridataString result:(void(^)(NSString * walletAddress,  NSString * mnemonic))result;

-(void)sigWithmessage:(NSString *)message pridata:(NSString *)pridataString result:(void (^)(NSString * _Nonnull))result;






@end

NS_ASSUME_NONNULL_END
