//
//  XQCollectArticleViewModel.h
//  ASByrApp
//
//  Created by lixiangqian on 17/3/14.
//  Copyright © 2017年 andy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

@class ASByrCollection, XQCollectDataCenter;

@interface XQCollectArticleViewModel : NSObject


@property (strong, nonatomic) XQCollectDataCenter * collectDataCenter;

@property (strong, nonatomic) ASByrCollection * collectionApi;

@property (strong, nonatomic) RACCommand * fetchCollectionCommand;

@end
