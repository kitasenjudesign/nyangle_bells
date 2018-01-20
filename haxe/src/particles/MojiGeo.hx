package particles;
import data.DataManager;
import js.Browser;
import js.html.Uint32Array;
import three.BoxGeometry;
import three.BufferGeometry;
import js.html.Float32Array;
import js.html.Uint16Array;
import three.BufferAttribute;
import three.Geometry;
import three.PlaneGeometry;
import three.SphereGeometry;
import utils.MojiGeoGetter;
/**
 * ...
 * @author 
 */
class MojiGeo extends BufferGeometry
{

	public function new( geo:Geometry, scale:Float, num:Int ) 
	{
		
		super();
		// BufferGeometryを生成
		//var geometry = new BufferGeometry();

		// 平面用の頂点を定義
			// d - c
			// |   |
			// a - b
		//var scale:Float = 0.5;
		
		//var geo:Geometry = MojiGeoGetter.getGeo();
		//var geo:Geometry = DataManager.getInstance().moji.geos[0];
		//var geo:SphereGeometry = new SphereGeometry(100,10,10);
		//var geo:BoxGeometry = new BoxGeometry(100,1,1,1);
		//var geo:PlaneGeometry = new PlaneGeometry(100, 100, 1, 1);
		
		
		var vertexPositions:Array<Array<Float>> = [];
		for (i in 0...geo.vertices.length){
			vertexPositions.push(
				[
					geo.vertices[i].x * scale,
					geo.vertices[i].y * scale,
					geo.vertices[i].z * scale
				]
			);
		}
		

		var normals:Float32Array = new Float32Array(vertexPositions.length * 3 * num);
		
		// Typed Arrayで頂点データを保持
		var vertices:Float32Array = new Float32Array(vertexPositions.length * 3 * num);
		
		
		var random:Float32Array = new Float32Array(vertexPositions.length * 3 * num);
		
		//color
		var color:Float32Array = new Float32Array(vertexPositions.length * 3 * num);
		
		
		var indices:Uint32Array = new Uint32Array( (geo.faces.length*3) * num );

		//個数分
		var ids:Float32Array = new Float32Array( vertexPositions.length * num ); 
		
		
		var pointsLen:Int = vertexPositions.length;
		
		//Browser.window.alert( ""+pointsLen );
		
		
		
		
		for(j in 0...num){
			
			//numこぶん、せいせい
			
			var xx:Float = 2*(Math.random()-0.5);
			var yy:Float = 2*(Math.random()-0.5);
			var zz:Float = 2*(Math.random()-0.5);
			
			var rr:Float = 0;// Math.random() < 0.5 ? 1 : 0;
			var gg:Float = 1;// Math.random() < 0.5 ? 1 : 0;
			var bb:Float = 0;
			
			var ss:Float = 1.0;
			
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
				
				//normals[ j*( pointsLen * 3 ) + i * 3 + 0] = 0.0;
				//normals[ j*( pointsLen * 3 ) + i * 3 + 1] = 0.0;
				//normals[ j*( pointsLen * 3 ) + i * 3 + 2] = 0.5;
				
				ids[ j * pointsLen + i ] = Math.floor( j / (num*0.1) );
			}
			
			
		}
		
		var numFace:Int = geo.faces.length;
		for(j in 0...num){
			for (i in 0...numFace){
				
				indices[ j * numFace * 3 + i * 3 + 0 ] = cast ( j*( pointsLen ) + geo.faces[i].a );
				indices[ j * numFace * 3 + i * 3 + 1 ] = cast ( j*( pointsLen ) + geo.faces[i].b );
				indices[ j * numFace * 3 + i * 3 + 2 ] = cast ( j*( pointsLen ) + geo.faces[i].c );
				
				normals[ cast (j * ( pointsLen ) + geo.faces[i].a) * 3 + 0 ] = geo.faces[i].vertexNormals[0].x;
				normals[ cast (j * ( pointsLen ) + geo.faces[i].a) * 3 + 1 ] = geo.faces[i].vertexNormals[0].y;
				normals[ cast (j * ( pointsLen ) + geo.faces[i].a) * 3 + 2 ] = geo.faces[i].vertexNormals[0].z;
				
				normals[ cast (j * ( pointsLen ) + geo.faces[i].b) * 3 + 0 ] = geo.faces[i].vertexNormals[1].x;
				normals[ cast (j * ( pointsLen ) + geo.faces[i].b) * 3 + 1 ] = geo.faces[i].vertexNormals[1].y;
				normals[ cast (j * ( pointsLen ) + geo.faces[i].b) * 3 + 2 ] = geo.faces[i].vertexNormals[1].z;
				
				normals[ cast (j * ( pointsLen ) + geo.faces[i].c) * 3 + 0 ] = geo.faces[i].vertexNormals[2].x;
				normals[ cast (j * ( pointsLen ) + geo.faces[i].c) * 3 + 1 ] = geo.faces[i].vertexNormals[2].y;
				normals[ cast (j * ( pointsLen ) + geo.faces[i].c) * 3 + 2 ] = geo.faces[i].vertexNormals[2].z;
				
			}
		}
		
		//Tracer.info("------vert");
		//Tracer.info(vertices);
		//Tracer.info("------idx");		
		//Tracer.info(indices);//4		
		
		
		// attributesを追加
		addAttribute("position",	new BufferAttribute(vertices, 3));/////////
		addAttribute("index",   	new BufferAttribute(cast indices,  1));/////////
		addAttribute("normal",	 	new BufferAttribute(normals, 3));//////////
		addAttribute("random",		new BufferAttribute(random, 3));
		addAttribute("color",		new BufferAttribute(color, 3));		
		
		addAttribute("idd",   		new BufferAttribute(cast ids,  1));/////////
		
	}
	
}