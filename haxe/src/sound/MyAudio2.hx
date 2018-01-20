package sound;
import common.Dat;
import js.Browser;
import js.html.audio.AnalyserNode;
import js.html.audio.AudioContext;
import js.html.audio.MediaElementAudioSourceNode;
import js.html.audio.MediaStreamAudioSourceNode;
import js.html.AudioElement;
import js.html.Uint8Array;

/**
 * ...
 * @author nabe
 */
class MyAudio2
{

	private var analyser:AnalyserNode;
	
	public var timeData:Uint8Array;
	public var audio:AudioElement;
	
	private var _oldFreqByteData	:Array<Int>;
	
	public var freqByteData		:Uint8Array;
	public var subFreqByteData	:Array<Int>;
	
	public var isStart:Bool = false;
	public var globalVolume:Float = 0.899;
	
	static public inline var FFTSIZE:Int = 64;
	
	
	public function new() 
	{
		
	}

	public function init():Void {
		
		var nav:Dynamic = Browser.navigator;
		nav.webkitGetUserMedia({
			audio: true
		}, untyped _handleSuccess, untyped _handleError);
	
	}
	
	private function _handleError(evt):Void
	{
		Browser.window.alert("err");
	}
	
	private function _handleSuccess(evt):Void
	{
		//freqByteData = new Uint8Array();
		
		var audioContext:AudioContext = new AudioContext();
        var source:MediaStreamAudioSourceNode      = audioContext.createMediaStreamSource(evt);
        analyser = audioContext.createAnalyser(evt);

		// Create a new analyser
		analyser.fftSize = FFTSIZE;

		subFreqByteData = [];
		_oldFreqByteData = [];
		for (i in 0...FFTSIZE) {
			subFreqByteData[i]	= 0;
			_oldFreqByteData[i]	= 0;
		}
		
		//source.connect(untyped audioContext.destination);
		source.connect(untyped analyser);
		// Connect up the audio output of the analyser to the audioContext destination i.e. the speakers (The analyser takes the output of the <audio> element and swallows it. If we want to hear the sound of the <audio> element then we need to re-route the analyser's output to the speakers)
		//analyser.connect(untyped audioContext.destination);
		isStart = true;
		
		Dat.gui.add(this, "globalVolume", 0.1, 3).step(0.1);
	}
	
	//http://jsdo.it/kimmy/iBGe
	

	// Draw the audio frequencies to screen
	public function update():Void {
		
		if (!isStart) return;
		
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
			freqByteData[i] = Math.floor( freqByteData[i] * globalVolume );
		}		
		for ( i in 0...freqByteData.length) {
			subFreqByteData[i] = Math.floor( subFreqByteData[i] * globalVolume );
		}		
		for ( i in 0...freqByteData.length) {
			timeData[i] = Math.floor( timeData[i] * globalVolume );
		}		
		
		
		
		
		// Clear the drawing display
		//canvasContext.clearRect(0, 0, canvas.width, canvas.height);

		// For each "bucket" in the frequency data, draw a line corresponding to its magnitude

		/*
		trace( freqByteData[5] );
		for (i in 0... freqByteData.length) {
			//canvasContext.fillRect(i, canvas.height - freqByteData[i], 1, canvas.height);
			//freqByteData[i]
		}
		*/
	}

	
		
	
	
}