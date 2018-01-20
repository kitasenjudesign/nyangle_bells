package sound;
import three.Object3D;

/**
 * ...
 * @author 
 */
class MidiJsonLoaders extends Object3D
{

	private var _callback:Void->Void;

	
	public function new() 
	{
		super();
	}
	
	public function load(callback:Void->Void):Void{
		
		_callback = callback;
		
		var uri:Array = [
			{
				key: "vo",
				url: "nekodemo_bpm120vo.json"
			},
			{
				key: "beat",
				url: "nekodemo_bpm120vo.json"				
			}
		];
		
		
	}
	
	
}