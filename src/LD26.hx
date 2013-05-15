package ;

import library.Animation;
import library.Game;
import library.SpriteManager;
import nme.Assets;
import nme.events.Event;

/**
 * ...
 * @author scorder
 */

class LD26 extends Game
{
	public static var MainConsole : Console;
	public static var MainBitmaps : BitmapManager;
	public static var MainSounds : SoundsManager;
	public static var MainBoard : Board;
	public static var MainGui : GUI;
	public static var MainRules : Rules;
	
	public function new()
	{
		super();
		init();
	}
	
	var font : SpriteManager;
	var letters : Animation;
	private override function init() 
	{
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
		
		font = new SpriteManager(Assets.getBitmapData("img/font.png"), 8);
		font.RegisterAnimation("letters", [ [01, 1], [02, 1], [03, 1], [04, 1], [05, 1], [06, 1], [07, 1], [08, 1], [09, 1], [10, 1], [11, 1], [12, 1], [13, 1],
		                                    [14, 1], [15, 1], [16, 1], [17, 1], [18, 1], [19, 1], [20, 1], [21, 1], [22, 1], [23, 1], [24, 1], [25, 1], [26, 1] ]);
		letters = font.GetAnimation("letters");
		letters.x = 0;
		letters.y = 0;
		letters.scaleX = 8;
		letters.scaleY = 8;
		addChild(letters);
		 //(your code here)
		
		addEventListener(Event.ENTER_FRAME, loop);
		
		 //Stage:
		 //stage.stageWidth x stage.stageHeight @ stage.dpiScale
		
		 //Assets:
		 //nme.Assets.getBitmapData("img/assetname.jpg");
	}
	var newFrame : Int = 0;
	function loop(event : Event)
	{
		newFrame = (newFrame + 1) % (4 * letters.Length);
		letters.SetFrame(newFrame >> 2);
		MainRules.SingleLoop();
	}

	//public static var Instance(default, null) : Game = null;
	//public var CurrentWorld(default, null) : World;
//
	//public function new()
	//{
		//super();
		//
		//if (Instance != null) throw "Game.construct() : Trying to create more than one Game";
		//Instance = this;
		//
		//addEventListener(Event.ADDED_TO_STAGE, construct);
	//}
	//
	//private function construct(e : Event)
	//{
		//removeEventListener(Event.ADDED_TO_STAGE, construct);
		//
		//CurrentWorld = null;
		//
		//stage.addEventListener(Event.RESIZE, resize);
		//addEventListener(Event.RESIZE, onResize);
		//addEventListener(Event.ENTER_FRAME, onUpdate);
		//
		//Initialize();
	//}
	//
	//private function onResize(e : Event) { }
	//private function onUpdate(e : Event) { }
	//
	//public function Initialize() { }
	
	//public function ChangeWorld(newWorld : World)
	//{
		//if (CurrentWorld != null)
		//{
			//CurrentWorld.destroy();
			//removeChild(CurrentWorld);
		//}
		//
		//CurrentWorld = newWorld;
		//addChild(CurrentWorld);
		//initialize();
	//}
	//
	//public function Initialize() { if (CurrentWorld != null) CurrentWorld.initialize(); }
	//public function Resize()     { if (CurrentWorld != null) CurrentWorld.resize(); }
	//public function Update()     { if (CurrentWorld != null) CurrentWorld.update(); }
	
}