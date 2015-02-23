package js.three;

import js.html.*;

// Renderers / Shaders /////////////////////////////////////////////////////////////////////
@:native("THREE.ShaderChunk")
extern interface ShaderChunk implements Dynamic<String>
{
	var alphamap_fragment : String;
	var alphamap_pars_fragment : String;
	var alphatest_fragment : String;
	var bumpmap_pars_fragment : String;
	var color_fragment : String;
	var color_pars_fragment : String;
	var color_pars_vertex : String;
	var color_vertex : String;
	var default_vertex : String;
	var defaultnormal_vertex : String;
	var envmap_fragment : String;
	var envmap_pars_fragment : String;
	var envmap_pars_vertex : String;
	var envmap_vertex : String;
	var fog_fragment : String;
	var fog_pars_fragment : String;

	var lightmap_fragment : String;
	var lightmap_pars_fragment : String;
	var lightmap_pars_vertex : String;
	var lightmap_vertex : String;
	var lights_lambert_pars_vertex : String;
	var lights_lambert_vertex : String;
	var lights_phong_fragment : String;
	var lights_phong_pars_fragment : String;
	var lights_phong_pars_vertex : String;
	var lights_phong_vertex : String;
	var linear_to_gamma_fragment : String;
	var logdepthbuf_fragment : String;
	var logdepthbuf_pars_fragment : String;
	var logdepthbuf_pars_vertex : String;
	var logdepthbuf_vertex : String;
	var map_fragment : String;
	var map_pars_fragment : String;
	var map_pars_vertex : String;
	var map_particle_fragment : String;
	var map_particle_pars_fragment : String;
	var map_vertex : String;
	var morphnormal_vertex : String;
	var morphtarget_pars_vertex : String;
	var morphtarget_vertex : String;
	var normalmap_pars_fragment : String;
	var shadowmap_fragment : String;
	var shadowmap_pars_fragment : String;
	var shadowmap_pars_vertex : String;
	var shadowmap_vertex : String;
	var skinbase_vertex : String;
	var skinning_pars_vertex : String;
	var skinning_vertex : String;
	var skinnormal_vertex : String;
	var specularmap_fragment : String;
	var specularmap_pars_fragment : String;
	var worldpos_vertex : String;
}