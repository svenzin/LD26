package ;
import nme.display.Bitmap;
import nme.display.Sprite;
import nme.Assets;
import nme.events.KeyboardEvent;
import nme.ui.Keyboard;

/**
 * ...
 * @author scorder
 */
class MainMenu extends Sprite
{

	public function new() 
	{
		super();
		
		m_title = new Bitmap(Assets.getBitmapData("img/MainBackground.png"));
		DisplayMenu();
		
		addEventListener(KeyboardEvent.KEY_DOWN, OnKey);
	}
	
	function OnKey(event : KeyboardEvent)
	{
		switch (event.keyCode)
		{
			case Keyboard.ENTER: Main.Start(new Game());
		}
	}
	
	function Clear()
	{
		while (numChildren > 0)
		{
			removeChildAt(0);
		}
	}
	function DisplayMenu()
	{
		Clear();
		addChild(m_title);
	}
	
	function DisplayInstructions()
	{
		Clear();
	}
	
	var m_title : Bitmap;
	var m_instructions : Bitmap;
}