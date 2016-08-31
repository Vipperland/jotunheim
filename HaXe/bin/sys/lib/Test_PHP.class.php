<?php

class Test_PHP {
	public function __construct(){}
	static function main() {
		$img = new sirius_php_file_Image("../assets/img/image.jpg");
		$img->fit(300, 300, null)->save("../assets/img/test.jpg", null);
	}
	function __toString() { return 'Test_PHP'; }
}
