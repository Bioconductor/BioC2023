
# Bioconductor conference 2023 website

Website: https://bioc2023.bioconductor.org/

This repository contains material for the Bioconductor annual conference. 
View <!--the example at https://bioc2022.bioconductor.org/ and--> the corresponding
[GitHub repo](https://github.com/Bioconductor/BioC2023). Created using [BioC_template](https://github.com/Bioconductor/BioC_template).

Run Hugo to preview the webpage locally.

```shell
rm -rf public; hugo --verbose; hugo server --disableFastRender --verbose
```

# Schedule generation

- Prepare the [schedule table spreadsheet](https://docs.google.com/spreadsheets/d/1tGtGffcbCRxQFjE3ej42IcWlN4FJCsuQeZvETt9g0oA/edit#gid=0) by copying information from the [tentative schedule](https://docs.google.com/spreadsheets/d/1AzVXX7EcCFtMcmbHv0-uywxPhWhQ_cmE3qZ8obAnw4M/edit#gid=243910517) and the [Openreview reviews](https://docs.google.com/spreadsheets/d/1CumaWFvf0cEBuXfkPR0h6PZRkAg1HHyXxfe_9UC9sCA/edit#gid=0) spreadsheet.
    - Each line describes either single event (Keynote, workshop, etc.) or multiple events (Short talks track).
        - Data for multiple event entries is stored at the end of the spreadsheet (Note: the format may change, [Issue 17](https://github.com/Bioconductor/BioC2023/issues/17))
    - For the "time" column, set the format to custom "hh:mm" (IMPORTANT)
    - Avoid using special characters, especially, "/"

- Check [1_create_yaml.R](https://github.com/Bioconductor/BioC2023/blob/179d85cdf70bca765746af736cb6b6ea07b1635d/1_create_yaml.R#L13) for the correct `sheet=XYZ` sheet from he [schedule table spreadsheet](https://docs.google.com/spreadsheets/d/1tGtGffcbCRxQFjE3ej42IcWlN4FJCsuQeZvETt9g0oA/edit#gid=0)

- Run the following command in the terminal in the base directory:

```bash
Rscript --vanilla 1_create_yaml.R; bash 2_create_abstracts.sh; bash 3_create_tracks.sh
```

### Manually adding data for the schedule

- Note: not needed if the schedule was automatically generated from the [schedule table spreadsheet](https://docs.google.com/spreadsheets/d/1tGtGffcbCRxQFjE3ej42IcWlN4FJCsuQeZvETt9g0oA/edit#gid=0) using the steps above.

+ Data for the abstracts and other elements for the schedule table should be located in `data/abstracts/`. This folder is populated by `1_create_yaml.R` from the "schedule table" spreadsheet.

There are three types of abstracts.

1. papers. Name format: day1_1315_longWorkshop_paper25.yaml. 
2. tracks. Name format: day1_0900_shortTalksSysEpi_track.yaml.
3. All other elements that will be added to the schedule.

Abstract file name format: day[1-3]_HHMM_type_paper/track#.yaml. 
The abstracts should all contain these fields. If any field isn't used, it should remain blank. 

```
title: "" # A string with the full title.
paper: "" # Number of paper or track. Valid options: paper# or track#. For example, paper2, track1, etc. track is only used for the short talks tracks. There is no defined track number as in the case of the papers, they should be added in order of appearance in the document.
session_type: "" # String with the type. Valid options: "Short talk", "Short talks track", "Package demo", "Workshop".
authors: "" # String with the authors separated by comma.
presenting_author: "" # Author who will present. The first author by default.
affiliation: "" # String with the affiliation.
abstract: "" # String with the abstract. Sometimes there are quotes in the text which should be escaped.
time: "" # The time in 24h format. Example: 1300 for 1 PM.
github: "" # Haven't used this field. Not sure if this has been provided.
twitter: "" # Twitter handle without the @.
youtube: "" # Link to youtube video when available.
day: "" # Valid options: day1, day2, day3.
talks: "" # This field is only for the short talk tracks. This should list the number of papers under this track. This should be a YAML array. Example: ["paper10", "paper20"]
```

+ The `content/abstracts/` directory contains the individual pages for the
abstracts. This directory could be ignored as it will be updated with
the `2_create_abstracts.sh` and `3_create_tracks.sh` bash scripts. These scripts
convert the elements in data to content pages.

======

# data

YAML files that need to be adjusted for each conference. 

## abstracts

YAML files for every event. `Workshop_paper` are processed by [content/workshops.md](content/workshops.md) and [layouts/shortcodes/workshops.html](layouts/shortcodes/workshops.html). All events are processed by [layouts/shortcodes/schedule.html](layouts/shortcodes/schedule.html).

## carousel

YAML files for the carousel panels. Processed by the main theme.

## clients

YAML files for sponsors. Processed by the main theme and [layouts/shortcodes/sponsors.html](layouts/shortcodes/sponsors.html)

## organizers

YAML files for co-chairs and committee. Processed by [content/organizers.md](content/organizers.md), [layouts/shortcodes/cochairs.html](layouts/shortcodes/cochairs.html) and [layouts/shortcodes/committee.html](layouts/shortcodes/committee.html).

## speakers

YAML files for each speaker. Processed by [layouts/partials/speakers.html](layouts/partials/speakers.html).

# Disclaimer

This template was created using the modified 
[hugo-universal-theme](https://github.com/devcows/hugo-universal-theme).
See the [demo web site](https://themes.gohugo.io/theme/hugo-universal-theme/),
the original [github repository](https://github.com/devcows/hugo-universal-theme)
and the [exampleSite files](https://github.com/devcows/hugo-universal-theme/tree/master/exampleSite).
Template by [Bootstrapious](https://bootstrapious.com/p/universal-business-e-commerce-template).
Ported to Hugo by [DevCows](https://github.com/devcows/hugo-universal-theme).
The theme is added as selected files, not as a submodule, for easier modification.

