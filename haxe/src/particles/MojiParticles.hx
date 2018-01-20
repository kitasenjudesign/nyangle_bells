package particles;
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
class MojiParticles extends Object3D
{

	
	//https://tkmh.me/blog/2016/12/06/578/
	
	//private var _geo:PaperParticlesGeo;
	private var _mat:PaperParticlesMat;
	
	public function new() 
	{
		super();
	}
	
	
	
	public function init():Void{
		
		//var geo:PaperParticlesGeo = new PaperParticlesGeo();
		var geo:MojiGeo = new MojiGeo(
			DataManager.getInstance().nyan.geos[0],
			0.5,
			400
		);
		
		_mat = new PaperParticlesMat();
		var m:Mesh = new Mesh(
			cast geo, _mat
		);
		add(m);
		m.frustumCulled = false;
		this.frustumCulled = false;
		
	}
	
	public function update():Void{
		_mat.update();
	}
	
	public function setColor(col:Color) 
	{
		_mat.setColor( col );
	}
	
	
	public function reset():Void{
		
		_mat.reset();
		
	}
	
	public function flash():Void{
		
		_mat.flash();
		
	}
	
	
	
	public function addNumRatio():Void{
		
		_mat.addNum();
		
	}
	
	public function start() 
	{
		_mat.start();
	}
	
}