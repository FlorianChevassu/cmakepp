  ## package_source_resolve_composite(<~uri>) -> <package handle>
  ## returns the package handle for the speciified uri
  ## the handle's package_source property will point to the package source used

  function(package_source_resolve_composite uri)
    set(args ${ARGN})

#    message(FORMAT "package_source_resolve_composite: {uri.uri}")
    uri_coerce(uri)

    ## query composite returns the best matching package_uris first
    ## specifiying --package-handle returns the package handle as 
    ## containing the package_uri and the package_source
    package_source_query_composite("${uri}" --package-handle)
    ans(package_handles)

    ## loops through every package handle and tries to resolve
    ## it. returns the handle on the first success
    while(true)

      if(NOT package_handles)
        return()
      endif()

      list_pop_front(package_handles)
      ans(package_handle)
      
      map_tryget(${package_handle} package_source_name)
      ans(package_source_name)

      assign(package_source = "this.children.${package_source_name}")
      
      if(NOT package_source)
        message(FATAL_ERROR "package handle missing package_source property")
      endif()

      map_tryget(${package_handle} uri)
      ans(uri)
      assign(package_handle = package_source.resolve("${uri}"))

      if(package_handle)
        ## copy over package source to new package handle
        assign(package_handle.package_source_name = package_source_name)
       # assign(package_handle.rating = source_uri.rating)
        return_ref(package_handle)
      endif()

    endwhile()
    return()
  endfunction() 

  