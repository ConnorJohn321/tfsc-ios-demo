//
//  OCAndCHelp.m
//
//  Created by Gavery on 2019/7/19.
//  Copyright © 2019 Gavery. All rights reserved.
//

#import "OCAndCHelp.h"
#include <string>

//double g_percent;
@implementation OCAndCHelp
+ (OCAndCHelp *)sharedManager
{
    static OCAndCHelp *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[OCAndCHelp alloc] init];
    });
    return manager;
}
- (instancetype)init
{
    if (self = [super init]) {
    }
    return self;
}



-(void)sigWithmessage:(NSString *)message pridata:(NSString *)pridataString result:(void (^)(NSString * _Nonnull))result{
    const char * pridata = [pridataString UTF8String];
    void * pkey = ImportFromHexStr(pridata);
    
    const char * messagedata = [message UTF8String];
    
    char *signature=nullptr;
    int signaturesize = 0;
//    void toSig_c (void * pkey,const char * data,int size_m,char ** buf,int *size);

    toSig_c(pkey, messagedata, (int)message.length, &signature, &signaturesize);
    NSData *data = [NSData dataWithBytes:signature length:signaturesize];
    NSString * signatureString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    free(signature);
    result(signatureString);
}





-(void)setProfileResult:(void (^)(NSString * _Nonnull, NSString * _Nonnull, NSString * _Nonnull))result{
    unsigned char *buf=nullptr;
    int bufsize = 0;
    BOOL code =  ExportEVP_PKEY(&buf,&bufsize);
    if(code == NO){
        free(buf);
        return;
    }
    NSLog(@"----------------------------------------");

    void * pkey = ImportEVP_PKEY(buf,bufsize);
    free(buf);
    NSLog(@"----------------------------------------");
    if(pkey == nullptr){
        return;
    }
    char *prihex=nullptr;
    int prihexsize = 0;
    BOOL ceode1 = ExportToHexStr(pkey,&prihex,&prihexsize);
    if(ceode1 == NO){
        free(prihex);
        return;
    }
    NSData *data = [NSData dataWithBytes:prihex length:prihexsize];
    NSString * pridataString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    free(prihex);
    NSLog(@"----------------------------------------");
    
    char *Mnemonic=nullptr;
    int Mnemonicsize = 0;
    BOOL ceode2 = ExportMnemonic(pkey,&Mnemonic,&Mnemonicsize);
    if(ceode2 == NO){
        free(Mnemonic);
        return;
    }
    NSData *Mnemonicdata = [NSData dataWithBytes:Mnemonic length:Mnemonicsize];
    NSString * MnemonicString  = [[NSString alloc] initWithData:Mnemonicdata encoding:NSUTF8StringEncoding];
    free(Mnemonic);
    NSLog(@"----------------------------------------");


    char *base58=nullptr;
    int base58size = 0;
    getBase58addr_c(pkey,&base58,&base58size);
    NSData *base58data = [NSData dataWithBytes:base58 length:base58size];
    NSString * base58string =[[NSString alloc] initWithData:base58data encoding:NSUTF8StringEncoding];
    free(base58);
    NSLog(@"----------------------------------------");
    result(pridataString,MnemonicString,base58string);

}

-(void)importMnemonic:(NSString *)MnemonicString result:(void (^)(NSString * _Nonnull, NSString * _Nonnull))result{
    const char * mnemonic = [MnemonicString UTF8String];
    void * pkey = ImportFromMnemonic(mnemonic);
    if(pkey == nullptr){
        return;
    }
    char *prihex=nullptr;
    int prihexsize = 0;
    BOOL ceode1 = ExportToHexStr(pkey,&prihex,&prihexsize);
    if(ceode1 == NO){
        free(prihex);
        return;
    }
    NSData *data = [NSData dataWithBytes:prihex length:prihexsize];
    NSString * pridataString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    free(prihex);
    NSLog(@"----------------------------------------");
    
    char *base58=nullptr;
    int base58size = 0;
    getBase58addr_c(pkey,&base58,&base58size);
    NSData *base58data = [NSData dataWithBytes:base58 length:base58size];
    NSString * base58string =[[NSString alloc] initWithData:base58data encoding:NSUTF8StringEncoding];
    free(base58);
    NSLog(@"----------------------------------------");
    result(pridataString,base58string);
}


-(void)importpridata:(NSString *)pridataString result:(void (^)(NSString * _Nonnull, NSString * _Nonnull))result{
    const char * pridata = [pridataString UTF8String];
    void * pkey = ImportFromHexStr(pridata);
    if(pkey == nullptr){
        return;
    }
    char *Mnemonic=nullptr;
    int Mnemonicsize = 0;
    BOOL ceode2 = ExportMnemonic(pkey,&Mnemonic,&Mnemonicsize);
    if(ceode2 == NO){
        free(Mnemonic);
        return;
    }
    NSData *Mnemonicdata = [NSData dataWithBytes:Mnemonic length:Mnemonicsize];
    NSString * MnemonicString  = [[NSString alloc] initWithData:Mnemonicdata encoding:NSUTF8StringEncoding];
    free(Mnemonic);
    NSLog(@"----------------------------------------");


    char *base58=nullptr;
    int base58size = 0;
    getBase58addr_c(pkey,&base58,&base58size);
    NSData *base58data = [NSData dataWithBytes:base58 length:base58size];
    NSString * base58string =[[NSString alloc] initWithData:base58data encoding:NSUTF8StringEncoding];
    free(base58);
    NSLog(@"----------------------------------------");
    result(base58string,MnemonicString);
   
}

@end

