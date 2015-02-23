package js.three;

import js.html.*;

/**
 * The WebGL renderer displays your beautifully crafted scenes using WebGL, if your device supports it.
 * This renderer has way better performance than CanvasRenderer.
 *
 * @see <a href="https://github.com/mrdoob/three.js/blob/master/src/renderers/WebGLRenderer.js">src/renderers/WebGLRenderer.js</a>
 */
@:native("THREE.WebGLRenderer")
extern class WebGLRenderer implements Renderer
{
	/**
	 * parameters is an optional object with properties defining the renderer's behaviour. The constructor also accepts no parameters at all. In all cases, it will assume sane defaults when parameters are missing.
	 */
	function new(?parameters:WebGLRendererParameters) : Void;

	/**
	 * A Canvas where the renderer draws its output.
	 * This is automatically created by the renderer in the constructor (if not provided already); you just need to add it to your page.
	 */
	var domElement : js.html.CanvasElement;

	/**
	 * The HTML5 Canvas's 'webgl' context obtained from the canvas where the renderer will draw.
	 */
	//  If you are using three.d.ts with other complete definitions of webgl, context:js.html.webgl.RenderingContext is suitable.
	//context:js.html.webgl.RenderingContext;
	var context : Dynamic;

	var devicePixelRatio : Float;

	/**
	 * Defines whether the renderer should automatically clear its output before rendering.
	 */
	var autoClear : Bool;

	/**
	 * If autoClear is true, defines whether the renderer should clear the color buffer. Default is true.
	 */
	var autoClearColor : Bool;

	/**
	 * If autoClear is true, defines whether the renderer should clear the depth buffer. Default is true.
	 */
	var autoClearDepth : Bool;

	/**
	 * If autoClear is true, defines whether the renderer should clear the stencil buffer. Default is true.
	 */
	var autoClearStencil : Bool;

	/**
	 * Defines whether the renderer should sort objects. Default is true.
	 */
	var sortObjects : Bool;

	/**
	 * Default is false.
	 */
	var gammaInput : Bool;

	/**
	 * Default is false.
	 */
	var gammaOutput : Bool;

	/**
	 * Default is false.
	 */
	var shadowMapEnabled : Bool;

	/**
	 * Default is true.
	 */
	var shadowMapAutoUpdate : Bool;

	/**
	 * Defines shadow map type (unfiltered, percentage close filtering, percentage close filtering with bilinear filtering in shader)
	 * Options are THREE.BasicShadowMap, THREE.PCFShadowMap, THREE.PCFSoftShadowMap. Default is THREE.PCFShadowMap.
	 */
	var shadowMapType : ShadowMapType;

	/**
	 * Default is true
	 */
	var shadowMapCullFace : CullFace;

	/**
	 * Default is false.
	 */
	var shadowMapDebug : Bool;

	/**
	 * Default is false.
	 */
	var shadowMapCascade : Bool;

	/**
	 * Default is 8.
	 */
	var maxMorphTargets : Float;

	/**
	 * Default is 4.
	 */
	var maxMorphNormals : Float;

	/**
	 * Default is true.
	 */
	var autoScaleCubemaps : Bool;

	/**
	 * An array with render plugins to be applied before rendering.
	 * Default is an empty array, or [].
	 */
	var renderPluginsPre : Array<RendererPlugin>;

	/**
	 * An array with render plugins to be applied after rendering.
	 * Default is an empty array, or [].
	 */
	var renderPluginsPost : Array<RendererPlugin>;

	/**
	 * An object with a series of statistical information about the graphics board memory and the rendering process. Useful for debugging or just for the sake of curiosity. The object contains the following fields:
	 */
	var info : {
		memory: {
			programs: Float,
			geometries: Float,
			textures: Float
		},
		render : {
			calls: Float,
			vertices: Int,
			faces: Int,
			points: Float
		}
	};

	var shadowMapPlugin : ShadowMapPlugin;

	/**
	 * Return the WebGL context.
	 */
	function getContext() : js.html.webgl.RenderingContext;

	/**
	 * Return a Boolean true if the context supports vertex textures.
	 */
	function supportsVertexTextures() : Bool;
	function supportsFloatTextures() : Bool;
	function supportsStandardDerivatives() : Bool;
	function supportsCompressedTextureS3TC() : Bool;
	function getMaxAnisotropy() : Int;
	function getPrecision() : String;

	/**
	 * Resizes the output canvas to (width, height), and also sets the viewport to fit that size, starting in (0, 0).
	 */
	function setSize(width:Float, height:Float, ?updateStyle:Bool) : Void;

	/**
	 * Sets the viewport to render from (x, y) to (x + width, y + height).
	 */
	function setViewport(?x:Float, ?y:Float, ?width:Float, ?height:Float) : Void;

	/**
	 * Sets the scissor area from (x, y) to (x + width, y + height).
	 */
	function setScissor(x:Float, y:Float, width:Float, height:Float) : Void;

	/**
	 * Enable the scissor test. When this is enabled, only the pixels within the defined scissor area will be affected by further renderer actions.
	 */
	function enableScissorTest(enable:Bool) : Void;

	/**
	 * Sets the clear color, using color for the color and alpha for the opacity.
	 */
	@:overload(function(color:String, ?alpha:Float):Void{})
	@:overload(function(color:Int, ?alpha:Float):Void{})
	function setClearColor(color:Color, ?alpha:Float) : Void;

	/**
	 * Sets the clear color, using hex for the color and alpha for the opacity.
	 *
	 * @example
	 * // Creates a renderer with black background
	 * var renderer = new THREE.WebGLRenderer();
	 * renderer.setSize(200, 100);
	 * renderer.setClearColorHex(0x000000, 1);
	 */
	function setClearColorHex(hex:Int, alpha:Float) : Void;

	/**
	 * Returns a THREE.Color instance with the current clear color.
	 */
	function getClearColor() : Color;

	/**
	 * Returns a float with the current clear alpha. Ranges from 0 to 1.
	 */
	function getClearAlpha() : Float;

	/**
	 * Tells the renderer to clear its color, depth or stencil drawing buffer(s).
	 * If no parameters are passed, no buffer will be cleared.
	 */
	function clear(?color:Bool, ?depth:Bool, ?stencil:Bool) : Void;

	function clearColor() : Void;
	function clearDepth() : Void;
	function clearStencil() : Void;
	function clearTarget(renderTarget:WebGLRenderTarget, color:Bool, depth:Bool, stencil:Bool) : Void;

	/**
	 * Initialises the postprocessing plugin, and adds it to the renderPluginsPost array.
	 */
	function addPostPlugin(plugin:RendererPlugin) : Void;

	/**
	 * Initialises the preprocessing plugin, and adds it to the renderPluginsPre array.
	 */
	function addPrePlugin(plugin:RendererPlugin) : Void;

	/**
	 * Tells the shadow map plugin to update using the passed scene and camera parameters.
	 *
	 * @param scene an instance of Scene
	 * @param camera — an instance of Camera
	 */
	function updateShadowMap(scene:Scene, camera:Camera) : Void;

	function renderBufferImmediate(object:Object3D, program:Dynamic, material:Material) : Void;

	function renderBufferDirect(camera:Camera, lights:Array<Light>, fog:Fog, material:Material, geometryGroup:Dynamic, object:Object3D) : Void;

	function renderBuffer(camera:Camera, lights:Array<Light>, fog:Fog, material:Material, geometryGroup:Dynamic, object:Object3D) : Void;

	/**
	 * Render a scene using a camera.
	 * The render is done to the renderTarget (if specified) or to the canvas as usual.
	 * If forceClear is true, the canvas will be cleared before rendering, even if the renderer's autoClear property is false.
	 */
	@:overload(function(scene:Scene,camera:Camera,?renderTarget:RenderTarget,?forceClear:Bool):Void{})
	function render(scene:Scene, camera:Camera) : Void;
	function renderImmediateObject(camera:Camera, lights:Array<Light>, fog:Fog, material:Material, object:Object3D) : Void;
	function initMaterial(material:Material, lights:Array<Light>, fog:Fog, object:Object3D) : Void;

	/**
	 * Used for setting the gl frontFace, cullFace states in the GPU, thus enabling/disabling face culling when rendering.
	 * If cullFace is false, culling will be disabled.
	 * @param cullFace "back", "front", "front_and_back", or false.
	 * @param frontFace "ccw" or "cw
	 */
	function setFaceCulling(?cullFace:CullFace, ?frontFace:FrontFaceDirection) : Void;
	function setMaterialFaces(material:Material) : Void;
	function setDepthTest(depthTest:Bool) : Void;
	function setDepthWrite(depthWrite:Bool) : Void;
	function setBlending(blending:Blending, blendEquation:BlendingEquation, blendSrc:BlendingSrcFactor, blendDst:BlendingDstFactor) : Void;
	function setTexture(texture:Texture, slot:Float) : Void;
	function setRenderTarget(renderTarget:RenderTarget) : Void;
}