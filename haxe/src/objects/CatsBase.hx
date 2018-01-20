package objects;
import camera.ExCamera;
import sound.MyAudio;
import three.Object3D;

/**
 * ...
 * @author watanabe
 */
class CatsBase extends Object3D
{
	private var _cam:ExCamera;

	public function new() 
	{
		
		super();
		
	}
	
	
	public function init(cam:ExCamera):Void {
		_cam = cam;
	}
	
	
	public function update(a:MyAudio):Void {
		
		
		
	}
	
	public function restart():Void
	{
		
	}

	
	
	
	
}