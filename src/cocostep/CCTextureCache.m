#import<CocosStepPrefix.h>
/*
 * cocos2d for iPhone: http://www.cocos2d-iphone.org
 *
 * Copyright (c) 2008-2010 Ricardo Quesada
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 *
 */

#import "CCTextureCache.h"
#import "ccMacros.h"
#import "CCDirector.h"
#import "CCTexture2D.h"
#import "Support/CCFileUtils.h"

static NSOpenGLContext *auxEAGLcontext = nil;

@interface CCAsyncObject : NSObject
{
	SEL			selector_;
	id			target_;
	id			data_;
}
//@property	(readwrite,assign)	SEL			selector;
DeclareProperty_rw_as_at(	SEL,selector,Selector);
//@property	(readwrite,retain)	id			target;
DeclareProperty_rw_rt_at(	id,target,Target);
//@property	(readwrite,retain)	id			data;
DeclareProperty_rw_rt_at(	id,data,Data);
@end

@implementation CCAsyncObject 
//@synthesize selector = selector_;
//@synthesize target = target_;
DefineProperty_ro_as_na(id,target,Target,target_);
//@synthesize data = data_;
- (void) dealloc
{
	CCLOGINFO(@"cocos2d: deallocing %@", self);
	[target_ release];
	[data_ release];
	[super dealloc];
}
@end



@implementation CCTextureCache

static CCTextureCache *sharedTextureCache;

+ (CCTextureCache *)sharedTextureCache
{
	if (!sharedTextureCache)
		sharedTextureCache = [[CCTextureCache alloc] init];
		
	return sharedTextureCache;
}

+(id)alloc
{
	NSAssert(sharedTextureCache == nil, @"Attempted to allocate a second instance of a singleton.");
	return [super alloc];
}

+(void)purgeSharedTextureCache
{
	[sharedTextureCache release];
}

-(id) init
{
	if( (self=[super init]) ) {
		textures = [[NSMutableDictionary dictionaryWithCapacity: 10] retain];
		dictLock = [[NSLock alloc] init];
		contextLock = [[NSLock alloc] init];
	}

	return self;
}

- (NSString*) description
{
	return [NSString stringWithFormat:@"<%@ = %08X | num of textures =  %i>", [self class], self, [textures count]];
}

-(void) dealloc
{
	CCLOG(@"cocos2d: deallocing %@", self);

	[textures release];
	[dictLock release];
	[contextLock release];
	[auxEAGLcontext release];
	auxEAGLcontext = nil;
	sharedTextureCache = nil;
	[super dealloc];
}


-(void) addImageWithAsyncObject:(CCAsyncObject*)async
{
	NSAutoreleasePool *autoreleasepool = [[NSAutoreleasePool alloc] init];
	
	// textures will be created on the main OpenGL context
	// it seems that in SDK 2.2.x there can't be 2 threads creating textures at the same time
	// the lock is used for this purpose: issue #472
	[contextLock lock];
#if IPHONE	
	if( auxEAGLcontext == nil ) {
		auxEAGLcontext = [[NSOpenglContext alloc]
							   initWithAPI:kEAGLRenderingAPIOpenGLES1
							   sharegroup:[[[[CCDirector sharedDirector] openGLView] context] sharegroup]];
		
		if( ! auxEAGLcontext )
			CCLOG(@"cocos2d: TextureCache: Could not create EAGL context");
	}
	
	if( [EAGLContext setCurrentContext:auxEAGLcontext] ) {

		// load / create the texture
		CCTexture2D *tex = [self addImage:[async data]];

		// The callback will be executed on the main thread
		[[async target] performSelectorOnMainThread:[async selector] withObject:tex waitUntilDone:NO];
		
		[EAGLContext setCurrentContext:nil];
	} else {
		CCLOG(@"cocos2d: TetureCache: EAGLContext error");
	}
	[contextLock unlock];
	
	[autoreleasepool release];
#endif	
}


-(void) addImageAsync: (NSString*) filename target:(id)target selector:(SEL)selector
{
	NSAssert(filename != nil, @"TextureCache: fileimage MUST not be nill");

	// optimization
	
	CCTexture2D * tex;
	
	if( (tex=[textures objectForKey: filename] ) ) {
		[target performSelector:selector withObject:tex];
		return;
	}

	// schedule the load
	
	CCAsyncObject *asyncObject = [[CCAsyncObject alloc] init];
	[asyncObject setSelector: selector];
	[asyncObject setTarget: target];
	[asyncObject setData: filename];
	
	[NSThread detachNewThreadSelector:@selector(addImageWithAsyncObject:) toTarget:self withObject:asyncObject];
	[asyncObject release];
}

