#' Group together municipalities that were once merged.
#'
#' @param y_start Integer, earliest year for which changes are considered
#' @param y_end Integer, latest year for which changes are considered
#' @param prov If a list of provinces is specified, only municipalities in
#'   those provinces are returned (Character vector, detault = NULL).
#'   If NULL, all provinces are included.
#'
#'   Accepts official names, case-insentitive: Alava, Albacete, Alicante,
#'   Almeria, Avila, Badajoz, Baleares, Barcelona, Burgos, Caceres, Cadiz,
#'   Castellon, Ceuta, Ciudad Real, Cordoba, A Coruna, Cuenca, Girona,
#'   Granada, Guadalajara, Gipuzkoa, Huelva, Huesca, Jaen, Leon, Lleida,
#'   La Rioja, Lugo, Madrid, Malaga, Melilla, Murcia, Navarra, Ourense,
#'   Asturias, Palencia, Las Palmas, Pontevedra, Salamanca,
#'   Santa Cruz de Tenerife, Cantabria, Segovia, Sevilla, Soria, Tarragona,
#'   Teruel, Toledo, Valencia, Valladolid, Bizkaia, Zamora, Zaragoza.
#' @param partial_changes (*In progress*) If TRUE, all municipalities that suffered
#'   partial changes will also be merged (Logical, default = FALSE).
#'
#'   Partial changes refers to those cases where only a part of a municipality
#'   is affected, either because it gets transfered to another municipality or
#'   because a whole municipality splits and its territories become part of
#'   different municipalities.
#' @param checks If TRUE, checks whether output includes all municipalities
#'   and no municipality is included in two groups (Logical, default = FALSE).
#'   *Note:* this option increases running time considerably.
#'
#' @importFrom stringr str_split
#'
#' @return A character vector with the municipality codes group together in
#'   each string, separated by ';'.
#'
#' @examples
#' ch_euk = changes_groups(1930, 1970,
#'   prov = c("gipuzkoa", "alava", "bizkaia"), checks = TRUE)
#' head(ch_euk)
#' tail(ch_euk)
#'
#' @export
changes_groups = function(
  y_start,
  y_end,
  prov = NULL,
  partial_changes = FALSE,
  checks = FALSE){

  # Checking inputs
  y_valid = c(1857, 1860, 1877, 1887, 1897, 1900, 1910, 1920,
    1930, 1940, 1950, 1960, 1970, 1981, 1991, 2001, 2011)
  if(!(y_start %in% y_valid & y_end %in% y_valid)){stop("Years must be valid census years")}

  # Partial changes options not yet available
  if(partial_changes){stop("Partial changes option not yet available")}

  # Limit to selected provinces
  if(!is.null(prov)){
    if(!all(tolower(prov) %in% codelist$prov_name)){
      stop("Province names not valid - misspelled?")
    } else {
      var_own = var[var$prov %in% prov, ]
      codelist_own = codelist[codelist$prov_name %in% prov, ]
    }
  } else {
    var_own = var
    codelist_own = codelist
  }

  # Baseline and index of originals
  base = codelist_own$muni_code
  index = base
  delete = NULL

  # Pattern to look for code
  ptt = function(code){
    return(paste0("(^|;)", code, "(;|$)"))
  }

  # Years included
  years_censo = unique(var_own$censo)
  years_censo = years_censo[years_censo >= y_start & years_censo<= y_end]
  years_censo = years_censo[2:length(years_censo)]

  # Looping through census years
  for(i in years_censo){

    svar = subset(var_own, tipo %in% c("CD", "CS", "EI", "CF", "CC") & censo == i)
    if(nrow(svar) > 0){
      for(i in 1:nrow(svar)){
        m1 = svar$codine[i]
        m2 = svar$codine2[i]
        # Find them in base
        m1_i = which(grepl(ptt(m1), base))
        m2_i = which(grepl(ptt(m2), base))
        # Check (WHAT?)
        # Merge
        new = paste(base[m1_i], base[m2_i], sep = ";")
        # Add and delete
        base = c(base, new)
        base = base[-c(m1_i, m2_i)]
      }
    }

  }

  # Removing duplicates
  base = str_split(base, ";")
  base = lapply(base, function(x) x = paste(unique(x[x != ""]), collapse = ";"))
  base = unlist(base)

  ## Remove municipalities not relevant for the period
  # Get relevant census period
  census_cols = y_valid[y_valid >= y_start & y_valid <= y_end]
  census_cols = paste0("c", census_cols)
  if(!all(census_cols %in% names(census))){
    stop("Some years not included in census? (Error: When removing municipalities not relevant)")}
  census_incl = subset(census, prov_name %in% prov,
    select = c("muni_code", census_cols))
  # Remove municipalities without population during these years
  census_incl = census_incl[rowSums(is.na(census_incl)) < length(census_cols),]
  # Remove these municipalities from single-row output
  singletons = base[!grepl(";", base)]
  to_exclude = singletons[!singletons %in% census_incl$muni_code]
  base = base[!base %in% to_exclude]
  # NOTE (20/02/2020): Some municipalities are present but actually didn't exist at
  # the end of the period (e.g. 22636). This is due because I'm currently excluding
  # 'partial multisplits,' which in any case are mostly due to population loss.
  # REMOVING THIS AS WELL: (not many, e.g. 8 in Huesca)
  weirdos = singletons[singletons %in%
    census_incl$muni_code[is.na(census_incl[,census_cols[length(census_cols)]])]]
  base = base[!base %in% weirdos]

  # Checks
  if(checks == TRUE){
    base_raw = paste0(sprintf("%02.f", codelist_own$prov),
      sprintf("%03.f", codelist_own$muni))
    n_appear = sapply(base_raw, function(x)
      length(base[grepl(paste0("(^|;)", x, "(;|$)"), base)]))
    if(any(n_appear) == 0){
      warning("Warning: Some municipalities missing")
    } else {print("Checked: All municipalities included")}
    if(any(n_appear) == 2){
      warning("Warning: Municipalities duplicated")
    } else {print("Checked: No duplicated municipalities")}
  }


  # Returning
  return(base)

}
