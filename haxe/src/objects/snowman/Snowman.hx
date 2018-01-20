package objects.snowman;
import three.Geometry;
import three.Matrix4;
import three.Mesh;
import three.MeshBasicMaterial;
import three.MeshLambertMaterial;
import three.Object3D;
import three.SphereBufferGeometry;
import three.SphereGeometry;

/**
 * ...
 * @author 
 */
class Snowman extends Object3D
{

	//private var _geo1:SphereBufferGeometry;
	//private var _geo2:SphereBufferGeometry;
	
	private static var _geo:Geometry; 
	private static var _mat:MeshLambertMaterial;
	
	public function new() 
	{
		//var g:SphereBufferGeometry = new SphereBufferGeometry(5000, 15, 15);
		super();
	}
	
	public function init():Void{
				
		if( _geo == null ){
		
			_geo = new Geometry();
			var g1:SphereGeometry = new SphereGeometry(100, 10, 10);
			var g2:SphereGeometry = new SphereGeometry(70, 10, 10);
			
			var m:Matrix4 = new Matrix4();
			m.makeTranslation(0, 100, 0);
			_geo.merge(g1);
			_geo.merge(g2, m);
			
			_mat = new MeshLambertMaterial({color:0xffffff,ambient:0xffffff,emissive:0x888888});
			
		}
			
		var m:Mesh = new Mesh(_geo, _mat); 
		m.castShadow = true;
		add(m);
				
			
	}
	
	
	
	
	
	
}