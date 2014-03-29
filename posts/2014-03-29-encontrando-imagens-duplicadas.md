---
title: Encontrando imagens duplicadas
author: André Ramaciotti
tags: GNU/Linux
---

Eu tenho o vício de colecionar *wallpapers.*  Chega quase a ser uma obsceção, e
já passei da faixa de 200 imagens com esse propósito.  Como não poderia deixar
de ser, de vez em quando aparecem algumas imagens duplicadas, e resolvi achar um
jeito de removê-las.

Encontrei um programa chamado `findimagedupes`, escrito em Perl e que utiliza o
ImageMagick para fazer uma sequência de operações até chegar a uma “impressão
digital” de cada papel de parede e compará-las.  Esse procedimento é melhor que
calcular o MD5 (ou o SHA) de cada imagem, já que ele consegue encontrar
duplicatas mesmo que o formato do arquivo seja diferente ou a resolução não seja
a mesma.

Os passos são:

1. Ler a imagem;
1. Reduzi-la para 160x160;
1. Transformá-la em tons de cinza reduzindo a saturação;
1. Borrá-la, para reduzir ruído;
1. Normalizar os tons de cinza para deixá-los bem distribuídos;
1. Equalizar a imagem para deixá-la com o máximo de contraste;
1. Reduzi-la novamente, agora para 16x16;
1. Transformá-la em preto e branco (1 bit por pixel).

Isso dá origem à impressão digital de uma imagem.  Depois, para compará-las:

1. Aplica a operação *xor* entre as duas impressões digitais;
1. Calcula a porcentagem de 1 no resultado;
1. Se a porcentagem for maior que um limite, as imagens são consideradas
   similares.

Ao final do processo, o programa imprime uma tabela de imagens e imagens
similares.  Note, no entanto, que esse processo não é perfeito, então compensa
verificar se as imagens são realmente a mesma.

Uma característica interessante desse programa é que é possível criar um arquivo
com as impressões digitais calculadas anteriormente.  Assim, a próxima vez que
ele for executado, ele terá bem menos trabalho.

Para lembrar as opções que utilizei, criei o *shell script* abaixo:

~~~~{.sh}
#!/bin/sh

WPDIR=~/Pictures/Wallpapers
findimagedupes --fingerprints=.fingerprints.db --prune --recurse -- $WPDIR
~~~~
