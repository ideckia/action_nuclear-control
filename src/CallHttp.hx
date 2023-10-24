class CallHttp {
	public static function getPortPath(port:Int, path:String) {
		return callPortPath(port, path, false);
	}

	public static function postPortPath(port:Int, path:String) {
		return callPortPath(port, path, true);
	}

	private static function callPortPath(port:Int, path:String, post:Bool = false) {
		return new js.lib.Promise((resolve, reject) -> {
			var http = new haxe.Http('http://localhost:${port}/nuclear/player/$path');
			http.addHeader('Accept', 'application/json');
			http.onError = reject;
			http.onData = resolve;
			http.request(post);
		});
	}

	public static function callEndpoint(endpoint:String, post:Bool = false) {
		return new js.lib.Promise((resolve, reject) -> {
			var http = new haxe.Http(endpoint);
			http.addHeader('Accept', 'application/json');
			http.onError = reject;
			http.onBytes = resolve;
			http.request(post);
		});
	}
}
