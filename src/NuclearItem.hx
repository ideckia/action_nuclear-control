package;

using api.IdeckiaApi;

typedef Props = {
	@:editable("prop_port", 3100)
	var port:Int;
	@:editable("prop_action", "next", ["next", "previous"])
	var action:String;
}

@:name("_nuclear-item")
@:description("item_action_description")
@:localize
class NuclearItem extends IdeckiaAction {
	public function execute(currentState:ItemState):js.lib.Promise<ActionOutcome> {
		return new js.lib.Promise((resolve, reject) -> {
			CallHttp.postPortPath(props.port, props.action).then(response -> {
				resolve(new ActionOutcome({state: currentState}));
			}).catchError(e -> {
				core.log.error('nuclear error: $e');
				reject(e);
			});
		});
	}
}
