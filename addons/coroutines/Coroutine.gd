extends RefCounted
class_name Coroutine

# For resume functionality
signal resume_signal()
var _is_started: = false
var is_completed: = false

# For join functionality
signal _join()
var _futures_count: = -1

var return_value


func resumable_call(callable: Callable) -> void:
	assert(not is_completed, "This Coroutine was already used")
	_is_started = true
	return_value = await callable.call(self)
	is_completed = true


func resume() -> void:
	assert(_is_started, "Trying to resume a Coroutine that was not started")
	resume_signal.emit()


func add_future(callable: Callable) -> void:
	# init
	if _futures_count < 0:
		_futures_count = 0
		return_value = []

	var index: int = return_value.size()
	return_value.append(null)
	_futures_count += 1
	return_value[index] = await callable.call()
	_futures_count -= 1
	if _futures_count == 0:
		_join.emit()


func join() -> Array:
	if _futures_count <= 0:
		return return_value
	await _join
	return return_value
	
