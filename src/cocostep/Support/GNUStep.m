


///---------------Affain transform related work
 NSAffineTransformStruct CGAffineTransformIdentity = {
   1.0, 0.0, 0.0, 1.0, 0.0, 0.0
};



  CGPoint CS_CGPointApplyAffineTransform(CGPoint point,CGAffineTransform transform_)
{
 
 	NSAffineTransform * transform =[NSAffineTransform new];
	[transform setTransformStruct:transform_];
	point = [transform transformPoint:point];
	[transform release];
	return point;
}

  CGSize  CS_CGSizeApplyAffineTransform(CGSize point,CGAffineTransform transform_) 
{
 
 	NSAffineTransform * transform =[NSAffineTransform new];
	[transform setTransformStruct:transform_];
	point = [transform transformSize:point];
	[transform release];
	return point;
}




 CGRect  CS_CGRectApplyAffineTransform(CGRect rect,CGAffineTransform transform) 
{
    
	rect.origin =   CGPointApplyAffineTransform(rect.origin, transform)	;			
	rect.size =   CGSizeApplyAffineTransform(rect.size, transform);					
	return rect; 	
}




 CGAffineTransform CS_CGAffineTransformTranslate(CGAffineTransform transform_, CGFloat anchorPointInPixelsx, CGFloat anchorPointInPixelsy)
{

	
 	NSAffineTransform * transform =[NSAffineTransform new];
	[transform setTransformStruct:transform_];
	[transform  translateXBy: anchorPointInPixelsx yBy: anchorPointInPixelsy];
	transform_ = [transform transformStruct];
	[transform release];
	return transform_;


}




 CGAffineTransform CS_CGAffineTransformRotate(CGAffineTransform transform_ , CGFloat rotation_)
{
	
 	NSAffineTransform * transform =[NSAffineTransform new];
	[transform setTransformStruct:transform_];
	[transform rotateByRadians:rotation_];
	transform_ = [transform transformStruct];
	[transform release];
	return transform_;

}



CGAffineTransform CS_CGAffineTransformScale(CGAffineTransform transform_ , CGFloat scaleX_, CGFloat scaleY)
{
	
 	NSAffineTransform * transform =[NSAffineTransform new];
	[transform setTransformStruct:transform_];
	[transform scaleXBy: scaleX_ yBy: scaleY];
	transform_ = [transform transformStruct];
	[transform release];
	return transform_;

}






 CGAffineTransform CS_CGAffineTransformConcat(CGAffineTransform a,CGAffineTransform b)
{
   	NSAffineTransform * transform =[NSAffineTransform new];
	[transform setTransformStruct:a];


	
	NSAffineTransform * transformb =[NSAffineTransform new];
	[transformb setTransformStruct:b];

	[transform appendTransform:transformb];
	a = [transform transformStruct];
	[transform release];
	[transformb release];

	return a;
	

   	

}

CGAffineTransform CS_CGAffineTransformInvert( CGAffineTransform inCGAffineTransform)
{
	
 	NSAffineTransform * transform =[NSAffineTransform new];
	[transform setTransformStruct:inCGAffineTransform];
	[transform invert];
	inCGAffineTransform = [transform transformStruct];
	[transform release];
	return inCGAffineTransform;

}


CGAffineTransform CS_CGAffineTransformMake(float a,float b,float c,float d,float tx,float ty)
{

	CGAffineTransform cGAffineTransform;
	
	NSAffineTransform * transform =[NSAffineTransform new];
	cGAffineTransform = [transform transformStruct];
	[transform release];
	cGAffineTransform.tX=tx;
	cGAffineTransform.tY=ty;
	
	cGAffineTransform.m11=a;
	cGAffineTransform.m12=b;
	cGAffineTransform.m21=c;
	cGAffineTransform.m22=d;
	
	
	return cGAffineTransform;


}


