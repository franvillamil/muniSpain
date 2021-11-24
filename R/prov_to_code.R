#' Get province code from province name.
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
#' @return Integer, province code.
#'
#' @examples
#' prov_to_code(c("Asturias", "asturias", "Lugo", "lleida", "Lerida"))
#'
#' @export
prov_to_code = function(prov){

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
    warning(paste0("Unknown province names: ",
      paste(unique(prov_name[!prov_name %in% prov_list]), collapse = ", ")))
  }

  # Transform to code
  prov_code = NA
  prov_code[prov_name == "a coruna"] = 15
  prov_code[prov_name == "alava"] = 1
  prov_code[prov_name == "albacete"] = 2
  prov_code[prov_name == "alicante"] = 3
  prov_code[prov_name == "almeria"] = 4
  prov_code[prov_name == "asturias"] = 33
  prov_code[prov_name == "avila"] = 5
  prov_code[prov_name == "badajoz"] = 6
  prov_code[prov_name == "baleares"] = 7
  prov_code[prov_name == "barcelona"] = 8
  prov_code[prov_name == "bizkaia"] = 48
  prov_code[prov_name == "burgos"] = 9
  prov_code[prov_name == "caceres"] = 10
  prov_code[prov_name == "cadiz"] = 11
  prov_code[prov_name == "cantabria"] = 39
  prov_code[prov_name == "castellon"] = 12
  prov_code[prov_name == "ceuta"] = 51
  prov_code[prov_name == "ciudad real"] = 13
  prov_code[prov_name == "cordoba"] = 14
  prov_code[prov_name == "cuenca"] = 16
  prov_code[prov_name == "gipuzkoa"] = 20
  prov_code[prov_name == "girona"] = 17
  prov_code[prov_name == "granada"] = 18
  prov_code[prov_name == "guadalajara"] = 19
  prov_code[prov_name == "huelva"] = 21
  prov_code[prov_name == "huesca"] = 22
  prov_code[prov_name == "jaen"] = 23
  prov_code[prov_name == "la rioja"] = 26
  prov_code[prov_name == "las palmas"] = 35
  prov_code[prov_name == "leon"] = 24
  prov_code[prov_name == "lleida"] = 25
  prov_code[prov_name == "lugo"] = 27
  prov_code[prov_name == "madrid"] = 28
  prov_code[prov_name == "malaga"] = 29
  prov_code[prov_name == "melilla"] = 52
  prov_code[prov_name == "murcia"] = 30
  prov_code[prov_name == "navarra"] = 31
  prov_code[prov_name == "ourense"] = 32
  prov_code[prov_name == "palencia"] = 34
  prov_code[prov_name == "pontevedra"] = 36
  prov_code[prov_name == "salamanca"] = 37
  prov_code[prov_name == "santa cruz de tenerife"] = 38
  prov_code[prov_name == "segovia"] = 40
  prov_code[prov_name == "sevilla"] = 41
  prov_code[prov_name == "soria"] = 42
  prov_code[prov_name == "tarragona"] = 43
  prov_code[prov_name == "teruel"] = 44
  prov_code[prov_name == "toledo"] = 45
  prov_code[prov_name == "valencia"] = 46
  prov_code[prov_name == "valladolid"] = 47
  prov_code[prov_name == "zamora"] = 49
  prov_code[prov_name == "zaragoza"] = 50

  # Output
  prov_code = as.integer(prov_code)
  return(prov_code)

}
