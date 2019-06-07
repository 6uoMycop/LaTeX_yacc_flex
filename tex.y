%{
    #define _CRT_SECURE_NO_WARNINGS
    #include <stdio.h>
    #include <ctype.h>
    #include <string.h>
    
    #define alloca malloc
    #undef YYERROR_VERBOSE 0
    
    int yyerror (char *error);
	
    extern int yylex();
    extern int iLineNumber;
    extern FILE *yyin;
%}

%token SPACE    OPERATOR SPECCHAR BEGINDOC   ENDDOC    DOCCLASS LCBR  RCBR
%token TITLE    POW      END      USEPACKAGE MAKETITLE AUTHOR   INDEX TABLEOFCONT
%token MATH     BSL      LSBR     RSBR       NEWPAGE   INPUT    LSKF  RSKF
%token BEGINENV ENDENV   ERR      FORMAT     INTEGER   WORD     IF    ENDIF

%%

start           :   start code
                |   code
                ;

code            :   documentclass preamble BEGINDOC body ENDDOC
                |   END
                    {
                        printf("\nComplete\n");
                        exit(0);
                    }
                ;

documentclass   :   DOCCLASS LCBR textoption RCBR
                |   DOCCLASS LSBR math RSBR LCBR textoption RCBR
                |   DOCCLASS LSBR RSBR LCBR textoption RCBR
                |   DOCCLASS LSBR math RSBR LCBR RCBR
                |   DOCCLASS LSBR RSBR LCBR RCBR
                ;

preamble        :   preamble usepackage
                |   preamble author
                |   preamble titletype
                |   
                ;

usepackage      :   math
                ;

title           :   titletype title
                |   titletype
                |   author title
                |   author
                ;

titletype       :   TITLE LCBR math RCBR
                |   TITLE LCBR RCBR
                |   TITLE LSBR math RSBR LCBR math RCBR 
                |   TITLE LCBR math RCBR LSBR math RSBR LCBR math RCBR
                |   TITLE LSBR RSBR LCBR RCBR 
                ;

author          :   AUTHOR LCBR math RCBR
                |   AUTHOR LCBR RCBR
                ;

body            :   part body
                |   part
                ;

textenvir       :   text textenvir
                |   text
                ;

text            :   LCBR math RCBR
                |   LSBR math RSBR
                ;

part            :   math
                |   title
                ;

math            :   operand
                |   LSKF math RSKF
                ;

operand         :   operand POW math
                |   operand POW LCBR math RCBR
                |   operand POW LCBR math RCBR LCBR math RCBR
                |   operand POW LCBR RCBR LCBR math RCBR
                |   operand POW LCBR math RCBR LCBR RCBR
                |   operand POW LCBR RCBR LCBR RCBR
                |   operand INDEX math
                |   operand INDEX LCBR math RCBR
                |   operand INDEX LCBR math RCBR LCBR math RCBR
                |   operand INDEX LCBR RCBR LCBR math RCBR
                |   operand INDEX LCBR math RCBR LCBR RCBR
                |   operand INDEX LCBR RCBR LCBR RCBR
                |   operand LCBR RCBR
                |   operand LCBR math RCBR
                |   operand SPACE LCBR math RCBR
                |   operand LCBR operand RCBR
                |   operand LSBR math RSBR
                |   operand environment
                |   operand textoption
                |   operand if
                |   SPACE LCBR math RCBR
                |   LCBR operand RCBR
                |   LSBR math RSBR
                |   environment
                |   textoption
                |   if
                ;

if              :   IF math ENDIF
                ;

environment     :   LCBR BEGINENV LCBR textoption RCBR math RCBR
                |   LCBR math BEGINENV LCBR textoption RCBR RCBR
                |   LCBR BEGINENV LCBR textoption RCBR RCBR
                |   LCBR ENDENV LCBR textoption RCBR math RCBR
                |   LCBR math ENDENV LCBR textoption RCBR RCBR
                |   LCBR ENDENV LCBR textoption RCBR RCBR
                |   BEGINENV textenvir body ENDENV textenvir
                |   BEGINENV textenvir LCBR body RCBR ENDENV textenvir 
                |   BEGINENV textenvir ENDENV textenvir  
                ;

textoption      :   WORD
                |   INTEGER
                |   SPECCHAR
                |   BSL WORD
                |   TABLEOFCONT
                |   MATH
                |   BSL OPERATOR
                |   LSBR RSBR
                |   BSL LCBR WORD BSL RCBR
                |   OPERATOR
                |   NEWPAGE
                |   MAKETITLE
                |   INPUT LCBR math RCBR
                |   INPUT LSBR math RSBR LCBR math RCBR
                |   INPUT LSBR RSBR LCBR math RCBR
                |   INPUT LSBR RSBR LCBR RCBR
                |   INPUT LSBR math RSBR LCBR RCBR
                |   INPUT LSBR math RSBR LSBR math RSBR LCBR math RCBR
                |   INPUT LSBR math RSBR LSBR math RSBR LSBR math RSBR LCBR math RCBR
                |   FORMAT LCBR math RCBR
                |   LSBR OPERATOR RSBR
                |   FORMAT
                |   USEPACKAGE LCBR math RCBR
                |   USEPACKAGE LSBR math RSBR LCBR math RCBR
                |   USEPACKAGE LCBR RCBR
                |   USEPACKAGE LSBR RSBR LCBR RCBR
                ;

%%

int yyerror(char *error)
{
    printf("\nLine %d\t\terror: \"%s\"\n", iLineNumber, error);
    exit(1);
    return 0;
}

int main(int argc, char *argv[])
{
    yyin = fopen(argv[1], "r");
    if (yyin == NULL)
    {
        yyerror("file was not opened");
        return 0;
    }
    yyparse();
    fclose(yyin);
    return 0;
}

