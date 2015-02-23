package js.three;

import js.html.*;

// Wrapping modes
@:native("THREE.Wrapping")
extern enum Wrapping
{
	RepeatWrapping;
	ClampToEdgeWrapping;
	MirroredRepeatWrapping;
}