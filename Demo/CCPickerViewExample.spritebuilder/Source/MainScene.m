//
//  MainScene.m
//  CCPickerViewExample
//
//  Created by Lahiru on 17/10/14.
//  Copyright (c) 2013 SoundofCode. All rights reserved.
//

#import "MainScene.h"

#define kComponentWidth 106
#define kComponentHeight 71
#define kComponentSpacing 10

@implementation MainScene

- (id)init
{
    if (self = [super init])
    {
        // activate touches on this scene
        //self.userInteractionEnabled = TRUE;
    }
    return self;
}

- (void)didLoadFromCCB
{
    m_slotwindow = [CCSprite spriteWithImageNamed:@"ccbResources/slot_window.png"];
    
    CGSize size = [[CCDirector sharedDirector] viewSize];
    
    pickerView = [CCPickerView node];
    pickerView.position = ccp(size.width*0.5, size.height*0.56);
    pickerView.dataSource = self;
    pickerView.delegate = self;
    
    // If you do not want the nodes repeated uncomment the line below.
    // [pickerView autoRepeatNodes:NO];
    [self addChild:pickerView];
}

-(void)spinPickerEase {
    
    int stopRow0 = arc4random() % 10;
    int stopRow1 = arc4random() % 10;
    int stopRow2 = arc4random() % 10;
    
    // Change the easeRate, speed, repeat and stopRow for the desired spin effect.
    // Seems like there is a bug with EaseInOut so use an integer value for easeRate.
    [pickerView spinComponent:0 speed:20 easeRate:1 repeat:2 stopRow:stopRow0];
    [pickerView spinComponent:1 speed:20 easeRate:2 repeat:2 stopRow:stopRow1];
    [pickerView spinComponent:2 speed:20 easeRate:3 repeat:2 stopRow:stopRow2];
}

#pragma mark - CCPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(CCPickerView *)pickerView {
    return 3;
}

- (NSInteger)pickerView:(CCPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    NSInteger numRows = 0;
    
    switch (component) {
        case 0:
            numRows = 12;
            break;
        case 1:
            numRows = 12;
            break;
        case 2:
            numRows = 12;
            break;
        default:
            break;
    }
    
    return numRows;
}

#pragma mark - CCPickerViewDelegate
- (CGFloat)pickerView:(CCPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return kComponentHeight;
}

- (CGFloat)pickerView:(CCPickerView *)pickerView widthForComponent:(NSInteger)component {
    return kComponentWidth;
}

- (NSString *)pickerView:(CCPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return @"Not used";
}

- (CCNode *)pickerView:(CCPickerView *)pickerView nodeForRow:(NSInteger)row forComponent:(NSInteger)component reusingNode:(CCNode *)node {
    
    CCSprite* sprite = [CCSprite spriteWithImageNamed:[NSString stringWithFormat:@"ccbResources/icons/icon%d.png", row+1]];
    [sprite setScale:0.4];
    return sprite;
}

- (void)pickerView:(CCPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSString*)component {
    CCLOG(@"didSelect row = %d, component = %@", row, component);
}

- (CGFloat)spaceBetweenComponents:(CCPickerView *)pickerView {
    return kComponentSpacing;
}

- (CGSize)sizeOfPickerView:(CCPickerView *)pickerView {
    CGSize size = m_slotwindow.boundingBox.size;
    
    return size;
}

- (CCNode *)overlayImage:(CCPickerView *)pickerView {
    
    CCSprite* sprite = [CCSprite spriteWithSpriteFrame:m_slotwindow.spriteFrame];
    return sprite;
}

- (void)onDoneSpinning:(CCPickerView *)pickerView component:(NSString*)component {
    switch ([component intValue]) {
        case 0: {
            break;
        }
        case 1: {
            break;
        }
        case 2: {
            
            break;
        }
        default:
            break;
    }
    
    NSLog(@"Component %@ stopped spinning.", component);
}

@end
