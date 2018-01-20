package effect.shaders;

/**
 * ...
 * @author watanabe
 */
class VignetteShader
{

	public function new() 
	{
		
	}
	
	/**
	 * 
	 * @return
	 */
	public static function getObject():Dynamic {
		
		return {
			uniforms: {
				"tDiffuse": { type: "t", value: null },
				"offset":   { type: "f", value: 1.0 },
				"darkness": { type: "f", value: 1.5 }
			},
			vertexShader:
				"varying vec2 vUv;
				void main() {
					vUv = uv;
					gl_Position = projectionMatrix * modelViewMatrix * vec4( position, 1.0 );
				}",
			fragmentShader:
				"uniform float offset;
				uniform float darkness;
				uniform sampler2D tDiffuse;
				varying vec2 vUv;
				void main() {
					vec4 texel = texture2D( tDiffuse, vUv );
					vec2 uv = ( vUv - vec2( 0.5 ) ) * vec2( offset );
					gl_FragColor = vec4( mix( texel.rgb, vec3( 1.0 - darkness ), dot( uv, uv ) ), texel.a );
				}"

		};
	
	}
	
}