package;

using api.IdeckiaApi;

typedef Props = {
	@:editable("Port used by the API", 3100)
	var port:Int;
}

@:name("nuclear-now-playing-item")
@:description("A Nuclear control item that shows the 'now-playing' information")
class NuclearNowPlayingItem extends IdeckiaAction {
	var prevArtist = 'artist';
	var prevName = 'name';
	var updateTimer:haxe.Timer;

	override function show(currentState:ItemState):js.lib.Promise<ItemState> {
		return new js.lib.Promise((resolve, reject) -> {
			currentState.text = '{b:$prevArtist}\n$prevName';

			if (updateTimer == null) {
				updateTimer = new haxe.Timer(3000);
				updateTimer.run = () -> {
					updateInfo(currentState).then(updatedState -> {
						server.updateClientState(updatedState);
					});
				}
			}

			updateInfo(currentState).then(updatedState -> {
				resolve(updatedState);
			}).catchError(reject);
		});
	};

	override public function hide() {
		if (updateTimer != null) {
			updateTimer.stop();
			updateTimer = null;
		}
	}

	public function execute(currentState:ItemState):js.lib.Promise<ActionOutcome> {
		return new js.lib.Promise((resolve, reject) -> {
			updateInfo(currentState, true).finally(() -> resolve(new ActionOutcome({state: currentState})));
		});
	}

	function updateInfo(state:ItemState, force:Bool = false):js.lib.Promise<ItemState> {
		return new js.lib.Promise((resolve, reject) -> {
			CallHttp.getPortPath(props.port, 'now-playing').then(response -> {
				var npResp:Types.NowPlayingResponse = haxe.Json.parse(response);

				if (!force && npResp.artist == prevArtist && npResp.name == prevName) {
					return;
				}

				prevArtist = npResp.artist;
				prevName = npResp.name;
				state.text = '{b:${npResp.artist}}\n${npResp.name}';
				if (npResp.thumbnail == null) {
					resolve(state);
				}

				CallHttp.callEndpoint(npResp.thumbnail)
					.then(data -> state.icon = haxe.crypto.Base64.encode(data))
					.catchError(e -> server.log.error('Error getting ${npResp.thumbnail} thumbnail: $e'))
					.finally(() -> resolve(state));
			}).catchError(e -> {
				server.log.error('nuclear error: $e');
				reject(e);
			});
		});
	}
}
