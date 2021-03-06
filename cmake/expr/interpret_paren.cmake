

function(interpret_paren list_token)
  list(LENGTH list_token count)
  if(NOT "${count}" EQUAL 1)
    return()
  endif()
  map_tryget("${list_token}" type)
  ans(type)
  if(NOT "${type}" STREQUAL "paren")
    return()
  endif()

  map_tryget("${list_token}" tokens)
  ans(tokens)

  interpret_separation("${tokens}" "comma")
  ans(ast)

  map_set(${ast} type paren)
  
  return(${ast})

endfunction()
