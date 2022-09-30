<?php
/**
 */

namespace jotun\net;

use \haxe\io\_BytesData\Container;
use \php\net\SslSocket;
use \php\_Boot\HxAnon;
use \php\Boot;
use \haxe\io\BytesOutput;
use \sys\net\Socket;
use \haxe\Exception;
use \haxe\io\Output;
use \haxe\io\BytesBuffer;
use \haxe\io\Eof;
use \haxe\io\Error;
use \haxe\io\Input;
use \php\_Boot\HxString;
use \sys\net\Host;
use \php\_Boot\HxClosure;
use \haxe\ds\StringMap;
use \haxe\ds\List_hx;
use \haxe\io\Bytes;

/**
 * This class can be used to handle Http requests consistently across
 * platforms. There are two intended usages:
 * - call haxe.Http.requestUrl(url) and receive the result as a String (not
 * available on flash)
 * - create a new haxe.Http(url), register your callbacks for onData, onError
 * and onStatus, then call request().
 */
class HttpRequest {
	/**
	 * @var object
	 */
	static public $PROXY = null;

	/**
	 * @var Bytes
	 */
	public $chunk_buf;
	/**
	 * @var int
	 */
	public $chunk_size;
	/**
	 * @var float
	 */
	public $cnxTimeout;
	/**
	 * @var object
	 */
	public $file;
	/**
	 * @var List_hx
	 */
	public $headers;
	/**
	 * @var bool
	 */
	public $noShutdown;
	/**
	 * @var \Closure
	 * This method is called upon a successful request, with `data` containing
	 * the result String.
	 * The intended usage is to bind it to a custom function:
	 * `httpInstance.onData = function(data) { // handle result }`
	 */
	public $onData;
	/**
	 * @var \Closure
	 * This method is called upon a request error, with `msg` containing the
	 * error description.
	 * The intended usage is to bind it to a custom function:
	 * `httpInstance.onError = function(msg) { // handle error }`
	 */
	public $onError;
	/**
	 * @var \Closure
	 * This method is called upon a Http status change, with `status` being the
	 * new status.
	 * The intended usage is to bind it to a custom function:
	 * `httpInstance.onStatus = function(status) { // handle status }`
	 */
	public $onStatus;
	/**
	 * @var List_hx
	 */
	public $params;
	/**
	 * @var string
	 */
	public $postData;
	/**
	 * @var string
	 */
	public $responseData;
	/**
	 * @var StringMap
	 */
	public $responseHeaders;
	/**
	 * @var string
	 * The url of `this` request. It is used only by the request() method and
	 * can be changed in order to send the same request to different target
	 * Urls.
	 */
	public $url;

	/**
	 * Makes a synchronous request to `url`.
	 * This creates a new Http instance and makes a GET request by calling its
	 * request(false) method.
	 * If `url` is null, the result is unspecified.
	 * 
	 * @param string $url
	 * 
	 * @return string
	 */
	public static function requestUrl ($url) {
		#src/jotun/net/HttpRequest.hx:762: characters 3-32
		$h = new HttpRequest($url);
		#src/jotun/net/HttpRequest.hx:766: characters 3-16
		$r = null;
		#src/jotun/net/HttpRequest.hx:767: lines 767-769
		$h->onData = function ($d) use (&$r) {
			#src/jotun/net/HttpRequest.hx:768: characters 4-9
			$r = $d;
		};
		#src/jotun/net/HttpRequest.hx:770: lines 770-772
		$h->onError = function ($e) {
			#src/jotun/net/HttpRequest.hx:771: characters 4-9
			throw Exception::thrown($e);
		};
		#src/jotun/net/HttpRequest.hx:776: characters 4-20
		$h->request(false);
		#src/jotun/net/HttpRequest.hx:778: characters 3-11
		return $r;
	}

	/**
	 * Creates a new Http instance with `url` as parameter.
	 * This does not do a request until request() is called.
	 * If `url` is null, the field url must be set to a value before making the
	 * call to request(), or the result is unspecified.
	 * (Php) Https (SSL) connections are allowed only if the OpenSSL extension
	 * is enabled.
	 * 
	 * @param string $url
	 * 
	 * @return void
	 */
	public function __construct ($url) {
		if (!$this->__hx__default__onData) {
			$this->__hx__default__onData = new HxClosure($this, 'onData');
			if ($this->onData === null) $this->onData = $this->__hx__default__onData;
		}
		if (!$this->__hx__default__onError) {
			$this->__hx__default__onError = new HxClosure($this, 'onError');
			if ($this->onError === null) $this->onError = $this->__hx__default__onError;
		}
		if (!$this->__hx__default__onStatus) {
			$this->__hx__default__onStatus = new HxClosure($this, 'onStatus');
			if ($this->onStatus === null) $this->onStatus = $this->__hx__default__onStatus;
		}
		#src/jotun/net/HttpRequest.hx:107: characters 3-17
		$this->url = $url;
		#src/jotun/net/HttpRequest.hx:108: characters 3-56
		$this->headers = new List_hx();
		#src/jotun/net/HttpRequest.hx:109: characters 3-54
		$this->params = new List_hx();
		#src/jotun/net/HttpRequest.hx:114: characters 3-18
		$this->cnxTimeout = 10;
		#src/jotun/net/HttpRequest.hx:117: characters 3-87
		$this->noShutdown = !function_exists("stream_socket_shutdown");
	}

	/**
	 * @param string $header
	 * @param string $value
	 * 
	 * @return HttpRequest
	 */
	public function addHeader ($header, $value) {
		#src/jotun/net/HttpRequest.hx:134: characters 3-47
		$this->headers->push(new _HxAnon_HttpRequest0($header, $value));
		#src/jotun/net/HttpRequest.hx:135: characters 3-14
		return $this;
	}

