package effect.shaders;

/**
 * ...
 * @author watanabe
 */
class MyTiltShiftShader
{

	public function new() 
	{
		
	}
	
	public static function getObject():Dynamic {
		
		return {
			uniforms: {

				"tDiffuse": { type: "t", value: null },
				"v":        { type: "f", value: 3.0 / 512.0 },
				"r":		{type:"f",value:0.5},
				"k"  : { type: "fv1", value: [
					1.0, 4.0, 6.0, 4.0, 1.0,
					4.0, 16.0, 24.0, 16.0, 4.0,
					6.0, 24.0, 36.0, 24.0, 6.0,
					4.0, 16.0, 24.0, 16.0, 4.0,
					1.0, 4.0, 6.0, 4.0, 1.0
				] },    // float array (plain)
			},

			vertexShader:'
				varying vec2 vUv;
				void main() {
					vUv = uv;
					gl_Position = projectionMatrix * modelViewMatrix * vec4( position, 1.0 );
				}',


			fragmentShader:'
				uniform sampler2D tDiffuse;
				uniform float v;
				uniform float r;
				uniform float k[25];
				varying vec2 vUv;

				void main() {

					vec4 sum = vec4( 0.0 );
					float vv = v * abs( r - vUv.y );
					
					for(float i=-2.0;i<=2.0;i++){
						for(float j = -2.0; j <=2.0; j++) {
							sum += texture2D( tDiffuse, vec2( vUv.x + i * vv, vUv.y + j * vv ) ) / 25.0;
							//idx += 1;
						}
					}
					
					gl_FragColor = sum;

				}'
		};
		
	}
	
	
}