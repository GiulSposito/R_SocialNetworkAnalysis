---
title: "An�lise da Rede de Colabora��o de Autores de Pacotes do CRAN usando R"
author: "Giuliano Sposito"
date: "Dezembro de 2017"
output:
  html_document:
    keep_md: TRUE
    df_print: paged
  pdf_document: default
---



```
CT050-Turma D: Geografia da Inova��o, Pol�tica Tecnol�gica e Governan�a de Redes
Profa. Dra. Janaina Pamplona da Costa
Departamento de Pol�tica Cient�fica e Tecnol�gica
Instituto de Geoci�ncias - Unicamp
```
### Abstract

Este artigo explora t�cnicas de *An�lise de Redes Sociais* para analisar o comportamento e organiza��o em redes colabora��o de autores e desenvolvedores de pacotes de software para R[^1] publicados no reposit�rio CRAN[^2].

## Introdu��o

### Redes Sociais

O trabalho em rede tem se tornado cada vez mais uma maneira de organiza��o humana presente em nossas vidas e nos mais diferentes n�veis da estrutura das empresas modernas. "_Os indiv�duos, dotados de recursos e capacidades propositivas, organizam suas a��es nos pr�prios espa�os pol�ticos em fun��o de socializa��es e mobiliza��es suscitadas pelo pr�prio desenvolvimento das redes_". (MARTELETO 2001)

A din�mica das redes funciona por meio de atividades relacionadas ao compartilhamento de valores e de id�ias em comunidades, e em sua representa��o gr�fica em que cada ator � representada por um n�, e as rela��es s�o representadas por linhas que conectam os n�s. (STORCH 2008)

Analisar estas redes resume-se em estudar as liga��es relacionais entre atores sociais. Estes atores, tanto podem ser pessoas e empresas individualmente ou coletivamente analisadas em unidades sociais, como por exemplo, departamento de uma organiza��o, prestadoras de servi�o p�blico em um munic�pio ou estados-na��o em um continente. (WASSERMAN 1994) 


### Vantagens Competitivas da Rede

O acesso � informa��o � um elemento-chave para o desenvolvimento econ�mico e social de comunidades, grupos sociais e indiv�duos. A capacidade de obter informa��es, al�m dos contornos restritos da pr�pria localidade, � parte do capital relacional dos indiv�duos e grupos. (MARTELETO 2004)

O capital social, definido como o conjunto de vantagens obtida da rede de relacionamento, pode ser considerado como capital humano ou financeiro, investimentos para sua amplia��o devem permitir retornos ou benef�cios, servindo de base para o desenvolvimento. (BURT 2001)

Com efeito, a rede n�o � conseq��ncia, apenas, das rela��es que de fato existem entre os atores; ela � tamb�m o resultado da aus�ncia de rela��es, da falta de la�os diretos entre dois atores, do que BURT (1992) chama de "buracos estruturais". O "desenho" do tecido social apresenta-se, desse modo, como algo semelhante a um queijo su��o. Para os analistas que salientam o "fechamento da rede", o capital social guarda rela��o direta e proporcional com a quantidade de cliques (ou n�cleos de tr�ades sobrepostas) e com a intensidade dos la�os fortes (ENGLE 1999).


### Importancia da An�lise de Redes Sociais

An�lise das m�tricas de rede possibilitaria ent�o apontar interven��es necess�rias para otimizar as intera��es entre os atores das redes. 

An�lise de Redes Sociais possibilitam, dentre outros, os seguintes benef�cios para as organiza��es: promo��o da integra��o da rede de pessoas participantes em atividades de negocia��es da empresa, identifica��o dos indiv�duos que n�o compartilham seus conhecimentos; a avalia��o do desempenho de um grupo de pessoas que trabalham de forma integrada, dentre outros. 

Muitas pr�ticas gerenciais habituais no cotidiano das empresas e corpora��es podem explorar os conceitos e mecanismos da organiza��o em rede, melhorando a sua efetividade: 

* **Gest�o de Talentos**: Encontrar os l�deres naturais na organiza��o;
* **Inova��o**: Identificar fronteiras. Garantir que a organiza��o tenha acesso a novas id�ias;
* **Colabora��o**: Encontrar lacunas no conhecimento dentro de grupos, ou entre organiza��es ou geografias. Monitorar ou medir mudan�as;
* **Gest�o do conhecimento**: Identificar e manter conhecimentos vitais. Monitorar ou medir mudan�as no conhecimento ou na troca de conhecimento;
* **Mudan�a Organizacional e Desenvolvimento**: Encontrar l�deres de opini�o para iniciativas de gerenciamento de mudan�as ou durante a integra��o ap�s fus�es e aquisi��es;
* **Desempenho Organizacional**: Diagnosticar a coes�o entre os membros da equipe e identificar conex�es cr�ticas para a melhoria.


## Conceitos Chaves para An�lise de Redes

O uso prim�rio da teoria de grafos na an�lise de rede � buscar identificar "importante" atores. O conceito de prest�gio e centralidade busca quantificar ideias te�ricas sobre a proemin�ncia de um ator em uma rede, sumarizando as rela��es estruturais com os demais atores. Al�m disso, fornece indicadores no n�vel de grupo, que permite avaliar a dispers�o ou desigualdade (de recursos e/ou informa��es) entre todos os atores da rede.

A *teoria de grafos*, campo da da matem�tica que estuda as rela��es entre os objetos de um determinado conjunto, fornece os mecanismos matem�ticos que s�o base para a an�lise das estruturas da rede. Atrav�s do entendimento da estrutura de uma rede � poss�vel ter _insights_ sobre seus padr�es, propriedades e indiv�duos. 

