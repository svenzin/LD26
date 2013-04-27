package ;

/**
 * ...
 * @author scorder
 */
class Colors
{

	public function new() 
	{
		
	}
	
	public static function Get(r : Float, g : Float, b : Float) : Int
	{
		var red = Math.max(Math.min(r, 1.0), 0.0);
		var gre = Math.max(Math.min(g, 1.0), 0.0);
		var blu = Math.max(Math.min(b, 1.0), 0.0);
		
		return Math.floor(0xFF * red) * 0x010000
		     + Math.floor(0xFF * gre) * 0x000100
			 + Math.floor(0xFF * blu) * 0x000001;
	}

	public static var White  : Int = 0xFFFFFF;
	public static var Red    : Int = 0xFF0000;
	public static var Green  : Int = 0x00FF00;
	public static var Blue   : Int = 0x0000FF;
	public static var Yellow : Int = 0xFFFF00;
	public static var Purple : Int = 0xFF00FF;
	public static var Cyan   : Int = 0x00FFFF;
	public static var Black  : Int = 0x000000;
}