	/**
	 * @param string $param
	 * @param mixed $value
	 * 
	 * @return HttpRequest
	 */
	public function addParameter ($param, $value) {
		#src/jotun/net/HttpRequest.hx:158: characters 4-59
		$this->params->push(new _HxAnon_HttpRequest1($param, \Std::string($value)));
		#src/jotun/net/HttpRequest.hx:160: characters 3-14
		return $this;
	}

	/**
	 * @param bool $post
	 * @param Output $api
	 * @param object $sock
	 * @param string $method
	 * 
	 * @return void
	 */
	public function customRequest ($post, $api, $sock = null, $method = null) {
		#src/jotun/net/HttpRequest.hx:364: characters 3-20
		$this->responseData = null;
		#src/jotun/net/HttpRequest.hx:365: characters 3-72
		$url_regexp = new \EReg("^(https?://)?([a-zA-Z\\.0-9_-]+)(:[0-9]+)?(.*)\$", "");
		#src/jotun/net/HttpRequest.hx:366: lines 366-369
		if (!$url_regexp->match($this->url)) {
			#src/jotun/net/HttpRequest.hx:367: characters 4-26
			$this->onError("Invalid URL");
			#src/jotun/net/HttpRequest.hx:368: characters 4-10
			return;
		}
		#src/jotun/net/HttpRequest.hx:370: characters 3-54
		$secure = $url_regexp->matched(1) === "https://";
		#src/jotun/net/HttpRequest.hx:371: lines 371-386
		if ($sock === null) {
			#src/jotun/net/HttpRequest.hx:372: lines 372-385
			if ($secure) {
				#src/jotun/net/HttpRequest.hx:374: characters 6-10
				$sock = new SslSocket();
			} else {
				#src/jotun/net/HttpRequest.hx:385: characters 5-9
				$sock = new Socket();
			}
		}
		#src/jotun/net/HttpRequest.hx:387: characters 3-36
		$host = $url_regexp->matched(2);
		#src/jotun/net/HttpRequest.hx:388: characters 3-42
		$portString = $url_regexp->matched(3);
		#src/jotun/net/HttpRequest.hx:389: characters 3-39
		$request = $url_regexp->matched(4);
		#src/jotun/net/HttpRequest.hx:390: lines 390-391
		if ($request === "") {
			#src/jotun/net/HttpRequest.hx:391: characters 4-11
			$request = "/";
		}
		#src/jotun/net/HttpRequest.hx:392: characters 3-141
		$port = (($portString === null) || ($portString === "") ? ($secure ? 443 : 80) : \Std::parseInt(\mb_substr($portString, 1, mb_strlen($portString) - 1)));
		#src/jotun/net/HttpRequest.hx:395: characters 3-34
		$multipart = $this->file !== null;
		#src/jotun/net/HttpRequest.hx:396: characters 3-23
		$boundary = null;
		#src/jotun/net/HttpRequest.hx:397: characters 3-18
		$uri = null;
		#src/jotun/net/HttpRequest.hx:398: lines 398-435
		if ($multipart) {
			#src/jotun/net/HttpRequest.hx:399: characters 4-8
			$post = true;
			#src/jotun/net/HttpRequest.hx:400: characters 4-12
			$boundary = \Std::string(\mt_rand(0, 999)) . \Std::string(\mt_rand(0, 999)) . \Std::string(\mt_rand(0, 999)) . \Std::string(\mt_rand(0, 999));
			#src/jotun/net/HttpRequest.hx:401: lines 401-402
			while (mb_strlen($boundary) < 38) {
				#src/jotun/net/HttpRequest.hx:402: characters 5-13
				$boundary = "-" . ($boundary??'null');
			}
			#src/jotun/net/HttpRequest.hx:403: characters 4-28
			$b = new \StringBuf();
			#src/jotun/net/HttpRequest.hx:404: characters 14-20
			$_g_head = $this->params->h;
			#src/jotun/net/HttpRequest.hx:404: lines 404-415
			while ($_g_head !== null) {
				$val = $_g_head->item;
				$_g_head = $_g_head->next;
				$p = $val;
				#src/jotun/net/HttpRequest.hx:405: characters 5-16
				$b->add("--");
				#src/jotun/net/HttpRequest.hx:406: characters 5-20
				$b->add($boundary);
				#src/jotun/net/HttpRequest.hx:407: characters 5-18
				$b->add("\x0D\x0A");
				#src/jotun/net/HttpRequest.hx:408: characters 5-52
				$b->add("Content-Disposition: form-data; name=\"");
				#src/jotun/net/HttpRequest.hx:409: characters 5-19
				$b->add($p->param);
				#src/jotun/net/HttpRequest.hx:410: characters 5-15
				$b->add("\"");
				#src/jotun/net/HttpRequest.hx:411: characters 5-18
				$b->add("\x0D\x0A");
				#src/jotun/net/HttpRequest.hx:412: characters 5-18
				$b->add("\x0D\x0A");
				#src/jotun/net/HttpRequest.hx:413: characters 5-19
				$b->add($p->value);
				#src/jotun/net/HttpRequest.hx:414: characters 5-18
				$b->add("\x0D\x0A");
			}
			#src/jotun/net/HttpRequest.hx:416: characters 4-15
			$b->add("--");
			#src/jotun/net/HttpRequest.hx:417: characters 4-19
			$b->add($boundary);
			#src/jotun/net/HttpRequest.hx:418: characters 4-17
			$b->add("\x0D\x0A");
			#src/jotun/net/HttpRequest.hx:419: characters 4-51
			$b->add("Content-Disposition: form-data; name=\"");
			#src/jotun/net/HttpRequest.hx:420: characters 4-21
			$b->add($this->file->param);
			#src/jotun/net/HttpRequest.hx:421: characters 4-26
			$b->add("\"; filename=\"");
			#src/jotun/net/HttpRequest.hx:422: characters 4-24
			$b->add($this->file->filename);
			#src/jotun/net/HttpRequest.hx:423: characters 4-14
			$b->add("\"");
			#src/jotun/net/HttpRequest.hx:424: characters 4-17
			$b->add("\x0D\x0A");
			#src/jotun/net/HttpRequest.hx:425: characters 4-55
			$b->add("Content-Type: " . ($this->file->mimeType??'null') . "\x0D\x0A" . "\x0D\x0A");
			#src/jotun/net/HttpRequest.hx:426: characters 4-7
			$uri = $b->b;
		} else {
			#src/jotun/net/HttpRequest.hx:428: characters 14-20
			$_g_head = $this->params->h;
			#src/jotun/net/HttpRequest.hx:428: lines 428-434
			while ($_g_head !== null) {
				$val = $_g_head->item;
				$_g_head = $_g_head->next;
				$p = $val;
				#src/jotun/net/HttpRequest.hx:429: lines 429-432
				if ($uri === null) {
					#src/jotun/net/HttpRequest.hx:430: characters 6-9
					$uri = "";
				} else {
					#src/jotun/net/HttpRequest.hx:432: characters 6-16
					$uri = ($uri??'null') . "&";
				}
				#src/jotun/net/HttpRequest.hx:433: characters 5-77
				$uri = ($uri??'null') . (\rawurlencode($p->param)??'null') . "=" . (\rawurlencode($p->value)??'null');
			}
		}
		#src/jotun/net/HttpRequest.hx:437: characters 3-27
		$b = new \StringBuf();
		#src/jotun/net/HttpRequest.hx:438: lines 438-444
		if ($method !== null) {
			#src/jotun/net/HttpRequest.hx:439: characters 4-17
			$b->add($method);
			#src/jotun/net/HttpRequest.hx:440: characters 4-14
			$b->add(" ");
		} else if ($post) {
			#src/jotun/net/HttpRequest.hx:442: characters 4-18
			$b->add("POST ");
		} else {
			#src/jotun/net/HttpRequest.hx:444: characters 4-17
			$b->add("GET ");
		}
		#src/jotun/net/HttpRequest.hx:446: lines 446-453
		if (HttpRequest::$PROXY !== null) {
			#src/jotun/net/HttpRequest.hx:447: characters 4-20
			$b->add("http://");
			#src/jotun/net/HttpRequest.hx:448: characters 4-15
			$b->add($host);
			#src/jotun/net/HttpRequest.hx:449: lines 449-452
			if ($port !== 80) {
				#src/jotun/net/HttpRequest.hx:450: characters 5-15
				$b->add(":");
				#src/jotun/net/HttpRequest.hx:451: characters 5-16
				$b->add($port);
			}
		}
		#src/jotun/net/HttpRequest.hx:454: characters 3-17
		$b->add($request);
		#src/jotun/net/HttpRequest.hx:456: lines 456-462
		if (!$post && ($uri !== null)) {
			#src/jotun/net/HttpRequest.hx:457: lines 457-460
			if (HxString::indexOf($request, "?", 0) >= 0) {
				#src/jotun/net/HttpRequest.hx:458: characters 5-15
				$b->add("&");
			} else {
				#src/jotun/net/HttpRequest.hx:460: characters 5-15
				$b->add("?");
			}
			#src/jotun/net/HttpRequest.hx:461: characters 4-14
			$b->add($uri);
		}
		#src/jotun/net/HttpRequest.hx:463: characters 3-43
		$b->add(" HTTP/1.1\x0D\x0AHost: " . ($host??'null') . "\x0D\x0A");
		#src/jotun/net/HttpRequest.hx:464: lines 464-481
		if ($this->postData !== null) {
			#src/jotun/net/HttpRequest.hx:465: characters 4-52
			$b->add("Content-Length: " . (mb_strlen($this->postData)??'null') . "\x0D\x0A");
		} else if ($post && ($uri !== null)) {
			#src/jotun/net/HttpRequest.hx:467: lines 467-476
			if ($multipart || !\Lambda::exists($this->headers, function ($h) {
				#src/jotun/net/HttpRequest.hx:467: characters 57-90
				return $h->header === "Content-Type";
			})) {
				#src/jotun/net/HttpRequest.hx:468: characters 5-28
				$b->add("Content-Type: ");
				#src/jotun/net/HttpRequest.hx:469: lines 469-474
				if ($multipart) {
					#src/jotun/net/HttpRequest.hx:470: characters 6-34
					$b->add("multipart/form-data");
					#src/jotun/net/HttpRequest.hx:471: characters 6-26
					$b->add("; boundary=");
					#src/jotun/net/HttpRequest.hx:472: characters 6-21
					$b->add($boundary);
				} else {
					#src/jotun/net/HttpRequest.hx:474: characters 6-48
					$b->add("application/x-www-form-urlencoded");
				}
				#src/jotun/net/HttpRequest.hx:475: characters 5-18
				$b->add("\x0D\x0A");
			}
			#src/jotun/net/HttpRequest.hx:477: lines 477-480
			if ($multipart) {
				#src/jotun/net/HttpRequest.hx:478: characters 5-78
				$b->add("Content-Length: " . (mb_strlen($uri) + $this->file->size + mb_strlen($boundary) + 6) . "\x0D\x0A");
			} else {
				#src/jotun/net/HttpRequest.hx:480: characters 5-48
				$b->add("Content-Length: " . (mb_strlen($uri)??'null') . "\x0D\x0A");
			}
		}
		#src/jotun/net/HttpRequest.hx:482: characters 13-20
		$_g_head = $this->headers->h;
		#src/jotun/net/HttpRequest.hx:482: lines 482-487
		while ($_g_head !== null) {
			$val = $_g_head->item;
			$_g_head = $_g_head->next;
			$h = $val;
			#src/jotun/net/HttpRequest.hx:483: characters 4-19
			$b->add($h->header);
			#src/jotun/net/HttpRequest.hx:484: characters 4-15
			$b->add(": ");
			#src/jotun/net/HttpRequest.hx:485: characters 4-18
			$b->add($h->value);
			#src/jotun/net/HttpRequest.hx:486: characters 4-17
			$b->add("\x0D\x0A");
		}
		#src/jotun/net/HttpRequest.hx:488: characters 3-16
		$b->add("\x0D\x0A");
		#src/jotun/net/HttpRequest.hx:489: lines 489-492
		if ($this->postData !== null) {
			#src/jotun/net/HttpRequest.hx:490: characters 4-19
			$b->add($this->postData);
		} else if ($post && ($uri !== null)) {
			#src/jotun/net/HttpRequest.hx:492: characters 4-14
			$b->add($uri);
		}
		#src/jotun/net/HttpRequest.hx:493: lines 493-521
		try {
			#src/jotun/net/HttpRequest.hx:494: lines 494-497
			if (HttpRequest::$PROXY !== null) {
				#src/jotun/net/HttpRequest.hx:495: characters 5-74
				$sock->connect(new Host(HttpRequest::$PROXY->host), HttpRequest::$PROXY->port);
			} else {
				#src/jotun/net/HttpRequest.hx:497: characters 5-38
				$sock->connect(new Host($host), $port);
			}
			#src/jotun/net/HttpRequest.hx:498: characters 4-28
			$sock->write($b->b);
			#src/jotun/net/HttpRequest.hx:499: lines 499-515
			if ($multipart) {
				#src/jotun/net/HttpRequest.hx:500: characters 5-24
				$bufsize = 4096;
				#src/jotun/net/HttpRequest.hx:501: characters 5-44
				$buf = Bytes::alloc($bufsize);
				#src/jotun/net/HttpRequest.hx:502: lines 502-510
				while ($this->file->size > 0) {
					#src/jotun/net/HttpRequest.hx:503: characters 6-66
					$size = ($this->file->size > $bufsize ? $bufsize : $this->file->size);
					#src/jotun/net/HttpRequest.hx:504: characters 6-18
					$len = 0;
					#src/jotun/net/HttpRequest.hx:505: lines 505-507
					try {
						#src/jotun/net/HttpRequest.hx:506: characters 7-10
						$len = $this->file->io->readBytes($buf, 0, $size);
					} catch(\Throwable $_g) {
						#src/jotun/net/HttpRequest.hx:505: lines 505-507
						if ((Exception::caught($_g)->unwrap() instanceof Eof)) {
							#src/jotun/net/HttpRequest.hx:507: characters 33-38
							break;
						} else {
							#src/jotun/net/HttpRequest.hx:505: lines 505-507
							throw $_g;
						}
					}
					#src/jotun/net/HttpRequest.hx:508: characters 6-43
					$sock->output->writeFullBytes($buf, 0, $len);
					#src/jotun/net/HttpRequest.hx:509: characters 6-22
					$this->file->size -= $len;
				}
				#src/jotun/net/HttpRequest.hx:511: characters 5-23
				$sock->write("\x0D\x0A");
				#src/jotun/net/HttpRequest.hx:512: characters 5-21
				$sock->write("--");
				#src/jotun/net/HttpRequest.hx:513: characters 5-25
				$sock->write($boundary);
				#src/jotun/net/HttpRequest.hx:514: characters 5-21
				$sock->write("--");
			}
			#src/jotun/net/HttpRequest.hx:516: characters 4-30
			$this->readHttpResponse($api, $sock);
			#src/jotun/net/HttpRequest.hx:517: characters 4-16
			$sock->close();
		} catch(\Throwable $_g) {
			#src/jotun/net/HttpRequest.hx:518: characters 12-13
			$e = Exception::caught($_g)->unwrap();
			#src/jotun/net/HttpRequest.hx:519: characters 4-45
			try {
				#src/jotun/net/HttpRequest.hx:519: characters 8-20
				$sock->close();
			} catch(\Throwable $_g) {
			}
			#src/jotun/net/HttpRequest.hx:520: characters 4-26
			$this->onError(\Std::string($e));
		}
	}

