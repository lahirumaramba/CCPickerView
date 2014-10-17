//
//  CCPickerView.m
//  CCPickerView
//
//  Originally Created by Mick Lester on 5/16/12.
//  Copyright (c) 2012 fidgetware. All rights reserved.
//
//  Updated Code to Cocos2d v3 by Lahiru Lakmal on 17/10/14
//

#import "CCPickerView.h"

@implementation CCPickerView
@synthesize dataSource;
@synthesize delegate;
@synthesize numberOfComponents;

-(id) init {
	if ((self=[super init])) {
        repeatNodes = YES;
	}
    
	return self;
}

-(void)initialLoad {
    CGSize size = [delegate sizeOfPickerView:self];
    CGFloat spacing = [delegate spaceBetweenComponents:self];
    
    self.contentSize = size;
    
    //Clip
    CCNodeColor *scissorRect = [CCNodeColor nodeWithColor:[CCColor clearColor] width:size.width height:size.height];
    [scissorRect setAnchorPoint:ccp(0.5f,0.5f)];
    [scissorRect setPosition:ccp(0.f,0.f)];
    
    scissor = [CCClippingNode clippingNodeWithStencil:scissorRect];
    [scissor setContentSize:self.contentSize];
    [scissor setPositionType:CCPositionTypeNormalized];
    [scissor setAlphaThreshold:0.0];
    
    [self addChild:scissor];
    
    /*CCSprite* background;
    background = [CCSprite node];
    background.color = [CCColor colorWithCcColor3b:ccWHITE];
    background.textureRect = CGRectMake(0, 0, size.width-spacing, size.height-spacing);
    [scissor addChild:background];*/
    
    CCNodeColor* background = [CCNodeColor nodeWithColor:[CCColor colorWithCcColor3b:ccWHITE] width:size.width-spacing height:size.height-spacing];
    [background setAnchorPoint:ccp(0.5f,0.5f)];
    [scissor addChild:background];
    
    CCNode *overlayImage = [delegate overlayImage:self];
    //[self addChild:overlayImage z:10];
    [scissor addChild:overlayImage z:10];
    
    [self reloadAllComponents];
}

-(void)setDelegate:(id<CCPickerViewDelegate>)newDelegate {
    delegate = newDelegate;
    
    if (dataSource != nil) {
        [self initialLoad];
    }
}

-(void)setDataSource:(id<CCPickerViewDataSource>)newDataSource {
    dataSource = newDataSource;
    
    if (delegate != nil) {
        [self initialLoad];
    }
}

- (void)autoRepeatNodes:(BOOL)repeat {
    repeatNodes = repeat;
    [self reloadAllComponents];
}

- (void)spinComponent:(NSInteger)component speed:(float)speed easeRate:(float)rate repeat:(NSInteger)repeat stopRow:(NSInteger)row {
    if (repeatNodes) {
        ScrollLayer *scrollLayer = (ScrollLayer *)[scissor getChildByName:[NSString stringWithFormat:@"%d",component] recursively:NO];
        [scrollLayer spin:speed rate:rate repeat:repeat stopPage:row];
    } else {
        CCLOG(@"You need to turn on autoRepeatNodes");
    }
}

- (NSInteger)numberOfRowsInComponent:(NSInteger)component {
    ScrollLayer *scrollLayer = (ScrollLayer *)[scissor getChildByName:[NSString stringWithFormat:@"%d",component] recursively:NO];
    
    return [scrollLayer.arrayPages count];
}

- (void)reloadAllComponents {
    for (int c = 0; c < [dataSource numberOfComponentsInPickerView:self]; c++) {
        [self reloadComponent:c];
    }
}

