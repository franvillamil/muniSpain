#' Changes a vector of municipality codes into new ones following territorial changes.
#'
#' Wrapper for changes_group function, directly changing a vector of municipality codes
#' to their correspoding new code following territorial changes.
#'
#' @param old_codes Character vector, to be converted into new codes.
#' @param y_start Integer, earliest year for which changes are considered. Default = 1857.
#' @param y_end Integer, latest year for which changes are considered. Default = 2011.
#' @param muni_output "First" (default) or "largest". If "first", the municipality
#'   with the first code will be chosen as the output for the whole group. If
#'   "largest", the municipality with highest population at y_end will be chosen.
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
#' @param recycle If TRUE, saves municipality groups to global workspace to use
#'   when the function is run again. Useful to cut computing times when transforming
#'   several datasets for the same period (Logical, default = FALSE).
#'
#'   *Note* recycle option saves an object called "muni_groups" to global workspace
#'   in R, and uses it in subsequent calls of the function. If dealing with different
#'   period transformation in the same R session, this option would lead to errors as
#'   no new municipality groups would be calculated.
#'
#' @importFrom stringr str_sub
#'
#' @return A character vector equivalent to the input.
#'
#' @examples
#'   # Bilbao, Zamudio & Derio & Zamudio Derio (Bizkaia)
#'   changes_newcode(c("48020", "48513", "48534", "48535"), 1930, 1970)
#'   changes_newcode(c("48020", "48513", "48534", "48535"), 1930, 1970, muni_output = "largest")
#'   changes_newcode(c("48020", "48513", "48534", "48535"), 1930, 1970, checks = TRUE)
#'
#'   # Tapia de Casariego & Castropol (Asturias)
#'   changes_newcode(c("33017", "33070"), 1860, 1900)
#'   changes_newcode(c("33017", "33070"), 1887, 1900)
#'   changes_newcode(c("33017", "33070"), 1860, 1900, muni_output = "largest")
#'   changes_newcode(c("33017", "33070"), 1860, 2001, muni_output = "largest")
#'
#' @export
changes_newcode = function(
  old_codes,
  y_start = 1857,
  y_end = 2011,
  muni_output = "first",
  partial_changes = FALSE,
  checks = FALSE,
  recycle = FALSE){

  # Checking inputs
  y_valid = c(1857, 1860, 1877, 1887, 1897, 1900, 1910, 1920,
    1930, 1940, 1950, 1960, 1970, 1981, 1991, 2001, 2011)
  if(!(y_start %in% y_valid & y_end %in% y_valid)){stop("Years must be valid census years")}

  # # Warning if 1857-1860 is included
  if(y_start %in% c(1857, 1860)){
    warning("Because of INE codes used for municipalities that disappeared in 1857 (prov code + 5000-5999), make sure codes are included as a character vector and first two digits follow the format '01', '02', '03', ... '10', '11'. Eg, '01001' and not '1001'. (Not doing automatic correction with sprintf as some codes are 6-digit long.)")
  } else {
    old_codes = sprintf("%05d", old_codes)
  }

  # * run changes_groups. if not there, save to workspace so dont have to call it again
  # Provinces in codes provided
  prov_incl = as.integer(unique(str_sub(old_codes, 1, 2)))
  prov_incl = unique(codelist$prov_name[codelist$prov %in% prov_incl])

  if(recycle == TRUE){
    # If an object called "muni_groups" exists in Global Environment, get it
    # Otherwise, run changes_groups and assign to GlobalEnv
    if ("muni_groups" %in% ls(envir = .GlobalEnv)) {
      print("Getting 'muni_groups' from GlobalEnv")
      get("muni_groups", envir = .GlobalEnv)
    } else {
      muni_groups = changes_groups(y_start = y_start, y_end = y_end, prov = prov_incl,
        partial_changes = partial_changes, checks = checks)
      assign("muni_groups", muni_groups, .GlobalEnv)
    }
  } else {
    muni_groups = changes_groups(y_start = y_start, y_end = y_end, prov = prov_incl,
      partial_changes = partial_changes, checks = checks)
  }

  # Order by population function
  pop_order = function(codevector){
    cp = census[census$muni_code %in% codevector, ] # subset
    cp = cp[match(codevector, cp$muni_code), paste0("c", y_end)] # order
    return(codevector[order(cp, decreasing=T)]) # return ordered
  }

  # Order muni_groups
  if(muni_output == "first"){
    muni_groups = str_split(muni_groups, ";")
    muni_groups = lapply(muni_groups, function(x) x[order(x)])
    muni_groups = sapply(muni_groups, function(x) paste(x, collapse = ";"))
  } else if (muni_output == "largest"){
    muni_groups = str_split(muni_groups, ";")
    muni_groups = lapply(muni_groups, function(x) pop_order(x))
    muni_groups = sapply(muni_groups, function(x) paste(x, collapse = ";"))
  } else {
    warning("muni_output must be 'largest' or 'first'")
  }

  # Transform to data frame for faster access
  changes_l = str_split(muni_groups, ";")
  changes_main = sapply(changes_l, function(x) x[1])
  changes = data.frame(
    input = unlist(changes_l),
    output = rep(changes_main, sapply(changes_l, function(x) length(x))),
    stringsAsFactors = FALSE)

  # Assign new codes
  new_codes = changes$output[match(old_codes, changes$input)]
  return(new_codes)

}
