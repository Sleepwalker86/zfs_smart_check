* * * * *

ZFS und SMART Check Script
==========================

Dieses Bash-Skript dient zur regelmäßigen Überprüfung von ZFS-Pools und der SMART-Daten von Festplatten. Es protokolliert die Ergebnisse und sendet bei erkannten Fehlern eine Benachrichtigung per E-Mail.

* * * * *

Features
--------

-   **ZFS-Pool-Prüfung**: Analysiert den Zustand der ZFS-Pools und meldet, wenn ein Pool nicht `ONLINE` ist.
-   **SMART-Überprüfung**: Führt eine SMART-Prüfung für alle Festplatten durch und warnt bei potenziell problematischen Werten.
-   **Protokollierung**: Speichert die Ergebnisse in einer Log-Datei.
-   **E-Mail-Benachrichtigung**: Sendet bei Fehlern eine E-Mail mit den Details.

* * * * *

Voraussetzungen
---------------

### 1\. Software-Installationen

Das Skript benötigt die folgenden Tools:

-   **ZFS-Utilities**: Für die ZFS-Befehle (`zpool`).
-   **Smartmontools**: Zum Abrufen von SMART-Daten.
-   **Sendmail**: Zum Versenden von E-Mail-Benachrichtigungen. Postfix muss bereits auf eurem System konfiguriert sein!

Installation der erforderlichen Pakete:

```
sudo apt update
sudo apt install zfsutils-linux smartmontools sendmail

```

### 2\. Benutzerberechtigungen

Das Skript erfordert Root-Berechtigungen, da `zpool` und `smartctl` administrative Rechte benötigen.

* * * * *

Konfiguration
-------------

### E-Mail-Adresse

Passen Sie die E-Mail-Adresse für Benachrichtigungen an:

```
EMAIL="your_email@email.de"

```

### Log-Datei

Das Skript speichert alle Ausgaben in einer Log-Datei:

```
LOG_FILE="/root/zfs_smart_check.log"

```

* * * * *

Funktionsweise
--------------

### ZFS-Prüfung

-   Überprüft den Zustand der Pools mit `zpool status -x`.
-   Analysiert den Status jedes Pools, um sicherzustellen, dass er `ONLINE` ist.
-   Bei Problemen wird ein entsprechender Warnhinweis ausgegeben.

### SMART-Überprüfung

-   Führt einen SMART-Health-Check für alle Festplatten durch (`smartctl -H`).
-   Prüft problematische Attribute wie:
    -   **Reallocated Sector Count**
    -   **Current Pending Sector**
    -   **Offline Uncorrectable**
-   Gibt Warnungen aus, wenn kritische Schwellenwerte überschritten werden.

### Protokollierung

-   Alle Ergebnisse werden in der angegebenen Log-Datei gespeichert.

### E-Mail-Benachrichtigung

-   Bei erkannten Fehlern werden die Log-Datei und eine Warnung per E-Mail an die konfigurierte Adresse gesendet.
-   Bei fehlerfreiem Zustand wird keine E-Mail gesendet.

* * * * *

Installation und Verwendung
---------------------------

### 1\. Skript bereitstellen

Speichern Sie das Skript unter einem geeigneten Pfad, z. B. `/root/zfs_smart_check.sh`.

### 2\. Ausführungsrechte vergeben

Machen Sie das Skript ausführbar:

```
chmod +x /root/zfs_smart_check.sh

```

### 3\. Manuelle Ausführung

Führen Sie das Skript manuell aus:

```
sudo /root/zfs_smart_check.sh

```

### 4\. Automatisierung (optional)

Um die Prüfung regelmäßig durchzuführen, richten Sie einen Cron-Job ein:

```
sudo crontab -e

```

Fügen Sie folgende Zeile hinzu, um die Prüfung täglich um 2:00 Uhr auszuführen:

```
0 2 * * * /root/zfs_smart_check.sh

```

* * * * *

Fehlerbehebung
--------------

### Fehler bei `zpool` oder `smartctl`

-   Stellen Sie sicher, dass die ZFS- und SMART-Tools installiert sind.
-   Prüfen Sie, ob die Festplatten SMART-Unterstützung bieten.

### E-Mail-Versand schlägt fehl

-   Stellen Sie sicher, dass `sendmail` korrekt konfiguriert ist.
-   Testen Sie den E-Mail-Versand manuell:

```
echo "Test" | sendmail -v your_email@email.de

```

* * * * *

Warnungen
---------

-   Das Skript setzt voraus, dass alle verwendeten Festplatten und Pools korrekt eingerichtet sind.
-   Regelmäßige Tests und Überprüfungen der E-Mail-Benachrichtigung werden empfohlen.

* * * * *

Erweiterungsmöglichkeiten
-------------------------

-   Hinzufügen von spezifischen Prüfungen für weitere SMART-Attribute.
-   Integration von Benachrichtigungen über andere Dienste wie Slack oder Telegram.
-   Verbesserte Protokollierung für detailliertere Analysen.

* * * * *

Lizenz
------

Das Skript steht unter der **MIT-Lizenz**, wodurch es frei verwendet, verändert und verteilt werden darf, sofern die ursprüngliche Urheberschaft angegeben wird.

```
MIT License

Copyright (c) 2024 [Sascha Moritz]

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

```

* * * * *

Autor
-----

Dieses Skript wurde erstellt, um eine zuverlässige Überwachung von ZFS-Pools und Festplatten auf Systemen mit SMART-Unterstützung zu ermöglichen. Anpassungen und Erweiterungen können frei vorgenommen werden.
