package objects.bg;
import data.ImageManager;
import three.ImageUtils;
import three.MeshBasicMaterial;

/**
 * ...
 * @author 
 */
class BgPlaneMatLow extends MeshBasicMaterial
{

	public function new() 
	{
		super(
			{
				map: ImageManager.getInstance().loadTexure( "./img/low/bg.png" ),
				side:Three.DoubleSide
			}
		);
	}
	
}