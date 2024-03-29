#' Adapt Spanish (and Catalan) encoding when using UTF8.
#'
#' Adapts Spanish encoding when using UTF8, deleting accents (tildes) and
#' turning ñ into n, ç into c, ü into u.
#'
#' @param data Character vector or data frame. If data frame, converts
#'   all columns of class character.
#' @param tolower If TRUE, returns lower-case. Logical, default = FALSE.
#'
#' @return Same object as input, adapted.
#'
#' @examples
#' adapt("Ñora")
#' adapt("Lledó", tolower = TRUE)
#'
#' @export
adapt = function(data, tolower = FALSE){

if (class(data) == "character"){

  data = gsub("\302\241", "", data, useBytes = TRUE)
  data = gsub("\302\252", "", data, useBytes = TRUE)
  data = gsub("\302\272", "", data, useBytes = TRUE)
  data = gsub("\302\277", "", data, useBytes = TRUE)
  data = gsub("\303\200", "A", data, useBytes = TRUE)
  data = gsub("\303\201", "A", data, useBytes = TRUE)
  data = gsub("\303\202", "A", data, useBytes = TRUE)
  data = gsub("\303\203", "A", data, useBytes = TRUE)
  data = gsub("\303\204", "A", data, useBytes = TRUE)
  data = gsub("\303\207", "C", data, useBytes = TRUE)
  data = gsub("\303\210", "E", data, useBytes = TRUE)
  data = gsub("\303\211", "E", data, useBytes = TRUE)
  data = gsub("\303\212", "E", data, useBytes = TRUE)
  data = gsub("\303\213", "E", data, useBytes = TRUE)
  data = gsub("\303\214", "I", data, useBytes = TRUE)
  data = gsub("\303\215", "I", data, useBytes = TRUE)
  data = gsub("\303\216", "I", data, useBytes = TRUE)
  data = gsub("\303\217", "I", data, useBytes = TRUE)
  data = gsub("\303\221", "N", data, useBytes = TRUE)
  data = gsub("\303\222", "O", data, useBytes = TRUE)
  data = gsub("\303\223", "O", data, useBytes = TRUE)
  data = gsub("\303\224", "O", data, useBytes = TRUE)
  data = gsub("\303\225", "O", data, useBytes = TRUE)
  data = gsub("\303\226", "O", data, useBytes = TRUE)
  data = gsub("\303\231", "U", data, useBytes = TRUE)
  data = gsub("\303\232", "U", data, useBytes = TRUE)
  data = gsub("\303\233", "U", data, useBytes = TRUE)
  data = gsub("\303\234", "U", data, useBytes = TRUE)
  data = gsub("\303\240", "a", data, useBytes = TRUE)
  data = gsub("\303\241", "a", data, useBytes = TRUE)
  data = gsub("\303\242", "a", data, useBytes = TRUE)
  data = gsub("\303\243", "a", data, useBytes = TRUE)
  data = gsub("\303\244", "a", data, useBytes = TRUE)
  data = gsub("\303\247", "c", data, useBytes = TRUE)
  data = gsub("\303\250", "e", data, useBytes = TRUE)
  data = gsub("\303\251", "e", data, useBytes = TRUE)
  data = gsub("\303\252", "e", data, useBytes = TRUE)
  data = gsub("\303\253", "e", data, useBytes = TRUE)
  data = gsub("\303\254", "i", data, useBytes = TRUE)
  data = gsub("\303\255", "i", data, useBytes = TRUE)
  data = gsub("\303\256", "i", data, useBytes = TRUE)
  data = gsub("\303\257", "i", data, useBytes = TRUE)
  data = gsub("\303\261", "n", data, useBytes = TRUE)
  data = gsub("\303\262", "o", data, useBytes = TRUE)
  data = gsub("\303\263", "o", data, useBytes = TRUE)
  data = gsub("\303\264", "o", data, useBytes = TRUE)
  data = gsub("\303\265", "o", data, useBytes = TRUE)
  data = gsub("\303\266", "o", data, useBytes = TRUE)
  data = gsub("\303\271", "u", data, useBytes = TRUE)
  data = gsub("\303\272", "u", data, useBytes = TRUE)
  data = gsub("\303\274", "u", data, useBytes = TRUE)
  # short Octal
  data = gsub("\241", "", data, useBytes = TRUE)
  data = gsub("\252", "", data, useBytes = TRUE)
  data = gsub("\272", "", data, useBytes = TRUE)
  data = gsub("\277", "", data, useBytes = TRUE)
  data = gsub("\300", "A", data, useBytes = TRUE)
  data = gsub("\301", "A", data, useBytes = TRUE)
  data = gsub("\302", "A", data, useBytes = TRUE)
  data = gsub("\303", "A", data, useBytes = TRUE)
  data = gsub("\304", "A", data, useBytes = TRUE)
  data = gsub("\307", "C", data, useBytes = TRUE)
  data = gsub("\310", "E", data, useBytes = TRUE)
  data = gsub("\311", "E", data, useBytes = TRUE)
  data = gsub("\312", "E", data, useBytes = TRUE)
  data = gsub("\313", "E", data, useBytes = TRUE)
  data = gsub("\314", "I", data, useBytes = TRUE)
  data = gsub("\315", "I", data, useBytes = TRUE)
  data = gsub("\316", "I", data, useBytes = TRUE)
  data = gsub("\317", "I", data, useBytes = TRUE)
  data = gsub("\321", "N", data, useBytes = TRUE)
  data = gsub("\322", "O", data, useBytes = TRUE)
  data = gsub("\323", "O", data, useBytes = TRUE)
  data = gsub("\324", "O", data, useBytes = TRUE)
  data = gsub("\325", "O", data, useBytes = TRUE)
  data = gsub("\326", "O", data, useBytes = TRUE)
  data = gsub("\331", "U", data, useBytes = TRUE)
  data = gsub("\332", "U", data, useBytes = TRUE)
  data = gsub("\333", "U", data, useBytes = TRUE)
  data = gsub("\334", "U", data, useBytes = TRUE)
  data = gsub("\340", "a", data, useBytes = TRUE)
  data = gsub("\341", "a", data, useBytes = TRUE)
  data = gsub("\342", "a", data, useBytes = TRUE)
  data = gsub("\343", "a", data, useBytes = TRUE)
  data = gsub("\344", "a", data, useBytes = TRUE)
  data = gsub("\347", "c", data, useBytes = TRUE)
  data = gsub("\350", "e", data, useBytes = TRUE)
  data = gsub("\351", "e", data, useBytes = TRUE)
  data = gsub("\352", "e", data, useBytes = TRUE)
  data = gsub("\353", "e", data, useBytes = TRUE)
  data = gsub("\354", "i", data, useBytes = TRUE)
  data = gsub("\355", "i", data, useBytes = TRUE)
  data = gsub("\356", "i", data, useBytes = TRUE)
  data = gsub("\357", "i", data, useBytes = TRUE)
  data = gsub("\361", "n", data, useBytes = TRUE)
  data = gsub("\362", "o", data, useBytes = TRUE)
  data = gsub("\363", "o", data, useBytes = TRUE)
  data = gsub("\364", "o", data, useBytes = TRUE)
  data = gsub("\365", "o", data, useBytes = TRUE)
  data = gsub("\366", "o", data, useBytes = TRUE)
  data = gsub("\371", "u", data, useBytes = TRUE)
  data = gsub("\372", "u", data, useBytes = TRUE)
  data = gsub("\374", "u", data, useBytes = TRUE)

  data = gsub("<U\\+00F1>", "n", data, useBytes = TRUE)
  data = gsub("<U\\+00F3>", "o", data, useBytes = TRUE)
  data = gsub("<U\\+00ED>", "i", data, useBytes = TRUE)
  data = gsub("<U\\+00E9>", "e", data, useBytes = TRUE)
  data = gsub("<U\\+00E1>", "a", data, useBytes = TRUE)
  data = gsub("<U\\+00FC>", "u", data, useBytes = TRUE)
  data = gsub("<U\\+00BF>", "?", data, useBytes = TRUE)
  data = gsub("<U\\+00FA>", "u", data, useBytes = TRUE)
  data = gsub("<U\\+00DA>", "U", data, useBytes = TRUE)

  data = gsub(" - ", "-", data, useBytes = TRUE)


  if(tolower == TRUE){ data = tolower(data) }
  return(data)

} else if (class(data) == "data.frame"){

  # get character variables
  vars = labels(which(lapply(data, class) == "character"))

  # for each variable, transform
  for (i in vars){
    # long Octal
    data[, i] = gsub("\302\241", "", data[, i], useBytes = TRUE)
    data[, i] = gsub("\302\252", "", data[, i], useBytes = TRUE)
    data[, i] = gsub("\302\272", "", data[, i], useBytes = TRUE)
    data[, i] = gsub("\302\277", "", data[, i], useBytes = TRUE)
    data[, i] = gsub("\303\200", "A", data[, i], useBytes = TRUE)
    data[, i] = gsub("\303\201", "A", data[, i], useBytes = TRUE)
    data[, i] = gsub("\303\202", "A", data[, i], useBytes = TRUE)
    data[, i] = gsub("\303\203", "A", data[, i], useBytes = TRUE)
    data[, i] = gsub("\303\204", "A", data[, i], useBytes = TRUE)
    data[, i] = gsub("\303\207", "C", data[, i], useBytes = TRUE)
    data[, i] = gsub("\303\210", "E", data[, i], useBytes = TRUE)
    data[, i] = gsub("\303\211", "E", data[, i], useBytes = TRUE)
    data[, i] = gsub("\303\212", "E", data[, i], useBytes = TRUE)
    data[, i] = gsub("\303\213", "E", data[, i], useBytes = TRUE)
    data[, i] = gsub("\303\214", "I", data[, i], useBytes = TRUE)
    data[, i] = gsub("\303\215", "I", data[, i], useBytes = TRUE)
    data[, i] = gsub("\303\216", "I", data[, i], useBytes = TRUE)
    data[, i] = gsub("\303\217", "I", data[, i], useBytes = TRUE)
    data[, i] = gsub("\303\221", "N", data[, i], useBytes = TRUE)
    data[, i] = gsub("\303\222", "O", data[, i], useBytes = TRUE)
    data[, i] = gsub("\303\223", "O", data[, i], useBytes = TRUE)
    data[, i] = gsub("\303\224", "O", data[, i], useBytes = TRUE)
    data[, i] = gsub("\303\225", "O", data[, i], useBytes = TRUE)
    data[, i] = gsub("\303\226", "O", data[, i], useBytes = TRUE)
    data[, i] = gsub("\303\231", "U", data[, i], useBytes = TRUE)
    data[, i] = gsub("\303\232", "U", data[, i], useBytes = TRUE)
    data[, i] = gsub("\303\233", "U", data[, i], useBytes = TRUE)
    data[, i] = gsub("\303\234", "U", data[, i], useBytes = TRUE)
    data[, i] = gsub("\303\240", "a", data[, i], useBytes = TRUE)
    data[, i] = gsub("\303\241", "a", data[, i], useBytes = TRUE)
    data[, i] = gsub("\303\242", "a", data[, i], useBytes = TRUE)
    data[, i] = gsub("\303\243", "a", data[, i], useBytes = TRUE)
    data[, i] = gsub("\303\244", "a", data[, i], useBytes = TRUE)
    data[, i] = gsub("\303\247", "c", data[, i], useBytes = TRUE)
    data[, i] = gsub("\303\250", "e", data[, i], useBytes = TRUE)
    data[, i] = gsub("\303\251", "e", data[, i], useBytes = TRUE)
    data[, i] = gsub("\303\252", "e", data[, i], useBytes = TRUE)
    data[, i] = gsub("\303\253", "e", data[, i], useBytes = TRUE)
    data[, i] = gsub("\303\254", "i", data[, i], useBytes = TRUE)
    data[, i] = gsub("\303\255", "i", data[, i], useBytes = TRUE)
    data[, i] = gsub("\303\256", "i", data[, i], useBytes = TRUE)
    data[, i] = gsub("\303\257", "i", data[, i], useBytes = TRUE)
    data[, i] = gsub("\303\261", "n", data[, i], useBytes = TRUE)
    data[, i] = gsub("\303\262", "o", data[, i], useBytes = TRUE)
    data[, i] = gsub("\303\263", "o", data[, i], useBytes = TRUE)
    data[, i] = gsub("\303\264", "o", data[, i], useBytes = TRUE)
    data[, i] = gsub("\303\265", "o", data[, i], useBytes = TRUE)
    data[, i] = gsub("\303\266", "o", data[, i], useBytes = TRUE)
    data[, i] = gsub("\303\271", "u", data[, i], useBytes = TRUE)
    data[, i] = gsub("\303\272", "u", data[, i], useBytes = TRUE)
    data[, i] = gsub("\303\274", "u", data[, i], useBytes = TRUE)
    # short Octal
    data[, i] = gsub("\241", "", data[, i], useBytes = TRUE)
    data[, i] = gsub("\252", "", data[, i], useBytes = TRUE)
    data[, i] = gsub("\272", "", data[, i], useBytes = TRUE)
    data[, i] = gsub("\277", "", data[, i], useBytes = TRUE)
    data[, i] = gsub("\300", "A", data[, i], useBytes = TRUE)
    data[, i] = gsub("\301", "A", data[, i], useBytes = TRUE)
    data[, i] = gsub("\302", "A", data[, i], useBytes = TRUE)
    data[, i] = gsub("\303", "A", data[, i], useBytes = TRUE)
    data[, i] = gsub("\304", "A", data[, i], useBytes = TRUE)
    data[, i] = gsub("\307", "C", data[, i], useBytes = TRUE)
    data[, i] = gsub("\310", "E", data[, i], useBytes = TRUE)
    data[, i] = gsub("\311", "E", data[, i], useBytes = TRUE)
    data[, i] = gsub("\312", "E", data[, i], useBytes = TRUE)
    data[, i] = gsub("\313", "E", data[, i], useBytes = TRUE)
    data[, i] = gsub("\314", "I", data[, i], useBytes = TRUE)
    data[, i] = gsub("\315", "I", data[, i], useBytes = TRUE)
    data[, i] = gsub("\316", "I", data[, i], useBytes = TRUE)
    data[, i] = gsub("\317", "I", data[, i], useBytes = TRUE)
    data[, i] = gsub("\321", "N", data[, i], useBytes = TRUE)
    data[, i] = gsub("\322", "O", data[, i], useBytes = TRUE)
    data[, i] = gsub("\323", "O", data[, i], useBytes = TRUE)
    data[, i] = gsub("\324", "O", data[, i], useBytes = TRUE)
    data[, i] = gsub("\325", "O", data[, i], useBytes = TRUE)
    data[, i] = gsub("\326", "O", data[, i], useBytes = TRUE)
    data[, i] = gsub("\331", "U", data[, i], useBytes = TRUE)
    data[, i] = gsub("\332", "U", data[, i], useBytes = TRUE)
    data[, i] = gsub("\333", "U", data[, i], useBytes = TRUE)
    data[, i] = gsub("\334", "U", data[, i], useBytes = TRUE)
    data[, i] = gsub("\340", "a", data[, i], useBytes = TRUE)
    data[, i] = gsub("\341", "a", data[, i], useBytes = TRUE)
    data[, i] = gsub("\342", "a", data[, i], useBytes = TRUE)
    data[, i] = gsub("\343", "a", data[, i], useBytes = TRUE)
    data[, i] = gsub("\344", "a", data[, i], useBytes = TRUE)
    data[, i] = gsub("\347", "c", data[, i], useBytes = TRUE)
    data[, i] = gsub("\350", "e", data[, i], useBytes = TRUE)
    data[, i] = gsub("\351", "e", data[, i], useBytes = TRUE)
    data[, i] = gsub("\352", "e", data[, i], useBytes = TRUE)
    data[, i] = gsub("\353", "e", data[, i], useBytes = TRUE)
    data[, i] = gsub("\354", "i", data[, i], useBytes = TRUE)
    data[, i] = gsub("\355", "i", data[, i], useBytes = TRUE)
    data[, i] = gsub("\356", "i", data[, i], useBytes = TRUE)
    data[, i] = gsub("\357", "i", data[, i], useBytes = TRUE)
    data[, i] = gsub("\361", "n", data[, i], useBytes = TRUE)
    data[, i] = gsub("\362", "o", data[, i], useBytes = TRUE)
    data[, i] = gsub("\363", "o", data[, i], useBytes = TRUE)
    data[, i] = gsub("\364", "o", data[, i], useBytes = TRUE)
    data[, i] = gsub("\365", "o", data[, i], useBytes = TRUE)
    data[, i] = gsub("\366", "o", data[, i], useBytes = TRUE)
    data[, i] = gsub("\371", "u", data[, i], useBytes = TRUE)
    data[, i] = gsub("\372", "u", data[, i], useBytes = TRUE)
    data[, i] = gsub("\374", "u", data[, i], useBytes = TRUE)

    data[, i] = gsub("<U\\+00F1>", "n", data[, i], useBytes = TRUE)
    data[, i] = gsub("<U\\+00F3>", "o", data[, i], useBytes = TRUE)
    data[, i] = gsub("<U\\+00ED>", "i", data[, i], useBytes = TRUE)
    data[, i] = gsub("<U\\+00E9>", "e", data[, i], useBytes = TRUE)
    data[, i] = gsub("<U\\+00E1>", "a", data[, i], useBytes = TRUE)
    data[, i] = gsub("<U\\+00FC>", "u", data[, i], useBytes = TRUE)
    data[, i] = gsub("<U\\+00BF>", "?", data[, i], useBytes = TRUE)
    data[, i] = gsub("<U\\+00FA>", "u", data[, i], useBytes = TRUE)
    data[, i] = gsub("<U\\+00DA>", "U", data[, i], useBytes = TRUE)

    data[, i] = gsub(" - ", "-", data[, i], useBytes = TRUE)

    if(tolower == TRUE){ data[, i] = tolower(data[, i]) }
  }

  return(data)

} else {stop("no character variable?")}

}
