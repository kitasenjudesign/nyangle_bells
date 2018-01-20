package particles;
import js.html.Float32Array;
import js.html.Uint16Array;
import three.BufferAttribute;
import three.BufferGeometry;
import three.MeshLambertMaterial;

/**
 * ...
 * @author 
 */
class BasicParticlesGeo extends BufferGeometry
{

	public function new() 
	{
		super();
		// BufferGeometryを生成
		//var geometry = new BufferGeometry();

		// 平面用の頂点を定義
		// d - c
		// |   |
		// a - b
		var s:Float = 100;
		var vertexPositions:Array<Array<Float>> = [
			[-1.0*s, -1.0*s, 0.0*s], // a
			[ 1.0*s, -1.0*s, 0.0*s], // b
			[ 1.0*s,  1.0*s, 0.0*s], // c
			[-1.0*s,  1.0*s, 0.0*s]  // d
		];

		// Typed Arrayで頂点データを保持
		var vertices:Float32Array = new Float32Array(vertexPositions.length * 3);
		for ( i in 0...vertexPositions.length) {
			vertices[i * 3 + 0] = vertexPositions[i][0];
			vertices[i * 3 + 1] = vertexPositions[i][1];
			vertices[i * 3 + 2] = vertexPositions[i][2];
		}

		// 頂点インデックスを生成
		var indices:Uint16Array = new Uint16Array([
			0, 1, 2,
			2, 3, 0
		]);

		// attributesを追加
		addAttribute("position",	new BufferAttribute(vertices, 3));
		addAttribute("index",   	new BufferAttribute(indices,  1));
		//geometry.addAttribute("normal",	 	new BufferAttribute(normals, 3));
		
		
		
	}
	
}