package library;
import nme.display.Bitmap;
import nme.display.Sprite;
import nme.events.Event;
import nme.Lib;

/**
 * ...
 * @author scorder
 */
enum AnimationType
{
	ANIMATED_BY_TIME;
	ANIMATED_BY_FRAMES;
}

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
		
		addEventListener(Event.ENTER_FRAME, update);
		
		m_counter = 0;
	}
	
	function update(e : Event)
	{
		if (m_counter != 0)
		{
			switch (m_type)
			{
				case ANIMATED_BY_FRAMES: m_current += 1;
				case ANIMATED_BY_TIME:   m_current = Lib.getTimer();
			}
			
			var newFrame = Math.floor(Length * (m_current - m_start) / m_period);
			if (newFrame >= Length)
			{
				SetFrame(0);
				--m_counter;
				m_start = m_current;
			}
			else if (newFrame != Frame)
			{
				SetFrame(newFrame);
			}
		}
	}
	
	public function PlayOverTime(timeInMs : Int, count : Int = 1)
	{
		m_start = m_current = Lib.getTimer();
		m_period = timeInMs;
		m_type = ANIMATED_BY_TIME;
		m_counter = count;
	}
	
	public function PlayOverFrames(frames : Int, count : Int = 1)
	{
		m_start = m_current = 0;
		m_period = frames;
		m_type = ANIMATED_BY_FRAMES;
		m_counter = count;
	}
	
	public function Stop()
	{
		m_counter = 0;
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
	
	var m_type : AnimationType;
	var m_period : Int;
	var m_start : Int;
	var m_current : Int;
	var m_counter : Int;
}