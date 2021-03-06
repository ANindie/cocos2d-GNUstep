/*
 * cocos2d for iPhone: http://www.cocos2d-iphone.org
 *
 * Copyright (c) 2008-2010 Ricardo Quesada
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


#import "CCBlockSupport.h"
#import "CCInstantAction.h"
#import "CCNode.h"
#import "CCSprite.h"


//
// InstantAction
//

@implementation CCInstantAction

-(id) init
{
	if( (self=[super init]) )	
		duration = 0;
	return self;
}

-(id) copyWithZone: (NSZone*) zone
{
	CCInstantAction *copy = [[[self class] allocWithZone: zone] init];
	return copy;
}

- (BOOL) isDone
{
	return YES;
}
-(void) step: (ccTime) dt
{
	[self update: 1];
}
-(void) update: (ccTime) t
{
	// ignore
}
-(CCFiniteTimeAction*) reverse
{
	return [[self copy] autorelease];
}
@end

//
// Show
//

@implementation CCShow
-(void) startWithTarget:(id)aTarget
{
	[super startWithTarget:aTarget];
	[((CCNode *)target) setVisible:YES];
}
-(CCFiniteTimeAction*) reverse
{
	return [CCHide action];
}
@end

//
// Hide
//

@implementation CCHide
-(void) startWithTarget:(id)aTarget
{
	[super startWithTarget:aTarget];
	[((CCNode *)target) setVisible: NO];
}
-(CCFiniteTimeAction*) reverse
{
	return [CCShow action];
}
@end

//
// ToggleVisibility
//

@implementation CCToggleVisibility
-(void) startWithTarget:(id)aTarget
{
	[super startWithTarget:aTarget];
	[((CCNode *)target) setVisible:![((CCNode *)target) visible]];
}
@end

//
// FlipX
//

@implementation CCFlipX
+(id) actionWithFlipX:(BOOL)x
{
	return [[[self alloc] initWithFlipX:x] autorelease];
}

-(id) initWithFlipX:(BOOL)x
{
	if(( self=[super init])) {
		flipX = x;
	}
	
	return self;
}

-(void) startWithTarget:(id)aTarget
{
	[super startWithTarget:aTarget];
	[(CCSprite*)aTarget setFlipX:flipX];
}

-(CCFiniteTimeAction*) reverse
{
	return [CCFlipX actionWithFlipX:!flipX];
}

-(id) copyWithZone: (NSZone*) zone
{
	CCInstantAction *copy = [[[self class] allocWithZone: zone] initWithFlipX:flipX];
	return copy;
}
@end

//
// FlipY
//

@implementation CCFlipY
+(id) actionWithFlipY:(BOOL)y
{
	return [[[self alloc] initWithFlipY:y] autorelease];
}

-(id) initWithFlipY:(BOOL)y
{
	if(( self=[super init])) {
		flipY = y;
	}
	
	return self;
}

-(void) startWithTarget:(id)aTarget
{
	[super startWithTarget:aTarget];
	[(CCSprite*)aTarget setFlipY:flipY];
}

-(CCFiniteTimeAction*) reverse
{
	return [CCFlipY actionWithFlipY:!flipY];
}

-(id) copyWithZone: (NSZone*) zone
{
	CCInstantAction *copy = [[[self class] allocWithZone: zone] initWithFlipY:flipY];
	return copy;
}
@end


//
// Place
//

@implementation CCPlace
+(id) actionWithPosition: (CGPoint) pos
{
	return [[[self alloc]initWithPosition:pos]autorelease];
}

-(id) initWithPosition: (CGPoint) pos
{
	if( (self=[super init]) )
		position = pos;
	return self;
}

-(id) copyWithZone: (NSZone*) zone
{
	CCInstantAction *copy = [[[self class] allocWithZone: zone] initWithPosition: position];
	return copy;
}

-(void) startWithTarget:(id)aTarget
{
	[super startWithTarget:aTarget];
	[((CCNode *)target)setPosition:position];
}
@end

//
// CallFunc
//

@implementation CCCallFunc
+(id) actionWithTarget: (id) t selector:(SEL) s
{
	return [[[self alloc] initWithTarget: t selector: s] autorelease];
}

-(id) initWithTarget: (id) t selector:(SEL) s
{
	if( (self=[super init]) ) {
		targetCallback = [t retain];
		selector = s;
	}
	return self;
}

-(void) dealloc
{
	[targetCallback release];
	[super dealloc];
}

-(id) copyWithZone: (NSZone*) zone
{
	CCInstantAction *copy = [[[self class] allocWithZone: zone] initWithTarget:targetCallback selector:selector];
	return copy;
}


-(void) startWithTarget:(id)aTarget
{
	[super startWithTarget:aTarget];
	[self execute];
}

-(void) execute
{
	[targetCallback performSelector:selector];
}
@end

//
// CallFuncN
//

@implementation CCCallFuncN

-(void) execute
{
	[targetCallback performSelector:selector withObject:target];
}
@end

//
// CallFuncND
//

@implementation CCCallFuncND

//@synthesize callbackMethod = callbackMethod_;
DefineProperty_rw_as_na(CC_CALLBACK_ND,callbackMethod,CallbackMethod,callbackMethod_);

+(id) actionWithTarget:(id)t selector:(SEL)s data:(void*)d
{
	return [[[self alloc] initWithTarget:t selector:s data:d] autorelease];
}

-(id) initWithTarget:(id)t selector:(SEL)s data:(void*)d
{
	if( (self=[super initWithTarget:t selector:s]) ) {
		data = d;

#if COCOS2D_DEBUG
		NSMethodSignature * sig = [[t class] instanceMethodSignatureForSelector:s];
		NSAssert(sig !=0 , @"Signature not found for selector - does it have the following form? -(void)name:(id)sender data:(void*)data");
#endif
		callbackMethod_ = (CC_CALLBACK_ND) [t methodForSelector:s];
	}
	return self;
}

-(id) copyWithZone: (NSZone*) zone
{
	CCInstantAction *copy = [[[self class] allocWithZone: zone] initWithTarget:targetCallback selector:selector data:data];
	return copy;
}

-(void) dealloc
{
	// nothing to dealloc really. Everything is dealloc on super (CCCallFuncN)
	[super dealloc];
}

-(void) execute
{
	callbackMethod_(targetCallback,selector,target, data);
}
@end


#if NS_BLOCKS_AVAILABLE


@implementation CCCallBlock

+(id) actionWithBlock:(void(^)())block {
	return [[[self alloc] initWithBlock:block] autorelease];
}

-(id) initWithBlock:(void(^)())block {
	if ((self = [super init])) {
	
		block_ = [block retain];
	}
	return self;
}

-(id) copyWithZone: (NSZone*) zone {
	CCInstantAction *copy = [[[self class] allocWithZone: zone] initWithBlock:block_];
	return copy;
}

-(void) startWithTarget:(id)aTarget {
	[super startWithTarget:aTarget];
	[self execute];
}

-(void) execute {
	block_();
}

-(void) dealloc {
	[block_ release];
	[super dealloc];
}

@end


@implementation CCCallBlockN

+(id) actionWithBlock:(void(^)(CCNode *node))block {
	return [[[self alloc] initWithBlock:block] autorelease];
}

-(id) initWithBlock:(void(^)(CCNode *node))block {
	if ((self = [super init])) {
	
		block_ = [block retain];
	}
	return self;
}

-(id) copyWithZone: (NSZone*) zone {
	CCInstantAction *copy = [[[self class] allocWithZone: zone] initWithBlock:block_];
	return copy;
}

-(void) startWithTarget:(id)aTarget {
	[super startWithTarget:aTarget];
	[self execute];
}

-(void) execute {
	block_(target);
}

-(void) dealloc {
	[block_ release];
	[super dealloc];
}

@end


#endif // NS_BLOCKS_AVAILABLE
