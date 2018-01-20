package menu;
import haxe.Timer;
import three.BoxGeometry;
import three.Color;
import three.Material;
import three.Mesh;
import three.MeshBasicMaterial;
import three.Object3D;
import three.PlaneGeometry;
import three.Vector3;

/**
 * ...
 * @author nabe
 */
class DistortPlane extends Object3D
{

	private var segX:Int = 12;
	private var segY:Int = 12;
	public var p:Mesh;
	public var pOver:Mesh;
	private var cnt:Int = 0;
	private var _boxes:Array<Mesh>;
	private var _index:Int;
	
	public var p0:Vector3;
	public var p1:Vector3;
	public var p2:Vector3;
	public var p3:Vector3;
	
	
	public function new(mate:Material, pSegX:Int=3,pSegY:Int=3,idx:Int=0) 
	{
		segX = pSegX;
		segY = pSegY;
		_index = idx;
		super();
		
		
		p = new Mesh(
			new PlaneGeometry(200, 200, segX, segY),
			mate
			//new MeshBasicMaterial({color:0xff0000,wireframe:true})
		);
		
		pOver = new Mesh(
			p.geometry,
			new MeshBasicMaterial({color:0xffffff,transparent:true,shading:Three.FlatShading})
		);
		pOver.visible = false;
		pOver.position.z = 10;
		Timer.delay( _onAdd, 1500);
		
		add(p);
		p.name = "" + _index;
		p.frustumCulled = false;

		update(
			new Vector3( -300, 400),
			new Vector3( 300, 300),
			new Vector3( 300+300, -300),
			new Vector3( -300, -300)
		);
	}
	
	private function _onAdd():Void
	{
		add(pOver);
	}
	
	/*
	public function init():Void {
		update(
			new Vector3( -300, -400),
			new Vector3( 300, -300),
			new Vector3( 300+300, 300),
			new Vector3( -300, 300)
		);
	}*/
	
	
	
	
	public function update(pA:Vector3, pB:Vector3, pC:Vector3, pD:Vector3):Void {
		_update4points(pA,pB,pC,pD);
		_updateOthrePoints();		
		p.geometry.verticesNeedUpdate = true;
		
	}
	
	
	//指定の４点を決める
	private function _update4points(pA:Vector3, pB:Vector3, pC:Vector3, pD:Vector3):Void {
		p0 = _setPoint(0, 0, pA);
		p1 = _setPoint(segX, 0, pB);
		p2 = _setPoint(segX, segY, pC);
		p3 = _setPoint(0, segY, pD);
	}
	
	//それに合わせて内部を計算しなおす
	private function _updateOthrePoints():Void {
		
		for ( i in 0...segX+1) {
			for ( j in 0...segY+1) {
				
				var ir:Float = i / (segX);
				var jr:Float = j / (segY);
				var vv:Vector3 = _getCrossPoint(
					ir, jr, p0, p1, p2, p3
				);
				
				/*
				if (i == 0 && j == 0) {
					vv = p0;
				}
				if (i == segX && j == 0) {
					vv = p1;					
				}
				if (i == segX && j == segY) {
					vv = p2;					
				}
				if (i == 0 && j == segY) {
					vv = p3;					
				}*/
				
				var index:Int = j * (segX + 1) + i % (segX + 1);
				var vertex:Vector3 = p.geometry.vertices[index];
				
				//if(vv.length() !=0){
					vertex.x = vv.x;
					vertex.y = vv.y;
					vertex.z = vv.z;
				//}
			}
		}		
	}
	
	function _getCrossPoint(ir:Float, jr:Float, a:Vector3, b:Vector3, c:Vector3, d:Vector3) 
	{
		//４ペン上の　ある比率の点を求める
		var P1:Vector3 = _getHokanPoint(a, b, ir);
		var P2:Vector3 = _getHokanPoint(b, c, jr);
		var P3:Vector3 = _getHokanPoint(d, c, ir);
		var P4:Vector3 = _getHokanPoint(a, d, jr);
		
		//中点を求める
		var S1:Float = ((P4.x-P2.x)*(P1.y-P2.y)-(P4.y-P2.y)*(P1.x-P2.x))*0.5;
		var S2:Float = ((P4.x-P2.x)*(P2.y-P3.y)-(P4.y-P2.y)*(P2.x-P3.x))*0.5;
		
		var outX:Float = P1.x + (P3.x-P1.x)*(S1/(S1 + S2));
		var outY:Float = P1.y + (P3.y-P1.y)*(S1/(S1 + S2));

		
		return new Vector3(outX, outY, 0);
	}
	
	
	//
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
		
	}
	
	
	private function _getHokanPoint(pA:Vector3,pB:Vector3,r:Float):Vector3 {
		
		var out:Vector3 = new Vector3();
		out.x = pA.x * (1-r) + pB.x * (r); 
		out.y = pA.y * (1-r) + pB.y * (r);
		out.z = pA.z * (1-r) + pB.z * (r);
		return out;
		
	}
	
	
	
	
}