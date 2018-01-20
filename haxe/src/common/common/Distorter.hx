package common;
import three.Vector2;
import three.Vector3;

/**
 * ...
 * @author nabe
 */
class Distorter
{

	public var p0:Vector3;
	public var p1:Vector3;
	public var p2:Vector3;
	public var p3:Vector3;
	
	
	public function new() 
	{
		
	}
	
	/**
	 * 
	 * @param	ir 0-1
	 * @param	jr 0-1
	 * @return
	 */
	public function getPoint(ir:Float,jr:Float):Vector2 {
	
		if (ir > 1) ir = 1;
		if (jr > 1) jr = 1;
		if (ir < 0) ir = 0;
		if (jr < 0) jr = 0;
		
		var vv:Vector2 = _getCrossPoint(
			ir, jr, p0, p1, p2, p3
		);
		return vv;
		
	}
	
	
	function _getCrossPoint(ir:Float, jr:Float, a:Vector3, b:Vector3, c:Vector3, d:Vector3):Vector2
	{
		//４ペン上の　ある比率の点を求める
		var P1:Vector2 = _getHokanPoint(a, b, ir);
		var P2:Vector2 = _getHokanPoint(b, c, jr);
		var P3:Vector2 = _getHokanPoint(d, c, ir);
		var P4:Vector2 = _getHokanPoint(a, d, jr);
		
		//中点を求める
		var S1:Float = ((P4.x-P2.x)*(P1.y-P2.y)-(P4.y-P2.y)*(P1.x-P2.x))*0.5;
		var S2:Float = ((P4.x-P2.x)*(P2.y-P3.y)-(P4.y-P2.y)*(P2.x-P3.x))*0.5;
		
		var outX:Float = P1.x + (P3.x-P1.x)*(S1/(S1 + S2));
		var outY:Float = P1.y + (P3.y-P1.y)*(S1/(S1 + S2));
		
		return new Vector2(outX, outY);
	}
	
	
	/*
	private function _getPoint(i:Int, j:Int):Vector3 {
	
		var index:Int = j * (segX + 1) + i % (segX + 1);
		var vertex:Vector3 = p.geometry.vertices[index];
		return vertex;
		
	}
	
	//
	private function _setPoint(i:Int, j:Int, v:Vector3):Vector3 {
		
		var index:Int = j * (segX + 1) + i % (segX + 1);
		var vertex:Vector3 = p.geometry.vertices[index];
		vertex.x = v.x;
		vertex.y = v.y;
		vertex.z = v.z;
		return vertex;
		
	}*/
	
	
	private function _getHokanPoint(pA:Vector3,pB:Vector3,r:Float):Vector2 {
		
		var out:Vector2 = new Vector2();
		out.x = pA.x * (1-r) + pB.x * (r); 
		out.y = pA.y * (1-r) + pB.y * (r);
		//out.z = pA.z * (1-r) + pB.z * (r);
		return out;
		
	}
		
	
	
}