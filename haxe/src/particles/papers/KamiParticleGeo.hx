package particles.papers;
import haxe.io.UInt32Array;
import js.Browser;
import js.html.Float32Array;
import js.html.Uint16Array;
import three.BufferAttribute;
import three.BufferGeometry;
import three.MeshLambertMaterial;

/**
 * ...
 * @author 
 */
class KamiParticleGeo extends BufferGeometry
{

	public function new(num:Int) 
	{
		super();
		// BufferGeometryを生成
		//var geometry = new BufferGeometry();

		var s:Float = 7;	
		var vertexPositions:Array<Array<Float>> = [
				[-1.0*s, -1.0*s, 0.0*s], // a
				[ 1.0*s, -1.0*s, 0.0*s], // b
				[ 1.0*s,  1.0*s, 0.0*s], // c
				[-1.0*s,  1.0*s, 0.0*s]  // d
		];

		var normals:Float32Array 	= new Float32Array(vertexPositions.length * 3 * num);
		
		// Typed Arrayで頂点データを保持
		var vertices:Float32Array 	= new Float32Array(vertexPositions.length * 3 * num);
		
		
		var random:Float32Array 	= new Float32Array(vertexPositions.length * 3 * num);
		
		//color
		var color:Float32Array 		= new Float32Array(vertexPositions.length * 3 * num);
		
		
		var indices:UInt32Array 	= new UInt32Array( 6 * num );
		
		
		//var nn:Int = Math.sqrt( num );
		
		
		
		
		for(j in 0...num){
			
			//4点ぶんのvec3
			var pointsLen:Int = 4;
			
			var xx:Float = 2*(Math.random()-0.5);
			var yy:Float = 2*(Math.random()-0.5);
			var zz:Float = 2*(Math.random()-0.5);
			
			vertices[ j * 3 + 0] = 0;
			vertices[ j * 3 + 1] = 0;
			vertices[ j * 3 + 2] = 0;
				
			random[ j * 3 + 0] = xx;
			random[ j * 3 + 1] = yy;
			random[ j * 3 + 2] = zz;

		}
		
		//Browser.window.alert( "num " + vertices.length );
		
		// attributesを追加
		addAttribute("position",	new BufferAttribute(vertices, 3));
		//addAttribute("index",   	new BufferAttribute(cast indices,  1));
		//addAttribute("normal",	 	new BufferAttribute(normals, 3));
		addAttribute("random",	new BufferAttribute(random, 3));
		//addAttribute("color",	new BufferAttribute(color, 3));
		
		//これにcubeMaterialを渡す
		
	}
	
}