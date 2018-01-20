package camera;

/**
 * ...
 * @author nabe
 */
class CamData
{

	public static var cam_Shomen		:CamData = new CamData("shomen",	1800, 0, 0.15, 40, 200);	
	public static var cam_PersNaname	:CamData = new CamData("naname",	1800, -0.7, 0.4, 50, 100);	
	
	public static var cam_Ue:CamData = new CamData("ue",		820, 0, 1.15, 85, 200);
	public static var cam_Yoko:CamData = new CamData("yoko",	1800, -3.14 / 2, 0, 45, 0);
	
	public static var cam_Pers:CamData = new CamData("perspective",	500, 0.34, 1.2, 140,0);	
	public static var cam_Pers2:CamData = new CamData("perspective2",	500, -2.6, 1.1, 140, 0, true);	
	
	
	public static var cam_Orth1:CamData = new CamData("orth",	5500, 0.7, 0.7, 15,0);	
	public static var cam_Gyaku:CamData = new CamData("gyaku",	2000, -3.14, 0.3, 50, 300, true);	
	
	//public static var cam3:CamData = new CamData("orth2",	4800, -0.66, 0.43, 10,0);	
	public static var cam_Orth2:CamData = new CamData("orth3",	8000, 2.66, 0.75, 10,0,true);	

	
	public static var cam_Migi:CamData = new CamData("migi",	1800, 0.7, 0.05, 60,300);
	public static var cam_Yori:CamData = new CamData("yori",	1500, -0.37,0.13, 60,300 );


	public static var cam_Shita:CamData = new CamData("shita",	1200, 0.55, -0.2, 55,300 );

	
	
	public static var cams:Array<CamData> = [ 
		
		cam_Shomen, 
		cam_PersNaname,
		cam_Ue,
		cam_Shita,
		cam_Yoko,
		cam_Pers,
		cam_Orth1, 
		cam_Gyaku,
		
		cam_Migi, 
		cam_Yori, 
		
		cam_Pers2
	];

	public var name	:String = "";
	public var radX	:Float = 0;
	public var radY	:Float = 0;
	public var amp	:Float = 0;
	public var fov	:Float = 60;
	public var offsetY:Float = 0;
	public var gyaku:Bool = false;
	private static var index:Int = -1;
	
	public function new(n:String, a:Float, rx:Float,ry:Float,fovv:Float,oY:Float,gyak:Bool=false) 
	{
		
		this.name = n;
		this.amp = a;
		this.radX = rx;
		this.radY = ry;
		this.fov = fovv;
		this.offsetY = oY;
		this.gyaku = gyak;
		
	}
	
	static public function getAngle():CamData
	{
		index++;
		return cams[ index % cams.length ];
	}
	
	
}