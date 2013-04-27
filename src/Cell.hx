package ;
import nme.display.Bitmap;
import nme.display.Sprite;
import nme.Assets;
import nme.events.Event;
import nme.events.MouseEvent;


/**
 * ...
 * @author scorder
 */
class Cell extends Sprite
{

	public function new(x : Int, y : Int) 
	{
		super();
		
		m_idX = x;
		m_idY = y;
		
		m_display = new Sprite();
		addChild(m_display);
		
		if (Global.Debug) Debug();
	}
	
	function Debug()
	{
		this.graphics.lineStyle(1, Colors.Green);
		this.graphics.drawRect(0, 0, Global.CellSize - 1, Global.CellSize - 1);
	}
	
	public function SetTile()
	{
		while (m_display.numChildren > 0)
		{
			m_display.removeChildAt(0);
		}
		
		switch (Player)
		{
			case 0: m_display.addChild(Main.MainBitmaps.get("CELL_P0"));
			case 1: m_display.addChild(Main.MainBitmaps.get("CELL_P1"));
			case 2: m_display.addChild(Main.MainBitmaps.get("CELL_P2"));
			case 3: m_display.addChild(Main.MainBitmaps.get("CELL_P3"));
		}
		
		if (Selected) m_display.addChild(Main.MainBitmaps.get("CELL_P0_SELECTED"));

		switch (Energy)
		{
			case 0: m_display.addChild(Main.MainBitmaps.get("ENERGY_0"));
			case 1: m_display.addChild(Main.MainBitmaps.get("ENERGY_1"));
			case 2: m_display.addChild(Main.MainBitmaps.get("ENERGY_2"));
			case 3: m_display.addChild(Main.MainBitmaps.get("ENERGY_3"));
			case 4: m_display.addChild(Main.MainBitmaps.get("ENERGY_4"));
			case 5: m_display.addChild(Main.MainBitmaps.get("ENERGY_5"));
			case 6: m_display.addChild(Main.MainBitmaps.get("ENERGY_6"));
			case 7: m_display.addChild(Main.MainBitmaps.get("ENERGY_7"));
			case 8: m_display.addChild(Main.MainBitmaps.get("ENERGY_8"));
			case 9: m_display.addChild(Main.MainBitmaps.get("ENERGY_9"));
		}

		switch (Military)
		{
			case 0: m_display.addChild(Main.MainBitmaps.get("MILITARY_0"));
			case 1: m_display.addChild(Main.MainBitmaps.get("MILITARY_1"));
			case 2: m_display.addChild(Main.MainBitmaps.get("MILITARY_2"));
			case 3: m_display.addChild(Main.MainBitmaps.get("MILITARY_3"));
			case 4: m_display.addChild(Main.MainBitmaps.get("MILITARY_4"));
			case 5: m_display.addChild(Main.MainBitmaps.get("MILITARY_5"));
			case 6: m_display.addChild(Main.MainBitmaps.get("MILITARY_6"));
			case 7: m_display.addChild(Main.MainBitmaps.get("MILITARY_7"));
			case 8: m_display.addChild(Main.MainBitmaps.get("MILITARY_8"));
			case 9: m_display.addChild(Main.MainBitmaps.get("MILITARY_9"));
		}
	}
	
	var m_idX : Int;
	var m_idY : Int;
	
	var m_display : Sprite;
	
	public var Player : Int;
	public var Energy : Int;
	public var Military : Int;
	public var Selected : Bool = false;
}