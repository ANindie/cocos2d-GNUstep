/*
 * cocos2d for iPhone: http://www.cocos2d-iphone.org
 *
 * Copyright (c) 2009-2010 Ricardo Quesada
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
 *
 * TMX Tiled Map support:
 * http://www.mapeditor.org
 *
 */

/*
 * Internal TMX parser
 *
 * IMPORTANT: These classed should not be documented using doxygen strings
 * since the user should not use them.
 *
 */
 

enum {
	TMXLayerAttribNone = 1 << 0,
	TMXLayerAttribBase64 = 1 << 1,
	TMXLayerAttribGzip = 1 << 2,
};

enum {
	TMXPropertyNone,
	TMXPropertyMap,
	TMXPropertyLayer,
	TMXPropertyObjectGroup,
	TMXPropertyObject,
	TMXPropertyTile
};

/* CCTMXLayerInfo contains the information about the layers like:
 - Layer name
 - Layer size
 - Layer opacity at creation time (it can be modified at runtime)
 - Whether the layer is visible (if it's not visible, then the CocosNode won't be created)
 
 This information is obtained from the TMX file.
 */
@interface CCTMXLayerInfo : NSObject
{
	NSString			*name_;
	CGSize				layerSize_;
	unsigned int		*tiles_;
	BOOL				visible_;
	unsigned char		opacity_;
	BOOL				ownTiles_;
	unsigned int		minGID_;
	unsigned int		maxGID_;
	NSMutableDictionary	*properties_;
	CGPoint				offset_;
}

//@property (nonatomic,readwrite,retain)	NSString *name;
DeclareProperty_rw_rt_na(	NSString*,name,Name);
//@property (nonatomic,readwrite)			CGSize layerSize;
DeclareProperty_rw_as_na(CGSize,layerSize,LayerSize);
//@property (nonatomic,readwrite)			unsigned int *tiles;
DeclareProperty_rw_as_na(unsigned int*,tiles,Tiles);
//@property (nonatomic,readwrite)			BOOL visible;
DeclareProperty_rw_as_na(			BOOL,visible,Visible);
//@property (nonatomic,readwrite)			unsigned char opacity;
DeclareProperty_rw_as_na(			unsigned char,opacity,Opacity);
//@property (nonatomic,readwrite)			BOOL ownTiles;
DeclareProperty_rw_as_na(			BOOL,ownTiles,OwnTiles);
//@property (nonatomic,readwrite)			unsigned int minGID;
DeclareProperty_rw_as_na(			unsigned int,minGID,MinGID);
//@property (nonatomic,readwrite)			unsigned int maxGID;
DeclareProperty_rw_as_na(			unsigned int,maxGID,MaxGID);
//@property (nonatomic,readwrite,retain) NSMutableDictionary *properties;
DeclareProperty_rw_rt_na(NSMutableDictionary*,properties,Properties);
//@property (nonatomic,readwrite)			CGPoint offset;
DeclareProperty_rw_as_na(			CGPoint,offset,Offset);
@end

/* CCTMXTilesetInfo contains the information about the tilesets like:
 - Tileset name
 - Tilset spacing
 - Tileset margin
 - size of the tiles
 - Image used for the tiles
 - Image size
 
 This information is obtained from the TMX file. 
 */
@interface CCTMXTilesetInfo : NSObject
{
	NSString		*name_;
	unsigned int	firstGid_;
	CGSize			tileSize_;
	unsigned int	spacing_;
	unsigned int	margin_;
	
	// filename containing the tiles (should be spritesheet / texture atlas)
	NSString	*sourceImage_;
	
	// size in pixels of the image
	CGSize		imageSize_;
}
//@property (nonatomic,readwrite,retain) NSString *name;
DeclareProperty_rw_rt_na(NSString*,name,Name);
//@property (nonatomic,readwrite,assign) unsigned int firstGid;
DeclareProperty_rw_as_na(unsigned int,firstGid,FirstGid);
//@property (nonatomic,readwrite,assign) CGSize tileSize;
DeclareProperty_rw_as_na(CGSize,tileSize,TileSize);
//@property (nonatomic,readwrite,assign) unsigned int spacing;
DeclareProperty_rw_as_na(unsigned int,spacing,Spacing);
//@property (nonatomic,readwrite,assign) unsigned int margin;
DeclareProperty_rw_as_na(unsigned int,margin,Margin);
//@property (nonatomic,readwrite,retain) NSString *sourceImage;
DeclareProperty_rw_rt_na(NSString*,sourceImage,SourceImage);
//@property (nonatomic,readwrite,assign) CGSize imageSize;
DeclareProperty_rw_as_na(CGSize,imageSize,ImageSize);

-(CGRect) rectForGID:(unsigned int)gid;
@end

/* CCTMXMapInfo contains the information about the map like:
 - Map orientation (hexagonal, isometric or orthogonal)
 - Tile size
 - Map size
 
 And it also contains:
 - Layers (an array of TMXLayerInfo objects)
 - Tilesets (an array of TMXTilesetInfo objects)
 - ObjectGroups (an array of TMXObjectGroupInfo objects)
 
 This information is obtained from the TMX file.
 
 */
#ifdef __IPHONE_4_0
@interface CCTMXMapInfo : NSObject <NSXMLParserDelegate>
#else
@interface CCTMXMapInfo : NSObject
#endif
{	
	NSMutableString	*currentString;
    BOOL				storingCharacters;	
	int					layerAttribs;
	int					parentElement;
	unsigned int		parentGID_;

	
	// tmx filename
	NSString *filename_;

	// map orientation
	int	orientation_;	
	
	// map width & height
	CGSize	mapSize_;
	
	// tiles width & height
	CGSize	tileSize_;
	
	// Layers
	NSMutableArray *layers_;
	
	// tilesets
	NSMutableArray *tilesets_;
		
	// ObjectGroups
	NSMutableArray *objectGroups_;
	
	// properties
	NSMutableDictionary *properties_;
	
	// tile properties
	NSMutableDictionary *tileProperties_;
}

//@property (nonatomic,readwrite,assign) int orientation;
DeclareProperty_rw_as_na(int,orientation,Orientation);
//@property (nonatomic,readwrite,assign) CGSize mapSize;
DeclareProperty_rw_as_na(CGSize,mapSize,MapSize);
//@property (nonatomic,readwrite,assign) CGSize tileSize;
DeclareProperty_rw_as_na(CGSize,tileSize,TileSize);
//@property (nonatomic,readwrite,retain) NSMutableArray *layers;
DeclareProperty_rw_rt_na(NSMutableArray*,layers,Layers);
//@property (nonatomic,readwrite,retain) NSMutableArray *tilesets;
DeclareProperty_rw_rt_na(NSMutableArray*,tilesets,Tilesets);
//@property (nonatomic,readwrite,retain) NSString *filename;
DeclareProperty_rw_rt_na(NSString*,filename,Filename);
//@property (nonatomic,readwrite,retain) NSMutableArray *objectGroups;
DeclareProperty_rw_rt_na(NSMutableArray*,objectGroups,ObjectGroups);
//@property (nonatomic,readwrite,retain) NSMutableDictionary *properties;
DeclareProperty_rw_rt_na(NSMutableDictionary*,properties,Properties);
//@property (nonatomic,readwrite,retain) NSMutableDictionary *tileProperties;
DeclareProperty_rw_rt_na(NSMutableDictionary*,tileProperties,TileProperties);

/** creates a TMX Format with a tmx file */
+(id) formatWithTMXFile:(NSString*)tmxFile;
/** initializes a TMX format witha  tmx file */
-(id) initWithTMXFile:(NSString*)tmxFile;
@end


