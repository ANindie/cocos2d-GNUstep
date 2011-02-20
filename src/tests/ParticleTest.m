//
// Particle Demo
// a cocos2d example
// http://www.cocos2d-iphone.org
//

// local import
#import "ParticleTest.h"

enum {
	kTagLabelAtlas = 1,
};

static int sceneIdx=-1;
static NSString *transitions[] = {
		@"DemoFlower",
		@"DemoGalaxy",
		@"DemoFirework",
		@"DemoSpiral",
		@"DemoSun",
		@"DemoMeteor",
		@"DemoFire",
		@"DemoSmoke",
		@"DemoExplosion",
		@"DemoSnow",
		@"DemoRain",
		@"DemoBigFlower",
		@"DemoRotFlower",
		@"DemoModernArt",
		@"DemoRing",
		@"ParallaxParticle",
		@"ParticleDesigner1",
		@"ParticleDesigner2",
		@"ParticleDesigner3",
		@"ParticleDesigner4",
		@"ParticleDesigner5",
		@"ParticleDesigner6",
		@"ParticleDesigner7",
		@"RadiusMode1",
		@"RadiusMode2",
};

Class nextAction()
{
	
	sceneIdx++;
	sceneIdx = sceneIdx % ( sizeof(transitions) / sizeof(transitions[0]) );
	NSString *r = transitions[sceneIdx];
	Class c = NSClassFromString(r);
	return c;
}

Class backAction()
{
	sceneIdx--;
	int total = ( sizeof(transitions) / sizeof(transitions[0]) );
	if( sceneIdx < 0 )
		sceneIdx += total;	

	NSString *r = transitions[sceneIdx];
	Class c = NSClassFromString(r);
	return c;
}

Class restartAction()
{
	NSString *r = transitions[sceneIdx];
	Class c = NSClassFromString(r);
	return c;
}

@implementation ParticleDemo

//@synthesize emitter;


DefineProperty_rw_rt_na(CCParticleSystem*,emitter,Emitter,emitter);

-(id) init
{
	if( (self=[super initWithColor:ccc4(127,127,127,255)] )) {

		[self setIsTouchEnabled : YES];
		
		CGSize s = [[CCDirector sharedDirector] winSize];
		CCLabel* label = [CCLabel labelWithString:[self title] fontName:@"Arial" fontSize:32];
		[self addChild:label z:100];
		[label setPosition: ccp(s.width/2, s.height-50)];
		
		CCLabel *tapScreen = [CCLabel labelWithString:@"Tap the Screen" fontName:@"Arial" fontSize:20];
		[tapScreen setPosition: ccp(s.width/2, s.height-80)];
		[self addChild:tapScreen z:100];
		
		CCMenuItemImage *item1 = [CCMenuItemImage itemFromNormalImage:@"b1.png" selectedImage:@"b2.png" target:self selector:@selector(backCallback:)];
		CCMenuItemImage *item2 = [CCMenuItemImage itemFromNormalImage:@"r1.png" selectedImage:@"r2.png" target:self selector:@selector(restartCallback:)];
		CCMenuItemImage *item3 = [CCMenuItemImage itemFromNormalImage:@"f1.png" selectedImage:@"f2.png" target:self selector:@selector(nextCallback:)];
		
		CCMenuItemToggle *item4 = [CCMenuItemToggle itemWithTarget:self selector:@selector(toggleCallback:) items:
								 [CCMenuItemFont itemFromString: @"Free Movement"],
								 [CCMenuItemFont itemFromString: @"Grouped Movement"],
								 nil];
		
		CCMenu *menu = [CCMenu menuWithItems:item1, item2, item3, item4, nil];
			
		[menu setPosition : CGPointZero];
		[item1 setPosition: ccp( s.width/2 - 100,30)];
		[item2 setPosition:  ccp( s.width/2, 30)];
		[item3 setPosition: ccp( s.width/2 + 100,30)];
		[item4 setPosition: ccp( 0, 100)];
		[item4 setAnchorPoint:  ccp(0,0)];

		[self addChild: menu z:100];	
		
		CCLabelAtlas *labelAtlas = [CCLabelAtlas labelAtlasWithString:@"0000" charMapFile:@"fps_images.png" itemWidth:16 itemHeight:24 startCharMap:'.'];
		[self addChild:labelAtlas z:100 tag:kTagLabelAtlas];
		[labelAtlas setPosition: ccp(254,50)];
		
		// moving background
		background = [CCSprite spriteWithFile:@"background3.png"];
		[self addChild:background z:5];
		[background setPosition:ccp(s.width/2, s.height-180)];

		id move = [CCMoveBy actionWithDuration:4 position:ccp(300,0)];
		id move_back = [move reverse];
		id seq = [CCSequence actions: move, move_back, nil];
		[background runAction:[CCRepeatForever actionWithAction:seq]];
		
		
		[self scheduleUpdate];
	}

	return self;
}

