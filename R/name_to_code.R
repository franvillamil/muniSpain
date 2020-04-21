#' Returns INE codes corresponding to municipality names.
#'
#' @param muni Character string or character vector. It returns a character vector of
#'   INE codes equivalent to the input. If not found, it returns NA. In case two codes
#'   share a municipality name in the same province, it returns the municipality existing
#'   in latest census, or the one that had the name in latest census. Otherwise, it gives
#'   a warning. Usually, these problems are due to a municipality changing name and code,
#'   and then returning to the old denomination, but there might be more problematic cases.
#'
#' @param prov Optional, character vector. Include in case of name duplicates.
#'   If a duplicate is found and no province was specified, it returns an error message.
#'   If only one value is given for a set of municipalities, it is expanded to all of them.
#'
#'   Accepts official names, case-insensitive: Alava, Albacete, Alicante,
#'   Almeria, Avila, Badajoz, Baleares, Barcelona, Burgos, Caceres, Cadiz,
#'   Castellon, Ceuta, Ciudad Real, Cordoba, A Coruna, Cuenca, Girona,
#'   Granada, Guadalajara, Gipuzkoa, Huelva, Huesca, Jaen, Leon, Lleida,
#'   La Rioja, Lugo, Madrid, Malaga, Melilla, Murcia, Navarra, Ourense,
#'   Asturias, Palencia, Las Palmas, Pontevedra, Salamanca,
#'   Santa Cruz de Tenerife, Cantabria, Segovia, Sevilla, Soria, Tarragona,
#'   Teruel, Toledo, Valencia, Valladolid, Bizkaia, Zamora, Zaragoza.
#'   Also: Araba, La Coruna, Gerona, Lerida, Guipuzcoa, Vizcaya.
#'
#' @param year Integer, code_list will be restricted to municipalities existing in a
#'   particular census year. Must be a valid census year.
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
name_to_code = function(muni, prov = NULL, year = NULL){

  if(class(muni) != "character"){
    stop("muni must be of class 'character'")
  }

  # Restrict code_list to years, if provided
  y_valid = c(1857, 1860, 1877, 1887, 1897, 1900, 1910, 1920,
    1930, 1940, 1950, 1960, 1970, 1981, 1991, 2001, 2011)
  if(!is.null(year)){
    if(!year %in% y_valid){stop("Year must be a valid census year")}
    c_year = is.na(census[, paste0("c", year)])
    c_year = census$muni_code[!c_year]
    code_list = subset(codelist, muni_code %in% c_year)
  } else {code_list = codelist}

  # Adapt muni to lower-case and add regex
  muni_ptt = gsub("\\(", "\\\\\\(", muni)
  muni_ptt = gsub("\\)", "\\\\\\)", muni_ptt)
  muni_ptt = paste0("(^|;)", muni_ptt, "(;|$)")

  # Expand province name if only one was given for many municipalities
  if(length(muni) > 1 & length(prov) == 1){
    prov = rep(prov, length(muni))
  }

  # Functions to find rows in code_list
  return_rows_noprov = function(muni_regex){
    rows = code_list[grepl(muni_regex, code_list$names, ignore.case = TRUE),]
    if(nrow(rows) != 0){rows$regex = muni_regex}
    if(length(unique(rows$prov)) > 1){
      stop("Same names in different provinces. Please specify provinces.")}
    return(rows)
  }

  return_rows = function(muni_regex, prov){
    rows = code_list[grepl(muni_regex, code_list$names, ignore.case = TRUE) &
      code_list$prov_name == tolower(prov),]
    if(nrow(rows) != 0){rows$regex = muni_regex}
    return(rows)
  }

  # If something in prov, check & apply relevant variable
  if(!is.null(prov)){

    # Correct usual
    prov[tolower(prov) == "araba"] = "Alava"
    prov[tolower(prov) == "la coruna"] = "A Coruna"
    prov[tolower(prov) == "gerona"] = "Girona"
    prov[tolower(prov) == "lerida"] = "Lleida"
    prov[tolower(prov) == "guipuzcoa"] = "Gipuzkoa"
    prov[tolower(prov) == "vizcaya"] = "Bizkaia"

    if(length(prov) != length(muni)){
      stop("'prov' and 'muni' must have the same length")
    } else if(!all(tolower(prov) %in% code_list$prov_name)){
      stop(paste0("Province names not valid, misspelled? Not matched:",
        (prov[!tolower(prov) %in% code_list$prov_name]) ))
    }
    rows_found = apply(cbind(muni_ptt, prov), 1, function(x) return_rows(x[1], x[2]))

  # If prov = NULL
  } else {
    rows_found = lapply(muni_ptt, function(x) return_rows_noprov(x))
  }

  # Get municipality codes
  rows_to_code = function(code_list_row){

    # Get municipality codes and check for non-standard lengths
    code = code_list_row$muni_code

    # If no one, just return NA
    if(length(code) == 0){code = NA}

    # If more than 1, messy
    if(length(code) > 1){

      # Get census with those codes
      s_census = subset(census, muni_code %in% code)

      # If both codes were present in last census, return the one matching
      if(!any(is.na(s_census[, ncol(s_census)]))){
        s_census = subset(s_census, grepl(unique(code_list_row$regex), muni_name))
      # If some but not all were missing from last census, return the one existing
      } else if (any(!is.na(s_census[, ncol(s_census)]))){
        s_census = s_census[!is.na(s_census[, ncol(s_census)]),]
      # If all missing, just Warning + NA
      } else {
        code = NA
        print(paste0("WARNING. Problem with ",
          gsub("\\(|\\)|\\$|\\;|\\^|\\|", "", unique(code_list_row$regex)),
          " in ", unique(code_list_row$prov_name)))
      }

      # Check if results is unique, if not just throw Warning + NA
      if(nrow(s_census) == 1){
        code = s_census$muni_code
        print(paste0("Several matches for ",
          gsub("\\(|\\)|\\$|\\;|\\^|\\|", "", unique(code_list_row$regex)),
          " in ", unique(code_list_row$prov_name), ". Returning: ", code))
      } else {
        code = NA
        print(paste0("WARNING. Problem with ",
          gsub("\\(|\\)|\\$|\\;|\\^|\\|", "", unique(code_list_row$regex)),
          " in ", unique(code_list_row$prov_name)))
      }

    }

    return(code)

  }

  codes = unlist(lapply(rows_found, rows_to_code))
  return(codes)

}
