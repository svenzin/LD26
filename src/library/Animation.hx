package library;
import nme.display.Bitmap;
import nme.display.Sprite;
import nme.events.Event;

/**
 * ...
 * @author scorder
 */
class Animation extends Sprite
{

	public function new(frames : Array<Bitmap>) 
	{
		super();
		
		m_frames = frames;
		
		init();
	}
	
	function init()
	{
		Frame = 0;
		Length = m_frames.length;
		addChild(m_frames[Frame]);
	}
	
	public function SetFrame(frame : Int)
	{
		if (frame > m_frames.length) throw "Animation.SetFrame(frame) : frame is out of range";
		
		removeChild(m_frames[Frame]);
		Frame = frame;
		addChild(m_frames[Frame]);
	}
	
	public var Frame(default, null) : Int;
	public var Length(default, null) : Int;
	
	var m_frames : Array<Bitmap>;
}