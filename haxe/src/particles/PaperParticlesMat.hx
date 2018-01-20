package particles;
import common.Dat;
import data.NoteonData;
import js.html.Uint8Array;
import shaders.SimplexNoise;
import sound.MyAudio;
import three.Color;
import three.ImageUtils;
import three.ShaderMaterial;
import three.Texture;
import three.Vector3;
import tween.TweenMax;
import tween.TweenMaxHaxe;
import tween.easing.Cubic;
import tween.easing.Power0;


/**
 * ...
 * @author watanabe
 */
class PaperParticlesMat extends ShaderMaterial
{

	

	private var vv:String = SimplexNoise.glsl + "
		varying vec2 vUv;// fragmentShaderに渡すためのvarying変数
		varying vec3 vNormal;
		varying vec3 vColor;
		attribute vec3 color; // 頂点カラー
		attribute vec3 random;
		
		attribute float idd;		
		varying float vId;
		
		
		uniform float counter;
		uniform float rotRatio;
		uniform float sclRatio;
		uniform float sclRatio2;
		uniform vec3 rotAxis;
		
		uniform vec3 col;
		
		vec3 rotateVec3(vec3 p, float angle, vec3 axis){
		  vec3 a = normalize(axis);
		  float s = sin(angle);
		  float c = cos(angle);
		  float r = 1.0 - c;
		  mat3 m = mat3(
			a.x * a.x * r + c,
			a.y * a.x * r + a.z * s,
			a.z * a.x * r - a.y * s,
			a.x * a.y * r - a.z * s,
			a.y * a.y * r + c,
			a.z * a.y * r + a.x * s,
			a.x * a.z * r + a.y * s,
			a.y * a.z * r - a.x * s,
			a.z * a.z * r + c
		  );
		  return m * p;
		}
		
		
		void main()
		{
			
			vec3 size = vec3(4000.0,2000.0,4000.0);
			float fall = 1000.0;
			//pos.z += radius;
			//vec3 pos = rotateVec3(position, counter, vec3(0.0, 1.0, 0.0)) + random * 300.0;		
			//vec3 pos = rotateVec3( position, counter+random.x*100.0, normalize(random) ) + random * size;		
			float rot = counter * random.z + random.x * 100.0;
			vec3 axis = random;
			axis.x += random.z * counter * 0.1;
			axis.y += random.x * counter * 0.1; 
			axis.z += random.y * counter * 0.1; 
			
			//0,1,2,3,4,5
			
			float scl = 10.0 * (sclRatio - idd / 10.0);
			
			scl = clamp(scl, 0.0, 1.0);
			
			scl *= sclRatio2;
			
			vec3 pos = rotateVec3( position * scl, rotRatio, normalize(rotAxis) ) + random * size;	
			vec3 norm = rotateVec3(normal, rotRatio, normalize(rotAxis) );
			
			//1000下がる
			float d = mod( abs(random.y) * fall + counter * (10.0+10.0*abs(random.x)), fall );
			
			pos.x = pos.x + (50.0+100.0*random.z) * sin( counter * random.x * 0.3 + random.y * 6.28 );
			pos.y = pos.y;// - d;
			pos.z = pos.z + (50.0+100.0*random.x) * sin( counter * random.y * 0.3 + random.z * 6.28 );
			

			vColor = col;
			vId = idd;
			vNormal = normalMatrix * norm;
			
			// 処理する頂点ごとのuv(テクスチャ)座標をそのままfragmentShaderに横流しする
			vUv = uv;
			// 変換：ローカル座標 → 配置 → カメラ座標
		  vec4 mvPosition = modelViewMatrix * vec4(pos, 1.0);    
			// 変換：カメラ座標 → 画面座標
		  gl_Position = projectionMatrix * mvPosition;
		}
	";
	
	private var ff:String = SimplexNoise.glsl + "
		//uniform 変数としてテクスチャのデータを受け取る
		//uniform sampler2D texture;
		uniform float counter;
		uniform vec3 offsetColor;
		uniform float colRatio;
		uniform float numRatio;
		// vertexShaderで処理されて渡されるテクスチャ座標
		varying vec2 vUv;                                             
		varying vec3 vNormal; 
		varying vec3 vColor;
		varying float vId;

		
		void main()
		{
			
			//if ( vId > numRatio ) discard;
			if ( colRatio <= 0.001) discard;
			
			
			vec3 lightPosition1 = vec3(0, 0, -1.0);
			
			vec4 viewLightPosition1 = viewMatrix * vec4( lightPosition1, 0.0 );			
			
			vec3 normal = vNormal;
			
			#ifdef DOUBLE_SIDED
				normal = normal * ( float( gl_FrontFacing ) * 2.0 - 1.0 );	
			#endif
			
			vec3 N = normalize(normal);
			vec3 L1 = normalize(viewLightPosition1.xyz);
			
			float dotNL1 = dot(N, L1);
			vec3 diffuse1 = abs(vColor * dotNL1);// + vColor * dotNL2;
			diffuse1 = vColor * 0.5 + diffuse1 * 0.5;
			//vec3 diffuse1 = (vColor * dotNL1);// + vColor * dotNL2;
			
			diffuse1 *= colRatio;
			diffuse1 += offsetColor;
			
			//vId = id;
			
			// テクスチャの色情報をそのままピクセルに塗る
			gl_FragColor = vec4(diffuse1, 1.0);// texture2D(texture, vUv);
			//gl_FragColor = vec4(vec3(1.0,0,0), 1.0);// texture2D(texture, vUv);
		  
		}	
	";	
	
