package objects ;
import camera.ExCamera;
import common.Distorter;
import data.MyColors;
import js.Browser;
import js.html.Uint8Array;
import sound.MyAudio;
import three.BoxGeometry;
import three.Geometry;
import three.Mesh;
import three.MeshBasicMaterial;
import three.MeshPhongMaterial;
import three.Object3D;
import three.Vector2;
import three.Vector3;
/**
 * ...
 * @author nab
 */
class MyFace extends Object3D
{
	
	public var dae:Mesh;
	//public var dae2:Mesh;
	
	private var _base:Array<Vector3>;
	private var _count:Float = 0;
	
	private var _speed:Float = 0.01;
	private var _sphere:Float = 0.1;
	private var _nejireX:Float = 0.5;
	private var _nejireY:Float = 0;
	private var _noise:Float = 0.8;
	private var _noiseAmp:Float = 2;
	private var _noiseSpeed:Float = 0.1;
	private var _scaleX:Float = 1;
	private var _scaleY:Float = 1;
	
	public var _audio:MyAudio;
	
	var _vr:Float=0;
	public var gui:Dynamic;
	private var music:String = "";
	
	private var _idxNejireX:Int = 0;
	private var _idxNejireY:Int = 0;
	private var _idxNejireNoise:Int = 0;
	private var _idxSphereNoise:Int = 0;
	private var _idxSpeedNoise:Int = 0;
	

	private var _idxNoiseSpeed:Int = 0;
	private var _idxYokoRatio:Int = 0;
	private var _idxYokoSpeed:Int = 0;

	private var _idxPowY:Int = 0 ;
	private var _idxPowY2:Int = 0;
	private var _idxPowY3:Int = 0;
	
	private var _vx:Float = 0;
	private var _vy:Float = 0;
	private var _vz:Float = 0;

	private var p0:Mesh;	
	private var p1:Mesh;
	private var p2:Mesh;
	private var p3:Mesh;
	
	private var _nejiMasatsuX:Float = 0;
	private var _nejiMasatsuY:Float = 0;
	
	private var _distort:Distorter;
	var _yokoRatio:Float = 1;
	var _yokoSpeed:Float = 1;
	var _zengoRatio:Float = 1;
	var _daeLoader:MyDAELoader;
	
	var MODE_A:Int = 0;// = "MODE_A";
	var MODE_B:Int = 1;// = "b";
	var MODE_C:Int = 2;// = "c";
	
	public static var staricRot:Float = 0;
	var _mode:Int = 0;
	var _speedRotX:Float = -0.01;
	var _ran:Float=0;
	var _powY:Float=1;
	var _powY2:Float=1;
	
	public function new() 
	{
		super();
	}

	
	
	public function init(d:MyDAELoader):Void {
	
		setParams();

		_daeLoader = d;
		dae = new Mesh( d.geometry.clone(), d.material);
		dae.rotation.y = Math.PI / 2;
		//dae.scale.set(200, 200, 200);
		add(dae);
		
		_base = d.baseGeo;
		
		
		
		
		var gg:BoxGeometry = new BoxGeometry(4, 4, 4, 1, 1, 1);
		var mm:MeshBasicMaterial = new MeshBasicMaterial( { color:0xcccccc } );
		
		p0 = new Mesh(gg, mm);
		add(p0);
		p0.position.set( -300, 300, 0);		
		
		p1 = new Mesh(gg,mm);
		add(p1);
		p1.position.set( 300, 300, 0);
		
		p2 = new Mesh(gg, mm);
		add(p2);
		p2.position.set( 300, -300, 0);
		
		p3 = new Mesh(gg,mm);
		add(p3);
		p3.position.set( -300, -300, 0);
		
		
		//var cube:Mesh = new Mesh(new BoxGeometry(600,600, 600, 1,1,1), new MeshBasicMaterial( { color:0xffffff, wireframe:true,transparent:true,opacity:0.5 } ));
		//add(cube);
		
		
		_distort = new Distorter();
		_distort.p0 = p0.position;
		_distort.p1 = p1.position;
		_distort.p2 = p2.position;
		_distort.p3 = p3.position;
		
		//var v:Vector2 = _distort.getPoint(0, 0.1);
		//Browser.window.alert(v.x +" : " + v.y);
		
		
	}
	
