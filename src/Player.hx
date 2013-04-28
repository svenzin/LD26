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
		Energy = 4;
		Military = 0;
		Points = 0;
		
		Phase = Global.NONE;
	}
	
	public function hashCode() : String
	{
		return Std.string(Id);
	}
	
	public var Id : Int;
	public var Energy : Int;
	public var Military : Int;
	public var Points : Int;
	
	public var Phase : String;
}