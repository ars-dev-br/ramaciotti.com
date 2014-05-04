---
title: Escrevendo código modular em C
author: André Ramaciotti
tags: C, Programação
---

Sem boa parte das *features* presentes em linguagens mais modernas para
organizar código -- como *namespaces/packages* e classes -- escrever um programa
bem organizado em C pode ser um desafio para quem não está habituado.  Porém,
boa parte dessas técnicas utilizadas também se aplica nesta linguagem, ainda que
não seja tão aparente num primeiro momento.

Talvez um dos pontos mais importantes seja tratar cada par de arquivos `.h` e
`.c` como um módulo, com uma interface pública e uma implementação privada.  No
cabeçalho, estarão presentes os protótipos das funções e outras declarações que
poderão ser utilizadas pelo restante do sistema, como estruturas e enumerações.
Já no arquivo `.c`, estará a implementação de qualquer coisa referente a esse
módulo: as funções públicas e, possivelmente, algumas funções privadas.
Geralmente, essas funções privadas são marcadas com a palavra-chave `static`,
avisando ao compilador que elas só são acessíveis dentro daquele arquivo e
evitando conflitos de nomes durante a compilação.

Para exemplificar, considere que estamos escrevendo um módulo capaz de compactar
e descompactar arquivos `.zip`.  Sua interface pública provavelmente seria
simples, como o arquivo `.h` abaixo.

~~~~{.c}
/* compactacao.h */

#ifndef COMPACTACAO_H
#define COMPACTACAO_H

/* Estas duas funções são públicas e poderão ser chamadas de outras partes do
   programa. */
int compactar(const char* diretorio, const char* arquivo_zip);
int descompactar(const char* arquivo_zip, const char* diretorio);

#endif
~~~~

Por outro lado, a implementação seria mais complexa, incluindo a definição das
funções declaradas acima e qualquer outra função auxiliar que seja necessária.

~~~~{.c}
/* compactao.c */

#include "compactacao.h"

#include <stdbool.h>
#include <stdlib.h>

/* Estas duas funções são privadas e só podem ser utilizadas neste arquivo */
static bool arquivo_valido(const char* arquivo);
static size_t tamanho_arquivo(const char* arquivo);

int compactar(const char* diretorio, const char* arquivo_zip) {
    /* ... */
}

int descompactar(const char* arquivo_zip, const char* diretorio) {
    /* ... */
}

static bool arquivo_valido(const char* arquivo) {
    /* ... */
}

static size_t tamanho_arquivo(const char* arquivo) {
    /* ... */
}
~~~~

Outra técnica bastante utilizada e bastante útil é tratar cada módulo como algo
próximo à definição de uma classe.  Em conjunto com ponteiros opacos, isso
permite fazer o encapsulamento de dados de forma bastante similar ao que ocorre
na orientação a objetos, deixando a desejar apenas o polimorfismo.

Para isso, na interface do módulo, declara-se o nome que a estrutura terá e que
funções serão utilizadas para manipulá-la.  Por exemplo, se o nosso módulo
trabalhasse com arquivos `.bmp`, teríamos algo como o arquivo abaixo.

~~~~{.c}
/* bitmap.h */

#ifndef BITMAP_H
#define BITMAP_H

#include <stdint.h>
#include <stdlib.h>

struct bitmap_t;

struct bitmap_t* bitmap_create(uint32_t width, uint32_t height);
void bitmap_set_color(struct bitmap_t* bitmap, uint32_t row, uint32_t col,
	struct color24_t color);
size_t bitmap_size(const struct bitmap_t* bitmap);
void bitmap_destroy(struct bitmap_t* bitmap);

#endif
~~~~

Isso cria uma definição de tipo parcial, `bitmap_t`.  Ela pode ser utilizada no
protótipo de funções, mas outras partes do programa não poderão acessar as
variáveis que a compõem.  Qualquer alteração ou qualquer informação que se
queira obter dessa estrutura terá de ser feita através de uma das funções
disponibilizadas.

O tipo só é definido completamente no arquivo `.c` onde as funções também são
definidas.

~~~~{.c}
/* bitmap.c */

#include "bitmap.h"

#include <stdint.h>
#include <stdlib.h>

struct bitmap_t {
    /* ... */
}

struct bitmap_t* bitmap_create(uint32_t width, uint32_t height) {
    /* ... */
}

void bitmap_set_color(struct bitmap_t* bitmap, uint32_t row, uint32_t col,
	struct color24_t color) {
    /* ... */
}

size_t bitmap_size(const struct bitmap_t* bitmap) {
    /* ... */
}

void bitmap_destroy(struct bitmap_t* bitmap) {
    /* ... */
}
~~~~

Em resumo, é isso: trate seu sistema como diversos subsistemas que se comunicam
através de interfaces públicas e utilize tipos que são encapsulados através de
ponteiros opacos.