Um grafo � uma representa��o matem�tica de uma rede social, onde os elementos (empresas, pessoas, etc.) s�o representados por v�rtices e a rela��o entre os elementos s�o representados como arestas entre dois v�rtices. A liga��o (aresta) pode ser direcional ou n�o direcional. Pode-se associar valores tanto aos n�s como arestas.



```r
# Lista de arestas, os n�meros s�o identificadores dos n�s
g_edgelist <- data.frame(
  from = c( 1,1,2,2,3,3,5,5),
  to   = c( 2,3,3,5,4,5,6,7)
) 

# construindo a rede a partir da lista de arestas
g <- g_edgelist %>%
  as.matrix() %>%
  graph.edgelist(directed = FALSE) %>% # usando igraph 
  as_tbl_graph() %>%
  activate("nodes") %>%
  mutate( name = LETTERS[1:7] ) # nomeando os n�s

# calculando previamente as m�tricas
g <- g %>% 
  mutate( degree = centrality_degree(), 
          btwn   = round( centrality_betweenness(),2 ),
          clsn   = round( centrality_closeness(normalized = T),2 ),
          eign   = round( centrality_eigen(scale = F), 2 ))

# fixando o layout previamente para todos os plots terem a mesma disposicao
g_layout <- create_layout(g, layout = "kk")

# plotando o graph
ggraph(g_layout) +
  geom_edge_fan(alpha=0.3) +
  geom_node_point(color="blue",alpha=0.8, size=8) +
  geom_node_text(aes(label=name), color="white") +
  theme_void() +
  ggtitle( "Exemplo de Rede" ) + 
  theme( legend.position = "none" )
```

![](ct050_artigo_files/figure-html/network-1.png)<!-- -->


H� uma s�rie de m�tricas e propriedades (Newmann, 2010) de um grafo que podem fornecer informa��es relevantes sobre a rela��o (arestas) entre os indiv�duos (v�rtices) e os pr�prios indiv�duos quando esse representa uma rede social. Iremos explorar algumas propriedades que podem estar ligadas a identifica��o de capital social, s�o elas:

* Degree Centrality
* Betweenness Centrality
* Closeness Centrality
* Eigenvector Centrality
* Components
* Density
* Diameter
* Eccentricy


#### Degree Centrality (Grau)

O Grau (_Degree_) � o n�mero de arestas (ou links) que levam para dentro ou para fora de um v�rtice. Freq�entemente usado como medida de conex�o de um n� para outros n�s imediatos. Podendo assim representar influencia e/ou popularidade de um n� juntos aos demais. �til na avalia��o de quais n�s s�o fundamentais em rela��o � dissemina��o de informa��es e na capacidade influenciar outros n�s na localidade imediata.

Exemplos:

* Quantas pessoas essa pessoa pode alcan�ar diretamente?
* Em uma rede de m�sicos: com quantas pessoas essa pessoa j� colaborou/tocou junto?



```r
# plot da rede evidenciando o degree
ggraph(g_layout) +
  geom_edge_fan(alpha=0.4) +
  geom_node_point(aes(color = degree), size=8) + 
  geom_node_text(aes(label=name),color="white") +
  geom_node_text(aes(label=degree, color=degree), nudge_y = NUDGE_Y ) +
  theme_graph() +
  # ggtitle( "Degree" ) + 
  theme( legend.position = "none" )
```

![](ct050_artigo_files/figure-html/degree-1.png)<!-- -->


#### Betweenness Centrality (Intermedia��o)

A *Betweenness Centrality* � uma m�trica que representa quantos caminhos curtos (_shortest path_) que ligam outros n� da rede, passam pelo n� em quest�o. Para calcular o valor para um determinado n� **v**, calcule o n�mero de caminhos mais curtos entre os n�s **i** e **j** que passam atrav�s de **v** e divida por todos os caminhos mais curtos entre **i** e **j**. Repita para todo os n�s.

� uma medida importante, pois representa "o quanto" um n�, ou v�rtice, est� dentro dos fluxos de informa��es poss�veis entre os outros n�s. Quanto mais alto o valor, maior a import�ncia do n�, como um elo de comunica��o entre os demais n�s.

Esta m�trica tamb�m pode ser calculada com respeito a uma aresta, assim estar�amos medindo o quanto um link entre dos n�s participa dos caminhos mais curtos entre os n�s da rede.

Exemplos:

* Qual a probabilidade de esta pessoa ser a rota mais direta entre duas pessoas na rede?
* Me uma rede de espi�es: quem � o espi�o pela qual a maioria das informa��es confidenciais pode fluir?



```r
# plot da rede evidenciando o betweenness
ggraph(g_layout) +
  geom_edge_fan(alpha=0.4) +
  geom_node_point(aes(color = btwn), size=8) + 
  geom_node_text(aes(label=name),color="white") +
  geom_node_text(aes(label=btwn, color=btwn), nudge_y = NUDGE_Y ) +
  theme_graph() +
  # ggtitle( "Betweenness Centrality" ) + 
  theme( legend.position = "none" )
```

![](ct050_artigo_files/figure-html/Betweenness-1.png)<!-- -->


#### Closeness Centrality (Proximidade)

Representa o qu�o perto um n� est� dos demais, pode ser uma medida direta da contagem de arestas ou da soma dos pesos dela. Para obt�-la calcule o comprimento m�dio de todos os caminhos mais curtos de um n� para todos os outros n�s da rede.

� uma medida de _alcance_, mediria por exemplo a velocidade com informa��es pode alcan�ar outros n�s a partir de um determinado n� inicial, quanto mais pr�ximo um n� dos demais, mais r�pido este n� influenciaria outros.

Exemplos:

* Qu�o r�pido essa pessoa pode alcan�ar todos na rede?
* Em rede de rela��es sexuais: qu�o r�pido uma DST se espalhar� dessa pessoa para o resto da rede?



