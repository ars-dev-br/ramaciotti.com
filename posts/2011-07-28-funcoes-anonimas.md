---
title: Funções Anônimas em C
author: André Ramaciotti
tags: C
---

Quem conhece funções anônimas (também conhecidas por expressões lambda) de
outras linguagens talvez já tenha sentido sua falta quando resolvendo certos
problemas em C[^l1].

[^l1]: Com a chegada do padrão C++11, isso deixou de ser um problema para
programadores C++, mas mesmo o vindouro padrão C1X não faz qualquer referência a
funções anônimas.

Porém, se seu projeto só será compilado usando o compilador GNU, uma boa parte
de seus problemas pode ser resolvida com a utilização de um macro e de duas
extensões. O uso dessas extensões significa que seu código deixará de seguir o
padrão ISO e, portanto, **deixará de ser portável**. Se isso é um problema ou
não, você que deverá julgar.

Primeiramente, o macro:

~~~~ {.C}
#define lambda(return_type, args_and_body) \
    ({                                     \
        return_type __fn__ args_and_body   \
        &__fn__;                           \
    })
~~~~

Pouco da mágica realmente acontece nele, ele serve apenas para facilitar um
pouco nosso trabalho. Abaixo, um exemplo de como chamá-lo e no que ele se
expande:

~~~~ {.C}
int (*max)(int, int) = lambda(int, (int a, int b) {
         return a > b ? a : b;
    });

int (*max)(int, int) = ({
    int __fn__ (int a, int b) {
        return a > b ? a : b;
    }
    &__fn__;
    });
~~~~

Analisando o código de cima para baixo, encontra-se o par de caracteres `({`,
fechado na última linha do código por seu inverso, `})`. Isso faz parte da
primeira extensão usada, [Statements and Declarations in Expressions][SDE]. Com
ela, pode-se criar um novo escopo, da forma similar ao que acontece quando se
usa `{` `}`, com a diferença de que o último *statement* será usado como valor
de retorno (apesar de não se utilizar a palavra-chave `return`).

[SDE]: http://gcc.gnu.org/onlinedocs/gcc/Statement-Exprs.html

Logo em seguida, vê-se a definição de uma função, chamada `__fn__`, de tipo
`return_type` e definida por `args_and_body`. No entanto, só se pode defini-la
aí por causa da segunda extensão utilizada, [Nested Functions][NF]. Com essa
extensão, podem-se definir funções dentro de outras funções, funções dentro de
`ifs`, dentro de expressões compostas (como neste caso) etc.

[NF]: http://gcc.gnu.org/onlinedocs/gcc/Nested-Functions.html


Juntando tudo, o que se está fazendo é definindo uma nova função, `__fn__`, que
tem como escopo apenas um pequeno bloco e retornando seu endereço com `&__fn__`.

Porém, esta solução não “captura” as variáveis num escopo léxico (não cria uma
*closure)*, o que pode trazer alguns problemas. Por exemplo, o código abaixo
funciona sem problemas, já que a função lambda é executada enquanto a variável
`soma` ainda está dentro de seu escopo.

~~~~{.C}
#include <stdio.h>
#define lambda(return_type, body_and_args) \
    ({                                     \
        return_type __fn__ body_and_args   \
            &__fn__;                       \
    })

void map(int array[], int n, int (*fn)(int)) {
    int i;
    for(i = 0; i < n; i++)
        array[i] = (*fn)(array[i]);
}

int main() {
    int array[] = {1, 2, 3, 4};
    int soma = 0;

    map(array, 4, lambda(int, (int x) {
                soma += x;
                return x;
            }));
    printf("%d\n", soma);

    return 0;
}
~~~~

Por outro lado, a função abaixo não funcionará:

~~~~{.C}
#include <stdio.h>
#define lambda(return_type, body_and_args) \
    ({                                     \
        return_type __fn__ body_and_args   \
            &__fn__;                       \
    })

int (*adder(int what))(int) {
    return lambda(int, (int x) {
            int __inc = what;
            return x + __inc;
        });
}

int main() {
    int (*inc1)(int) = adder(1);
    printf("%d\n", inc1(1));
    printf("%d\n", inc1(1));
    return 0;
}
~~~~

Quando `inc1` é chamada, `adder` já terminou de ser executada e `what` não está
mais em escopo. O resultado, portanto, é indefinido. Aqui, a primeira chamada
funciona normalmente, mas a segunda causa uma *segmentation fault*.

Na lista de discussão comp.lang.c (segundo link das fontes), há uma outra forma
de se tentar fazer isso (SPOILER: que também não funciona).

Fontes: [lambdas-in-c][LIC], [Lambdas in GCC][LIG]

[LIC]: http://walfield.org/blog/2010/08/25/lambdas-in-c.html
[LIG]: http://groups.google.com/group/comp.lang.c/browse_thread/thread/fd82dc3d97ea87ff/8b01e62f2feae4f0?lnk=gst&pli=1

