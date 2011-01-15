#import<CocosStepPrefix.h>
/*
 * cocos2d for iPhone: http://www.cocos2d-iphone.org
 *
 * Copyright (c) 2009-2010 Ricardo Quesada
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 *
 */

#import "CCParallaxNode.h"
#import "Support/CGPointExtension.h"
#import "Support/ccArray.h"

@interface CGPointObject : NSObject
{
	CGPoint	ratio_;
	CGPoint offset_;
	CCNode *child_;	// weak ref
}
//@property (readwrite) CGPoint ratio;
DeclareProperty_rw_as_at(CGPoint,ratio,Ratio);
//@property (readwrite) CGPoint offset;
DeclareProperty_rw_as_at(CGPoint,offset,Offset);
//@property (readwrite,assign) CCNode *child;
DeclareProperty_rw_as_at(CCNode*,child,Child);
+(id) pointWithCGPoint:(CGPoint)point offset:(CGPoint)offset;
-(id) initWithCGPoint:(CGPoint)point offset:(CGPoint)offset;
@end
@implementation CGPointObject
//@synthesize ratio = ratio_;
DefineProperty_rw_as_at(CGPoint,ratio,Ratio,ratio_);
//@synthesize offset = offset_;
DefineProperty_rw_as_at(CGPoint,offset,Offset,offset_);
//@synthesize child=child_;
DefineProperty_rw_as_at(CCNode*,child,Child,child_);

+(id) pointWithCGPoint:(CGPoint)ratio offset:(CGPoint)offset
{
	return [[[self alloc] initWithCGPoint:ratio offset:offset] autorelease];
}
-(id) initWithCGPoint:(CGPoint)ratio offset:(CGPoint)offset
{
	if( (self=[super init])) {
		ratio_ = ratio;
		offset_ = offset;
	}
	return self;
}
@end

@implementation CCParallaxNode

//@synthesize parallaxArray=parallaxArray_;
DefineProperty_rw_as_na(ccArray*,parallaxArray,ParallaxArray,parallaxArray_);

-(id) init
{
	if( (self=[super init]) ) {
		parallaxArray_ = ccArrayNew(5);		
		lastPosition = CGPointMake(-100,-100);
	}
	return self;
}

- (void) dealloc
{
	if( parallaxArray_ ) {
		ccArrayFree(parallaxArray_);
		parallaxArray_ = nil;
	}
	[super dealloc];
}

-(id) addChild:(CCNode*)child z:(int)z tag:(int)tag
{
	NSAssert(NO,@"ParallaxNode: use addChild:z:parallaxRatio:positionOffset instead");
	return nil;
}

-(id) addChild: (CCNode*) child z:(int)z parallaxRatio:(CGPoint)ratio positionOffset:(CGPoint)offset
{
	NSAssert( child != nil, @"Argument must be non-nil");
	CGPointObject *obj = [CGPointObject pointWithCGPoint:ratio offset:offset];
	[obj setChild:child];
	ccArrayAppendObjectWithResize(parallaxArray_, obj);
	
	CGPoint pos = [self position];
	float x = pos.x * ratio.x + offset.x;
	float y = pos.y * ratio.y + offset.y;
	[child setPosition: ccp(x,y)];
	
	return [super addChild: child z:z tag:[child tag]];
}

-(void) removeChild:(CCNode*)node cleanup:(BOOL)cleanup
{
unsigned int i;
	for(  i=0;i < parallaxArray_->num;i++) {
		CGPointObject *point = parallaxArray_->arr[i];
		if( [[point child] isEqual:node] ) {
			ccArrayRemoveObjectAtIndex(parallaxArray_, i);
			break;
		}
	}
	[super removeChild:node cleanup:cleanup];
}

-(void) removeAllChildrenWithCleanup:(BOOL)cleanup
{
	ccArrayRemoveAllObjects(parallaxArray_);
	[super removeAllChildrenWithCleanup:cleanup];
}

-(CGPoint) absolutePosition_
{
	CGPoint ret = position_;
	
	CCNode *cn = self;
	
	while ([cn parent] != nil) {
		cn = [cn parent];
		ret = ccpAdd( ret,  [cn position] );
	}
	
	return ret;
}

/*
 The positions are updated at visit because:
   - using a timer is not guaranteed that it will called after all the positions were updated
   - overriding "draw" will only precise if the children have a z > 0
*/
-(void) visit
{
//	CGPoint pos = position_;
//	CGPoint	pos = [self convertToWorldSpace:CGPointZero];
	CGPoint pos = [self absolutePosition_];
	if( ! CGPointEqualToPoint(pos, lastPosition) ) {
		unsigned int i;
		for(i=0; i < parallaxArray_->num; i++ ) {

			CGPointObject *point = parallaxArray_->arr[i];
			float x = -pos.x + pos.x * [point ratio].x + [point offset].x;
			float y = -pos.y + pos.y * [point ratio].y + [point offset].y;			
			[[point child] setPosition:ccp(x,y)];
		}
		
		lastPosition = pos;
	}
	
	[super visit];
}
@end