	/**
	 * @param string $argname
	 * @param string $filename
	 * @param Input $file
	 * @param int $size
	 * @param string $mimeType
	 * 
	 * @return void
	 */
	public function fileTransfer ($argname, $filename, $file, $size, $mimeType = "application/octet-stream") {
		#src/jotun/net/HttpRequest.hx:360: characters 3-100
		if ($mimeType === null) {
			$mimeType = "application/octet-stream";
		}
		$this->file = new _HxAnon_HttpRequest2($argname, $filename, $file, $size, $mimeType);
	}

	/**
	 * Note: Deprecated in 4.0
	 * 
	 * @param string $argname
	 * @param string $filename
	 * @param Input $file
	 * @param int $size
	 * @param string $mimeType
	 * 
	 * @return void
	 */
	public function fileTransfert ($argname, $filename, $file, $size, $mimeType = "application/octet-stream") {
		#src/jotun/net/HttpRequest.hx:356: characters 6-59
		if ($mimeType === null) {
			$mimeType = "application/octet-stream";
		}
		$this->fileTransfer($argname, $filename, $file, $size, $mimeType);
	}

	/**
	 * This method is called upon a successful request, with `data` containing
	 * the result String.
	 * The intended usage is to bind it to a custom function:
	 * `httpInstance.onData = function(data) { // handle result }`
	 * 
	 * @param string $data
	 * 
	 * @return void
	 */
	public function onData ($data)
	{
		if ($this->onData !== $this->__hx__default__onData) return call_user_func_array($this->onData, func_get_args());
	}
	protected $__hx__default__onData;

