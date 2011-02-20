

#if ! OBJC2


#define DeclareProperty_ro_as_na(Type,name,Name) \
-(Type)name;



#define DeclareProperty_rw_as_na(Type,name,Name) \
-(Type)name;\
-(void)set##Name:(Type) inVal;

#define DeclareProperty_rw_rt_na(Type,name,Name) DeclareProperty_rw_as_na(Type,name,Name) 


#define DefineProperty_ro_as_na(Type,name,Name,var)\
-(Type)name\
{  return var;}\

#define DefineProperty_rw_as_at(Type,name,Name,var) DefineProperty_rw_as_na(Type,name,Name,var)
#define DeclareProperty_rw_as_at(Type,name,Name) DeclareProperty_rw_as_na(Type,name,Name)

#define DefineProperty_rw_as_na(Type,name,Name,var) \
-(Type)name\
{  return var;}\
-(void)set##Name:(Type) inVal\
{ var=inVal;}


#define DefineProperty_rw_rt_na(Type,name,Name,var) \
-(Type)name\
{  return var;}\
-(void)set##Name:(Type) inVal\
{ if(var == inVal) return;\
  [inVal retain]; [var release]; var=inVal ;  }

#define DeclareProperty_rw_rt_at(Type,name,Name) DeclareProperty_rw_rt_na(Type,name,Name)
 
#define DefineProperty_ro_rt_na(Type,name,Name,var) \
-(Type)name\
{  return var;}\



#define DefineProperty_ro(Type,val)\
-(Type)val\
{  return val;}

#define DefineProperty_ro_(Type,val)\
-(Type)val\
{  return _##val;}


#define DeclareProperty_rw_X(Type,val,Val,x)\
-(Type)val;\
-(void)set##Val:(Type) inVal;




#define DefineProperty_ro_x(Type,val,x)\
-(Type)val\
{  return x;}


#define DeclareProperty_rw(Type,val)\
-(Type)val;\
-(void)set##val:(Type) inVal;

#define DeclareProperty_rwrt(Type,val) DeclareProperty_rw(Type,val)

#define DefineProperty_rw(Type,val)\
-(Type)val\
{  return val;}\
-(void)set##val:(Type) inVal\
{ val=inVal;}

#define DefineProperty_rw_(Type,val)\
-(Type)val\
{  return _##val;}\
-(void)set##val:(Type) inVal\
{ _##val=inVal;}


#define DefineProperty_rw_x(Type,val,x)\
-(Type)val\
{  return x;}\
-(void)set##val:(Type) inVal\
{ x=inVal;}

#define DefineProperty_rw_X(Type,val,Val,x)\
-(Type)val\
{  return x;}\
-(void)set##Val:(Type) inVal\
{ x=inVal;}





#define UIEvent NSEvent 


#define DefineProperty_rwrt(Type,val)\
-(Type)val\
{  return val;}\
-(void)set##val:(Type) inVal\
{ if(val==inVal) return;\
  [inVal retain]; [val release]; val=inVal ;  }


#define DefineProperty_rwrt_x(Type,val,x)\
-(Type)val\
{  return x;}\
-(void)set##val:(Type) inVal\
{ if(x==inVal) return;\
  [inVal retain]; [x release]; x=inVal ;  }


#define DefineProperty_rwrt_X(Type,val,Val,x)\
-(Type)val\
{  return x;}\
-(void)set##Val:(Type) inVal\
{ if(x==inVal) return;\
  [inVal retain]; [x release]; x=inVal ;  }




#define DefineProperty_rwrt_(Type,val)\
-(Type)val\
{  return _##val;}\
-(void)set##val:(Type) inVal\
{ if(_##val==inVal) return;\
  [inVal retain]; [_##val release]; _##val=inVal ;  }

#else



#define DeclareProperty_ro(Type,val)

#define DefineProperty_ro(Type,val)

#define DefineProperty_ro_(Type,val)

#define DeclareProperty_rw(Type,val)
#define DefineProperty_rw(Type,val)

#define DefineProperty_rw_(Type,val)


#define DefineProperty_rwrt(Type,val)

#define DefineProperty_rwrt_(Type,val)

#endif




#define NS_REQUIRES_NIL_TERMINATION
#define UIView NSView


typedef enum {
	
	UIDeviceOrientationPortrait,	

	UIDeviceOrientationPortraitUpsideDown,
	/// Device oriented horizontally, home button on the right
UIDeviceOrientationLandscapeLeft,
	/// Device oriented horizontally, home button on the left
    UIDeviceOrientationLandscapeRight,
} UIDeviceOrientation;


typedef enum _UITextAlignment {
  UILeftTextAlignment=NSLeftTextAlignment,
  UIRightTextAlignment=NSRightTextAlignment,
  UICenterTextAlignment = NSCenterTextAlignment,
  UIJustifiedTextAlignment = NSJustifiedTextAlignment,
  UINaturalTextAlignment = NSNaturalTextAlignment,
  
} UITextAlignment;



#define TRUE 1;
#define FALSE 0;

#define GNUSTEP__attribute__(X);

#ifndef GLOBALNSEnumerator
#define GLOBALNSEnumerator
extern NSEnumerator *gCoCoSTenumerator;
extern NSEnumerator *gCoCoSTenumerator1;
extern NSEnumerator *gCoCoSTenumerator2;
extern NSEnumerator *gCoCoSTenumerator2;
#endif

#define FLT_EPSILON M_E 
#define UIFont NSFont 
 
#define FORIN(Type,var ,collection) \
NSEnumerator * coCoSTenumerator = [collection objectEnumerator];\
Type var; \
while((var = [coCoSTenumerator nextObject]) != NULL)



#define CFSwapInt32LittleToHost(X) (X)

#if CC_ABORT_ON_ASSERT
#undef NSAssert
#define NSAssert(cond,msg) \
if(!(cond)){ NSLog(@"Assertion failed  %@ %s",msg,#cond);abort();}
#endif


 

