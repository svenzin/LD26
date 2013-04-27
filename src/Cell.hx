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

	public function new() 
	{
		super();
		
		m_display = new Sprite();
		addChild(m_display);
		
		if (Global.Debug) Debug();
	}
	
	function Debug()
	{
		this.graphics.lineStyle(1, Colors.Green);
		this.graphics.drawRect(0, 0, Global.CellSize - 1, Global.CellSize - 1);
	}
	
	public function Update()
	{
		while (m_display.numChildren > 0)
		{
			m_display.removeChildAt(0);
		}
		
		switch (Player.Id)
		{
			case 0: m_display.addChild(Main.MainBitmaps.get("CELL_P0"));
			case 1: m_display.addChild(Main.MainBitmaps.get("CELL_P1"));
			case 2: m_display.addChild(Main.MainBitmaps.get("CELL_P2"));
			case 3: m_display.addChild(Main.MainBitmaps.get("CELL_P3"));
		}
		
		if (Selected) m_display.addChild(Main.MainBitmaps.get("CELL_SELECTED"));
		if (!Active)
		{
			var bitmap = Main.MainBitmaps.get("CELL_DISABLED");
			bitmap.alpha = 0.5;
			m_display.addChild(bitmap);
		}

		if (Visible)
		{
			m_display.addChild(Main.MainBitmaps.get("ENERGY_" + Std.string(Energy)));
			m_display.addChild(Main.MainBitmaps.get("MILITARY_" + Std.string(Military)));
			m_display.addChild(Main.MainBitmaps.get("PRODUCTION_" + Std.string(Production)));
		}
	}
	
	var m_display : Sprite;
	
	public var Player : Player;
	public var Energy : Int;
	public var Military : Int;
	public var Production : Int;
	
	public var Visible : Bool = false;
	public var Selected : Bool = false;
	public var Active : Bool = true;
}