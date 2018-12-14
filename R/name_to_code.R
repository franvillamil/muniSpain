#' Returns INE codes corresponding to municipality names.
#'
#' @param muni Character string or character vector. It returns a character vector of
#'   INE codes equivalent to the input. If not found, it returns NA.
#' @param prov Optional, character vector. Include in case of name duplicates.
#'   If a duplicate is found and no province was specified, it returns an error message.
#'
#'   Accepts official names, case-insentitive: Alava, Albacete, Alicante,
#'   Almeria, Avila, Badajoz, Baleares, Barcelona, Burgos, Caceres, Cadiz,
#'   Castellon, Ceuta, Ciudad Real, Cordoba, A Coruna, Cuenca, Girona,
#'   Granada, Guadalajara, Gipuzkoa, Huelva, Huesca, Jaen, Leon, Lleida,
#'   La Rioja, Lugo, Madrid, Malaga, Melilla, Murcia, Navarra, Ourense,
#'   Asturias, Palencia, Las Palmas, Pontevedra, Salamanca,
#'   Santa Cruz de Tenerife, Cantabria, Segovia, Sevilla, Soria, Tarragona,
#'   Teruel, Toledo, Valencia, Valladolid, Bizkaia, Zamora, Zaragoza.
#'
#' @return Character vector equivalent to the input. NA if not found.
#'
#' @examples
#'   # name_to_code("Tapia") # Returns an error
#'   # name_to_code(c("Tapia", "Castropol")) # Returns an error
#'   name_to_code("Tapia de Casariego")
#'   name_to_code(c("Tapia", "Castropol"), rep("Asturias", 2))
#'
#'
#' @export
name_to_code = function(muni, prov = NULL){

  if(class(muni) != "character"){
    stop("muni must be of class 'character'")
  }

  # Adapt muni to lower-case and add regex
  muni_ptt = paste0("(^|;)", muni, "(;|$)")

  # If something in prov, check
  if(!is.null(prov)){
    if(length(prov) != length(muni)){
      stop("prov and muni must have the same length")
    }
    if(!all(tolower(prov) %in% codelist$prov_name)){
      stop("Province names not valid - misspelled?")
    }

    mp = data.frame(p = prov, m = muni_ptt, i = NA)
    for(i in 1:nrow(mp)){
      found = which(grepl(mp[i, "p"], codelist$prov_name, ignore.case = TRUE) &
        grepl(mp[i, "m"], codelist$names, ignore.case = TRUE))
      mp[i, "i"] = found
    }
    found_codes = codelist$muni_code[mp$i]
    return(found_codes)

  } else {

    found = sapply(muni_ptt, function(x){
      result = grep(x, codelist$names, ignore.case = TRUE)
      if(length(result) == 0){result = NA}
      result})

    if(class(found) == "list" | length(found) > length(muni_ptt)){
      stop("Duplicates found - please specify provinces")
    } else {
      found_codes = codelist$muni_code[found]
      return(found_codes)
    }

  }

}
