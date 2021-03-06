## removes the specified range from the list
function(list_range_remove __lst range)
  list(LENGTH ${__lst} list_len)
  range_indices(${list_len} "${range}")
  ans(indices)
  list(LENGTH indices len)

  if(NOT len)
    return(0)
  endif()
  #message("${indices} - ${list_len}")
  if("${indices}" EQUAL ${list_len})
    return(0)
  endif()
  list(REMOVE_AT ${__lst} ${indices})
  set(${__lst} ${${__lst}} PARENT_SCOPE)
  return(${len})
endfunction()