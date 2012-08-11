---
title: Falhas de Abstração
author: André Ramaciotti
tags: Haskell
---

A ideia para este artigo veio enquanto eu resolvia o primeiro problema do [Project Euler][PE]. Ele é bastante simples – somar todos os múltiplos de 3 ou 5 menores que 1000 – e pode ser resolvido com basicamente uma linha de Haskell:

~~~~{.Haskell}
module Main where

main = putStrLn $ show $ sum $ filter (\x -> x `mod` 3 == 0 || x `mod` 5 == 0) $ takeWhile (<1000) [1..]
~~~~

Ele é rápido o suficiente para que não se pare para pensar nisso, mas o quão eficiente ele realmente é? Compilando e executando o programa com o *profiler* ligado, podemos ver que ele alocou cerca de 400 *kilobytes* para fazer uma tarefa simples como essa.

~~~~
$ ghc -prof -fprof-auto -rtsopts 01.hs
$ ./01 +RTS -p
~~~~

Investigando melhor o código escrito, percebe-se que ele é proporcional a *n,* tanto no que se refere ao tempo de execução como ao consumo de memória. No entanto, não há nada durante a criação do programa que exija que essa análise seja feita.

Este não é um problema exclusivo da linguagem Haskell ou da programação funcional, mas de qualquer processo que seja abstraído de alguma forma. O mesmo problema pode aparecer, por exemplo, caso se abuse de LINQ num programa escrito em C#.

A abstração facilita bastante a compreensão e solução de um problema, mas não se pode esquecer que, em algum momento, essa mágica será desfeita e que se terá de voltar ao mundo real. Não importa o quão fácil ou *elegante* seja essa solução inicial, no final do dia ainda será um bom e velho computador executando código de máquina que irá computar o resultado desejado.

Pode-se melhorar em muito a solução desse problema com um novo código, que executa em tempo e que ocupa espaço constantes. A nova versão é bem mais complexa que a anterior, mas ainda está longe de ser um programa escrito em *assembly* usando Haskell.

~~~~{.Haskell}
module Main
    where

import Data.List

type Range = (Int, Int)
data Progression = Progression !Int !Int !Int

-- Makes a correct progression using range [begin,end)
makeProgression :: Range -> Int -> Progression
makeProgression (begin, end) diff | end `mod` diff == 0 = Progression begin (end - diff) diff
                                  | otherwise           = Progression begin end' diff
    where
      end' = end - (end `mod` diff)

sumProgression :: Progression -> Int
sumProgression (Progression begin end diff) = (begin + end) * n `div` 2
    where
      n = ((end - begin) `div` diff) + 1

sumOfMultiples :: Range -> [Int] -> Int
sumOfMultiples _ [] = 0
sumOfMultiples r [x] = sumProgression $ makeProgression r x
sumOfMultiples r xs = sum . map (sumOfMultiples') . subsequences $ xs
    where
      sumOfMultiples' [] = 0
      sumOfMultiples' [x] = sumProgression $ makeProgression r x
      sumOfMultiples' xs = - (sumProgression $ makeProgression r $ product xs)

main = print $ sumOfMultiples (0, 10000) [3, 5]
~~~~

PS: Quando terminava de escrever este artigo, percebi que a ideia apresentada nele é bastante similar à de [leaky abstractions][LA], de Joel Spolsky. Não gosto de repetir o que já falaram, mas para não perder o artigo que já estava escrito, resolvi colocar esta nota no final.

[PE]: http://projecteuler.net
[LA]: http://www.joelonsoftware.com/articles/LeakyAbstractions.html
