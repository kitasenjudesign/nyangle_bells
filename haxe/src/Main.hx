package ;

import html.Page;
import js.Browser;
import js.Lib;
/**
 * ...
 * @author nabe
 */

class Main 
{
	
	private static var _main:Main3d;
	private static var _page:Page;
	
	static function main() 
	{
		Browser.window.onload = untyped _init;
	}
	
	static private function _init() 
	{
		

		_main = new Main3d();
		_main.init();
		
	}
	
}