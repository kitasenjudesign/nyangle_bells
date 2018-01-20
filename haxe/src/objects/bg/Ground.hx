package objects.bg;
import three.Mesh;
import three.MeshBasicMaterial;
import three.MeshLambertMaterial;
import three.Object3D;
import three.PlaneGeometry;

/**
 * ...
 * @author 
 */
class Ground extends Mesh
{

	public function new() 
	{
		super(new PlaneGeometry(20000, 20000, 10, 10), new MeshLambertMaterial({color:0xffffff,emissive:0x888888}));
		rotation.x = -Math.PI / 2;
		receiveShadow = true;
	}
	
}