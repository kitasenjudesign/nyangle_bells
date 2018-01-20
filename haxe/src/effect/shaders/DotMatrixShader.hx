package effect.shaders;
import js.Browser;
import three.Vector2;

/**
 * ...
 * @author watanabe
 */
class DotMatrixShader
{

	public function new() 
	{
		
	}
	
	public static function getObject():Dynamic {
		
		return {
		
			uniforms: {

				"tDiffuse":   { type: "t", value: null },
				"spacing":    { type: "f", value: 10.0 },
				"size":       { type: "f", value: 4.0 },
				"blur":       { type: "f", value: 4.0 },
				"resolution": { type: "v2", value: new Vector2( Browser.window.innerWidth, Browser.window.innerHeight)  }

			},

			//
			vertexShader:
				"varying vec2 vUv;
					void main() {
						vUv = uv;
						gl_Position = projectionMatrix * modelViewMatrix * vec4( position, 1.0 );
				}",

			//
			fragmentShader:
				"uniform sampler2D tDiffuse;
				uniform float spacing;
				uniform float size;
				uniform float blur;
				uniform vec2 resolution;

				varying vec2 vUv;
				
				void main() {

					vec2 count = vec2(resolution/spacing);
					vec2 p = floor(vUv*count)/count;

					vec4 color = texture2D(tDiffuse, p);

					vec2 pos = mod(gl_FragCoord.xy, vec2(spacing)) - vec2(spacing/2.0);
					float dist_squared = dot(pos, pos);
					gl_FragColor = mix(color, vec4(0.0), smoothstep(size, size + blur, dist_squared));

				}"
					
		};
	}
	
	
}