	private var _texture1:Texture;
	
	private var _speed:Float = 0;
	private var _tgtSpeed:Float = 0;
	private var _twn:TweenMaxHaxe;
	private var _twn2:TweenMaxHaxe;
	
	private var _flag:Bool = false;
	private var _num:Float = 0;
	var _resetMode:Bool=false;
	/**
	 * new
	 * @param	tt
	 * @param	t2
	 */
	public function new() 
	{
		//texture
		
		//_texture1 = ImageUtils.loadTexture("img/earth.jpg");
		
		
		super({
				vertexShader: vv,
				fragmentShader: ff,
				uniforms: {
					map: { type: 't', 		value: null },
					counter: { type: 'f', 		value: 0 },
					rotRatio: { type:"f",		value: 0.9999 },
					numRatio: { type:"f",		value: 0.9999 },
					colRatio: { type:"f",		value: 0.9999 },
					sclRatio: { type:"f",		value: 0.9999 },
					sclRatio2: { type:"f",		value: 0.9999 },
					rotAxis: { type:"v3", 	value: new Vector3(1,0,0)  },
					col: { type:"v3", 	value: new Vector3(1,0,0) },
					offsetColor: { type:"v3", 	value: new Vector3() }
				}
		});
		
		this.side = Three.DoubleSide;
		//this.wireframe = true;
		
		//this.wireframe = true;
		//Dat.gui.add(uniforms.counter, "value", 0, 10);
		
		#if debug
			Dat.gui.add(uniforms.rotRatio, "value", 0, 5).name("rotRatio");
			Dat.gui.add(uniforms.numRatio, "value", 0, 1).name("numRatio");
			Dat.gui.add(uniforms.colRatio, "value", 0, 1).name("colRatio");		
			Dat.gui.add(uniforms.sclRatio, "value", 0, 1.01).name("sclRatio");	
		#end
		
		/*
		Dat.gui.add(uniforms.offsetColor.value, "x", 0, 1).name("xx");
		Dat.gui.add(uniforms.offsetColor.value, "y", 0, 1).name("yy");
		Dat.gui.add(uniforms.offsetColor.value, "z", 0, 1).name("zz");
		*/
		

	}
	
	
	public function start() 
	{
		MyAudio.a.addEventListener(MyAudio.EVENT_NOTEON, _onNote);		
	}	
	
	private function _onNote(e):Void 
	{
		var n:NoteonData = e.data;

		if ( n.type == NoteonData.BEAT ){
			
			if (n.name == "C2"){
				
				uniforms.sclRatio2.value = 1.4;
				/*
				var n1:Float = 0.02;
				var n2:Float = 0.3;
				_tgtSpeed = (_tgtSpeed == n1) ? n2 : n1;
				
				if ( _tgtSpeed == n1 ) flash();
				*/
			}
			
		}
	
	}
	
	
	public function setColor(col:Color):Void{
		
		uniforms.col.value.x = col.r;
		uniforms.col.value.y = col.g;
		uniforms.col.value.z = col.b;
		uniforms.counter.value = 0;
	}	
	
	
	public function reset():Void{
		
		_num = 0;
		uniforms.sclRatio.value = 0;
		
		_resetMode = Math.random() < 0.7 ? true : false;

		
	}
	
	
	public function flash():Void{
		
		if (_twn != null) _twn.kill();
		if (_twn2 != null) _twn2.kill();
		
		/*
		uniforms.offsetColor.value.x = 1;
		uniforms.offsetColor.value.y = 1;
		uniforms.offsetColor.value.z = 1;
		_twn = TweenMax.to(uniforms.offsetColor.value, 0.2, {
			x:0,
			y:0,
			z:0			
		});*/
		
		
		if(_resetMode){
		
			uniforms.rotRatio.value = 1.5;
			_twn2 = TweenMax.to(uniforms.rotRatio, 0.2, {
				value:0,
				ease:Power0.easeInOut
			});
			
			uniforms.rotAxis.value.x = Math.random() - 0.5;
			uniforms.rotAxis.value.y = Math.random() - 0.5;
			uniforms.rotAxis.value.z = Math.random() - 0.5;		
		
		}else{

			uniforms.rotRatio.value = 1.0;

			_twn2 = TweenMax.to(uniforms.rotAxis.value, 0.1, {
				x:2 * ( Math.random() - 0.5 ),
				y:2 * ( Math.random() - 0.5 ),
				z:2 * ( Math.random() - 0.5 ),
				ease:Power0.easeInOut
			});
			
		}
		
		
		
		_flag = true;
		
		_num += 0.1;
		
		uniforms.numRatio = 1;
		//uniforms.rotRatio.value = 0;
		//uniforms.sclRatio.value = 0;
		TweenMax.to(uniforms.sclRatio, 0.1, {
			value:_num,
			ease: Power0.easeInOut,
			onComplete: _onFlash
		});		
		
		
	}
	
	private function _onFlash():Void
	{
		_flag = false;
	}
	

	public function update():Void {
		
		if (!_flag){
			
			//uniforms.sclRatio.value+= (0 - uniforms.sclRatio.value) / 10;
			
		}
		
		
		uniforms.sclRatio2.value += ( 1.0 - uniforms.sclRatio2.value ) / 4;
		
		//_speed += ( _tgtSpeed - _speed ) / 2;
		//uniforms.counter.value += _speed;
		
	}
	
	public function addNum():Void
	{
		//uniforms.numRatio.value += 0.1;
	}

	
}