//
//  BaseModel.h
//  ListeningStory
//
//  Created by 丁伟 on 15/11/20.
//  Copyright (c) 2015年 丁伟. All rights reserved.
//

#import "JSONModel.h"

@interface BaseModel : JSONModel
@property (nonatomic, strong) NSString *index;
@property (nonatomic, strong) NSString *visit_count;
@property (nonatomic, strong) NSString *idStr;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *uuid;
@property (nonatomic, copy) NSString *updatedAt;
@property (nonatomic, copy) NSString *cover;
@property (nonatomic, copy) NSString *createdAt;
@property (nonatomic, copy) NSString *desc;
@property (nonatomic, copy) NSString *audio;
@end