- (void) dealloc
{
	[emitter release];
	[super dealloc];
}


-(void) registerWithTouchDispatcher
{
	[[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:NO];
}

-(BOOL) ccTouchBegan:(UITouch*)touch withEvent:(UIEvent*)event
{
	[self ccTouchEnded:touch withEvent:event];
	
	// claim the touch
	return YES;
}
- (void)ccTouchMoved:(UITouch*)touch withEvent:(UIEvent *)event
{
	[self ccTouchEnded:touch withEvent:event];
}

- (void)ccTouchEnded:(UITouch*)touch withEvent:(UIEvent *)event
{
	CGPoint location = [touch locationInView: [touch view]];
	CGPoint convertedLocation = [[CCDirector sharedDirector] convertToGL:location];

	CGPoint pos = CGPointZero;
	
	if( background )
		pos = [background convertToWorldSpace:CGPointZero];
	[emitter setPosition: ccpSub(convertedLocation, pos)];	
}

-(void) update:(ccTime) dt
{
	CCLabelAtlas *atlas = (CCLabelAtlas*) [self getChildByTag:kTagLabelAtlas];

	NSString *str = [NSString stringWithFormat:@"%4d", [emitter particleCount]];
	[atlas setString:str];
}

-(NSString*) title
{
	return @"No title";
}

-(void) toggleCallback: (id) sender
{
	if( [emitter positionType] == kCCPositionTypeGrouped )
		[emitter setPositionType:  kCCPositionTypeFree];
	else
		[emitter setPositionType: kCCPositionTypeGrouped];
}

-(void) restartCallback: (id) sender
{
//	Scene *s = [Scene node];
//	[s addChild: [restartAction() node]];
//	[[Director sharedDirector] replaceScene: s];
	
	[emitter resetSystem];
//	[emitter stopSystem];
}

-(void) nextCallback: (id) sender
{
	CCScene *s = [CCScene node];
	[s addChild: [nextAction() node]];
	[[CCDirector sharedDirector] replaceScene: s];
}

-(void) backCallback: (id) sender
{
	CCScene *s = [CCScene node];
	[s addChild: [backAction() node]];
	[[CCDirector sharedDirector] replaceScene: s];
}

-(void) setEmitterPosition
{
	if( CGPointEqualToPoint( [emitter centerOfGravity], CGPointZero ) ) 
		[emitter setPosition: ccp(200, 70)];
}

@end

#pragma mark -

@implementation DemoFirework
-(void) onEnter
{
	[super onEnter];
	[self setEmitter: [CCParticleFireworks node]];
	[background addChild: emitter z:10];
	
	[emitter setTexture: [[CCTextureCache sharedTextureCache] addImage: @"test-rgba1.png"]];
	
	[self setEmitterPosition];
}
-(NSString *) title
{
	return @"ParticleFireworks";
}
@end

#pragma mark -

@implementation DemoFire
-(void) onEnter
{
	[super onEnter];
	[self setEmitter: [CCParticleFire node]];
	[background addChild: emitter z:10];
	
	[emitter setTexture: [[CCTextureCache sharedTextureCache] addImage: @"fire.pvr"]];
	CGPoint p = [emitter position];
	[emitter setPosition: ccp(p.x, 100)];
	
	[self setEmitterPosition];
}
-(NSString *) title
{
	return @"ParticleFire";
}
@end

#pragma mark -

@implementation DemoSun
-(void) onEnter
{
	[super onEnter];
	[self setEmitter: [CCParticleSun node]];
	[background addChild: emitter z:10];

	[emitter setTexture: [[CCTextureCache sharedTextureCache] addImage: @"fire.pvr"]];
	
	[self setEmitterPosition];
}
-(NSString *) title
{
	return @"ParticleSun";
}
@end

#pragma mark -

@implementation DemoGalaxy
-(void) onEnter
{
	[super onEnter];
	[self setEmitter: [CCParticleGalaxy node]];
	[background addChild: emitter z:10];
	
	[emitter setTexture: [[CCTextureCache sharedTextureCache] addImage: @"fire.pvr"]];
	
	[self setEmitterPosition];
}
-(NSString *) title
{
	return @"ParticleGalaxy";
}
@end

#pragma mark -

@implementation DemoFlower
-(void) onEnter
{
	[super onEnter];

	[self setEmitter: [CCParticleFlower node]];
	[background addChild: emitter z:10];
	[emitter setTexture: [[CCTextureCache sharedTextureCache] addImage: @"stars.png"]];
	
	[self setEmitterPosition];
}
-(NSString *) title
{
	return @"ParticleFlower";
}
@end

#pragma mark -

@implementation DemoBigFlower
-(void) onEnter
{
	[super onEnter];
	[self setEmitter: [[CCQuadParticleSystem alloc] initWithTotalParticles:50]];
	[background addChild: emitter z:10];
	[emitter setTexture: [[CCTextureCache sharedTextureCache] addImage: @"stars.png"]];
	
	// duration
	[emitter setDuration: kCCParticleDurationInfinity];
	
	// Gravity Mode: gravity
	[emitter setGravity: CGPointZero];

	// Set "Gravity" mode (default one)
	[emitter setEmitterMode: kCCParticleModeGravity];
	
	// Gravity Mode: speed of particles
	[emitter setSpeed : 160];
	[emitter setSpeedVar: 20];
		
	// Gravity Mode: radial
	[emitter setRadialAccel : -120];
	[emitter setRadialAccelVar : 0];
	
	// Gravity Mode: tagential
	[emitter setTangentialAccel: 30];
	[emitter setTangentialAccelVar: 0];
	
	// angle
	[emitter setAngle: 90];
	[emitter setAngleVar: 360];
		
	// emitter position
	[emitter setPosition: ccp(160,240)];
	[emitter setPosVar : CGPointZero];
	
	// life of particles
	[emitter setLife : 4];
	[emitter setLifeVar : 1];
	
	// spin of particles
	[emitter setStartSpin: 0];
	[emitter setStartSpinVar: 0];
	[emitter setEndSpin : 0];
	[emitter  setEndSpinVar  : 0];
	
	// color of particles
	ccColor4F startColor = {0.5f, 0.5f, 0.5f, 1.0f};
	[emitter setStartColor : startColor];
	
	ccColor4F startColorVar = {0.5f, 0.5f, 0.5f, 1.0f};
	[emitter setStartColorVar : startColorVar];
	
	ccColor4F endColor = {0.1f, 0.1f, 0.1f, 0.2f};
	[emitter setEndColor : endColor];
	
	ccColor4F endColorVar = {0.1f, 0.1f, 0.1f, 0.2f};	
	[emitter setEndColorVar : endColorVar];
	
	// size, in pixels
	[emitter setStartSize : 80.0f];
	[emitter setStartSizeVar : 40.0f];
	[emitter setEndSize : kCCParticleStartSizeEqualToEndSize];
	
	// emits per second
	[emitter setEmissionRate : [emitter totalParticles]/[emitter life]];
	
	// additive
	[emitter setBlendAdditive : YES];
	
	[self setEmitterPosition];
}
-(NSString *) title
{
	return @"Big Particles";
}
@end

#pragma mark -

@implementation DemoRotFlower
-(void) onEnter
{
	[super onEnter];
	[self setEmitter: [[CCQuadParticleSystem alloc] initWithTotalParticles:300]];
	[background addChild: emitter z:10];
	[emitter setTexture: [[CCTextureCache sharedTextureCache] addImage: @"stars2.png"]];
	
	// duration
	[emitter setDuration: kCCParticleDurationInfinity];
	
	// Set "Gravity" mode (default one)
	[emitter setEmitterMode: kCCParticleModeGravity];

	// Gravity mode: gravity
	[emitter setGravity: CGPointZero];
	
	// Gravity mode: speed of particles
	[emitter setSpeed : 160];
	[emitter setSpeedVar: 20];
	
	// Gravity mode: radial
	[emitter setRadialAccel : -120];
	[emitter setRadialAccelVar : 0];
	
	// Gravity mode: tagential
	[emitter setTangentialAccel: 30];
	[emitter setTangentialAccelVar: 0];
	
	// emitter position
	[emitter setPosition: ccp(160,240)];
	[emitter setPosVar : CGPointZero];
	
	// angle
	[emitter setAngle: 90];
	[emitter setAngleVar: 360];
		
	// life of particles
	[emitter setLife : 3];
	[emitter setLifeVar : 1];

	// spin of particles
	[emitter setStartSpin: 0];
	[emitter setStartSpinVar: 0];
	[emitter setEndSpin : 0];
	[emitter  setEndSpinVar  : 2000];
	
	// color of particles
	ccColor4F startColor = {0.5f, 0.5f, 0.5f, 1.0f};
	[emitter setStartColor : startColor];
	
	ccColor4F startColorVar = {0.5f, 0.5f, 0.5f, 1.0f};
	[emitter setStartColorVar : startColorVar];
	
	ccColor4F endColor = {0.1f, 0.1f, 0.1f, 0.2f};
	[emitter setEndColor : endColor];
	
	ccColor4F endColorVar = {0.1f, 0.1f, 0.1f, 0.2f};	
	[emitter setEndColorVar : endColorVar];

	// size, in pixels
	[emitter setStartSize : 30.0f];
	[emitter setStartSizeVar : 00.0f];
	[emitter setEndSize : kCCParticleStartSizeEqualToEndSize];
	
	// emits per second
	[emitter setEmissionRate : [emitter totalParticles]/[emitter life]];

	// additive
	[emitter setBlendAdditive : NO];
	
	[self setEmitterPosition];
	
}
-(NSString *) title
{
	return @"Spinning Particles";
}
@end

#pragma mark -

@implementation DemoMeteor
-(void) onEnter
{
	[super onEnter];
	[self setEmitter: [CCParticleMeteor node]];
	[background addChild: emitter z:10];
	
	[emitter setTexture: [[CCTextureCache sharedTextureCache] addImage: @"fire.pvr"]];
	
	[self setEmitterPosition];
}
-(NSString *) title
{
	return @"ParticleMeteor";
}
@end

#pragma mark -

@implementation DemoSpiral
-(void) onEnter
{
	[super onEnter];
	[self setEmitter: [CCParticleSpiral node]];
	[background addChild: emitter z:10];
	
	[emitter setTexture: [[CCTextureCache sharedTextureCache] addImage: @"fire.pvr"]];
	
	[self setEmitterPosition];
}
-(NSString *) title
{
	return @"ParticleSpiral";
}
@end

#pragma mark -

@implementation DemoExplosion
-(void) onEnter
{
	[super onEnter];
	[self setEmitter: [CCParticleExplosion node]];
	[background addChild: emitter z:10];
	
	[emitter setTexture: [[CCTextureCache sharedTextureCache] addImage: @"stars.png"]];
	
	[emitter setAutoRemoveOnFinish : YES];
	
	[self setEmitterPosition];
}
-(NSString *) title
{
	return @"ParticleExplosion";
}
@end

#pragma mark -

@implementation DemoSmoke
-(void) onEnter
{
	[super onEnter];
	[self setEmitter: [CCParticleSmoke node]];
	[background addChild: emitter z:10];
	
	CGPoint p = [emitter position];
	[emitter setPosition: ccp( p.x, 100)];
	
	[self setEmitterPosition];
}
-(NSString *) title
{
	return @"ParticleSmoke";
}
@end

#pragma mark -

@implementation DemoSnow
-(void) onEnter
{
	[super onEnter];
	[self setEmitter: [CCParticleSnow node]];
	[background addChild: emitter z:10];
	
	CGPoint p = [emitter position];
	[emitter setPosition: ccp( p.x, p.y-110)];
	[emitter setLife : 3];
	[emitter setLifeVar : 1];
	
	// gravity
	[emitter setGravity: ccp(0,-10)];
		
	// speed of particles
	[emitter setSpeed: 130];
	[emitter setSpeedVar: 30];
	
	
	ccColor4F startColor = [emitter startColor];
	startColor.r = 0.9f;
	startColor.g = 0.9f;
	startColor.b = 0.9f;
	[emitter setStartColor : startColor];
	
	ccColor4F startColorVar = [emitter startColorVar];
	startColor.b = 0.1f;
	[emitter setStartColorVar : startColorVar];
	
	[emitter setEmissionRate : [emitter totalParticles]/[emitter life]];
	
	[emitter setTexture: [[CCTextureCache sharedTextureCache] addImage: @"snow.png"]];
	
	[self setEmitterPosition];

}
-(NSString *) title
{
	return @"ParticleSnow";
}
@end

#pragma mark -

@implementation DemoRain
-(void) onEnter
{
	[super onEnter];
	[self setEmitter: [CCParticleRain node]];
	[background addChild: emitter z:10];
	
	CGPoint p = [emitter position];
	[emitter setPosition: ccp( p.x, p.y-100)];
	[emitter setLife : 4];
	
	[emitter setTexture: [[CCTextureCache sharedTextureCache] addImage: @"fire.pvr"]];
	
	[self setEmitterPosition];

}
-(NSString *) title
{
	return @"ParticleRain";
}
@end

#pragma mark -

@implementation DemoModernArt
-(void) onEnter
{
	[super onEnter];
	[self setEmitter: [[CCPointParticleSystem alloc] initWithTotalParticles:1000]];
	[background addChild: emitter z:10];
	
	CGSize s = [[CCDirector sharedDirector] winSize];
	
	// duration
	[emitter setDuration: kCCParticleDurationInfinity];
	
	// Gravity mode
	[emitter setEmitterMode: kCCParticleModeGravity];
	
	// Gravity mode: gravity
	[emitter setGravity: ccp(0,0)];
		
	// Gravity mode: radial
	[emitter setRadialAccel : 70];
	[emitter setRadialAccelVar : 10];
	
	// Gravity mode: tagential
	[emitter setTangentialAccel: 80];
	[emitter setTangentialAccelVar: 0];
	
	// Gravity mode: speed of particles
	[emitter setSpeed: 50];
	[emitter setSpeedVar: 10];
	
	// angle
	[emitter setAngle: 0];
	[emitter setAngleVar: 360];
	
	// emitter position
	[emitter setPosition: ccp( s.width/2, s.height/2)];
	[emitter setPosVar :  CGPointZero];
	
	// life of particles
	[emitter setLife : 2.0f];
	[emitter setLifeVar : 0.3f];
	
	// emits per frame
	[emitter setEmissionRate : [emitter totalParticles]/[emitter life]];
	
	// color of particles
	ccColor4F startColor = {0.5f, 0.5f, 0.5f, 1.0f};
	[emitter setStartColor : startColor];
	
	ccColor4F startColorVar = {0.5f, 0.5f, 0.5f, 1.0f};
	[emitter setStartColorVar : startColorVar];
	
	ccColor4F endColor = {0.1f, 0.1f, 0.1f, 0.2f};
	[emitter setEndColor : endColor];
	
	ccColor4F endColorVar = {0.1f, 0.1f, 0.1f, 0.2f};	
	[emitter setEndColorVar : endColorVar];
	
	// size, in pixels
	[emitter setStartSize : 1.0f];
	[emitter setStartSizeVar : 1.0f];
	[emitter setEndSize : 32.0f];
	[emitter setEndSizeVar: 8.0f];
	
	// texture
//	emitter setTexture: [[TextureCache sharedTextureCache] addImage:@"fire.png"];
	
	// additive
	[emitter setBlendAdditive : NO];
	
	[self setEmitterPosition];
}
-(NSString *) title
{
	return @"Varying size";
}
@end

#pragma mark -

@implementation DemoRing
-(void) onEnter
{
	[super onEnter];
	[self setEmitter: [[CCParticleFlower alloc] initWithTotalParticles:500]];
	[background addChild: emitter z:10];

	[emitter setTexture: [[CCTextureCache sharedTextureCache] addImage: @"stars.png"]];
	[emitter setLifeVar : 0];
	[emitter setLife : 10];
	[emitter setSpeed: 100];
	[emitter setSpeedVar: 0];
	[emitter setEmissionRate : 10000];
	
	[self setEmitterPosition];
}
-(NSString *) title
{
	return @"Ring Demo";
}
@end

#pragma mark -

@implementation ParallaxParticle
-(void) onEnter
{
	[super onEnter];

	[[background parent] removeChild:background cleanup:YES];
	background = nil;

	CCParallaxNode *p = [[CCParallaxNode alloc] init];
	[self addChild:p z:5];

	CCSprite *p1 = [CCSprite spriteWithFile:@"background3.png"];
	background = p1;
	
	CCSprite *p2 = [CCSprite spriteWithFile:@"background3.png"];

	[p addChild:p1 z:1 parallaxRatio:ccp(0.5f,1) positionOffset:ccp(0,250)];
	[p addChild:p2 z:2 parallaxRatio:ccp(1.5f,1) positionOffset:ccp(0,50)];

	
	[self setEmitter: [[CCParticleFlower alloc] initWithTotalParticles:500]];
	[p1 addChild:emitter z:10];
	[emitter setPosition:ccp(250,200)];
	
	id par = [[CCParticleSun alloc] initWithTotalParticles:250];
	[p2 addChild:par z:10];
	[par release];
	
	
	id move = [CCMoveBy actionWithDuration:4 position:ccp(300,0)];
	id move_back = [move reverse];
	id seq = [CCSequence actions: move, move_back, nil];
	[p runAction:[CCRepeatForever actionWithAction:seq]];	
}

-(NSString *) title
{
	return @"Parallax + Particles";
}
@end

#pragma mark -

@implementation ParticleDesigner1
-(void) onEnter
{
	[super onEnter];
	
	[self setColor:ccBLACK];
	[self removeChild:background cleanup:YES];
	background = nil;

	[self setEmitter: [CCQuadParticleSystem particleWithFile:@"Particles/SpookyPeas.plist"]];
	[self addChild: emitter z:10];
}

-(NSString *) title
{
	return @"PD: Spooky Peas";
}
@end

#pragma mark -

@implementation ParticleDesigner2
-(void) onEnter
{
	[super onEnter];
	
	[self setColor:ccBLACK];
	[self removeChild:background cleanup:YES];
	background = nil;

	[self setEmitter: [CCQuadParticleSystem particleWithFile:@"Particles/SpinningPeas.plist"]];
	[self addChild: emitter z:10];
	
	// custom spinning
	[[self emitter] setStartSpin: 0];
	[[self emitter] setStartSpin: 360];
	[[self emitter] setEndSpin : 720];
	[[self emitter]  setEndSpinVar  : 360];	
}

-(NSString *) title
{
	return @"PD: Spinning Peas";
}
@end


#pragma mark -

@implementation ParticleDesigner3
-(void) onEnter
{
	[super onEnter];
	
	[self setColor:ccBLACK];
	[self removeChild:background cleanup:YES];
	background = nil;

	[self setEmitter: [CCQuadParticleSystem particleWithFile:@"Particles/LavaFlow.plist"]];
	[self addChild: emitter z:10];

}

-(NSString *) title
{
	return @"PD: Lava Flow";
}
@end

#pragma mark -

@implementation ParticleDesigner4
-(void) onEnter
{
	[super onEnter];
	
	[self setColor:ccBLACK];
	[self setEmitter: [CCQuadParticleSystem particleWithFile:@"Particles/ExplodingRing.plist"]];
	[self addChild: emitter z:10];

	[self removeChild:background cleanup:YES];
	background = nil;
}

-(NSString *) title
{
	return @"PD: Exploding Ring";
}
@end

#pragma mark -

@implementation ParticleDesigner5
-(void) onEnter
{
	[super onEnter];
	
	[self setColor:ccBLACK];
	[self removeChild:background cleanup:YES];
	background = nil;

	[self setEmitter: [CCQuadParticleSystem particleWithFile:@"Particles/Comet.plist"]];
	[self addChild: emitter z:10];
}

-(NSString *) title
{
	return @"PD: Comet";
}
@end

#pragma mark -

@implementation ParticleDesigner6
-(void) onEnter
{
	[super onEnter];
	
	[self setColor:ccBLACK];
	[self removeChild:background cleanup:YES];
	background = nil;

	[self setEmitter: [CCQuadParticleSystem particleWithFile:@"Particles/BurstPipe.plist"]];
	[self addChild: emitter z:10];
}

-(NSString *) title
{
	return @"PD: Burst Pipe";
}
@end

#pragma mark -

@implementation ParticleDesigner7
-(void) onEnter
{
	[super onEnter];
	
	[self setColor:ccBLACK];
	[self removeChild:background cleanup:YES];
	background = nil;
	
	[self setEmitter: [CCQuadParticleSystem particleWithFile:@"Particles/BoilingFoam.plist"]];
	[self addChild: emitter z:10];
}

-(NSString *) title
{
	return @"PD: Boiling Foam";
}
@end

#pragma mark -

@implementation RadiusMode1
-(void) onEnter
{
	[super onEnter];
	
	[self setColor:ccBLACK];
	[self removeChild:background cleanup:YES];
	background = nil;
	
	[self setEmitter: [[CCQuadParticleSystem alloc] initWithTotalParticles:200]];
	[self addChild: emitter z:10];

	[emitter setTexture: [[CCTextureCache sharedTextureCache] addImage: @"stars.png"]];
	
	// duration
	[emitter setDuration: kCCParticleDurationInfinity];

	// radius mode
	[emitter setEmitterMode: kCCParticleModeRadius];
	
	// radius mode: start and end radius in pixels
[emitter setStartRadius : 0];
[emitter setStartRadiusVar : 0];
[emitter setEndRadius : 160];
[emitter setEndRadiusVar : 0];
	
	// radius mode: degrees per second
[emitter setRotatePerSecond : 180];
[emitter setRotatePerSecondVar:0];
	
	
	// angle
[emitter setAngle: 90];
[emitter setAngleVar: 0];
		
	// emitter position
	CGSize size = [[CCDirector sharedDirector] winSize];
[emitter setPosition: ccp( size.width/2, size.height/2)];
[emitter setPosVar :  CGPointZero];
	
	// life of particles
[emitter setLife : 5];
[emitter setLifeVar : 0];
	
	// spin of particles
[emitter setStartSpin: 0];
[emitter setStartSpinVar: 0];
[emitter setEndSpin : 0];
[emitter  setEndSpinVar  : 0];
	
	// color of particles
	ccColor4F startColor = {0.5f, 0.5f, 0.5f, 1.0f};
[emitter setStartColor : startColor];
	
	ccColor4F startColorVar = {0.5f, 0.5f, 0.5f, 1.0f};
[emitter setStartColorVar : startColorVar];
	
ccColor4F endColor = {0.1f, 0.1f, 0.1f, 0.2f};
[emitter setEndColor : endColor];
	
	ccColor4F endColorVar = {0.1f, 0.1f, 0.1f, 0.2f};	
[emitter setEndColorVar : endColorVar];
	
	// size, in pixels
[emitter setStartSize : 32];
[emitter setStartSizeVar : 0];
[emitter setEndSize : kCCParticleStartSizeEqualToEndSize];
	
	// emits per second
[emitter setEmissionRate : [emitter totalParticles]/[emitter life]];
	
	// additive
[emitter setBlendAdditive : NO];
}


-(NSString *) title
{
	return @"Radius Mode: Spiral";
}
@end

#pragma mark -

@implementation RadiusMode2
-(void) onEnter
{
	[super onEnter];
	
	[self setColor:ccBLACK];
	[self removeChild:background cleanup:YES];
	background = nil;
	
[self setEmitter: [[CCQuadParticleSystem alloc] initWithTotalParticles:200]];
	[self addChild: emitter z:10];

[emitter setTexture: [[CCTextureCache sharedTextureCache] addImage: @"stars.png"]];
	
	// duration
[emitter setDuration: kCCParticleDurationInfinity];
	
	// radius mode
[emitter setEmitterMode: kCCParticleModeRadius];
	
	// radius mode: 100 pixels from center
[emitter setStartRadius : 100];
[emitter  setStartRadiusVar : 0];
[emitter setEndRadius : kCCParticleStartRadiusEqualToEndRadius];
[emitter setEndRadiusVar : 0];	// not used when start == end
	
	// radius mode: degrees per second
	// 45 * 4 seconds of life = 180 degrees
[emitter setRotatePerSecond : 45];
[emitter setRotatePerSecondVar : 0];

	
	// angle
[emitter setAngle: 90];
[emitter setAngleVar: 0];
	
	// emitter position
	CGSize size = [[CCDirector sharedDirector] winSize];
[emitter setPosition: ccp( size.width/2, size.height/2)];
[emitter setPosVar :  CGPointZero];
	
	// life of particles
[emitter setLife : 4];
[emitter setLifeVar : 0];
	
	// spin of particles
[emitter setStartSpin: 0];
[emitter setStartSpinVar: 0];
[emitter setEndSpin : 0];
[emitter  setEndSpinVar  : 0];
	
	// color of particles
	ccColor4F startColor = {0.5f, 0.5f, 0.5f, 1.0f};
	[emitter setStartColor : startColor];
	
	ccColor4F startColorVar = {0.5f, 0.5f, 0.5f, 1.0f};
[emitter setStartColorVar : startColorVar];
	
	ccColor4F endColor = {0.1f, 0.1f, 0.1f, 0.2f};
[emitter setEndColor : endColor];
	
	ccColor4F endColorVar = {0.1f, 0.1f, 0.1f, 0.2f};	
[emitter setEndColorVar : endColorVar];
	
	// size, in pixels
[emitter setStartSize : 32];
[emitter setStartSizeVar : 0];
[emitter setEndSize : kCCParticleStartSizeEqualToEndSize];

	// emits per second
[emitter setEmissionRate : [emitter totalParticles]/[emitter life]];
	
	// additive
[emitter setBlendAdditive : NO];
	
}

-(NSString *) title
{
	return @"Radius Mode: Semi Circle";
}
@end



#pragma mark -
#pragma mark App Delegate

// CLASS IMPLEMENTATIONS
@implementation AppController

- (void) applicationDidFinishLaunching:(UIApplication*)application
{
	// Init the window
	window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	
	// cocos2d will inherit these values
	[window setUserInteractionEnabled:YES];	
	//[window setMultipleFTouchEnabled:YES];
	
	// must be called before any othe call to the director
	if( ! [CCDirector setDirectorType:kCCDirectorTypeDisplayLink] )
		[CCDirector setDirectorType:kCCDirectorTypeMainLoop];
	
	// before creating any layer, set the landscape mode
	[[CCDirector sharedDirector] setDeviceOrientation:kCCDeviceOrientationPortrait];
	[[CCDirector sharedDirector] setDisplayFPS: YES];

	// AnimationInterval doesn't work with FastDirector, yet
//	[[Director sharedDirector] setAnimationInterval: 1.0/60];

	// create OpenGL view and attach it to a window
	[[CCDirector sharedDirector] attachInView:window];
	
	// Default texture format for PNG/BMP/TIFF/JPEG/GIF images
	// It can be RGBA8888, RGBA4444, RGB5_A1, RGB565
	// You can change anytime.
	[CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGBA8888];	
	
	[window makeKeyAndVisible];

	CCScene *scene = [CCScene node];
	[scene addChild: [nextAction() node]];
	

			 
	[[CCDirector sharedDirector] runWithScene: scene];
}

- (void) dealloc
{
	[window release];
	[super dealloc];
}


// getting a call, pause the game
-(void) applicationWillResignActive:(UIApplication *)application
{
	[[CCDirector sharedDirector] pause];
}

// call got rejected
-(void) applicationDidBecomeActive:(UIApplication *)application
{
	[[CCDirector sharedDirector] resume];
}

// purge memroy
- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
	[[CCTextureCache sharedTextureCache] removeAllTextures];
}

// next delta time will be zero
-(void) applicationSignificantTimeChange:(UIApplication *)application
{
	[[CCDirector sharedDirector] setNextDeltaTimeZero:YES];
}

@end
