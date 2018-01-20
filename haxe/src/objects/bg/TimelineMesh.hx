package objects.bg;
import data.Params;
import three.Color;
import three.Geometry;
import three.LineBasicMaterial;
import three.LineSegment;
import three.Mesh;
import three.Vector3;

/**
 * ...
 * @author 
 */
class TimelineMesh extends LineSegment
{

	private var _geo:Geometry;
	private var _mat:LineBasicMaterial;
	
	public function new() 
	{
		
		
		//5ko
		
		var geo:Geometry = new Geometry();
		
		var ww:Float = 2000;
		var dd:Float = Params.distance;
		
		geo.vertices.push( new Vector3(-ww/2,0,0) );
		geo.vertices.push( new Vector3(ww/2,0,0) );

		geo.vertices.push( new Vector3(-ww/2, 0, -dd/2 ));
		geo.vertices.push( new Vector3(ww/2,  0, -dd/2 ));
		geo.vertices.push( new Vector3(-ww/2, 0, dd/2 ));
		geo.vertices.push( new Vector3(ww/2,  0, dd/2 ));

		geo.vertices.push( new Vector3(-ww/2, 0, -dd/2 ));
		geo.vertices.push( new Vector3(-ww/2,  0, dd/2 ));
		geo.vertices.push( new Vector3(ww/2, 0, -dd/2 ));
		geo.vertices.push( new Vector3(ww/2,  0, dd/2 ));
		
		
		_mat = new LineBasicMaterial({color:0xffff00});
		
		super(geo,_mat);
		
		this.frustumCulled = false;
		
	}
	
	
	
	public function update(rr:Float):Void{
		
		var zz:Float = Params.distance * (rr - 0.5);
		
		zz = Math.floor( zz * 100 ) / 100;
		
		/*
		_mat.color.setRGB(
			Math.random() < 0.5 ? 1 : 0,
			Math.random() < 0.5 ? 1 : 0,
			Math.random() < 0.5 ? 1 : 0
		);*/
		
		this.geometry.vertices[0].z = zz;
		this.geometry.vertices[1].z = zz;
		this.geometry.verticesNeedUpdate = true;
	}
	
	
	public function setColor(col:Color):Void{
		
		_mat.color.r = col.r;
		_mat.color.g = col.g;
		_mat.color.b = col.b;
				
	}
	
	
}