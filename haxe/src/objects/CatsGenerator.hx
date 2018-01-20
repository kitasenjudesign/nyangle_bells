package objects;
import data.DataManager;
import sound.MyAudio;
import three.BoxGeometry;
import three.Mesh;
import three.MeshBasicMaterial;
import three.Object3D;
import three.PlaneGeometry;
import tween.TweenMax;

/**
 * ...
 * @author watanabe
 */
class CatsGenerator extends Object3D
{

		
	private var ground:Ground;
	private var _cats:Array<Cat>;
	private var _activeCat:Cat;
	private var _active		:Bool = false;
	private var _showing	:Bool = false;
	var _index:Int;
	
	public function new() 
	{
		super();
	}
	
	/**
	 * init
	 */
	public function init(index:Int):Void {
		_cats = [];
		_index = index;
		
		ground = new Ground();
		ground.init();
		//ground.rotation.x = Math.PI / 2;
		add(ground);
		
	}
	
	//on off suru
	
	//audio wo watasu
	public function update(audio:MyAudio):Void {
		
		//_body.rotation
		var value:Float = Math.pow( audio.freqByteData[_index] / 255, 3);
		var s:Float = value * 2 + 0.5;
		if (s > 1) s = 1;
		ground.setScale(s);
		
		if ( value > 0.1) {
			
			//値によって
			if (_activeCat == null) {
				//gen(value);//
			}
			
		}else {
			if (_activeCat != null) {
				_activeCat.hide(_onHide);
			}
			
		}
		
		var i:Int = 0;
		while (true) {
			if (i >= _cats.length) break;
			
			_cats[i].update(audio);
			if (_cats[i] !=_activeCat && _cats[i].getPosY() > 1500) {
				_onRemove(i,_cats[i]);
			}else{
				i++;
			}
			
		}
		
		
	}
	
	
	public function gen(value:Float):Void{
		_activeCat = new Cat();
		_activeCat.init(value);
		add(_activeCat);
		_cats.push(_activeCat);
		ground.flash();
	}
	
	
	public function reset():Void {
		
		for (i in 0..._cats.length) {
			remove(_cats[i]);
		}
		_cats = [];
	}
	
	private function _onRemove(i:Int,cat:Cat):Void
	{
		trace("remove!!!");
		remove(cat);	
		_cats.splice(i, 1);
			
	}
	
	private function _onHide(cat:Cat):Void
	{
		_activeCat = null;
		

	}
	
}