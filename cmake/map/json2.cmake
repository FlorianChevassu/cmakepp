function(json2 input)
  json2_definition()
  ans(lang)
  language_initialize(${lang})
  ref_set(json2_language_definition "${lang}")
  function(json2 input) 
    set(cached ${ARGN})
    #if(cached)
      string(MD5 cache_key "${input}" )
      if(EXISTS "${cutil_temp_dir}/json2/${cache_key}.json")
        message("getting cached")
        include("${cutil_temp_dir}/json2/${cache_key}.json")
        return_ans()

      endif()
    #endif()
    ref_get(json2_language_definition)
    ans(lang)

    map_new()
    ans(ctx)
    map_set(${ctx} input "${input}")
    map_set(${ctx} def "json")
    obj_setprototype(${ctx} "${lang}")

    #lang2(output json2 input "${input}" def "json")
    lang(output ${ctx})
    ans(res)
    #if(cached)
      qm_serialize("${res}")
      ans(qm)
      file(WRITE "${cutil_temp_dir}/json2/${cache_key}.json" "${qm}")
    #endif()
    return_ref(res)
  endfunction()
  json2("${input}")
  return_ans()
endfunction()