	/**
	 * This method is called upon a request error, with `msg` containing the
	 * error description.
	 * The intended usage is to bind it to a custom function:
	 * `httpInstance.onError = function(msg) { // handle error }`
	 * 
	 * @param string $msg
	 * 
	 * @return void
	 */
	public function onError ($msg)
	{
		if ($this->onError !== $this->__hx__default__onError) return call_user_func_array($this->onError, func_get_args());
	}
	protected $__hx__default__onError;

	/**
	 * This method is called upon a Http status change, with `status` being the
	 * new status.
	 * The intended usage is to bind it to a custom function:
	 * `httpInstance.onStatus = function(status) { // handle status }`
	 * 
	 * @param int $status
	 * 
	 * @return void
	 */
	public function onStatus ($status)
	{
		if ($this->onStatus !== $this->__hx__default__onStatus) return call_user_func_array($this->onStatus, func_get_args());
	}
	protected $__hx__default__onStatus;

	/**
	 * @param \EReg $chunk_re
	 * @param Output $api
	 * @param Bytes $buf
	 * @param int $len
	 * 
	 * @return bool
	 */
	public function readChunk ($chunk_re, $api, $buf, $len) {
		#src/jotun/net/HttpRequest.hx:665: lines 665-699
		if ($this->chunk_size === null) {
			#src/jotun/net/HttpRequest.hx:666: lines 666-673
			if ($this->chunk_buf !== null) {
				#src/jotun/net/HttpRequest.hx:667: characters 5-39
				$b = new BytesBuffer();
				#src/jotun/net/HttpRequest.hx:668: characters 5-21
				$b->b = ($b->b . $this->chunk_buf->b->s);
				#src/jotun/net/HttpRequest.hx:669: characters 5-26
				if (($len < 0) || ($len > $buf->length)) {
					throw Exception::thrown(Error::OutsideBounds());
				} else {
					$left = $b->b;
					$this_s = \substr($buf->b->s, 0, $len);
					$b->b = ($left . $this_s);
				}
				#src/jotun/net/HttpRequest.hx:670: characters 5-8
				$buf = $b->getBytes();
				#src/jotun/net/HttpRequest.hx:671: characters 5-28
				$len += $this->chunk_buf->length;
				#src/jotun/net/HttpRequest.hx:672: characters 5-14
				$this->chunk_buf = null;
			}
			#src/jotun/net/HttpRequest.hx:677: lines 677-691
			if ($chunk_re->match($buf->toString())) {
				#src/jotun/net/HttpRequest.hx:679: characters 5-35
				$p = $chunk_re->matchedPos();
				#src/jotun/net/HttpRequest.hx:680: lines 680-690
				if ($p->len <= $len) {
					#src/jotun/net/HttpRequest.hx:681: characters 6-37
					$cstr = $chunk_re->matched(1);
					#src/jotun/net/HttpRequest.hx:682: characters 6-16
					$this->chunk_size = \Std::parseInt("0x" . ($cstr??'null'));
					#src/jotun/net/HttpRequest.hx:683: lines 683-687
					if ($cstr === "0") {
						#src/jotun/net/HttpRequest.hx:684: characters 7-17
						$this->chunk_size = null;
						#src/jotun/net/HttpRequest.hx:685: characters 7-16
						$this->chunk_buf = null;
						#src/jotun/net/HttpRequest.hx:686: characters 7-19
						return false;
					}
					#src/jotun/net/HttpRequest.hx:688: characters 6-18
					$len -= $p->len;
					#src/jotun/net/HttpRequest.hx:689: characters 36-54
					$pos = $p->len;
					$tmp = null;
					if (($pos < 0) || ($len < 0) || (($pos + $len) > $buf->length)) {
						throw Exception::thrown(Error::OutsideBounds());
					} else {
						$tmp = new Bytes($len, new Container(\substr($buf->b->s, $pos, $len)));
					}
					#src/jotun/net/HttpRequest.hx:689: characters 6-59
					return $this->readChunk($chunk_re, $api, $tmp, $len);
				}
			}
			#src/jotun/net/HttpRequest.hx:693: lines 693-696
			if ($len > 10) {
				#src/jotun/net/HttpRequest.hx:694: characters 5-29
				$this->onError("Invalid chunk");
				#src/jotun/net/HttpRequest.hx:695: characters 5-17
				return false;
			}
			#src/jotun/net/HttpRequest.hx:697: characters 16-30
			$tmp = null;
			if (($len < 0) || ($len > $buf->length)) {
				throw Exception::thrown(Error::OutsideBounds());
			} else {
				$tmp = new Bytes($len, new Container(\substr($buf->b->s, 0, $len)));
			}
			#src/jotun/net/HttpRequest.hx:697: characters 4-13
			$this->chunk_buf = $tmp;
			#src/jotun/net/HttpRequest.hx:698: characters 4-15
			return true;
		}
		#src/jotun/net/HttpRequest.hx:700: lines 700-704
		if ($this->chunk_size > $len) {
			#src/jotun/net/HttpRequest.hx:701: characters 4-21
			$this->chunk_size -= $len;
			#src/jotun/net/HttpRequest.hx:702: characters 4-29
			$api->writeBytes($buf, 0, $len);
			#src/jotun/net/HttpRequest.hx:703: characters 4-15
			return true;
		}
		#src/jotun/net/HttpRequest.hx:705: characters 3-28
		$end = $this->chunk_size + 2;
		#src/jotun/net/HttpRequest.hx:706: lines 706-714
		if ($len >= $end) {
			#src/jotun/net/HttpRequest.hx:707: lines 707-708
			if ($this->chunk_size > 0) {
				#src/jotun/net/HttpRequest.hx:708: characters 5-37
				$api->writeBytes($buf, 0, $this->chunk_size);
			}
			#src/jotun/net/HttpRequest.hx:709: characters 4-14
			$len -= $end;
			#src/jotun/net/HttpRequest.hx:710: characters 4-14
			$this->chunk_size = null;
			#src/jotun/net/HttpRequest.hx:711: lines 711-712
			if ($len === 0) {
				#src/jotun/net/HttpRequest.hx:712: characters 5-16
				return true;
			}
			#src/jotun/net/HttpRequest.hx:713: characters 34-50
			$tmp = null;
			if (($end < 0) || ($len < 0) || (($end + $len) > $buf->length)) {
				throw Exception::thrown(Error::OutsideBounds());
			} else {
				$tmp = new Bytes($len, new Container(\substr($buf->b->s, $end, $len)));
			}
			#src/jotun/net/HttpRequest.hx:713: characters 4-55
			return $this->readChunk($chunk_re, $api, $tmp, $len);
		}
		#src/jotun/net/HttpRequest.hx:715: lines 715-716
		if ($this->chunk_size > 0) {
			#src/jotun/net/HttpRequest.hx:716: characters 4-36
			$api->writeBytes($buf, 0, $this->chunk_size);
		}
		#src/jotun/net/HttpRequest.hx:717: characters 3-20
		$this->chunk_size -= $len;
		#src/jotun/net/HttpRequest.hx:718: characters 3-14
		return true;
	}

