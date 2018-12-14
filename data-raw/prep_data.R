setwd("~/Documents/Academic/PhD/Projects/Spain/data")
options(stringsAsFactors = FALSE)
library(stringr)
library(plyr)
load("function_adapt.RData")

p = c("alava", "albacete", "alicante", "almeria", "avila",
  "badajoz", "baleares", "barcelona", "burgos", "caceres",
  "cadiz", "castellon", "ciudad real", "cordoba", "a coruna",
  "cuenca", "girona", "granada", "guadalajara", "gipuzkoa",
  "huelva", "huesca", "jaen", "leon", "lleida",
  "la rioja", "lugo", "madrid", "malaga", "murcia",
  "navarra", "ourense", "asturias", "palencia", "las palmas",
  "pontevedra", "salamanca", "santa cruz de tenerife",
  "cantabria", "segovia", "sevilla", "soria", "tarragona",
  "teruel", "toledo", "valencia", "valladolid", "bizkaia",
  "zamora", "zaragoza", "ceuta", "melilla")

### --------------------------------------------------------
### Data on territorial changes

# Ruiz & Goerlich (2018)
rg = adapt( read.csv("municipios/ruiz_goerlich/ruiz_goerlich_cambios.csv",
  colClasses = c("character", "integer", "character", "character",
    "character", "character", "character", "character")) )

rg$prov = as.integer(str_sub(rg$codine, 1, 2))
rg$prov = p[rg$prov]

# Corrections
rg[rg$codine == "22026" & rg$codine2 == "22624", "tipo"] = "CF"
rg[rg$codine == "22026" & rg$codine2 == "22624", "descripcion"] =
  "Alto Sobrarbe <se crea por fusión, entre otros, de> Santa María de Buil"
rg[rg$codine == "465001" & rg$codine2 == "46220", "censo"] = 1857

# Keep municipality changes (exc name change)
var = subset(rg, tipo != "OD")

### --------------------------------------------------------
### Municipality name and code list

# Code list
codelist = read.csv("municipios/codelist.csv")
codelist = cbind(codelist, prov_name = p[codelist$prov])
codelist$muni_code = paste0(
  sprintf("%02.f", codelist$prov), sprintf("%03.f", codelist$muni))

# INE census
census = read.csv("census/INE_census.csv", colClasses =
  c("integer", "character", "character", "character", rep("integer", 18)))

# Different names for each code
od = subset(rg, tipo == "OD")[, c("codine", "descripcion")]
od$descripcion = gsub(" \\(\\d.*\\)$", "", od$descripcion)
od$descripcion = gsub(" <se denominaba> ", ";", od$descripcion)
od = ddply(od, .(codine), summarize,
  names = paste(descripcion, collapse = ";"))
od$names = sapply(str_split(od$names, ";"),
  function(x) paste(unique(x), collapse = ";"))

# Add names to codelist
codelist$names = od$names[match(codelist$muni_code, od$codine)]
codelist$names[is.na(codelist$names)] = census$muni_name[
  match(codelist$muni_code[is.na(codelist$names)], census$muni_code)]

### --------------------------------------------------------
### Save data

save(codelist, var, census, file = "municipios/muniSpain/R/sysdata.rda")
