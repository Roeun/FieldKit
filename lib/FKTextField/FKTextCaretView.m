/*
 
 FKTextCaretView.m
 FieldKit
 
 Copyright (cc) 2012 Luis Laugga.
 Some rights reserved, all wrongs deserved.
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of
 this software and associated documentation files (the "Software"), to deal in
 the Software without restriction, including without limitation the rights to
 use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
 the Software, and to permit persons to whom the Software is furnished to do so,
 subject to the following conditions:

 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
 FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
 COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
 IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
 CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 
*/

#import "FKTextCaretView.h"

#import "FKTextAppearance.h"

static const NSTimeInterval FKTextCaretBlinkDelay = 0.7;
static const NSTimeInterval FKTextCaretBlinkRate = 0.5;

@implementation FKTextCaretView

#pragma mark -
#pragma mark Initialization

- (void)dealloc
{
    self.blinkTimer = nil;
    [super dealloc];
}

+ (FKTextCaretView *)defaultCaretView
{
    // Create and set caret view using default values
    FKTextCaretView * caretView = [[FKTextCaretView alloc] init];
    caretView.backgroundColor = [FKTextAppearance defaultSelectionCaretColor];
    return [caretView autorelease];
}

- (id)init
{
    self = [super initWithFrame:CGRectZero];
    if(self)
    {
        self.blinkTimer = nil;
        _blink = NO;
    }
    return self;
}

#pragma mark -
#pragma mark UIView

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    NSLog(@"pointInside %f %f", point.x, point.y);
    CGRect hitRect = CGRectMake(self.frame.origin.x-20, self.frame.origin.y-20, self.frame.size.width+40, self.frame.size.height+40);
    return CGRectContainsPoint(hitRect, point);
}

#pragma mark -
#pragma mark Show/Hide/Update

- (void)show
{
    // Show
    self.hidden = NO;
    
    // Start blinking if needed
    [self blinkIfNeeded];
}

- (void)hide
{
    // Clear blink timer
    [self clearBlinkTimer];
    
    // Hide
    self.hidden = YES;
}

- (void)update:(CGRect)textRect
{
    // Update caret view frame
    self.frame = [FKTextAppearance selectionCaretFrameForTextRect:textRect];
}

- (void)touch
{
    [self touchBlinkTimer];
}

#pragma mark -
#pragma mark Blink

- (void)blinkTimerFired:(id)info // caret timer action
{
    // Toggle caret view visibility
    self.hidden = !self.hidden;
}

- (void)blinkIfNeeded // setup caret timer
{
    // Set up caret timer
    if(self.blinkTimer == nil)
        self.blinkTimer = [NSTimer scheduledTimerWithTimeInterval:FKTextCaretBlinkRate target:self selector:@selector(blinkTimerFired:) userInfo:nil repeats:YES];
    
    // Set caret view visible
    self.hidden = NO;
    
    // Set caret blinks flag
    _blink = YES;
}

- (void)touchBlinkTimer // reset caret timer fire date
{
    // Update caret timer
    [_blinkTimer setFireDate:[NSDate dateWithTimeIntervalSinceNow:FKTextCaretBlinkDelay]];
    
    // Set caret view visible
    self.hidden = NO;
}

- (void)clearBlinkTimer // invalidate caret timer
{
    // Release caret timer
    [_blinkTimer invalidate];
    self.blinkTimer = nil;
    
    // Set caret view visible
    self.hidden = NO;
    
    // Mark caret blinks flag
    _blink = NO;
}

@end