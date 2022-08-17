extends Timer

var function: FuncRef

func turn_on(fun: FuncRef):
	function = fun
	start()

func _on_timeout():
	function.call_func()
