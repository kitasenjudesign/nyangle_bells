package objects;
import data.DataManager;
import haxe.Timer;
import objects.cat.CatHat;
import sound.MyAudio;
import three.BoxGeometry;
import three.ConeGeometry;
import three.Mesh;
import three.MeshBasicMaterial;
import three.MeshLambertMaterial;
import three.Object3D;
import three.PlaneGeometry;
import tween.TweenMax;

/**
 * ...
 * @author watanabe
 */
class LongCat extends Object3D
{

	public static inline var SIZE_HEAD:Float = 63.743;
	public static inline var SIZE_HIP:Float = 67.9;
	
	public var index:Int = 0;
	private var ground:Mesh;
	private var _dataManager:DataManager;
	
	private var _cat:Object3D;
	private var _body:CatBody;
	private var _hip:Object3D;
	
	private var _limit:Float = 600+200*Math.random();
	private var _rotSpeed:Float = Math.random() * Math.PI / 42;
	
	private var _showing:Bool = true;
	//private var _callback:Cat->Void;
	private var _removeCallback:Cat->Void;
	private var _rad:Float = 0;
	private var _mode:Int = 0;
	private var _freqIndex:Int = 0;
	private var _flag:Bool = false;
	private var _tgtScale:Float = 1;
	
	private var _container:Object3D;
	private var _rot:Float = 0;
	var _hat:CatHat;
	
	public function new() 
	{
		super();
	}
	
	
	
	/**
	 * init
	 */
	public function init():Void {
		
		_freqIndex = Math.floor(Math.random() * 10);
		
		_dataManager = DataManager.getInstance();
		
		_container = new Object3D();
		add(_container);
		
		//head
		_cat = _dataManager.cats.head.clone();
		_container.add(_cat);
		
		_hat = new CatHat();
		_hat.rotation.x = - Math.PI / 2;
		_hat.position.y = -0.1;
		_hat.position.z = -0.35;
		_hat.visible = false;
		//hat.position.z = 0.05;
		_cat.add(_hat);			
		
	
		
		//_body
		_body = new CatBody();
		//_body.castShadow = true;
		_body.scale.set(100, 0.001, 100);
		_body.init();
		_body.position.y = -0.63743 * 100;
		_container.add( _body );
		
		//_hip
		_hip = _dataManager.cats.hip.clone();
		_container.add(_hip);
		
		_showing = true;
	}
	
	
	public function showHat():Void{
		_hat.visible = true;
	}
	public function hideHat():Void{
		_hat.visible = false;
	}
	
	
	
	public function setSize(size:Float):Float {
		
		if (_mode == 0) {
			
			_cat.position.y = size + 0.63743 * 100;//63.743
			_body.updateDoubleSize(size);
			_hip.position.y =  -size;//67.9
						
		}else{
			_cat.position.y = size + 0.63743 * 100;
			_body.updateFrontSize(size);
			_hip.position.y = 0;// -size;
			
			var oy:Float = 0.6 * 100 + size * 0.3;
			_cat.position.y += oy;
			_body.position.y += oy;
			_hip.position.y += oy;
			
		}		
		
		return size+SIZE_HIP + SIZE_HEAD;
	}

	/*
	public function updateB(size:Float,isScale:Bool=true):Void {
		


		if(isScale){
			var ss:Float = size / 100;
			if (ss > 1) ss = 1;
			if (ss < 0.01) ss = 0.01;
			_container.scale.y = ss;
		}
		
	}*/
	
	
	//audio wo watasu
	public function update(audio:MyAudio,rot:Float):Void {
		
		
		//this.rotation.y += Math.PI/100;		
		_rad += Math.PI / 100;
		//_cat.position.y = 170+100*Math.sin(_rad);
		/*
		this.rotation.x += Math.PI / 1200;
		this.rotation.y += Math.PI / 1230;
		this.rotation.z += Math.PI / 1430;
		*/
		
		if ( audio.subFreqByteData[_freqIndex] > 10 ) {
			_flag = !_flag;
		}
		
		if(_flag){
			_tgtScale += ( 1 - _tgtScale) / 2;
		}else {
			_tgtScale += ( 0.001 - _tgtScale ) / 2;
		}
		
		this.rotation.y += (rot - this.rotation.y) / 2;
		
		_container.scale.y += ( _tgtScale - _container.scale.y) / 4;
		//position.y +=
		
		
		/*
		var headPos:Float = _cat.position.y - 0.63743 * 100;
		
		if(_showing){
			_body.setStart(headPos);
		}else {
			_body.position.y = headPos;
			_hip.position.y = headPos - _body.scale.y;
		}
		*/
		
		//_body.rotation
	}
	
	public function getPosY():Float {
		return _cat.position.y;
	}
	
	/**
	 * 
	 * @param	callback
	 * @param	removeCallback
	 */
	public function hide(callback:Cat->Void):Void
	{
		if(_showing){
			_showing = false;
			Timer.delay(_onHide, 800);
		}
	}
	
	/**
	 * 
	 * @param	xx
	 * @param	yy
	 * @param	zz
	 */
	public function setScale(xx:Float, yy:Float, zz:Float):Void 
	{
		
	}
	
	private function _onHide():Void
	{
		
	}
	
	
	
}