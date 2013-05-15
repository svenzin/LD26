package ;

import library.Animation;
import library.Game;
import library.SpriteManager;
import nme.Assets;
import nme.display.Sprite;
import nme.display.StageAlign;
import nme.display.StageScaleMode;
import nme.events.Event;
import nme.Lib;

/**
 * ...
 * @author scorder
 */

class Main extends Sprite 
{
	private function init() 
	{
		addChild(new LD26());
	}
	
	/* SETUP */

	public static function main() 
	{
		Lib.current.addChild(new Main());
	}
	
	public function new() 
	{
		super();	
		addEventListener(Event.ADDED_TO_STAGE, construct);
	}
	
	private function construct(e : Event)
	{
		removeEventListener(Event.ADDED_TO_STAGE, construct);
		
		Lib.current.stage.align = nme.display.StageAlign.TOP_LEFT;
		Lib.current.stage.scaleMode = nme.display.StageScaleMode.NO_SCALE;
		
		stage.addEventListener(Event.RESIZE, resize);
		#if ios
		haxe.Timer.delay(init, 100); // iOS 6
		#else
		init();
		#end
	}
	
	private function resize(e : Event) { }
}
