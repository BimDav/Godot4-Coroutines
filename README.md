# Godot4-Coroutines
Easy to use Coroutine functionality in Godot 4

## Resume ##
The Resume pattern is used to stop the execution in a subfunction, which will wait for its caller to call
`resume()` for it to continue where it had stopped. See `ResumeExample.tscn`.

- The resumable function must take a `Coroutine` as first argument. To stop execution, it must await on the `Coroutine`'s `resume_signal` signal.
- Create a Coroutine using `var coroutine := Coroutine.new()`
- Call the resumable function using `coroutine.resumable_call(my_resumable_function)`
- Note: use `bind`to add arguments to the call:  `coroutine.resumable_call(my_resumable_function.bind(arg1, arg2))`
- Execution in `my_resumable_function()`will stop on `await coroutine.resume_signal`
- Resume the execution using `coroutine.resume()`
- Once `my_resumable_function()`has finished, `coroutine.is_completed`is set to `true`and the return value of `my_resumable_function()`is in `coroutine.return_value`

## Join All ##
Join All is used to launch the execution of multiple functions, then waiting for them all to finish before continuing execution. See `JoinAllExample.tscn`.

- Create a Coroutine using `var coroutine := Coroutine.new()`
- Add a function you want to differ awaiting on using `coroutine.add_future(my_joinable_function)`
- When all functions are added, use `await coroutine.join_all()` to wait for them all to finish

## Join Either ##
Join Either is used to launch the execution of multiple functions, then waiting for at least one to finish before continuing execution. See `JoinEitherExample.tscn`.

- Create a Coroutine using `var coroutine := Coroutine.new()`
- Add a function you want to differ awaiting on using `coroutine.add_future(my_joinable_function)`
- When all functions are added, use `await coroutine.join_either()` to wait for at least one of them to finish
