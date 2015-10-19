# xls2csv
## to use xls2csv you have to install

```
portinstall p5-Spreadsheet-ParseExcel converters/p5-Unicode-Map textproc/p5-Text-CSV_XS devel/p5-Locale-libintl
```

then:

```
wget http://search.cpan.org/CPAN/authors/id/K/KE/KEN/xls2csv-1.06.tar.gz
tar xfvz xls2csv-1.06.tar.gz
cd xls2csv-1.06
perl Makefile.PL
make

as root:
make install
```
