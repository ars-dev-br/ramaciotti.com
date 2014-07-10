---
title: Postmortem: CG N3 e N4
author: André Ramaciotti
tags: C++, OpenGL, Postmortem
---

Seguindo com minha série de [postmortes][P], falarei um pouco sobre dois
trabalhos de computação gráfica que fiz este semestre.  Eles foram feitos em C++
e usam a *pipeline* fixa do OpenGL.  Esse modo de renderização foi declarado
obsoleto em 2008, com o lançamento da especificação do OpenGL 3, mas ainda faz
sentido num contexto educacional.  A *pipeline* fixa é mais simples de ser
explicada e não depende de uma placa de vídeo relativamente recente.

[P]: http://www.ramaciotti.com/tags/Postmortem.html

O [primeiro projeto][PP] -- da terceira avaliação (N3) -- é uma aplicação para
trabalhar o desenho de polígonos simples, seleção de objetos gráficos e
aplicação de transformações.  O [segundo][SP] é um pequeno jogo de corrida e
trabalha com 3D, iluminação e texturas.

[PP]: https://github.com/ramaciotti/cg-n3
[SP]: https://github.com/ramaciotti/racing

Em geral, a arquitetura dos dois projetos segue o mesmo princípio: evitei
ponteiros ao máximo em ambos e deleguei a alocação de memória para coleções,
como o `std::vector`.  Esta é a melhor forma de se evitar *dangling pointers* e
vazamento de memória, embora não seja sempre viável.  Nisso, acho que fui bem
sucedido.

Dada a complexidade que um projeto em C++ pode alcançar, este é um conselho que
deve ser seguido com mais cuidado nessa linguagem: faça tudo da forma mais
simples que possa funcionar.  É muito fácil se perder em meio a alocação manual
de memória, herança múltipla, sobrecarga de operadores etc.

Por outro lado, a separação entre a lógica da aplicação e a parte gráfica não
ficou tão boa.  Isso é particularmente perceptível no segundo projeto, em que
diversas classes possuem um método `render`.  Imagine o que aconteceria se eu
quisesse trocar a forma de renderização, para uma versão mais moderna de OpenGL
ou para DirectX: eu teria de passar classe por classe e alterar todos os métodos
`render`.

Com a aproximação do final do semestre, comecei a pesquisar como essa separação
pode ser feita e cheguei a artigos como [este][SORT].  Desta forma, a thread
principal trabalha enviando comandos para um buffer disponibilizado pelo
*renderer.* Ele, por sua vez, [organiza esses comandos][Q3S] e os
[renderiza][Q3R].  O renderizador do Quake 3 é um bom exemplo de como isso foi
implementado, a [uma análise mais aprofundada][FS] de como ele funciona foi
feita pelo Fabien Sanglard.

[SORT]: http://realtimecollisiondetection.net/blog/?p=86
[Q3S]: https://github.com/id-Software/Quake-III-Arena/blob/master/code/renderer/tr_main.c#L1454
[Q3R]: https://github.com/id-Software/Quake-III-Arena/blob/master/code/renderer/tr_backend.c#L1075
[FS]: http://fabiensanglard.net/quake3/
