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
		register("CELL_P0_SELECTED", MakeRect(0, 1));
		
		register("CELL_P1", MakeRect(1, 0));
		register("CELL_P1_SELECTED", MakeRect(1, 1));
		
		register("CELL_P2", MakeRect(2, 0));
		register("CELL_P2_SELECTED", MakeRect(2, 1));
		
		register("CELL_P3", MakeRect(3, 0));
		register("CELL_P3_SELECTED", MakeRect(3, 1));
		
		register("ENERGY_0", MakeRect(4, 0));
		register("ENERGY_1", MakeRect(4, 1));
		register("ENERGY_2", MakeRect(4, 2));
		register("ENERGY_3", MakeRect(4, 3));
		register("ENERGY_4", MakeRect(4, 4));
		register("ENERGY_5", MakeRect(4, 5));
		register("ENERGY_6", MakeRect(4, 6));
		register("ENERGY_7", MakeRect(4, 7));
		register("ENERGY_8", MakeRect(4, 8));
		register("ENERGY_9", MakeRect(4, 9));

		register("MILITARY_0", MakeRect(5, 0));
		register("MILITARY_1", MakeRect(5, 1));
		register("MILITARY_2", MakeRect(5, 2));
		register("MILITARY_3", MakeRect(5, 3));
		register("MILITARY_4", MakeRect(5, 4));
		register("MILITARY_5", MakeRect(5, 5));
		register("MILITARY_6", MakeRect(5, 6));
		register("MILITARY_7", MakeRect(5, 7));
		register("MILITARY_8", MakeRect(5, 8));
		register("MILITARY_9", MakeRect(5, 9));
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