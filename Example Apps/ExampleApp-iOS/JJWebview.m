//
//  JJWebview.m
//  ExampleApp-iOS
//
//  Created by PomCat on 2020/7/25.
//  PomCat
//

#import "JJWebview.h"

@implementation JJWebview

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (nullable WKNavigation *)reloadFromOrigin {
    return [super reloadFromOrigin];
}

- (WKNavigation *)reload {
    return [super reload];
}

- (void)reloadInputViews {
    [super reloadInputViews];
}

@end
