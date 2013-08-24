---
title: O que são Monads
author: André Ramaciotti
tags: Haskell, Programação Funcional
---

Um dos primeiros desafios para quem está começando a estudar Haskell (e outras
linguagens funcionais) são as *monads*.  Elas costumam causar tanta confusão
que, na maioria dos livros sobre Haskell, operações de entrada e saída aparecem
apenas na segunda metade (já que dependem da *monad* `IO`).  Neste texto
tentarei explicar o que elas são de uma maneira informal.  Não entrarei nos
formalismos da Teoria das Categorias, mas espero dar uma ideia geral de seu uso.

A primeira coisa a se ter em mente é que as funções que escrevemos representam
computações.  O tipo de computação mais simples são as funções puras: elas
recebem um argumento e retornam um valor.  Um fator importante para que uma
função seja considerada pura é que, para toda vez que ela for executada com o
mesmo argumento, ela deve retornar o mesmo valor.

Porém, nem toda computação cabe nesse modelo.  Algumas computações podem falhar,
outras podem retornar diversos resultados válidos, e outras podem depender de
algum estado interno do programa ou de algum estado externo a ele, como o
horário e arquivos.

É aí que entram as *monads*.  Elas representam esse tipo de computação que não
pode ser representado através de funções puras.  Os exemplos do parágrafo
anterior estão relacionados, respectivamente, às *monads* `Maybe`, `List` (ou
`[]`), `State` e `IO`.  Elas não são as únicas, dentre os módulos que compõem o
GHC existem outras, e podem ser combinadas entre si.

A maioria desses tipos de computação fazem parte do nosso cotidiano como
programadores, mas não pensamos neles como tendo algo de especial.  O que
Haskell faz com seu uso explícito de *monads* é deixar claros os mecanismos que
certas partes do programa precisam para poder funcionar corretamente.

Não só isso, mas também o programador se vê obrigado a modularizar melhor seu
código.  Como é difícil escrever uma função que dependa de diversas *monads*, é
melhor ele separar cada uma dessas partes em funções diferentes e mais simples.

