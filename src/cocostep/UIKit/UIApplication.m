#import "UIApplication.h"


@interface UIApplication (internal)

 -(UIScreen*)mainScreen;
@end


@implementation UIApplication (internal)

 -(UIScreen*)mainScreen
 {
   return mMainScreen;
 }
@end

#ifndef DEFAULT_SCREEN_HIEGHT
#define DEFAULT_SCREEN_HIEGHT 480
#endif

#ifndef DEFAULT_SCREEN_WIDTH
#define DEFAULT_SCREEN_WIDTH 320
#endif

static NSSize sUIScreenSize; 
@implementation UIApplication

 -(id)init
 { 
    if((self =[super init]))
    {
     sUIScreenSize = NSMakeSize(DEFAULT_SCREEN_WIDTH,DEFAULT_SCREEN_HIEGHT);
     
      const char * screensize=getenv("UISCREEN_SIZE");
      if(screensize)
      {
      
      	 NSString* nssizestr =[NSString stringWithCString: screensize];
      	 NSSize uIScreenSize=NSSizeFromString(nssizestr);
      	 if(uIScreenSize.width>10 && uIScreenSize.width<1024 && uIScreenSize.height>10 && uIScreenSize.height<1024)
      	 {
           sUIScreenSize = uIScreenSize;
      	 }
      
      }
     
        
      //sUIScreenSize = getEnv 
        
      
    	mMainScreen =  [[UIScreen alloc]    initWithContentRect: NSMakeRect(0,0,sUIScreenSize.width,sUIScreenSize.height)
	     styleMask: (NSTitledWindowMask|NSClosableWindowMask )
	     backing: NSBackingStoreRetained
	     defer: NO];
    
        NSView * view =[[NSView alloc] initWithFrame: NSMakeRect(0,0,sUIScreenSize.width,sUIScreenSize.height)];
	   [mMainScreen setContentView:view];
	   [view release];

      [mMainScreen setDelegate:self];
    
    }
    
    return self;
 }
 
 
 - (BOOL) windowShouldClose: (id)sender
 {
 	 [self terminate:sender];	
 	 return NO;
 }

 
 
 
- (void)dealloc
{
	
	[super dealloc];
}
 
+(UIApplication*)sharedApplication
{
	static UIApplication * _sharedApplication=nil;
	if(_sharedApplication == nil)
		_sharedApplication = [[UIApplication alloc]init];
	
	return _sharedApplication;
}

-(void)run
{
   
	
    [super run];
}


@end



int UIApplicationMain(int argc, const char *argv[], id dummy, NSString * delegateName)
{
   	
   
	
   UIApplication * app =[UIApplication sharedApplication] ;	 
   id  controller = [[[NSBundle mainBundle] classNamed: delegateName] new];
   [app setDelegate: controller];
  
	    
   
   [app run];
   
   RELEASE (controller);
	
	
	//return  NSApplicationMain (argc, argv);
	return 0;
}




@implementation UIWindow

-(id)initWithFrame:(NSRect)frame
 { 
    if((self =[super initWithFrame:frame]))
    {
	
			[[[UIScreen mainScreen] contentView] addSubview:self];	
    }
    
    return self;
 }
 
-(void)makeKeyAndVisible
{
	

   	[[UIScreen mainScreen]  orderFront:nil];
	[[UIScreen mainScreen]  makeKeyWindow];
	
}
-(NSView*)contentView
{
    return self;
}


//must be moved to uiview
-(BOOL) isUserInteractionEnabled
{
	return YES;
}

-(void)setUserInteractionEnabled:(BOOL)status
{

}

-(BOOL) isMultipleTouchEnabled
{
	return NO;
}

-(void)setMultipleTouchEnabled:(BOOL)status
{

}

@end 



@implementation UIScreen

-(NSRect)bounds
{
  return NSMakeRect(0,0,[super frame].size.width,[super frame].size.height);
}


+(UIScreen*)mainScreen
{
   return [[UIApplication sharedApplication] mainScreen];

}

@end 

