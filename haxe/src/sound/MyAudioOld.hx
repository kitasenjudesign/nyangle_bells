package sound;
import common.Config;
import common.Dat;
import data.NoteonData;
import js.Browser;
import js.html.AudioElement;
import js.html.DivElement;
import js.html.Uint8Array;
import js.html.audio.AnalyserNode;
import js.html.audio.AudioContext;
import js.html.audio.MediaElementAudioSourceNode;
import js.html.audio.MediaStreamAudioSourceNode;
import three.EventDispatcher;
import tween.TweenMax;

/**
 * ...
 * @author nabe
 */
class MyAudioOld extends EventDispatcher
{

	public static inline var EVENT_NOTEON:String = "noteon";
	public static inline var EVENT_FINISH:String = "finish";//終了したら
	
	public static inline var FFTSIZE:Int = 64;
	public static inline var LOOP_NUM:Int = 2;
	
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
	
	public function new() 
	{
		super();
	}

	public function init(callback:Void->Void):Void {
		
		
		if (a != null){
			
			Browser.window.alert("no");
			return;
			
		}
		
		a = this;///////////////////static
		
		//Tracer.debug("init");
		globalVolume = 1.2;// Config.globalVol;
		
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
		
		_handleSuccess();
	}
	
	
	
	private function _handleError(evt):Void
	{
		Browser.window.alert("err");
	}
	
	private function _handleSuccess():Void
	{
		
		//Tracer.info("+++++++++++++++");
		//Tracer.info( _midi.noteList );
		
		
		//audio
		audio = Browser.document.createAudioElement();
		audio.src = "sound/nekodemobpm120.mp3";
				audio.autoplay = true;
				audio.loop = true;
				audio.volume = 0.1;
				Browser.document.body.appendChild(audio);
				
				
				
				
		// Create a new audio context (that allows us to do all the Web Audio stuff)
			//var audioContext:AudioContext;// = new AudioContext();
			if (untyped __js__("typeof(webkitAudioContext)") != "undefined") {
				audioContext = untyped __js__("new AudioContext()");
			} else {
				audioContext = new js.html.audio.AudioContext();
			}
		
		// Create a new analyser
			analyser = audioContext.createAnalyser();
			analyser.fftSize = 64;

		// Create a new audio source from the <audio> element
		var source:MediaElementAudioSourceNode = audioContext.createMediaElementSource(audio);
			// Connect up the output from the audio source to the input of the analyser
			source.connect(untyped analyser);
			// Connect up the audio output of the analyser to the audioContext destination i.e. the speakers (The analyser takes the output of the <audio> element and swallows it. If we want to hear the sound of the <audio> element then we need to re-route the analyser's output to the speakers)
			analyser.connect(untyped audioContext.destination);

	
		audio.play();
		
		
		// Create a new analyser
		analyser.fftSize = FFTSIZE;

		_impulse = [];
		subFreqByteData = [];
		freqByteDataAry = [];
		_oldFreqByteData = [];
		for (i in 0...FFTSIZE) {
			subFreqByteData[i]	= 0;
			freqByteDataAryEase[i] = 0;
			_oldFreqByteData[i]	= 0;
		}
		
		//source.connect(untyped audioContext.destination);
		source.connect(untyped analyser,0);
		// Connect up the audio output of the analyser to the audioContext destination i.e. the speakers (The analyser takes the output of the <audio> element and swallows it. If we want to hear the sound of the <audio> element then we need to re-route the analyser's output to the speakers)
		//analyser.connect(untyped audioContext.destination);
		
		isStart = true;
		
		//Dat.gui.add(this, "globalVolume", 0, 3.00).step(0.01).listen();
		//Dat.gui.add(this, "setImpulse" );
		Dat.gui.add(this, "timeRatio").listen();
		Dat.gui.add(this, "time").listen();
		Dat.gui.add(this.audio, "currentTime").listen();
		
		setImpulse();
		update();
		
		
		
		//Dat.gui.add(this.audio, "currentTime").listen();
		
		//debug
		//freqByteDataAry = [];
		//for ( i in 0...freqByteData.length) {
		//	freqByteDataAry[i] = Math.floor(Math.random() * 255);
		//}
		_callback();
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
					trace(t + " noteon");
					this.dispatchEvent( { type: EVENT_NOTEON, data: notes[i] } );
				}
			}
			
		}
		
		//終了したら
		if (currentTime < _oldTime){
			this.dispatchEvent( { type: EVENT_FINISH } );
		}
		
		_oldTime = currentTime;
	}
	
	
	
	
	//曲が終了しているかどうかを見る
	private function _calcFFT():Void{
		
		// Setup the next frame of the drawing
		//webkitRequestAnimationFrame(draw);
  
		// Create a new array that we can copy the frequency data into
		freqByteData = new Uint8Array(analyser.frequencyBinCount);
		
		// Copy the frequency data into our new array
		analyser.getByteFrequencyData(freqByteData);

		
		for (i in 0...freqByteData.length) { 
			subFreqByteData[i] = freqByteData[i] - _oldFreqByteData[i];
		}
		
		for (i in 0...freqByteData.length) {
			_oldFreqByteData[i] = freqByteData[i];
		}
		
		timeData = new Uint8Array(analyser.fftSize);
		analyser.getByteTimeDomainData(timeData);
		
		//
		for ( i in 0...freqByteData.length) {
			freqByteData[i] = Math.floor( freqByteData[i] * globalVolume ) +Math.floor( _impulse[i] );
		}		
		for ( i in 0...freqByteData.length) {
			subFreqByteData[i] = Math.floor( subFreqByteData[i] * globalVolume );
		}		
		for ( i in 0...freqByteData.length) {
			timeData[i] = Math.floor( timeData[i] * globalVolume );
		}		
	
		
		//copy
		for ( i in 0...freqByteData.length) {
			freqByteDataAry[i] = freqByteData[i];
			freqByteDataAryEase[i] += (freqByteData[i] - freqByteDataAryEase[i]) / 2;
		}
		
		_updateInpulse();		
	}
	
	
	//オブジェクトを作ろう
	
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
	
	/**
	 * 
	 */
	private function _updateInpulse():Void {
	
		for (i in 0...FFTSIZE) {
			_impulse[i] += (0 -_impulse[i]) / 2;
		}
		
	}
		
	public function setImpulse(stlength:Float=1):Void {
	
		for (i in 0...FFTSIZE) {
			_impulse[i] = 255 * Math.random() * stlength;
		}		
		
	}
	
	public function tweenVol(tgt:Float) 
	{
		//Browser.window.alert("tweenVol");
		//this.globalVolume
		TweenMax.to(this, 0.2, {
			globalVolume:tgt
		});
	}
	
	
}