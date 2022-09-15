<?php
/**
 */

namespace jotun\net;

use \haxe\io\_BytesData\Container;
use \php\_Boot\HxAnon;
use \php\Boot;
use \haxe\Exception;
use \php\Lib;
use \jotun\data\Fragments;
use \jotun\utils\Dice;
use \haxe\Json;
use \php\_Boot\HxString;
use \jotun\data\IFragments;
use \haxe\io\Bytes;

/**
 * ...
 * @author Rafael Moreira <vipperland@live.com,rafael@gateofsirius.com>
 */
class Domain implements IDomain {
	/**
	 * @var string
	 */
	public $client;
	/**
	 * @var IDomainData
	 */
	public $data;
	/**
	 * @var string
	 */
	public $file;
	/**
	 * @var string
	 */
	public $host;
	/**
	 * @var mixed
	 */
	public $input;
	/**
	 * @var mixed
	 */
	public $params;
	/**
	 * @var string
	 */
	public $port;
	/**
	 * @var string
	 */
	public $server;
	/**
	 * @var IFragments
	 */
	public $url;

	/**
	 * @return void
	 */
	public function __construct () {
		#src/jotun/net/Domain.hx:58: characters 3-14
		$this->_parseURI();
	}

	/**
	 * @return string
	 */
	public function _getMultipartKey () {
		#src/jotun/net/Domain.hx:204: lines 204-214
		if ($this->isRequestMethod("POST")) {
			#src/jotun/net/Domain.hx:205: characters 5-58
			$a = $_POST;
			#src/jotun/net/Domain.hx:206: lines 206-208
			if (get_magic_quotes_gpc()) {
				#src/jotun/net/Domain.hx:207: characters 6-105
				reset($a); while(list($k, $v) = each($a)) $a[$k] = stripslashes((string)$v);
			}
			#src/jotun/net/Domain.hx:209: characters 5-46
			$post = Lib::hashOfAssociativeArray($a);
			#src/jotun/net/Domain.hx:210: characters 17-28
			$data = \array_values(\array_map("strval", \array_keys($post->data)));
			$key_current = 0;
			$key_length = \count($data);
			$key_data = $data;
			while ($key_current < $key_length) {
				#src/jotun/net/Domain.hx:210: lines 210-213
				$key = $key_data[$key_current++];
				#src/jotun/net/Domain.hx:211: lines 211-212
				if (HxString::indexOf($key, "Content-Disposition:_form-data;_name") !== -1) {
					#src/jotun/net/Domain.hx:212: characters 7-17
					return $key;
				}
			}
		}
		#src/jotun/net/Domain.hx:215: characters 4-15
		return null;
	}

	/**
	 * Merge POST and GET parameters as one string vector
	 * @return
	 * 
	 * @return mixed
	 */
	public function _getParams () {
		#src/jotun/net/Domain.hx:144: characters 4-77
		$a = array_merge($_GET, $_POST);
		#src/jotun/net/Domain.hx:145: lines 145-147
		if (get_magic_quotes_gpc()) {
			#src/jotun/net/Domain.hx:146: characters 5-104
			reset($a); while(list($k, $v) = each($a)) $a[$k] = stripslashes((string)$v);
		}
		#src/jotun/net/Domain.hx:160: characters 5-43
		return Lib::objectOfAssociativeArray($a);
	}

