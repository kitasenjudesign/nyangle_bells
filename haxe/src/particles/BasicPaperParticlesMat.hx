package particles;
import common.Dat;
import common.Path;
import js.html.Uint8Array;
import shaders.SimplexNoise;
import sound.MyAudio;
import three.ImageUtils;
import three.ShaderMaterial;
import three.Texture;
import three.Vector3;


/**
 * ...
 * @author watanabe
 */
class BasicPaperParticlesMat extends ShaderMaterial
{


	private var vv:String = SimplexNoise.glsl + "
		varying vec2 vUv;// fragmentShaderに渡すためのvarying変数
		varying vec3 vNormal;
		uniform float counter;
		
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
			
			//pos.z += radius;
			vec3 pos = rotateVec3(position, counter, vec3(0.0, 1.0, 0.0));			
			pos.y += 50.0;
		  
			vNormal = normalMatrix * normal;
			
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
		// vertexShaderで処理されて渡されるテクスチャ座標
		varying vec2 vUv;                                             
		varying vec3 vNormal; 
		
		void main()
		{
		  // テクスチャの色情報をそのままピクセルに塗る
		  gl_FragColor = vec4(vNormal, 1.0);// texture2D(texture, vUv);
		  
		}	
	";	
	
	private var _texture1:Texture;
	
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
					
				}
		});
		
		this.side = Three.DoubleSide;
		
		//this.wireframe = true;
		Dat.gui.add(uniforms.counter, "value", 0, 10);
	}
	

	public function update():Void {
		uniforms.counter.value += 0.01;
	}
	
}