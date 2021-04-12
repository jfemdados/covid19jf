##### JF EM DADOS - Coronavírus Casos e Óbitos ######
#Dados Secretaria de Saúde MG - https://coronavirus.saude.mg.gov.br/painel
#  Autor: Marcello Filgueiras  

library(tidyverse)
# Importação ----------------------------------------------------
library(readxl)
obitos_diarios_ses_raw <- read_excel("ses_mg/data_raw/xlsx_painel.xlsx", 
                          sheet = "OBITOS", 
                          col_types = c("text","numeric", "date",
                                        "text", "text", "text", "text"))

obitos_diarios_ses<- obitos_diarios_ses_raw

# Tidying ----------------------------------------------------

obitos_diarios_ses<-obitos_diarios_ses%>%
  mutate(DATA= as.Date(DATA))%>%
  tidyr::complete(DATA= seq.Date(min(DATA), Sys.Date(), by="day"))

# filtros e Classificações  ----------------------------------------------------


obitos_diarios_ses_jf<- obitos_diarios_ses%>%
  filter(MUNICIPIO_RESIDENCIA == "JUIZ DE FORA")

# Modelos  ----------------------------------------------------

obitos_diarios_ses_jf<- obitos_diarios_ses_jf%>%
    tsibble::as_tsibble(index=DATA)%>%
    mutate(media_movel_mortes_7dias= slider::slide_index_dbl(.i = DATA,
                                                             .x = NUM_OBITOS,
                                                             .f = mean,
                                                             .before = 6),
           media_movel_mortes_14dias = slider::slide_index_dbl(.i = DATA,
                                                               .x = NUM_OBITOS,
                                                               .f = mean,
                                                               .before = 13))%>%
  arrange(desc(DATA))

# Visualização ----------------------------------------------------

#Mortes Diárias


obitos_diarios_ses_jf%>%
  ggplot(aes(x=DATA, y=NUM_OBITOS)) +geom_col() +
  geom_line(aes(x=DATA, y= media_movel_mortes_7dias), 
            color= "red", show.legend = FALSE, size= 1.2, alpha= 0.8) +
  geom_line(aes(x=DATA, y= media_movel_mortes_14dias), 
            color= "blue", show.legend = FALSE, size= 1.2, alpha= 0.8)+
  labs(title = "Nº Diário de Mortes em Juiz de Fora - SES",
       subtitle = "Em Vermelho, Média Movel dos Últimos 7 dias. Em Azul, Média Móvel dos Últimos 14 dias",
       caption= "Fonte: Secretaria de Saúde Estadual - Elaboração do Gráfico: JF em Dados")+
  theme_classic()


# Exportação ----------------------------------------------------