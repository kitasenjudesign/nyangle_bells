/**
 *
 */

function MotionViewGui() {

	var controls = {

	    gui: null,
	    "Lock Camera": false,
	    "Show Debug" : true,
	    "Show Skeleton": false,
	    "Step Mode" : false,
	    "Speed": 1.0,
	    "Local Mode":false,

	    "Show Light": false,
	    "X1": 360,
	    "Y1": 0,
	    "intensity1":1.5,
	    "color1" : "#ffffff",
	    "X2": 180,
	    "Y2": 0,
	    "intensity2":1.5,
	    "color2" : "#ffffff",

	};

//	controls.animations = animations;

	this.showModel = function() {

	    return controls['Show Model'];

	};

	this.showSkeleton = function() {

	    return controls['Show Skeleton'];

	};

	this.getTimeScale = function() {
	    
	    return controls['Speed'];
	    
	};

        this.getLight1 = function(){
	    return new Array( controls['X1'], controls['Y1'], controls['intensity1']);
	};

        this.getLight2 = function(){
	    return new Array( controls['X2'], controls['Y2'], controls['intensity2']);
	};

        this.getColor1 = function(){
	    return controls['color1'];
	}

        this.getColor2 = function(){
	    return controls['color2'];
	}
    
    
    this.update = function() {


    };

	var init = function() {
	    controls.gui = new dat.GUI();


	    var settings = controls.gui.addFolder( 'Settings' );
	    var playback = controls.gui.addFolder( 'Playback' );
	    
	    settings.add( controls, "Lock Camera" ).onChange( controls.lockCameraChanged );
	    settings.add( controls, "Show Light" ).onChange( controls.showLightHelperChanged );
	    settings.add( controls, "Show Debug" ).onChange( controls.showDebugChanged );
	    settings.add( controls, "Step Mode" ).onChange( controls.StepChanged );
	    settings.add( controls, "Speed", 0, 1, 0.01 );

	    //var mode = controls.gui.addFolder( 'Motion Mode' );
	    //playback.add( controls, "restart" );
	    //playback.add( controls, "pause" );
	    //playback.add( controls, "step" );

	    var lights = controls.gui.addFolder( 'Light1' );
	    lights.add( controls, "X1").min(0).max(360).step(1.0);
	    lights.add( controls, "Y1").min(0).max(360).step(1.0);
	    lights.add( controls, "intensity1", 0, 10, 0.01 );
	    lights.addColor( controls, "color1");

	    var lights2 = controls.gui.addFolder( 'Light2' );
	    lights2.add( controls, "X2").min(0).max(360).step(1.0);
	    lights2.add( controls, "Y2").min(0).max(360).step(1.0);
	    lights2.add( controls, "intensity2", 0, 10, 0.01 );
	    lights2.addColor( controls, "color2");

	    settings.open();
	    playback.open();
	    lights.open();
	    lights2.open();

        controls.gui.close();
	    //mode.open();

	}


    controls.restart = function(){
	var ev  = new CustomEvent( 're-start-animation',{detail:0});
	window.dispatchEvent(ev);
    };

    controls.step = function(){
	var ev  = new CustomEvent( 'step-animation',{detail:0});
	window.dispatchEvent(ev);
    };

    controls.stop = function() {
	var stopEvent = new CustomEvent( 'stop-animation' );
	window.dispatchEvent( stopEvent );

    };

    controls.pause = function() {
	var pauseEvent = new CustomEvent( 'pause-animation' );
	window.dispatchEvent( pauseEvent );
    };


    controls.lockCameraChanged = function() {

	var data = {
	    detail: {
		shouldLock: controls['Lock Camera']
	    }
	}
	
	window.dispatchEvent( new CustomEvent( 'toggle-lock-camera', data ) );
    }

    controls.showSkeletonChanged = function() {

	var data = {
	    detail: {
		shouldShow: controls['Show Skeleton']
	    }
	}

	window.dispatchEvent( new CustomEvent( 'toggle-show-skeleton', data ) );
    }


    controls.showLightHelperChanged = function() {

	var data = {
	    detail: {
		shouldShow: controls['Show Light']
	    }
	}
		window.dispatchEvent( new CustomEvent( 'toggle-show-lighthelper', data ) );
	}

    controls.showDebugChanged = function() {

	var data = {
	    detail: {
		shouldShow: controls['Show Debug']
	    }
	}
	window.dispatchEvent( new CustomEvent( 'toggle-show-debug', data ) );
    }

    controls.StepChanged = function() {

	var data = {
	    detail: {
		shouldShow: controls['Step Mode']
	    }
	}
	window.dispatchEvent( new CustomEvent( 'toggle-step-mode', data ) );
    }

    
    controls.modeChanged = function(){
	var data = {
	    detail: {
		localMode: controls['Local Mode']
	    }
	}

	window.dispatchEvent( new CustomEvent( 'toggle-change-mode', data ) );

    }


    init.call(this);

}
