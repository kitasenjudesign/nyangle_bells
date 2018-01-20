package ;

import js.Browser;
import net.badimon.five3D.typography.GenTypography3D;
import three.ExtrudeGeometry;
import three.Geometry;
import three.Mesh;
import three.Path;
import three.Shape;
import three.ShapeGeometry;

/**
 * ...
 * @author nab
 */

//@:expose("FontShapeMaker")
class FontShapeMaker
{

	//public static var src:Map<String, ShapeGeometry>;
	public static var font:GenTypography3D;
	#if debug
	//private static var _test3d:Test3d;
	#end
	
	static function main() 
	{
		new FontShapeMaker();
	}
	
	public function new() {
		//Browser.window.onload = _test;
	}
	
	public function add(m:Mesh):Void
	{
		#if debug			 
			/*
			if(_test3d==null){
				_test3d = new Test3d();
				_test3d.init();
			}
			_test3d.add(m);
			*/
		
		#else
			trace("このメソッドはdebugじゃないと動作しないよ");
		#end
		
		
	}
	
	public function remove(m:Mesh):Void
	{
		#if debug			 
			/*
			if(_test3d==null){
				_test3d = new Test3d();
				_test3d.init();
			}
			_test3d.remove(m);
			*/
		#else
			trace("このメソッドはdebugじゃないと動作しないよ");
		#end
		
	}
	
	
	
	
	
	
	
	
	
	
	public function init(json:String,callback:Void->Void):Void {
		
		//src = new Map();
		font = new GenTypography3D();
		if(callback==null){
			font.initByString(json);
		}else {
			font.init(json,callback);//url
		}
	}
	

	public function getWidth(moji:String):Float {
		return font.getWidth(moji);
	}
	
	public function getHeight():Float {
		return font.getHeight();
	}
	
	public function getGeometry(
		moji:String,
		isCentering:Bool = true
	):Geometry {

		var shapes:Array<Shape>=getShapes( moji, isCentering );
			
		//var geo:ExtrudeGeometry = new ExtrudeGeometry(
		//	untyped shapes, { amount:15, bevelEnabled:false }
		//);
		var geo:ShapeGeometry = new ShapeGeometry(shapes, { } );
		
		return geo;
	}
	
	public function getShapes(
		moji:String,
		isCentering:Bool = false
	):Array<Shape> {

			var scale:Float = 1;
			var shapes:Array<Shape> = [];
			
			var shape:Shape = null;
			var g:Path = null;//shape or path
			
			var motif:Array<Dynamic> = font.motifs.get(moji);
			var ox:Float = 0;
			var oy:Float = 0;
			var s:Float = scale;
			
			if (isCentering) {
				ox = -font.widths.get(moji) / 2;
				oy = -font.height / 2;
			}
			
			var len:Int = motif.length;
			
			for (i in 0...len) {
				
				var tgt:String = motif[i][0];
				if (tgt == "M" || tgt=="H") {
					
					
					if (tgt == "H") {
						g = new Path();
						shape.holes.push(untyped g);
					}else {
						shape = new Shape();
						//shape.createPointsGeometry
						shapes.push(shape);
						g = shape;
					}
					
					g.moveTo(s * (motif[i][1][0] + ox), -s * (motif[i][1][1] + oy));
					
				}else if( tgt=="L" ){
					g.lineTo(s * (motif[i][1][0] + ox), -s * (motif[i][1][1] + oy));
					
				}else if (tgt == "C") {
					
					g.quadraticCurveTo(
						s * (motif[i][1][0] + ox),
						-s * (motif[i][1][1] + oy),
						s * (motif[i][1][2] + ox),
						-s * (motif[i][1][3] + oy)
					);
					
				}
			}
			
			
			return shapes;
			
		}
	
}