# STATENT Tool

Shiny app for STATENT-Data.

Shiny app for STATENT Tool, created as a golem app.

The STATENT application on the [Website of Statistik Stadt Zürich](https://www.stadt-zuerich.ch/prd/de/index/statistik/themen/wirtschaft/unternehmen/bestand.html) shows the count of companies, employees (male & female) and full-time equivalents (male & female) in Zurich since 2011. It can be selected to display the results by area, sector, company size and/or legal form.

The data is obtained from the Open Data portal of the city of Zurich and is available [here](https://data.stadt-zuerich.ch/dataset/politik_abstimmungen_seit1933).

# Architecture

``` mermaid
flowchart LR;
  f1[F1 select area]:::filter --> button[button start]:::button
  f2[F2 select sector]:::filter --> button
  f3[F3 select size]:::filter --> button
  f4[F3 select legal]:::filter --> button
  button --> output1[(filtered data = \nF1 + F2 + F3 + F4)]:::data
  output1 --> results1[[Resultat Abfrage]]:::result
  results1 --> results2[["Resultat Abfrage \n(Result)"]]:::result
  results1 --> downloads{Downloads}:::download
  
  classDef filter fill:#ffff2f,stroke:#ffff2f;
  classDef button fill:#695eff,stroke:#695eff;
  classDef data fill:#edade6,stroke:#acb0b0;
  classDef result fill:#59e6f0,stroke:#acb0b0;
  classDef download fill:#43cc4c,stroke:#43cc4c;
```
