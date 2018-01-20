package sound;
import common.Dat;
import data.NoteonData;
import html.Page;
import js.Browser;
import js.html.AudioElement;
import js.html.Uint8Array;
import js.html.audio.AnalyserNode;
import js.html.audio.AudioContext;
import three.EventDispatcher;
import tween.TweenMax;
import tween.easing.Power0;
import utils.OsChecker;

/**
 * ...
 * @author nabe
 */
class MyAudio extends EventDispatcher
{

	public static inline var EVENT_NOTEON:String = "noteon";
	public static inline var EVENT_FINISH:String = "finish";//終了したら
	public static inline var EVENT_500MS:String = "500ms";
	
	public static inline var FFTSIZE:Int = 64;
	public static inline var LOOP_NUM:Int = 3;
	
	private var analyser:AnalyserNode;
	
	public var timeData:Uint8Array;
	public var audio:AudioElement;
	
	public var timeRatio:Float = 0.0001;
	public var time:Float = 0.0001;
	
	private var _oldFreqByteData	:Array<Int>;
	private var _impulse			:Array<Float> = [];
	private var _callback:Void->Void;
	public var freqByteData			:Uint8Array;
	public var subFreqByteData		:Array<Int>;
	public var freqByteDataAry		:Array<Int>;
	public var freqByteDataAryEase	:Array<Float> = [];
	public var audioContext:AudioContext;
	
	public var isStart:Bool = false;
	public var globalVolume:Float = 1.5;
	//public var audio:AudioElement;
	public static var a:MyAudio;
	
	
	public var _midiA:MidiJsonLoader;
	public var _midiB:MidiJsonLoader;
	private var _midis:Array<MidiJsonLoader>;
	
	private var _oldTime:Float=0;
	public var volume:Float = 0;
	
	
	public function new() 
	{
		super();
		
		if (a != null){
			return;
		}
		
		a = this;///////////////////static		
	}

	public function init(callback:Void->Void):Void {
		
		

		
		_callback = callback;		
		//_handleSuccess(null);
		_midiA = new MidiJsonLoader();
		_midiA.load("sound/nekodemo_bpm120vo.json", NoteonData.VOCAL, _onLoad1);
		
	}
	
	private function _onLoad1():Void
	{
		_midiB = new MidiJsonLoader();
		_midiB.load("sound/nekodemo_bpm120beat.json", NoteonData.BEAT, _onLoad2);
	}
	
	function _onLoad2() 
	{
		
		_midis = [
			_midiA,
			_midiB
		];
		
		_init();
		
	}
	
	private function _init():Void
	{

		
		audio = Browser.document.createAudioElement();
		audio.src = "sound/nyangle.mp3";
		Browser.document.body.appendChild(audio);
		
		//if ( OsChecker.isMobile() ){
		if (true){
			
			audio.autoplay = false;
			audio.volume = 0.0;	
			//audio.loop = true;
			
			Page.showStart(_onTouchStart);
		}else{

			Browser.document.getElementById("btn").style.display = "none";
			
			audio.addEventListener("canplaythrough", _onLoad);
			audio.autoplay = false;
			audio.volume = 0.1;
			audio.loop = true;
			
		}
		
		#if debug
			Dat.gui.add(this, "timeRatio").listen();
			Dat.gui.add(this, "time").listen();
			Dat.gui.add(this.audio, "currentTime").listen();
			Dat.gui.add(this, "pause");
		#end
		
	}
	
	public function pause():Void{
		
		this.audio.pause();
		
	}

	//クリックされたら
	private function _onTouchStart():Void{
		
		//クリックされたらロード開始
		if(OsChecker.isMobile()){
			Page.showLoading(0.1);
		}else{
			Page.showLoading(0.5);			
		}
		
		audio.addEventListener("ended", _onEnd);
		audio.addEventListener("canplaythrough", _onLoad);
		audio.load();
		
	}
	
	private function _onEnd(e):Void 
	{
		//ロード終了
		audio.play();
	}
	
	
	/**
	 * onLoad
	 */
	private function _onLoad( e ):Void{

		audio.removeEventListener("canplaythrough", _onLoad);
		
		Dat.gui.add(audio, "duration");
		
		Page.hideStart();
		Page.hideLoading();/////////////////
		
		_callback();
		
	}
	
	
	public function play():Void{

		isStart = true;		
		
		//audio wo tween
		
		this.volume = 0;
		TweenMax.to(this, 2, {
			volume:0.5,
			ease:Power0.easeInOut,
			onUpdate: _onUpdate
		});
		
		audio.play();
		update();
				
	}
	
	
	
	private function _onUpdate():Void{
		audio.volume = this.volume;	
	}
	
	
	
	/**
	 * 
	 */
	public function update():Void {
		
		if (!isStart) {
			trace("not work");
			return;
		}

		//Tracer.info( "duration" + this.audio.duration );
		
		timeRatio = getTimeRatio();
		time = getTime();
		_calcMidi();
		//_calcFFT();
		
	}

	
	//曲が終了しているかどうかを見る
	private function _calcMidi():Void{
		
		var currentTime:Float =  this.getTime();
		
		for ( j in 0..._midis.length){
			
			var midi:MidiJsonLoader = _midis[j];
			var notes:Array<NoteonData> = midi.noteList;
			for(i in 0...notes.length){
				
				var time0:Float = _oldTime;
				var time1:Float = currentTime;
				var t:Float = notes[ i ].time;// + 1.9;// this.audio.currentTime;
				
				if (time0 < t && t <= time1){
					//Tracer.info(t + " noteon");
					this.dispatchEvent( { type: EVENT_NOTEON, data: notes[i] } );
				}
				
				
				
			}
		}
		
		//終了したら
		if (currentTime < _oldTime){
			Tracer.info("終了 " + currentTime + "/" + _oldTime);
			this.dispatchEvent( { type: EVENT_FINISH } );
		}
		
		//0.5secずつ
		if ( Math.abs( (currentTime * 2) % 1 - (_oldTime * 2) % 1 ) > 0.9 ){
			//Tracer.info("aa");
			this.dispatchEvent( { type: EVENT_500MS } );
		}
		
		
		_oldTime = currentTime;
	}
	
	
	
	//現在の時間を取得する
	public function getTime():Float{
		return this.audio.currentTime % (this.audio.duration / LOOP_NUM);
	}
	
	//現在の時間の比率
	public function getTimeRatio():Float{
		return getTime() / (this.audio.duration / LOOP_NUM);
	}
	
	public function getDuration():Float{
		return this.audio.duration / LOOP_NUM;
	}
	
	
	
}