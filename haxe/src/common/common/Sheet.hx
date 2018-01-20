package common;
//import com.neymarshot.common.CssUtils;
//import com.neymarshot.data.ImageManager;
import js.Browser;
import js.html.DivElement;
import js.JQuery;

/**
 * ...
 * @author watanabe
 */
class Sheet
{
	
	public static var ID:String = "fadeSheet";
	static private var _sheet:JQuery;
	private static var _baseWidth	:Int = 1280;
	private static var _baseHeight	:Int = 720;
	
	public function new(){
	
		
	}
	
	/**
	 * 
	 * @param	zIndex
	 */
	public static function show():Void {
		
		//Tracer.debug("show " + zIndex);
		
		var bg:DivElement = Browser.window.document.createDivElement();
		bg.id = ID;
		Browser.window.document.body.appendChild(bg);
		
		//bg.innerHTML = "AJIJDIJFI";
		_sheet = new JQuery("#"+ID);	
		_sheet.css( {
			"pointer-events":"100% 100%",
			backgroundSize		:"contain",
			backgroundImage		:"url('black.png')",
			position			:"absolute",
			backgroundPosition	:"center center",
			zIndex				:1000
		});
		
		//CssUtils.setUserSelect(_sheet);
		
		Browser.window.onresize = untyped resize;
		resize();
	}
	
	
	public static function resize():Void {

		var w:Float = Browser.window.innerWidth;
		var h:Float = Browser.window.innerHeight;
		
		var r:Float = _baseWidth / _baseHeight;
		
		var ww:Float = w;
		var hh:Float = h;
		/*
		if (w / h > r) {
			ww = w;
			hh = w * _baseHeight / _baseWidth;
		}else {
			ww = h * _baseWidth / _baseHeight;
			hh = h;
		}
		*/
		_sheet.css( {
			width: ww,
			height: hh,
			left: 0,
			top: 0
		});
		
	}
	
	
}