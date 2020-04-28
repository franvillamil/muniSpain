#' Returns census names corresponding to municipality codes.
#'
#' @param code Municipality code. If using 6-digit municipalities, use character class.
#'
#' @return Character vector. NA if not found.
#'
#' @examples
#'   code_to_name(c(15005, 48020))
#'   code_to_name(c(35001))
#'   code_to_name(c(35001, "035001"))
#'
#' @export
code_to_name = function(code){

  names = census$muni_name[match(code, census$muni_code)]
  return(names)

}
