package loaders ;

import three.Geometry;
import three.ImageUtils;
import three.Material;
import three.MeshBasicMaterial;
import three.Object3D;
import three.Vector3;
/**
 * ...
 * @author nab
 */
class MyDAELoader
{
	
	private var _callback:Void->Void;
	public var materialB:MeshBasicMaterial;
	public var materialC:MeshBasicMaterial;
	public var materialD:MeshBasicMaterial;
	
	public var dae:Object3D;
	public var geometry:Geometry;
	public var material:Material;
	public var baseGeo:Array<Vector3>;
	
	
	public function new() 
	{
		
	}

	public function load(filename:String,callback:Void->Void):Void {
		
		_callback = callback;
		
		var loader = untyped __js__("new THREE.ColladaLoader()");
		loader.options.convertUpAxis = true;		
		loader.load( filename, _onComplete );
		
	}
	
	
	
	private function _onComplete(collada):Void 
	{
		
		dae = collada.scene;
		dae.scale.x = dae.scale.y = dae.scale.z =170;
	
		material = new MeshBasicMaterial( { map:ImageUtils.loadTexture("mae_face_.png"), side:Three.FrontSide } );
		materialB = new MeshBasicMaterial( { map:ImageUtils.loadTexture("mae_face_blue.png"), side:Three.FrontSide } );
		materialC = new MeshBasicMaterial( { map:ImageUtils.loadTexture("mae_faceB.png"), side:Three.FrontSide } );
		materialD = new MeshBasicMaterial( { map:ImageUtils.loadTexture("mae_face_mono.png"), side:Three.FrontSide } );

		//material = new MeshBasicMaterial( { map:untyped dae.children[0].children[0].material.map, side:Three.DoubleSide } );
			
		/*
			var shape:Shape = new Shape();
			FontTest.getLetterPoints(shape, "A", true,0.03, new HelveticaMedium());
			var geo:ExtrudeGeometry = new ExtrudeGeometry(untyped shape, {amount:0.4,bevelEnabled:false} );
		*/
		
		geometry = untyped dae.children[0].children[0].geometry;
		geometry.verticesNeedUpdate = true;
		
		//konber
		
		_makeBaseGeo();
		
		if (_callback != null) {
			_callback();
		}
		
		//dispatchEvent(new Event("COMPLETE", true, true));
	}
	
	
	public static function getPosY(ratio:Float):Float {
	
		ratio = 1 - ratio;
		var maxY:Float = 1.36578;
		var minY:Float = -1.13318;
		return minY + (maxY - minY) * ratio;
	
	}
	
	public static function getRatioY(posY:Float,pow:Float,posR:Float):Float {
		
		var maxY:Float = 1.36578;
		var minY:Float = -1.13318;
		var r:Float = (posY - minY) / (maxY - minY);
		
		if (r < posR) {
			r = Math.pow(r, pow);
		}else {
			r = Math.pow(r, 1/pow);			
		}
		
		return r;
		
	}
	
	public static function getHeight(ratio:Float):Float {
	
		return (1.36578 + 1.13318) * ratio;
		
	}	
	
	
	private function _makeBaseGeo():Void {
		
		baseGeo = [];
		for (i in 0...geometry.vertices.length) {
			var v:Vector3 = geometry.vertices[i].clone();			
			baseGeo.push( v );
		}
		
	}
	
	
	
}