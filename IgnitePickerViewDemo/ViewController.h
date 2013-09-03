//
//  ViewController.h
//  IgnitePickerViewDemo
//
//  Created by Michal on 9/3/13.
//  Copyright (c) 2013 Michal Lichwa Ignite. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IgnitePickerView.h"

@interface ViewController : UIViewController <IgnitePickerViewDelegate, IgnitePickerViewDataSource>{
    
    NSArray *languageNamesArray;
    
}

@property (nonatomic, strong) NSArray *languageNamesArray;

@end
