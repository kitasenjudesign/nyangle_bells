package objects;
import js.Browser;
import sound.MyAudio;
import three.BoundingBoxHelper;
import three.BoxGeometry;
import three.Mesh;
import three.MeshBasicMaterial;
import three.Object3D;
import three.Vector3;
import tween.TweenMax;

/**
 * ...
 * @author watanabe
 */
class DimentionCat extends Object3D
{
	

	
	

	private var _callback:FlyingCat->Void;
	private var _startPos:Vector3;
	public var v:Vector3;
	public var cat:LongCat;
	//houbutsu sen
	
	private var _mode:Int = 0;
	private var _box:LineBox2;
	private var _randomSpeed:Vector3;
	private var _index:Int = 0;
	private var _count:Int = 0;
	private var _size:Float = 30;
	
	
	public function new() 
	{
		super();
		cat = new LongCat();
		cat.init();
		add(cat);
		//koko

		
	}
	
	/**
	 * 
	 * @param	spos
	 * @param	callback
	 */
	public function init():Void {
		
		_index = Math.floor( 10 * Math.random() );
		_randomSpeed = new Vector3(
			Math.random() - 0.5,
			Math.random() - 0.5,
			Math.random() - 0.5			
		);
		
		var sz:Float = cat.setSize(30);
		
		//trace("size " + sz);
		
		cat.rotation.x = Math.PI / 2;
		
		_box = new LineBox2();
		_box.init();
		_box.position.z = 10;		
		_box.position.y = -10;
		_box.scale.set(0.5, 0.75, 1.9*sz/161.643);
		add(_box);
		
		//setSize(50);
	}
	
	
	public function setSize(size:Float):Void {
		
		//_size = size;
		
		TweenMax.to(this, 0.5, {
			_size:size,
			onUpdate:_onUpdateSize
		});
		
	}
	
	private function _onUpdateSize():Void
	{
		var sz:Float = cat.setSize(_size);
		_box.scale.set(0.5, 0.75, 1.9*sz/161.643);
	}
	
	public function prev():Void {
		
	}
	
	//public function next(idx:Int ):Void {
	//	_mode = idx;// Math.floor( _scales.length * Math.random() );
	//}
	
	//onajiugoki, local no ugoki
	public function setGlobal(b:Bool):Void {
		
	}
	
	
	public function update(r:Vector3,ss:Vector3,randomMode:Bool,audio:MyAudio):Void {

		//var ss:Vector3 = _scales[_mode];
		
		this.scale.x += (ss.x - this.scale.x) / 4;
		this.scale.y += (ss.y - this.scale.y) / 4; 
		this.scale.z += (ss.z - this.scale.z) / 4;
		
		if (randomMode) {
			
			if ( audio.subFreqByteData[_index] > 10 && _count++ > 10 ) {
				_count = 0;
				_randomSpeed.x = audio.subFreqByteData[_index] / 255 * 0.4;
				_randomSpeed.y = audio.subFreqByteData[_index+1] / 255 * 0.4;
				_randomSpeed.z = audio.subFreqByteData[_index+2] / 255 * 0.4;				
			}
			
			this.rotation.x += _randomSpeed.x;
			this.rotation.y += _randomSpeed.y;
			this.rotation.z += _randomSpeed.z;
			
		}else{
			this.rotation.x += ( r.x - this.rotation.x)/4;
			this.rotation.y += ( r.y - this.rotation.y)/4;
			this.rotation.z += ( r.z - this.rotation.z)/4;
		}
		
		
	}
	
	private function _remove():Void
	{
		
	}
}