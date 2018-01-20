package objects.cat;
import data.NoteonData;
import objects.LongCat;
import objects.cat.GiftBox;
import particles.papers.KamiMesh;
import particles.papers.KamiParticle;
import three.Color;
import three.Object3D;
import tween.TweenMax;

/**
 * ...
 * @author 
 */
class GiftBoxCat extends Object3D
{

	private var _box:GiftBox;
	private var _cat:LongCat;
	private var _tweening:Bool = false;
	private var _rotSpeed:Float = 0;
	private var _ySpeed:Float = 1;
	private var _papers:KamiParticle;
	public var data:NoteonData;
	
	public function new() 
	{
		super();
	}
	
	public function init(d:NoteonData):Void{
		
		data = d;
		
		_box = new GiftBox();
		_box.position.y = 50;
		add(_box);
		
		_papers = new KamiParticle();
		add(_papers);
		
		_cat = new LongCat();
		_cat.init();
		_cat.setSize(200 * Math.random());

		_rotSpeed = ( Math.random() - 0.5 ) * 0.5;
		
		_cat.rotation.y = Math.random() * Math.PI * 2;

		
		_ySpeed = Math.random() * 10;
		
		
		var ss:Float = 2 * Math.random() + 1;
		_cat.scale.set(ss, ss, ss);
		_cat.visible = false;
		add(_cat);
		
	}
	
	
	public function show():Void{
		
		_tweening = true;
		_cat.visible = true;
		_box.open();
		_papers.play();
		_cat.position.y = -500;
		TweenMax.to( _cat.position, 0.1, {
			y:0,
			onComplete:_onShow
		});
		
	}
	
	private function _onShow():Void{
		_tweening = false;		
		_cat.showHat();
	}
	
	
	public function hide():Void{
		
		_cat.visible = false;
		
	}
	
	/**
	 * 
	 */
	public function getPaper():KamiParticle{
		return _papers;
	}
	
	public function update():Void{
		
		if (_tweening) return;
		
		_cat.position.y += _ySpeed;
		_cat.rotation.y += _rotSpeed;
		
	}
	
	public function reset() 
	{
		_cat.visible = false;
		_box.reset();
		_cat.hideHat();
	}
	
	
	
}