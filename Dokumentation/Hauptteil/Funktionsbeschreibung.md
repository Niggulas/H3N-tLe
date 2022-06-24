# Funktionsbeschreibung

## Ordnerstruktur

Sämmtliche Ordner und Dateien auf die die App zugreift sind in ihrem "Documents" Ordner.
Direkt "Documents" untergeordnet sind der "Library" und der "PlugIns" Ordner.
Dem "Library" Ordner sind wiederum die Comic Ordner direkt untergeordnet, die wiederum die Kapitel Ordner enthalten.
Direkt dem "PlugIns" Ordner untergeordnet sind die Ordner der einzelnen PlugIns, die wiederum beliebig viele Unterordner haben können, die beliebig verschachtelt sein können.

## Comics

Comics werden von Instanzen der Series Klasse repräsentiert.
Jeder Comic Ordner enthält eine "info.json" Datei.
"info.json" Dateien müssen ein JSON objekt das einen "title" Schlüssel und dazugehörigen Wert vom Typ String haben, ansonsten schlägt das erstellen einer Instanz der Series Klasse für den Ordner fehl.
Eine "info.json" Datei kann optional auch die folgenden Werte als String enthalten (Schlüssel in den Klammern):

- die Beschreibung (description)
- den Status (status)
- den Namen der Datei die das Titlebild enthält (cover)
- das zuletzt gelesene Kapitel (last_read_chapter)
- die URL zum zuletzt heruntergeladenen Kapitel (url)

Die dem Comic Ordner untergeordneten Ordner werden von Instanzen der Series Klasse mit deren Namen als Kapitel aufgelistet und bei anfrage nach den URLs zu den Bildern eines Kapitels zu sämmtlichen Dateien im Kapitel Ordner URLs zurückgegeben.
Die Bilder in den Kapitel Ordnern sollten von 0 an nummeriert damit die URLs zu ihnen in der korrekten Reihenfolge zurückgegeben werden können, dies wird allerdings nicht überprüft es ist also auch möglich A bis Z zu verwenden oder etwas anderes was der Sortieralgorythmus in die richtige Reihenfolge bringt.

## Library

Der "LibraryTab()" greift, um die Comicliste anzeigen zu können, auf eine Instanz der Library Klassse zu.

Die Library Klasse ist dafür verantwortlich eine Liste aller Comics zu führen und bereitzustellen, sowie den Download eines neuen Kapitel zu starten und die Anfrage des PlugIns dieses zu speichern zu beabeiten.

Für den "LibraryTab()" ist allerdings nur das bereitstellen der geführten Liste aller Comics relevant, um diese dann anzuzeigen.
Das zusammenstellen der Liste erfolgt, indem aus dem "Library" Ordner die Namen aller Ordner ausgelesen werden und bei jedem überprüft wird ob es sich um ein Comic handelt.
Dazu versucht die Instanz der "Library" Klasse für jeden der Ordnernamen eine Instanz der Series Klasse zu erstellen, gelingt das wird diese Instanz der Liste hinzugefügt.

Die Informationen aus der "info.json" Datei werden (mit ausnahme des zuletzt gelesenen Kapitel und des zuletzt heruntergeladenen Kapitel) dann verwendet um im "LibraryTab()" Titel, Beschreibung (falls vorhanden), Status (wenn nicht in "info.json" automatisch "unknown") und Titelbild (falls kein Name in "info.json" war oder die Datei nicht gelesen werden konnte ein Platzhalter) für jedes Comic zu zeigen.

## Series Instanzen im "SeriesView()" und "Reader()"

Der "SeriesView()" und der "Reader()" verwenden eine Instanz der Series Klasse die, im Fall von "SeriesView()" vom "LibraryTab()" und im Fall von "Reader()" vom SeriesView(), übergeben wird.

"SeriesView()" verwendet die Instanz um, wie der "LibraryTab()", Informationen aus der "info.json" Datei anzuzeigen, wenn der "Continue" Button gedrückt wird das Nächste Kapitel im "Reader()" zu öffnen und wenn der "Mark as unread" Button gedrückt wird aus der "info.json" den Eintrag zum zuletzt gelesenen Kapitel zu löschen.
Zusätzlich verwendet "SeriesView()" die Instanz um die Liste der Kapitel anzuzeigen.
Drückt man auf das Element eines Kapitels wird der "Reader()" für das entsprechende Kapitel geöffnet.
Wenn "SeriesView()" ein Kapitel im "Reader()" öffnet wird ihm die Series Instanz und der Name des Kapitels übergeben.

