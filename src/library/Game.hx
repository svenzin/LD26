package library;
import com.eclecticdesignstudio.motion.Actuate;
import nme.display.Sprite;
import nme.events.Event;

/**
 * ...
 * @author scorder
 */

//class Global extends EventDispatcher
//{
	//public var Ticks(default, null) : Int;
	//public var DeltaTicks(default, null) : Int;
	//
	//public function new() { init(); }
	//
	//function init()
	//{
		//Ticks = DeltaTicks = 0;
		//addEventListener(Event.ENTER_FRAME, update);
	//}
	//
	//function update()
	//{
		//DeltaTicks = Lib.getTimer() - Ticks;
		//Ticks += DeltaTicks;
	//}
	//
	//public function FramesPerSecond() : Float
	//{
		//if (DeltaTicks == 0) return -1.0;
		//return 1000.0 / DeltaTicks;
	//}
//}

class World extends Sprite { }
class Game extends Sprite
{
	public function new()
	{
		super();
		Construct();
		addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
	}
	
	private function Construct()
	{
		CurrentWorld = null;
		m_nextWorld = null;
	}
	
	private function onAddedToStage(e : Event)
	{
		removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		
		addEventListener(Event.ENTER_FRAME, Update);
		Initialize();
	}
	
	private function Update(e : Event)
	{
		ChangeWorld();
	}
	
	private function Initialize() { }
	
	public  var CurrentWorld(default, null) : World;
	private var m_nextWorld : World;
	public function NextWorld(nextWorld : World)
	{
		m_nextWorld = nextWorld;
	}
	private function ChangeWorld()
	{
		if (m_nextWorld == null) return;
		
		if (CurrentWorld != null) removeChild(CurrentWorld);
		CurrentWorld = m_nextWorld;
		m_nextWorld = null;
		addChild(CurrentWorld);
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