package shaders;
import js.html.Uint8Array;
import sound.MyAudio;
import three.ImageUtils;
import three.ShaderMaterial;
import three.Texture;
import three.Vector3;


/**
 * ...
 * @author watanabe
 */
class MaeShaderMaterial extends ShaderMaterial
{


	private var vv:String = "
		varying vec2 vUv;// fragmentShaderに渡すためのvarying変数
		varying vec4 vPos;
		
		void main()
		{
		  // 処理する頂点ごとのuv(テクスチャ)座標をそのままfragmentShaderに横流しする
		  vUv = uv;
		  // 変換：ローカル座標 → 配置 → カメラ座標
		  vec4 mvPosition = modelViewMatrix * vec4(position, 1.0);    
		  
		  //world座標
		  
		  // 変換：カメラ座標 → 画面座標
			vPos = modelMatrix * vec4(position, 1.0);
		 
		  gl_Position = projectionMatrix * mvPosition;
		}
	";
	
	private var ff:String = "
		//uniform 変数としてテクスチャのデータを受け取る
		uniform sampler2D map;
		//uniform float counter;
		uniform float rp;
		// vertexShaderで処理されて渡されるテクスチャ座標
		varying vec2 vUv;                                             
		varying vec4 vPos;

		void main()
		{

			if (vPos.y < 0.0) discard;
			
		  // テクスチャの色情報をそのままピクセルに塗る
		  vec2 uvv = vec2( vUv.x, fract( rp * vUv.y ) );
		  
		  gl_FragColor = texture2D(map, uvv);
		}	
	";	
	
	private var _texture1:Texture;
	
	/**
	 * new
	 * @param	tt
	 * @param	t2
	 */
	public function new(uri:String,repeat:Float=1) 
	{
		//texture
		
		_texture1 = ImageUtils.loadTexture(uri);
		
		
		super({
				vertexShader: vv,
				fragmentShader: ff,
				uniforms: {
					map: { type: 't', 		value: _texture1 },
					rp: { type: 't', 		value: repeat }
				}
		});
		
		this.side = Three.DoubleSide;
		
		//this.wireframe = true;
		
	}
	

	public function update():Void {
		uniforms.counter.value += 0.01;
	}
	
}