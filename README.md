# covid19jf
Dados, estatísticas e mapas do Coronavírus para a cidade de Juiz de Fora


os scripts em R são organizados da seguinte forma:

**mapa_corona** foi um mapa da covid construído cruzando geobr, com a base de bairros do be a partir de dados em um txt que conseguimos provisório. Foi o primeiro mapa e o que motivou a criação do JF em Dados =D

![image](https://user-images.githubusercontent.com/53457944/113977685-56098180-9819-11eb-9f0e-0bd36f42091f.png)


**corona_open_data_sus** é já baixando os dados oficiais do sus.
Mas também tem o Open Data sus original, que se pá vou usar pra fazer data da notificação vs data da morte e covid vs srag: https://opendatasus.saude.gov.br/dataset/bd-srag-2020 
Não deu certo, a base tem muito menos casos do que a base total.


Do **Brasil IO**, base mais organizada por voluntários, no link: https://brasil.io/dataset/covid19/caso_full/., fiz dois códigos:
**dados_diarios_brasil_io.r**, um de dados diários, que tem a média movel. Funciona bem, mas os dados demoram. vou tee que achar outra base

![image](https://user-images.githubusercontent.com/53457944/113977274-bb10a780-9818-11eb-9b2b-b268d5529f06.png)

**dados_totais_brasil_io.r** é do número total de morte e casos. possibilita comparação com outras cidade .
![image](https://user-images.githubusercontent.com/53457944/113977326-ccf24a80-9818-11eb-8de1-d62d9dd5f230.png)

![image](https://user-images.githubusercontent.com/53457944/113977367-dd0a2a00-9818-11eb-9039-8c141e507bf1.png)

