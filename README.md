# covid19jf
Dados, estatísticas e mapas do Coronavírus para a cidade de Juiz de Fora


os scripts em R são organizados da seguinte forma:

**mapa_corona** foi um mapa da covid construído cruzando geobr, com a base de bairros do be a partir de dados em um txt que conseguimos provisório. Foi o primeiro mapa e o que motivou a criação do JF em Dados =D

**corona_open_data_sus** é já baixando os dados oficiais do sus.
Mas também tem o Open Data sus original, que se pá vou usar pra fazer data da notificação vs data da morte e covid vs srag: https://opendatasus.saude.gov.br/dataset/bd-srag-2020 
Não deu certo, a base tem muito menos casos do que a base total.

Do **Brasil IO**, base mais organizada por voluntários, no link: https://brasil.io/dataset/covid19/caso_full/., fiz dois códigos:
**dados_diarios_brasil_io.r**, um de dados diários, que tem a média movel. Funciona bem, mas os dados demoram. vou tee que achar outra base
**dados_totais_brasil_io.r** é do número total de morte e casos. possibilita comparação.
