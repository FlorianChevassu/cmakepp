
function(obj_new result constructor )
	message("obj_new ${ARGV}")
	obj_create(this ${ARGN})
	obj_getref(${constructor} call __call__)
	this_setfunction(__init__ "${call}")
	obj_getprototype("${constructor}" proto)
	this_setprototype( ${proto})
	obj_callmember(${this} __init__)
	return_value(${this})
endfunction()