```r
ggraph(g_layout) +
  geom_edge_fan(alpha=0.4) +
  geom_node_point(aes(color = clsn), size=8) + 
  geom_node_text(aes(label=name),color="white") +
  geom_node_text(aes(label=clsn, color=clsn), nudge_y = NUDGE_Y ) +
  theme_graph() +
  # ggtitle( "Closeness" ) + 
  theme( legend.position = "none" )
```

![](ct050_artigo_files/figure-html/closeness-1.png)<!-- -->


#### Eigenvector Centrality (Autovetor)

A centralidade do _autovetores_ de um n� � proporcional � soma das centralidades de _autovetores de todos os n�s diretamente conectados a ele. A m�trica � obtida atrav�s da fatora��o e calculo de autovetores da _matriz de adjac�ncia_[^3] que representa a rede.

Est� associado a reputa��o e um v�rtice com respeito �s suas liga��es.

Exemplos:

* Qu�o bem esta pessoa est� conectada a outras pessoas bem conectadas?
* Na rede de cita��es de artigos: quem � o autor mais citado por outros autores bem citados?


```r
ggraph(g_layout) +
  geom_edge_fan(alpha=0.4) +
  geom_node_point(aes(color = eign), size=8) + 
  geom_node_text(aes(label=name),color="white") +
  geom_node_text(aes(label=eign, color=eign), nudge_y = NUDGE_Y ) +
  theme_graph() +
  # ggtitle( "Eigenvector" ) + 
  theme( legend.position = "none" )
```

![](ct050_artigo_files/figure-html/eigenvector-1.png)<!-- -->


#### Componentes

Um rede pode ter ser segmentada, ou seja, n�s formam sub-redes n�o conectadas entre si, tais sub-redes s�o chamadas de componentes.



```r
# montando uma lista de arestas (os n�meros identificam o v�rtice)
edgelist <- data.frame(
  from = c(1,1,2,4,2,3,4,5,6,6,7,7,8,8,9,10),
  to   = c(2,3,4,3,5,4,5,1,7,8,9,8,9,10,10,7)
)

# construindo o grafo a partid da lista de aresta
edgelist %>%
  as.matrix() %>%
  graph.edgelist(directed = T) %>%
  as_tbl_graph() %>%
  activate("nodes") %>%
  mutate( name = LETTERS[1:10],
          component = as.factor(group_components())) -> g


ggraph(g, layout="kk") +
  geom_edge_fan(alpha=0.2, arrow = arrow(type="closed", angle=10, length = unit(5,units = "mm") ))+
  geom_node_point(aes(color=component),alpha=0.8, size=8) +
  geom_node_text(aes(label=name), color="white") +
  theme_void() +
  ggtitle( "Components" ) + 
  theme( legend.position = "none" )
```

![](ct050_artigo_files/figure-html/components-1.png)<!-- -->


### Identificando Atores e Padr�es

Usando as m�tricas listadas acima � poss�vel identificar e classificar a atua��o e import�ncia dos atores em uma rede.

Tome-se como exemplo esta rede:



```r
# lista de ligacoes
h_edgelist <- data.frame(
  from = c( 0,  1, 1,  2, 2, 3, 3,  3,  4, 5, 5, 5, 8),
  to   = c(10, 10, 2, 10, 3, 4, 5, 10, 10, 6, 7, 8, 9)
) + 1

# construcao da rede
h <- h_edgelist %>%
  as.matrix() %>%
  graph.edgelist(directed = FALSE) %>%
  as_tbl_graph() %>%
  activate("nodes") %>%
  mutate( name = LETTERS[1:11] ) # nomeando nos

# plot
ggraph(h, layout="kk") +
  geom_edge_fan(alpha=0.2) +
  geom_node_point(color="red",alpha=0.9, size=8) +
  geom_node_text(aes(label=name), color="white") +
  theme_void() +
  ggtitle( "Exemplo" ) + 
  theme( legend.position = "none" )
```

![](ct050_artigo_files/figure-html/kpnetwork-1.png)<!-- -->

Vamos combinar as medidas de centralidade para exibir importantes atores na estrutura.


```r
# calculando m�tricas de centralidade 
h <- h %>%
  activate("nodes") %>%
  mutate (
    degree = as.factor(centrality_degree()),
    btwn = round(centrality_betweenness(), 2),
    clsn = round(centrality_closeness(normalized = T), 2),
    eign = round(centrality_eigen(scale = T), 2),
    clst = as.factor(group_edge_betweenness())) %>% 
  
  # centrality das arestas
  activate("edges") %>%
  mutate( ebtwn = centrality_edge_betweenness() )

ggraph(h, layout="kk") +
  geom_edge_fan2(alpha=0.4, aes(edge_colour = ebtwn, label=ebtwn), label_size=3) +
  geom_node_point(aes(color=degree, size=clsn),alpha=0.5) +
  geom_node_text(aes(label=name), color="black") +
  geom_node_text(aes(label=eign, color=degree), nudge_y = -NUDGE_Y/2, size=2) +
  theme_void() +
  ggtitle( "Combinando M�tricas" ) + 
  scale_color_manual(breaks = c("1", "2","3", "5", "10"),
                     values=c("red","red","lightskyblue","lightskyblue","darkblue"))
```

![](ct050_artigo_files/figure-html/kpcentralities-1.png)<!-- -->

As v�rias medidas de centralidade s�o mostradas acima e s�o representadas:

* Cor do v�rtice: Degree Centrality
* Tamanho do v�rtice: Closeness Centrality
* N�mero abaixo do v�rtice: Eigenvetor Centrality
* Cor e valor na aresta: Edge Betweenness Centrality



```r
h %>% activate("nodes") %>%
  as.tibble() %>%
  select(-clst) %>%
  knitr::kable(caption="M�tricas de Centralidade dos N�s")
```



Table: M�tricas de Centralidade dos N�s

