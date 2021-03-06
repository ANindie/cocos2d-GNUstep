/*
 * cocos2d for iPhone: http://www.cocos2d-iphone.org
 *
 * Copyright (c) 2009 On-Core
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


#import "CCGridAction.h"
#import "CCDirector.h"
#import <math.h>

@implementation CCGridAction

//@synthesize gridSize;
DefineProperty_rw_as_na(ccGridSize,gridSize,GridSize,gridSize);

+(id) actionWithSize:(ccGridSize)size duration:(ccTime)d
{
	return [[[self alloc] initWithSize:size duration:d ] autorelease];
}

-(id) initWithSize:(ccGridSize)gSize duration:(ccTime)d
{
	if ( (self = [super initWithDuration:d]) )
	{
		gridSize = gSize;
	}
	
	return self;
}

-(void)startWithTarget:(id)aTarget
{
	[super startWithTarget:aTarget];

	CCGridBase *newgrid = [self grid];
	
	CCNode *t = (CCNode*) target;
	CCGridBase *targetGrid = [t grid];
	
	if ( targetGrid && [targetGrid reuseGrid] > 0 )
	{
		if ( [targetGrid active] && [targetGrid gridSize].x == gridSize.x && [targetGrid gridSize].y == gridSize.y && [targetGrid isKindOfClass:[newgrid class]] )
		{
			[targetGrid reuse];
		}
		else
		{
			[NSException raise:@"GridBase" format:@"Cannot reuse grid"];
		}
	}
	else
	{
		if ( targetGrid && [targetGrid active] )
			[targetGrid setActive:NO];
		[t setGrid:newgrid];
		[[t grid] setActive: YES];
	}	
}

-(CCGridBase *)grid
{
	[NSException raise:@"GridBase" format:@"Abstract class needs implementation"];
	return nil;
}

- (CCIntervalAction*) reverse
{
	return [CCReverseTime actionWithAction:self];
}

-(id) copyWithZone: (NSZone*) zone
{
	CCGridAction *copy = [[[self class] allocWithZone:zone] initWithSize:gridSize duration:duration];
	return copy;
}
@end

////////////////////////////////////////////////////////////


@implementation CCGrid3DAction

-(CCGridBase *)grid
{
	return [CCGrid3D gridWithSize:gridSize];
}

-(ccVertex3F)vertex:(ccGridSize)pos
{
	CCGrid3D *g = (CCGrid3D *)[target grid];
	return [g vertex:pos];
}

-(ccVertex3F)originalVertex:(ccGridSize)pos
{
	CCGrid3D *g = (CCGrid3D *)[target grid];
	return [g originalVertex:pos];
}

-(void)setVertex:(ccGridSize)pos vertex:(ccVertex3F)vertex
{
	CCGrid3D *g = (CCGrid3D *)[target grid];
	return [g setVertex:pos vertex:vertex];
}
@end

////////////////////////////////////////////////////////////


@implementation CCTiledGrid3DAction

-(CCGridBase *)grid
{
	return [CCTiledGrid3D gridWithSize:gridSize];
}

-(ccQuad3)tile:(ccGridSize)pos
{
	CCTiledGrid3D *g = (CCTiledGrid3D *)[target grid];
	return [g tile:pos];
}

-(ccQuad3)originalTile:(ccGridSize)pos
{
	CCTiledGrid3D *g = (CCTiledGrid3D *)[target grid];
	return [g originalTile:pos];
}

-(void)setTile:(ccGridSize)pos coords:(ccQuad3)coords
{
	CCTiledGrid3D *g = (CCTiledGrid3D *)[target grid];
	[g setTile:pos coords:coords];
}

@end

////////////////////////////////////////////////////////////

@interface CCIntervalAction (Amplitude)
-(void)setAmplitudeRate:(CGFloat)amp;
-(CGFloat)getAmplitudeRate;
@end

@implementation CCIntervalAction (Amplitude)
-(void)setAmplitudeRate:(CGFloat)amp
{
	[NSException raise:@"IntervalAction (Amplitude)" format:@"Abstract class needs implementation"];
}

-(CGFloat)getAmplitudeRate
{
	[NSException raise:@"IntervalAction (Amplitude)" format:@"Abstract class needs implementation"];
	return 0;
}
@end

////////////////////////////////////////////////////////////


@implementation CCAccelDeccelAmplitude

//@synthesize rate;
DefineProperty_rw_as_na(float,rate,Rate,rate);

+(id)actionWithAction:(CCAction*)action duration:(ccTime)d
{
	return [[[self alloc] initWithAction:action duration:d ] autorelease];
}

-(id)initWithAction:(CCAction *)action duration:(ccTime)d
{
	if ( (self = [super initWithDuration:d]) )
	{
		rate = 1.0f;
		other = [action retain];
	}
	
	return self;
}

-(void)dealloc
{
	[other release];
	[super dealloc];
}

-(void)startWithTarget:(id)aTarget
{
	[super startWithTarget:aTarget];
	[other startWithTarget:target];
}

-(void) update: (ccTime) time
{
	float f = time*2;
	
	if (f > 1)
	{
		f -= 1;
		f = 1 - f;
	}
	
	[other setAmplitudeRate:powf(f, rate)];
	[other update:time];
}

- (CCIntervalAction*) reverse
{
	return [CCAccelDeccelAmplitude actionWithAction:[other reverse] duration:duration];
}

@end

////////////////////////////////////////////////////////////


@implementation CCAccelAmplitude

//@synthesize rate;
DefineProperty_rw_as_na(float,rate,Rate,rate);

+(id)actionWithAction:(CCAction*)action duration:(ccTime)d
{
	return [[[self alloc] initWithAction:action duration:d ] autorelease];
}

-(id)initWithAction:(CCAction *)action duration:(ccTime)d
{
	if ( (self = [super initWithDuration:d]) )
	{
		rate = 1.0f;
		other = [action retain];
	}
	
	return self;
}

-(void)dealloc
{
	[other release];
	[super dealloc];
}

-(void)startWithTarget:(id)aTarget
{
	[super startWithTarget:aTarget];
	[other startWithTarget:target];
}

-(void) update: (ccTime) time
{
	[other setAmplitudeRate:powf(time, rate)];
	[other update:time];
}

- (CCIntervalAction*) reverse
{
	return [CCAccelAmplitude actionWithAction:[other reverse] duration:[self duration]];
}

@end

////////////////////////////////////////////////////////////


@implementation CCDeccelAmplitude

//@synthesize rate;
DefineProperty_rw_as_na(float,rate,Rate,rate);

+(id)actionWithAction:(CCAction*)action duration:(ccTime)d
{
	return [[[self alloc] initWithAction:action duration:d ] autorelease];
}

-(id)initWithAction:(CCAction *)action duration:(ccTime)d
{
	if ( (self = [super initWithDuration:d]) )
	{
		rate = 1.0f;
		other = [action retain];
	}
	
	return self;
}

-(void)dealloc
{
	[other release];
	[super dealloc];
}

-(void)startWithTarget:(id)aTarget
{
	[super startWithTarget:aTarget];
	[other startWithTarget:target];
}

-(void) update: (ccTime) time
{
	[other setAmplitudeRate:powf((1-time), rate)];
	[other update:time];
}

- (CCIntervalAction*) reverse
{
	return [CCDeccelAmplitude actionWithAction:[other reverse] duration:[self duration]];
}

@end

////////////////////////////////////////////////////////////


@implementation CCStopGrid

-(void)startWithTarget:(id)aTarget
{
	[super startWithTarget:aTarget];

	if ( [[self target] grid] && [[[self target] grid] active] ) {
		[[[self target] grid] setActive: NO];
		
//		[[self target] setGrid: nil];
	}
}

@end

////////////////////////////////////////////////////////////


@implementation CCReuseGrid

+(id)actionWithTimes:(int)times
{
	return [[[self alloc] initWithTimes:times ] autorelease];
}

-(id)initWithTimes:(int)times
{
	if ( (self = [super init]) )
	{
		t = times;
	}
	
	return self;
}

-(void)startWithTarget:(id)aTarget
{
	[super startWithTarget:aTarget];

	CCNode *myTarget = (CCNode*) [self target];
	if ( [myTarget grid] && [[myTarget grid] active] )
		[[myTarget grid] setReuseGrid:[[myTarget grid] reuseGrid] + t];
}

@end
