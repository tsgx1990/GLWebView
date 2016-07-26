//
//  UITextView+Fix.m
//  TouTiao_student
//
//  Created by guanglong on 16/5/8.
//  Copyright © 2016年 bjhl. All rights reserved.
//

#import "UITextView+Fix.h"

@implementation UITextView (Fix)

#if DEBUG

- (instancetype)_firstBaselineOffsetFromTop
{
    return nil;
}

- (instancetype)_baselineOffsetFromBottom
{
    return nil;
}

@end

@implementation UIWindow(Fix)

- (instancetype)viewForFirstBaselineLayout
{
    return nil;
}

- (instancetype)viewForLastBaselineLayout
{
    return nil;
}


@end


@implementation UIView(Fix)

- (instancetype)viewForFirstBaselineLayout
{
    return nil;
}

// [UILayoutContainerView viewForLastBaselineLayout]
- (instancetype)viewForLastBaselineLayout
{
    return nil;
}

#endif
@end
