//
// Interval Demo
// a cocos2d example
// http://www.cocos2d-iphone.org
//


#import "IntervalTest.h"


@implementation Layer1
-(id) init
{
	if( (self=[super init])) {
		
		CGSize s = [[CCDirector sharedDirector] winSize];
		// sun
		CCParticleSystem* sun = [CCParticleSun node];
		[sun setPosition :ccp(s.width-32,s.height-32)];

		[sun setTotalParticles :130];
		[sun setLife: 0.6f];
		[self addChild:sun];

		// timers
		label1 = [CCBitmapFontAtlas bitmapFontAtlasWithString:@"0" fntFile:@"bitmapFontTest4.fnt"];
		label2 = [CCBitmapFontAtlas bitmapFontAtlasWithString:@"0" fntFile:@"bitmapFontTest4.fnt"];
		label3 = [CCBitmapFontAtlas bitmapFontAtlasWithString:@"0" fntFile:@"bitmapFontTest4.fnt"];
		
		[self schedule: @selector(step1:) interval: 0.5f];
		[self schedule: @selector(step2:) interval:1.0f];
		[self schedule: @selector(step3:) interval: 1.5f];
		
		[label1 setPosition: ccp(80,s.width/2)];
		[label2 setPosition: ccp(240,s.width/2)];
		[label3 setPosition : ccp(400,s.width/2)];
		
		[self addChild:label1];
		[self addChild:label2];
		[self addChild:label3];
		
		// Sprite
		CCSprite *sprite = [CCSprite spriteWithFile:@"grossini.png"];
		[sprite setPosition :ccp(40,50)];
		
		id jump = [CCJumpBy actionWithDuration:3 position:ccp(400,0) height:50 jumps:4];
		
		[self addChild:sprite];
		[sprite runAction: [CCRepeatForever actionWithAction:
						[CCSequence actions: jump, [jump reverse], nil]
							]
		 ];

		// pause button
		CCMenuItem *item1 = [CCMenuItemFont itemFromString: @"Pause" target:self selector:@selector(pause:)];
		CCMenu *menu = [CCMenu menuWithItems: item1, nil];
		[menu setPosition: ccp(s.height-50, 270)];

		[self addChild: menu];
	}
		
	return self;
}

- (void) dealloc
{
	[super dealloc];
}

-(void) pause: (id) sender
{
	[[CCDirector sharedDirector] pause];
	
	// Dialog
/*	UIAlertView* dialog = [[UIAlertView alloc] init];
	[dialog setDelegate:self];
	[dialog setTitle:@"Game Paused"];
	[dialog setMessage:@"Game paused"];
	[dialog addButtonWithTitle:@"Resume"];
	[dialog show];	
	[dialog release];
*/

    NSAlert *alert = [[NSAlert alloc] init];
    [alert addButtonWithTitle:@"Resume"];
    [alert setMessageText:@"Game Paused"];
    [alert setInformativeText:@"Do you want to Resume?"];
    [alert setAlertStyle:NSInformationalAlertStyle];
    [alert beginSheetModalForWindow:[UIScreen mainScreen] modalDelegate:self didEndSelector:@selector(alertDidEnd:returnCode:contextInfo:) contextInfo:nil];
	
}

//- (void) alertView:(UIAlertView *)alert clickedButtonAtIndex:(NSInteger)buttonIndex
-(void)alertDidEnd:(NSAlert *)alert returnCode:(NSInteger)returnCode     contextInfo:(void *)contextInfo
{	
	[[CCDirector sharedDirector] resume];
}

-(void) step1: (ccTime) delta
{
//	time1 +=delta;
	time1 +=1;
	[label1 setString: [NSString stringWithFormat:@"%2.1f", time1] ];
}

-(void) step2: (ccTime) delta
{
//	time2 +=delta;
	time2 +=1;
	[label2 setString: [NSString stringWithFormat:@"%2.1f", time2] ];
}

-(void) step3: (ccTime) delta
{
//	time3 +=delta;
	time3 +=1;
	[label3 setString: [NSString stringWithFormat:@"%2.1f", time3] ];
}

@end

// CLASS IMPLEMENTATIONS
@implementation AppController

- (void) applicationDidFinishLaunching:(UIApplication*)application
{
	// Init the window
	window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	
	// cocos2d will inherit these values
	[window setUserInteractionEnabled:YES];	
	[window setMultipleTouchEnabled:NO];
	
	// must be called before any othe call to the director
	[CCDirector setDirectorType:kCCDirectorTypeDisplayLink];

	
	// before creating any layer, set the landscape mode
	[[CCDirector sharedDirector] setDeviceOrientation:kCCDeviceOrientationLandscapeLeft];
	[[CCDirector sharedDirector] setDisplayFPS:YES];

	// frames per second
	[[CCDirector sharedDirector] setAnimationInterval:1.0/60];
	
	// Default texture format for PNG/BMP/TIFF/JPEG/GIF images
	// It can be RGBA8888, RGBA4444, RGB5_A1, RGB565
	// You can change anytime.
	[CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGBA8888];	

	// create an openGL view inside a window
	[[CCDirector sharedDirector] attachInView:window];	

	
	[window makeKeyAndVisible];	
	
	CCScene *scene = [CCScene node];

	[scene addChild: [Layer1 node] z:0];

	

	[[CCDirector sharedDirector] runWithScene: scene];
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

- (void) dealloc
{
	[window release];
	[super dealloc];
}

@end
