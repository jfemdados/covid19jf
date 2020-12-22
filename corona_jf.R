library(tidyverse)
library(geobr)
library(sf)

##mapa geobr

juiz_de_fora <- geobr::read_municipality(code_muni = 3136702)
juiz_de_fora_zonas <- geobr::read_census_tract(code_tract  = 3136702, year = 2000 )

juiz_de_fora_zonas_urbanas <- geobr::read_census_tract(code_tract  = 3136702, year = 2000, zone = "urban" )
juiz_de_fora_zonas_rurais <- geobr::read_census_tract(code_tract  = 3136702, year = 2000, zone = "rural" )

ggplot() +geom_sf(data= juiz_de_fora_zonas_urbanas, fill= "steelblue4", color= "#FEBF57", size= .15, show.legend = F)

#grupamento de bairros IBGE

library(readxl)
Base_informacoes_setores2010_sinopse_MG <- read_excel("base_ibge/Base_informacoes_setores2010_sinopse_MG.xls")

base_ibge<-Base_informacoes_setores2010_sinopse_MG%>%
  select(Cod_setor, Cod_municipio:Nome_do_bairro)

base_ibge_jf<- base_ibge%>%
  filter(Nome_do_municipio== "JUIZ DE FORA")%>%
  rename(code_tract= Cod_setor)

#juntando geobr X IBGE com inner_join 

juiz_de_fora_agregado <- inner_join(juiz_de_fora_zonas, base_ibge_jf, by= "code_tract")

#base de Dados covid
corona <- read.delim(file = "casos_corona2.txt", sep= ";",header = FALSE)%>%
  rename("Nome_do_bairro"= "V1", "Casos"= "V2")%>%
  mutate(across(Nome_do_bairro,~iconv(.x,"UTF-8","Latin1")))

#Cruzando covid com mapas pelo Dados com inner_join

corona_por_bairro <- full_join(juiz_de_fora_bairros, corona, by= "Nome_do_bairro")

grafico_inner_join <- corona_por_bairro%>%
  ggplot() + geom_sf(data= corona_por_bairro , size= .15, 
                     show.legend = F) + geom_sf(aes(fill= Casos))  +
  scale_fill_gradient (low = "darkolivegreen1", high = "darkolivegreen") +
  labs(title =  "Casos de Covid-19 em Juiz de Fora", subtitle = "Divididos por Bairros", caption = "Fonte: Prefeitura de Juiz de Fora e @Ocorrências JF \n Elaborado por: Marcello Filgueiras") +
  theme_void()
 grafico_inner_join
 
## Deu alguns problemas como perder algumas áreas no mapa, tentei pelo full_join


#Cruzando geobr e ibge com full_join

juiz_de_fora_agregado2 <- full_join(juiz_de_fora_zonas, base_ibge_jf, by= "code_tract")

juiz_de_fora_bairros2<- juiz_de_fora_agregado2%>%
  group_by(Nome_do_bairro)%>%
  summarize()%>%
  st_simplify(dTolerance = 0.0007)

ggplot() +geom_sf(data= juiz_de_fora_bairros2, fill= "steelblue4", color= "#FEBF57", size= .15, show.legend = F)


#cruazando mapas com corona com full_join 

corona_por_bairro2 <- full_join(juiz_de_fora_bairros2, corona, by= "Nome_do_bairro")

corona_por_bairro2%>%
  ggplot() + geom_sf(data= corona_por_bairro2 , size= .15, 
                     show.legend = F) + geom_sf(aes(fill= Casos))  +
  scale_fill_gradient (low = "darkolivegreen1", high = "darkolivegreen") +
  labs(title =  "Casos de Covid-19 em Juiz de Fora", subtitle = "Divididos por Bairros",
       caption = "Fonte: Prefeitura de Juiz de Fora e @Ocorrências JF \n Elaborado por: Marcello Filgueiras") +
  theme_void()


