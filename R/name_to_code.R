#' Returns INE codes corresponding to municipality names.
#'
#' @param muni Character string or character vector. It returns a character vector of
#'   INE codes equivalent to the input. If not found, it returns NA. In case two codes
#'   share a municipality name in the same province, it returns the largest code (usually,
#'   the latest municipality) and a warning. Usually, this is due to a municipality changing
#'   name and code, and then returning to the old denomination. A more problematic case is
#'   where two different municipalities in the same province share a name in the past.
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
  muni_ptt = gsub("\\(", "\\\\\\(", muni)
  muni_ptt = gsub("\\)", "\\\\\\)", muni_ptt)
  muni_ptt = paste0("(^|;)", muni_ptt, "(;|$)")

  # Functions to find rows in codelist
  return_rows_noprov = function(muni_regex){
    rows = codelist[grepl(muni_regex, codelist$names, ignore.case = TRUE),]
    if(length(unique(rows$prov)) > 1){
      stop("Identical municipality names in different provinces. Please specify provinces.")
    } else if(nrow(rows)>1 & length(unique(rows$prov))==1){
      print(paste0("Identical municipality names within the same province, for '",
        gsub("\\(|\\)|\\$|\\;|\\^|\\|", "", muni_regex),
        "'. Returning highest code: ", rows$muni_code[rows$muni_code==max(rows$muni_code)]))
    }
    return(rows)
  }

  return_rows = function(muni_regex, prov){
    rows = codelist[grepl(muni_regex, codelist$names, ignore.case = TRUE) &
      codelist$prov_name == tolower(prov),]
    if(nrow(rows) > 1){
      print(paste0("Identical municipality names within the same province, for '",
        gsub("\\(|\\)|\\$|\\;|\\^|\\|", "", muni_regex), "' in ", prov,
        ". Returning highest code: ", rows$muni_code[rows$muni_code==max(rows$muni_code)]))
    }
    return(rows)
  }

  # If something in prov, check & apply relevant variable
  if(!is.null(prov)){

    if(length(prov) != length(muni)){
      stop("prov and muni must have the same length")
    } else if(!all(tolower(prov) %in% codelist$prov_name)){
      stop("Province names not valid - misspelled?")
    }
    rows_found = apply(cbind(muni_ptt, prov), 1, function(x) return_rows(x[1], x[2]))

  # If prov = NULL
  } else {
    rows_found = lapply(muni_ptt, function(x) return_rows_noprov(x))
  }

  # Get municipality codes
  rows_to_code = function(codelist_row){
    code = codelist_row$muni_code
    if(length(code) == 0){
      code = NA
    } else if(length(code) > 1){
      code = code[code == max(code)]
    }
    return(code)
  }

  codes = unlist(lapply(rows_found, rows_to_code))
  return(codes)

}
