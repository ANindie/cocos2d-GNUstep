#import <AppKit/AppKit.h>


@protocol UIApplicationDelegate
@end





@interface UIScreen: NSWindow
{
}
-(NSRect)bounds;
+(UIScreen*)mainScreen;
@end 


@interface UIWindow: NSView
{
}

//dummy
-(BOOL) isUserInteractionEnabled;
-(void)setUserInteractionEnabled:(BOOL)status;
-(BOOL) isMultipleTouchEnabled;
-(void)setMultipleTouchEnabled:(BOOL)status;

-(void)makeKeyAndVisible;
-(NSView*)contentView;
@end 



@interface UIApplication: NSApplication
{
  UIScreen * mMainScreen;
}


+(UIApplication*)sharedApplication;


@end


int UIApplicationMain(int argc,const  char *argv[], id dummy, NSString * delegateName);

