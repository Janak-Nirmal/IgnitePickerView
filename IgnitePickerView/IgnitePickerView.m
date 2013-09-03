//
//  IgnitePickerView.m
//  IgnitePickerViewDemo
//
//  Created by Michal on 9/3/13.
//  Copyright (c) 2013 Michal Lichwa Ignite. All rights reserved.
//

#import "IgnitePickerView.h"

@interface IgnitePickerView() <UITableViewDataSource, UITableViewDelegate>

@end

@implementation IgnitePickerView {
	UITableView *_tableView;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
		_tableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.frame.size.width, self.frame.size.height) style:UITableViewStylePlain];
		_tableView.delegate = self;
		_tableView.dataSource = self;
		_tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
		_tableView.allowsSelection = NO;
		_tableView.showsVerticalScrollIndicator = NO;
		_tableView.showsHorizontalScrollIndicator = NO;
        _tableView.backgroundColor = [UIColor clearColor];
        self.lastResizedCell = 0;
        self.cellResized = NO;
        _tableView.backgroundView = nil;
        [_tableView setOpaque:YES];
		self.overlayCell = [[UIView alloc] initWithFrame:CGRectMake(0.0, 45.0, self.frame.size.width, 40.0)];
		self.overlayCell.backgroundColor = [UIColor blackColor];
		self.overlayCell.userInteractionEnabled = NO;
		//self.overlayCell.alpha = 0.7;
        
        self.overlayTop = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.frame.size.width, 40.0)];
		//self.overlayTop.backgroundColor = [UIColor blackColor];
		self.overlayTop.userInteractionEnabled = NO;
		//self.overlayTop.alpha = 0.7;
        
        self.overlayBottom = [[UIView alloc] initWithFrame:CGRectMake(0.0, 90.0, self.frame.size.width, 40.0)];
		self.overlayBottom.backgroundColor = [UIColor blackColor];
		self.overlayBottom.userInteractionEnabled = NO;
		self.overlayBottom.alpha = 0.7;
        self.superview.userInteractionEnabled = YES;
        [_tableView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
        
    }
    return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"contentOffset"]) {
        
        
        CGFloat offset = [[change objectForKey:NSKeyValueChangeNewKey] CGPointValue].y;
        NSLog(@"offset y %f",offset);
        NSInteger *tempCellNumber;
        tempCellNumber = (NSInteger*)((NSInteger)offset / 45);
        
        NSInteger cellCenter;
        cellCenter = (NSInteger)tempCellNumber * (NSInteger)45;
        
        
        
        //difference between center and the offset +10 ,-10
        NSInteger difference = cellCenter - (NSInteger)offset;
        
        if(difference > 10 || difference < -10 ){
            NSLog(@"cell index %i",(int)tempCellNumber);
            NSLog(@"size it down");
            [self makeCellSmaller:(NSInteger)tempCellNumber];
            //self.cellResized = YES;
        }else{
            NSLog(@"cell index %i",(int)tempCellNumber);
            NSLog(@"size it up");
            
            [self makeCellBigger:(NSInteger)tempCellNumber];
            //self.cellResized = NO;
        }
        
        if(tempCellNumber != self.lastResizedCell){
            
            self.lastResizedCell = tempCellNumber;
            //self.cellResized = NO;
        }
        
    }
    
}

-(void)makeCellBigger:(NSInteger)index{
    
    
    UITableViewCell *cell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
    UIView *contentView = cell.contentView;
    
    UILabel *textLabel = (UILabel*)[contentView viewWithTag:-1];
    [textLabel setFont:[UIFont fontWithName:@"Helvetica" size:30]];
    
}

-(void)makeCellSmaller:(NSInteger)index{
    
    UITableViewCell *cell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
    UIView *contentView = cell.contentView;
    
    UILabel *textLabel = (UILabel*)[contentView viewWithTag:-1];
    [textLabel setFont:[UIFont fontWithName:@"Helvetica" size:24]];
    
}


