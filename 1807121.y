/* C Declarations */

%{
	#include<stdio.h>
	#include<stdlib.h>
	#include <string.h>
	#include<math.h>
	
	int yylex ();
	int yyerror();

	int switchdone = 0;
	int switchvar;

	int ifval[1000];
	int ifptr = -1;
	int ifdone[1000];

    int ptr = 0;
    int value[1000];
    char varlist[1000][1000];

    ///if already declared  return 1 else return 0
    int isdeclared(char str[]){
        int i;
        for(i = 0; i < ptr; i++){
            if(strcmp(varlist[i],str) == 0) return 1;
        }
        return 0;
    }
    /// if already declared return 0 or add new value and return 1;
    int addnewval(char str[],int val){
        if(isdeclared(str) == 1) return 0;
        strcpy(varlist[ptr],str);
        value[ptr] = val;
        ptr++;
        return 1;
    }

    ///get the value of corresponding string
    int getval(char str[]){
        int indx = -1;
        int i;
        for(i = 0; i < ptr; i++){
            if(strcmp(varlist[i],str) == 0) {
                indx = i;
                break;
            }
        }
		if(indx==-1)
		{
			return 0;
		}
        return value[indx];
    }
    int setval(char str[], int val){
    	int indx = -1;
        int i;
        for(i = 0; i < ptr; i++){
            if(strcmp(varlist[i],str) == 0) {
                indx = i;
                break;
            }
        }
		if(indx!=-1)
        value[indx] = val;

	

    }


%}

%union {
  char text[10000];
  int val;
}


%token <text>  ID
%token <val>  NUM
%token <text> STR

%type <val> expression
%type <text> LoopStatement
%type <text> Lprint
%type <val> ifexp


%left LT GT LE GE
%left PLUS MINUS
%left MULT DIV
%left MODULUS


%token SCAN NE EQ POWER MODULUS FLOAT LESS GREAT WHILE INT DOUBLE CHAR MAIN FBS FBE SBS SBE SEMICOLON COMMA ASGN SHOW_VAR SHOW_STR SHOW_LINE PLUS MINUS MUL DIV LT GT LE GE IF ELSE ELSEIF FOR INCREMENT_BY TO SWITCH DEFAULT COLON FUNCTION
%nonassoc IFX
%nonassoc ELSE
%left SH


%%

starthere 	: function program function
		
			;

program		: INT MAIN FBS FBE SBS statement SBE { printf("\nCompilation Successful\n"); }
			;
statement	: /* empty */
			| statement declaration
			| statement print
			| statement expression 
			| statement ifelse
			| statement assign
			| statement forloop
			| statement switch
			| statement whileloop
			;







declaration : type variables SEMICOLON {}
			;
type		: INT | DOUBLE | CHAR {}
			;
variables	: variable COMMA variables {}
			| variable {}
			;
variable   	: ID 	
					{
						//printf("%s\n",$1);
						int x = addnewval($1,0);
						if(!x) {
							printf("Compilation Error:Variable %s is already declared\n",$1);
							exit(-1);
						}

					}
			| ID ASGN expression 	
					{
						//printf("%s %d\n",$1,$3);
						int x = addnewval($1,$3);
						if(!x) {
							printf("Compilation Error: Variable %s is already declared\n",$1);
							exit(-1);
							}
					}

			;





assign : ID ASGN expression SEMICOLON  
					{
						if(!isdeclared($1)) {
							printf("Compilation Error: Variable %s is not declared\n",$1);
							exit(-1);
						}
						else{
							setval($1,$3);
						}
				    }
		| SCAN FBS ID FBE SEMICOLON
		{
			int tmp;
			tmp = 7;
			//printf("scan korte chai\n");
			scanf("%d", &tmp);
			//printf("%d - %s \n", tmp, $3);
			
			setval($3, tmp);
		}
		;








print		: SHOW_VAR FBS ID FBE SEMICOLON 	
					{
						if(!isdeclared($3)){
							printf("Compilation Error: Variable %s is not declared\n",$3);
							exit(-1);
						}
						else{
							int v = getval($3);
							printf("%d",v);
						}
					}
			| SHOW_STR FBS STR FBE SEMICOLON
		 
					{
						int l = strlen($3);
						int i;
						for(i = 1;  i < l-1; i++) printf("%c",$3[i]);
					}
			| SHOW_LINE FBS FBE	SEMICOLON
		 	
					{
						printf("\n");
					}
			;










expression : NUM {$$ = $1;}
			| ID 	
					{
						if(!isdeclared($1)) {
							printf("Compilation Error: Variable %s is not declared\n",$1);
							exit(-1);
						}
						else{
							$$ = getval($1);
						}
				 	}
			| expression POWER expression 
					{
						$$ = pow($1,$3);
						printf("POWER");
					}
			| expression MODULUS expression 
					{
						$$ = $1 % $3;
						printf("mod");
					}
			| expression PLUS expression 
					{$$ = $1 + $3;}
			| expression MINUS expression 
					{$$ = $1 - $3;}
			| expression MULT expression 
					{$$ = $1 * $3;}
			| expression DIV expression 
					{
						if($3) {
 							$$ = $1 / $3;
							}
				  		else {
							$$ = 0;
							printf("\nRuntime Error: division by zero\t");
							exit(-1);
				  		} 
					}
			| expression LT expression	
					{ $$ = $1 < $3; }
			| expression GT expression	
					{ $$ = $1 > $3; }
			| expression LE expression	
					{ $$ = $1 <= $3; }
			| expression GE expression	
					{ $$ = $1 >= $3; }
			| expression NE expression	
					{ 
						$$ = $1 != $3;
					}
			| expression EQ expression	
					{ 
						$$ = $1 == $3; 
					}
			| FBS expression FBE
					{$$ = $2;}
			;







