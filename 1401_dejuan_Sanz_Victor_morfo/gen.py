inputfile = open('includes/tokens.h');

my_text = inputfile.readlines()[9:60];


for i in xrange(0,51):
	if my_text[i][0:3] == "#de":
		token = my_text[i].split()[1];	
		word = token.split('_')[1];
		number = my_text[i].split()[2];
		token_str = token + "_STR";
		
		#Generar reglas
		#print("{0} ".format(word) + "{" + "\n \t return {1};".format(word,token) + "\n}");
		

		#Generar defines
		#print("#define {0}".format(token)+"_STR "+'"'+"{0}".format(token)+'"');

		print("case {0}:\n\tprintf('"'%s %d %s'"', {1},{2},yytex);\nbreak;".format(token,token_str,token));

		pass
	pass