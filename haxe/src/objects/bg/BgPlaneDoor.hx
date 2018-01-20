package objects.bg;
import data.Quality;
import three.Material;
import three.Mesh;
import three.MeshBasicMaterial;
import three.PlaneGeometry;

/**
 * ...
 * @author 
 */
class BgPlaneDoor extends Mesh
{

	//private var _geo:PlaneGeometry;
	private var _mat	:BgPlaneMat;
	private var _matLow	:BgPlaneMatLow;
	
	public function new() 
	{
		var geo:PlaneGeometry = new PlaneGeometry(6000, 6000, 1, 1);
		var mat:Material;
		
		if(Quality.HIGH){
			mat = _mat = new BgPlaneMat();
		}else{
			mat = new BgPlaneMatLow();
		}
		
		super(
			geo, mat
		);
	}
	
	public function update():Void{
		
		if ( _mat != null){
			_mat.update();
		}
		
	}
	
	public function resize():Void{
		
	}
	
}