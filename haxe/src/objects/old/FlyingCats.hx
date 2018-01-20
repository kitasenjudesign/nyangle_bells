package objects;
import camera.ExCamera;
import haxe.Timer;
import objects.Ground;
import sound.MyAudio;
import three.Mesh;
import three.MeshBasicMaterial;
import three.Object3D;
import three.PlaneBufferGeometry;
import three.Vector3;

/**
 * ...
 * @author watanabe
 */
class FlyingCats extends CatsBase
{
	
	//saisho ni 30 piki tsukuru
	private static inline var MAX:Int = 30;
	private var _cats:Array<FlyingCat>;
	private var _count:Int = 0;
	private var _index:Int = 0;
	private var _factory:Array<FlyingCat>;
	private var _rad:Float = 0;
	private var _ground:Ground;
	
	public function new() 
	{
		super();
	}
	
	override public function init(cam:ExCamera):Void {
		
		_cam = cam;
		_cats = [];
		_factory = [];
		
		for (i in 0...MAX) {
			var cat:FlyingCat = new FlyingCat();
			_factory.push(cat);
			//add(cat);			
			
		}

		
		var m:Mesh = new Mesh(
			cast new PlaneBufferGeometry(1200, 1200, 20, 20),
			new MeshBasicMaterial( { color:0x0, side:Three.FrontSide } )
		);
		m.rotation.x = -Math.PI / 2;
		m.position.y = -100;
		add(m);
		
		_ground = new Ground();
		_ground.init();
		add(_ground);
	}
	
	private function _gen():Void
	{
		_rad += Math.PI / 30;
		
		var cat:FlyingCat = _factory[_index % _factory.length];	
		var v:Vector3 = new Vector3(
			0,
			0,
			0
		);
		var scl:Float = 1 + Math.random();
		if (Math.random() < 0.01) {
			scl = 3 + 5 * Math.random();
		}
		cat.start(v, scl,_onRemove);
		add(cat);
		_index++;
		
		_cats.push( cat );
		_ground.setScale(scl);
		_ground.flash();
	}
	
	private function _onRemove(hoge:FlyingCat):Void
	{
		remove(hoge);
		_cats.splice(_cats.indexOf(hoge), 1);
	}
	
	override public function restart():Void
	{
		
	}	
	
	
	
	/*
	 * 
	 */
	override public function update(a:MyAudio):Void {

		_count++;
		if (_count > 5 && a.subFreqByteData[0]>10) {
			_gen();
			_count = 0;
		}
		
		
		for (i in 0..._cats.length) {
			if(_cats[i]!=null){
				_cats[i].update();
			}
		}
		
	}
	
}