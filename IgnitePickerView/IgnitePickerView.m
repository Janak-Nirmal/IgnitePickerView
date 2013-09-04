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
		self.overlayCell.userInteractionEnabled = NO;
		
        
        self.overlayTop = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.frame.size.width, 40.0)];
		self.overlayTop.userInteractionEnabled = NO;

        
        self.overlayBottom = [[UIView alloc] initWithFrame:CGRectMake(0.0, 90.0, self.frame.size.width, 40.0)];
		self.overlayBottom.userInteractionEnabled = NO;


        self.superview.userInteractionEnabled = YES;
        self.normalFont = [UIFont fontWithName:@"Helvetica" size:24];
        self.selectedFont = [UIFont fontWithName:@"Helvetica" size:30];

        [_tableView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
        
    }
    return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"contentOffset"]) {
        
        CGFloat rowHeight = [self.delegate rowHeightForIgnitePickerView:self];
        
        //Observer will update offset each time user touches picker. We want to offset to be an y point in the middle of each row.
        CGFloat offset = [[change objectForKey:NSKeyValueChangeNewKey] CGPointValue].y;
        offset = offset +(rowHeight/2);
        // temporary index of a cell we will be editing. We're casting float to integer to get
        NSInteger *tempCellNumber;
        tempCellNumber = (NSInteger*)((NSInteger)offset / (NSInteger)rowHeight);
        float modulo = fmodf(offset, rowHeight);
        NSLog(@"modulo %f",modulo);
        NSInteger cellCenter;
        cellCenter = (NSInteger)tempCellNumber * (NSInteger)rowHeight;
        
        if(modulo > 5 && modulo < 33){

            [self makeCellBigger:(NSInteger)tempCellNumber];
            [self makeCellSmaller:(NSInteger)tempCellNumber-1];
            [self makeCellSmaller:(NSInteger)tempCellNumber+1];

        }else{
            
            [self makeCellSmaller:(NSInteger)tempCellNumber];

        }
        
    }
    
}

-(void)makeCellBigger:(NSInteger)index{
    
    
    UITableViewCell *cell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
    UIView *contentView = cell.contentView;
    
    UILabel *textLabel = (UILabel*)[contentView viewWithTag:-1];
    [textLabel setFont:self.selectedFont];
    
}

-(void)makeCellSmaller:(NSInteger)index{
    
    if(index >=0 && index <= [_tableView numberOfRowsInSection:0]){
        UITableViewCell *cell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
        UIView *contentView = cell.contentView;
    
        UILabel *textLabel = (UILabel*)[contentView viewWithTag:-1];
        [textLabel setFont:self.normalFont];
    }
}


- (void)layoutSubviews {
    [self setBackgroundColor:[UIColor clearColor]];

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
