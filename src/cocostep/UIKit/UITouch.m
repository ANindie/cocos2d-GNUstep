#import<Foundation/Foundation.h>
#import"UITouch.h"

@implementation UITouch 

-(NSPoint)locationInView:(NSView*) view
{
	  NSPoint locationInView =
        [view convertPoint:mPoint fromView:[[mView window] contentView]];
	return locationInView;

}


-(NSPoint)previousLocationInView:(NSView*) view
{
	  NSPoint locationInView =
        [view convertPoint:mLastPoint fromView:[[mView window] contentView]];
	return locationInView;

}






-(NSView*)view
{
  return mView;	
}

-(void)setPoint:(NSPoint) inPoint
{
  mLastPoint =mPoint;
  mPoint = inPoint;
}

-(id)initWithPoint:(NSPoint) point withView:(NSView*) view
{	
  if((self=[super init]))
  {
	mPoint = point ;
 	mView  = [view retain];
  }	

  return self;
}

-(void)dealloc
{

  [mView release];		
  [super dealloc];

}

@end 

