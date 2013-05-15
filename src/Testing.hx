package ;
import library.World;
import nme.display.Bitmap;
import nme.display.Sprite;
import nme.Assets;
import nme.events.KeyboardEvent;
import nme.ui.Keyboard;

/**
 * ...
 * @author scorder
 */
class Testing extends World
{

	public static var Bitmaps : BitmapManager;
	public static var Sounds : SoundsManager;

	public function new() 
	{
		super();
		Bitmaps = new BitmapManager();
		Sounds = new SoundsManager();
	}

	public override function initialize()
	{
		super.initialize();
		trace("Initialized");
	}
	
	public override function update()
	{
		super.update();
		trace("Updated");
	}
	
	public override function resize()
	{
		super.resize();
		trace("Resized");
	}
	
	public override function destroy()
	{
		super.destroy();
		trace("Destroyed");
	}

}