library(tidyverse)
library(purrr)
library(tidyr)

#lendo os dados Open Data Sus
library(readr)
INFLUD_18_01_2021 <- read_csv2("data_sus/open_data_sus/INFLUD-18-01-2021.csv")

saveRDS(caso, file = "data_sus/open_data_sus/covid_srag_ods_18_01_2021.rds")

#Lendo dados do Brasil IO 
#Cada linha é numero de mortes em cada cidade
library(readr)
caso <- read_csv("data_sus/brasil_io/caso.csv")
caso_full <- read_csv("data_sus/brasil_io/caso_full.csv")
obito_cartorio <- read_csv("data_sus/brasil_io/obito_cartorio.csv")

saveRDS(caso, file = "data_sus/brasil_io/caso.rds")
saveRDS(caso_full, file = "data_sus/brasil_io/caso_full.rds")
saveRDS(obito_cartorio, file = "data_sus/brasil_io/obito_cartorio.rds")

#Filtratndo para MG

lista_mg <- map(.x= list(caso, obito_cartorio, caso_full), .f= ~filter(.x, state== "MG"))

caso_mg<-lista_mg[[1]]

obito_cartorio_mg<-lista_mg[[2]]%>%
  mutate(date= lubridate::ymd(date))

caso_full_mg<-lista_mg[[3]]%>%
  #criando numero de mortes por 100 mil hab
  mutate(last_available_deaths_100k_inhabitants= last_available_deaths*100000/estimated_population)


#DFs para o Flourish

casos_zona_da_mata_30mil<- caso_full_mg%>%
  filter(city_ibge_code %in% codigo_zm, estimated_population >30000)


a<- caso_full_mg%>%
  filter(city_ibge_code %in% codigo_zm, estimated_population >30000)%>%
  pivot_wider(names_from = city, values_from = last_available_confirmed_per_100k_inhabitants)

b<- caso_full_mg%>%
  filter(city_ibge_code %in% codigo_zm, estimated_population >30000)%>%
  pivot_wider(names_from = city, values_from = last_available_deaths_100k_inhabitants)

c<- caso_full_mg%>%
  filter(city_ibge_code %in% codigo_zm, estimated_population >30000)%>%
  pivot_wider(names_from = city, values_from = new_deaths)

d<- caso_full_mg%>%
  filter(city_ibge_code %in% codigo_zm, estimated_population >30000)%>%
  pivot_wider(names_from = city, values_from = new_confirmed)
              


writexl::write_xlsx(list(a,b,c,d), path= "data_sus/casos_zona_da_mata_30mil.xlsx")

### Graficos Linhas -  #fiz no flourish
#casos_zona_da_mata_30mil%>%
#  ggplot(aes(x=date, y= last_available_confirmed_per_100k_inhabitants, color=city))+ geom_line( aes(linetype= city)) +
 # labs(Title= "Casos por 100 mil hab na zona da Mata")


####Mapas ###

library(readxl)
Base_informacoes_setores2010_sinopse_MG <- read_excel("~/R2/eleicoes_jf/base_ibge/Base_informacoes_setores2010_sinopse_MG.xls")

base_ibge_mg <-  Base_informacoes_setores2010_sinopse_MG%>%
  select(Cod_setor:Nome_do_bairro)%>%
  filter(Nome_da_UF== "Minas Gerais")%>%
  group_by(Nome_da_meso, Cod_meso, Nome_da_micro, Cod_micro, Cod_municipio)%>%
  count(Nome_do_municipio)%>%
  rename("code_muni"= Cod_municipio)%>%
  mutate(code_muni= as.numeric(code_muni))



geoms_mg<- geobr::read_municipality(code_muni = "MG")%>%
    inner_join(base_ibge_mg, by= "code_muni")%>%
  st_simplify(dTolerance = 0.01)

ggplot() + geom_sf(data=geoms_mg , size= .15, 
                   show.legend = F) + geom_sf(data=geoms_mg, aes(fill= Nome_da_meso))
