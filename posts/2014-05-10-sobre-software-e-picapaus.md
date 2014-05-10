---
title: Sobre software e pica-paus
author: André Ramaciotti
tags: Programação
---

*Este texto é um conjunto de reflexões minhas e não traz respostas, apenas
 perguntas.*

Existe uma citação relativamente famosa no meio da Qualidade de Software.  Em
tradução livre:

> *Se construtores construíssem edifícios como programadores escrevem programas,
> o primeiro pica-pau que aparecesse destruiria a civilização.* -- Gerald
> Weinberg

Parece exagero, mas em muitos casos não é.  Estamos em 2014 e eu ainda ouço
frases como “precisamos cuidar com esse tipo de problema, pois há clientes
usando o servidor de homologação” (não é para isso que serve o ambiente de
homologação).  É o século XXI, mas ainda vejo *strings* serem concatenadas para
gerar *queries* SQL (use parâmetros).

Uma resposta comum a esta frase é que construtores constroem há milhares de
anos, e a nossa profissão existe não faz um século.  Porém, não consigo ver essa
justificativa senão como uma desculpa furada.  Não é como se não existissem os
equivalentes a EPIs e normas de construção.  Nós simplesmente não os usamos
porque... Por que mesmo?

Há ferramentas que simplificam muitos dos processos que uma equipe de
desenvolvedores efetua.  Imagine programar usando apenas o bloco de notas do
Windows.  Agora imagine que muitas equipes ainda estão presas a esse nível de
desenvolvimento tecnológico no que se refere a versionamento, revisões,
compilação, testes e *deployment.*

Existem ferramentas e existe o conhecimento.  Livros como [Code Complete][CC] e
[Pragmatic Programmer][PP] estão aí há pelo menos quinze anos e muitas de suas
lições não foram aprendidas.  Não digo que suas lições foram analisadas e
rejeitadas -- o que seria completamente aceitável --; elas foram apenas
ignoradas.

[CC]: http://en.wikipedia.org/wiki/Code_Complete
[PP]: https://en.wikipedia.org/wiki/The_Pragmatic_Programmer

O conhecimento existe, mas ele não é difundido.  Ele está ali, na forma de
livros, revistas, blogs, vídeos... mas esse conhecimento só é útil na medida em
que consegue alcançar seu público.  E, talvez para alguns soe estranho, mas para
cada programador que tem esse conhecimento, acompanha blogs e agregadores de
notícias, [existem centenas que nem sabem que isso existe][PI].[^fn1][^fn2]

[PI]: http://www.itexto.net/devkico/?p=1799

[^fn1]: Sim, acabei de inventar essa estatística.

[^fn2]: O texto do link é sobre um assunto um pouco diferente.  Fala do
estrelismo em agregadores como Reddit e Hacker News e que existem muitos
programadores que entregam valor usando tecnologias consideradas ultrapassadas,
como Visual Basic e Delphi.  Não discordo dele, mas creio que este meu texto se
aplique também a esse tipo de profissional.  Claro que essas equipes estão
entregando valor, mas imagino que estariam numa situação melhor combinando essas
tecnologias a ferramentas e métodos que permitam desenvolver software melhor e
com menos estresse.  Na verdade, o texto dele até corrobora com essa minha visão
quando mostra que muitas das ideias de trinta anos atrás são reinventadas e
apresentadas como novidade.  Por que nós esquecemos que elas já existiam?

[Parte da responsabilidade por esse desconhecimento é nossa][PNE], mas talvez
exista mais que possa ser feito.  Talvez essas ferramentas não sejam utilizadas
por que são difíceis de serem configuradas?  Talvez a interface delas não seja
amigável?  Talvez esses conhecimentos deveriam ser introduzidos na faculdade?  E
por que os próprios professores não usam mais essas ferramentas?

Para mim, é bastante decepcionante saber que eu poderia desenvolver mais, melhor
e com menos estresse, mas não posso porque... Por que mesmo?

[PNE]: http://www.pedrovereza.com/2014/01/08/programadores-nao-sabem-ensinar.html
