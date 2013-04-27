package ;
import flash.display.Sprite;
import nme.display.Bitmap;
import nme.events.Event;
import nme.events.MouseEvent;

/**
 * ...
 * @author scorder
 */
class Button extends Sprite
{

	public function new(name : String) 
	{
		super();
		
		m_bitmap = Main.MainBitmaps.get(name);
		addChild(m_bitmap);
		
		m_inactive = Main.MainBitmaps.get("CELL_DISABLED");
		m_inactive.alpha = 0.5;
		addChild(m_inactive);
		
		Name = name;
		setActive(true);
		
		addEventListener(MouseEvent.CLICK, OnClick);
	}
	
	function OnClick(event : MouseEvent)
	{
		event.stopImmediatePropagation();
		
		if (Active) dispatchEvent(new Event(Name, true));
	}
	
	public var Name : String;
	var Active : Bool;
	public function getActive() : Bool { return Active; }
	public function setActive(active : Bool) { Active = active;  m_inactive.visible = !Active; }
	
	var m_inactive : Bitmap;
	var m_bitmap : Bitmap;
}