name   degree    btwn   clsn   eign
-----  -------  -----  -----  -----
A      1          0.0   0.34   0.32
B      2          0.0   0.36   0.57
C      3          3.0   0.45   0.78
D      4         25.5   0.59   0.89
E      2          0.0   0.43   0.60
F      4         29.0   0.56   0.41
G      1          0.0   0.37   0.13
H      1          0.0   0.37   0.13
I      2          9.0   0.40   0.15
J      1          0.0   0.29   0.05
K      5         13.5   0.50   1.00


Atrav�s das rela��es entre as centralidades � poss�vel identificar os seguintes aspectos

* N�s mais conectados: **K** com mais conex�es seguidas de **D** e **F**;
* A liga��o entre a **F** e **D** � a de maior *intermedia��o*, al�m disso se removida desconecta o gr�fico;
* O n� **D** � o mais pr�ximo aos demais e
* O n� **K** � no mais referenciado por n�s mais referenciados (maior *eigenvector*), seguido logo por **D**, mais uma vez mostrando a import�ncia do no **D** na estrutura da rede.


#### Gatekeepers & Accessors

Combinando duas m�tricas de centralidade, autovetores e intermedia��o, � poss�vel evidenciar dois tipos de atores espec�ficos numa rede. 

* Um ator com **alta intermedia��o** (*betweenness*) e **baixo autovetor** (*eigenvector*) pode ser um porteiro (_Gatekeeper_) importante para um ator central ou atores importantes.
* Um ator com **baixa intermedia��o** e **alto autovetor** pode ter acesso exclusivo a atores centrais.



```r
h %>% activate("nodes") %>% as_tibble() %>% 
  ggplot(aes(x=btwn, y=eign)) + 
  geom_point() + geom_label(aes(label=name)) +
  theme( legend.position = "none" )
```

![](ct050_artigo_files/figure-html/keysplayer-1.png)<!-- -->


Observando a distribui��o de como *eigenvector* fica em fun��o *betweenness*, � poss�vel observar ent�o que o n� **F** atua como um *Gatekeeper* e o n� **C** como um n� de acesso a atores importantes (*accessor*).



```r
# key actors type
h <- h %>%
  activate("nodes") %>%
  mutate( type = as.factor(case_when(
    name == "F" ~ "gatekeeper",
    name == "C" ~ "access to central actors",
    TRUE ~ "others"
  )))

# plot
ggraph(h, layout="kk") +
  geom_edge_fan2(alpha=0.4, aes(edge_colour = ebtwn), label_size=3) +
  geom_node_point(aes(color=type),alpha=0.9, size=8) +
  geom_node_text(aes(label=name), color="white") +
  geom_node_text(aes(label=eign), nudge_y = NUDGE_Y, size=3) +
  theme_void() +
  # ggtitle( "Gatekeeper and Accessor" ) + 
  scale_color_manual(breaks = c("others","gatekeeper","access to central actors"),
                     values=c("red","lightskyblue","darkblue"))
```

![](ct050_artigo_files/figure-html/nodetypes-1.png)<!-- -->


Podemos perceber que o n� **C** � o n� que "d� acesso" a n�s de alta reputa��o (*eigenvector*) enquanto o n� **F**, � um n� de relativa baixa reputa��o que atua de porteiro para os n�s de atua relev�ncia (D, K, E e C).


#### Comunidades (_clusters_)

Muitas redes consistem em m�dulos que est�o densamente conectados, mas que est�o escassamente conectados a outros m�dulos, a esses m�dulos � dado o nome de *comunidade*. A ideia da detec��o de estrutura de comunidade � descobrir "bordas" e detectar arestas quem ligam m�dulos separados. 

Uma estrat�gia � calcular a centralidade de betweenness das arestas e ir removendo gradualmente as arestas de maior pontua��o, desconectando o gr�fico, identificando assim as comunidades.



```r
ggraph(h, layout="kk") +
   geom_edge_fan2(alpha=0.5, aes(edge_colour = ebtwn)) +
  geom_node_point(aes(color=clst),alpha=0.9, size=8) +
  geom_node_text(aes(label=name), color="white") +
  # ggtitle( "Community / Clusters" ) + 
  theme_void() + 
  theme( legend.position = "none" )
```

![](ct050_artigo_files/figure-html/community-1.png)<!-- -->


## Rede de Colabora��o de Autores no CRAN

