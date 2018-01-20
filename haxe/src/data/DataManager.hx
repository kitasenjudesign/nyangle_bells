package data;
import loaders.CatsLoader;
import loaders.MyBoxLoader;

/**
 * ...
 * @author nabe
 */
class DataManager
{

	/*******************************************************/
	private static var instance=null;
    private static var internallyCalled:Bool = false;
	
    public function new() {
        if(internallyCalled){
            internallyCalled=false;
        }else{
            throw "Singleton.getInstance()で生成してね。";
        }
    }

    public static function getInstance():DataManager{
        if(DataManager.instance==null){
            internallyCalled = true;
            instance = new DataManager();
        }
        return instance;		
    }
	/*******************************************************/
	
	private var _callback:Void->Void;
	
	public var cats			:CatsLoader;
	public var box			:MyBoxLoader;
	
	public var nyan			:MyBoxLoader;
	public var xmas			:MyBoxLoader;
	public var nyangle		:MyBoxLoader;
	
	//public var fontShape	:FontShapeMaker;
	//snowman cat
	
	//
	public function load(callback:Void->Void):Void {	
		_callback = callback;
		
		cats = new CatsLoader();
		cats.load(_onLoad );
	}
	
	function _onLoad() 
	{
		trace("==onLoad==");
		box = new MyBoxLoader();
		box.load( "./obj/box/box.dae",_onLoad2 );
		
	}
	
	private function _onLoad2():Void{
		
		//fontShape = new FontShapeMaker();
		//fontShape.init("font/DINBold.json", _onLoad3);
		_onLoad3();
	}
	
	private function _onLoad3():Void{
		nyan = new MyBoxLoader();
		nyan.load( "./obj/moji/moji.dae", _onLoad4 );
	}
	
	private function _onLoad4():Void{
		xmas = new MyBoxLoader();
		xmas.load( "./obj/moji/xmas.dae", _onLoad5 );
	}
	
	private function _onLoad5():Void{
		nyangle = new MyBoxLoader();
		nyangle.load( "./obj/moji/nyanglebell.dae", _onLoad6 );
	}
	
	
	private function _onLoad6():Void{
		
		if (_callback != null) {
			_callback();
		}
		
	}
	
	
	
}