library(tidyverse)
library(purrr)
library(tidyr)

#lendo os dados Open Data Sus
library(readr)
INFLUD_18_01_2021 <- read_csv2("data_sus/open_data_sus/INFLUD-18-01-2021.csv")

ods_srag_18_01_2021<- INFLUD_18_01_2021

character_types<- replicate(154,"c")%>%
  str_c()


ods_srag_29_03_2021 <- read_csv2("data_sus/open_data_sus/INFLUD-29-03-2021.csv")%>%
  rename("codigo_municipio_do_paciente"= CO_MUN_RES , "nome_municipio_do_paciente"= ID_MN_RESI )



ods_srag_29_03_2021_JF<- ods_srag_29_03_2021%>%
  filter(codigo_municipio_do_paciente == 313670)




  filter(nome_municipio_do_paciente == "JUIZ DE FORA")