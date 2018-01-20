package particles.papers;
import common.Dat;
import particles.papers.KamiParticleMat;
import three.Color;
import three.Object3D;
import three.Points;

/**
 * ...
 * @author 
 */
class KamiParticle extends Points
{
	var _mat:KamiParticleMat;

	
	
	public function new() 
	{
		/*
		var material:PointsMaterial = new PointsMaterial({
		   color: 0xffffff,
		   size: 30,
		   map: ImageUtils.loadTexture("./img/star.png"),
		   vertexColors:Three.VertexColors,
		   transparent:true
		});

		var points:Points = new Points(geometry, material);
		add(points);
		points.position.z = Params.distance / 2;
		points.frustumCulled = false;
		*/
		
		_mat = new KamiParticleMat();
		super( cast new KamiParticleGeo(30), _mat);
		
		this.visible = false;
		//Dat.gui.add(this, "play");
	}
	
	public function play() 
	{
		Tracer.info("Play");
		this.visible = true;
		_mat.play( _onPlay );
	}	
	
	private function _onPlay():Void{
		this.visible = false;		
	}
	
	public function setColor(col:Color):Void{
		//Tracer.info("setColor " + col);
		_mat.setColor(col);
	}	
	
}