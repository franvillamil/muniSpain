muniSpain
=========

This is a R package to deal with territorial changes in Spanish municipalities when working with historical local-level data from different periods.
It relies on the municipality codes from the [*Instituto Nacional de Estadística* (INE)](http://ine.es/) and the list of municipality changes compiled and corrected by Francisco J. Goerlich and Francisco Ruiz (see [Goerlich and Ruiz 2018](https://doi.org/10.1515/jos-2018-0005), and below for more information).
The package also allows converting municipality names (including old and multi-language denominations) to INE codes.

*Note:* A separate repository shows the R code used to scrap the INE census for all municipalities using [`rvest`](https://github.com/hadley/rvest).

`muniSpain` is currently in progress. In particular, partial changes in municipalities (such as when two municipalities exchange a small part of their territory or a municipality splits and these parts are integrated in different municipalities) are still not implemented.
Moreover, it will include further resources to deal with different historical territorial units and analyze different datasets.

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

This function takes a character vector of municipality codes (`old_codes`) and returns a vector of the same length with the equivalent codes, depending on the period chosen. `y_start`  and `y_end` must correspond with valid census years, so if working with datasets that extend between 1936 and 1965, select 1930 and 1970. In addition, it has a number of additional arguments:

  * `muni_output` takes "first" (default) or "largest". When grouping together several municipalities, they will all take the code of the first one (as in the smallest number) or the one that had the largest population at `y_end`.
  * `partial_changes` (default = FALSE) this option is still not available.
  * `checks` (default = FALSE) for checking the output for duplicates or missing municipalities (increases running time).
  * `recycle` (default = FALSE) When transforming municipality codes across many datasets using the same period, this option cuts down computing time by generating the correspondence matrix only once. Do not use it if different periods are used in the same R session.

The function `changes_newcode` is actually a wrapper for the function `changes_groups(y_start, y_end, ...)` which takes the period and, optionally, a set of provinces, and returns the correspondence matrix: a character vector grouping together all municipalities that were once merged, separated in each string by ';'.


_Note:_
Is better to introduce municipality codes as a character vector, and those where the province code is between 1 and 9 should be in the form '01001', '01002', etc. This is because municipality codes are formed with the code of the province (01-52) and the municipality coded (usually 1-999). However, in a far-from-optimal decision, INE decided to assign the codes 5000-5999 to those municipalities that disappeared between 1842 and 1857. This means that two municipalities might share a code number when using integer numbers, such as is the case of "035001" (Pueblo Nuevo de San Rafael, in Alicante) and "35001" (Agaete, in Las Palmas).

### Municipality codes

In addition, the `name_to_code()` function

args: `muni` and `prov` (default = NULL)

## Information and sources

### Implementing municipality changes

### Names and codes
