package library;
import haxe.Public;
import nme.display.Bitmap;
import nme.display.BitmapData;
import nme.geom.Point;
import nme.geom.Rectangle;

/**
 * @author scorder
 * 
 * Loads tiled sprites and animations
 */
private typedef SpriteDescriptor = { Size : Array<Int>, Area : Rectangle };
private typedef AnimationDescriptor = { Frames : Array<SpriteDescriptor> };
class SpriteManager
{

	public function new(source : BitmapData, tileSizeX : Int, ?tileSizeY : Int)
	{
		if (tileSizeY == null) tileSizeY = tileSizeX;
		init(source, tileSizeX, tileSizeY);
	}
	
	function init(source : BitmapData, tileSizeX : Int, tileSizeY : Int)
	{
		m_tileScale = [ tileSizeX, tileSizeY ];
		m_source = source;
		m_sprites = new Hash();
		m_animations = new Hash();
	}
	
	public function RegisterBitmap(name : String, tile : Array<Int>, ?size : Array<Int>)
	{
		if (size == null) size = [ 1, 1 ];
		
		//if (tile.length != 2) throw "SpriteManager.Register(" + name + ", " + tile.toString() + ", " + size.toString() + ") : tile is not 2D";
		//if (size.length != 2) throw "SpriteManager.Register(" + name + ", " + tile.toString() + ", " + size.toString() + ") : size is not 2D";
		if (tile.length != 2) throw "SpriteManager.Register(name, tile, size) : tile is not 2D";
		if (size.length != 2) throw "SpriteManager.Register(name, tile, size) : size is not 2D";
		
		m_sprites.set(name, { Size : [ size[0] * m_tileScale[0], size[1] * m_tileScale[1] ],
		                      Area : new Rectangle(tile[0] * m_tileScale[0], tile[1] * m_tileScale[1],
		                                           size[0] * m_tileScale[0], size[1] * m_tileScale[1]) } );
	}
	
	public function RegisterAnimation(name : String, tiles : Array<Array<Int>>, ?sizes : Array<Array<Int>>)
	{
		if (sizes == null) sizes = [ [ 1, 1 ] ];
		if (sizes.length == 1)
		{
			while (sizes.length < tiles.length)
			{
				sizes.push(sizes[0]);
			}
		}
		
		if (tiles.length == 0) throw "SpriteManager.Register(name, tiles, sizes) : tiles is empty";
		for (tile in tiles) if (tile.length != 2) throw "SpriteManager.Register(name, tiles, sizes) : tile is not 2D";
		
		if (sizes.length != tiles.length) throw "SpriteManager.Register(name, tiles, sizes) : sizes.length does not match tiles.length";
		for (size in sizes) if (size.length != 2) throw "SpriteManager.Register(name, tiles, sizes) : size is not 2D";
		
		var descriptors : Array<SpriteDescriptor> = new Array();
		for (index in 0...tiles.length)
		{
			var descriptor : SpriteDescriptor = { Size : [ sizes[index][0] * m_tileScale[0], sizes[index][1] * m_tileScale[1] ],
			                                      Area : new Rectangle(tiles[index][0] * m_tileScale[0], tiles[index][1] * m_tileScale[1],
		                                                               sizes[index][0] * m_tileScale[0], sizes[index][1] * m_tileScale[1]) };
			descriptors.push(descriptor);
		}
		
		m_animations.set(name, { Frames : descriptors } );
	}
	
	function CreateBitmap(descriptor : SpriteDescriptor) : Bitmap
	{
		var data = new BitmapData(descriptor.Size[0], descriptor.Size[1]);
		data.copyPixels(m_source, descriptor.Area, new Point());
		
		return new Bitmap(data);
	}
	
	public function GetBitmap(name : String) : Bitmap
	{
		if (!m_sprites.exists(name)) throw "SpriteManager.GetBitmap(name) : Bitmap name does not exist";
		
		var descriptor = m_sprites.get(name);
		
		return CreateBitmap(descriptor);
	}
	
	public function GetAnimation(name : String) : Animation
	{
		if (!m_animations.exists(name)) throw "SpriteManager.GetAnimation(name) : Animation name does not exist";
		
		var descriptors = m_animations.get(name);
		
		var frames : Array<Bitmap> = new Array();
		for (descriptor in descriptors.Frames)
		{
			frames.push(CreateBitmap(descriptor));
		}
		
		return new Animation(frames);
	}
	
	var m_source : BitmapData;
	var m_tileScale : Array<Int>;
	var m_sprites : Hash<SpriteDescriptor>;
	var m_animations : Hash<AnimationDescriptor>;
}