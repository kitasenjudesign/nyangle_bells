package common;
import webfont.WebFont;

/**
 * ...
 * @author nabe
 */
class WebfontLoader
{
	
	//Roboto+Condensed:700,400:latin
	public static inline var ROBOTO_CONDENSED			:String = "Roboto Condensed";
	public static inline var ROBOTO_CONDENSED_700400	:String = "Roboto+Condensed:700,400:latin";
	public static inline var ROBOTO_CONDENSED_400300	:String = "Roboto+Condensed:400,300:latin";
	
	
	private static var _callback:Void->Void;
	private static var _loading		:Bool = false;
	private static var _complete	:Bool = false;
	public function new() 
	{
		
	}
	
	/**
	 * 
	 * @param	fontNames
	 * @param	callback
	 */
	public static function load(fontNames:Array<String>, callback:Void->Void):Void {
		
		_callback = callback;
		
		if (_loading) {
			
		}else {
			if (_complete) {
				_callback();
			}
		}
		
		
		
		if (WebFont == null) {
			
			trace("inactive webfont");
			if (_callback != null) {
				_callback();
			}
			
		}else {
			if (_loading) return;
			
			_loading = true;	
			WebFont.load({
				google: {
					families:fontNames
				},
				loading: function() {
				  trace("loading webfont...");
				},
				active: function () {
					//window.init();
					_loading = false;
					_complete = true;
					
					if (_callback != null) {
						_callback();
					}
					
				},
				inactive: function() {
				   trace("inactive webfont");
					if (_callback != null) {
						_callback();
					}
				}
			});
		}
		
	}
	
}