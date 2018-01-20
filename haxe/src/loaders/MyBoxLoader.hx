package loaders ;
import three.Geometry;
import three.ImageUtils;
import three.Mesh;
import three.MeshBasicMaterial;
import three.MeshLambertMaterial;
import three.Vector3;
/**
 * ...
 * @author nab
 */
class MyBoxLoader extends MyDAELoader
{
	
	//private var _callback:Void->Void;
	//private var _cubecamera:CubeCamera;
	public var meshes:Array<Mesh>;
	
	//public var dae:Object3D;
	public var geos:Array<Geometry>;
	public var mat:MeshLambertMaterial;
	//public var baseGeo:Array<Vector3>;
	
	private var scale:Float = 100;
	
	
	public function new() 
	{
		super();
	}

	override public function load(filename:String,callback:Void->Void):Void {
		
		_callback = callback;
		var loader = untyped __js__("new THREE.ColladaLoader()");
		loader.options.convertUpAxis = true;		
		//loader.load( 'cat/test_cat.dae', _onComplete );
		loader.load( filename, _onComplete );
		
	}
	
	
	
	override private function _onComplete(ret):Void 
	{
		
		var dae:Dynamic = ret.scene;
		mat = new MeshLambertMaterial({
		
		//var mm:MeshPhongMaterial = new MeshPhongMaterial({
			//map :			ImageUtils.loadTexture( "./obj/box/box.jpg"),
			color:			0xff0000,
			ambient:		0xffffff,
			side:			Three.DoubleSide
			//specularMap:	ImageUtils.loadTexture( "./cat/cat_norm.jpg"),
			//normalMap: 		ImageUtils.loadTexture( "./cat/cat_spec.jpg"),
			///skinning : false,
			//depthWrite: true,
			//depthTest: true
		});
		mat.shading = Three.SmoothShading;
		mat.alphaTest = 0.9;
		//mm.shininess = 1;// shiness = 0;
		
		
		meshes = [];
		geos = [];
		untyped __js__("
			var hoge = this;
			dae.traverse( function(child){
				if( child instanceof THREE.Mesh){
					child.material = hoge.mat;
					hoge.geos.push(child.geometry);
					hoge.meshes.push(child);
				}
			});
		");
			
		Tracer.info("____");
		Tracer.info( geos[0] );
		
		if (_callback != null) {
			_callback();
		}
		
	}

	
	
	
	
}