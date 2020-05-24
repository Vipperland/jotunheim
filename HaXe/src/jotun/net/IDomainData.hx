package jotun.net;
import jotun.objects.IResolve;

/**
 * @author Rafael Moreira
 */

interface IDomainData extends IResolve {
	public var HTTP_HOST:String;
	public var HTTP_CONNECTION:String;
	public var HTTP_ACCEPT:String;
	public var HTTP_UPGRADE_INSECURE_REQUESTS:String;
	public var HTTP_USER_AGENT:String;
	public var HTTP_DNT:String;
	public var HTTP_AUTHORIZATION:String;
	public var HTTP_ACCEPT_ENCODING:String;
	public var HTTP_ACCEPT_LANGUAGE:String;
	public var HTTP_BASIC_AUTHENTICATION:String;
	public var HTTP_COOKIE:String;
	public var CONTENT_TYPE:String;
	public var CONTENT_LEGTH:String;
	public var SystemRoot:String;
	public var COMSPEC:String;
	public var PATHEXT:String;
	public var WINDIR:String;
	public var SERVER_SIGNATURE:String;
	public var SERVER_SOFTWARE:String;
	public var SERVER_NAME:String;
	public var SERVER_ADDR:String;
	public var SERVER_PORT:String;
	public var REMOTE_ADDR:String;
	public var DOCUMENT_ROOT:String;
	public var REQUEST_SCHEME:String;
	public var CONTEXT_PREFIX:String;
	public var CONTEXT_DOCUMENT_ROOT:String;
	public var SERVER_ADMIN:String;
	public var SCRIPT_FILENAME:String;
	public var REMOTE_PORT:String;
	public var GATEWAY_INTERFACE:String;
	public var SERVER_PROTOCOL:String;
	public var REQUEST_METHOD:String;
	public var QUERY_STRING:String;
	public var REQUEST_URI:String;
	public var SCRIPT_NAME:String;
	public var PHP_SELF:String;
	public var REQUEST_TIME_FLOAT:String;
	public var REQUEST_TIME:String;
	public var PHP_AUTH_USER:String;
	public var PHP_AUTH_PW:String;
	
}