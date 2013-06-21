<?php

	namespace flash\display;

	class Graphics extends \sirius\SiriusObject {

		public function beginBitmapFill($bitmap,$matrix,$repeat,$smooth){
			$this->runCommand('beginBitmapFill', func_get_args());
		}
	
		public function beginFill($color,$alpha){
			$this->runCommand('beginFill', func_get_args());
		}
	
		public function beginGradientFill($type,$colors,$alphas,$ratios,$matrix,$spreadMethod,$interpolationMethod,$focalPointRatio){
			$this->runCommand('beginGradientFill', func_get_args());
		}
	
		public function beginShaderFill($shader,$matrix){
			$this->runCommand('beginShaderFill', func_get_args());
		}
	
		public function clear(){
			$this->runCommand('clear', func_get_args());
		}
	
		public function copyFrom($sourceGraphics){
			$this->runCommand('copyFrom', func_get_args());
		}
	
		public function cubicCurveTo($controlX1,$controlY1,$controlX2,$controlY2,$anchorX,$anchorY){
			$this->runCommand('cubicCurveTo', func_get_args());
		}
	
		public function curveTo($controlX,$controlY,$anchorX,$anchorY){
			$this->runCommand('curveTo', func_get_args());
		}
	
		public function drawCircle($x,$y,$radius){
			$this->runCommand('drawCircle', func_get_args());
		}
	
		public function drawEllipse($x,$y,$width,$height){
			$this->runCommand('drawEllipse', func_get_args());
		}
	
		public function drawGraphicsData($graphicsData){
			$this->runCommand('drawGraphicsData', func_get_args());
		}
	
		public function drawPath($commands,$data,$winding){
			$this->runCommand('drawPath', func_get_args());
		}
	
		public function drawRect($x,$y,$width,$height){
			$this->runCommand('drawRect', func_get_args());
		}
	
		public function drawRoundRect($x,$y,$width,$height,$ellipseWidth,$ellipseHeight){
			$this->runCommand('drawRoundRect', func_get_args());
		}
	
		public function drawRoundRectComplex($x,$y,$width,$height,$topLeftRadius,$topRightRadius,$bottomLeftRadius,$bottomRightRadius){
			$this->runCommand('drawRoundRectComplex', func_get_args());
		}
	
		public function drawTriangles($vertices,$indices,$uvtData,$culling){
			$this->runCommand('drawTriangles', func_get_args());
		}
	
		public function endFill(){
			$this->runCommand('endFill', func_get_args());
		}

		public function lineBitmapStyle($bitmap,$matrix,$repeat,$smooth){
			$this->runCommand('lineBitmapStyle', func_get_args());
		}
	
		public function lineGradientStyle($type,$colors,$alphas,$ratios,$matrix,$spreadMethod,$interpolationMethod,$focalPointRatio){
			$this->runCommand('lineGradientStyle', func_get_args());
		}
	
		public function lineShaderStyle($shader,$matrix){
			$this->runCommand('lineShaderStyle', func_get_args());
		}
	
		public function lineStyle($thickness,$color,$alpha,$pixelHinting,$scaleMode,$caps,$joints,$miterLimit){
			$this->runCommand('lineStyle', func_get_args());
		}
	
		public function lineTo($x,$y){
			$this->runCommand('lineTo', func_get_args());
		}
	
		public function moveTo($x,$y){
			$this->runCommand('moveTo', func_get_args());
		}


	}