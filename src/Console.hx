package ;
import nme.display.Sprite;
import nme.text.TextField;
import nme.text.TextFieldAutoSize;

/**
 * ...
 * @author scorder
 */
class Console extends Sprite
{

	public function new() 
	{
		super();
		
		Message = new TextField();
		Message.x = 0;
		Message.y = 520;
		Message.autoSize = TextFieldAutoSize.LEFT;
		
		Log("Hello");
		
		//addChild(Message);
	}
	
	function Set(caption : String, color : Int)
	{
		Message.text = caption;
		Message.textColor = color;
	}
	
	public function Log  (caption : String) { Set(caption, Colors.White); }
	public function Warn (caption : String) { Set(caption, Colors.Yellow); }
	public function Error(caption : String) { Set(caption, Colors.Red); }
	
	var Message : TextField;
}