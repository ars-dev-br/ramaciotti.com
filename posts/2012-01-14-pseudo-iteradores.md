---
title: Pseudo-Iteradores como Listas Infinitas
author: André Ramaciotti
tags: C++
---

Uma característica interessante de algumas linguagens de programação é a
possibilidade de se trabalhar com listas com um infinito número de elementos.

Obviamente, é impossível emular esse comportamento em C++ usando qualquer uma
das coleções da STL, já que computar todos os elementos de uma lista infinita
significaria que o programa jamais encerraria.

No entanto, isso não importa muito. Qualquer uma dessas coleções (com exceção
talvez da classe `std::vector`) não será usada diretamente, mas sim através de
iteradores. Sendo assim, pode-se emular o comportamento de uma lista infinita
com um pseudo-iterador que não itera sobre uma coleção pré-computada, mas sim a
vai computando conforme é utilizado.

Abaixo, segue um exemplo de pseudo-iterador que gera infinitos números de
Fibonacci. Outros exemplos de pseudo-operadores que podem ser criados assim são:
uma lista com todos os números naturais, com todos os números triangulares ou
com todos os fatoriais. Outro exemplo, menos matemático, seria a criação de um iterador que lesse um arquivo linha a linha.

~~~~{.Cpp}
#include <algorithm>
#include <iostream>
#include <iterator>

// O correto aqui seria usar a categoria input_iterator_tag, mas isso faz com
// que ocorra um erro de compilação no Visual Studio 2010 no modo Debug, que
// erroneamente verifica se o iterador é bidirecional antes de chamar a função
// std::for_each
class fib_iterator :
    public std::iterator<std::bidirectional_iterator_tag,
                         unsigned int, std::ptrdiff_t,
                         unsigned int*, unsigned int&> {
public:
    fib_iterator(void) {
        prev_ = 0;
        cur_ = 1;
    }

    unsigned int operator*(void) const {
        return cur_;
    }

    fib_iterator& operator++(void) {
        unsigned int tmp = prev_;
        prev_ = cur_;
        cur_ = prev_ + tmp;

        return *this;
    }

    fib_iterator operator++(int) {
        fib_iterator tmp = *this;
        ++(*this);
        return tmp;
    }

    fib_iterator operator+(unsigned int steps) const {
        fib_iterator tmp = *this;
        for(unsigned int i = 0; i < steps; ++i)
            ++tmp;
        return tmp;
    }

    bool operator==(const fib_iterator& other) const {
        return cur_ == other.cur_;
    }

    bool operator!=(const fib_iterator& other) const {
        return !(*this == other);
    }

private:
    unsigned int prev_;
    unsigned int cur_;
};
~~~~

Em seu uso, essa classe não difere muito de um iterador qualquer. O que acontece
é que não se está iterando sobre valores de uma lista já existente, e sim
calculando o próximo elemento a partir do estado atual.

Seguem dois exemplos de como esse iterador poderia ser usado em conjunto com a
função `std::for_each`. Note que não existe efetivamente um iterador final; a
quantidade de iterações que serão feitas é arbitrária e poderia ser tanto menor
que vinte como maior.

~~~~{.Cpp}
int main(int argc, char* argv[]) {
    fib_iterator f;
    std::for_each(f, f + 20, [](unsigned int i) {
        std::cout << i << std::endl;
    });

    std::cout << std::endl;

    unsigned int soma = 0;
    std::for_each(f, f + 20, [&soma](unsigned int i) {
        soma += i;
    });

    std::cout << "soma: " << soma << std::endl;
}
~~~~