	public function setParams():Void
	{
		_count = 500 * Math.random();
		
		_nejiMasatsuX = 0.83 + 0.16 * Math.random();
		_nejiMasatsuY = 0.83 + 0.16 * Math.random();
		
		_idxNejireX = Math.floor(Math.random() * 20 );
		_idxNejireY = Math.floor(Math.random() * 20 );
		_idxNejireNoise = Math.floor(Math.random() * 20 );
		_idxSphereNoise = Math.floor(Math.random() * 20 );
		_idxNoiseSpeed = Math.floor(Math.random() * 20 );
		_idxSpeedNoise = Math.floor(Math.random() * 20 );
		_idxYokoRatio = Math.floor( Math.random() * 20 );
		_idxPowY = Math.floor( Math.random() * 20 );
		_idxPowY2 = Math.floor( Math.random() * 20 );
		_idxPowY3 = Math.floor( Math.random() * 20 );
		
		_noiseAmp = 2 * Math.random();
		
	}
	

	
	
	
	private function _getNoise(xx:Float,yy:Float,zz:Float):Float
	{
		var f = untyped __js__("noise.perlin3");
		var n:Float = f(xx, yy, zz);
		return n;
	}
	
	public function forceRot(dx:Float, dy:Float, dz:Float):Void {
	
		_vx = dx;
		_vy = dy;
		_vz = dz;
		
	}
	
