//
// cocos2d Hello World example
// http://www.cocos2d-iphone.org
//

// IMPORTANT:
//  This example ONLY shows the basic steps to render a sprite

// Needed for NSWindow, NSAutoReleasePool, and other objects
#import <AppKit/AppKit.h>

// Import the interfaces
#import "BasicSprite.h"

// BasicSprite implementation
@implementation BasicSprite



-(void) addNewSpriteWithCoords:(CGPoint)p
{
	int idx = CCRANDOM_0_1() * 1400 / 100;

	int x = (idx%5) * 85;
	int y = (idx/5) * 121;
	
	
	CCSprite *sprite = [CCSprite spriteWithFile:@"grossini_dance_atlas.png" rect:CGRectMake(x,y,85,121)];
	[self addChild:sprite];
	
	[sprite setPosition: ccp( p.x,p.y)];
	
	id action;
	float rand =10;;
	
	if( rand < 0.20 )
		action = [CCScaleBy actionWithDuration:3 scale:2];
	else if(rand < 0.40)
		action = [CCRotateBy actionWithDuration:3 angle:360];
	else if( rand < 0.60)
		action = [CCBlink actionWithDuration:1 blinks:3];
	else if( rand < 0.8 )
		action = [CCTintBy actionWithDuration:2 red:0 green:-255 blue:-255];
	else 
		action = [CCFadeOut actionWithDuration:2];
	id action_back = [action reverse];
	id seq = [CCSequence actions:action, action_back, nil];
	
	
	[sprite runAction: [CCRepeatForever actionWithAction:seq]];
	
}



// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init] )) {
		
		// create and initialize a Label
		
		
		// ask director the the window size
		CGSize s = [[CCDirector sharedDirector] winSize];
	
		// position the label on the center of the screen
		/*CCLabel* label = [CCLabel labelWithString:@"Hello World" fontName:@"Marker Felt" fontSize:64];
		[self addChild: label];
		[label setPosition:  ccp( s.width /2 , s.height/2 )];
		*/
		
		// add the label as a child to this Layer
		
		[self addNewSpriteWithCoords:ccp(s.width/2, s.height/2)];

		
		
	}
	return self;
}




-(NSString *) title
{
	return @"Sprite (tap screen)";
}


// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	
	// don't forget to call "super dealloc"
	[super dealloc];
}
@end

//
// Application Delegate implementation.
// Probably all your games will have a similar Application Delegate.
// For the moment it's not that important if you don't understand the following code.
//
@implementation AppController
 
// window is a property. @synthesize will create the accesors methods
//@synthesize window;

// Application entry point
- (void) applicationDidFinishLaunching:(NSApplication*)application
{
// Try to use CADisplayLink director
	// if it fails (SDK < 3.1) use Threaded director
	if( ! [CCDirector setDirectorType:kCCDirectorTypeDisplayLink] )
		[CCDirector setDirectorType:kCCDirectorTypeDefault];
	
	// create an initilize the main UIWindow
	window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

	// Attach cocos2d to the window
	[[CCDirector sharedDirector] attachInWindow:window];
	
	[[CCDirector sharedDirector] setDisplayFPS:YES];	
	

	// before creating any layer, set the landscape mode
	[[CCDirector sharedDirector] setDeviceOrientation:kCCDeviceOrientationLandscapeLeft];

	// Make the window visible
	[window makeKeyAndVisible];
	
	// Create and initialize parent and empty Scene
	CCScene *scene = [CCScene node];

	// Create and initialize our BasicSprite Layer
	CCLayer *layer = [BasicSprite node];
	// add our BasicSprite Layer as a child of the main scene
	[scene addChild:layer];

	[[CCDirector sharedDirector] setDisplayFPS:YES];	


	// Run!
	[[CCDirector sharedDirector] runWithScene: scene];



}

- (void) dealloc
{
	[window release];
	[super dealloc];
}

@end


//
// main entry point. Like any c or c++ program, the "main" is the entry point
//
int main(int argc, char **argv)
{


	
	// it is safe to leave these lines as they are.
	CREATE_AUTORELEASE_POOL(pool);


	UIApplicationMain(argc, argv, nil, @"AppController");
	DESTROY(pool);
	return 0;
}

