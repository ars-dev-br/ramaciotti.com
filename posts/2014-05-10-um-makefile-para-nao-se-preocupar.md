---
title: Um Makefile para não se preocupar mais
author: André Ramaciotti
tags: C, C++
---

Mesmo para projetos relativamente pequenos, acho de bom tom escrever um
`Makefile` que descreva como um projeto deve ser compilado.  Porém, num momento
inicial, isso pode ser cansativo e improdutivo.  Dependendo de como o Makefile
for escrito, ele deverá ser alterado para cada arquivo `.c` ou `.cpp` que for
criado (ou removido).

Um jeito de simplificar isso é utilizar *globs.*  O `Makefile` que tenho usado
como template está abaixo.  Ele compila todos os arquivos `.cpp` existentes no
diretório e depois os *linka,* gerando o executável.

~~~~{.Makefile}
CPP = g++
CPPFLAGS = -O2 -Wall -Wextra -c -g --std=c++11
LDFLAGS =
LIBS = -lm -lGL -lglut -lGLU

DEPS = $(wildcard *.hpp)
SOURCES = $(wildcard *.cpp)
OBJECTS = $(SOURCES:.cpp=.o)
EXECUTABLE = n3

.PHONY: all clean

all: $(SOURCES) $(EXECUTABLE)

$(EXECUTABLE): $(OBJECTS)
	$(CPP) $(LDFLAGS) $(LIBS) $(OBJECTS) -o $@

.cpp.o: $(DEPS)
	$(CPP) $(CPPFLAGS) $< -o $@

clean:
	rm $(EXECUTABLE) *.o

~~~~

As variáveis são:

- **CPP**: o compilador utilizado.
- **CPPFLAGS**: opções de compilação, como otimização, se símbolos de *debug*
  devem ser gerados etc.
- **LDFLAGS**: opções de *linker.*
- **LIBS**: bibliotecas utilizadas.  Neste caso, estão presentes algumas
  bibliotecas do OpenGL.
- **EXECUTABLE**: o nome do executável gerado no final do processo.

O resto, o `make` faz sozinho.  Ele considera todos os arquivos `.hpp` como
dependências (DEPS), os arquivos `.cpp` como arquivos fontes que serão
compilados (SOURCES) e, para cada arquivo `.cpp`, ele sabe que será gerado
objeto com o mesmo nome, mas com a extensão `.o`.
