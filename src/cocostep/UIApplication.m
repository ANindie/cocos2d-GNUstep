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



@implementation UIApplication

 -(id)init
 { 
    if((self =[super init]))
    {
    	mMainScreen =  [[UIScreen alloc]    initWithContentRect: NSMakeRect(0,0,320,480)
	     styleMask: (NSTitledWindowMask  )
	     backing: NSBackingStoreRetained
	     defer: NO];
    
        NSView * view =[[NSView alloc] initWithFrame: NSMakeRect(0,0,320,480)];
	   [mMainScreen setContentView:view];
	   [view release];

    
    
    }
    
    return self;
 }
 
 
- (void)dealloc
{
	[mMainScreen release];
	
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

