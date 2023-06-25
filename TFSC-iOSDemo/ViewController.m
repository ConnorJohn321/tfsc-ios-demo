//
//  ViewController.m
//  TFSC-iOSDemo
//
//  Created by John Connor on 2023/5/4.
//

#import "ViewController.h"
#import "OCAndCHelp.h"
#define ScreenBoundsSize ([[UIScreen mainScreen] bounds].size)
#define ScreenWidth ScreenBoundsSize.width
#define ScreenHeight ScreenBoundsSize.height

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self creatViews];
}
-(void)creatViews{
    self.view.backgroundColor = [UIColor grayColor];
    self.navigationItem.title = @"Demo";
    UIButton * b1 = [UIButton buttonWithType:UIButtonTypeSystem];
    b1.frame = CGRectMake(40, 120, ScreenWidth-80, 50);
    b1.backgroundColor = UIColor.whiteColor;
    [b1 setTitle:@"Create new account" forState:UIControlStateNormal];
    [b1 setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
    [b1 addTarget:self action:@selector(create) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:b1];
    
    UIButton * b2 = [UIButton buttonWithType:UIButtonTypeSystem];
    b2.frame = CGRectMake(40, CGRectGetMaxY(b1.frame) + 30, ScreenWidth-80, 50);
    b2.backgroundColor = UIColor.whiteColor;
    [b2 setTitle:@"Import mnemonics word" forState:UIControlStateNormal];
    [b2 setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
    [b2 addTarget:self action:@selector(restoreMnemonic) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:b2];
    
    
    UIButton * b3 = [UIButton buttonWithType:UIButtonTypeSystem];
    b3.frame = CGRectMake(40, CGRectGetMaxY(b2.frame) + 30, ScreenWidth-80, 50);
    b3.backgroundColor = UIColor.whiteColor;
    [b3 setTitle:@"Import private key" forState:UIControlStateNormal];
    [b3 setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
    [b3 addTarget:self action:@selector(restorePrivate) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:b3];
    
    
    UIButton * b4 = [UIButton buttonWithType:UIButtonTypeSystem];
    b4.frame = CGRectMake(40, CGRectGetMaxY(b3.frame) + 30, ScreenWidth-80, 50);
    b4.backgroundColor = UIColor.whiteColor;
    [b4 setTitle:@"Transfer" forState:UIControlStateNormal];
    [b4 setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
    [b4 addTarget:self action:@selector(transfer) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:b4];
    
    UIButton * b5 = [UIButton buttonWithType:UIButtonTypeSystem];
    b5.frame = CGRectMake(40, CGRectGetMaxY(b4.frame) + 30, ScreenWidth-80, 50);
    b5.backgroundColor = UIColor.whiteColor;
    [b5 setTitle:@"Get balance" forState:UIControlStateNormal];
    [b5 setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
    [b5 addTarget:self action:@selector(getBalance) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:b5];
}


-(void)create{
    [[OCAndCHelp sharedManager]setProfileResult:^(NSString * _Nonnull out_private_key, NSString * _Nonnull mnemonic, NSString * _Nonnull walletAddress) {
        NSLog(@"--------------------------------------------------------------------------");
        NSLog(@"private key == %@", out_private_key);
        NSLog(@"mnemonics word == %@", mnemonic);
        NSLog(@"wallet address == %@", walletAddress);
        NSLog(@"--------------------------------------------------------------------------");

    }];
}

-(void)restoreMnemonic{
    NSString * mnemonic = @"write group sister impose indicate rose wrap major scatter old renew wave link federal magnet despair purchase canvas license hurdle panda clinic pilot act";
    [[OCAndCHelp sharedManager]importMnemonic:mnemonic result:^(NSString * _Nonnull out_private_key, NSString * _Nonnull walletAddress) {
        NSLog(@"--------------------------------------------------------------------------");
        NSLog(@"private key == %@", out_private_key);
        NSLog(@"wallet address == %@", walletAddress);
        NSLog(@"--------------------------------------------------------------------------");
    }];
}

-(void)restorePrivate{
    NSString *  privatekey = @"fe8cdf2638f72f783f8433c07342d8fbf820a8e179e0ae243604b7c9f6566938";
    [[OCAndCHelp sharedManager]importpridata:privatekey result:^(NSString * _Nonnull walletAddress, NSString * _Nonnull mnemonic) {
        NSLog(@"--------------------------------------------------------------------------");
        NSLog(@"mnemonics word == %@", mnemonic);
        NSLog(@"wallet address == %@", walletAddress);
        NSLog(@"--------------------------------------------------------------------------");

    }];
}

-(void)getBalance{
    NSMutableDictionary * paramars = [NSMutableDictionary dictionary];
    paramars[@"type"] = @"get_balance";
    paramars[@"addr"] = @"1GQt9ht8nULrJaeNWAZDLDe6BmxptkG6vs";
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:paramars
                                                       options:kNilOptions
                                                         error:NULL];
    NSString *body = [[NSString alloc] initWithData:jsonData
                                           encoding:NSUTF8StringEncoding];
    
    NSData *bodyData = [body dataUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *url = [NSURL URLWithString:@"http://192.168.1.42:41517/get_balance"];//The RPC node address you built yourself
    
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:bodyData];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionDataTask *sessionDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSString *result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:[result dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
        long long  walletprice = [dic[@"result"][@"balance"] longLongValue];// walletprice/100000000
        NSLog(@"price == %lld",walletprice/100000000);
        NSLog(@"--------------------------------------------------------------------------");

    }];
    
    [sessionDataTask resume];
    
}

-(void)transfer{
    NSMutableDictionary * paramars = [NSMutableDictionary dictionary];
    paramars[@"type"] = @"tx_req";
    paramars[@"fromAddr"] = @[@"1GQt9ht8nULrJaeNWAZDLDe6BmxptkG6vs"];
    paramars[@"toAddr"] = @[@{@"addr":@"1HEUuLH5Zd6Borfu2TccQnEXSBKCEQTBKu",@"value":@"10"}];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:paramars
                                                       options:kNilOptions
                                                         error:NULL];
    NSString *body = [[NSString alloc] initWithData:jsonData
                                           encoding:NSUTF8StringEncoding];
    
    NSData *bodyData = [body dataUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *url = [NSURL URLWithString:@"http://192.168.1.42:41517/get_transaction_req"];//The RPC node address you built yourself
    
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:bodyData];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionDataTask *sessionDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSString *result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:[result dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
        
        NSString * message = result;
        NSString * ErrorCode = dic[@"ErrorCode"];
        
        if([ErrorCode isEqualToString:@"0"]){
            [[OCAndCHelp sharedManager]sigWithmessage:message pridata:@"1382fc663747d0d96f1e61850687cb16c152fb7e9183988591d044f56065d8f0" result:^(NSString * _Nonnull signature) {
                [self sendmesssage:signature];
            }];
        }
      
        NSLog(@"--------------------------------------------------------------------------");

    }];
    
    [sessionDataTask resume];

}

-(void)sendmesssage:(NSString *)message{
    
    NSData *bodyData = [message dataUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *url = [NSURL URLWithString:@"http://192.168.1.42:41517/send_message"];//The RPC node address you built yourself
    
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:bodyData];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionDataTask *sessionDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSString *result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:[result dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
        
        NSString * ErrorCode = dic[@"ErrorCode"];
        
        if([ErrorCode isEqualToString:@"0"]){
            NSLog(@"%@",@"success");
        }
      
        NSLog(@"--------------------------------------------------------------------------");

    }];
    
    [sessionDataTask resume];
    
    
   
}



@end
