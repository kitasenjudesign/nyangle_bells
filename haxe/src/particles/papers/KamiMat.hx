package particles.papers;
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
import tween.easing.Power4;


/**
 * ...
 * @author watanabe
 */
class KamiMat extends ShaderMaterial
{

	

	private var vv:String = SimplexNoise.glsl + "
		varying vec2 vUv;// fragmentShaderに渡すためのvarying変数
		varying vec3 vNormal;
		varying vec3 vColor;
		attribute vec3 color; // 頂点カラー
		attribute vec3 random;
		
		attribute float idd;		
		varying float vId;
		varying float vRatio;
		
		uniform float counter;
		uniform float ratio;
		uniform float rotRatio;
		uniform float sclRatio;
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
			
			float size = 500.0;
			float height = 500.0;
			//pos.z += radius;
			//vec3 pos = rotateVec3(position, counter, vec3(0.0, 1.0, 0.0)) + random * 300.0;		
			//vec3 pos = rotateVec3( position, counter+random.x*100.0, normalize(random) ) + random * size;		
			float rot = ratio * random.z * 100.0 + random.x * 100.0;
			vec3 pos = rotateVec3( position * sclRatio, rot * rotRatio, normalize(random) );	
			vec3 norm = rotateVec3(normal, rot * rotRatio, normalize(random) );
			
			//1000下がる
			//float d = mod( abs(random.y) * fall + counter * (10.0+10.0*abs(random.x)), fall );
			
			float rr = ratio * ( 1.0 + abs( random.x + random.y ) / 2.0 ) - abs(random.z);
			rr = clamp(rr, 0.0, 1.0);
			
			pos.x = pos.x + random.x * size * rr;
			//pos.y = pos.y + abs( random.y ) * 600.0 * ratio;// - d;
			pos.y = pos.y - 4.0 * rr * ( rr - 1.0 ) * (height*0.5 + height*0.5 * abs(random.y));
			pos.z = pos.z + random.z * size * rr;
			

			vColor = col;
			vId = idd;
			vNormal = normalMatrix * norm;
			vRatio = rr;
			
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
		varying float vRatio;
		
		void main()
		{
			
			if ( vId > numRatio ) discard;
			if ( colRatio <= 0.001) discard;
			if ( vRatio <= 0.0) discard;
			if ( vRatio >= 1.0) discard;
			
			gl_FragColor = vec4(vColor, 1.0);
		}
	";			
		
	/*
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
			//vec3 diffuse1 = (vColor * dotNL1);// + vColor * dotNL2;
			
			diffuse1 = vColor * 0.5 + diffuse1 * 0.5;
			
			diffuse1 *= colRatio;
			diffuse1 += offsetColor;
			
			//vId = id;
			
			// テクスチャの色情報をそのままピクセルに塗る
			gl_FragColor = vec4(diffuse1, 1.0);// texture2D(texture, vUv);
			//gl_FragColor = vec4(vec3(1.0,0,0), 1.0);// texture2D(texture, vUv);
		  
		}	
	";	*/
	
	private var _texture1:Texture;
	
	private var _speed:Float = 0;
	private var _tgtSpeed:Float = 0;
	private var _twn:TweenMaxHaxe;
	private var _twn2:TweenMaxHaxe;
	
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
					ratio: { type: 'f', 		value: 0 },
					rotRatio: { type:"f",		value: 0.9999 },
					numRatio: { type:"f",		value: 0.9999 },
					colRatio: { type:"f",		value: 0.9999 },
					sclRatio: { type:"f",		value: 0.9999 },
					col: { type:"v3", 	value: new Vector3(1,0,0) },
					offsetColor: { type:"v3", 	value: new Vector3() }
				}
		});
		
		this.side = Three.DoubleSide;
		//this.wireframe = true;
		
		//this.wireframe = true;
		//Dat.gui.add(uniforms.counter, "value", 0, 10);
		
		/*
		Dat.gui.add(uniforms.ratio, "value", 0, 1).name("ratio");
		
		
		Dat.gui.add(uniforms.rotRatio, "value", 0, 5).name("rotRatio");
		Dat.gui.add(uniforms.numRatio, "value", 0, 1).name("numRatio");
		Dat.gui.add(uniforms.colRatio, "value", 0, 1).name("colRatio");		
		Dat.gui.add(uniforms.sclRatio, "value", 0, 3).name("sclRatio");	
		Dat.gui.add(this, "play");
		*/
		
		
	}
	
	public function setColor(col:Color):Void{
		
		uniforms.col.value.x = col.r;
		uniforms.col.value.y = col.g;
		uniforms.col.value.z = col.b;
		
	}
	
	public function play(onComp:Void->Void):Void{
		
		uniforms.ratio.value = 0;
		TweenMax.to(uniforms.ratio, 2.0, {
			value:0.5,
			ease:Power4.easeOut
			//ease:Cubic.easeOut
			
		});			
		uniforms.sclRatio.value = 1.0;
		TweenMax.to(uniforms.sclRatio, 2.0, {
			value:0,
			ease:Cubic.easeIn,
			onComplete:onComp
		});					
		
	}
	
	public function update():Void {
		//uniforms.counter.value += 0.1;
	}
	
}