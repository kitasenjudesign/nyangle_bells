package objects;
import three.Geometry;
import three.Line;
import three.LineBasicMaterial;
import three.Object3D;
import three.Vector3;

/**
 * ...
 * @author watanabe
 */
class LongCatsWaku extends Object3D
{

	private var _line:Line;
	
	public function new() 
	{
		super();
	}
	
	public function init():Void {

		var geo:Geometry = new Geometry();
		var m:LineBasicMaterial = new LineBasicMaterial( { color:0xddaa33,linewidth:2 } );

		var w:Float = 330;
		geo.vertices.push(new Vector3(w, 0, w));
		geo.vertices.push(new Vector3(w, 0, -w));
		geo.vertices.push(new Vector3(-w, 0, -w));
		geo.vertices.push(new Vector3(-w, 0, w));
		geo.vertices.push(new Vector3(w, 0, w));
		
		
		
		_line = new Line(geo, m);
		add(_line);
		
		
		
		
	}
	
}