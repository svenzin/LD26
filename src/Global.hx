package ;

/**
 * ...
 * @author scorder
 */
class Global
{

	public function new() 
	{
		
	}

	public static var Debug : Bool = false;
	
	public static var CellSize : Int = 64;
	
	public static var Width : Int = 960;
	public static var Height : Int = 540;
	
	public static var MAX_ENERGY = 5;
	public static var MAX_STABLE_ENERGY = 5;
	public static var MAX_PRODUCTION = 2;
	
	public static var DICE_COUNT = 3;
	public static var DICE_OFFSET = 0.3;
	public static var MIN_STARTER_VALUE = 0;
	public static var MAX_STARTER_VALUE = 16;
	
	public static var NONE    : String = "None";
	public static var EXPLORE : String = "Explore";
	public static var DEVELOP : String = "Develop";
	public static var SETTLE  : String = "Settle";
	public static var PRODUCE : String = "Produce";
	public static var UPKEEP  : String = "Upkeep";
	
	public static var GO      : String = "Go";
	public static var PASS    : String = "Pass";
	public static var DONE    : String = "Done";
	public static var EXIT    : String = "Exit";
	
	public static var PHASE : String = "Phase";
	public static var RED   : String = "Red";
	public static var GREEN : String = "Green";
	public static var BLUE  : String = "Blue";
	
	public static var NOBODY : Player = new Player(0);
}