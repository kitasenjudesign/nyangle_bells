package utils;
import data.DataManager;
import three.ExtrudeGeometry;
import three.Geometry;
import three.Matrix4;
import three.Shape;
import three.Vector3;

/**
 * ...
 * @author 
 */
class MojiGeoGetter 
{

	public function new() 
	{
		
	}

	public static function getGeo():Geometry{
		
		var _shape:FontShapeMaker = null;// DataManager.getInstance().fontShape;// new FontShapeMaker();
		
		var src:String = "NYAN";		
		var list:Array<String> = [];
		
		var space:Float = 140;
		var spaceY:Float = 250;
		
		var g:Geometry = new Geometry();
		
		
		for(j in 0...src.length){
			
			var shapes:Array<Shape> = _shape.getShapes(src.substr(j,1), true);
			var geo:ExtrudeGeometry = new ExtrudeGeometry(shapes, { bevelEnabled:false, amount:30 } );
			
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
		
		return g;
		
		
	}
	
	
}