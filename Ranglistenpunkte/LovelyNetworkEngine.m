//
//  LovelyNetworkEngine.m
//  Ranglistenpunkte
//
//  Created by Martin Kautz on 21.05.14.
//  Copyright (c) 2014 Martin Kautz. All rights reserved.
//

#import "LovelyNetworkEngine.h"


@implementation LovelyNetworkEngine
//----------------------------------------------------------------------------------------------------------------------
#pragma mark - fetch data
//----------------------------------------------------------------------------------------------------------------------
- (void)fetchPayloadForApiKey:(NSString *)sApiKey
                 onCompletion:(MKNKResponseBlock)completionBlock
                      onError:(MKNKErrorBlock)errorBlock
{

    NSDictionary *params = @{ @"apikey" : sApiKey };
    
    // please use your own api path!!!
    MKNetworkOperation *op = [self operationWithPath:THEAPIPATH
                                              params:params
                                          httpMethod:@"GET"
                                                 ssl:YES];

    [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        completionBlock(completedOperation);
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        errorBlock(error);
    }];

    [self enqueueOperation:op];
}

@end