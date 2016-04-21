//
//  CMLLine.m
//  CAMELLIAE
//
//  Created by 张越 on 16/3/22.
//  Copyright © 2016年 张越. All rights reserved.
//

#import "CMLLine.h"


#define LineWidth [UIScreen mainScreen].bounds.size.width
#define LineHeight [UIScreen mainScreen].bounds.size.height

@implementation CMLLine

- (instancetype)init{
    
    self =[super init];
    
    if (self) {
        self.frame=CGRectMake(100, 100, LineWidth, LineHeight);
    }
    return self;
}

-(void)layoutSubviews{
    
    [super superview];
    
    if (self.kindOfLine == DottedLine) {
        
        
        if (self.directionOfLine == VerticalLine) {
            
            
            if (self.directionOfLine == HorizontalLine) {
                
                CGFloat width;
                if (self.lineWidth) {
                    width=self.lineWidth;
                }else{
                    width=1.0;
                }
                if (self.LineColor) {
                    self.backgroundColor=self.LineColor;
                }else{
                    self.backgroundColor=[UIColor whiteColor];
                }
                self.frame=CGRectMake(self.startingPoint.x, self.startingPoint.y,width,
                                      self.lineLength);
                
                for (int i=0; i<(int)self.lineLength/4.0; i++) {
                    
                    UIView *view =[[UIView alloc] initWithFrame:CGRectMake(0,1+i*4, 1, 1)];
                    view.backgroundColor=[UIColor whiteColor];
                    [self addSubview:view];
                }
                
                
            }else{
                
                CGFloat width;
                if (self.lineWidth) {
                    width=self.lineWidth;
                }else{
                    width=1.0;
                }
                if (self.LineColor) {
                    self.backgroundColor=self.LineColor;
                }else{
                    self.backgroundColor=[UIColor whiteColor];
                }
                
                self.frame=CGRectMake(self.startingPoint.x, self.startingPoint.y,
                                      self.lineLength, width);
                
                for (int i=0; i<(int)self.lineLength/4.0; i++) {
                    
                    UIView *view =[[UIView alloc] initWithFrame:CGRectMake(1+i*4, 0, 1, 1)];
                    view.backgroundColor=[UIColor whiteColor];
                    [self addSubview:view];
                }
                
            }
        }
    }else{
        
        if (self.directionOfLine==VerticalLine) {
            
            CGFloat width;
            if (self.lineWidth) {
                width=self.lineWidth;
            }else{
                width=1.0;
            }
            if (self.LineColor) {
                self.backgroundColor=self.LineColor;
            }else{
                self.backgroundColor=[UIColor whiteColor];
            }
            self.frame=CGRectMake(self.startingPoint.x, self.startingPoint.y,width,
                                  self.lineLength);
            
        }else{
            
            CGFloat width;
            if (self.lineWidth) {
                width=self.lineWidth;
            }else{
                width=1.0;
            }
            if (self.LineColor) {
                self.backgroundColor=self.LineColor;
            }else{
                self.backgroundColor=[UIColor whiteColor];
            }
            
            self.frame=CGRectMake(self.startingPoint.x, self.startingPoint.y,
                                  self.lineLength, width);
        }
    }
}

@end
