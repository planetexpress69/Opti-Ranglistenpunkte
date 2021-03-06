//
//  SimpleDataProvider.m
//  Ranglistenpunkte
//
//  Created by Martin Kautz on 09.05.14.
//  Copyright (c) 2014 Martin Kautz. All rights reserved.
//

#import "SimpleDataProvider.h"


@interface SimpleDataProvider()
@end


@implementation SimpleDataProvider

static NSString *kArrayKey = @"storedDataArray";

//----------------------------------------------------------------------------------------------------------------------
#pragma mark - Init
//----------------------------------------------------------------------------------------------------------------------
+ (instancetype)sharedInstance
{
    static SimpleDataProvider *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[SimpleDataProvider alloc] init];
    });
    return sharedInstance;
}

//----------------------------------------------------------------------------------------------------------------------
#pragma mark - Init datasource
//----------------------------------------------------------------------------------------------------------------------
- (NSMutableArray *)theDataStorageArray
{
    if (_theDataStorageArray == nil) {
        _theDataStorageArray = [self loadDataSource];
        if (_theDataStorageArray == nil) {
            _theDataStorageArray = [[NSMutableArray alloc]initWithCapacity:10];
        }
    }
    return _theDataStorageArray;
}

//----------------------------------------------------------------------------------------------------------------------
#pragma mark - Try loading persisted datasource
//----------------------------------------------------------------------------------------------------------------------
- (NSMutableArray *)loadDataSource
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if ([userDefaults objectForKey:kArrayKey]) {
        NSLog(@"> :%@", [userDefaults objectForKey:kArrayKey]);
        return ((NSArray *)[userDefaults objectForKey:kArrayKey]).mutableCopy;
    }
    return nil;
}

//----------------------------------------------------------------------------------------------------------------------
#pragma mark - Save datasource
//----------------------------------------------------------------------------------------------------------------------
- (void)persist
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:self.theDataStorageArray forKey:kArrayKey];
    [userDefaults synchronize];
}

//----------------------------------------------------------------------------------------------------------------------
#pragma mark - Add a regatta's dictionary to datasource
//----------------------------------------------------------------------------------------------------------------------
- (void)addObject:(NSDictionary *)anObject;
{
    [self.theDataStorageArray addObject:anObject];
    [self sort];
    [self persist];
}

//----------------------------------------------------------------------------------------------------------------------
#pragma mark - Replace a regatta's dictionary with an updated version
//----------------------------------------------------------------------------------------------------------------------
- (void)replaceObject:(NSDictionary *)anObject atIndex:(NSInteger)anIndex
{
    [self.theDataStorageArray removeObjectAtIndex:anIndex];
    [self.theDataStorageArray insertObject:anObject atIndex:anIndex];
    [self sort];
    [self persist];
}

//----------------------------------------------------------------------------------------------------------------------
#pragma mark - Remove a regatta's dictionary from datasource
//----------------------------------------------------------------------------------------------------------------------
- (void)removeObjectAtIndex:(NSInteger)anIndex
{
    [self.theDataStorageArray removeObjectAtIndex:anIndex];
    [self persist];
}


//----------------------------------------------------------------------------------------------------------------------
#pragma mark - Determine the "m" factor for a regatta taking at least three days
//----------------------------------------------------------------------------------------------------------------------
- (int)mFactor:(NSInteger)numberOfRaces atLeastThreeDays:(BOOL)threeDays
{
    switch (abs((int)numberOfRaces)) {
        case 0:
            return 0;
            break;
        case 1:
            return 1;
            break;
        case 2:
            return 2;
            break;
        case 3:
            return 3;
            break;
        case 4:
            return 4;
            break;
        case 5:
            return 4;
            break;
        default:
            return threeDays ? 5 : 4;
            break;
    }
}


//----------------------------------------------------------------------------------------------------------------------
#pragma mark - Sort the regattas by score
//----------------------------------------------------------------------------------------------------------------------
- (void)sort
{
    self.theDataStorageArray = [self.theDataStorageArray sortedArrayUsingComparator:^NSComparisonResult(id obj1,
                                                                                                        id obj2) {
        float fFirst = ((NSNumber *)(NSDictionary *)obj1[@"score"]).floatValue;
        float fSecnd = ((NSNumber *)(NSDictionary *)obj2[@"score"]).floatValue;
        if (fFirst > fSecnd)
            return NSOrderedAscending;
        else if (fFirst < fSecnd)
            return NSOrderedDescending;
        return NSOrderedSame;
    }].mutableCopy;
}

//----------------------------------------------------------------------------------------------------------------------
#pragma mark - Calculate the average of the nine best scored regattas - A
//----------------------------------------------------------------------------------------------------------------------
- (CGFloat)bestScoreA
{
    if (self.theDataStorageArray == nil)
        return 0.0f;

    int counter             = 0;
    float allPoints         = 0.0f;
    NSDictionary *regatta   = nil;

    for (regatta in self.theDataStorageArray) {

        NSNumber *points    = regatta[@"score"];
        NSInteger races     = ((NSNumber *)regatta[@"races"]).integerValue;
        BOOL threeDays      = regatta[@"threeDays"] != nil ? ((NSNumber *)regatta[@"threeDays"]).boolValue : NO;
        NSNumber *mFactor   = [NSNumber numberWithInteger:[self mFactor:races atLeastThreeDays:threeDays]];

        for (int i = 0; i < mFactor.intValue; i++) {
            if (counter < 9) {
                counter ++;
                allPoints += points.floatValue;
            }
        }
    }
    return counter == 9 ? (allPoints/counter) : 0.00f;
}


//----------------------------------------------------------------------------------------------------------------------
#pragma mark - Calculate the average of the nine best scored regattas - B
//----------------------------------------------------------------------------------------------------------------------
- (CGFloat)bestScoreB
{
    if (self.theDataStorageArray == nil)
        return 0.0f;

    int counter             = 0;
    float allPoints         = 0.0f;
    NSDictionary *regatta   = nil;

    for (regatta in self.theDataStorageArray) {
        NSNumber *points = regatta[@"score"];
        allPoints += points.floatValue;
        counter ++;
        if (counter == 3) {
            break;
        }
    }
    return counter == 3 ? (allPoints/counter) : 0.00f;
}

@end
