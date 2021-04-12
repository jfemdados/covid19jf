##### Dados Covid DIÁRIOS  - Fonte Brasil Io
# Autor: Marcello Filgueiras
library(tidyverse)
library(tsibble)
library(slider)

#Importação -----------------------------------------

library(readr)
#Dados do Brasil IO
#Cada linha é numero agregado de mortes em uma cidade em uma data

#caso <- read_csv("data_sus/brasil_io/caso.csv")
caso_full <- read_csv("data_sus/brasil_io/caso_full.csv")
#obito_cartorio <- read_csv("data_sus/brasil_io/obito_cartorio.csv")


#Tidyng ---------------------------------------------


#Filtros e Classificações ---------------------------


#Modelagem -------------------------------------------

caso_full_jf_raw<-caso_full%>%
  filter(city_ibge_code== 3136702)

caso_full_jf<-caso_full_raw%>%
  filter(city_ibge_code== 3136702)%>%
  tsibble::as_tsibble(index=date)%>%
  mutate(media_movel_mortes_7dias= slider::slide_index_dbl(.i = date,
                                                           .x = new_deaths,
                                                           .f = mean,
                                                           .before = 6),
         media_movel_mortes_14dias = slider::slide_index_dbl(.i = date,
                                                             .x = new_deaths,
                                                             .f = mean,
                                                             .before = 13),
         media_movel_casos_7dias= slider::slide_index_dbl(.i = date,
                                                          .x = new_confirmed,
                                                          .f = mean,
                                                          .before = 6),
         media_movel_casos_14dias = slider::slide_index_dbl(.i = date,
                                                            .x = new_confirmed,
                                                            .f = mean,
                                                            .before = 13) )

medias_moveis_jf<- caso_full_jf%>%
  pivot_longer(cols = c(media_movel_mortes_7dias, media_movel_mortes_14dias),
               names_to = "Dias de media móvel",
               values_to = "valores da Média")


# Visualização --------------------------------------

#Mortes Diárias
caso_full_jf%>%
  ggplot(aes(x=date, y=new_deaths)) +geom_col() +
  geom_line(aes(x=date, y= media_movel_mortes_7dias), 
            color= "red", show.legend = FALSE, size= 1.2, alpha= 0.8) +
  geom_line(aes(x=date, y= media_movel_mortes_14dias), 
            color= "blue", show.legend = FALSE, size= 1.2, alpha= 0.8)+
  labs(title = "Nº Diário de Mortes em Juiz de Fora- BRASIL IO",
       subtitle = "Em Vermelho, Média Movel dos Últimos 7 dias. Em Azul, Média Móvel dos Últimos 14 dias",
       caption= "Fonte: Secretaria de Saúde Estadual - Tratamento dos Dados: Brasil IO - Elaboração do Gráfico: JF em Dados")+
  theme_classic()


#casos diários
caso_full_jf%>%
  ggplot(aes(x=date, y=new_confirmed)) +geom_col() +
  geom_line(aes(x=date, y= media_movel_casos_7dias), 
            color= "red", show.legend = FALSE, size= 1.2, alpha= 0.8) +
  geom_line(aes(x=date, y= media_movel_casos_14dias), 
            color= "blue", show.legend = FALSE, size= 1.2, alpha= 0.8)+
  labs(title = "Nº Diário de Casos em Juiz de Fora - Última atualização em 25/03/2021",
       subtitle = "Em Vermelho, Média Movel dos Últimos 7 dias. Em Azul, Média Móvel dos Últimos 14 dias",
       caption= "Fonte: Secretaria de Saúde Estadual - Tratamento dos Dados: Brasil IO - Elaboração do Gráfico: JF em Dados")+
  theme_classic()

# Exportação ------------------------------------------

write.csv(caso_full_jf, file="data_sus/caso_full_jf.csv")

writexl::write_xlsx(caso_full_jf, path = "data_sus/caso_full_jf.xlsx")
