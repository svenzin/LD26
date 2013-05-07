package ;

import library.SpriteManager;
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
		m_manager = new SpriteManager(Assets.getBitmapData("img/Tiles.png"), Global.CellSize);
		
		m_manager.Register("CELL_P0",       [ 0, 0 ] );
		m_manager.Register("CELL_SELECTED", [ 1, 0 ] );
		m_manager.Register("CELL_DISABLED", [ 2, 0 ] );
		
		m_manager.Register("CELL_P1",          [ 0, 1 ] );
		m_manager.Register("CELL_P1_SELECTED", [ 1, 1 ] );
		
		m_manager.Register("CELL_P2",          [ 0, 2 ] );
		m_manager.Register("CELL_P2_SELECTED", [ 1, 2 ] );
		
		m_manager.Register("CELL_P3",          [ 0, 3 ] );
		m_manager.Register("CELL_P3_SELECTED", [ 1, 3 ] );
		
		for (i in 0...10) m_manager.Register("MILITARY_"   + Std.string(i), [ i, 4 ] );
		for (i in 0...10) m_manager.Register("ENERGY_"     + Std.string(i), [ i, 5 ] );
		for (i in 0...10) m_manager.Register("PRODUCTION_" + Std.string(i), [ i, 6 ] );

		m_manager.Register(Global.EXPLORE, [ 0, 7 ] );
		m_manager.Register(Global.DEVELOP, [ 1, 7 ] );
		m_manager.Register(Global.SETTLE,  [ 2, 7 ] );
		m_manager.Register(Global.PRODUCE, [ 3, 7 ] );
		m_manager.Register(Global.UPKEEP,  [ 4, 7 ] );
		
		m_manager.Register(Global.GO,   [ 0, 8 ] );
		m_manager.Register(Global.PASS, [ 1, 8 ] );
		m_manager.Register(Global.DONE, [ 2, 8 ] );
		m_manager.Register(Global.EXIT, [ 3, 8 ] );
		
		m_manager.Register(Global.PHASE, [ 4, 8 ] );
		m_manager.Register(Global.BLUE,  [ 5, 8 ] );
		m_manager.Register(Global.GREEN, [ 6, 8 ] );
		m_manager.Register(Global.RED,   [ 7, 8 ] );
	}
	
	public function get(name : String) : Bitmap
	{
		return m_manager.Get(name);
	}

	var m_manager : SpriteManager;
}
