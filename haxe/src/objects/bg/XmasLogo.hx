package objects.bg;
import data.DataManager;
import three.Color;
import three.Geometry;
import three.Mesh;
import three.MeshLambertMaterial;
import three.Object3D;

/**
 * ...
 * @author 
 */
class XmasLogo extends Mesh
{

	private var _geo:Geometry;
	private var _mat:MeshLambertMaterial;
	
	private var colors:Array<Color> = [
		new Color(1,0,0),
		new Color(1,1,0),
		new Color(0,1,0),
		new Color(0,1,1),
		new Color(0,0,1),
		new Color(1,0,1)
	];
	
	private var _index:Int = 0;
	
	public function new(geo:Geometry) 
	{
		
		_geo = geo;// DataManager.getInstance().xmas.geos[0];
		_mat = new MeshLambertMaterial({color:0xff0000});
		
		super( _geo, _mat );
		
	}
	
	public function setColor() 
	{
		
		var tgt:Color = colors[ _index % colors.length  ];
		_index++;
		
		_mat.color.copy( tgt );
	}
	
}