	/**
	 * Parse Multipart/FormData raw data (properties only)
	 * @param	boundary
	 * @param	data
	 * @return
	 * 
	 * @param string $boundary
	 * @param mixed $data
	 * 
	 * @return mixed
	 */
	public function _getRawData ($boundary, $data = null) {
		#src/jotun/net/Domain.hx:171: lines 171-173
		if ($data === null) {
			#src/jotun/net/Domain.hx:172: characters 5-14
			$data = new HxAnon();
		}
		#src/jotun/net/Domain.hx:174: characters 4-80
		$input = file_get_contents('php://input');
		#src/jotun/net/Domain.hx:175: characters 4-53
		$result = HxString::split($input, $boundary);
		#src/jotun/net/Domain.hx:176: lines 176-197
		Dice::Values($result, function ($v) use (&$data) {
			#src/jotun/net/Domain.hx:177: lines 177-179
			if (($v === null) || (mb_strlen($v) === 0)) {
				#src/jotun/net/Domain.hx:178: characters 6-12
				return;
			}
			#src/jotun/net/Domain.hx:180: lines 180-196
			if (HxString::indexOf($v, "Content-Disposition: form-data;") < 30) {
				#src/jotun/net/Domain.hx:181: characters 6-102
				$point = HxString::split((HxString::split($v, "Content-Disposition: form-data; name=")->arr[1] ?? null), "\x0D\x0A\x0D\x0A");
				#src/jotun/net/Domain.hx:182: characters 6-55
				$param = HxString::split(($point->arr[0] ?? null), "\"")->join("");
				#src/jotun/net/Domain.hx:183: lines 183-195
				if (HxString::indexOf($param, "Content-Type:") === -1) {
					#src/jotun/net/Domain.hx:184: characters 7-52
					$value = (HxString::split(($point->arr[1] ?? null), "\x0D\x0A")->arr[0] ?? null);
					#src/jotun/net/Domain.hx:185: lines 185-194
					if ((mb_strlen($param) > 0) && (mb_strlen($value) > 0) && ($value !== "null")) {
						#src/jotun/net/Domain.hx:186: lines 186-193
						if (HxString::indexOf($param, "[]") === -1) {
							#src/jotun/net/Domain.hx:187: characters 9-45
							\Reflect::setField($data, $param, $value);
						} else {
							#src/jotun/net/Domain.hx:189: lines 189-191
							if (!\Reflect::hasField($data, $param)) {
								#src/jotun/net/Domain.hx:190: characters 10-43
								\Reflect::setField($data, $param, new \Array_hx());
							}
							#src/jotun/net/Domain.hx:192: characters 9-47
							\Reflect::field($data, $param)->push($value);
						}
					}
				}
			}
		});
		#src/jotun/net/Domain.hx:199: characters 4-15
		return $data;
	}

	/**
	 * @return void
	 */
	public function _parseURI () {
		#src/jotun/net/Domain.hx:74: characters 4-78
		$this->data = Lib::objectOfAssociativeArray($_SERVER);
		#src/jotun/net/Domain.hx:75: characters 4-27
		$this->port = $this->data->SERVER_PORT;
		#src/jotun/net/Domain.hx:76: characters 4-25
		$this->server = (\dirname($_SERVER["SCRIPT_FILENAME"])??'null') . "/";
		#src/jotun/net/Domain.hx:77: characters 4-28
		$this->host = $_SERVER["SERVER_NAME"];
		#src/jotun/net/Domain.hx:78: characters 4-30
		$this->client = $_SERVER["REMOTE_ADDR"];
		#src/jotun/net/Domain.hx:80: characters 4-45
		$boundary = $this->_getMultipartKey();
		#src/jotun/net/Domain.hx:82: lines 82-84
		if ($this->data->CONTENT_TYPE === "application/json") {
			#src/jotun/net/Domain.hx:83: characters 5-81
			$this->input = Json::phpJsonDecode(file_get_contents('php://input'));
		}
		#src/jotun/net/Domain.hx:85: characters 4-25
		$this->params = $this->_getParams();
		#src/jotun/net/Domain.hx:87: lines 87-91
		if ($boundary !== null) {
			#src/jotun/net/Domain.hx:88: characters 5-42
			\Reflect::deleteField($this->params, $boundary);
			#src/jotun/net/Domain.hx:89: characters 5-41
			$boundary = (HxString::split($boundary, "\x0D\x0A")->arr[0] ?? null);
			#src/jotun/net/Domain.hx:90: characters 5-34
			$this->_getRawData($boundary, $this->params);
		}
		#src/jotun/net/Domain.hx:93: characters 4-46
		$this->url = new Fragments($this->data->SCRIPT_NAME, "/");
	}

	/**
	 * @param int $len
	 * 
	 * @return string
	 */
	public function getFQDN ($len = 2) {
		#src/jotun/net/Domain.hx:99: lines 99-102
		if ($len === null) {
			$len = 2;
		}
		#src/jotun/net/Domain.hx:100: characters 3-41
		$h = HxString::split($this->host, ".");
		#src/jotun/net/Domain.hx:101: characters 3-49
		return $h->splice($h->length - $len, $len)->join(".");
	}

	/**
	 * @return string
	 */
	public function getRequestMethod () {
		#src/jotun/net/Domain.hx:123: characters 11-44
		return \mb_strtoupper($this->data->REQUEST_METHOD);
	}

	/**
	 * @param string $q
	 * 
	 * @return bool
	 */
	public function isRequestMethod ($q) {
		#src/jotun/net/Domain.hx:127: characters 4-48
		return $this->getRequestMethod() === \mb_strtoupper($q);
	}

