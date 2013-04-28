package ;

import nme.display.Sprite;
import nme.events.Event;
import nme.Lib;

/**
 * ...
 * @author scorder
 */

class Main extends Sprite 
{
	var inited:Bool;

	public static var MainConsole : Console;
	public static var MainBitmaps : BitmapManager;
	public static var MainSounds : SoundsManager;
	public static var MainBoard : Board;
	public static var MainGui : GUI;
	public static var MainRules : Rules;

	/* ENTRY POINT */
	
	function resize(e) 
	{
		if (!inited) init();
		// else (resize or orientation change)
	}
	
	function init() 
	{
		if (inited) return;
		inited = true;
		
		MainBitmaps = new BitmapManager();
		MainSounds = new SoundsManager();
		
		MainBoard = new Board();
		addChild(MainBoard);
		MainBoard.generate(8, 8);
		
		MainGui = new GUI();
		addChild(MainGui);
		
		MainConsole = new Console();
		addChild(MainConsole);
		
		MainRules = new Rules();
		MainRules.start();
		
		// (your code here)
		//
		addEventListener(Event.ENTER_FRAME, loop);
		
		// Stage:
		// stage.stageWidth x stage.stageHeight @ stage.dpiScale
		
		// Assets:
		// nme.Assets.getBitmapData("img/assetname.jpg");
	}
	
	/* SETUP */

	public function new() 
	{
		super();	
		addEventListener(Event.ADDED_TO_STAGE, added);
	}
	
	function loop(event : Event)
	{
		MainRules.SingleLoop();
	}

	function added(e)
	{
		removeEventListener(Event.ADDED_TO_STAGE, added);
		stage.addEventListener(Event.RESIZE, resize);
		#if ios
		haxe.Timer.delay(init, 100); // iOS 6
		#else
		init();
		#end
	}
	
	public static function main() 
	{
		// static entry point
		Lib.current.stage.align = nme.display.StageAlign.TOP_LEFT;
		Lib.current.stage.scaleMode = nme.display.StageScaleMode.NO_SCALE;
		Lib.current.addChild(new Main());
	}
}
