package objects;
import createjs.easeljs.Container;
import createjs.easeljs.Text;

/**
 * ...
 * @author watanabe
 */
class SpacingText extends Container
{

	private var _width	:Float = 0;
	private var _height	:Float = 0;
	private var _space:Float = 0;
	private var _font:String;
	private var _color:String;
	private var _texts:Array<Text>;

	
	public function new(text:String,font:String,space:Float,color:String) 
	{
		super();
		
		_font = font;
		_space = space;
		_color = color;
		
		_setText( text );
		
	}

	/**
	 * 
	 * @param	text
	 */
	private function _setText(text:String):Void {
		
		_removeTexts();
		
		var sx:Float = 0;
		for (i in 0...text.length) {	
			var tt:String = text.substr(i, 1);
			var text:Text = new Text(tt, _font);
			text.color = _color;
			if (tt == "@") {
				text.y = -2;
			}else {
				text.y = 0;
			}
			text.x = sx;
			
			_texts.push(text);
			sx += text.getMeasuredWidth() + _space;
			
			_height = Math.max(_height, text.getMeasuredHeight() );
			
			_texts.push(text);	
			this.addChild(text);
		}
		
		_width = sx - _space;
	}
	
	private function _removeTexts():Void {
		
		if(_texts!=null){
			for (i in 0..._texts.length) {
				if (this.contains(_texts[i])) {
					this.removeChild(_texts[i]);
				}
			}
		}
		_texts = [];
	}
	
	/**
	 * 
	 * @param	text
	 */
	public function update(text:String):Void {
		
		_setText(text);
		
	}
	
	
	
	public function getWidth():Float {
		return _width;
	}
	public function getHeight():Float {
		return _height;
	}
	
	
	public static function getFont(size:Float, bold:String="400", text:String = "Roboto Condensed" ):String {
		return bold +" "+size+"px " + text;
	}
	
}