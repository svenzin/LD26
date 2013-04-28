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
		Energy = 0;
		Spending = 0;
		Production = 0;
		
		Phase = Global.NONE;
	}
	
	public function hashCode() : String
	{
		return Std.string(Id);
	}
	
	public var Id : Int;
	public var Energy : Int;
	public var Spending : Int;
	public var Production : Int;
	
	public var Phase : String;
}