# tries to match the regex at the begging of ${${str_name}} and returns the match
# ${str_name} is shortened in the process
# match is returned
function(string_take_regex str_name regex)
  string(REGEX MATCH "^(${regex})" match "${${str_name}}")
  string(LENGTH "${match}" len)
  if(len)
    string(SUBSTRING "${${str_name}}" ${len} -1 res )
    set(${str_name} "${res}" PARENT_SCOPE)
    return_ref(match)
  endif()
  return()
endfunction()

## fasterversion does not work in case of nested regex parenthesis
## and unknown matchgroup of rest string
# function(string_take_regex str_name regex)
#   if("${${str_name}}" MATCHES "^(${regex})(.*)$")
#     set(${str_name} "${CMAKE_MATCH_2}" PARENT_SCOPE)
#     set(__ans "${CMAKE_MATCH_1}" PARENT_SCOPE)
    
#     endif()
#   else()
#     set(__ans PARENT_SCOPE)
#   endif()



# endfunction()


## fasterversion
## also does not work.... 
# function(string_take_regex str_name regex)
#   if("${${str_name}}" MATCHES "^(${regex})")
#     set(__ans "${CMAKE_MATCH_1}" PARENT_SCOPE)
#     string(REGEX REPLACE "^(${regex})" "" "${str_name}" "${${str_name}}")
#     set(${str_name} "${${str_name}}" PARENT_SCOPE)    
#   else()
#     set(__ans PARENT_SCOPE)
#   endif()
# endfunction()




function(string_take_regex_replace str_name regex replace)
  string_take_regex(${str_name} "${regex}")
  ans(match)
  if("${match}_" STREQUAL _)
    return()
  endif()
  set(${str_name} "${${str_name}}" PARENT_SCOPE)
  string(REGEX REPLACE "${regex}" "${replace}" match "${match}")
  return_ref(match)
endfunction()

