//
//  CEFGoalHelper.h
//  Push-Up-Tracker
//
//  Created by chadfranklin on 8/11/20.
//  Copyright © 2020 chadfranklin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Goal.h"

NS_ASSUME_NONNULL_BEGIN

@interface CEFGoalHelper : NSObject

+ (BOOL)checkIfGoalInJeopardy:(Goal *)goal;

@end

NS_ASSUME_NONNULL_END
