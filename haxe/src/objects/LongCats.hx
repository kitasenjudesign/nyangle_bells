package objects;
import camera.ExCamera;
import sound.MyAudio;
import three.BoxGeometry;
import three.Line;
import three.Mesh;
import three.MeshBasicMaterial;
import three.Object3D;

/**
 * ...
 * @author watanabe
 */
class LongCats extends CatsBase
{
	
	private var _cats:Array<LongCat>;
	private var _speedX:Float = Math.random();
	private var _waku:LongCatsWaku; 
	private var _rot:Float = 0;
	private var _count:Int = 0;
	private var _isRotation:Bool=false;
	public function new() 
	{
		super();
	}
	
	//switch on off
	
	override public function init(cam:ExCamera):Void {
		
		_cam = cam;
		_cats = [];
		
		
		_waku = new LongCatsWaku();
		_waku.init();
		add(_waku);
		
		for(j in 0...4){
			for(i in 0...4){
				
				var cat:LongCat = new LongCat();
				cat.init();
				cat.setSize(100);
				cat.position.x = i * 100 - 3 * 100 / 2;// 200 * ( Math.random() - 0.5 );	
				cat.position.z = j * 100 - 3 * 100 / 2;// 200 * ( Math.random() - 0.5 );	
				
				add(cat);
				
				_cats.push(cat);
				
			}
		}
	}
	
	override public function restart():Void
	{
		
		_speedX = Math.random() / 100 + 0.002;
		_cam.radY = (Math.random() - 0.5) * Math.PI * 0.8;		
		_cam.amp = 500 + 600 * Math.random();
		_reposition(Math.floor(1 + (Math.floor(Math.random() * 4))));
		_isRotation = (Math.random() < 0.5) ? true :false;
		
	}		
	
	private function _reposition(num:Int):Void {
		
		trace("num = " + num);
		
		for (i in 0..._cats.length) {
			_cats[i].visible = false;
		}
		
		var sp:Float = 120 + (4-num)*100;
		var idx:Int = 0;

		for (j in 0...num) {
			for ( i in 0...num) {
				
				_cats[idx].visible = true;
				_cats[idx].scale.set(5 - num, 5 - num, 5 - num);
				_cats[idx].position.x = i * sp - (num - 1) * sp / 2;
				_cats[idx].position.z = j * sp - (num - 1) * sp / 2;
				idx++;
				
			}
		}
		
		if(Math.random()<0.5){
			this.rotation.x = Math.PI / 2;
		}else {
			this.rotation.x = 0;			
		}
	}
	
	
	
	/**
	 * myAudio
	 */
	override public function update(a:MyAudio):Void {
		_cam.radX += _speedX;
		
		if(_isRotation){
			_count++;
			if (a.subFreqByteData[8] > 10 && _count > 30) {
				_count = 0;
				_rot += 0.15;
			}else {
				_rot += 0.01;
			}
		}else {
			_rot = 0;
		}
		for(i in 0..._cats.length){
			_cats[i].update(a, _rot);
		}
	}
	
	
}