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
		
		var x = cell.BoardX;
		var y = cell.BoardY;
		//LD26.MainConsole.Log("x(" + Std.string(cell.x) + ") to " + Std.string(x) + " y(" + Std.string(cell.y) + ") to " + Std.string(y));
		
		if (x > 0)         cells.push(at(x - 1, y));
		if (x < SizeX - 1) cells.push(at(x + 1, y));
		
		if (y > 0)         cells.push(at(x, y - 1));
		if (y < SizeY - 1) cells.push(at(x, y + 1));
		
		if (y % 2 == 0)
		{
			if ((x > 0) && (y > 0))         cells.push(at(x - 1, y - 1));
			if ((x > 0) && (y < SizeY - 1)) cells.push(at(x - 1, y + 1));
		}
		else
		{
			if ((x < SizeX - 1) && (y > 0))         cells.push(at(x + 1, y - 1));
			if ((x < SizeX - 1) && (y < SizeY - 1)) cells.push(at(x + 1, y + 1));
		}
		
		return cells;
	}
	
	public function at(x : Int, y : Int) : Cell
	{
		var index : Int = SizeY * x + y;
		return Cells[index];
	}
	
	var availableValues : Array<Int>;
	function target() : Int
	{
		var targetValue : Float = 0.0;
		for (i in 0...Global.DICE_COUNT) targetValue += Math.random() - Global.DICE_OFFSET;
		targetValue = targetValue * (Global.MAX_STARTER_VALUE - Global.MIN_STARTER_VALUE) / Global.DICE_COUNT + Global.MIN_STARTER_VALUE;
		//trace(targetValue);
		var result : Int = 0;
		for (value in availableValues)
		{
			if (value <= targetValue) result = value;
		}
		//trace(result);
		return result;
	}
	public function sort(x : Int, y : Int) : Int { return x - y; }
	public function generate(sizeX : Int, sizeY : Int)
	{
		SizeX = sizeX;
		SizeY = sizeY;
		
		availableValues = Cell.ExistingValues();
		availableValues.sort(sort);
		//trace(availableValues);
		//return;
		Cells = new Array();
		for (ix in new IntIter(0, SizeX))
		{
			for (iy in new IntIter(0, SizeY))
			{
				var current = new Cell();
				Cells.push(current);
				addChild(current);
				
				if (iy % 2 == 0) current.x = ix * m_cellSizeX;
				else             current.x = (ix + 0.5) * m_cellSizeX;
				current.y = iy * m_cellSizeY;
				
				current.BoardX = ix;
				current.BoardY = iy;
				
				var target = target();
				while (current.Value() != target) current.Randomize();
				current.Player = Global.NOBODY;
			}
		}
	}

	public var Cells : Array<Cell>;
	
	var m_cellSizeX : Int;
	var m_cellSizeY : Int;
	
	public var SizeX : Int;
	public var SizeY : Int;
}