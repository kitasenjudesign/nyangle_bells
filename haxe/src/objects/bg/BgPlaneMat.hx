package objects.bg;
import common.Path;
import data.ImageManager;
import js.html.Uint8Array;
import shaders.SimplexNoise;
import three.Color;
import tween.TweenMax;
//import sound.MyAudio;
import three.ImageUtils;
import three.ShaderMaterial;
import three.Texture;
import three.Vector3;


/**
 * ...
 * @author watanabe
 */
class BgPlaneMat extends ShaderMaterial
{

	private var vv:String = "
		varying vec2 vUv;// fragmentShaderに渡すためのvarying変数
		varying vec3 vPos;
		void main()
		{
		  // 処理する頂点ごとのuv(テクスチャ)座標をそのままfragmentShaderに横流しする
		  vUv = uv;
		  vPos = position;
		  // 変換：ローカル座標 → 配置 → カメラ座標
		  vec4 mvPosition = modelViewMatrix * vec4(position, 1.0);    
		  // 変換：カメラ座標 → 画面座標
		  gl_Position = projectionMatrix * mvPosition;
		}
	";
	
	private var ff:String = SimplexNoise.glsl + "
		//uniform 変数としてテクスチャのデータを受け取る
		uniform sampler2D texture;
		uniform float counter;
		uniform vec3 colorRatio;
		uniform vec3 offsetColor;
		// vertexShaderで処理されて渡されるテクスチャ座標
		varying vec2 vUv;                                             
		varying vec3 vPos;

		float rand(vec2 co){
			return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453);
		}
		
		void main()
		{	
			vec3 vv = snoiseVec3(vec3(vUv.x * 0.5, vUv.y * 0.5, counter));
			vv.x = 0.5 + vv.x * 0.5;
			vv.y = 0.3 + vv.y * 0.5;
			vv.z = 0.8 + vv.z * 0.2;
			
			//noise
			vv += vec3(0.05 * rand(vUv));//snoiseVec3(vec3(vUv.x * 400.0 + counter*10.0, vUv.y * 400.0+ counter*10.0, counter*10.0));
			
			vec4 texel = vec4( vv, 1.0 ); 
			gl_FragColor = texel;
		}	
	";	
	
	
	private var _texture		:Texture;
	private var _counter		:Float = 0;
	private var _offsetRatio	:Float = 0;

	
	/**
	 * new
	 * @param	tt
	 * @param	t2
	 */
	public function new() 
	{
		//texture
		//normal とか、ざらざらにしたい
		
		_texture = null;
		super({
				vertexShader: vv,
				fragmentShader: ff,
				uniforms: {
					texture: { type: 't', 		value: _texture },
					counter: { type: 'f', 		value: 0 },
					colorRatio: { type: "v3",value:new Vector3(0.2,0.2,0.7) },
					offsetColor: { type: 'c', 	value: new Color(0,0,0) }
				}
		});
		
		side = Three.DoubleSide;
		
		
		//_texture.needsUpdate = true;
		//this.wireframe = true;
		
		_offsetRatio = 0;
		//updateOffset();
		/*
		TweenMax.to(this, 3, {
			_offsetRatio:0,
			onUpdate:updateOffset
		});*/
		
	}
	
	//cube camera wo使うか。
	
	public function update():Void {
		
		uniforms.counter.value += 0.005;
		
	}
	
}