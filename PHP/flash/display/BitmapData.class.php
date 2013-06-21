<?php

	namespace flash\display;

	class BitmapData extends \sirius\SiriusObject {

	
		public function applyFilter($sourceBitmapData,$sourceRect,$destPoint,$filter){
			$this->runCommand('applyFilter', func_get_args());
		}
	
		public function __construct($width,$height,$transparent,$fillColor){
			$this->width = $width;
			$this->height = $height;
			$this->transparent = $transparent;
			$this->fillColor = $fillColor;
		}
	
		public function clone(){
			$this->runCommand('clone', func_get_args());
		}
	
		public function colorTransform($rect,$colorTransform){
			$this->runCommand('colorTransform', func_get_args());
		}
	
		public function compare($otherBitmapData){
			$this->runCommand('compare', func_get_args());
		}
	
		public function copyChannel($sourceBitmapData,$sourceRect,$destPoint,$sourceChannel,$destChannel){
			$this->runCommand('copyChannel', func_get_args());
		}
	
		public function copyPixels($sourceBitmapData,$sourceRect,$destPoint,$alphaBitmapData,$alphaPoint,$mergeAlpha){
			$this->runCommand('copyPixels', func_get_args());
		}
	
		public function dispose(){
			$this->runCommand('dispose', func_get_args());
		}
	
		public function draw($source,$matrix,$colorTransform,$blendMode,$clipRect,$smoothing){
			$this->runCommand('draw', func_get_args());
		}
	
		public function fillRect($rect,$color){
			$this->runCommand('fillRect', func_get_args());
		}
	
		public function floodFill($x,$y,$color){
			$this->runCommand('floodFill', func_get_args());
		}
	
		public function generateFilterRect($sourceRect,$filter){
			$this->runCommand('generateFilterRect', func_get_args());
		}
	
		public function getColorBoundsRect($mask,$color,$findColor){
			$this->runCommand('getColorBoundsRect', func_get_args());
		}
	
		public function getPixel($x,$y){
			$this->runCommand('getPixel', func_get_args());
		}
	
		public function getPixel32($x,$y){
			$this->runCommand('getPixel32', func_get_args());
		}
	
		public function getPixels($rect){
			$this->runCommand('getPixels', func_get_args());
		}
	
		public function getVector($rect){
			$this->runCommand('getVector', func_get_args());
		}
	
		public function histogram($hRect){
			$this->runCommand('histogram', func_get_args());
		}
	
		public function hitTest($firstPoint,$firstAlphaThreshold,$secondObject,$secondBitmapDataPoint,$secondAlphaThreshold){
			$this->runCommand('hitTest', func_get_args());
		}
	
		public function lock(){
			$this->runCommand('lock', func_get_args());
		}
	
		public function merge($sourceBitmapData,$sourceRect,$destPoint,$redMultiplier,$greenMultiplier,$blueMultiplier,$alphaMultiplier){
			$this->runCommand('merge', func_get_args());
		}
	
		public function noise($randomSeed,$low,$high,$channelOptions,$grayScale){
			$this->runCommand('noise', func_get_args());
		}
	
		public function paletteMap($sourceBitmapData,$sourceRect,$destPoint,$redArray,$greenArray,$blueArray,$alphaArray){
			$this->runCommand('paletteMap', func_get_args());
		}
	
		public function perlinNoise($baseX,$baseY,$numOctaves,$randomSeed,$stitch,$fractalNoise,$channelOptions,$grayScale,$offsets){
			$this->runCommand('perlinNoise', func_get_args());
		}
	
		public function pixelDissolve($sourceBitmapData,$sourceRect,$destPoint,$randomSeed,$numPixels,$fillColor){
			$this->runCommand('pixelDissolve', func_get_args());
		}
	
		public function scroll($x,$y){
			$this->runCommand('scroll', func_get_args());
		}
	
		public function setPixel($x,$y,$color){
			$this->runCommand('setPixel', func_get_args());
		}
	
		public function setPixel32($x,$y,$color){
			$this->runCommand('setPixel32', func_get_args());
		}
	
		public function setPixels($rect,$inputByteArray){
			$this->runCommand('setPixels', func_get_args());
		}
	
		public function setVector($rect,$inputVector){
			$this->runCommand('setVector', func_get_args());
		}
	
		public function threshold($sourceBitmapData,$sourceRect,$destPoint,$operation,$threshold,$color,$mask,$copySource){
			$this->runCommand('threshold', func_get_args());
		}
	
		public function unlock($changeRect){
			$this->runCommand('unlock', func_get_args());
		}

	}