# Bot télégram avec notif quand disque/partition serveur full
Source initiale: https://forum.virtualmin.com/t/how-to-receive-telegram-message-when-partition-storage-is-getting-full/112125

## Créer un bot télégram et récupérer les infos d'utilisation

* Il suffit de lancer un dialogue avec bot_father
* Puis créer un nouveau bot et bien noter le token/key
* Ensuite on lance une conversation avec le bot
* On se rend sur cett url (pour récupérer le chat Id) : https://api.telegram.org/bot<YourBOTToken>/getUpdates
* Enusite on lui envoi un message de test
* Et là on peut récupérer le chat ID (que l'on conserve)

## Modification des scripts récupérés et fonctionnement du bot télégram

* On récupère les fichiers

``` bash
git clone https://github.com/dsumon/bottelegram.git
cd bottelegram
```

* On modifie le premier fichier "telegram-notify"

``` bash
# Configuration file
FILE_CONF="/path/bottelegram/telegram-notify.conf"
```

* On personnalise le second "telegram-notify.conf"

``` bash
[general]
api-key=xxx:xxxx #letokenAPIBot
user-id=1744001323 #leChatID
```

* On vérifie que le push sur télégram via le bot est ok

``` bash
bash /path/telegram-notify --success --text "Action *sucessful* with markdown *bold* example"
```

* Et on termine avec le script qui sera éxécuté et permettera de faire le check "storage-warning-telegram.sh"

``` bash
#!/bin/bash
CURRENT=$(df | grep -Ev '/dev/sda15' | grep 'dev/sda1' | awk '{print $5}' | sed 's/%//g')
#CURRENT=$(df | grep 'dev/sda' | awk '{print $5}' | sed 's/%//g')
#CURRENT=$(cd /home/xxx && du -hs | sed -e 's/[^0-9]//g')
THRESHOLD=90
HOSTNAME=$(echo 'xxx - xxx')

if [ "$CURRENT" -gt "$THRESHOLD" ] ; then
    . /home/path/bottelegram/telegram-notify --error --title "Disque Plein $HOSTNAME" --text "Partition /dev/sda1 > 90%. Utilisé: $CURRENT%"
fi
```

On modifie la partie "CURRENT" avec la partition/chemin qu'on souhaite vérifier.
Pour connaître les partitions :
``` bash
df -h
```

On s'assure que le "grep" et "sed" fonctionne bien et renvoi un seul chiffre sur une seule ligne (important sinon erreur)

``` bash
df | grep -Ev '/dev/sda15' | grep 'dev/sda1' | awk '{print $5}' | sed 's/%//g'
```

On modifie le THRESHOLD (limite) (on peut mettre 2 et on remettera ensuite 90 une fois ok), on personnalise le HOSTNAME

On modifie le path pour le script télégram et on personnalise si besoin le message.

* On rend éxécutable le script et on le test

``` bash
chmod +x storage-warning-telegram.sh
```

``` bash
bash storage-warning-telegram.sh
```

* On met en place un cron pour lancer ce fichier tous les x temps

``` bash
crontab -e
```

``` bash
0 5 * * * cd /path/bottelegram && ./storage-warning-telegram.sh >> /dev/null 2>&1
```

On lance le script tous les jours à 5h du matin.

On pense bien à modifier la limite pour l'alterte (THRESHOLD)
