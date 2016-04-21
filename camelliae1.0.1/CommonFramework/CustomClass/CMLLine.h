//
//  CMLLine.h
//  CAMELLIAE
//
//  Created by 张越 on 16/3/22.
//  Copyright © 2016年 张越. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CMLLine : UIView

typedef enum {
    
    HorizontalLine,
    VerticalLine
    
} DirectionOfLine ;

typedef enum{
    RealLine,
    DottedLine
    
} KindOfLine;

/**起点*/
@property (assign,nonatomic) CGPoint startingPoint;

/**线的方向(水平，竖直)*/
@property (assign,nonatomic) DirectionOfLine directionOfLine;

/**线的种类(默认实线)*/
@property (assign,nonatomic) KindOfLine kindOfLine;

/**线长*/
@property (assign,nonatomic) CGFloat lineLength;

/**宽度(默认为1)*/
@property (assign,nonatomic) CGFloat lineWidth;

/**线颜色（默认黑色）*/
@property (retain,nonatomic) UIColor * LineColor;
@end
