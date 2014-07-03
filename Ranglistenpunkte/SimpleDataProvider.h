//
//  SimpleDataProvider.h
//  Ranglistenpunkte
//
//  Created by Martin Kautz on 09.05.14.
//  Copyright (c) 2014 Martin Kautz. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SimpleDataProvider : NSObject
//----------------------------------------------------------------------------------------------------------------------
@property (nonatomic, strong) NSMutableArray *theDataStorageArray;
//----------------------------------------------------------------------------------------------------------------------
+ (SimpleDataProvider *)sharedInstance;
//----------------------------------------------------------------------------------------------------------------------
- (void)addObject:(NSDictionary *)anObject;
- (void)replaceObject:(NSDictionary *)anObject atIndex:(NSInteger)anIndex;
- (void)removeObjectAtIndex:(NSInteger)anIndex;
- (void)persist;
- (CGFloat)bestScoreA;
- (CGFloat)bestScoreB;
- (int)mFactor:(NSInteger)numberOfRaces;
//----------------------------------------------------------------------------------------------------------------------
@end
