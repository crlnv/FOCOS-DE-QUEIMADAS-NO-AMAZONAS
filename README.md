OLÁ!

Atualizando o canal com um projetinho que eu fiz como trabalho final do curso de Séries Temporais, também conhecida como uma das melhores matérias de Estatística. 
Escolhi trabalhar com dados ambientais do Amazonas, e como o estado nos últimos anos vem passando por situações emergenciais relacionados a mundanças climáticas e ao desmatamento,
considerei que seria interessante observar como essas informações se mostram ao longo do tempo, o período delimitado foi janeiro/1999 até dezembro/2023.
Os dados foram extraídos no site do [INPE](https://terrabrasilis.dpi.inpe.br/queimadas/situacao-atual/estatisticas/estatisticas_estados/) que faz o monitoramento dos focos ativos de queimadas.
Lembrando que focos de queimadas e área desmatadas são indicadores proporcionais.
Como o trabalho foi feito e pensado para ser apresentado numa aula de forma bem prática, você não vai encontrar aqui uma fundamentação teórica, mas ainda é um desejo meu 
retornar nesse trabalho e deixar ele mais completo.
Pois bem, o script no R fornece um modelo SARIMA (ARIMA com componente de sazonalidade) e previsão para 24 meses. Fiz a apresentação no Rmarkdown usando o [reveal.js](https://revealjs.com).
Sobre o reveal.js uma consideração: o design é muito bonito e ele oferece ferramentas que o Rmarkdown ou Quarto sozinho não oferecem, mas exportar para powerpoint, por exemplo,
é bem complicado, e não foi algo que levei em consideração quando fiz a apresentação. Consegui exportar pra pdf porém não ficou legal como fica quando roda no Rstudio.
Enfim, se for usar o reveal.js leve isso em consideração!



