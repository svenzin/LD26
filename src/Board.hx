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

	public function new(sizeX : Int, sizeY : Int) 
	{
		super();
		
		m_cellSizeX = Global.CellSize;
		m_cellSizeY = Global.CellSize;
		
		m_sizeX = sizeX;
		m_sizeY = sizeY;
		
		generate();
		
		addEventListener(MouseEvent.CLICK, OnClick);
	}
	
	function OnClick(event : MouseEvent)
	{
		//event.
	}
	
	function generate()
	{
		for (ix in new IntIter(0, m_sizeX))
		{
			for (iy in new IntIter(0, m_sizeY))
			{
				var newCell = new Cell(ix, iy);
				newCell.x = ix * m_cellSizeX;
				newCell.y = iy * m_cellSizeY;
				
				newCell.Player = Std.random(4);
				newCell.Energy = Std.random(10);
				newCell.Military = Std.random(10);
				
				addChild(newCell);
				newCell.SetTile();
			}
		}
	}

	var m_cellSizeX : Int;
	var m_cellSizeY : Int;
	
	var m_sizeX : Int;
	var m_sizeY : Int;
}