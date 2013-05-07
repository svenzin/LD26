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
	}
	
	public function Register(name : String, tile : Array<Int>, ?size : Array<Int>)
	{
		if (size == null) size = [ 1, 1 ];
		
		if (tile.length != 2) throw "SpriteManager.Register(" + name + ", " + tile.toString() + ", " + size.toString() + ") : tile is not 2D";
		if (size.length != 2) throw "SpriteManager.Register(" + name + ", " + tile.toString() + ", " + size.toString() + ") : size is not 2D";
		
		m_sprites.set(name, { Size : [ size[0] * m_tileScale[0], size[1] * m_tileScale[1] ],
		                      Area : new Rectangle(tile[0] * m_tileScale[0], tile[1] * m_tileScale[1],
		                                           size[0] * m_tileScale[0], size[1] * m_tileScale[1]) } );
	}
	
	public function Get(name : String) : Bitmap
	{
		if (!m_sprites.exists(name)) throw "SpriteManager.Get(" + name + ") : Sprite name does not exist";
		
		var descriptor = m_sprites.get(name);
		
		var data = new BitmapData(descriptor.Size[0], descriptor.Size[1]);
		data.copyPixels(m_source, descriptor.Area, new Point());
		
		return new Bitmap(data);
	}
	
	var m_source : BitmapData;
	var m_tileScale : Array<Int>;
	var m_sprites : Hash<SpriteDescriptor>;
}