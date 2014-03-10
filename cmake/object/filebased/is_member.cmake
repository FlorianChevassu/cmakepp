# returns true if ref is member of an object
function(is_member result ref)
	map_navigate(res "${ref}")
	return_value(${res})
	return()
	if(NOT EXISTS ${ref})
		return_value(false)
	endif()
	if(IS_DIRECTORY ${ref})
		return_value(false)
	endif()
# in 2812 use DIRECTOY instead of PATH
	get_filename_component(obj ${ref} PATH )
	is_object(isobj ${obj})
	return_value(${isobj})
endfunction()