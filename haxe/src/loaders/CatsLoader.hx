package loaders;
import three.ExtrudeGeometry;
import three.Material;
import three.Mesh;
import three.MeshBasicMaterial;
import three.MeshFaceMaterial;
import three.Object3D;
import three.Shape;
import three.Vector3;

/**
 * ...
 * @author watanabe
 */
class CatsLoader extends Object3D
{

	public var head		:MyCATLoader;
	public var hip		:MyCATLoader;
	public var body		:MyCATLoader;
	public var circle	:MyCATLoader;
	public var tail		:MyCATLoader;
	
	private var _callback:Void->Void;
	
	public function new() 
	{
		super();
	}
	
	public function load(callback:Void->Void):Void {
		
		_callback = callback;
		
		head 	= new MyCATLoader();
		hip 	= new MyCATLoader();
		body 	= new MyCATLoader();
		//circle  = new MyCATLoader();
		//tail	= new MyCATLoader();
		
		head.load("./obj/cat/head1.dae",_onLoad1);
	}
	
	function _onLoad1() 
	{
		hip.load("./obj/cat/hip1.dae", _onLoad2);
	}
	
	function _onLoad2() 
	{
		body.load("./obj/cat/body1.dae", _onLoad3);
	}

	function _onLoad3() 
	{
		_onLoad4();
		//circle.load("./obj/cat/circle.dae", _onLoad4);
	}
	
	
	function _onLoad4() 
	{		
		
		/*
		var materials:Array<Material> = [
			new MeshBasicMaterial({color: 0xff0000,wireframe:true}),
			new MeshBasicMaterial({color: 0x00ff00,wireframe:true})
		];
		var extrudeMaterial:MeshFaceMaterial = new MeshFaceMaterial(materials);
		
		var shape:Shape = new Shape();
		
		for (i in 0...circle.baseGeo.length) {
			var vv:Vector3 = circle.baseGeo[i];
			if (i == 0) {
				shape.moveTo(vv.x,vv.z);
			}else {
				shape.lineTo(vv.x,vv.z);			
			}
		}
		
		var g:ExtrudeGeometry = new ExtrudeGeometry(shape, { steps:10, amount:10, bevelEnabled:false,material: 0, extrudeMaterial: 1} );
			
		var extrudeMesh:Mesh = new Mesh(
			g, 
			extrudeMaterial
		);
		extrudeMesh.scale.set(100, 100, 100);
		add(extrudeMesh);
		*/
		
		
		
		if (_callback != null) {
			_callback();
		}
	}
	
}