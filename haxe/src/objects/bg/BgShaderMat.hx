package objects.bg;
//import common.Path;
import data.Quality;
//import data.ImageManager;
//import data.Quality;
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
class BgShaderMat extends ShaderMaterial
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
	
	
	public function getFragment():String{
		
		var ff0:String = SimplexNoise.glsl + "
			//uniform 変数としてテクスチャのデータを受け取る
			uniform sampler2D texture;
			uniform float counter;
			uniform vec3 offsetColor;
			// vertexShaderで処理されて渡されるテクスチャ座標
			varying vec2 vUv;                                             
			varying vec3 vPos;

			void main()
			{
			  // テクスチャの色情報をそのままピクセルに塗る
			  vec3 col = 1.0 * snoiseVec3(vec3(vPos.x * 0.00010, vPos.y * 0.00011, vPos.z * 0.00012 + counter));
			  col.x = 2.0 * abs(col.x);
			  col.y = 2.0 * abs(col.y);
			  //col.x = 0.5 * ( col.x + 1.0 ) / 2.0 + 0.1;
			  //col.y *= 0.15;
			  //col.z *= 0.35;

		";
		
		//細かいnoise、quality high以外では使わない
		var ff1:String = !Quality.HIGH ? "" : "
			col += vec3( 0.05 * snoiseVec3(vec3(vPos.x * 0.5, vPos.y * 0.5, vPos.z * 0.5 + counter)));
		";
		
		//最後のノイズ
		var ff2:String = "	  
				//白くする用
				//col += offsetColor;
				gl_FragColor = vec4( col, 1.0 );// texture2D(texture, vUv);
				
			}
		";
		
		return ff0 + ff1 + ff2;
		
	}
	

	
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
		//_texture = ImageManager.getInstance().bg1;// 
		super({
				vertexShader: vv,
				fragmentShader: getFragment(),
				uniforms: {
					texture: { type: 't', 		value: _texture },
					counter: { type: 'f', 		value: 0 },
					offsetColor: { type: 'c', 	value: new Color(0) }
				}
		});
		
		side = Three.BackSide;
		//_texture.needsUpdate = true;
		//this.wireframe = true;
		
		
		_offsetRatio = 1;
		updateOffset();
		/*
		TweenMax.to(this, 3, {
			_offsetRatio:0,
			onUpdate:updateOffset
		});*/
		
	}
	
	/**
	 * startBlack
	 * @param	delay
	 */
	public function startBlack(time:Float,delay:Float):Void{
		
		TweenMax.to(this, time, {
			_offsetRatio	:0,
			delay			:delay,
			onUpdate		:updateOffset
		});
		
	}
	
	public function startWhite(time:Float, delay:Float):Void{
		
		TweenMax.to(this, time, {
			_offsetRatio	:1.5,
			delay			:delay,
			onUpdate		:updateOffset
		});		
		
	}
	
	
	public function updateOffset():Void{
		//Tracer.info("fadeIn");
		var color:Color = uniforms.offsetColor.value;
		color.setRGB(_offsetRatio, _offsetRatio, _offsetRatio);
		uniforms.offsetColor.value = color;
	}
	

	public function update():Void {
		
		uniforms.counter.value += 0.003;
		
	}
	
}