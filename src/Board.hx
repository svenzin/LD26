package ;
import nme.display.Sprite;
import nme.events.Event;
import nme.events.MouseEvent;

/**
 * ...
 * @author scorder
 */
class Board extends Sprite
{

	public function new() 
	{
		super();
		
		m_cellSizeX = Global.CellSize;
		m_cellSizeY = Global.CellSize;
	}
	
	public function toX(screenX : Float) : Int { return Math.floor(screenX / m_cellSizeX); }
	public function toY(screenY : Float) : Int { return Math.floor(screenY / m_cellSizeY); }

	public function neighbours(cell : Cell) : Array<Cell>
	{
		var cells : Array<Cell> = new Array();
		
		var x = toX(cell.x);
		var y = toY(cell.y);
		//Main.MainConsole.Log("x(" + Std.string(cell.x) + ") to " + Std.string(x) + " y(" + Std.string(cell.y) + ") to " + Std.string(y));
		
		if (x > 0)         cells.push(at(x - 1, y));
		if (x < SizeX - 1) cells.push(at(x + 1, y));
		if (y > 0)         cells.push(at(x, y - 1));
		if (y < SizeY - 1) cells.push(at(x, y + 1));
		
		return cells;
	}
	
	public function at(x : Int, y : Int) : Cell
	{
		var index : Int = SizeY * x + y;
		return Cells[index];
	}
	
	public function generate(sizeX : Int, sizeY : Int)
	{
		SizeX = sizeX;
		SizeY = sizeY;
		
		Cells = new Array();
		for (i in new IntIter(0, SizeX * SizeY))
		{
			var current = new Cell();
			Cells.push(current);
			addChild(current);
		}
		
		for (ix in new IntIter(0, SizeX))
		{
			for (iy in new IntIter(0, SizeY))
			{
				var current = at(ix, iy);
				current.x = ix * m_cellSizeX;
				current.y = iy * m_cellSizeY;
				
				current.Player = Global.NOBODY;
				current.Energy = Std.random(10);
				current.Military = Std.random(10);
				
				current.Update();
			}
		}
	}

	public var Cells : Array<Cell>;
	
	var m_cellSizeX : Int;
	var m_cellSizeY : Int;
	
	public var SizeX : Int;
	public var SizeY : Int;
}