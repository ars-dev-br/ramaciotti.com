---
title: Linux, Netbeans e Tomcat
author: André Ramaciotti
tags: GNU/Linux, Java
---

Para um projeto da faculdade, o professor pediu que fosse usado o Netbeans como
IDE e o Tomcat como servidor.  Como cheguei a um ponto da graduação em que
desisti de tentar convencer os professores a enxergarem a luz e começarem a usar
o Emacs, resolvi usar as ferramentas que o professor sugeriu.

~~~~{.sh}
$ sudo pacman -S netbeans tomcat8
~~~~

Porém, na hora de configurar o Netbeans 8.0 para usar a versão de Tomcat
instalada, uma surpresa: o pacote do Tomcat é dividido: uma parte fica em `/usr`
(os binários e bibliotecas) enquanto que outra parte fica em `/var` (arquivos de
configuração e conteúdo dos sites).

Isso está correto, mas o Netbeans não se entende muito bem com essa divisão.  O
recomendado, então, é baixar o Tomcat do [próprio site][AT], descompactá-lo e
configurar o Netbeans para usá-lo dessa pasta.

[AT]: http://tomcat.apache.org/download-80.cgi