	/**
	 * @param Output $api
	 * @param object $sock
	 * 
	 * @return void
	 */
	public function readHttpResponse ($api, $sock) {
		#src/jotun/net/HttpRequest.hx:526: characters 3-37
		$b = new BytesBuffer();
		#src/jotun/net/HttpRequest.hx:527: characters 3-13
		$k = 4;
		#src/jotun/net/HttpRequest.hx:528: characters 3-34
		$s = Bytes::alloc(4);
		#src/jotun/net/HttpRequest.hx:529: characters 3-30
		$sock->setTimeout($this->cnxTimeout);
		#src/jotun/net/HttpRequest.hx:530: lines 530-586
		while (true) {
			#src/jotun/net/HttpRequest.hx:531: characters 4-40
			$p = $sock->input->readBytes($s, 0, $k);
			#src/jotun/net/HttpRequest.hx:532: lines 532-533
			while ($p !== $k) {
				#src/jotun/net/HttpRequest.hx:533: characters 5-41
				$p += $sock->input->readBytes($s, $p, $k - $p);
			}
			#src/jotun/net/HttpRequest.hx:534: characters 4-21
			if (($k < 0) || ($k > $s->length)) {
				throw Exception::thrown(Error::OutsideBounds());
			} else {
				$left = $b->b;
				$this_s = \substr($s->b->s, 0, $k);
				$b->b = ($left . $this_s);
			}
			#src/jotun/net/HttpRequest.hx:535: lines 535-585
			if ($k === 1) {
				#src/jotun/net/HttpRequest.hx:537: characters 5-22
				$c = \ord($s->b->s[0]);
				#src/jotun/net/HttpRequest.hx:538: lines 538-539
				if ($c === 10) {
					#src/jotun/net/HttpRequest.hx:539: characters 6-11
					break;
				}
				#src/jotun/net/HttpRequest.hx:540: lines 540-543
				if ($c === 13) {
					#src/jotun/net/HttpRequest.hx:541: characters 6-7
					$k = 3;
				} else {
					#src/jotun/net/HttpRequest.hx:543: characters 6-7
					$k = 4;
				}
			} else if ($k === 2) {
				#src/jotun/net/HttpRequest.hx:545: characters 5-22
				$c1 = \ord($s->b->s[1]);
				#src/jotun/net/HttpRequest.hx:546: lines 546-553
				if ($c1 === 10) {
					#src/jotun/net/HttpRequest.hx:547: lines 547-548
					if (\ord($s->b->s[0]) === 13) {
						#src/jotun/net/HttpRequest.hx:548: characters 7-12
						break;
					}
					#src/jotun/net/HttpRequest.hx:549: characters 6-7
					$k = 4;
				} else if ($c1 === 13) {
					#src/jotun/net/HttpRequest.hx:551: characters 6-7
					$k = 3;
				} else {
					#src/jotun/net/HttpRequest.hx:553: characters 6-7
					$k = 4;
				}
			} else if ($k === 3) {
				#src/jotun/net/HttpRequest.hx:555: characters 5-22
				$c2 = \ord($s->b->s[2]);
				#src/jotun/net/HttpRequest.hx:556: lines 556-569
				if ($c2 === 10) {
					#src/jotun/net/HttpRequest.hx:557: lines 557-562
					if (\ord($s->b->s[1]) !== 13) {
						#src/jotun/net/HttpRequest.hx:558: characters 7-8
						$k = 4;
					} else if (\ord($s->b->s[0]) !== 10) {
						#src/jotun/net/HttpRequest.hx:560: characters 7-8
						$k = 2;
					} else {
						#src/jotun/net/HttpRequest.hx:562: characters 7-12
						break;
					}
				} else if ($c2 === 13) {
					#src/jotun/net/HttpRequest.hx:564: lines 564-567
					if ((\ord($s->b->s[1]) !== 10) || (\ord($s->b->s[0]) !== 13)) {
						#src/jotun/net/HttpRequest.hx:565: characters 7-8
						$k = 1;
					} else {
						#src/jotun/net/HttpRequest.hx:567: characters 7-8
						$k = 3;
					}
				} else {
					#src/jotun/net/HttpRequest.hx:569: characters 6-7
					$k = 4;
				}
			} else if ($k === 4) {
				#src/jotun/net/HttpRequest.hx:571: characters 5-22
				$c3 = \ord($s->b->s[3]);
				#src/jotun/net/HttpRequest.hx:572: lines 572-584
				if ($c3 === 10) {
					#src/jotun/net/HttpRequest.hx:573: lines 573-578
					if (\ord($s->b->s[2]) !== 13) {
						#src/jotun/net/HttpRequest.hx:574: characters 7-15
						continue;
					} else if ((\ord($s->b->s[1]) !== 10) || (\ord($s->b->s[0]) !== 13)) {
						#src/jotun/net/HttpRequest.hx:576: characters 7-8
						$k = 2;
					} else {
						#src/jotun/net/HttpRequest.hx:578: characters 7-12
						break;
					}
				} else if ($c3 === 13) {
					#src/jotun/net/HttpRequest.hx:580: lines 580-583
					if ((\ord($s->b->s[2]) !== 10) || (\ord($s->b->s[1]) !== 13)) {
						#src/jotun/net/HttpRequest.hx:581: characters 7-8
						$k = 3;
					} else {
						#src/jotun/net/HttpRequest.hx:583: characters 7-8
						$k = 1;
					}
				}
			}
		};
		#src/jotun/net/HttpRequest.hx:590: characters 4-56
		$headers = HxString::split($b->getBytes()->toString(), "\x0D\x0A");
		#src/jotun/net/HttpRequest.hx:592: characters 18-33
		if ($headers->length > 0) {
			$headers->length--;
		}
		#src/jotun/net/HttpRequest.hx:592: characters 3-34
		$response = \array_shift($headers->arr);
		#src/jotun/net/HttpRequest.hx:593: characters 3-32
		$rp = HxString::split($response, " ");
		#src/jotun/net/HttpRequest.hx:594: characters 3-36
		$status = \Std::parseInt(($rp->arr[1] ?? null));
		#src/jotun/net/HttpRequest.hx:595: lines 595-596
		if (($status === 0) || ($status === null)) {
			#src/jotun/net/HttpRequest.hx:596: characters 4-9
			throw Exception::thrown("Response status error");
		}
		#src/jotun/net/HttpRequest.hx:599: characters 3-16
		if ($headers->length > 0) {
			$headers->length--;
		}
		\array_pop($headers->arr);
		#src/jotun/net/HttpRequest.hx:600: characters 3-16
		if ($headers->length > 0) {
			$headers->length--;
		}
		\array_pop($headers->arr);
		#src/jotun/net/HttpRequest.hx:601: characters 3-18
		$this->responseHeaders = new StringMap();
		#src/jotun/net/HttpRequest.hx:602: characters 3-19
		$size = null;
		#src/jotun/net/HttpRequest.hx:603: characters 3-23
		$chunked = false;
		#src/jotun/net/HttpRequest.hx:604: lines 604-617
		$_g = 0;
		while ($_g < $headers->length) {
			#src/jotun/net/HttpRequest.hx:604: characters 8-13
			$hline = ($headers->arr[$_g] ?? null);
			#src/jotun/net/HttpRequest.hx:604: lines 604-617
			++$_g;
			#src/jotun/net/HttpRequest.hx:605: characters 4-30
			$a = HxString::split($hline, ": ");
			#src/jotun/net/HttpRequest.hx:606: characters 16-25
			if ($a->length > 0) {
				$a->length--;
			}
			#src/jotun/net/HttpRequest.hx:606: characters 4-26
			$hname = \array_shift($a->arr);
			#src/jotun/net/HttpRequest.hx:607: characters 4-58
			$hval = ($a->length === 1 ? ($a->arr[0] ?? null) : $a->join(": "));
			#src/jotun/net/HttpRequest.hx:608: characters 11-57
			$hval = \ltrim(\rtrim($hval));
			#src/jotun/net/HttpRequest.hx:609: characters 4-36
			$this->responseHeaders->data[$hname] = $hval;
			#src/jotun/net/HttpRequest.hx:610: characters 11-30
			$__hx__switch = (\mb_strtolower($hname));
			if ($__hx__switch === "content-length") {
				#src/jotun/net/HttpRequest.hx:613: characters 6-10
				$size = \Std::parseInt($hval);
			} else if ($__hx__switch === "transfer-encoding") {
				#src/jotun/net/HttpRequest.hx:615: characters 6-13
				$chunked = \mb_strtolower($hval) === "chunked";
			}
		}
		#src/jotun/net/HttpRequest.hx:619: characters 3-19
		$this->onStatus($status);
		#src/jotun/net/HttpRequest.hx:621: characters 3-46
		$chunk_re = new \EReg("^([0-9A-Fa-f]+)[ ]*\x0D\x0A", "m");
		#src/jotun/net/HttpRequest.hx:622: characters 3-13
		$this->chunk_size = null;
		#src/jotun/net/HttpRequest.hx:623: characters 3-12
		$this->chunk_buf = null;
		#src/jotun/net/HttpRequest.hx:625: characters 3-22
		$bufsize = 1024;
		#src/jotun/net/HttpRequest.hx:626: characters 3-42
		$buf = Bytes::alloc($bufsize);
		#src/jotun/net/HttpRequest.hx:627: lines 627-656
		if ($size === null) {
			#src/jotun/net/HttpRequest.hx:628: lines 628-629
			if (!$this->noShutdown) {
				#src/jotun/net/HttpRequest.hx:629: characters 5-30
				$sock->shutdown(false, true);
			}
			#src/jotun/net/HttpRequest.hx:630: lines 630-640
			try {
				#src/jotun/net/HttpRequest.hx:631: lines 631-638
				while (true) {
					#src/jotun/net/HttpRequest.hx:632: characters 6-52
					$len = $sock->input->readBytes($buf, 0, $bufsize);
					#src/jotun/net/HttpRequest.hx:633: lines 633-637
					if ($chunked) {
						#src/jotun/net/HttpRequest.hx:634: lines 634-635
						if (!$this->readChunk($chunk_re, $api, $buf, $len)) {
							#src/jotun/net/HttpRequest.hx:635: characters 8-13
							break;
						}
					} else {
						#src/jotun/net/HttpRequest.hx:637: characters 7-32
						$api->writeBytes($buf, 0, $len);
					}
				}
			} catch(\Throwable $_g) {
				#src/jotun/net/HttpRequest.hx:630: lines 630-640
				if (!(Exception::caught($_g)->unwrap() instanceof Eof)) {
					throw $_g;
				}
			}
		} else {
			#src/jotun/net/HttpRequest.hx:642: characters 4-21
			$api->prepare($size);
			#src/jotun/net/HttpRequest.hx:643: lines 643-655
			try {
				#src/jotun/net/HttpRequest.hx:644: lines 644-652
				while ($size > 0) {
					#src/jotun/net/HttpRequest.hx:645: characters 6-83
					$len = $sock->input->readBytes($buf, 0, ($size > $bufsize ? $bufsize : $size));
					#src/jotun/net/HttpRequest.hx:646: lines 646-650
					if ($chunked) {
						#src/jotun/net/HttpRequest.hx:647: lines 647-648
						if (!$this->readChunk($chunk_re, $api, $buf, $len)) {
							#src/jotun/net/HttpRequest.hx:648: characters 8-13
							break;
						}
					} else {
						#src/jotun/net/HttpRequest.hx:650: characters 7-32
						$api->writeBytes($buf, 0, $len);
					}
					#src/jotun/net/HttpRequest.hx:651: characters 6-17
					$size -= $len;
				}
			} catch(\Throwable $_g) {
				#src/jotun/net/HttpRequest.hx:643: lines 643-655
				if ((Exception::caught($_g)->unwrap() instanceof Eof)) {
					#src/jotun/net/HttpRequest.hx:654: characters 5-10
					throw Exception::thrown("Transfer aborted");
				} else {
					#src/jotun/net/HttpRequest.hx:643: lines 643-655
					throw $_g;
				}
			}
		}
		#src/jotun/net/HttpRequest.hx:657: lines 657-658
		if ($chunked && (($this->chunk_size !== null) || ($this->chunk_buf !== null))) {
			#src/jotun/net/HttpRequest.hx:658: characters 4-9
			throw Exception::thrown("Invalid chunk");
		}
		#src/jotun/net/HttpRequest.hx:659: lines 659-660
		if (($status < 200) || ($status >= 400)) {
			#src/jotun/net/HttpRequest.hx:660: characters 4-9
			throw Exception::thrown("Http Error #" . ($status??'null'));
		}
		#src/jotun/net/HttpRequest.hx:661: characters 3-14
		$api->close();
	}

