package ;
import nme.display.Bitmap;
import nme.Assets;
import nme.display.Sprite;
import nme.text.TextField;
import nme.text.TextFieldAutoSize;
import nme.events.Event;

/**
 * ...
 * @author scorder
 */
class GUI extends Sprite
{

	public function new()
	{
		super();
		
		m_side = new Bitmap(Assets.getBitmapData("img/Side.png"));
		m_side.x = Global.Width - m_side.width;
		m_side.y = 0;
		
		m_p1Name = new TextField();
		m_p1Name.x = m_side.x + 32;
		m_p1Name.y = m_side.y + 20;
		m_p1Name.text = "Player 1 (You - Blue)";
		m_p1Name.textColor = Colors.White;
		
		m_p1Score = new TextField();
		m_p1Score.x = m_side.x + 210;
		m_p1Score.y = m_side.y + 20;
		m_p1Score.textColor = Colors.White;
		
		m_p2Name = new TextField();
		m_p2Name.x = m_side.x + 32;
		m_p2Name.y = m_side.y + 56;
		m_p2Name.text = "Player 2 (Green)";
		m_p2Name.textColor = Colors.White;
		
		m_p2Score = new TextField();
		m_p2Score.x = m_side.x + 210;
		m_p2Score.y = m_side.y + 56;
		m_p2Score.textColor = Colors.White;
		
		m_p3Name = new TextField();
		m_p3Name.x = m_side.x + 32;
		m_p3Name.y = m_side.y + 96;
		m_p3Name.text = "Player 3 (Red)";
		m_p3Name.textColor = Colors.White;
		
		m_p3Score = new TextField();
		m_p3Score.x = m_side.x + 210;
		m_p3Score.y = m_side.y + 96;
		m_p3Score.textColor = Colors.White;
		
		m_status = new TextField();
		m_status.x = m_side.x + 32;
		m_status.y = m_side.y + 135;
		m_status.textColor = Colors.White;
		m_status.autoSize = TextFieldAutoSize.LEFT;
		m_status.multiline = true;
		
		addChild(m_side);
		addChild(m_p1Name);
		addChild(m_p1Score);
		addChild(m_p2Name);
		addChild(m_p2Score);
		addChild(m_p3Name);
		addChild(m_p3Score);
		addChild(m_status);
		
		Phase = Main.MainBitmaps.get(Global.PHASE);
		addChild(Phase);
		
		var buttonX = m_side.x - 70;
		
		Explore = new Button(Global.EXPLORE);
		Explore.x = buttonX;
		Explore.y = 0 + 10;
		
		Settle = new Button(Global.SETTLE);
		Settle.x = buttonX;
		Settle.y = 70 + 10;
		
		Produce = new Button(Global.PRODUCE);
		Produce.x = buttonX;
		Produce.y = 140 + 10;
		
		Go = new Button(Global.GO);
		Go.x = buttonX;
		Go.y = 310;
		
		Pass = new Button(Global.PASS);
		Pass.x = buttonX;
		Pass.y = 380;
		
		Done = new Button(Global.DONE);
		Done.x = buttonX;
		Done.y = 400;
		
		addChild(Explore);
		addChild(Settle);
		addChild(Produce);
		//addChild(Go);
		//addChild(Pass);
		addChild(Done);
		
		Red   = Main.MainBitmaps.get(Global.RED);
		Green = Main.MainBitmaps.get(Global.GREEN);
		Blue  = Main.MainBitmaps.get(Global.BLUE);
		
		addChild(Red);
		addChild(Green);
		addChild(Blue);
		
		addEventListener(Event.ENTER_FRAME, update);
	}
	
	function showItemOnPhase(item : Bitmap, phase : String)
	{
		item.visible = true;
		switch (phase)
		{
			case Global.EXPLORE: { item.x = Explore.x; item.y = Explore.y; }
			case Global.SETTLE:  { item.x = Settle.x; item.y = Settle.y; }
			case Global.PRODUCE: { item.x = Produce.x; item.y = Produce.y; }
			default:             { item.visible = false; }
		}
	}
	
	function update(event : Event)
	{
		m_p1Score.text = Std.string(Main.MainRules.Players[0].Points);
		m_p2Score.text = Std.string(Main.MainRules.Players[1].Points);
		m_p3Score.text = Std.string(Main.MainRules.Players[2].Points);
		
		showItemOnPhase(Phase, Main.MainRules.Phase);
		showItemOnPhase(Red,   Main.MainRules.Players[0].Phase);
		showItemOnPhase(Green, Main.MainRules.Players[1].Phase);
		showItemOnPhase(Blue,  Main.MainRules.Players[2].Phase);
		
		m_status.text = "Energy: " + Std.string(Main.MainRules.Players[0].Energy) + "\n" + "Military: " + Std.string(Main.MainRules.Players[0].Military);
	}
	
	var m_side : Bitmap;
	
	var m_p1Name : TextField;
	var m_p1Score : TextField;
	
	var m_p2Name : TextField;
	var m_p2Score : TextField;
	
	var m_p3Name : TextField;
	var m_p3Score : TextField;
	
	var m_status : TextField;
	
	public var Phase : Bitmap;
	public var Red : Bitmap;
	public var Green : Bitmap;
	public var Blue : Bitmap;
	
	public var Explore : Button;
	public var Settle  : Button;
	public var Produce : Button;
	public var Go      : Button;
	public var Pass    : Button;
	public var Done    : Button;
}