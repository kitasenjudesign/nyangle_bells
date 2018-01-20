package objects.cat;
import data.DataManager;
import three.BoxGeometry;
import three.Geometry;
import three.Mesh;
import three.MeshLambertMaterial;
import three.Object3D;
import tween.TweenMax;

/**
 * ...
 * @author 
 */
class GiftBox extends Object3D
{

	private var _top	:Mesh;
	private var _bottom	:Mesh;
	
	private static var _geo1	:Geometry;
	private static var _geo2	:Geometry;
	private static var _mat	:MeshLambertMaterial;
	
	
	
	
	public function new() 
	{
		
		super();
		
		if (_mat == null){
			
			_mat = DataManager.getInstance().box.mat;
			_geo1 = DataManager.getInstance().box.geos[0];
			_geo2 = DataManager.getInstance().box.geos[1];
			
		}
		
		
		_top = new Mesh(_geo1, _mat);
		
		_bottom = new Mesh(_geo2, _mat);
		
		_bottom.castShadow = true;
		
		add(_top);
		add(_bottom);
		
		reset();
		
		//castShadow = true;
	}
	
	
	public function open():Void{
		
		TweenMax.to(_top.position, 0.5, {
			x:200* ( Math.random()-0.5 ),
			y:_top.position.y + 300 + 200 * Math.random()
		});
		TweenMax.to(_top.rotation, 0.5, {
			x:Math.random() * 2 * Math.PI,
			y:Math.random() * 2 * Math.PI,
			z:Math.random() * 2 * Math.PI			
		});
		
	}
	
	public function reset():Void{
		
		var ss:Float = 0.5;
		
		_top.scale.set(ss, ss, ss);
		_top.rotation.set(0, 0, 0);
		_top.position.x = 0;
		_top.position.y = 110 * ss;
		_bottom.scale.set(ss, ss, ss);		
		
	}
	
	
}