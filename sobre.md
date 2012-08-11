---
title: Sobre
author: André Ramaciotti
---

Sobre o Autor
-------------

[<img class="pull-right" alt="qrcode com informações de contato" src="/img/ramaciotti.vcard.png" width="210" height="210"/>][VCF]

Meu nome é André Ramaciotti da Silva. Nasci em 1990 em São Paulo, onde cresci e
tomei gosto por programação, música e a aprender idiomas estrangeiros.

Atualmente, moro em Blumenau. Curso Ciência da Computação na [FURB][F] e
trabalho na [WK Sistemas][WK] desde 2010. Já passei por diversas áreas, da
*Quality Assurance* à programação em C++, C# e Javascript.

No momento, sou responsável pela área de treinamento técnico, ensinando C++ e
avaliando os estagiários de programação da empresa. Além disso, participo da
melhoria dos processos de desenvolvimento.

[Chave pública (rsa)][RSA]

Sobre o Site
------------

Este site é construído sobre diversas bibliotecas open source. As duas
principais são o [Hakyll][H] e o [Bootstrap][BS]. O primeiro me permite
escrever os artigos em formatos mais agradáveis de serem escritos (como
*markdown,* por exemplo) e os converte em HTML. Além disso, ele é o responsável
por atualizar automaticamente coisas como a página inicial. O segundo ajuda bastante na apresentação visual do site.

Além deles, utilizo também a [Font Awesome][FA], para os ícones que aparecem na
barra de navegação, e o plugin [timeago][TA] para o [jQuery][JQ], que troca as
datas no texto por mensagens como “há 5 meses”. Outra biblioteca que utilizo é a [Code Prettify][CP] da Google, para o *highlighting* dos códigos de exemplo.

O código fonte do site está disponível no meu [github][GH], no repositório
[ramaciotti.com][GHR].

Sobre Software
--------------

Procuro ser pragmático em minhas escolhas, mas não escondo minha preferência
por software livre. Meus computadores rodam [Ubuntu][U] e desenvolvo usando o
shell (zsh com [oh-my-zsh][OMZ]) e algum editor de textos (emacs ou vim,
dependendo do caso).

Os projetos em que estou trabalhando atualmente podem ser acessados pelo meu
[github][GH].

[BS]: http://twitter.github.com/bootstrap/
[CP]: http://code.google.com/p/google-code-prettify/
[F]: http://www.furb.br/
[FA]: http://fortawesome.github.com/Font-Awesome/
[GH]: http://github.com/ramaciotti
[GHR]: https://github.com/ramaciotti/ramaciotti.com
[H]: http://jaspervdj.be/hakyll/
[JQ]: http://jquery.com/
[OMZ]: https://github.com/robbyrussell/oh-my-zsh
[RSA]: /files/ramaciotti.pub
[TA]: http://timeago.yarp.com/
[U]: http://ubuntu.com/
[VCF]: /files/ramaciotti.vcard
[WK]: http://www.wk.com.br/

<script src="/js/jquery-1.8.0.min.js"></script>
<script>
$(function () {
  $(".icon-globe").parent().parent().removeClass("active");
  $(".icon-user").parent().parent().addClass("active");
});
</script>
