package ;
import nme.Assets;
import nme.media.Sound;

/**
 * ...
 * @author scorder
 */
class SoundsManager
{

	public function new() 
	{
		Select  = Assets.getSound("wav/Valid.wav");
		Explore = Assets.getSound("wav/Explore.wav");
		Settle  = Assets.getSound("wav/Settle.wav");
		Produce = Assets.getSound("wav/Generate.wav");
		Consume = Assets.getSound("wav/Consume.wav");
		Desume  = Assets.getSound("wav/Consume.wav");
	}
	
	public var Select : Sound;
	public var Explore : Sound;
	public var Settle : Sound;
	public var Produce : Sound;
	public var Consume : Sound;
	public var Desume : Sound;
}