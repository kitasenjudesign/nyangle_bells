package objects.cat;
import three.ConeGeometry;
import three.Mesh;
import three.MeshLambertMaterial;

/**
 * ...
 * @author 
 */
class CatHat extends Mesh
{

	private static var _geo:ConeGeometry;
	private static var _mat:MeshLambertMaterial;
	
	public function new() 
	{
		
		if( _geo == null ){
			_geo = new ConeGeometry(0.08, 0.3);
			_mat = new MeshLambertMaterial({color:0xff0000});
		}
		
		super(_geo, _mat);
		
	}
	
}