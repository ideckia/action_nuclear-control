package;

import api.action.Data;

using api.IdeckiaApi;

typedef Props = {
	@:editable("Port used by the API", 3100)
	var port:Int;
}

@:name("nuclear-control")
@:description("Action to control Nuclear music player")
class NuclearControl extends IdeckiaAction {
	static var ICON = Data.embedBase64('img/nuclear_icon.png');
	static var PREVIOUS = Data.embedBase64('img/previous.png');
	static var NEXT = Data.embedBase64('img/next.png');
	static var PLAY = Data.embedBase64('img/play.png');
	static var PAUSE = Data.embedBase64('img/pause.png');

	override function init(initialState:ItemState):js.lib.Promise<ItemState> {
		var runtimeImg = Data.getBase64('img/nuclear_icon.png');
		if (runtimeImg != null)
			ICON = runtimeImg;
		runtimeImg = Data.getBase64('img/previous.png');
		if (runtimeImg != null)
			PREVIOUS = runtimeImg;
		runtimeImg = Data.getBase64('img/next.png');
		if (runtimeImg != null)
			NEXT = runtimeImg;
		runtimeImg = Data.getBase64('img/play.png');
		if (runtimeImg != null)
			PLAY = runtimeImg;
		runtimeImg = Data.getBase64('img/pause.png');
		if (runtimeImg != null)
			PAUSE = runtimeImg;

		initialState.icon = ICON;

		return super.init(initialState);
	}

	override public function getStatus() {
		server.log.info('nuclear getStatus');

		return new js.lib.Promise<ActionStatus>((resolve, _) -> {
			function handleError(e) {
				server.log.error('nuclear error: $e');
				resolve({
					code: ActionStatusCode.error,
					message: 'Could not connect to nuclear API in [http://localhost:${props.port}/nuclear/player/]: $e'
				});
			}
			js.Node.process.once('uncaughtException', handleError);
			CallHttp.getPortPath(props.port, 'now-playing').then(_ -> resolve({code: ActionStatusCode.ok})).catchError(handleError);
		});
	}

	public function execute(currentState:ItemState):js.lib.Promise<ActionOutcome> {
		var dynamicDir:DynamicDir = {
			rows: 2,
			columns: 2,
			items: [
				{
					textColor: 'ff333333',
					actions: [
						{
							name: '_nuclear-now-playing-item',
							props: {
								port: props.port
							}
						}
					]
				},
				{
					text: 'paused',
					icon: PLAY,
					actions: [
						{
							name: '_nuclear-play-pause-item',
							props: {
								port: props.port,
								play_icon: PLAY,
								pause_icon: PAUSE,
							}
						}
					]
				},
				{
					icon: PREVIOUS,
					actions: [
						{
							name: '_nuclear-item',
							props: {
								port: props.port,
								action: 'previous'
							}
						}
					]
				},
				{
					icon: NEXT,
					actions: [
						{
							name: '_nuclear-item',
							props: {
								port: props.port,
								action: 'next'
							}
						}
					]
				}
			]
		}
		return new js.lib.Promise((resolve, reject) -> resolve(new ActionOutcome({directory: dynamicDir})));
	}
}
