package common;
import data.DataManager;
import loaders.MyDAELoader;
import three.BoxGeometry;
import three.ExtrudeGeometry;
import three.Geometry;
import three.Matrix4;
import three.Mesh;
import three.MeshBasicMaterial;
import three.MeshPhongMaterial;
import three.Object3D;
import three.Plane;
import three.Shape;
import three.Texture;
import three.Vector3;

/**
 * ...
 * @author watanabe
 */
class Mojis extends Object3D
{
	private var _shape:FontShapeMaker;
	private var _callback:Void->Void;
	//private var _mesh:Mesh;
	private var _material:MeshPhongMaterial;
	private var _meshes:Array<Mesh>;
	private var _loader:MyDAELoader;
	private var _face:Mesh;
	var _rad:Float=0;
	
	
	public function new() 
	{
		super();
	}
	
	public function init(callback:Void->Void):Void {
		
		_callback = callback;
		
		//_shape = DataManager.getInstance().fontShape;// new FontShapeMaker();
		//_shape.init("DINBold.json", _onInit0);
		
		this.scale.set(3, 3, 3);
		//this.visible = false;
	}

	
	private function _onInit0():Void {
		
		var src:String = "MERRY CHRISTMAS";		
		var list:Array<String> = [];
		
		var space:Float = 140;
		var spaceY:Float = 250;
		
		var g:Geometry = new Geometry();
		
		
		for(j in 0...src.length){
			
			var shapes:Array<Shape> = _shape.getShapes(src.substr(j,1), true);
			var geo:ExtrudeGeometry = new ExtrudeGeometry(shapes, { bevelEnabled:true, amount:30 } );
			
			var mat4:Matrix4 = new Matrix4();
			mat4.multiply( new Matrix4().makeScale(1, 1, 1) );
			var vv:Vector3 = 
				new Vector3( 
					(j * space - (src.length - 1) / 2 * space)*0.5, 
					0, 
				0);
			mat4.multiply( new Matrix4().makeTranslation(vv.x,vv.y,vv.z));
			g.merge(geo, mat4);
		}
		
		_material = new MeshPhongMaterial( { color:0xffff00 } );
		
		_meshes = [];
		for(i in 0...1){
			var m:Mesh = new Mesh(g, _material);
			m.castShadow = true;
			//m.receiveShadow = true;
			var rr:Float = Math.random() * 0.1;
			//m.scale.set(0.2 + rr, 0.2 + rr, 0.2 + rr);
			m.position.y += 60 * ( Math.random() - 0.5);
			//position.y = 100;
			add(m);
			_meshes.push(m);
		}
		
		
		/*
		var cube:Mesh = new Mesh(
			new BoxGeometry(400, 50, 50), 
			new MeshBasicMaterial( { color:0xffffff, wireframe:true,clippingPlanes:[p] } )
		);
		add(cube);*/
		
		if (_callback != null) {
			_callback();
		}
		
	}
	
	/**
	 * 
	 * @param	texture
	 */
	public function setEnvMap(texture:Texture) 
	{
		_material.envMap = texture;
	}
	
	public function update() 
	{
		
		for(i in 0..._meshes.length){
			_meshes[i].rotation.x += 0.001*(i+1); 
			_meshes[i].rotation.y += 0.003*(i+1);
			_meshes[i].rotation.z += 0.004*(i + 1);
		}
		
		//cube.rotation.x += 0.016;

	}
		
	
	
}