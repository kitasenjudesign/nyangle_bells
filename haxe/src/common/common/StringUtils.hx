package common;

/**
 * ...
 * @author watanabe
 */
class StringUtils
{

	public function new() 
	{
		
		
		
	}
	
	
	/**
	 * addCommma
	 * @param	n
	 * @return
	 */
	public static function addCommma(n:Int):String {
		
		var s:String = Std.string( n );
		var out:String = "";
		
		for(i in 0...s.length){
			out+=s.substr(i,1);
			var keta:Int=s.length-1-i;
			if(keta%3==0 && keta!=0){
				out+=",";
			}
		}

		return out;
		
	}
	

	public static function addCommaStr(s:String):String {
		
		if (s.length <= 3) {
			return s;
		}

		var out:String = "";		
		var lastIndex:Int = (s.length - 1); 
		var last:String = "";
		for (i in 0...s.length) {
			var j:Int = lastIndex - i;
			var last:String = s.substr( j, 1);
			//trace(last,j%3,j);
			if (i % 3 == 0 && i!=0){
				out = last + "," + out;
			}else{
				out = last+out;
			}
        }

		return out;
		
	}
	
	public static function addZero(val:Int, keta:Int):String
	{
		var valStr:String = "" + val;
		var sa:Int = keta - valStr.length;
		while(sa -- > 0){
			valStr = "0" + valStr;
		}
		
		return valStr;
	}
	
	/**
	 * 少数N桁まで入れて返す
	 * @param	t
	 * @param	keta
	 * @return
	 */
	static public function getDecimal(t:Float, keta:Float):String
	{
		var n:Float = Math.pow( 10, keta-1);
		
		n = Math.floor(t * n) / n;
		
		var str:String = "" + n;
		if (str.length == 1) {
			str = str + ".";
		}
		while (true) {
			if (str.length >= keta+1) break;		
			str = str + "0";
		}
		
		return str;
	}
	
	
	static public function date2string(open_date:Date):String
	{
		
		
		if (open_date == null) {
			return "UNDEFINED";	
		}
		
		var out:String=
		open_date.getFullYear()+"/"+
		addZero( open_date.getMonth()+1,2)+"/"+
		addZero( open_date.getDate(),2);
		
		/*
		Tracer.debug("======");
		Tracer.error("__date " + open_date);
		Tracer.error("____date2string " + out);
		*/	
		
		return out;
	}
	
	
	static public function string2date(s:String):Date
	{
		var a:Array<String> = s.split("-");	
		var date:Date = new Date(  Std.parseInt(a[0]), Std.parseInt(a[1])-1, Std.parseInt(a[2]), 12, 0, 0);
		/*
		Tracer.debug("*****");
		Tracer.error("____string2date " + s);
		Tracer.error("__date " + date);
		*/
		return date;
		
		//return 2015-07-31
	}
	
	
	
	
}