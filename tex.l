%{
    #include "y_tab.h"
    #include<stdio.h>
    #include<string.h>
    #define YY_NEVER_INTERACTIVE 1

    int debug_output();
    int iLineNumber=1;
%}

%option noyywrap

%%

"\\newenvironment"                             { debug_output(yytext, "ERR         "); return WORD;                }
"\\renewenvironment"                           { debug_output(yytext, "ERR         "); return WORD;                }
"\\newcommand"                                 { debug_output(yytext, "ERR         "); return WORD;                }
"\\renewcommand"                               { debug_output(yytext, "ERR         "); return WORD;                }
"\\def"                                        { debug_output(yytext, "ERR         "); return WORD;                }
"\\def"[a-zA-Z0-9]                             { debug_output(yytext, "ERR         "); return WORD;                }
"\\\\"                                         { debug_output(yytext, NULL          );                             }
"\\"                                           { debug_output(yytext, "BSL         "); return BSL;                 }
"{"                                            { debug_output(yytext, "LCBR        "); return LCBR;                }
"}"                                            { debug_output(yytext, "RCBR        "); return RCBR;                }
"["                                            { debug_output(yytext, "LSBR        "); return LSBR;                }
"]"                                            { debug_output(yytext, "RSBR        "); return RSBR;                }
"^"                                            { debug_output(yytext, "POW         "); return POW;                 }
"_"                                            { debug_output(yytext, "INDEX       "); return INDEX;               }
"\\begin{document}"                            { debug_output(yytext, "BEGINDOC    "); return BEGINDOC;            }
"\\begin{document}+"                           { debug_output(yytext, "WORD        "); return WORD;                }
"\\end{document}"                              { debug_output(yytext, "ENDDOC      "); return ENDDOC;              }
"\\end{document}+"                             { debug_output(yytext, "WORD        "); return WORD;                }
"\\begin"                                      { debug_output(yytext, "BEGINENV    "); return BEGINENV;            }
"\\begin"\{.*\}\+                              { debug_output(yytext, "WORD        "); return WORD;                }
"\\end"                                        { debug_output(yytext, "ENDENV      "); return ENDENV;              }
"\\end"\{.*\}\+                                { debug_output(yytext, "WORD        "); return WORD;                }
"\\usepackage"                                 { debug_output(yytext, "USEPACKAGE  "); return USEPACKAGE;          }
"\\usepackage"[a-zA-Z]+                        { debug_output(yytext, "WORD        "); return WORD;                }
"\\usepackage"\{.+?\}"+"                       { debug_output(yytext, "WORD        "); return WORD;                }
"\\input"[a-zA-Z]+[\+\*]*                      { debug_output(yytext, "WORD        "); return WORD;                }
"\\input"                                      { debug_output(yytext, "INPUT       "); return INPUT;               }
"\\include"[a-z]*                              { debug_output(yytext, "INPUT       "); return INPUT;               }
"\\include"[a-z|\+|\*]+                        { debug_output(yytext, "WORD        "); return WORD;                }
"\\documentclass"                              { debug_output(yytext, "DOCCLASS    "); return DOCCLASS;            }
"\\textcopyright"                              { debug_output(yytext, "WORD        "); return WORD;                }
"\\text"[a-zA-Z]+                              { debug_output(yytext, "FORMAT      "); return FORMAT;              }
"\\if"[a-zA-Z]+                                { debug_output(yytext, "IF          "); return IF;                  }
"\\fi"                                         { debug_output(yytext, "ENDIF       "); return ENDIF;               }
"\\maketitle"[a-zA-Z]+[\+\*]*                  { debug_output(yytext, "WORD        "); return WORD;                }
"\\maketitle"                                  { debug_output(yytext, "MAKETITLE   "); return MAKETITLE;           }
"\\author"                                     { debug_output(yytext, "AUTHOR      "); return AUTHOR;              }
"\\author"[a-zA-Z]+[\+\*]*                     { debug_output(yytext, "WORD        "); return WORD;                }
"\\date"                                       { debug_output(yytext, "AUTHOR      "); return AUTHOR;              }
"\\date"[a-zA-Z]+[\+\*]*                       { debug_output(yytext, "WORD        "); return WORD;                }
"\\title"                                      { debug_output(yytext, "TITLE       "); return TITLE;               }
"\\title"[a-zA-Z]+[\+\*]*                      { debug_output(yytext, "WORD        "); return WORD;                }
"\\tableofcontents"                            { debug_output(yytext, "TABLEOFCONT "); return TABLEOFCONT;         }
"\\newpage"                                    { debug_output(yytext, "NEWPAGE     "); return NEWPAGE;             }
"\\hspace"                                     { debug_output(yytext, "SPACE       "); return SPACE;               }
"\\vspace"                                     { debug_output(yytext, "SPACE       "); return SPACE;               }
"\\hspace*"                                    { debug_output(yytext, "SPACE       "); return SPACE;               }
"\\vspace*"                                    { debug_output(yytext, "SPACE       "); return SPACE;               }
"\\"[ ]*[a-zA-Z0-9|\+|\*|\-|\#|\/]+            { debug_output(yytext, "WORD1       "); return WORD;                }
<<EOF>>                                        { debug_output(yytext, "END         "); return END;                 }
(\\\%|\\\$|\\\&|\\\-|\\\<|\\\>|\\\#|\\\{|\\\}) { debug_output(yytext, "SPECCHAR    "); return SPECCHAR;            }
("+"|"-"|"="|"*"|"&"|"/"|"%"|"|"|"<"|">"|"~")  { debug_output(yytext, "OPERATOR    "); return OPERATOR;            }
[0-9]+                                         { debug_output(yytext, "INTEGER     "); return INTEGER;             }
((\.|\,|\!|\?|\:|\;)|[a-zA-Z0-9])+             { debug_output(yytext, "WORD        "); return WORD;                }
\\[\~|\`|\'|\^|\"|\=|\.|\_]                    { debug_output(yytext, "WORD        "); return WORD;                }
\$\$[^\$]+?\$\$                                { debug_output(yytext, "MATH        "); iLineNumber++; return MATH; }
\$[^\$]+?\$                                    { debug_output(yytext, "MATH        "); return MATH;                }
\%.*[^\n]                                      { debug_output(yytext, NULL          );                             }
\%.*\n                                         { debug_output(yytext, NULL          ); iLineNumber++;              }
\\\]                                           { debug_output(yytext, "RSKF        "); return RSKF;                }
\\\[                                           { debug_output(yytext, "LSKF        "); return LSKF;                }
\\\)                                           { debug_output(yytext, "RSKF        "); return RSKF;                }
\\\(                                           { debug_output(yytext, "LSKF        "); return LSKF;                }
\n                                             {                                       iLineNumber++;              }
\$                                             { debug_output(yytext, "WORD        "); return WORD;                }


%%

int debug_output(char *str, char *token)
{
#ifdef _DEBUG
	printf("%s\t%s\n", (token == NULL) ? "" : token, str);
#endif
	return 0;
}
