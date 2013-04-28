package ;

import nme.display.Bitmap;
import nme.display.BitmapData;
import nme.Assets;
import nme.geom.Point;
import nme.geom.Rectangle;

/**
 * ...
 * @author scorder
 */
class BitmapManager
{

	public function new() 
	{
		m_data = Assets.getBitmapData("img/Tiles.png");
		m_tiles = new Hash();
		
		register("CELL_P0", MakeRect(0, 0));
		register("CELL_SELECTED", MakeRect(0, 1));
		register("CELL_DISABLED", MakeRect(0, 2));
		
		register("CELL_P1", MakeRect(1, 0));
		register("CELL_P1_SELECTED", MakeRect(1, 1));
		
		register("CELL_P2", MakeRect(2, 0));
		register("CELL_P2_SELECTED", MakeRect(2, 1));
		
		register("CELL_P3", MakeRect(3, 0));
		register("CELL_P3_SELECTED", MakeRect(3, 1));
		
		for (i in 0...10) register("MILITARY_" + Std.string(i), MakeRect(4, i));
		for (i in 0...10) register("ENERGY_" + Std.string(i), MakeRect(5, i));
		for (i in 0...10) register("PRODUCTION_" + Std.string(i), MakeRect(6, i));

		register(Global.EXPLORE, MakeRect(7, 0));
		register(Global.DEVELOP, MakeRect(7, 1));
		register(Global.SETTLE,  MakeRect(7, 2));
		register(Global.PRODUCE, MakeRect(7, 3));
		register(Global.UPKEEP,  MakeRect(7, 4));
		
		register(Global.GO,   MakeRect(8, 0));
		register(Global.PASS, MakeRect(8, 1));
		register(Global.DONE, MakeRect(8, 2));
		register(Global.EXIT, MakeRect(8, 3));
		
		register(Global.PHASE, MakeRect(8, 4));
		register(Global.BLUE,  MakeRect(8, 5));
		register(Global.GREEN, MakeRect(8, 6));
		register(Global.RED,   MakeRect(8, 7));
	}
	
	function MakeRect(line : Int, column : Int) : Rectangle
	{
		return new Rectangle(column * Global.CellSize, line * Global.CellSize, Global.CellSize, Global.CellSize);
	}
	
	public function register(name : String, area : Rectangle)
	{
		m_tiles.set(name, area);
	}
	
	public function get(name : String) : Bitmap
	{
		var area = m_tiles.get(name);
		var data = new BitmapData(Math.ceil(area.width), Math.ceil(area.height));
		data.copyPixels(m_data, area, new Point());
		
		return new Bitmap(data);
	}

	var m_data : BitmapData;
	var m_tiles : Hash<Rectangle>;
}
