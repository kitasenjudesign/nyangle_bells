package three;
import three.Texture;

@:native("THREE.TextureLoader")
extern class TextureLoader extends EventDispatcher /* not Loader, for some reason */ {
	
	public var crossOrigin:String;
	
    function new() : Void;
    function load(url:String, ?onLoad:Void->Void , ?onProgress:Void->Void, ?onError:Void->Void) : Texture;
	
}