CRAN[^2] � o reposit�rio oficial de pacotes de R, [listando](https://cran.r-project.org/web/packages/available_packages_by_name.html) todos os pacotes produzido e disponibilizado gratuitamente pela comunidade de usu�rio e programadores. Os pacotes fornece funcionalidades adicionais ou espec�ficas para o R e para serem utilizados devem ser copiados, instalados e carregados. 

Qualquer pessoa pode desenvolver e disponibilizar pacotes, por�m � mais comum que os pacotes sejam desenvolvidos por equipes de pesquisa e grupos de programadores dentro de empresas ou universidades ou que sejam um desenvolvimento que segue a din�mica de software _open source_, quando o c�digo do pacote est� p�blico e recebe contribui��o de v�rios desenvolvedores espalhados pelo mundo.

![Autores de um pacote R](./images/xgb_package.png)

O pacote publicado cont�m uma lista de autores, que contribu�ram para construir e publicar o pacote. O objetivo desta an�lise entender como se organiza a rede de colabora��o de autores, para isso usaremos os dados de publica��o para construir uma rede, onde cada v�rtice da rede � um ator e uma aresta identifica um pacote em que dois (ou mais autores) colaboraram juntos.


### Construindo a Rede



```r
# dados de publicacao de pacotes
pdb <- tools::CRAN_package_db()

# campo de autores dos pacotes
pbaut <- pdb$Author 

# o campo de autores � uma string separada por virgula e contendo outras informa��es
# � necessario limpar a string e separar os nome dos atuores
aut <- pbaut %>%
  str_replace_all("\\[.*?\\]", "") %>%
  str_replace_all("[\\n\\t]", "") %>%
  str_replace_all("\\<.*?\\>", "") %>%
  str_replace_all("\\(.*?\\)", "") %>% 
  str_replace_all("\\(([^)]+)\\)", "") %>% # remocao 
  str_replace_all("\\[([^]]+)\\]", "") %>% # remocao
  str_replace_all("<([^>]+)>", "") %>% # remocao
  str_replace_all("\n", " ") %>% # remocao
  str_replace_all("[Cc]ontribution.* from|[Cc]ontribution.* by|[Cc]ontributors", " ") %>%
  str_replace_all("\\(|\\)|\\[|\\]", " ") %>% # remocao
  iconv(to = "ASCII//TRANSLIT") %>% # limpeza dos caracters especiais
  str_replace_all("'$|^'", "") %>%  # limpeza
  gsub("([A-Z])([A-Z]{1,})", "\\1\\L\\2", ., perl = TRUE) %>% 
  gsub("\\b([A-Z]{1}) \\b", "\\1\\. ", .) %>%
  map(str_split, ",|;|&| \\. |--|(?<=[a-z])\\.| [Aa]nd | [Ww]ith | [Bb]y ", simplify = TRUE) %>% 
  map(str_replace_all, "[[:space:]]+", " ") %>% 
  map(str_replace_all, " $|^ | \\.", "") %>% 
  map(function(x) x[str_length(x) != 0]) %>%
  set_names(pdb$Package) %>% 
  magrittr::extract(map_lgl(., function(x) length(x) > 1))

# conta autores por pacote
aut_list <- aut %>%
  unlist() %>%
  dplyr::as_data_frame() %>%
  count(value) %>%
  rename(name = value, packages = n)

# transforma a lista "pacote" -> [autores] em uma edge list
edge_list <- aut %>%
  map(combn, m = 2) %>%    # em cada pacote (map) gera uma combinacao do array de autores dois a dois
  do.call("cbind", .) %>%  
  t() %>%
  dplyr::as_data_frame() %>%
  arrange(V1, V2) %>%
  count(V1, V2) 

# controi a rede a partir da lista de arestas
authors_network <- edge_list %>%
  select(V1, V2) %>%
  as.matrix() %>%
  graph.edgelist(directed = FALSE) %>%
  as_tbl_graph() %>%    # wrapper tidygraph para o objeto igraph
  activate("edges") %>% 
  mutate(weight = edge_list$n) %>% # resgata o peso das arestas (# de pacotes)
  activate("nodes") %>%
  left_join(aut_list, by="name") # nomeia os n�s com os nomes dos autores

# dados de autores e arestas
total_authors <- authors_network %>% activate("nodes") %>% as.tibble() %>% nrow()
total_edges <- authors_network %>% activate("edges") %>% as.tibble() %>% nrow()
```


### Selecionando Components

A rede constru�da � composta de 14721 autores que se relacionam atrav�s 74550 arestas. Dado a natureza do objeto estudado espera-se que essa rede n�o seja conecta integralmente, formando ent�o **componentes** de colabora��o entre grupos de autores distintos, vamos analisar esse aspecto.


```r
# identifica os components
g <- authors_network %>% 
  activate("nodes") %>%  
  mutate(component = as.factor(group_components()))

# tabela components por n�mero de autores
authors.by.components <- g %>% 
  activate("nodes") %>%
  as.tibble() %>%
  group_by(component) %>%
  summarise( authors=n() ) %>%
  arrange( desc(authors) )

# top 10 maiores components
knitr::kable(head(authors.by.components,10), caption = "Maiores componentes (top 10)")
```



Table: Maiores componentes (top 10)

component    authors
----------  --------
3               7486
30                68
6                 44
22                35
726               25
71                24
43                23
46                23
112               23
29                22

Vamos selecionar tr�s destes componentes para caracteriz�-los: componentes 30, 33 e 717[^4].

### Comparando os tr�s components



```r
sel_components <- c(30,33,717)

# plotando os components
g %>%
  filter( component %in% sel_components ) %>%
  ggraph(layout="auto") +
  geom_edge_fan(alpha=0.2)+
  geom_node_point(aes(color=component),alpha=0.8, size=2) +
  theme_void()
```

![](ct050_artigo_files/figure-html/plotcomponents-1.png)<!-- -->


Nota-se que os componentes possuem estruturas distintas umas das outras, vamos caracteriz�-las com m�tricas de rede.



```r
# para cada um do componentes escolhidos
net_metrics <- rbindlist(lapply( sel_components, function(comp){
  # filtra pelo component
  h <- g %>% filter( component == comp )
  # calcula metricas de rede
  res <- data.frame(
    component = comp,
    nodes     = h %>% activate("nodes") %>% as.tibble() %>% nrow(),
    density   = round(graph.density(h, loops = F),4),
    diameter  = diameter(h, directed = F, unconnected = F, weights = NULL),
    eccentricity = max(eccentricity(h, mode="all"))/min(eccentricity(h, mode="all"))
  )
  return(res)
}))

# tabela
knitr::kable(net_metrics)
```



 component   nodes   density   diameter   eccentricity
----------  ------  --------  ---------  -------------
        30      68         1          1              1
        33       4         1          1              1
       717       2         1          1              1


Para cada um dos componentes calculamos:

* **densidade**: n�mero de arestas da rede dividido pelo n�mero de arestas poss�veis;
* **di�metro**: maior menor caminho (_shortest path_) existente na rede e
* **excentricidade**: aqui definida como o di�metro dividido pelo menor caminho (_shortest path_).

Nota-se nos valores que as redes de fato s�o distintas nessas dimens�es.

### analise de atores 



```r
# calcula centralidades para uma rede
calcNodeMetrics <- function(net, comp){
  net %>%
    activate("nodes") %>%
    filter( component==comp ) %>%
    mutate(
      degree = centrality_degree(),
      btwn = round(centrality_betweenness(), 2),
      clsn = round(centrality_closeness(normalized = T), 2),
      eign = round(centrality_eigen(scale = T), 2),
      clst = as.factor(group_edge_betweenness())
    ) %>%
    activate("edges") %>%
    mutate( ebtwn = centrality_edge_betweenness() ) %>%
    return()
}

# para cada um dos componentes, faz o calculo de centralidades
netMetrics <- lapply(sel_components, function(comp) calcNodeMetrics(g,comp) )
netMetrics <- setNames(netMetrics, sel_components)
```


#### Component 30


```r
ggraph(netMetrics$`30`, layout="kk") +
  geom_edge_fan2(alpha=0.2, aes(edge_colour = ebtwn)) +
  geom_node_point(aes(color=btwn, size=degree),alpha=0.9) +
  theme_void() %>% +
  theme( legend.position = "none" ) + 
  ggtitle( "Componente 30" )
```

![](ct050_artigo_files/figure-html/comp30-1.png)<!-- -->


Numa rede totalmente conectada (densidade = 1), todos os n�s e arestas tem as mesmas m�tricas, n�o � poss�vel selecionar um (ou mais autores) como mais influente ou rela��o mais importante, a rede � homog�nea. Este componente � composto de autores de um s� pacote ([rcorpora](https://cran.r-project.org/web/packages/rcorpora/index.html)), cujo os autores n�o trabalharam com nenhum outro conjunto de autores.


#### Componente 33


```r
  ggraph(netMetrics$`33`, layout="kk") +
    geom_edge_fan2(alpha=0.4, aes(edge_colour = ebtwn)) +
    geom_node_point(aes(color=btwn, size=btwn),alpha=0.9) +
    theme_void() + 
    theme( legend.position = "none" ) + 
    ggtitle( "Componente 33 - Betweenness" )
```

![](ct050_artigo_files/figure-html/comp33plot1-1.png)<!-- -->


```r
netMetrics$`33` %>%
  activate("nodes") %>%
  as.tibble() %>%
  arrange( desc(btwn), desc(degree), desc(eign), desc(clsn) ) %>%
  select(-component, -clst) %>%
  head(10) %>%
  knitr::kable(caption = "Autores por Betweeness (10 mais)")
```



Table: Autores por Betweeness (10 mais)

name               packages   degree   btwn   clsn   eign
----------------  ---------  -------  -----  -----  -----
Aaron Sim                 1        3      0      1      1
Becca Asquith             1        3      0      1      1
Charles Bangham           1        3      0      1      1
Daniel Laydon             1        3      0      1      1


A rede do componente 33 j� � bem menos acoplada, portanto de menor densidade, � poss�vel visualizar os autores mais bem "relacionados" e os autores que atuam com "pontes" entre os diversos n�s na estrutura. Isso � reflexo de quando o autor trabalha em momentos diferentes com outros grupos de autores em pacotes diferentes.



```r
ggraph(netMetrics$`33`, layout="kk") +
  geom_edge_fan2(alpha=0.4, aes(edge_colour = ebtwn)) +
  geom_node_point(aes(color=eign, size=eign),alpha=0.9) +
  theme_void() + 
  theme( legend.position = "none" ) + 
  ggtitle( "Componente 33 - Eigenvector Centrality" )
```

![](ct050_artigo_files/figure-html/comp33plot2-1.png)<!-- -->


```r
netMetrics$`33` %>%
  activate("nodes") %>%
  as.tibble() %>%
  arrange( desc(eign), desc(degree), desc(btwn), desc(clsn) ) %>%
  select(-packages, -component, -clst) %>%
  head(10) %>%
  knitr::kable( caption="Autores por Eigenvector (10 mais)")
```



Table: Autores por Eigenvector (10 mais)

name               degree   btwn   clsn   eign
----------------  -------  -----  -----  -----
Aaron Sim               3      0      1      1
Becca Asquith           3      0      1      1
Charles Bangham         3      0      1      1
Daniel Laydon           3      0      1      1


#### Componente 717

O componente 717 tem uma estrutura mais acoplada, com uma densidade de 0,23, intermedi�ria entre a 30 e 33, � poss�vel observar grupos que trabalham juntos e grande autor central conectando os subgrupos.


```r
  ggraph(netMetrics$`717`, layout="kk") +
    geom_edge_fan2(alpha=0.4, aes(edge_colour = ebtwn)) +
    geom_node_point(aes(color=btwn, size=btwn),alpha=0.9) +
    theme_void() + 
    theme( legend.position = "none" ) + 
    ggtitle( "Componente 717 - Betweenness" )
```

![](ct050_artigo_files/figure-html/comp717plot1-1.png)<!-- -->


```r
netMetrics$`717` %>%
  activate("nodes") %>%
  as.tibble() %>%
  arrange( desc(btwn), desc(degree), desc(eign), desc(clsn) ) %>%
  select(-component, -clst) %>%
  head(10) %>%
  knitr::kable(caption = "Autores por Betweeness (10 mais)")
```



Table: Autores por Betweeness (10 mais)

name                 packages   degree   btwn   clsn   eign
------------------  ---------  -------  -----  -----  -----
Daniel Gebele               1        1      0      1      1
Jochen Staudacher           1        1      0      1      1


Podemos observar, de fato, que o autor central [Quanli Wang](https://www.linkedin.com/in/quanli-wang-5645a01b/) trabalhou em 7 pacotes diferente, servindo de pontes para os v�rios subgrupos presente neste componente. Como ele � o �nico autor ligando esses subgrupos ele tamb�m � o mais bem "referenciado".



```r
ggraph(netMetrics$`717`, layout="kk") +
  geom_edge_fan2(alpha=0.4, aes(edge_colour = ebtwn)) +
  geom_node_point(aes(color=eign, size=eign),alpha=0.9) +
  theme_void() + 
  theme( legend.position = "none" ) + 
  ggtitle( "Componente 717 - Eigenvector Centrality" )
```

![](ct050_artigo_files/figure-html/comp717plot2-1.png)<!-- -->



```r
netMetrics$`717` %>%
  activate("nodes") %>%
  as.tibble() %>%
  arrange( desc(eign), desc(degree), desc(btwn), desc(clsn) ) %>%
  select(-packages, -component, -clst) %>%
  head(10) %>%
  knitr::kable( caption="Autores por Eigenvector (10 mais)")
```



Table: Autores por Eigenvector (10 mais)

name                 degree   btwn   clsn   eign
------------------  -------  -----  -----  -----
Daniel Gebele             1      0      1      1
Jochen Staudacher         1      0      1      1


### Analisando colabora��o recorrente

Vamos analisar frequ�ncia de publica��o por autores, excluindo autores que contribu�ram apenas uma vez.


```r
aut_list %>% 
  select(packages) %>%
  unlist() %>%
  summary()
```

```
##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
##   1.000   1.000   1.000   1.584   1.000 107.000
```

Observa-se que mais de 75% (3rd Quarter) dos autores contribu�ram apenas 1 vez com outros autores, para estabelecer uma rede de colabora��o mais efetiva (e n�o apenas moment�nea), vamos filtrar na rede autores que  pelo menos 5 pacotes.


```r
# obtendo a rede de colaboradores com mais de 5 publica��es
h <- authors_network %>%
  activate("nodes") %>%
  filter( packages > 5 ) %>%
  mutate( component = group_components() ) %>%
  # escolhendo o maior component
  filter( component == names(table(component))[which.max(table(component))] ) 

# dados de autores e arestas
total_authors <- h  %>% activate("nodes") %>% as.tibble() %>% nrow()
total_edges <- h  %>% activate("edges") %>% as.tibble() %>% nrow()

ggraph(h, layout="lgl") +
  geom_edge_fan(alpha=0.1)+
  geom_node_point(alpha=0.2, size=0.2) +
  theme_void()
```

![](ct050_artigo_files/figure-html/majorcomp-1.png)<!-- -->

Temos ent�o o maior componente da rede de colabora��o de autores que publicaram mais de 5 pacotes com as caracter�sticas:


```r
knitr::kable( data.frame(
    nodes     = h %>% activate("nodes") %>% as.tibble() %>% nrow(),
    edges     = h %>% activate("edges") %>% as.tibble() %>% nrow(),
    density   = round(graph.density(h, loops = F),4),
    diameter  = diameter(h, directed = F, unconnected = F, weights = NULL),
    eccentricity = max(eccentricity(h, mode="all"))/min(eccentricity(h, mode="all"))
), caption = "Dados do Componente de Autores")
```



Table: Dados do Componente de Autores

 nodes   edges   density   diameter   eccentricity
------  ------  --------  ---------  -------------
   288    2401    0.0581         21            1.8


#### Autores Chaves

Nesta rede, vamos ent�o localizar e analisar os principais autores chave, usando as m�tricas de centralidade.


```r
h <- h %>%
  activate("nodes") %>%
  mutate(
    degree = centrality_degree(),
    btwn = round(centrality_betweenness(), 2),
    clsn = round(centrality_closeness(normalized = T), 2),
    eign = round(centrality_eigen(scale = T), 2)
  ) %>%
  activate("edges") %>%
  mutate( ebtwn = centrality_edge_betweenness() )

authors <- h %>%
  activate("nodes") %>%
  as.tibble() %>%
  arrange(desc(btwn))

knitr::kable( head(authors, 10), caption = "Principais Autores, pelo crit�rio de betweeness. (top 10)")
```



Table: Principais Autores, pelo crit�rio de betweeness. (top 10)

name                 packages   component   degree      btwn   clsn   eign
------------------  ---------  ----------  -------  --------  -----  -----
Hadley Wickham            104           1      129   5262.89   0.45   0.89
Martin Maechler            47           1       92   5058.27   0.43   0.06
Dirk Eddelbuettel          46           1       82   2579.27   0.43   0.13
Jeffrey Horner             11           1       24   2520.96   0.34   0.08
Michael Friendly           21           1       91   2181.52   0.43   0.09
Ben Bolker                 23           1       77   2158.11   0.42   0.08
Kurt Hornik                60           1       68   2111.17   0.39   0.04
Achim Zeileis              46           1       83   2023.60   0.42   0.06
Inc                        44           1       55   1872.54   0.38   0.39
Torsten Hothorn            25           1       60   1687.37   0.41   0.05


Podemos notar que a lista tr�s de fato, autores influentes na comunidade de desenvolvimento R, como [Hadley Wickham](http://hadley.nz/) (cientista Chefe na empresa RStudio), [Martin Maechler](https://stat.ethz.ch/~maechler/) (estat�stico su��o na ETH) e [Jeffrey Horner](http://biostat.mc.vanderbilt.edu/wiki/Main/JeffreyHorner) (Developer no departamento de bio estat�stica da universidade Vanderbuilt). Importante notar que este �ltimo, possui alto **betweeness* mas relativamente pouco grau (*degree*) comparado aos autores da lista.

Vamos visualizar os autores na rede.



```r
authors_top10 <- authors[1:10,]$name
authors_top20 <- authors[11:20,]$name

h <- h %>%
  activate("nodes") %>%
  mutate ( 
    rank = as.factor(
      case_when(
        name %in% authors_top10 ~ "top 10",
        name %in% authors_top20 ~ "top 20",
        TRUE ~ "others"
      )
    )
  )

ggraph(h, layout="lgl") +
  geom_edge_fan(alpha=0.1)+
  geom_node_point(aes(color=rank),alpha=0.8, size=1) +
  theme_void() +
  scale_color_manual(breaks = c("others","top 10","top 20"),
                     values=c("grey","red","orange"))
```

![](ct050_artigo_files/figure-html/plottopauthors-1.png)<!-- -->

Embora a visualiza��o com todos os n�s seja complicada � poss�vel visualizar que alguns dos autores no grupo selecionado realmente atuam como "pontes" (_bridges_) concentrado arestas entre grupos distintos.


#### Comunidades

Uma outra an�lise que podemos fazer, diz respeito a identificar e avaliar os diversos clusters (_comunidades_) dentro da rede, ou seja, grupos de autores fortemente conectados entre si, e fracamente conectados com outros grupo de autores, podemos identificar agrupando de acordo com a centralidade de *betweenness* das arestas.



```r
h <- h %>%
  activate("nodes") %>%
  mutate(
    clst = as.factor(group_edge_betweenness())
  )

clusters <- h %>%
  activate("nodes") %>%
  as.tibble() %>%
  group_by( clst ) %>%
  summarise( authors = n() ) %>%
  arrange( desc(authors) )

total_clusters <- nrow(clusters)

knitr::kable( head(clusters, 10), caption = "Comunidades de Autores dentro da Rede" )
```



Table: Comunidades de Autores dentro da Rede

clst    authors
-----  --------
2            58
3            47
58            9
7             8
62            7
6             5
10            5
17            5
44            5
46            5


Encontramos 95 comunidades dentro da rede, dos quais duas se destacam pelo n�mero de colaboradores bem acima dos demais. Vamos visualizar algumas comunidades sobre a estrutura da rede.



```r
h <- h %>%
  activate("nodes") %>%
  mutate ( 
    community = as.factor(
      case_when(
        clst == 4 ~ "Comunidade 4",
        clst == 3 ~ "Comunidade 3",
        clst == 63 ~ "Comunidade 63",
        clst == 9 ~ "Comunidade 9",
        TRUE ~ "Others"
      )
    )
  )


ggraph(h, layout="lgl") +
  geom_edge_fan(alpha=0.1)+
  geom_node_point(aes(color=community, size=packages),alpha=0.8) +
  theme_void() +
  scale_color_manual(breaks = c("Comunidade 4","Comunidade 3","Comunidade 63","Comunidade 9" ,"Others"),
                     values=c("red","skyblue","green","orange","grey"))
```

![](ct050_artigo_files/figure-html/mcplotcommunities-1.png)<!-- -->


Claramente podemos observar a organiza��o dos clusters dentro da estrutura. Cada um dos clusters poderiam ser separados da estrutura e analisados � parte, aplicando novamente as m�tricas de centralidade para evidenciar os seus atores principais e sua din�mica de integra��o.


## Conclus�o

Vimos que as t�cnicas de an�lise de rede usando m�tricas de centralidade s�o relevante para identificar os principais autores de uma rede, analisar a estrutura e identificar padr�es. Particularmente em estruturas muito complexas e com muitos atores, as m�tricas conseguem expor � luz, padr�es e comportamento embutidos na estrutura.

Al�m disso o car�cter _reproduz�vel da an�lise_[^5] feita em R permite refinar continuamente a an�lise, eliminando res�duos e apurando os resultados


## Refer�ncias

[^1]: [R](https://www.r-project.org/) � uma linguagem de programa��o e ambiente para computa��o e an�lise estat�stica, de uso gratuito e que que fornece uma ampla variedade de t�cnicas  para: modelagem linear e n�o-linear, testes estat�sticos, an�lise de s�ries temporais, classifica��o, agrupamento. 

[^2]: [CRAN](https://cran.r-project.org/) ou _Comprehensive R Archive Network_ � uma rede de FTP e servidores web ao redor do mundo que armazenam vers�es de c�digo e documenta��o atualizadas para pacotes e bibliotecas para R. 

[^3]: Matriz de v�rtices contra v�rtices cuja as c�lulas indica o peso ou a liga��o entre os v�rtices.

[^4]: Escolhido com base no formato dos componentes e escolhendo tr�s casos distintos.

[^5]: _Reproducible Research_ ou **pesquisa reproduz�vel** � a ideia de que a an�lise de dados e, em geral, as alega��es cient�ficas, s�o publicados com seus dados e c�digo de software para que outros possam verificar as descobertas e construir sobre elas.

BURT, R. Structural Holes. University of Chicago Press, Chicago, 1992.

BURT, R. S. (. Structural holes versus network closure as social capital. (Cap. 2, pp. 31-56). New York: Aldine de Gruyter. 2001

ENGLE, S. Structural Holes and Simmelian Ties: Exploring Social Capital, Task Interdependence and Individual Effectiveness. Phd Thesis, University of North Texas, 1999.

MARTELETO, R. M. An�lise de redes sociais - aplica��o nos estudos de transfer�ncia da informa��o. Ci�ncia da Informa��o, Bras�lia, v.30, n. 1, p. 71-81, jan./abr. 2001. 

MARTELETO, Regina Maria  and  SILVA, Antonio Braz de Oliveira e. Redes e capital social: o enfoque da informa��o para o desenvolvimento local. Ci. Inf. 2004, vol.33, n.3, pp.41-49.

NEWMANN, M. Networks. Oxford University Press. April 2010.

STORCH, S.. As redes sociais j� fazem parte de nosso jeito de pensar. Dispon�vel em: http://www.intranetportal.com.br/e-gov/redessociais - Acesso em: 15 set. 2008. 

WASSERMAN, S.; FAUST, K. Social network analysis: methods and applications. Cambridge: Cambridge University Press, 1994
