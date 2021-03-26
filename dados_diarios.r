##### Dados Covid DIÁRIOS
library(tidyverse)
library(tsibble)
library(slider)

#lendo os dados Open Data Sus
library(readr)
INFLUD_18_01_2021 <- read_csv2("data_sus/open_data_sus/INFLUD-18-01-2021.csv")

saveRDS(caso, file = "data_sus/open_data_sus/covid_srag_ods_18_01_2021.rds")



data_sus_jf_18_02 <- INFLUD_18_01_2021%>%
  filter(ID_MUN_RES== "JUIZ DE FORA")%>%
  


#Lendo dados do Brasil IO 
#Cada linha é numero de mortes em cada cidade
library(readr)
caso <- read_csv("data_sus/brasil_io/caso.csv")
caso_full <- read_csv("data_sus/brasil_io/caso_full.csv")
obito_cartorio <- read_csv("data_sus/brasil_io/obito_cartorio.csv")

saveRDS(caso, file = "data_sus/brasil_io/caso.rds")
saveRDS(caso_full, file = "data_sus/brasil_io/caso_full.rds")
saveRDS(obito_cartorio, file = "data_sus/brasil_io/obito_cartorio.rds")


caso_full_jf<-caso_full%>%
  filter(city_ibge_code== 3136702)%>%
  tsibble::as_tsibble(index=date)%>%
  mutate(media_movel_mortes_7dias= slider::slide_index_dbl(.i = date,
                                                     .x = new_deaths,
                                                     .f = mean,
                                                     .before = 6),
         media_movel_mortes_14dias = slider::slide_index_dbl(.i = date,
                                                     .x = new_deaths,
                                                     .f = mean,
                                                     .before = 13))
  

caso_full_jf%>%
  ggplot(aes(x=date, y=new_deaths)) +geom_col() +
  geom_line(aes(x=date, y= media_movel_mortes_7dias), 
            color= "red", show.legend = TRUE, size= 1.5) +
  labs(title = "Nº Diário de Mortes em Juiz de Fora -  A LINHA VEREMELHA É MEDIA MÓVEL NOS ULTIMOS 7 DIAS",
       subtitle = "Última atualização em 25/03/2021",
       caption= "Fonte: Secretaria de Saúde Estadual - Tratamento dos Dados: Brasil IO - Elaboração do Gráfico: JF em Dados")+
  theme_classic()