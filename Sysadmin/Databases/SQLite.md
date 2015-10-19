# Import CSV to sqlite

Let's face it, a comma as a separator sucks, so for my example I used the pipe put for some a <TAB> would be more adequate.

```
$ sqlite3 lux9000.db
SQLite version 3.7.2
Enter ".help" for instructions
Enter SQL statements terminated with a ";"
sqlite> CREATE TABLE wierder (MOTS_ID INEGER PRIMARY KEY, MOTS_LUXEMBURGISCH TEXT, MOTS_LUXEMBURGISCH_WSC TEXT, MOTS_FRENCH TEXT, MOTS_FRENCH_WSC TEXT, MOTS_GERMAN TEXT, MOTS_GERMAN_WSC TEXT, MOTS_ENGLISH TEXT, MOTS_ENGLISH_WSC TEXT, MOTS_SPAIN TEXT, MOTS_SPAIN_WSC TEXT, MOTS_ITALIAN TEXT, MOTS_ITALIAN_WSC TEXT, MOTS_PORTUGUESE TEXT, MOTS_PORTUGUESE_WSC TEXT, INFINITIF_INDEX1 TEXT, INFINITIF_INDEX2 TEXT);
sqlite> .separator "|"
sqlite> .import lux9000.csv wierder
sqlite> select count(*) from wierder;
3855
sqlite> 
```