#' Get CCAA from province name.
#'
#' @param prov Character vector.
#'
#'   Accepts official names, case-insensitive: Alava, Albacete, Alicante,
#'   Almeria, Avila, Badajoz, Baleares, Barcelona, Burgos, Caceres, Cadiz,
#'   Castellon, Ceuta, Ciudad Real, Cordoba, A Coruna, Cuenca, Girona,
#'   Granada, Guadalajara, Gipuzkoa, Huelva, Huesca, Jaen, Leon, Lleida,
#'   La Rioja, Lugo, Madrid, Malaga, Melilla, Murcia, Navarra, Ourense,
#'   Asturias, Palencia, Las Palmas, Pontevedra, Salamanca,
#'   Santa Cruz de Tenerife, Cantabria, Segovia, Sevilla, Soria, Tarragona,
#'   Teruel, Toledo, Valencia, Valladolid, Bizkaia, Zamora, Zaragoza.
#'   Also: Araba, La Coruna, Orense, Gerona, Lerida, Guipuzcoa, Vizcaya.
#'
#' @return Integer, province code. Returns simplified names, not official ones.
#'
#' @examples
#' prov_to_ccaa(c("Asturias", "asturias", "Lugo", "lleida", "Lerida"))
#'
#' @export
prov_to_ccaa = function(prov){

  # Adapt and to lower
  prov_name = adapt(prov, tolower = TRUE)

  # Correct usual
  prov_name[tolower(prov_name) == "araba"] = "alava"
  prov_name[tolower(prov_name) == "la coruna"] = "a coruna"
  prov_name[tolower(prov_name) == "orense"] = "ourense"
  prov_name[tolower(prov_name) == "gerona"] = "girona"
  prov_name[tolower(prov_name) == "lerida"] = "lleida"
  prov_name[tolower(prov_name) == "guipuzcoa"] = "gipuzkoa"
  prov_name[tolower(prov_name) == "vizcaya"] = "bizkaia"

  # Check
  prov_list = c("a coruna", "alava", "albacete", "alicante", "almeria", "asturias",
  "avila", "badajoz", "baleares", "barcelona", "bizkaia", "burgos",
  "caceres", "cadiz", "cantabria", "castellon", "ceuta", "ciudad real",
  "cordoba", "cuenca", "gipuzkoa", "girona", "granada", "guadalajara",
  "huelva", "huesca", "jaen", "la rioja", "las palmas", "leon",
  "lleida", "lugo", "madrid", "malaga", "melilla", "murcia", "navarra",
  "ourense", "palencia", "pontevedra", "salamanca", "santa cruz de tenerife",
  "segovia", "sevilla", "soria", "tarragona", "teruel", "toledo",
  "valencia", "valladolid", "zamora", "zaragoza")
  if(!all(prov_name %in% prov_list)){
    stop(paste0("Unknown province names: ",
      paste(unique(prov_name[!prov_name %in% prov_list]), collapse = ", ")))
  }

  # Transform to CCAA
  ccaa = prov_name
  ccaa[prov_name %in% c("alava", "bizkaia", "gipuzkoa")] = "euskadi"
  ccaa[prov_name %in% c("a coruna", "lugo", "ourense", "pontevedra")] = "galicia"
  ccaa[prov_name %in% c("huesca", "zaragoza", "teruel")] = "aragon"
  ccaa[prov_name %in% c("lleida", "girona", "tarragona", "barcelona")] = "catalunya"
  ccaa[prov_name %in% c("santa cruz de tenerife", "las palmas")] = "canarias"
  ccaa[prov_name %in% c("badajoz", "caceres")] = "extremadura"
  ccaa[prov_name %in% c("alicante", "castellon", "valencia")] = "comunidad valenciana"
  ccaa[prov_name %in% c("albacete", "ciudad real", "cuenca",
    "guadalajara", "toledo")] = "castilla-la mancha"
  ccaa[prov_name %in% c("almeria", "cadiz", "cordoba", "granada",
    "huelva", "jaen", "malaga", "sevilla")] = "andalucia"
  ccaa[prov_name %in% c("avila", "burgos", "leon", "palencia",
    "salamanca", "segovia", "soria", "valladolid", "zamora")] = "castilla y leon"

  # Output
  return(ccaa)

}