	public function setMode(mm:Int,ran:Float):Void {
	
		_ran = ran;
		_speedRotX = (ran - 0.5) * 0.05;
		_mode = mm;
		if (_mode == MODE_A) {
			this.rotation.set(0, ran*2*Math.PI, 0);
		}
		
	}
	
	
	public function update(audio:MyAudio,lines:Lines):Void {
		
		if (dae == null) return;
		
		
		
		if (_mode == MODE_A) {
			
			this.rotation.y += _speedRotX;
			
		}else if (_mode == MODE_B) {
			
			this.rotation.y += _vy;
			_vy *= 0.96;
			
		}else if (_mode == MODE_C) {
			
			this.rotation.x += _vx * 1.2;
			this.rotation.y += _vy;
			this.rotation.z += _vz;
			
			_vx *= 0.98;
			_vy *= 0.96;
			_vz *= 0.96;
		
		}
		/*
		switch(_mode) {
			case MODE_A:
				//this.rotation.x += _vx;
				this.rotation.y += 0.1;// Math.abs( _vy );
				//this.rotation.z += _vz;

			case MODE_B:
				trace("A");
				
			case MODE_C:
				trace("A");
				
		}*/
		
		
		
		_audio = audio;
		var g:Geometry = untyped dae.geometry;
		
		g.verticesNeedUpdate = true;
		_count += _speed;
		
		dae.rotation.y += _vr;
		
		_vr *= 0.95;
		
		if (_audio != null && _audio.isStart) {
			
			var freq:Uint8Array = _audio.freqByteData;
			
			_audio.update();
			
			if(freq.length>19){
			
				/*
				if (freq[10] > 50 ) {
				
					p0.position.x = -300 + 500 * (Math.random() - 0.5);
					p0.position.y = 300 + 500 * (Math.random() - 0.5);
					
					p1.position.x = 300 +500* (Math.random() - 0.5);
					p1.position.y = 300 +500* (Math.random() - 0.5);
					
					p2.position.x = 300 + 500 * (Math.random() - 0.5);
					p2.position.y = -300 + 500 * (Math.random() - 0.5);
					
					p3.position.x = -300 +500* (Math.random() - 0.5);
					p3.position.y = -300 +500* (Math.random() - 0.5);
					
				}*/
				
				_nejireX += Math.pow(freq[_idxNejireX] / 255, 1.5) * 0.3;// 10;
				_nejireY += Math.pow(freq[_idxNejireY] / 255, 2) * Math.PI * 0.3;// * 0.5;
				
				_nejireX *= _nejiMasatsuX;
				_nejireY *= _nejiMasatsuY;
				
				_noise = Math.pow(freq[_idxNejireNoise] / 255, 2) * (3.5 + _noiseAmp);
				_speed = 0.01+ Math.pow( freq[_idxSpeedNoise] / 255, 1.5) * 0.5;
				_sphere = Math.pow( freq[_idxSphereNoise]/255, 1.5);
				_noiseSpeed = 0.1 + Math.pow( freq[_idxNoiseSpeed] / 255, 1.5) * 0.05;
				
				_scaleX = 1 + Math.pow(freq[7] / 255, 1.5) * 0.5;
				_scaleY = 1 + Math.pow(freq[9] / 255, 1.5) * 0.5;
				//_scaleX += - Math.pow(freq[12] / 255, 1.5) * 0.5;
				//_scaleY += - Math.pow(freq[3] / 255, 1.5) * 0.5;
				
				_powY = 1 + Math.pow(freq[_idxPowY] / 255, 1.5);
				_powY2 = 1 + Math.pow(freq[_idxPowY2] / 255, 2) * 0.5 - Math.pow(freq[_idxPowY3] / 255, 2) * 0.5;
				
				
				_yokoRatio = Math.pow(freq[_idxYokoRatio] / 255, 2);
				_yokoSpeed = Math.pow(freq[_idxYokoSpeed] / 255, 2);
				
				
				lines.update( [
					freq[_idxNejireX]/255,
					freq[_idxNejireY]/255,
					freq[_idxNoiseSpeed]/255,
					freq[_idxYokoRatio]/255,
					freq[_idxYokoSpeed]/255
				] );
				
				/*
				_nejireX = Math.pow(freq[16] / 255, 3.5) * 10;
				_nejireY = Math.pow(freq[18] / 255, 5) * Math.PI * 2;// * 0.5;
				
				_noise = Math.pow(freq[12] / 255,3) * 4.5;
				_speed = Math.pow( freq[8] / 255, 4) * 0.5;
				_sphere = Math.pow( freq[4]/255, 15);
				_noiseSpeed = 0.1 + Math.pow( freq[19] / 255, 15) * 0.05;
				_scale = 1 + Math.pow(freq[1] / 255, 5) * 0.4;				
				*/			
				
				dae.scale.x = 200 * (1 + Math.pow(freq[4] / 255, 5) * 0.2 - Math.pow(freq[9] / 255, 5) * 0.2 );
				dae.scale.y = 200 * (1 + Math.pow(freq[4] / 255, 5) * 0.2 );
				dae.scale.z = 200 * (1 + Math.pow(freq[4] / 255, 5) * 0.2 );
				
			}
		}else {
			return;
		}
		
		
		for (i in 0...g.vertices.length) {
			
			var vv:Vector3 = _base[i].clone();
			//vv.y = -MyDAELoader.getPosY( MyDAELoader.getRatioY(vv.y,_powY,_powY2) );
			
			
			//絶対値
			var a:Float = Math.sqrt( vv.x * vv.x + vv.y * vv.y + vv.z * vv.z);
			//radX
			
			//前
			var radX:Float = -Math.atan2(vv.z, vv.x) + vv.y * Math.sin(_count) * _nejireX;//横方向の角度
			
			//radY
			var radY:Float = Math.asin(vv.y / a);// + _nejireY;// * Math.sin(_count * 0.8);//縦方向の角度

			var amp:Float = (1-_sphere) * a + (_sphere) * 1;
			amp += Math.sin(_count * 0.7) * _getNoise(vv.x, vv.y + _count * _noiseSpeed, vv.z) * _noise;

			//amp *= _scale;
			
			
			
			/*
			var v:Vector2 = _distort.getPoint( (vv.x+1)*0.4, (vv.y+1)*0.4 );
			g.vertices[i].x = v.x;
			g.vertices[i].y = v.y;
			*/
			var yoko:Float = Math.sin( 0.5*( vv.y * 2 * Math.PI ) + _count * _yokoSpeed ) * _yokoRatio;
			var zengo:Float = Math.cos( 0.5*( vv.y * 2 * Math.PI ) + _count * 3 ) * 0.2 * _zengoRatio;
			
			g.vertices[i].x = _scaleX * amp * Math.sin( radX ) * Math.cos(radY);//横
			g.vertices[i].y = _scaleY * amp * Math.sin( radY );//縦
			g.vertices[i].z = _scaleX * amp * Math.cos( radX ) * Math.cos(radY) + yoko;//横
			
			
		}
		
		
	}
	
	public function setColor(col:Int,ran:Float):Void {
	
		if (col == MyColors.ORANGE) {
			dae.material = _daeLoader.materialD;
			
		}else if (col == MyColors.BLACK) {
			if(ran<0.5){
				dae.material = _daeLoader.materialC;
			}else {
				dae.material = _daeLoader.material;	
			}
		}else {
			dae.material = _daeLoader.materialB;			
		}
		
	}
	
	
	
}