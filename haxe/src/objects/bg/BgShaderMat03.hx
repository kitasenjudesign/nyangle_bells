package objects.bg;
import common.Dat;
import common.Path;
import data.ImageManager;
import data.Params;
import data.Quality;
import js.html.Uint8Array;
import shaders.SimplexNoise;
import three.Color;
import tween.TweenMax;
import tween.easing.Power0;
//import sound.MyAudio;
import three.ImageUtils;
import three.ShaderMaterial;
import three.Texture;
import three.Vector3;


/**
 * ...
 * @author watanabe
 */
class BgShaderMat03 extends ShaderMaterial
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
		
		var ff:String = SimplexNoise.glsl + "
			//uniform 変数としてテクスチャのデータを受け取る
			uniform sampler2D texture;
			uniform float counter;
			uniform vec3 colorRatio;
			uniform vec3 offsetColor;
			// vertexShaderで処理されて渡されるテクスチャ座標
			varying vec2 vUv;                                             
			varying vec3 vPos;

			void main()
			{
			  // テクスチャの色情報をそのままピクセルに塗る
			  vec3 col = 0.4 * snoiseVec3(vec3(vPos.x * 0.00017, vPos.y * 0.00018, vPos.z * 0.00019 + counter));
			  col.x = colorRatio.x * ( col.x + 1.0 ) / 2.0;
			  col.y = colorRatio.y * ( col.y + 1.0 ) / 2.0;
			  col.z = colorRatio.z * ( col.z + 1.0 ) / 2.0;
		";		
		
		//細かいnoise, quality high以外は使わない
		var ff2:String = !Quality.HIGH ? "" : "
			col += vec3( 0.05 * snoiseVec3(vec3(vPos.x * 0.5, vPos.y * 0.5, vPos.z * 0.5 +counter)));
		";
		  
		var ff3:String = "
		  //白くする用
			col += offsetColor;
			gl_FragColor = vec4( col,1.0 );// texture2D(texture, vUv);
		}	
		";	
		
		return ff + ff2 + ff3;
		
	}
	


	
		private var _texture		:Texture;
		private var _counter		:Float = 0;
		private var _offsetRatio	:Vector3 = new Vector3();
		
	/**
	 * new
	 * @param	tt
	 * @param	t2
	 */
	public function new() 
	{
		//texture
		//normal とか、ざらざらにしたい
		
		_texture = null;// ImageManager.getInstance().bg1;// 
		super({
				vertexShader: vv,
				fragmentShader: getFragment(),
				uniforms: {
					texture: { type: 't', 		value: _texture },
					counter: { type: 'f', 		value: 0 },
					colorRatio: { type: "v3",value: Params.bgColSpace },
					offsetColor: { type: 'v3', 	value: new Vector3() }
				}
		});
		
		side = Three.BackSide;
		//_texture.needsUpdate = true;
		//this.wireframe = true;
		
		
		/*
		TweenMax.to(this, 3, {
			_offsetRatio:0,
			onUpdate:updateOffset
		});*/
		

	}
	
	public function init():Void{
		#if debug
		
			Dat.gui.add(uniforms.colorRatio.value,"x",0,2).name("colR");
			Dat.gui.add(uniforms.colorRatio.value,"y",0,2).name("colG");
			Dat.gui.add(uniforms.colorRatio.value,"z",0,2).name("colB");
		
		#end
	}
	
	/**
	 * startBlack やろう
	 * @param	delay
	 */
	public function startBlack(delay:Float):Void{
		
		TweenMax.to(uniforms.offsetColor.value, 3, {
			x:0,
			y:0,
			z:0,
			delay			:delay,
			ease:Power0.easeInOut
		});
		
	}
	
	public function startWhite(time:Float, delay:Float):Void{
		
		TweenMax.to(uniforms.offsetColor.value, time, {
			x	:1.5,
			y	:1.5,
			z	:1.5,
			delay			:delay,
			ease:Power0.easeInOut
		});		
		
	}
	
	
	public function tweenColor(tgt:Vector3,time:Float,delay:Float=0):Void{
		
		TweenMax.to(uniforms.colorRatio.value, time, {
			x:tgt.x,
			y:tgt.y,
			z:tgt.z,
			delay:delay,
			ease:Power0.easeInOut
		});			
		
	}
	
	public function tweenOffsetCol(tgt:Vector3, time:Float, delay:Float):Void{
		
		TweenMax.to(uniforms.offsetColor.value, time, {
			x:tgt.x,
			y:tgt.y,
			z:tgt.z,
			delay:delay,
			ease:Power0.easeInOut
		});	
		
	}
	
	
	
	
	public function startBlue():Void{
		
		
		
		TweenMax.to(uniforms.colorRatio.value, 1, {
			x:0.5,
			y:0.6,
			z:1,
			delay:0,
			ease:Power0.easeInOut
		});			
		
	}

	public function update(cnt:Float):Void {
		//0.0075
		
		
		if ( Math.isNaN(cnt) ){
			Tracer.warn("da = " + cnt);			
			uniforms.counter.value += 0.0075;
		}else{
			Tracer.info("ok = " + cnt);
			uniforms.counter.value += cnt;
		}
	}
	
}