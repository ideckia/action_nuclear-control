package;

using api.IdeckiaApi;

typedef Props = {
	@:editable("prop_port", 3100)
	var port:Int;
	var play_icon:String;
	var pause_icon:String;
}

@:name("_nuclear-play-pause-item")
@:description("play_pause_action_description")
@:localize
class NuclearPlayPauseItem extends IdeckiaAction {
	override function init(initialState:ItemState):js.lib.Promise<ItemState> {
		return new js.lib.Promise((resolve, reject) -> {
			updateInfo(initialState).then(newState -> resolve(newState));
		});
	}

	override public function show(currentState:ItemState):js.lib.Promise<ItemState> {
		return new js.lib.Promise((resolve, reject) -> {
			updateInfo(currentState).then(newState -> resolve(newState));
		});
	}

	public function execute(currentState:ItemState):js.lib.Promise<ActionOutcome> {
		return new js.lib.Promise((resolve, reject) -> {
			CallHttp.postPortPath(props.port, 'play-pause')
				.then(response -> {
					updateInfo(currentState).then(newState -> resolve(new ActionOutcome({state: newState})));
				})
				.catchError(e -> core.log.error('nuclear error: $e'))
				.finally(() -> resolve(new ActionOutcome({state: currentState})));
		});
	}

	function updateInfo(state:ItemState):js.lib.Promise<ItemState> {
		return new js.lib.Promise((resolve, reject) -> {
			CallHttp.getPortPath(props.port, 'now-playing')
				.then(response -> {
					var npResp:Types.NowPlayingResponse = haxe.Json.parse(response);

					if (npResp.playbackStatus == 'PAUSED') {
						state.icon = props.play_icon;
						state.text = Loc.paused.tr();
					} else if (npResp.playbackStatus == 'PLAYING') {
						state.icon = props.pause_icon;
						state.text = Loc.playing.tr();
					}
				})
				.catchError(e -> core.log.error('nuclear error: $e'))
				.finally(() -> resolve(state));
		});
	}
}
