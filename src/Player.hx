package ;

/**
 * ...
 * @author scorder
 */
class Player
{

	public function new(id : Int) 
	{
		Id = id;
		Military = 0;
		Points = 0;
		
		Phase = Global.NONE;
	}

	public var Id : Int;
	public var Energy : Int;
	public var Military : Int;
	public var Points : Int;
	
	public var Phase : String;
}