-(CCTexture2D*) addImage: (NSString*) path
{
	NSAssert(path != nil, @"TextureCache: fileimage MUST not be nill");

	CCTexture2D * tex = nil;

	// MUTEX:
	// Needed since addImageAsync calls this method from a different thread
	[dictLock lock];
	
	tex=[textures objectForKey: path];
	
	if( ! tex ) {
		
		// Split up directory and filename
		//NSLog(@" path %@ ",path);
		NSString *fullpath = [CCFileUtils fullPathFromRelativePath: path ];
		//NSLog(@" full path %@ ",fullpath);
		// all images are handled by UIImage except PVR extension that is handled by our own handler
		if ( [[path lowercaseString] hasSuffix:@".pvr"] )
			tex = [self addPVRTCImage:fullpath];
		else {

			// prevents overloading the autorelease pool
			UIImage *image = [ [UIImage alloc] initWithContentsOfFile: fullpath ];
			tex = [ [CCTexture2D alloc] initWithImage: image ];
			[image release];
			

			if( tex )
				[textures setObject: tex forKey:path];
			else
				CCLOG(@"cocos2d: Couldn't add image:%@ in CCTextureCache", path);

			
			[tex release];
		}
	}
	
	[dictLock unlock];
	
	return tex;
}

#if UNSUPPORTED
-(CCTexture2D*) addPVRTCImage: (NSString*) path bpp:(int)bpp hasAlpha:(BOOL)alpha width:(int)w
{
	NSAssert(path != nil, @"TextureCache: fileimage MUST not be nill");
	NSAssert( bpp==2 || bpp==4, @"TextureCache: bpp must be either 2 or 4");
	
	CCTexture2D * tex;
	
	if( (tex=[textures objectForKey: path] ) ) {
		return tex;
	}
	
	// Split up directory and filename
	NSString *fullpath = [CCFileUtils fullPathFromRelativePath:path];
	
	NSData *nsdata = [[NSData alloc] initWithContentsOfFile:fullpath];
	tex = [[CCTexture2D alloc] initWithPVRTCData:[nsdata bytes] level:0 bpp:bpp hasAlpha:alpha length:w];
	if( tex )
		[textures setObject: tex forKey:path];
	else
		CCLOG(@"cocos2d: Couldn't add PVRTCImage:%@ in CCTextureCache",path);

	[nsdata release];

	return [tex autorelease];
}

-(CCTexture2D*) addPVRTCImage: (NSString*) fileimage
{
	NSAssert(fileimage != nil, @"TextureCache: fileimage MUST not be nill");

	CCTexture2D * tex;
	
	if( (tex=[textures objectForKey: fileimage] ) ) {
		return tex;
	}
	
	tex = [[CCTexture2D alloc] initWithPVRTCFile: fileimage];
	if( tex )
		[textures setObject: tex forKey:fileimage];
	else
		CCLOG(@"cocos2d: Couldn't add PVRTCImage:%@ in CCTextureCache",fileimage);	
	
	return [tex autorelease];
}



-(CCTexture2D*) addCGImage: (CGImageRef) imageref forKey: (NSString *)key
{
	NSAssert(imageref != nil, @"TextureCache: image MUST not be nill");
	
	CCTexture2D * tex = nil;
	
	// If key is nil, then create a new texture each time
	if( key && (tex=[textures objectForKey: key] ) ) {
		return tex;
	}
	
	// prevents overloading the autorelease pool
	UIImage *image = [[UIImage alloc] initWithCGImage:imageref];
	tex = [[CCTexture2D alloc] initWithImage: image];
	[image release];
	
	if(tex && key)
		[textures setObject: tex forKey:key];
	else
		CCLOG(@"cocos2d: Couldn't add CGImage in CCTextureCache");
	
	return [tex autorelease];
}

#endif
-(void) removeAllTextures
{
	[textures removeAllObjects];
}

-(void) removeUnusedTextures
{
	NSArray *keys = [textures allKeys];
	FORIN( id, key, keys ) {
		id value = [textures objectForKey:key];		
		if( [value retainCount] == 1 ) {
			CCLOG(@"cocos2d: CCTextureCache: removing unused texture: %@", key);
			[textures removeObjectForKey:key];
		}
	}
}

-(void) removeTexture: (CCTexture2D*) tex
{
	if( ! tex )
		return;
	
	NSArray *keys = [textures allKeysForObject:tex];
	NSUInteger i;
	for( i = 0; i < [keys count]; i++ )
		[textures removeObjectForKey:[keys objectAtIndex:i]];
}
@end
