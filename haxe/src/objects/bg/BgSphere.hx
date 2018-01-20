package objects.bg;
import js.html.Float32Array;
import objects.bg.BgShaderMat;
//import objects.shape.MediceneShaderMat;
import three.BufferAttribute;
import three.BufferGeometry;
import three.ImageUtils;
import three.Mesh;
import three.MeshBasicMaterial;
import three.SphereBufferGeometry;

/**
 * ...
 * @author 
 */
class BgSphere extends Mesh
{

	private var _mat:BgShaderMat;
	
	public function new() 
	{
		
		// tekito ninyaru
		
		var g:SphereBufferGeometry = new SphereBufferGeometry(5000, 15, 15);
		
		Tracer.log( "len = " + g.attributes.position.length );
		var nn:Int = g.attributes.position.length;
		var colors:Float32Array = new Float32Array(nn * 3);
		for ( i in 0...nn ) {
			colors[i * 3 + 0] = Math.random();
			colors[i * 3 + 1] = Math.random();
			colors[i * 3 + 2] = Math.random();
		}
		
		//colors
		g.addAttribute('color', new BufferAttribute( colors, 3 ) );		
		
		
		_mat = new BgShaderMat();
		_mat.fog = false;
		///_mat.wireframe = true;
		super(cast g,cast _mat);
		
	}
	
	
	
	public function startBlack(time:Float, delay:Float):Void{
		_mat.startBlack(time, delay);
	}

	public function startWhite(time:Float, delay:Float):Void{
		_mat.startWhite(time, delay);
	}
	
	public function update():Void{
		
		_mat.update();
		
	}
	
}