ATTENTION: I couldn't make octal values and the like get to work on FreeBSD_4.10 instead I installed gsed and it worked!!
5.4 Also :(


Some useful awk scripts

An example of a loop in awk i = 1 while ( i &lt;= 2 ) { print $i ++i }

Uses a counter to loop the specified amount

To print last field of a record when the number of fields is unkown

awk 'BEGIN { FS = "/" } { print $NF }'

In this example the field seperator (FS) is set to /. NF is equivalent to the number of fields. The last field will be the same
number as the number of fields, therefore the last field will be printed.

To print everything but the last field when the total number of fields is unknown VAR1=`cat $RECORD | \ awk 'BEGIN { FS=":" } {
for (i=2;i&lt;NF;i++) print $1} | tr -d '[:space:]'`

The field separator is set to : . A loop is then performed which will print each field in turn, starting at field 2, looping whi
le the number is less than the number of fields, i.e. one less than NF so the last field isn't printed. As each field is seperat
e, tr can be used to "glue" them back together. Variable $VAR1 will then equal the sting minus the last record.

An alternative method of doing this is: awk '{ print substr($0,1,length($0) - length($NF)) }'

To print everything but the last character with variable length records awk '{ print substr($0,1,length($0)-1) }'

Print the first field unless it starts with a #


cat file | awk 'BEGIN { FS = ":" } $1 !~ /^#/ {print $1}'

Finding processes that have a parent process of 1

ps -ef | awk '$3 ~ /^1$/ { print $0 }'

Splitting records { split($9,elements,"/") if (elements[3] !~ /rdsk/ &amp;&amp; elements[4] ~ /s2/ print $9 }

So if field $9 is a list of disk devices, only /dev/dsk/c*t*d*s2 would be matched.

maths example

awk '{ result = $1 / 1000000 printf("%.1fn", result) }

prints the results to one decimal place

Working out the space used by files

find /home -name "*.log" | xargs ls -ld | awk '{ result = result + $5 } END { print result }'

sed examples

To print lines 10 15

sed -n '10,15p' file

To insert a line after match

/REGEXP/{x;s/^/line to insert/;x;G;}

To insert a line before match

/REGEXP/{x;s/^/line to insert/;G;}




sed 's/$/   /' file1          # append blanks to each line

sed 's/^/    /' file1         # prepend blanks to each line

sed 's/can/should/g' file1    # replace all strings "can" by "should"

sed 's/\<can\>/should/g' file1 # replace all words "can" by "should"

sed 's/Unix/UNIX/g ; s/ucb/UCB/g' file1

sed '/^$/d' file1             # remove all blank lines

sed '/^[        ]*$/d' file1  # remove lines having only blanks and tabs
                              # (there's a blank and a tab inside the
                              # brackets)

sed -n '12,20p' file1         # save only lines 12 through 20 inclusive

sed 'y/abc/ABC/' file1        # translates a->A, b->B, c->C in all lines

sed '/^\.TS/,/^\.TE/!d' file1 # extract (keep) all tables sections
                              # ! reverse the sense of the address expression

sed -f directives file1       # sed directives stored in file "directives"

sed '/^.code/d' file1         # deletes all lines that start with .code

sed '/blob$/d' file1         # deletes all lines that end with "blob"






Do nothing to the file, just echo it back (if no pattern is specified, then any
line will match)

         awk '{print}' file

==============================================================================

like "grep", find string "fleece"  (the {print} command is the default if
nothing is specified)

         awk '/fleece/' file

==============================================================================

select lines 14 through 30 of file

         awk 'NR==14, NR==30' file

==============================================================================

select just one line of a file

         awk 'NR==12' file
         awk "NR==$1" file

==============================================================================

rearrange fields 1 and 2 and put colon in between

         awk '{print $2 ":" $1}' file

==============================================================================

all lines between BEGIN and END lines (you can substitute any strings for
BEGIN and END, but they must be between slashes)

         awk '/BEGIN/,/END/' file

==============================================================================

print number of lines in file (of course wc -l does this, too)

         awk 'END{print NR}' file

==============================================================================

substitute every occurrence of a string XYZ by the new string ABC:
Requires nawk.

         nawk '{gsub(/XYZ/,"ABC"); print}' file

==============================================================================

print 3rd field from each line, but the colon is the field separate

         awk -F: '{print $3}' file

==============================================================================

Print out the last field in each line, regardless of how many fields:

         awk '{print $NF}' file

==============================================================================

To print out a file with line numbers at the edge:

         awk '{print NR, $0}' somefile

This is less than optimal because as the line number gets longer in digits,
the lines get shifted over.  Thus, use printf:

         awk '{printf "%3d %s", NR, $0}' somefile

==============================================================================

Print out lengths of lines in the file

         awk '{print length($0)}' somefile
    or
         awk '{print length}' somefile

==============================================================================

Print out lines and line numbers that are longer than 80 characters

         awk 'length > 80 {printf "%3d. %s\n", NR, $0}' somefile

==============================================================================

Total up the lengths of files in characters that results from "ls -l"

         ls -l | awk 'BEGIN{total=0} {total += $4} END{print total}'

==============================================================================

Print out the longest line in a file

         awk 'BEGIN {maxlength = 0}                 \
              {                                     \
                    if (length($0) > maxlength) {   \
                         maxlength = length($0)     \
                         longest = $0               \
                    }                               \
              }                                     \
              END   {print longest}' somefile

==============================================================================

How many entirely blank lines are in a file?

         awk  '/^$/ {x++} END {print x}' somefile

==============================================================================

Print out last character of field 1 of every line

         awk '{print substr($1,length($1),1)}' somefile

==============================================================================

comment out only #include statements in a C file.  This is useful if you want
to run "cxref" which will follow the include links.

         awk '/#include/{printf "/* %s */\n", $0; next} {print}'   \
              file.c | cxref -c $*

==============================================================================

If the last character of a line is a colon, print out the line.  This would be
useful in getting the pathname from output of ls -lR:

        awk '{                                      \
              lastchar = substr($0,length($0),1)    \
              if (lastchar == ":")                  \
                    print $0                        \
             }' somefile

    Here is the complete thing....Note that it even sorts the final output

       ls -lR |  awk '{                                              \
                lastchar = substr($0,length($0),1)                   \
                if (lastchar == ":")                                 \
                     dirname = substr($0,1,length($0)-1)             \
                else                                                 \
                     if ($4 > 20000)                                 \
                          printf "%10d %25s %s\n", $4, dirname, $8   \
               }' | sort -r

==============================================================================

The following is used to break all long lines of a file into chunks of
length 80:

       awk '{ line = $0
              while (length(line) > 80) {
                    print substr(line,1,80)
                    line = substr(line,81,length(line)-80)
              }
              if (length(line) > 0) print line
            } somefile.with.long.lines > whatever

==============================================================================

If you want to use awk as a programming language, you can do so by not
processing any file, but by enclosing a bunch of awk commands in curly braces,
activated upon end of file.  To use a standard UNIX "file" that has no lines,
use /dev/null.  Here's a simple example:

       awk 'END{print "hi there everyone"}' < /dev/null

Here's an example of using this to print out the ASCII characters:

       awk 'END{for (i=32; i<127; i++)            \
                    printf "%3d %3o %c\n", i,i,i  \
               }' < /dev/null

==============================================================================

Sometimes you wish to find a field which has some identifying tag, like
X= in front.  Suppose your file looked like:

          50 30 X=10 Y=100 Z=-2
          X=12 89 100 32 Y=900
          1 2 3 4 5 6 X=1000

Then to select out the X= numbers from each do

       awk '{ for (i=1; i<=NF; i++)        \
                  if ($i ~ /X=.*/)         \
                      print substr($i,3)   \
            }' playfile1

Note that we used a regular expression to find the initial part: /X=.*/

==============================================================================

Pull an abbreviation out of a file of abbreviations and their translation.
Actually, this can be used to translate anything, where the first field
is the thing you are looking up and the 2nd field is what you want to
output as the translation.

       nawk '$1 == abbrev{print $2}' abbrev=$1 translate.file

==============================================================================

Join lines in a file that end in a dash.  That is, if any line ends in
-, join it to the next line.  This only joins 2 lines at a time.  The
dash is removed.

       awk '/-$/  {oldline = $0                                    \
                   getline                                         \
                   print substr(oldline,1,length(oldline)-1) $0    \
                   next}                                           \
            {print}' somefile

==============================================================================

Function in nawk to round:

       function round(n)
       {
           return int(n+0.5)
       }

==============================================================================

If you have a file of addresses with empty lines between the sections,
you can use the following to search for strings in a section, and print
out the whole section.  Put the following into a file called "section.awk":

         BEGIN  {FS = "\n"; RS = ""; OFS = "\n"}
         $0 ~ searchstring { print }

Assume your names are in a file called "rolodex".
Then use the following nawk command when you want to find a section
that contains a string.  In this example, it is a person's name:

         nawk -f section.awk searchstring=Wolf rolodex

Here's a sample rolodex file:

         Big Bad Wolf
         101 Garden Lane
         Dark Forest, NY  14214

         Grandma
         102 Garden Lane
         Dark Forest, NY  14214
         home phone:  471-1900
         work phone:  372-8882

==============================================================================
