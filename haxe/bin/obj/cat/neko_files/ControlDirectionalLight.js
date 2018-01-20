ControlDirectionalLight = function( hex, intensity ){
    

    this.light = new THREE.DirectionalLight( hex, intensity );
    this.angle = new THREE.Vector3(0,0,1);

    this.helper = new THREE.DirectionalLightHelper( this.light, 10); 

    this.setDirection = function( p ) {
	this.light.position.copy(p).normalize();
    };
 

    this.setAngle = function ( radx, rady ) {
	var e = new THREE.Euler(
	    (radx / 360.0) * (Math.PI * 2.0),
	    (rady / 360.0) * (Math.PI * 2.0),
	    0);

	var a = new THREE.Vector3(0,0,1);
	a.applyEuler( e );
	this.angle.copy(a);
	this.setDirection( this.angle);
	this.helper.update();
    };


    this.setDirection( this.angle);

};

