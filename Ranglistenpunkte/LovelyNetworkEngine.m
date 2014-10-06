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
- (void)fetchPayloadForPath:(NSString *)path
               onCompletion:(MKNKResponseBlock)completionBlock
                    onError:(MKNKErrorBlock)errorBlock
{
    MKNetworkOperation *op = [self operationWithPath:path
                                              params:nil
                                          httpMethod:@"GET"
                                                 ssl:NO];

    [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        completionBlock(completedOperation);
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        errorBlock(error);
    }];

    [self enqueueOperation:op];

}

@end