	/**
	 * Sends `this` Http request to the Url specified by `this.url`.
	 * If `post` is true, the request is sent as POST request, otherwise it is
	 * sent as GET request.
	 * Depending on the outcome of the request, this method calls the
	 * onStatus(), onError() or onData() callback functions.
	 * If `this.url` is null, the result is unspecified.
	 * If `this.url` is an invalid or inaccessible Url, the onError() callback
	 * function is called.
	 * (Js) If `this.async` is false, the callback functions are called before
	 * this method returns.
	 * 
	 * @param bool $post
	 * 
	 * @return void
	 */
	public function request ($post = null) {
		#src/jotun/net/HttpRequest.hx:322: lines 322-346
		$_gthis = $this;
		#src/jotun/net/HttpRequest.hx:323: characters 4-18
		$me = $this;
		#src/jotun/net/HttpRequest.hx:324: characters 4-18
		$me = $this;
		#src/jotun/net/HttpRequest.hx:325: characters 4-43
		$output = new BytesOutput();
		#src/jotun/net/HttpRequest.hx:326: characters 4-22
		$old = $this->onError;
		#src/jotun/net/HttpRequest.hx:327: characters 4-20
		$err = false;
		#src/jotun/net/HttpRequest.hx:328: lines 328-338
		$this->onError = function ($e) use (&$err, &$old, &$_gthis, &$output, &$me) {
			#src/jotun/net/HttpRequest.hx:332: characters 5-51
			$me->responseData = $output->getBytes()->toString();
			#src/jotun/net/HttpRequest.hx:334: characters 5-15
			$err = true;
			#src/jotun/net/HttpRequest.hx:336: characters 5-18
			$_gthis->onError = $old;
			#src/jotun/net/HttpRequest.hx:337: characters 5-15
			$_gthis->onError($e);
		};
		#src/jotun/net/HttpRequest.hx:339: characters 4-30
		$this->customRequest($post, $output);
		#src/jotun/net/HttpRequest.hx:340: lines 340-344
		if (!$err) {
			#src/jotun/net/HttpRequest.hx:344: characters 5-62
			$me->onData($me->responseData = $output->getBytes()->toString());
		}
	}

