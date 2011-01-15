#import<Foundation/Foundation.h>
#import"UITouch.h"

@implementation UITouch 

-(NSPoint)locationInView:(NSView*) view
{
	  NSPoint locationInView =
        [view convertPoint:[mEvent locationInWindow] fromView:[[mView window] contentView]];
	return locationInView;

}
-(NSView*)view
{
  return mView;	
}


-(id)initWithPoint:(NSEvent*) point withView:(NSView*) view
{	
  if((self=[super init]))
  {
	mEvent = [point retain];
 	mView  = [view retain];
  }	

  return self;
}

-(void)dealloc
{
  [mEvent release];	
  [mView release];		
  [super dealloc];

}

@end 

