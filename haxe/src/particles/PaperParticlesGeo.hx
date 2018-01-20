package particles;
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
class PaperParticlesGeo extends BufferGeometry
{

	public function new(num:Int) 
	{
		super();
		// BufferGeometryを生成
		//var geometry = new BufferGeometry();

		var s:Float = 10;	
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
			
			//var xx:Float = 2*(Math.random()-0.5);
			//var yy:Float = 2*(Math.random()-0.5);
			//var zz:Float = 2*(Math.random()-0.5);
			
			
			var xx:Float = j % Math.floor(10);
			var yy:Float = Math.floor( j / 10 );
			
			
			var zz:Float = 0;// 2 * (Math.random() - 0.5);
			
			var rr:Float = 0.0;// Math.random() < 0.5 ? 1 : 0;
			var gg:Float = 1.0;
			var bb:Float = 0.0;
			
			var ss:Float = 0.8 + 0.4 * Math.random();
			for ( i in 0...pointsLen) {
				
				vertices[ j * ( pointsLen * 3 ) + i * 3 + 0] = vertexPositions[i][0] * ss;
				vertices[ j * ( pointsLen * 3 ) + i * 3 + 1] = vertexPositions[i][1] * ss;
				vertices[ j * ( pointsLen * 3 ) + i * 3 + 2] = vertexPositions[i][2] * ss;
				
				random[ j * ( pointsLen * 3 ) + i * 3 + 0] = xx;
				random[ j * ( pointsLen * 3 ) + i * 3 + 1] = yy;
				random[ j * ( pointsLen * 3 ) + i * 3 + 2] = zz;
				
				color[ j * ( pointsLen * 3 ) + i * 3 + 0] = rr;
				color[ j * ( pointsLen * 3 ) + i * 3 + 1] = gg;
				color[ j * ( pointsLen * 3 ) + i * 3 + 2] = bb;				
				
			}

			//4点ぶんのvec3
			for ( i in 0...vertexPositions.length) {
				normals[ j*( pointsLen * 3 ) + i * 3 + 0] = 0;
				normals[ j*( pointsLen * 3 ) + i * 3 + 1] = 0;
				normals[ j*( pointsLen * 3 ) + i * 3 + 2] = -1;
			}
			
			// 頂点インデックスを生成
			var indexOffset:Int = j * 4;
     
			indices[j * 6 + 0 ] = (indexOffset + 0);
			indices[j * 6 + 1 ] = (indexOffset + 1);
			indices[j * 6 + 2 ] = (indexOffset + 2);
			
			indices[j * 6 + 3 ] = (indexOffset + 2);
			indices[j * 6 + 4 ] = (indexOffset + 3);
			indices[j * 6 + 5 ] = (indexOffset + 0);
			
		}
		
		Browser.window.alert( "num " + vertices.length );
		
		// attributesを追加
		addAttribute("position",	new BufferAttribute(vertices, 3));
		addAttribute("index",   	new BufferAttribute(cast indices,  1));
		addAttribute("normal",	 	new BufferAttribute(normals, 3));
		addAttribute("random",	new BufferAttribute(random, 3));
		addAttribute("color",	new BufferAttribute(color, 3));
		
		//これにcubeMaterialを渡す
		
		
		
	}
	
}