	/**
	 * Sets the header identified as `header` to value `value`.
	 * If `header` or `value` are null, the result is unspecified.
	 * This method provides a fluent interface.
	 * 
	 * @param string $header
	 * @param string $value
	 * 
	 * @return HttpRequest
	 */
	public function setHeader ($header, $value) {
		#src/jotun/net/HttpRequest.hx:129: characters 3-47
		$this->headers->push(new _HxAnon_HttpRequest0($header, $value));
		#src/jotun/net/HttpRequest.hx:130: characters 3-14
		return $this;
	}

	/**
	 * Sets the parameter identified as `param` to value `value`.
	 * If `header` or `value` are null, the result is unspecified.
	 * This method provides a fluent interface.
	 * 
	 * @param string $param
	 * @param string $value
	 * 
	 * @return HttpRequest
	 */
	public function setParameter ($param, $value) {
		#src/jotun/net/HttpRequest.hx:147: characters 4-45
		$this->params->push(new _HxAnon_HttpRequest1($param, $value));
		#src/jotun/net/HttpRequest.hx:148: characters 4-15
		return $this;
	}
}

class _HxAnon_HttpRequest0 extends HxAnon {
	function __construct($header, $value) {
		$this->header = $header;
		$this->value = $value;
	}
}

class _HxAnon_HttpRequest1 extends HxAnon {
	function __construct($param, $value) {
		$this->param = $param;
		$this->value = $value;
	}
}

class _HxAnon_HttpRequest2 extends HxAnon {
	function __construct($param, $filename, $io, $size, $mimeType) {
		$this->param = $param;
		$this->filename = $filename;
		$this->io = $io;
		$this->size = $size;
		$this->mimeType = $mimeType;
	}
}

Boot::registerClass(HttpRequest::class, 'jotun.net.HttpRequest');