	/**
	 * @param \Closure $onPart
	 * @param \Closure $onData
	 * 
	 * @return void
	 */
	public function parseFiles ($onPart, $onData) {
		#src/jotun/net/Domain.hx:219: characters 4-56
		$files = $_FILES;
		#src/jotun/net/Domain.hx:220: lines 220-222
		if (!isset($files)) {
			#src/jotun/net/Domain.hx:221: characters 5-11
			return;
		}
		#src/jotun/net/Domain.hx:223: characters 4-70
		$keys = array_keys($files);
		#src/jotun/net/Domain.hx:224: characters 4-54
		$parts = \Array_hx::wrap($keys);
		#src/jotun/net/Domain.hx:225: lines 225-252
		$_g = 0;
		while ($_g < $parts->length) {
			#src/jotun/net/Domain.hx:225: characters 8-12
			$part = ($parts->arr[$_g] ?? null);
			#src/jotun/net/Domain.hx:225: lines 225-252
			++$_g;
			#src/jotun/net/Domain.hx:226: characters 5-65
			$info = $_FILES[$part];
			#src/jotun/net/Domain.hx:227: characters 5-49
			$tmp = $info["tmp_name"];
			#src/jotun/net/Domain.hx:228: characters 5-46
			$file = $info["name"];
			#src/jotun/net/Domain.hx:229: characters 5-43
			$err = $info["error"];
			#src/jotun/net/Domain.hx:230: lines 230-240
			if ($err > 0) {
				#src/jotun/net/Domain.hx:231: lines 231-239
				if ($err === 1) {
					#src/jotun/net/Domain.hx:232: characters 15-20
					throw Exception::thrown("The uploaded file exceeds the max size of " . \Std::string(ini_get("upload_max_filesize")));
				} else if ($err === 2) {
					#src/jotun/net/Domain.hx:233: characters 15-20
					throw Exception::thrown("The uploaded file exceeds the max file size directive specified in the HTML form (max is" . \Std::string(ini_get("post_max_size")) . ")");
				} else if ($err === 3) {
					#src/jotun/net/Domain.hx:234: characters 15-20
					throw Exception::thrown("The uploaded file was only partially uploaded");
				} else if ($err === 4) {
					#src/jotun/net/Domain.hx:235: characters 15-23
					continue;
				} else if ($err === 6) {
					#src/jotun/net/Domain.hx:236: characters 15-20
					throw Exception::thrown("Missing a temporary folder");
				} else if ($err === 7) {
					#src/jotun/net/Domain.hx:237: characters 15-20
					throw Exception::thrown("Failed to write file to disk");
				} else if ($err === 8) {
					#src/jotun/net/Domain.hx:238: characters 15-20
					throw Exception::thrown("File upload stopped by extension");
				}
			}
			#src/jotun/net/Domain.hx:241: characters 5-23
			$onPart($part, $file);
			#src/jotun/net/Domain.hx:242: lines 242-251
			if ("" !== $file) {
				#src/jotun/net/Domain.hx:243: characters 6-63
				$h = fopen($tmp,"r");
				#src/jotun/net/Domain.hx:244: characters 6-23
				$bsize = 8192;
				#src/jotun/net/Domain.hx:245: lines 245-249
				while (!feof($h)) {
					#src/jotun/net/Domain.hx:246: characters 7-75
					$buf = fread($h,$bsize);
					#src/jotun/net/Domain.hx:247: characters 7-65
					$size = strlen($buf);
					#src/jotun/net/Domain.hx:248: characters 14-33
					$tmp1 = \strlen($buf);
					#src/jotun/net/Domain.hx:248: characters 7-43
					$onData(new Bytes($tmp1, new Container($buf)), 0, $size);
				}
				#src/jotun/net/Domain.hx:250: characters 6-44
				fclose($h);
			}
		}
	}

	/**
	 * @param string[]|\Array_hx $params
	 * 
	 * @return bool
	 */
	public function require ($params) {
		#src/jotun/net/Domain.hx:130: lines 130-137
		$_gthis = $this;
		#src/jotun/net/Domain.hx:131: characters 4-22
		$r = true;
		#src/jotun/net/Domain.hx:132: lines 132-135
		Dice::Values($params, function ($v) use (&$r, &$_gthis) {
			#src/jotun/net/Domain.hx:133: characters 5-41
			$r = \Reflect::hasField($_gthis->params, $v);
			#src/jotun/net/Domain.hx:134: characters 5-14
			return !$r;
		});
		#src/jotun/net/Domain.hx:136: characters 4-12
		return $r;
	}
}

Boot::registerClass(Domain::class, 'jotun.net.Domain');