Der "Reader()" verwendet die Instanz von Series um anhand des Namen des Kapitels eine Liste von URLs zu allen Bildern des Kapitels zu bekommen, diese Liste wird dann von Anfang bis Ende abgearbeitet und für jede URL das entsprechende Bild geladen, so dass, am Ende alle untereinander angezeigt werden.
Beim drücken der Buttons zum nächsten oder vorherigen Kapitel wird ebenfalls auf die Instanz zugegriffen um zu bestimmen welches das nächste bzw. vorherige Kapitel ist und dieses dann zu Laden.

## PlugIns

PlugIns werden von Instanzen der PlugIn Klasse repräsentiert.
Jedes PlugIn hat eine "manifest.json" Datei in der die Manifestversion unter dem Schlüssel "manifest_version" als String gespeichert ist.
Ist im Manifest eine andere als die aktuell unterstützte Manifestversion angegeben, ein falscher Typ für den Wert verwendet oder gar keine Version angegeben worden schlägt das erstellen einer PlugIn Instanz für das PlugIn fehl.

Optional kann im Manifest unter dem Schlüssel "website" auch eine URL als String angegeben werden die zur Webseite des PlugIns führt.

Im Manifest des PlugIns können beliebig viele andere Schlüssel mit Stringwerten angegeben werden, die dann als Hostname verstanden werden und deren Stringwert als Pfad, relativ zum Manifest, zu JavaScript Dateien zeigt, die auf der Webseite für entsprechenden Hostnamen verwendet werden können um Kapitel herunter zu laden.

Sämmtliche PlugIns werden von einer Instanz der PlugInManager Klasse in einer Liste für die jeweiligen Hostnamen eingetragen.
Die Scripte und Webseite der PlugIns können über die Instanz von PlugInManager abgefragt werden.

## Starten eines Downloads durch den "DownloadsTab()"

Der "DownloadTab()" verwendet den PlugInManager um eine Liste aller PlugIns anzuzeigen wenn nichts in der Suchleiste steht. (Der "SettingsTab()" zeigt ebenfalls eine Liste aller PlugIns an wenn man dort auf "PlugIn list" drückt)
Steht eine URL in der Suchleiste nutzt der "DownloadTab()" die PlugInManager Instanz um für den Hostnamen der URL alle PlugIns aufzulisten die ein Script bereitstellen.

Ist eine URL in die Suchleiste eigetragen wird, wenn man auf das Element eines PlugIns drückt, das entsprechende PlugIn verwendet um Kapitel herunterzuladen.

Dazu wird die Instanz der Library Klasse verwendet.

## JSRunner

Die WebView Klasse, von der JSRunner eine Instanz verwendet, verwendet eine Instanz von WKWebView, dem in iOS eingebauten Objekt um Webseiten anzuzeigen, um Webseiten zu laden und macht WKWebView SwiftUI kompatibel, damit die Webseite angezeigt werden kann.
Außerdem vereinfacht WebView das deaktivieren und aktivieren von JavaScript auf der WebSeite, sowie das blockieren des anfragens von sämmtlichen, nicht in der HTML Datei enthaltenen, Daten.

JSRunner wiederum macht den Umgang mit "Message Handler"n (Funktionen um Nachrichten von den Scripten zu verarbeiten) und das Ausführen von JavaScript in einer WebView Instanz einfacher und erlaubt es dem JavaScript die Webseite anzuzeigen und auszublenden, sowie JavaScript der Webseite und Inhalte die nicht in der HTML Datei vorhanden sind zu erlauben und zu blockieren.

Die Library Instanz verwendet eine JSRunner Instanz um die Scripte von PlugIns auf Websieten auszuführen und ihnen zu erlauben zu überprüfen ob für ein Comic bereits ein Ordner Vorhanden ist, der App mitzuteilen, dass der Download fehlgeschlagen ist (was zum sofortigen beenden der ausführung des Scripts führt) und heruntergeladene Kapitel zu speichern.

## Download

Wenn ein download gestartet wurde führt die Library Instanz mit ihrer JSRunner Instanz das Script des PlugIns auf der angegebenen Webseite aus.

Das Script des PlugIn muss nun entweder das Kapitel was es auf der Webseite findet herunterladen und der Library Instanz als Nachricht schicken damit die es speichern kann oder der Library Instanz eine Nachricht schicken um ihr mitzuteilen, dass der Download fehlgeschlagen ist.

Bekommt die Library Instanz ein Kapitel und mindestens den Titel eines Comics (wobei auch das Titelbild, die Beschreibung und der Status mitgeteilt werden können) lässt sie eine Instanz des entsprechenden Comics das Kapitel speichern und, wenn eine URL zum nächsten Kapitel angegeben wurde, startet den Download für das nächste Kapitel.
