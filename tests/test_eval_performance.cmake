function(test)
	message(STATUS "inconclusive")
	return()
	foreach(i RANGE 10000)
		eval("function(_test${i})\nendfunction()")
	endforeach()
endfunction()