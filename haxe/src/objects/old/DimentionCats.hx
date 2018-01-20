package objects;
import camera.ExCamera;
import sound.MyAudio;
import three.BoxGeometry;
import three.Mesh;
import three.MeshBasicMaterial;
import three.Vector3;

/**
 * ...
 * @author watanabe
 */
class DimentionCats extends CatsBase
{

	public static inline var MODE_X		:Int = 2;
	public static inline var MODE_Y		:Int = 0;
	public static inline var MODE_Z		:Int = 1;
	public static inline var MODE_NORMAL:Int = 3;	
	
	private var _cats:Array<DimentionCat>;
	private var _flag:Bool=false;
	private var _count:Int = 0;
	private var _rot:Vector3;
	private var _mode:Int = 0;
	private var _scales:Array<Vector3>;
	private var _randomMode:Bool = false;
	
	public function new() 
	{
		super();
	}
	
	override public function init(cam:ExCamera):Void {
		_cam = cam;
		_rot = new Vector3();
		
		var z:Float = 0.001;
		
		_scales = [
			new Vector3(1, z, 1),			
			new Vector3(1, 1, z),
			new Vector3(z, 1, 1),
			new Vector3(1, 1, 1)
		];
		
		
		/*
		var m:Mesh = new Mesh(new BoxGeometry(10, 10, 10), new MeshBasicMaterial( { color:0xff0000 } ));
		add(m);
		*/
		_cats = [];
		
		for(i in 0...7){
			for(j in -2...3){
				var cat:DimentionCat = new DimentionCat();
				cat.position.x = i * 150 - 6 * 150 / 2;
				cat.position.y = j * 200;		
				cat.init();
				add(cat);
				_cats.push(cat);
			}
			
		}
		
		_mode = MODE_X;
		
		
	}
	
	
	override public function restart():Void
	{
		if (Math.random() < 0.1) {
			_cam.radX = Math.random()*2*Math.PI;
			_cam.radY = Math.random()*2*Math.PI;			
		}else{
			_cam.radX = 0;
			_cam.radY = 0;
		}
		_cam.amp = 300+600*Math.random();
	}	
	
	
	
	//audio wo watasu
	override public function update(a:MyAudio):Void {
		
		_flag = false;
		
		if( !_randomMode ){
			if (_mode == MODE_X) {
				_rot.x += Math.PI / 100;
			}else if (_mode == MODE_Y) {
				_rot.y += Math.PI / 100;			
			}else if (_mode == MODE_Z) {
				_rot.z += Math.PI / 100;
			}else {
				_rot.x += Math.PI / 100;
				_rot.y += Math.PI / 100;
				_rot.z += Math.PI / 100;
			}
		}
		
		_count++;
		if ( a.subFreqByteData[5] > 10 && _count > 15 ) {
			
			_flag = true;
			_count = 0;
			_goNext();
			
		}
		
		for (i in 0..._cats.length) {
			
			_cats[i].update(_rot, _scales[_mode], _randomMode, a);
			
		}
		
	}	
	
	private function _goNext():Void
	{
		var n:Int = Math.floor(Math.random() * 3);
		if (Math.random() < 0.5) {
			n = 3;
			_randomMode = Math.random() < 0.3 ? true : false;
			
			//size
			if (Math.random() < 0.25) {
				var size:Float = (Math.random() < 0.7) ? 10 + 10 * Math.random() : 20 + 50 * Math.random();
				if (Math.random() < 0.1) {
					size = 100;
				}
				for (i in 0..._cats.length) {
					_cats[i].setSize( size );
				}				
			}
		}else {
			_randomMode = false;
		}
		
		_mode = n;
	}
	

	
}