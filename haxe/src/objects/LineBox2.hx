package objects;
import three.BoundingBoxHelper;
import three.Geometry;
import three.Line;
import three.LineBasicMaterial;
import three.Mesh;
import three.Object3D;
import three.Vector3;

/**
 * ...
 * @author watanabe
 */
class LineBox2 extends Object3D
{

	private static var _geo:Geometry;
	private static var _mat:LineBasicMaterial;
	
	private static var W:Float = 50;
	
	private static var T1:Vector3 = new Vector3(W,W,W );
	private static var T2:Vector3 = new Vector3(W,W,-W );
	private static var T3:Vector3 = new Vector3(-W,W,-W );
	private static var T4:Vector3 = new Vector3(-W,W,W );

	private static var B1:Vector3 = new Vector3(W,-W,W );
	private static var B2:Vector3 = new Vector3(W,-W,-W );
	private static var B3:Vector3 = new Vector3(-W,-W,-W );
	private static var B4:Vector3 = new Vector3(-W,-W,W );
	
	
	public function new() 
	{
		
		super();
	}
	
	public function init():Void {
		
		if (_geo == null) {
			
			
			_mat = new LineBasicMaterial( { color:0xddaa33,linewidth:2} );
			_geo = new Geometry();

			_geo.vertices.push(T1);
			_geo.vertices.push(T2);
			_geo.vertices.push(T3);
			_geo.vertices.push(T4);
			_geo.vertices.push(T1);

			_geo.vertices.push(B1);
			_geo.vertices.push(B2);
			_geo.vertices.push(B3);
			_geo.vertices.push(B4);
			_geo.vertices.push(B1);
			
			_geo.vertices.push(B2);
			_geo.vertices.push(T2);
			_geo.vertices.push(B2);
			
			_geo.vertices.push(B3);
			_geo.vertices.push(T3);
			_geo.vertices.push(B3);
			
			_geo.vertices.push(B4);
			_geo.vertices.push(T4);
			_geo.vertices.push(B4);

		}
		
		
		
		var line:Line = new Line(_geo, _mat);
		add(line);
	}
	
}