extends RefCounted
class_name Coroutine

# For resume functionality
signal resume_signal()
var _is_started: = false
var is_completed: = false

# For join functionality
signal _join()
var _ended_count: = -1

var return_value


func resumable_call(callable: Callable) -> void:
	assert(not is_completed, "This Coroutine was already used")
	_is_started = true
	return_value = await callable.call(self)
	is_completed = true


func resume() -> void:
	assert(_is_started, "Trying to resume a Coroutine that was not started")
	resume_signal.emit()


func add_future(param) -> void:
	assert(param is Callable or param is Signal, "Can only wait on Signal or Callable")
	# init
	if _ended_count < 0:
		_ended_count = 0
		return_value = []

	var index: int = return_value.size()
	return_value.append(null)
	if param is Callable:
		return_value[index] = await param.call()
	else:
		await param
	_ended_count += 1
	if _ended_count == return_value.size():
		_join.emit()


func join_all() -> Array:
	if _ended_count == return_value.size():
		return return_value
	await _join
	return return_value


func join_either() -> Array:
	if _ended_count > 0:
		return return_value
	_ended_count = return_value.size() - 1
	await _join
	return return_value