- (void)layoutSubviews {
    [self setBackgroundColor:[UIColor clearColor]];
    CGFloat rowHeight = [self.delegate rowHeightForIgnitePickerView:self];
    
    // Move overlay to center of table view
    CGFloat centerY = (self.frame.size.height - rowHeight) / 2.0;
    self.overlayCell.frame = CGRectMake(0.0, centerY, self.frame.size.width, rowHeight);
    self.overlayTop.frame = CGRectMake(0.0, 0.0, self.frame.size.width, rowHeight);
    self.overlayBottom.frame = CGRectMake(0.0, 90, self.frame.size.width, rowHeight);
    
    
    
    self.lineTop = [[UIView alloc]initWithFrame:CGRectMake(0, 45, 270, 1)];
    self.lineBottom = [[UIView alloc]initWithFrame:CGRectMake(0, 90, 270, 1)];
    
    self.lineBottom.backgroundColor = self.framingColor;
    self.lineTop.backgroundColor = self.framingColor;
    
    [self addSubview:_tableView];
    [self addSubview:self.lineBottom];
    [self addSubview:self.lineTop];
    
}

- (UIView*)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
	// Always pass all touches on this view to the table view
    
    //[self magnify];
	return _tableView;
}

- (void)selectRow:(NSInteger)row {
    CGFloat rowHeight = [self.delegate rowHeightForIgnitePickerView:self];
    
	[_tableView setContentOffset:CGPointMake(0.0, row * rowHeight)];
}

- (void)setBackgroundColor:(UIColor *)backgroundColor {
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.backgroundView = nil;
}

#pragma mark - UITableViewDelegate functions

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [self.dataSource numberOfRowsInIgnitePickerView:self];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	CGFloat rowHeight = [self.delegate rowHeightForIgnitePickerView:self];
    
	static NSString *CellIdentifier = @"Cell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
	if (cell == nil) {
		// Alloc a new cell
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
		UIView *contentView = cell.contentView;
        
		UILabel *textLabel;
		if (indexPath.row == 0) {
			textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, self.overlayCell.frame.origin.y, self.frame.size.width, rowHeight)];
		} else {
			textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, self.frame.size.width, rowHeight)];
		}
		textLabel.tag = -1;
		textLabel.text = [self.delegate ignitePickerView:self titleForRow:indexPath.row];
        textLabel.backgroundColor = [UIColor clearColor];
        [self.delegate labelStyleForIgnitePickerView:self forLabel:textLabel];
        
		[contentView addSubview:textLabel];
		
	} else {
		// Reuse cell
		UIView *contentView = cell.contentView;
        
		UILabel *textLabel = (UILabel*)[contentView viewWithTag:-1];
		textLabel.text = [self.delegate ignitePickerView:self titleForRow:indexPath.row];
		
		if (indexPath.row == 0) {
			textLabel.frame = CGRectMake(0.0, self.overlayCell.frame.origin.y, self.frame.size.width, rowHeight);
		} else {
			textLabel.frame = CGRectMake(0.0, 0.0, self.frame.size.width, rowHeight);
		}
	}
    //	UIView *backView = [[UIView alloc] initWithFrame:CGRectZero];
    cell.backgroundColor = [UIColor clearColor];
    cell.backgroundView = nil;
    //[self addLoop];
    //[self magnify];
    
	return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat rowHeight = [self.delegate rowHeightForIgnitePickerView:self];
    
	// Add front and back padding to make this more closely resemble a picker view
	if (indexPath.row == 0) {
		return (self.overlayCell.frame.origin.y + rowHeight);
	} else if (indexPath.row == [self.dataSource numberOfRowsInIgnitePickerView:self] - 1) {
		return (self.overlayCell.frame.origin.y + rowHeight);
	}
	return rowHeight;
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    CGFloat rowHeight = [self.delegate rowHeightForIgnitePickerView:self];
    
	// Auto scroll to next multiple of rowHeight
	CGFloat floatVal = targetContentOffset->y / rowHeight;
	NSInteger rounded = (NSInteger)(lround(floatVal));
    
	targetContentOffset->y = rounded * rowHeight;
    
    // Tell delegate where we're landing
    [self.delegate ignitePickerView:self didSelectRow:rounded];
}



@end
