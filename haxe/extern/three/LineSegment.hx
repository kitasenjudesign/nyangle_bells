package three;

import Three;

@:native("THREE.LineSegments")
extern class LineSegment extends Object3D {
    var geometry : Geometry;
    var material : Material;
    var mode : LineType;
    function new( geometry : Geometry, ?material : Material, ?type : LineType ) : Void;
    // override public function clone(?object:Line) : Line;
}
