muniSpain
=========

This is an R package to deal with territorial changes in Spanish municipalities when working with historical local-level data from different periods.
It relies on the municipality codes from the [*Instituto Nacional de Estadística* (INE)](http://ine.es/) and the list of municipality changes compiled and corrected by Francisco J. Goerlich and Francisco Ruiz (see [Goerlich and Ruiz 2018](https://doi.org/10.1515/jos-2018-0005), and below for more information).
The package also allows converting municipality names (including old and multi-language denominations) to INE codes.

*Note:* A separate repository [(link)](https://github.com/franvillamil/scrap-INE-census) shows the R code used to scrap the INE census for all municipalities using [`rvest`](https://github.com/hadley/rvest).

`muniSpain` is currently in progress. In particular, partial changes in municipalities (such as when two municipalities exchange a small part of their territory or a municipality splits and these parts are integrated in different municipalities) are still not implemented.
Moreover, it will include further resources to deal with different historical territorial units and analyze different datasets.

**Pending**:

* Add alternative municipality names from [GADM](https://gadm.org/) for `name_to_code()`.
* Returning municipality codes in character vector is useful when working with pre-1860 datasets, but it can cause unnecessary problems otherwise because of incompatibilities with interger variables (e.g. "02001", 02001). Solve this, accounting for the periods being used and add warning messages when needed.
* Design some procedure to deal with partial changes? Not easy with municipality-level data. Default: remove.
* In `name_to_code()`, make it possible to give only one province (chr vector of length 1) for a full vector of municipality names.

## Installation

To install `muniSpain` from Github run:

```
# install.packages("devtools")
devtools::install_github("franvillamil/muniSpain")
```

## Usage and logic

### Municipality changes

The strategy to deal with territorial changes in municipalities is that of ensuring that local-level datasets at any point in time during the period of interest can be aggregated together. This means that if municipalities A and B were at some point merged into a larger municipality Z, they will be merged for the whole period. Similarly, if D gained independence from C, the two municipalities will also be merged for the whole period.

A further problem are partial changes in municipalities, such as when two municipalities exchange a small part of their territory or a municipality splits and these parts are integrated in different municipalities. This is still not taken into account in this version. See below for the strategy used by Francisco J. Goerlich and Francisco Ruiz ([Goerlich and Ruiz 2018](https://doi.org/10.1515/jos-2018-0005)) to build homogenous series of population data for Spain. Unfortunately, this strategy depends on the availability of data at smaller levels of aggregation than the municipality, which is not always the case.

The main function in this package is the following:

`changes_newcode(old_codes, y_start, y_end, ...)`

This function takes a character vector of municipality codes (`old_codes`) and returns a vector of the same length with the equivalent codes, depending on the period chosen. `y_start`  and `y_end` must correspond with valid census years, so if working with datasets that extend between 1936 and 1965, select 1930 and 1970. By default, it covers the entire period (1857-2011). In addition, it has a number of additional arguments:

  * `muni_output` takes "first" (default) or "largest". When grouping together several municipalities, they will all take the code of the first one (as in the smallest number) or the one that had the largest population at `y_end`.
  * `partial_changes` (default = FALSE) this option is still not available.
  * `checks` (default = FALSE) for checking the output for duplicates or missing municipalities (increases running time).
  * `recycle` (default = FALSE) When transforming municipality codes across many datasets using the same period, this option cuts down computing time by generating the correspondence matrix only once. Do not use it if different periods are used in the same R session.

The function `changes_newcode` is actually a wrapper for the function `changes_groups(y_start, y_end, ...)` which takes the period and, optionally, a set of provinces, and returns the correspondence matrix: a character vector grouping together all municipalities that were once merged, separated in each string by ';'.

**Examples**

``` r
## Tapia de Casariego (33070, Asturias) segregated from
## Castropol (33017) in 1863, between 1860 and 1877 censuses

changes_newcode(c("33017", "33070"), 1900, 2001)
#> [1] "33017" "33070"

changes_newcode(c("33017", "33070"), 1860, 2001)
#>[1] "33017" "33017"

changes_newcode(c("33017", "33070"), 1860, 2001,
  muni_output = "largest")
#> [1] "33070" "33070"

changes_newcode(c("33017", "33070"), 1860, 2001,
  muni_output = "largest", checks = TRUE)
#> [1] "Checked: All municipalities included"
#> [1] "Checked: No duplicated municipalities"
#> [1] "33070" "33070"
```

``` r
## Correspondence matrix for Bizkaia, 1930-1970

bizkaia_changes = changes_groups(1930, 1970,
  prov = "bizkaia", checks = TRUE)
#> [1] "Checked: All municipalities included"
#> [1] "Checked: No duplicated municipalities"

head(bizkaia_changes)
#> [1] "48001" "48002" "48004" "48005" "48006" "48007"

tail(bizkaia_changes)
#> [1] "48091;48504;48506;48508"
#> [2] "48511;48060;48524;48527"
#> [3] "48523;48520;48067"
#> [4] "48530;48529;48518;48512;48507;48501;48046"
#> [5] "48532;48525;48535;48513;48534;48516;48514;48510;48020"
#> [6] "48536;48009"
```

``` r
## Using the `recycle' option in changes_newcode()

ls()
#> character(0)

# Saves correspondence matrix for the whole province
changes_newcode(c("48020", "48513", "48534", "48535"),
  1920, 1970, recycle = TRUE)
#> [1] "48020" "48020" "48020" "48020"

ls()
#> [1] "muni_groups"

# Equivalent to the one generated with changes_groups()
changes_bizkaia_20_70 = changes_groups(1920, 1970,
  prov = "bizkaia")
identical(muni_groups, changes_bizkaia_20_70)
#> [1] TRUE

```

_Note:_
Is better to introduce municipality codes as a character vector, and those where the province code is between 1 and 9 should be in the form '01001', '01002', etc. This is because municipality codes are formed with the code of the province (01-52) and the municipality coded (usually 1-999). However, in a far-from-optimal decision, INE decided to assign the codes 5000-5999 to those municipalities that disappeared between 1842 and 1857. This means that two municipalities might share a code number when using integer numbers, such as is the case of "035001" (Pueblo Nuevo de San Rafael, in Alicante) and "35001" (Agaete, in Las Palmas). If using these census (1860 or earlier), the function will give a warning message reminding of this.

### Municipality codes

In addition, the `name_to_code()` function translates municipality names into INE codes. It takes two arguments, a string or character vector `muni` with the municipality names and, optionally, a vector of the same length `prov` (default = NULL) specifying the province. If no province is entered but two municipalities with the same name are found, the function will return an error and ask for the province.

In a few cases, a same municipality name within the same province applies to two different codes. Usually, this is because a municipality changed name and code in the past and then went back to the old denomination (e.g. Biel in Zaragoza), or because two different municipalities shared a name in the past. In those cases, `name_to_code()` selects the largest code (usually the last one created) and prints a warning. Manual checking might be desiderable in these cases.

``` r
name_to_code("Oviedo")
#> [1] "33044"
name_to_code("Mieres")
#> Error in name_to_code("Mieres") :
#>   Duplicates found - please specify provinces
name_to_code("Mieres", prov = "Asturias")
#> [1] "33037"
name_to_code("Mieres", prov = "Girona")
#> [1] "17105"

name_to_code(c("Oviedo", "Mieres"))
#> Error in name_to_code(c("Oviedo", "Mieres")) :
#>   Duplicates found - please specify provinces
name_to_code(c("Oviedo", "Mieres"), rep("Asturias", 2))
#> [1] "33044" "33037"
name_to_code(c("Mieres", "Mieres"), c("Asturias", "Girona"))
#> [1] "33037" "17105"
```

## Information and sources

The original information on territorial changes comes from INE. In the census website, INE lists all changes that each municipality experienced since 1842, including name changes (the [script that scraps the census data from INE](https://github.com/franvillamil/scrap-INE-census) also downloads this information). However, it contains errors and inconsistencies. Francisco J. Goerlich and Francisco Ruiz compiled this information and detected and corrected some mistakes, developing typology of boundary changes in territorial units, as part of a project to develop homogenous population series for Spain. More information can be found in:

* [Goerlich, Francisco and Francisco Ruiz (2018)](https://content.sciendo.com/view/journals/jos/34/1/article-p83.xml) Typology and Representation of Alterations in Territorial Units: A Proposal. _Journal of Official Statistics_ 34(1): 83-106.

For more information about the project to develop homogenous series of population data, breaking down municipalities and using data from sub-local units, see:

* [Goerlich, Francisco and Matilde Mas (dirs.) (2006)](https://www.fbbva.es/wp-content/uploads/2017/05/dat/DE_2006_IVIE_localizacion_poblacion_espanola.pdf) La localización de la población española sobre el territorio: Un siglo de cambios. Bilbao: Fundación BBVA.

### Implementing municipality changes

This version of `muniSpain` only takes into account full territorial changes. In other words, it implements changes that involved the creation and extinction of municipalities because of merges, splits, and integrations. The strategy to deal with these changes is to come up with a 'minimum list' of municipalities, This strategy allows any local-level data collected at any point in time during the period considered to be effectively merged with other datasets. Thus, for instance, if a municipality splits to form two new ones, they are considered as merged durign the whole period. This logic also extends to double- or even triple-level changes, when a spin-off municipality later splits itself.

Some quality datasets such as census data or even section-level electoral data would in theory allow for a finer aggregation using sub-local units, without having to group together municipalities. However, this is not possible in most cases.

Partial changes are a bit more complicated, and they will be included in a future version of the package, giving different options regarding how to include them.

### Names and codes

At the moment, the database includes all official names from INE, which includes those in different languages (e.g. Puente Nuevo, A Pontenova) and previous denominations (e.g. Casas Viejas, Casavieja). This is work in progress and will soon include more denominations for each municipality, particularly with regards to spelling differences and multi-word names (e.g. 'El Franco', 'Franco, El', 'Franco (El)') which sometimes appear differently.