- (void)reloadComponent:(NSInteger)component {
    NSInteger numComponents = [dataSource numberOfComponentsInPickerView:self];
    CGFloat componentsWidth = 0;
    NSInteger pickerStart = 0;
    CGFloat spacing = [delegate spaceBetweenComponents:self];

    [self removeChildByName:[NSString stringWithFormat:@"%d",component] cleanup:YES];
    
    ScrollLayer *scrollLayer = [ScrollLayer node];
    scrollLayer.delegate = self;
    
    for (int i = 0; i < numComponents; i++) {
        componentsWidth += [delegate pickerView:self widthForComponent:i];
    }
    
    componentsWidth += (numComponents-1)*spacing;

    pickerStart = -componentsWidth/2;
    for (int c = 0; c < component; c++) {
        CGSize componentSize = CGSizeMake([delegate pickerView:self widthForComponent:c], [delegate pickerView:self rowHeightForComponent:c]);
        pickerStart += componentSize.width + spacing;
    }

    CGSize componentSize = CGSizeMake([delegate pickerView:self widthForComponent:component], [delegate pickerView:self rowHeightForComponent:component]);

    scrollLayer.contentSize = componentSize;
    scrollLayer.position = ccp(pickerStart+componentSize.width/2, 0);
        
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:10];
    NSInteger pageSize = [dataSource pickerView:self numberOfRowsInComponent:component];
    
    // Duplicate the nodes if we have repeatNodes on.
    int numPages = repeatNodes?3:1;
    
    for (int r = 0; r < numPages; r++) {
        for (int p = 0; p < pageSize; p++) {
            [array addObject:[delegate pickerView:self nodeForRow:p forComponent:component reusingNode:nil]];
        }
    }
    
    scrollLayer.arrayPages = array;
    scrollLayer.pageSize = pageSize;
    [scrollLayer setCurrentPage:0];
    scrollLayer.touchSize = CGSizeMake(componentSize.width, self.contentSize.height);
    [scrollLayer makePages];
        
    [scissor addChild:scrollLayer z:0 name:[NSString stringWithFormat:@"%d", component]];
}

- (CGSize)rowSizeForComponent:(NSInteger)component {
    ScrollLayer *scrollLayer = (ScrollLayer *)[scissor getChildByName:[NSString stringWithFormat:@"%d", component] recursively:NO];
    
    return scrollLayer.contentSize;
}

- (NSInteger)selectedRowInComponent:(NSInteger)component {
    ScrollLayer *scrollLayer = (ScrollLayer *)[scissor getChildByName:[NSString stringWithFormat:@"%d", component] recursively:NO];
    
    return scrollLayer.currentPage;
}

- (void)selectRow:(NSInteger)row inComponent:(NSInteger)component animated:(BOOL)animated {
    ScrollLayer *scrollLayer = (ScrollLayer *)[scissor getChildByName:[NSString stringWithFormat:@"%d", component] recursively:NO];
    [scrollLayer setCurrentPage:row];    
}

- (CCNode *)nodeForRow:(NSInteger)row forComponent:(NSInteger)component {
    ScrollLayer *scrollLayer = (ScrollLayer *)[scissor getChildByName:[NSString stringWithFormat:@"%d", component] recursively:NO];
    
    return [scrollLayer getChildByName:[NSString stringWithFormat:@"%d", row] recursively:NO];
}

/*
//http://www.cocos2d-iphone.org/forum/topic/10270
- (void) visit {

	if (!self.visible)
		return;
    
	glEnable(GL_SCISSOR_TEST);

    CGSize size = self.contentSize;
    CGPoint worldPoint = [self convertToWorldSpace:self.position];
    CGRect rect = CGRectMake(worldPoint.x - self.position.x - size.width/2, worldPoint.y - self.position.y - size.height/2, size.width, size.height);

    CGRect scissorRect;
    
	scissorRect = CGRectMake( rect.origin.x * [CCDirector sharedDirector].contentScaleFactor,
                             rect.origin.y* [CCDirector sharedDirector].contentScaleFactor,
                             rect.size.width* [CCDirector sharedDirector].contentScaleFactor,
                             (rect.size.height)* [CCDirector sharedDirector].contentScaleFactor );
    
	glScissor(scissorRect.origin.x, scissorRect.origin.y,
			  scissorRect.size.width, scissorRect.size.height);
    
	[super visit];
    
	glDisable(GL_SCISSOR_TEST);
}
 */

#pragma mark - ScrollLayerDelegate
-(void)onDoneSelecting:(ScrollLayer *)scrollLayer {
    if ([delegate respondsToSelector:@selector(pickerView: didSelectRow: inComponent:)]) {
        [delegate pickerView:self didSelectRow:scrollLayer.currentPage inComponent:scrollLayer.name];
    }
}

-(void)onDoneSpinning:(ScrollLayer *)scrollLayer {
    if ([delegate respondsToSelector:@selector(onDoneSpinning: component:)]) {
        [delegate onDoneSpinning:self component:scrollLayer.name];
    }
}

@end

