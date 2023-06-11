//Modify this file to change what commands output to your statusbar, and recompile using the make command.
static const Block blocks[] = {
	/*Icon*/	/*Command*/		/*Update Interval*/	/*Update Signal*/
	{"Mem:", "free -h --si| awk '/^内存/ { print $3\"/\"$2 }' | sed s/i//g",	30,		0},

    {"CPU:","vmstat 1 1 | awk 'NR==3{print 100-$15}'",5,0},

    {"Vol:","pamixer --get-volume",1,0},

	{"", "date '+%b %d (%a) %H:%M'",					5,		0},

};

//sets delimeter between status commands. NULL character ('\0') means no delimeter.
static char delim[] = " | ";
static unsigned int delimLen = 5;