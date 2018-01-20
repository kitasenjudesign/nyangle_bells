package ;
import three.Path;
import three.Shape;
import net.badimon.five3D.typography.Typography3D;

/**
 * ...
 * @author nab
 */
class FontTest
{

	public function new() 
	{
		
	}

	public static function getLetterPoints(
		g:Dynamic,
		moji:String,
		isCentering:Bool = false,
		scale:Float = 1,
		letter:Typography3D = null
	):Shape {


			var shape:Shape = g;
			var motif:Array<Dynamic> = letter.motifs.get(moji);
			var ox:Float = 0;
			var oy:Float = 0;
			var s:Float = scale;
			
			if (isCentering) {
				ox = -letter.widths.get(moji) / 2;
				oy = -letter.height / 2;
			}
			
			var len:Int = motif.length;
			trace(len);
			var count:Int = 0;
			for (i in 0...len) {
				
				var tgt:String = motif[i][0];
				if (tgt == "M") {
					if (count >= 1) {
						g = new Path();
						shape.holes.push(untyped g);
					}
					g.moveTo(s * (motif[i][1][0] + ox), -s * (motif[i][1][1] + oy));
					count++;
					
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
			
			
			return shape;
			
		}
	
}