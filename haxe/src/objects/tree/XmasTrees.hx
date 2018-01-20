package objects.tree;
import three.Mesh;
import three.MeshBasicMaterial;
import three.Object3D;
import three.SphereGeometry;

/**
 * ...
 * @author 
 */
class XmasTrees extends Object3D
{

	private var _mat1:MeshBasicMaterial;
	private var _mat2:MeshBasicMaterial;
	
	private var _geo:SphereGeometry;
	
	private var _meshes:Array<Mesh> = [];
	private var _flag:Bool = false;
	
	public function new() 
	{
		super();
	}
	
	public function init():Void{
		
		_mat1 = new MeshBasicMaterial({color:0xff0000});
		_mat2 = new MeshBasicMaterial({color:0x008800});
		_geo = new SphereGeometry(100, 10, 10);
		
		_meshes = [];
		for (i in 0...20){
			var m:Mesh = new Mesh(_geo, i % 2 == 0 ? _mat1 : _mat2);
			
			m.position.x = 2000 * (Math.random() - 0.5);
			m.position.y = 2000 * (Math.random());
			m.position.z = 2000 * (Math.random());
			
			add(m);
			_meshes.push(m);
		}
		
		
	}
	
	public function beat():Void{
		
		if(_flag){
			_mat1.color.setHex(0xff0000);
			_mat2.color.setHex(0x008800);
		}else{
			_mat1.color.setHex(0x008800);
			_mat2.color.setHex(0xff0000);
		}
		_flag = !_flag;
	}
	
	
}