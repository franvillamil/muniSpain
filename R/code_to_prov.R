#' Get province name from province code.
#'
#' @param code Character or integer vector. Valid numbers from 1 to 52.
#'
#' @return Character, province name (official, lower-case).
#'
#' @examples
#' code_to_prov(c(1, 2, 3, "33"))
#'
#' @export
code_to_prov = function(code){

  # Adapt to integer
  code_original = code
  code = as.integer(code)

  # Check
  if(!all(code %in% 1:52)){
    stop(paste0("Codes not valid: ",
      paste(unique(code_original[!code %in% 1:52]), collapse = ", ")))
  }

  # Transform to name
  prov_name = code
  prov_name[code == 15] = "a coruna"
  prov_name[code == 1] = "alava"
  prov_name[code == 2] = "albacete"
  prov_name[code == 3] = "alicante"
  prov_name[code == 4] = "almeria"
  prov_name[code == 33] = "asturias"
  prov_name[code == 5] = "avila"
  prov_name[code == 6] = "badajoz"
  prov_name[code == 7] = "baleares"
  prov_name[code == 8] = "barcelona"
  prov_name[code == 48] = "bizkaia"
  prov_name[code == 9] = "burgos"
  prov_name[code == 10] = "caceres"
  prov_name[code == 11] = "cadiz"
  prov_name[code == 39] = "cantabria"
  prov_name[code == 12] = "castellon"
  prov_name[code == 51] = "ceuta"
  prov_name[code == 13] = "ciudad real"
  prov_name[code == 14] = "cordoba"
  prov_name[code == 16] = "cuenca"
  prov_name[code == 20] = "gipuzkoa"
  prov_name[code == 17] = "girona"
  prov_name[code == 18] = "granada"
  prov_name[code == 19] = "guadalajara"
  prov_name[code == 21] = "huelva"
  prov_name[code == 22] = "huesca"
  prov_name[code == 23] = "jaen"
  prov_name[code == 26] = "la rioja"
  prov_name[code == 35] = "las palmas"
  prov_name[code == 24] = "leon"
  prov_name[code == 25] = "lleida"
  prov_name[code == 27] = "lugo"
  prov_name[code == 28] = "madrid"
  prov_name[code == 29] = "malaga"
  prov_name[code == 52] = "melilla"
  prov_name[code == 30] = "murcia"
  prov_name[code == 31] = "navarra"
  prov_name[code == 32] = "ourense"
  prov_name[code == 34] = "palencia"
  prov_name[code == 36] = "pontevedra"
  prov_name[code == 37] = "salamanca"
  prov_name[code == 38] = "santa cruz de tenerife"
  prov_name[code == 40] = "segovia"
  prov_name[code == 41] = "sevilla"
  prov_name[code == 42] = "soria"
  prov_name[code == 43] = "tarragona"
  prov_name[code == 44] = "teruel"
  prov_name[code == 45] = "toledo"
  prov_name[code == 46] = "valencia"
  prov_name[code == 47] = "valladolid"
  prov_name[code == 49] = "zamora"
  prov_name[code == 50] = "zaragoza"

  # Output
  return(prov_name)

}
