package objects;
import three.BoxGeometry;
import three.Mesh;
import three.MeshBasicMaterial;
import three.Object3D;
import three.Vector3;

/**
 * ...
 * @author watanabe
 */
class FlyingCat extends Object3D
{

	private var _callback:FlyingCat->Void;
	private var _startPos:Vector3;
	public var v:Vector3;
	public var cat:LongCat;
	//houbutsu sen
	
	public function new() 
	{
		super();
		cat = new LongCat();
		cat.init();
		add(cat);
		//koko
		
	}
	
	/**
	 * 
	 * @param	spos
	 * @param	callback
	 */
	public function start(spos:Vector3, scl:Float, callback:FlyingCat->Void):Void {
		
		/*
		var mesh:Mesh = new Mesh(new BoxGeometry(10, 10, 100), new MeshBasicMaterial({wireframe:true}));
		add(mesh);
		*/
		
		cat.setSize(20 + 20 * Math.random());
		cat.rotation.x = Math.PI / 2;
		cat.scale.set(scl, scl, scl);
		
		position.x = spos.x;
		position.y = spos.y;
		position.z = spos.z;
		
		_startPos = spos;
		_callback = callback;
		
		v = new Vector3();
		v.x = 20*(Math.random() - 0.5);
		v.y = 10 + 30 * Math.random();
		v.z = 20*(Math.random() - 0.5);
		
	}
	
	public function update():Void {

		lookAt(new Vector3(
			position.x + v.x,
			position.y + v.y,
			position.z + v.z			
		));
		
		
		position.x += v.x;
		position.y += v.y;
		position.z += v.z;
		
		
		v.y -= 0.5;
		
		if ( position.y < _startPos.y-200 ) {
			_callback(this);
		}
	}
	
	private function _remove():Void
	{
		
	}
}