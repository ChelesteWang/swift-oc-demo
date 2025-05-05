1//
//  MyObjCUIView.m
//  swift-oc-demo
//
//  Created by Trae AI on 2024/07/26.
//

#import "MyObjCUIView.h"

@interface MyObjCUIView ()
@property (nonatomic, strong) UILabel *label;
@end

@implementation MyObjCUIView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor lightGrayColor];
        
        _label = [[UILabel alloc] initWithFrame:self.bounds];
        _label.textAlignment = NSTextAlignmentCenter;
        _label.textColor = [UIColor blackColor];
        _label.text = @"Hello from ObjC UIView";
        _label.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self addSubview:_label];
    }
    return self;
}

- (void)updateLabelText:(NSString *)text {
    self.label.text = text;
}

@end