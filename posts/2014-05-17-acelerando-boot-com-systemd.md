---
title: Acelerando o boot com systemd
author: André Ramaciotti
tags: GNU/Linux
---

Quando voltei a usar o [Arch Linux][AL], o tempo de inicialização dele me
surpreendeu.  O systemd -- que também é utilizado por algumas outras distros --
faz milagre e mesmo um computador com um HDD de 5400rpm faz o boot em 12
segundos.  Imagino que, com um SSD, o boot deve ser quase instantâneo.

[AL]: http://archlinux.org/

Porém, com o passar do tempo, esse tempo de inicialização foi subindo.
Inicialmente, tentei justificar isso pelo aumento no número de programas
instalados, possivelmente aumentando o número de *daemons* sendo inicializados.
Depois, passei a considerar a possibilidade de ser o `btrfs` que passei a usar
recentemente.

Finalmente, chegou o ponto em que isso realmente começou a me incomodar.
Lembrei que o systemd possui uma ferramenta própria para analisar o tempo de
boot e a executei.

~~~~
# para um resumo
$ systemd-analyze

# para saber os responsáveis
$ systemd-analyze blame
~~~~

Meu resultado foi condizente com o que a wiki do Arch diz sobre o
[tempo de inicialização aumentar com o passar do tempo][WA].  De forma sucinta,
o `NetworkManager` passa a demorar mais conforme o tamanho do log começa a
aumentar.  Segui os mesmos passos que estão lá e obtive sucesso.  Primeiro,
limpei a pasta com os logs.

[WA]: https://wiki.archlinux.org/index.php/systemd#Boot_time_increasing_over_time

~~~~
# rm /var/log/journal/*
~~~~

Depois, editei o arquivo `/etc/systemd/journal.conf` e configurei `SystemMaxUse`
para usar no máximo 20MB.  Resultado: meu computador voltou a iniciar em 12
segundos, e agora esse problema não deve mais voltar a acontecer[^fn1].

~~~~
$ systemd-analyze
Startup finished in 3.610s (kernel) + 8.799s (userspace) = 12.410s
~~~~

[^fn1]: Por padrão, o journald usa 10% da partição em que estão sendo guardados
os logs.  Como estou usando uma partição `btrfs` só com dois subvolumes (`/` e
`/home`), esses logs podiam chegar a 50GB.  Essa configuração padrão talvez faça
sentido para um servidor, mas para um desktop é exagero e só servia para tornar
a inicialização mais lenta.
