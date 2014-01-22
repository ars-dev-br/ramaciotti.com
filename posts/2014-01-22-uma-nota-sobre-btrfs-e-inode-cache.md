---
title: Uma nota sobre Btrfs e inode_cache
author: André Ramaciotti
tags: GNU/Linux
---

Recentemente, converti minhas partições de `ext4` para `btrfs` e usei a opção
`inode_cache` na hora de montar.  Infelizmente, existe algum problema nessa
opção, e o filesystem recriava o cache de inodes boot sim, boot não.

Como resultado, às vezes meu X dava timeout, já que ele não conseguia carregar
tudo que era necessário a tempo.  Se você estiver encontrando problemas do tipo,
edite seu `/etc/fstab` e tire essa opção.
