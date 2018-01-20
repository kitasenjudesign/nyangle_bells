package particles.papers;
import data.DataManager;
import js.html.Float32Array;
import js.html.Uint16Array;
import particles.PaperParticlesMat;
import three.BufferAttribute;
import three.Color;
import three.Mesh;
import three.Object3D;

/**
 * ...
 * @author 
 */
class KamiMesh extends Object3D
{

	
	//https://tkmh.me/blog/2016/12/06/578/
	
	private static var _geo:KamiGeo;
	private var _mat:KamiMat;
	
	public function new() 
	{
		super();
	}
	
	
	
	public function init():Void{
		
		if( _geo == null){
			_geo = new KamiGeo(80);
		}
		
		_mat = new KamiMat();
		
		var m:Mesh = new Mesh(
			cast _geo,_mat
		);
		add(m);
		m.rotation.y = Math.random() * 2 * Math.PI;
		this.visible = false;
		
	}	
	
	
	public function setColor(col:Color):Void{
		
		_mat.setColor(col);
		
	}
	
	public function update():Void{
		
		if (_mat != null){
			_mat.update();
		}
		
	}
	
	public function play() 
	{
		this.visible = true;
		_mat.play( _onPlay );
	}
	
	private function _onPlay():Void{
		
		this.visible = false;		
		
	}
	
}