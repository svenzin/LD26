package ;
import nme.display.Bitmap;
import nme.display.Sprite;
import nme.Assets;
import nme.events.Event;
import nme.events.MouseEvent;
import nme.ObjectHash;

/**
 * ...
 * @author scorder
 */
class Visibility
{
	public function new()
	{
		players = new List();
	}
	
	public function Empty() : Bool
	{
		return players.isEmpty();
	}
	
	public function Check(player : Player) : Bool
	{
		var visible = false;
		for (p in players) visible = visible || (p == player);
		return visible;
	}
	
	public function Add(player : Player)
	{
		if (!Check(player)) players.add(player);
	}
	
	public function Remove(player : Player)
	{
		if (Check(player)) players.remove(Player);
	}
	
	var players : List<Player>;
}

class Cell extends Sprite
{

	public function new() 
	{
		super();
		
		m_display = new Sprite();
		addChild(m_display);
		
		Visible = new Visibility();
		
		if (Global.Debug) Debug();
	}
	
	function Debug()
	{
		this.graphics.lineStyle(1, Colors.Green);
		this.graphics.drawRect(0, 0, Global.CellSize - 1, Global.CellSize - 1);
	}
	
	public function Update(player : Player)
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
			bitmap.alpha = 0.25;
			m_display.addChild(bitmap);
		}

		if (Visible.Check(player))
		//if (!Visible.Empty())
		{
			m_display.addChild(Main.MainBitmaps.get("ENERGY_" + Std.string(Energy)));
			m_display.addChild(Main.MainBitmaps.get("PRODUCTION_" + Std.string(Production)));
		}
	}
	
	public function Randomize()
	{
		Energy = Std.random(Global.MAX_ENERGY + 1);
		Production = Std.random(Global.MAX_PRODUCTION + 1);
	}
	public static function ExistingValues() : Array<Int>
	{
		var result : Array<Int> = new Array();
		var cell  = new Cell();
		for (e in 0...(Global.MAX_ENERGY + 1))
		{
			for (p in 0...(Global.MAX_PRODUCTION + 1))
			{
				cell.Energy = e;
				cell.Production = p;
				result.push(cell.Value());
			}
		}
		//trace(result);
		return result;
	}
	static function Sum(i : Int) : Int
	{
		var result = 0;
		for (value in 1...(i + 1)) result += value;
		return result;
	}
	public function Value() : Int
	{
		return Sum(Energy) + 4 * Sum(Production) * (Math.floor(Energy / 2.0) + 1);
	}
	
	var m_display : Sprite;
	
	public var Player : Player;
	public var Energy : Int;
	public var Production : Int;
	
	public var Visible : Visibility;
	public var Selected : Bool = false;
	public var Active : Bool = true;
	
	public var BoardX : Int;
	public var BoardY : Int;
}