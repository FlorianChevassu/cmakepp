## `(<start index> <end index>)-> <cmake code>`
## 
## captures the cmake code for the calling function and returns it as a string  
macro(arguments_cmake_code __args_start __args_end)
  string_codes()
  set(__args_command_invocations)
  set(__args_level 0)
  set(__args_current_invocation)
  foreach(i RANGE ${__args_start} ${__args_end})
    set(__args_current_token "${ARGV${i}}")

    set(__args_invocation_complete false)
    if("${__args_current_token}_" STREQUAL "(_")
      math(EXPR __args_level "${__args_level} + 1")
    elseif("${__args_current_token}_" STREQUAL ")_")
      math(EXPR __args_level "${__args_level} - 1")
      if(NOT __args_level)
        set(__args_invocation_complete true)
      endif()
    else()
     
     if("${__args_current_token}" MATCHES "[ \"\\(\\)#\\^\t\r\n\\\;]")
        ## encoded list encode cmake string...
        ## @ todo this has to be extracted however it does not work correctly because
        ## of macro evaluation when using cmake_string_escape2
        string(REPLACE ";" "${semicolon_code}" __args_current_token "${__args_current_token}")
        string(REPLACE "\\" "\\\\" __args_current_token "${__args_current_token}")
        string(REGEX REPLACE "([ \"\\(\\)#\\^])" "\\\\\\1" __args_current_token "${__args_current_token}")
        string(REPLACE "\t" "\\t" __args_current_token "${__args_current_token}")
        string(REPLACE "\n" "\\n" __args_current_token "${__args_current_token}")
        string(REPLACE "\r" "\\r" __args_current_token "${__args_current_token}")  
      endif()
    endif()
    list(APPEND __args_current_invocation "${__args_current_token} ")
    if(__args_invocation_complete)
      string(CONCAT __args_current_invocation ${__args_current_invocation})
      list(APPEND __args_command_invocations "${__args_current_invocation}\n")
      set(__args_current_invocation)
    endif()
  endforeach()

  string(CONCAT __ans ${__args_command_invocations})
  string(REPLACE "${semicolon_code}" "\\;" __ans "${__ans}")
endmacro()