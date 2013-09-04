//
//  IgnitePickerView.h
//  IgnitePickerViewDemo
//
//  Created by Michal on 9/3/13.
//  Copyright (c) 2013 Michal Lichwa Ignite. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol IgnitePickerViewDelegate;
@protocol IgnitePickerViewDataSource;



@interface IgnitePickerView : UIView{

}

- (void)selectRow:(NSInteger)row;


@property (nonatomic, strong) UIView *overlayCell;
@property (nonatomic, strong) UIView *overlayTop;
@property (nonatomic, strong) UIView *overlayBottom;
@property (nonatomic, strong) UIView *lineTop;
@property (nonatomic, strong) UIView *lineBottom;
@property (nonatomic) NSInteger *lastResizedCell; // index of cell that was resized as the last one
@property (nonatomic) BOOL cellResized; // did we resized it already?

// Background color for the table view
@property (nonatomic, strong) UIColor *backgroundColor;
@property (nonatomic, strong) UIColor *framingColor;
@property (nonatomic, strong) UIFont  *normalFont;
@property (nonatomic, strong) UIFont  *selectedFont;

// Delegate
@property (nonatomic, weak) id <IgnitePickerViewDelegate> delegate;
// Data source
@property (nonatomic, weak) id <IgnitePickerViewDataSource> dataSource;

@end

@protocol IgnitePickerViewDelegate

- (NSString *)ignitePickerView:(IgnitePickerView*)ignitePickerView titleForRow:(NSInteger)row;
- (void)ignitePickerView:(IgnitePickerView*)ignitePickerView didSelectRow:(NSInteger)row;
- (CGFloat)rowHeightForIgnitePickerView:(IgnitePickerView*)ignitePickerView;
- (void)labelStyleForIgnitePickerView:(IgnitePickerView*)ignitePickerView forLabel:(UILabel*)label;

@end

@protocol IgnitePickerViewDataSource

- (NSInteger)numberOfRowsInIgnitePickerView:(IgnitePickerView*)ignitePickerView;

@end