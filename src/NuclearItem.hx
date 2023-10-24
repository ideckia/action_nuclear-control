package;

using api.IdeckiaApi;

typedef Props = {
	@:editable("Port used by the API", 3100)
	var port:Int;
	@:editable("Action to execute by this item", "next", ["next", "previous"])
	var action:String;
}

@:name("nuclear-item")
@:description("A Nuclear control item")
class NuclearItem extends IdeckiaAction {
	public function execute(currentState:ItemState):js.lib.Promise<ActionOutcome> {
		return new js.lib.Promise((resolve, reject) -> {
			CallHttp.postPortPath(props.port, props.action).then(response -> {
				resolve(new ActionOutcome({state: currentState}));
			}).catchError(e -> {
				server.log.error('nuclear error: $e');
				reject(e);
			});
		});
	}
}