ifelse 	: IF FBS ifexp FBE SBS LoopStatement SBE elseif
					{
						if($3)
						printf("%s", $6);
						ifdone[ifptr] = 0;
						ifptr--;
					}
		;
ifexp	: expression 
					{
						ifptr++;
						ifdone[ifptr] = 0;
						if($1){
							printf("\nIf executed\n");
							ifdone[ifptr] = 1;
						}
						$$ = $1;
					}
		;
elseif 	: /* empty */
		| elseif ELSEIF FBS expression FBE SBS LoopStatement SBE 
					{
						if($4 && ifdone[ifptr] == 0){
							printf("%s", $7);
							printf("\nElse if block expressin %d executed\n",$4);
							ifdone[ifptr] = 1;
						}
					}
		| elseif ELSE SBS LoopStatement SBE
					{
						if(ifdone[ifptr] == 0){
							printf("%s", $4);
							printf("\nElse block executed\n");
							ifdone[ifptr] = 1;
						}
					}

		;







whileloop : WHILE FBS ID LESS NUM FBE SBS LoopStatement SBE
		{
			int tmp = getval($3);

			while(tmp<$5)
			{
				printf("%d ", tmp);
				printf("%s",$8);	
				tmp = tmp+1;
			}
			setval($3, tmp);

		}
		| WHILE FBS ID GREAT NUM FBE SBS LoopStatement SBE
		{
			int tmp = getval($3);
			while(tmp>$5)
			{
				printf("%d ", tmp);
				
				printf("%s",$8);
				
				tmp = tmp-1;
			}
			setval($3, tmp);

		}
		;









forloop	: FOR FBS expression TO expression INCREMENT_BY expression FBE SBS LoopStatement SBE 	
					{
						int st = $3;
						int ed = $5;
						int dif = $7;
						int cnt = 0;
						int k = 0;
						//printf(" hhel : \n%s\n", $10);
						for(k = st; k <= ed; k += dif){
							cnt++;
							int r ;
							if(strlen($10)!=0)
							printf("%s\n", $10);
						}	
						printf("Loop executes %d times\n",cnt);
					}
					;

LoopStatement: { strcpy($$,"");}
			| LoopStatement Lprint {
				 strcat($$, $2);
				}
			;

Lprint		: SHOW_VAR FBS ID FBE SEMICOLON 	
					{
						char val[1000];
						strcpy(val, "");
						if(!isdeclared($3)){
							strcat(val, "Compilation Error: Variable ");

							char tmp[20];
							sprintf(tmp, "%s ", $3);
							strcat(val, tmp);
							strcat( val,"is not declared\n");
							printf("%s", val);
							exit(-1);
							strcpy($$, val);
						}
						else{
							char val[1000];
							strcpy(val, "");
							int v = getval($3);
							char tmp[18];
							sprintf(tmp, "%d", v);
							//strcpy(tmp,atoi(v));
							//printf(" v er value : %d - %s\n ", v, tmp);
							strcat(val, tmp);
							strcpy($$, val);

							//printf("%d",v);
						}
					}
			| SHOW_STR FBS STR FBE SEMICOLON
		 
					{
						char val[10000];
						strcpy(val, "");
						int l = strlen($3);
						int i;
						for(i = 1;  i < l-1; i++) 
						{
							char tmp[20];
							sprintf(tmp, "%c", $3[i]);
							//printf(" str er tmp:  %s\n",tmp);
							strcat(val, tmp);
							
							
							//printf("%c",$3[i]);
						}
						//strcat(val, "");
						
						//printf("  %s ", $$);
						
						strcpy($$, val);
						//printf("::: --- val: %s - %s\n",val, $$);
					}
			| SHOW_LINE FBS FBE	SEMICOLON
		 	
					{
						strcpy($$, "\n");
					}
			;









switch	: SWITCH FBS expswitch FBE SBS switchinside SBE 
		;

expswitch 	:  expression 
					{
						switchdone = 0;
						switchvar = $1;
					}
			;


switchinside	: /* empty */
				| switchinside expression COLON SBS LoopStatement SBE 
					{
						if($2 == switchvar){
							//printf("Executed %d\n",$2);
							printf("%s", $5);
							switchdone = 1;
						}					
					}
				| switchinside DEFAULT COLON SBS LoopStatement SBE 
					{
						if(switchdone == 0){
							switchdone = 1;
							printf("Default Block executed\n");
							printf("%s", $5);
						}
					}
				;






function 	: /* empty */
			| function func
			;

func 	: type FUNCTION FBS fparameter FBE SBS statement SBE
					{
						printf("Function Declared\n");
					}
		;
fparameter 	: /* empty */
			| type ID fsparameter
			;
fsparameter : /* empty */
			| fsparameter COMMA type ID
			;



%%


int yyerror(char *s){
	printf( "%s\n", s);
}