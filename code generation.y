
%{
#include <stdio.h>
#include <stdlib.h>
#include<iostream>
#include<string>
#include<string.h>

#include<sstream>
#include<fstream>
#include<typeinfo>


#define NULL_VALUE -999999
#define INFINITY1 999999
using namespace std;
extern "C" FILE *yyin;

extern int line_count;
extern int error_count;

FILE *log;
int single_flag = 0,log_flag = 0,if_flag = 0,for_flag = 0,var_flag = 0,neg_var = 0,ara_flag = 0,ara_indholder = 0;
ofstream fout;
string tempholder = "",inc_flag = "",rel_v1 = "",rel_v2 = "",for_var = "";
string log_v1 = "",log_v2 = "",code1 = "",for_label = "",inc_str = "",prev_ch = "";
int flag = 0,a_f = 0,position,t[100],i_f = 0;
float mf1 = -1000,mf2 = -2000;
int ind1 = 0,ind = 0,for_var_flag = 0;
int ax = 0,bx = 0,cx = 0,dx = 0,mul_ind = 0,a_var = 0;
string ch,ch1,ch2,code = "";
void yyerror(char *s){
	fprintf(log,"%s at line no %d\n\n\n",s,line_count);
	error_count++;
}

class SymbolInfo
{
public:
    string name;
    string type;
    float fl;
    int iv1,iv,i_ff;
    float ara[100];
    
};


int yylex(void);
int yyparse(void);


class ArrayList
{
	SymbolInfo * list;
	int length ;
	int listMaxSize ;
	int listInitSize ;
public:
	ArrayList() ;
	~ArrayList() ;
	int searchItem(string item) ;
    	void insertItem(SymbolInfo item) ;
	void removeItem(SymbolInfo item) ;
	void removeItemAt(int position);
	void update(int value,int position,int position1);
	SymbolInfo getItem(int position) ;
	int getLength();
	bool empty();
	void printList();
} ;

ArrayList::ArrayList()
{
	listInitSize = 2 ;
	listMaxSize = listInitSize ;
	list = new SymbolInfo[listMaxSize] ;
	length = 0 ;
}

void ArrayList::insertItem(SymbolInfo newitem)
{
	SymbolInfo * tempList ;
	if (length == listMaxSize)
	{
		//allocate new memory space for tempList
		listMaxSize = 2 * listMaxSize ;
		tempList = new SymbolInfo[listMaxSize] ;
		int i;
        for( i = 0; i < length ; i++ )
        {
            tempList[i] = list[i] ; //copy all items from list to tempList
        }
        delete[] list ; //free the memory allocated before
        list = tempList ; //make list to point to new memory
	};

	list[length] = newitem ; //store new item
	length++ ;
}

int ArrayList::searchItem(string item)
{
	int i = 0;
	for (i = 0; i < length; i++)
	{
		if( list[i].name == item ) return i;
	}
	return NULL_VALUE;
}

void ArrayList::removeItemAt(int position) //do not preserve order of items
{
	if ( position < 0 || position >= length ) return ; //nothing to remove
	for(int i = position; i < length - 1; i++){
        list[i] = list[i+1];
	}
	length-- ;
}

void ArrayList::removeItem(SymbolInfo item)
{
	int position;
	position = searchItem(item.name) ;
	if ( position == NULL_VALUE ) return ; //nothing to remove
	removeItemAt(position) ;
}

void ArrayList::update(int value,int position,int position1)
{
	list[position].ara[position1] = value;
}

SymbolInfo ArrayList::getItem(int position)
{
	return list[position] ;
}

int ArrayList::getLength()
{
	return length ;
}

bool ArrayList::empty()
{
    if(length==0)return true;
    else return false;
}

void ArrayList::printList()
{
    int i;
    for(i=0;i<length;i++) cout << list[i].name << " : " << list[i].type;
    cout << listMaxSize << length;
}

ArrayList::~ArrayList()
{
    if(list) delete [] list;
    list = 0 ;
}

class SymbolTable
{
public:	int nRow ;
	ArrayList  * adjList ;

public:
	SymbolTable();
	~SymbolTable();
	void setnRow(int n);
	void Insert(int u, SymbolInfo v);
	void Delete(int u, SymbolInfo v);
    int getDegree(int u);
    void printSymbolTable();
    int look_up(string s,int u);
    int hashFunction(SymbolInfo s,int u);
    float getValue(int temp1,int temp2);
    SymbolInfo getObject(int temp1,int temp2);
    int getArrayLength(int temp1,int temp2);
    int getFlag(int temp1,int temp2);
    int get_if_Flag(int temp1,int temp2);
    float getValue1(int temp1,int temp2,int pos);
};


SymbolTable::SymbolTable()
{
	nRow = 0 ;
	adjList = 0 ;
	//if(adjList!=0) delete[] adjList ;
	//adjList = new ArrayList[31] ;
}

void SymbolTable::setnRow(int n)
{
	this->nRow = n ;
	if(adjList!=0) delete[] adjList ;
	adjList = new ArrayList[nRow] ;
}

void SymbolTable::Insert(int u, SymbolInfo v)
{
	adjList[u].insertItem(v);
}


void SymbolTable::Delete(int u, SymbolInfo v)
{

    adjList[u].removeItem(v);
}

int SymbolTable::getDegree(int u)
{
    return adjList[u].getLength();
}

void SymbolTable::printSymbolTable()
{
    for(int i=0;i<nRow;i++)
    {
        if(adjList[i].getLength() > 0){
           fprintf(log,"%d --> ",i);
            for(int j=0; j<adjList[i].getLength();j++)
            {
                //fprintf(log," < %s : %s >  ",adjList[i].getItem(j).name,adjList[i].getItem(j).type);
		//log << "<" << adjList[i].getItem(j).name << "," << adjList[i].getItem(j).type << "> ";
		int we = adjList[i].getItem(j).iv;
		float we1 = adjList[i].getItem(j).fl;
		if(we == -100){
		std::ostringstream ss1;
		ss1 << we1;
		string s4(ss1.str());
		//fprintf(log,"%d\n",adjList[i].getItem(j).obj.fl);
		char a[2500];
		std::string s = "<" + adjList[i].getItem(j).name + "," + adjList[i].getItem(j).type + "," + s4 + "> ";
		//strncpy(a,s, sizeof(a) - 1);
		//a = s;
		strcpy(a,s.c_str());
		a[sizeof(a) - 1] = 0;
		fprintf(log,"%s",a);
} 

		else if (we != -100){
		string s1 = "<" + adjList[i].getItem(j).name + "," + adjList[i].getItem(j).type + "," + " {";
		char a[1000];
			int hate = adjList[i].getItem(j).iv1;
			//fprintf(log,"%d\n",hate);
			for(int k = 0; k < hate; k++){
				std::ostringstream ss;
		ss << adjList[i].getItem(j).ara[k];
		std::string s5(ss.str());
		if(k == hate -1) s1 += s5;
		else s1 += s5 + ",";
		//strncpy(a,s, sizeof(a) - 1);
		//a = s;
			}
		strcpy(a,s1.c_str());
		a[sizeof(a) - 1] = 0;
		fprintf(log,"%s",a);
		fprintf(log,"}>");	
}	
            }
            fprintf(log,"\n");
        }
    }
	fprintf(log,"\n");
}

int SymbolTable::hashFunction(SymbolInfo s,int u)
{
    int len = s.name.length();
    int hasValue;
    hasValue = 0;
    for(int i = 0; i < len; i++){
        hasValue += s.name[i];
    }
    hasValue = hasValue%u;
    return hasValue;
}

int SymbolTable::look_up(string s,int u)
{
    int pos = adjList[u].searchItem(s);
    if( pos != NULL_VALUE) return pos;
    return -1;
}

float SymbolTable::getValue(int temp1,int temp2)
{
    return adjList[temp1].getItem(temp2).fl;
}

SymbolInfo SymbolTable::getObject(int temp1,int temp2)
{
    return adjList[temp1].getItem(temp2);
}

float SymbolTable::getValue1(int temp1,int temp2,int pos)
{
    return adjList[temp1].getItem(temp2).ara[pos];
}

int SymbolTable::getArrayLength(int temp1,int temp2)
{
    return adjList[temp1].getItem(temp2).iv1;
}

int SymbolTable::getFlag(int temp1,int temp2)
{
    return adjList[temp1].getItem(temp2).iv;
}

int SymbolTable::get_if_Flag(int temp1,int temp2)
{
    return adjList[temp1].getItem(temp2).i_ff;
}


SymbolTable::~SymbolTable()
{
    if(adjList) delete [] adjList;
    adjList = 0;
}


int n = 31;
SymbolTable g;

string temp,temp2;
string st,st2,tok;

void cmain(string s,float fb)
{
    
    int random = n;
    SymbolInfo v;
    if(ind == 0){
	g.setnRow(n);
	ind = 1;
	fout << ".MODEL SMALL\n.STACK 100H\n.DATA\n";
	}
    v.name = string(s);
    v.type = "ID";
    v.fl = fb;
    v.iv = -100;
    v.iv1 = 1;
    if(i_f == 0)v.i_ff = 0;
    else if(i_f == 1)v.i_ff = 1;
    int u = g.hashFunction(v,random);
    int j = g.look_up(v.name,u);
   
    if (j != -1 ) {
        string t = "<" + v.name + "," + v.type + "> " + " Already exists!\n";
        char a[250];
        strcpy(a,t.c_str());
	a[sizeof(a) - 1] = 0;
	//fprintf(log,"%s",a);
    }
    else{
        g.Insert(u, v);
	//g.printSymbolTable();
        //cout << "<" << v.name << "," << v.type << "> " << " Inserted at " << u << "," << g.getDegree(u) - 1;
    }
    //g.printSymbolTable();
}

void cmain1(string s,int n1)
{

    int random = n;
    SymbolInfo v;
    if(ind == 0){
	g.setnRow(n);
	ind = 1;
	fout << ".MODEL SMALL\n.STACK 100H\n.DATA\n";
	}
    v.name = string(s);
    v.type = "ID";
    v.iv = 100;
    v.fl = -1000;
    for(int i = 0; i < n1; i++){
        v.ara[i] = -1;
	//t[i] = -1;
    }
    v.iv1 = n1;
    int u = g.hashFunction(v,random);
    int j = g.look_up(v.name,u);
    if (j != -1 ) {
        string t = "<" + v.name + "," + v.type + "> " + " Already exists!\n";
        char a[250];
        strcpy(a,t.c_str());
	a[sizeof(a) - 1] = 0;
	//fprintf(log,"%s",a);
    }
    else{
        g.Insert(u, v);
	//g.printSymbolTable();
        //cout << "<" << v.name << "," << v.type << "> " << " Inserted at " << u << "," << g.getDegree(u) - 1;
    }
    //g.printSymbolTable();
}

int cdelete(string s)
{
     SymbolInfo v;
     v.name = s;
    int u = g.hashFunction(v,n);
    int j = g.look_up(v.name,u);
   if (j == -1 );//cout << v.name <<" Not found!";
   else g.Delete(u, v);
}


int clook_up(string s)
{
	SymbolInfo v;
	v.name = s;
        //myfile >> v.name;
	if(ind == 0){
	g.setnRow(n);
	ind = 1;return -1;
	}
        int u = g.hashFunction(v,n);
        int j = g.look_up(v.name,u);
        if (j != -1 ) return u;
	return -1;
}

int clook_up1(string s)
{
	SymbolInfo v;
	v.name = s;
        //myfile >> v.name;
	if(ind == 0){
	g.setnRow(n);
	ind = 1;return -1;
	}
        int u = g.hashFunction(v,n);
        int j = g.look_up(v.name,u);
        if (j != -1 ) return j;
	return -1;
}

int labelCount=0;
int tempCount=0;


char *newLabel()
{
	char *lb= new char[4];
	strcpy(lb,"L");
	char b[3];
	sprintf(b,"%d", labelCount);
	labelCount++;
	strcat(lb,b);
	return lb;
}

char *newTemp()
{
	char *t= new char[4];
	strcpy(t,"t");
	char b[3];
	sprintf(b,"%d", tempCount);
	tempCount++;
	strcat(t,b);
	return t;
}

%}



%token LPAREN RPAREN IF FOR DO INT FLOAT VOID DECOP MAIN NOT
	DEFAULT SWITCH ELSE WHILE BREAK CHAR DOUBLE RETURN CASE CONTINUE PRINTLN
	 ASSIGNOP INCOP LBRACKET RBRACKET LCURL RCURL COMMA SEMICOLON
%union{
	char *st;
	float f;
	int i;
	char con;
}

%nonassoc LOWER_THAN_ELSE
%nonassoc ELSE

%left "||"
%left "&&"
%left '<' '>' '=' "!=" "<=" ">="
%left '+' '-'
%left '*' '/' '%'
%left '(' ')'
%left "++" "--"


%token <st> ID
%token <f> CONST_FLOAT
%token <i> CONST_INT
%token <con> CONST_CHAR
%token <st> ADDOP
%token <st> MULOP
%token <st> RELOP
%token <st> LOGICOP 

%type <f> factor
%type <f> expression
%type <f> variable
%type <f> unary_expression
%type <f> term
%type <f> simple_expression
%type <f> rel_expression
%type <f> logic_expression
%type <f> expression_statement
%type <f> statements
%type <f> statement
%type <f> declaration_list
%type <f> type_specifier
%type <f> var_declaration
%type <f> compound_statement
%type <f> Program
%type <st>logicop1

%%



Program : INT MAIN LPAREN RPAREN compound_statement {fprintf(log,"Program : INT MAIN compound_statement\n\n");
			
		code += "println PROC\n\n";
		//code += "MOV AX,RES\n";
		code += "PUSH AX\n";
		code += "PUSH BX\n";
		code += "PUSH CX\n";
		code += "PUSH DX\n";
		code += "OR AX,AX\n";
		code += "JGE @END_IF1\n";
		code += "PUSH AX\n";
		code += "MOV DL,'-'\n";
		code += "MOV AH,2\n";
		code += "INT 21H\n";
		code += "POP AX\n";
		code += "NEG AX\n\n";

		code += "@END_IF1:\n";
		code += "XOR CX,CX\n";
		code += "MOV BX,10D\n\n";

		code += "@REPEAT1:\n";
		code += "XOR DX,DX\n";
		code += "DIV BX\n";
		code += "PUSH DX\n";
		code += "INC CX\n";
		code += "OR AX,AX\n";
		code += "JNE @REPEAT1\n\n";

		code += "MOV AH,2\n\n";

		code += "@PRINT_LOOP:\n\n";

		code += "POP DX\n";
		code += "OR DL,30H\n";
		code += "INT 21H\n";
		code += "LOOP @PRINT_LOOP\n\n";

		code += "POP DX\n";
		code += "POP CX\n";
		code += "POP BX\n";
		code += "POP AX\n";
		code += "RET\n";
		code += "println ENDP\n\n";
		code += "END MAIN\n";
fout << code;
code = "";	
	
}
	;


compound_statement : LCURL var_declaration statements RCURL {fprintf(log,"Compound_statement : LCURL var_declaration statements RCURL\n\n");}
		   | LCURL statements RCURL {fprintf(log,"compound_statement : LCURL statements RCURL\n\n");}
		   | LCURL RCURL {fprintf(log,"compound_statement : LCURL RCURL\n\n");}
		   ;

			 
var_declaration	: type_specifier declaration_list SEMICOLON {fprintf(log,"var_declaration :type_specifier declaration_list SEMICOLON\n\n");
		//fout << "\n.CODE\nMAIN PROC\nmov ax,@data\nmov ds,ax\n";
		//if(var_flag == 0){fout << "\n.CODE\nMAIN PROC\nmov ax,@data\nmov ds,ax\n";var_flag = 1;}

}
		|  var_declaration type_specifier declaration_list SEMICOLON 
			{fprintf(log,"var_declaration : var_declaration type_specifier declaration_list SEMICOLON\n\n");
			//fout << "\n.CODE\nMAIN PROC\nmov ax,@data\nmov ds,ax\n";
		
}
		;

type_specifier	: INT {fprintf(log,"type_specifier : INT\n\n");i_f = 0;}
		| FLOAT{fprintf(log,"type_specifier : FLOAT\n\n");i_f = 1;
			}
		| CHAR{fprintf(log,"type_specifier : CHAR\n\n");i_f = 2;}
		;
			
declaration_list : declaration_list COMMA ID {fprintf(log,"declaration_list : declaration_list COMMA ID\n\n");
			fprintf(log,"%s\n\n",yylval);string b = $3;
			
			int temp1 =  clook_up(b);int temp2 = clook_up1(b);
			//cmain(b,-999999);
			if(temp2 == -1){
				cmain(b,-999999);fout << b << " dw ?\n";
			}
			else{
				fprintf(log,"Error at line No : %d Variable %s already declared!\n\n",line_count,$3);
				error_count++;
			}
} 
		 | declaration_list COMMA ID LBRACKET CONST_INT RBRACKET {fprintf(log,"declaration_list : declaration_list 					COMMA ID LBRACKET CONST_INT RBRACKET\n\n");
				fprintf(log,"%s\n\n",yylval);string b = $3;
			int temp1 =  clook_up(b);
				int temp2 =  clook_up1(b);
			if(temp2 == -1){
				string b = $3;cmain1(b,$5);
				fout << b << " dw";
				for(int i = 0; i < $5;i++){
					fout << " ? ";
				}
				fout << "\n";
			}
			else{
				fprintf(log,"Variable %s already declared!Error at line No : %d\n\n",$3,line_count);
				error_count++;
			}
		}
				 

		 | ID {fprintf(log,"declaration_list : ID\n\n");fprintf(log,"%s\n\n",$1);string b = $1;
			int temp1 =  clook_up(b);
			int temp2 =  clook_up1(b);
			if(temp2 == -1){
				
				string b = $1;cmain(b,-999999);
				fout << b << " dw ?\n";
			}
			else{
				fprintf(log,"Variable %s already declared!Error at line No : %d\n\n",$1,line_count);
				error_count++;
			}
		}

		 | ID LBRACKET CONST_INT RBRACKET {fprintf(log,"declaration_list : ID LBRACKET CONST_INT RBRACKET\n\n");
				fprintf(log,"%s\n\n",$1);string b = $1;
				if(ind == 0){
					g.setnRow(n);
					ind = 1;
				//fout << ".MODEL SMALL\n.STACK 100H\n.DATA\n\n";	
				int temp1 =  clook_up(b);
				int temp2 =  clook_up1(b);
				cmain1(b,$3);
				fout << b << " dw";
				for(int i = 0; i < $3;i++){
					fout << " ? ";
				}
				fout << "\n";
			}
		else {
			
			int temp1 =  clook_up(b);
				int temp2 =  clook_up1(b);
			if(temp2 == -1){
				string b = $1;cmain1(b,$3);
				fout << b << " dw ";
				for(int i = 0; i < $3;i++){
					fout << " ? ";
				}
				fout << "\n";
			}
			else{
				fprintf(log,"Variable %s already declared!Error at line No : %d\n\n",$1,line_count);
				error_count++;
			}
		}
}
		 ;

statements : statement {fprintf(log,"statements : statement\n\n");}
	   | statements statement {fprintf(log,"statements : statements statement\n\n");}
	   ;


statement  : expression_statement {fprintf(log,"statement : expression_statement\n\n");}
	   | compound_statement {fprintf(log,"statement : compound_statement\n\n");}
	   | for1 LPAREN expression_statement expression_statement expression RPAREN statement {fprintf(log,"statement : FOR LPAREN expression_statement expression_statement expression RPAREN statement\n\n");
		fout << inc_str + "mov ax," + for_var + "\n" + "loop " + for_label + "\n";
		fout << code1 << ":\n";code1 = "";
		for_flag = 0;for_var_flag = 0;


}
	   | IF LPAREN expression RPAREN statement %prec LOWER_THAN_ELSE {fprintf(log,"IF LPAREN expression RPAREN statement\n\n");
			
			//fout << code;
			//code = "";
			//code+=$5->code;
			//code+=string(label)+":\n";
			//fout << code;
			//code = "";
			//if_flag = 1;
		//if(if_flag == 1){fout << code1 << ":\n";if_flag = 0;}
		fout << code1 << ":\n";if_flag = 0;cout << $3 << "bal";
					

}
	   | IF LPAREN expression RPAREN statement else1 statement {fprintf(log,"statement :F LPAREN expression RPAREN statement ELSE statement\n\n");
			//fout << code1 << ":\n";
			if_flag = 0;


}
	   | while1 LPAREN expression RPAREN statement {fprintf(log,"statement :WHILE LPAREN expression RPAREN statement\n\n");
				fout << inc_str + "mov ax," + for_var + "\n" + "loop " + for_label + "\n";
		fout << code1 << ":\n";code1 = "";
		for_flag = 0;for_var_flag = 0;



}
	   | PRINTLN LPAREN ID RPAREN SEMICOLON {fprintf(log,"statement : PRINTLN LPAREN ID RPAREN SEMICOLON\n\n");
					//int temp1 =  clook_up(string($3));int temp2 = clook_up1(string($3));
					//float fal = g.getValue(temp1,temp2);
					
					code += "mov ax," + string($3) + "\n";
					code += "call println\n";
					fout << code;
		ch = "";ch1 = "";ch2 = "";ax = 0;rel_v1 = "";rel_v2 = "";code = "";
}
	   | RETURN expression SEMICOLON {fprintf(log,"statement : RETURN expression SEMICOLON\n\n");
				fout << "\nmov ah,4ch\nint 21h\nMAIN ENDP\n\n\n\n";

}
	   ;
		
expression_statement	: SEMICOLON{fprintf(log,"expression_statement : SEMICOLON\n\n");}			
			| expression SEMICOLON {fprintf(log,"expression_statement :expression SEMICOLON\n\n");}
			;
						
variable : ID {fprintf(log,"variable : ID\n\n");fprintf(log,"%s\n\n",$1);inc_flag = string($1);
	if(for_flag == 1 && for_var_flag == 0){for_var = string($1);for_var_flag = 1;}
	if(log_flag == 1)log_v2 = string($1);
	if(rel_v1 == "")rel_v1 = string($1);
	else rel_v2 = string($1);
	if(var_flag == 0){fout << "\n.CODE\nMAIN PROC\nmov ax,@data\nmov ds,ax\n";var_flag = 1;}
	//if(ch != "" && ch1 == ""){ch1 = string($1);cout << ch1 << "ch1 ";}
	//else if(ch != "" && ch1 != "") {ch2 = string($1); cout << ch2 << "ch2 ";}
	if(ch != "" && ch1 == "") {ch1 = string($1);cout << ch1 << "ch1 ";}
	else if(ch1 != "" && ch2 == "") {ch2 = string($1);cout << ch2 << "ch2 ";}
	if(ch == ""){ch = string($1);cout << ch << "ch ";
	int temp1 =  clook_up(ch);int temp2 = clook_up1(ch);flag = 0;
	if(temp2 != -1 && g.adjList[temp1].getItem(temp2).iv == 100) {position = -1;}
	if(temp2 != -1)$$ = g.getValue(temp1,temp2);
	else {
		fprintf(log,"Error at line No : %d , Undeclared %s variable!\n\n",line_count,$1);
		error_count++;$$ = -78979;
		}
}
	else {
	int temp1 =  clook_up($1);int temp2 = clook_up1($1);
	if(temp2 != -1)$$ = g.getValue(temp1,temp2);
	else {
		fprintf(log,"Error at line No : %d Undeclared %s variable!\n\n",line_count,$1);
		error_count++;$$ = -767887;
		}
	}
	//if(ch1 != "")
//ch1 = string($1);
	//cout << ch << " " << ch1 << " " << ch2 << " ";
 }
	 | ID LBRACKET expression RBRACKET {fprintf(log,"variable : ID LBRACKET expression RBRACKET\n\n");
	fprintf(log,"%s\n\n",$1);
	
	inc_flag = string($1);
	if(for_flag == 1 && for_var_flag == 0){for_var = string($1);for_var_flag = 1;}
	if(log_flag == 1)log_v2 = string($1);
	if(rel_v1 == "")rel_v1 = string($1);
	else rel_v2 = string($1);
	if(ch == ""){ch = string($1);cout << ch << "ch ";ch1 = "";a_var = 1;ara_indholder = $3;}
	else if(ch != "" && ch1 != "" && ch2 == ""){cout << ch1 << "ch1 ";
			code += "lea di," + string($1) + "\n";
			for(int i=0;i<2;i++){
			code += "add di, " + ch1 +"\n";
}
			code += "mov ax,[di]\n";ara_flag = 1;ch1 = string($1);
	}

	else if(ch != "" && ch1 != "" && ch2 != ""){cout << ch2 << "ch2 ";
			code += "lea di," + string($1) + "\n";
			for(int i=0;i<2;i++){
			code += "add di, " + ch2 +"\n";
}
			code += "mov ax,[di]\n";ara_flag = 1;ch2 = string($1);
	}
	//else if(ch != "" && ch1 != "") {ch2 = string($1); cout << ch2 << "ch2 ";}
	//if(ch != "" && ch1 == "") {ch1 = string($1);cout << ch1 << "ch1 ";}
	//if(ch != "" && ch1 == "") {ch1 = string($1);cout << ch1 << "ch1 ";}
	//else if(ch1 != "" && ch2 == "") {ch2 = string($1);cout << ch2 << "ch2 ";}
	

	int temp1 =  clook_up(ch);int temp2 = clook_up1(ch);
	int temp = g.getArrayLength(temp1,temp2);
	
	$$ = g.getValue1(temp1,temp2,$3);flag = 1;position = $3;
	if(temp <= $3){
		fprintf(log,"Error at line No : %d !!Array Index out of bound!\n\n",line_count);
		a_f = 1;error_count++;position = -1000;
		}



	else {
	int temp1 =  clook_up($1);int temp2 = clook_up1($1);int temp = g.getArrayLength(temp1,temp2);
	$$ = g.getValue1(temp1,temp2,$3);

	if(temp <= $3){
		fprintf(log,"Error at line No : %d !!Array Index out of bound!\n\n",line_count);
		a_f = 1;error_count++;position = -1000;
		}
	}

		
	
} 
	 ;
			
expression : logic_expression	{fprintf(log,"expression : logic expression\n\n");}
	   | variable ASSIGNOP logic_expression {fprintf(log,"expression : variable ASSIGNOP logic_expression\n\n");
	int temp1 =  clook_up(ch);int temp2 = clook_up1(ch);
	//if(temp2 != -1)cout << g.get_if_Flag(temp1,temp2) << " ";
	if(mf1 != -1000 && mf2 != -2000 && (mf1-(int)mf1 != 0 || mf2-(int)mf2 != 0)){
		fprintf(log,"Error at line: %d : Integer operand on modulus operator\n\n",line_count);
		error_count++;mf1 = -1000; mf2 = -2000;
} 
	else if(temp2 != -1 && g.get_if_Flag(temp1,temp2) == 0 && $3 - (int)$3 != 0)
	{
    		fprintf(log,"Type mismathch at line no : %d\n\n",line_count);
    		error_count++;
    		ch = "";//cout << g.get_if_Flag(temp1,temp2);
	}
	
	
	else if(flag == 0 && temp2 != -1 && a_f != 1 && g.getFlag(temp1,temp2) == -100){
	cdelete(ch);
	float b2 = $3;cmain(ch,b2);a_f = 0;
	fprintf(log,"%f\n",b2);
	//prev_ch = ch;cout << prev_ch;
	if(if_flag == 2){


		if(single_flag == 1){
		code += "mov " + ch + ",ax\n";//ax = 0;bx = 0;
		
		}
	else if(single_flag == 0){	
			string va;         
			ostringstream temp1;  
			temp1<<$3;
			va=temp1.str();
			if(ara_flag != 1){code += "mov ax," + ch1 + "\n";ara_flag = 0;}
			code += "mov " + ch + ",ax\n";
	}

	fout << code;//cout << if_flag;
	//g.setNewValue(temp1,temp2,bal2);
	
	g.printSymbolTable();
	prev_ch = ch;
	ch = "";
	single_flag = 0;
}

	else{
	if(if_flag == 1){//fout << code1;code1 = "";if_flag = 0;//cout << code1;
		char *label=newLabel();
			code1 += "mov ax, "+tempholder+"\n";
			code1 += "cmp ax, 1\n";
			code1 += "jne "+string(label)+"\n";
			fout << code1;//code1 = "";
			//if_flag = 0;cout << code1;
			code1 = "";code1 = string(label);if_flag = 0;
			
}	
	if(single_flag == 1){
		code += "mov " + ch + ",ax\n";//ax = 0;bx = 0;
		
		}
	else if(single_flag == 0){	
			string va;         
			ostringstream temp1;  
			temp1<<$3;
			va=temp1.str();
			if(prev_ch != ch1 && neg_var != 1 && ara_flag != 1){code += "mov ax," + ch1 + "\n";neg_var = 0;ara_flag = 0;}
			code += "mov " + ch + ",ax\n";
	}

	fout << code;//cout << if_flag;
	//g.setNewValue(temp1,temp2,bal2);
	
	g.printSymbolTable();prev_ch = ch;cout << "ko" << prev_ch << "kho";
	ch = "";
	single_flag = 0;

}


}
	else if(flag == 0 && temp2 == -1 && a_f != 1 && position != -1){ch = "";}
	
	else if(position == -1 && temp2 != -1){
		//cout << "mis";
		fprintf(log,"Error at line %d : Type Mismatch\n\n",line_count);ch = "";
		error_count++;
		}
	else if(a_f != 1 && position != -1){
	int temp1 =  clook_up(ch);int temp2 = clook_up1(ch);
	int temp = g.getArrayLength(temp1,temp2);
	float b2 = $3;
	cout << position << "    ";
	string va1;         
	ostringstream temp3;  
	temp3<<ara_indholder;
	va1 = temp3.str();
	code += "lea di," + ch +"\n";
	for(int i=0;i<2;i++){
		code += "add di, " + va1 +"\n";
		}
	//fprintf(log,"%f\n",bal2);
	if(if_flag == 2){


		if(single_flag == 1){
		code += "mov [di],ax\n";//ax = 0;bx = 0;
		
		}
	else if(single_flag == 0){	
			string va;         
			ostringstream temp1;  
			temp1<<$3;
			va=temp1.str();
			if(ara_flag != 1){code += "mov ax," + ch1 + "\n";ara_flag = 0;}
			code += "mov [di],ax\n";
	}

	fout << code;//cout << if_flag;
	//g.setNewValue(temp1,temp2,bal2);
	
	g.printSymbolTable();
	ch = "";
	single_flag = 0;
}

	else{
	if(if_flag == 1){//fout << code1;code1 = "";if_flag = 0;//cout << code1;
		char *label=newLabel();
			code1 += "mov ax, "+tempholder+"\n";
			code1 += "cmp ax, 1\n";
			code1 += "jne "+string(label)+"\n";
			fout << code1;//code1 = "";
			//if_flag = 0;cout << code1;
			code1 = "";code1 = string(label);if_flag = 0;
			
}	
	if(single_flag == 1){
		code += "mov [di],ax\n";//ax = 0;bx = 0;
		
		}
	else if(single_flag == 0){	
			string va;         
			ostringstream temp1;  
			temp1<<$3;
			va=temp1.str();
			code += "mov ax," + ch1 + "\n";
			code += "mov [di],ax\n";
	}

	fout << code;//cout << if_flag;
	//g.setNewValue(temp1,temp2,bal2);
	
	g.printSymbolTable();
	ch = "";
	single_flag = 0;
	g.adjList[temp1].update(b2,temp2,position);
	g.printSymbolTable();a_f = 0;
	ch = "";ch1 = "";ch2 = "";ax = 0;rel_v1 = "";rel_v2 = "";
}

}	
	//else if(a_f == 1 && temp2 != -1 && g.getFlag(temp1,temp2) != -100 && position == -2){
		//cout << "mis";
	//	else {fprintf(log,"Error at line %d : Type Mismatch\n\n",line_count);ch = "";
	//	error_count++;}
	//	}*/

//else {fprintf(log,"Error at line %d : Type Mismatch\n\n",line_count);}

		ch = "";
		a_f = 0;
		code = "";	
		ch1 = "",ch2 = "";//tempholder = "";
		single_flag = 0;ara_flag = 0;	
}	
	   ;
			
logic_expression : rel_expression {fprintf(log,"logic_expression : rel_expression\n\n");$$ = $1;
		$$ = $$;}
		 | rel_expression logicop1 rel_expression {fprintf(log,"logic_expression :rel_expression LOGICOP 	rel_expression \n\n ");
			char *label1=newLabel();
			char *temp=newTemp();
			char *label2=newLabel();
			if(strcmp("&&",$2) == 0){	
				$$ = $1 && $3;
				if(ax == 0){code += "mov ax," + log_v1 + "\n";ax = 1;}
				code += "cmp ax,1\n";
				code += "jne "+string(label1)+"\n";
				if(tempholder != "") code += "mov ax " + tempholder + "\n";
				else  code += "mov ax " + log_v2 + "\n";
				code += "cmp ax,1\n";
				code += "jne "+string(label1)+"\n";
				code += "mov " + string(temp) + ",1\n";
				code += "jmp " + string(label2) + "\n";
				code += string(label1) + ":\n";
				code += "mov " + string(temp) + ",0\n";
				code += string(label2) + ":\n";
				fout << code;
				code = "";ax = 0;//tempholder = "";
				//ch = "";	
				//ch1 = "",ch2 = ""; 
				//single_flag = 0;
}
			else if(strcmp("||",$2) == 0){
				$$ = $1 || $3;
				if(ax == 0){code += "mov ax," + log_v1 + "\n";ax = 1;}
				code += "cmp ax,1\n";
				code += "je "+string(label1)+"\n";
				if(tempholder != "") code += "mov ax " + tempholder + "\n";
				else  code += "mov ax " + log_v2 + "\n";
				code += "cmp ax,1\n";
				code += "je "+string(label1)+"\n";
				code += "mov " + string(temp) + ",0\n";
				code += "jmp " + string(label2) + "\n";
				code += string(label1) + ":\n";
				code += "mov " + string(temp) + ",1\n";
				code += string(label2) + ":\n";
				fout << code;
				code = "";ax = 0;//tempholder = "";
				
}
			log_flag = 0;cout << log_v1 << " " << log_v2 << " ";
}	
		 ;
			
rel_expression	: simple_expression {fprintf(log,"rel_expression : simple_expression\n\n ");$$ = $1;}
		| simple_expression RELOP term{fprintf(log,"rel_expression : simple_expression RELOP term\n\n");
		if(for_flag != 1){code+="mov ax, " + rel_v1+"\n";cout << rel_v1 << " ";}
		else code += "mov ax, " + for_var + "\n";
		fout << code; code = "";
		if(for_flag == 1) fout << for_label + ":\n";
		code+="cmp ax, " + rel_v2+"\n";cout << rel_v2 << " ";
		if_flag = 1;
		char *temp=newTemp();
		char *label1=newLabel();
		char *label2=newLabel();
		if(strcmp("<",$2) == 0){
			$$ = $1 < $3;
			code+="jl " + string(label1)+"\n";
			//fout << code;
			//code += "";
	}
		else if(strcmp("<=",$2) == 0){
			$$ = $1 <= $3;
			code+="jle " + string(label1)+"\n";
			//fout << code;
			//code += "";
	}
		else if(strcmp(">",$2) == 0){
			$$ = $1 > $3;
			code+="jg " + string(label1)+"\n";
			//fout << code;
			//code += "";
	}
		else if(strcmp(">=",$2) == 0){
			$$ = $1 >= $3;
			code+="jge " + string(label1)+"\n";
			//fout << code;
			//code += "";
	}
		else if(strcmp("!=",$2) == 0){
			$$ = $1 != $3;
			code+="jne " + string(label1)+"\n";
			//fout << code;
			//code += "";
	}
		else if(strcmp("==",$2) == 0){
			$$ = $1 == $3;
			code+="je " + string(label1)+"\n";
			//fout << code;
			//code += "";
	}

		code += "mov "+string(temp) +", 0\n";
		code += "jmp "+string(label2) +"\n";
		code += string(label1)+":\nmov "+string(temp)+", 1\n";
		code += string(label2)+":\n";
		fout << code;
		code = "";rel_v1 = "";rel_v2 = "";
		tempholder = string(temp);
		ch = "";ch1 = "";ch2 = "";
		
}	
		;
				
simple_expression : term {fprintf(log,"simple_expression : term\n\n");$$ = $1;}
		  | simple_expression ADDOP term {fprintf(log,"simple_expression : simple_expression ADDOP term\n\n"); 
			string va;         
			ostringstream temp1,temp2;  
			temp1<<$1;
			va=temp1.str();
			//if(ch1 == "" && ax == 0){code += "mov ax," + va + "\n";ax = 1;}
			if(ax == 0 && ch1 != "0" && ch1 != prev_ch && neg_var != 1 && ara_flag != 1){code += "mov ax," + ch1 + "\n";ax = 1;cout <<"no:" << prev_ch << "b " << ch1;neg_var = 0;}
			temp2<<$3;
			va=temp2.str();
			char *temp=newTemp();
			//single_flag = 1;
			tempholder = string(temp);
   			if(strcmp("+",$2) == 0 && (va != "0" && ch1 != "0" && ch2 != "0")){
				$$ = $1 + $3;
				if(tempholder == "" && ch2 == "")code += "add ax," + va + "\n";
				else if(tempholder == "" && ch2 != "")code += "add ax," + ch2 + "\n";
				else if(tempholder != "" && ch2 == "")code += "add ax," + ch1 + "\n";
				else if(tempholder != "" && ch2 != "")code += "add ax," + ch2 + "\n";
				else code += "add ax," + tempholder + "\n";
				code += "mov "+ string(temp) + ", ax\n";
				tempholder = string(temp);
				single_flag = 1;
				//bx = 0;
				
			}
			else if(strcmp("-",$2) == 0){
			$$ = $1 - $3;
			//code += "sub ax,bx\n";
			if(tempholder == "" && ch2 == "")code += "sub ax," + va + "\n";
			else if(tempholder == "" && ch2 != "")code += "sub ax," + ch2 + "\n";
			else if(tempholder != "" && ch2 == "")code += "sub ax," + ch1 + "\n";
			else if(tempholder != "" && ch2 != "")code += "sub ax," + ch2 + "\n";
			else code += "sub ax," + tempholder + "\n";
			code += "mov "+ string(temp) + ", ax\n";
			tempholder = string(temp);
			single_flag = 1;
			//bx = 0;	
		}
	tempholder = string(temp);single_flag = 1;neg_var = 0;
	ch1 = "";ch2 = "";ax = 0;ara_flag = 0;	
} 
		  ;
					
term :	unary_expression {fprintf(log,"term : unary_expression\n\n");$$ = $1;}
     |  term MULOP unary_expression {fprintf(log,"term : term MULOP unary_expression\n\n");
	//$$->code += $3->code;
	
	if(strcmp("*",$2) == 0){
		if ( ch1 != "1" && ch2 != "1"){
		$$ = $1 * $3;
		string va;         	
		ostringstream temp1,temp2;  
		temp1<<$1;
	va=temp1.str();
	if(ax == 0 && prev_ch != ch){code += "mov ax," + ch1 + "\n";ax = 1;}
	if(ch2 == "")code += "mov bx," + ch1 + "\n";
	else code += "mov bx," + ch2 + "\n";
	temp2<<$3;
	va=temp2.str();
	char *temp=newTemp();
	single_flag = 1;
		code += "mul bx\n";
		code += "mov "+ string(temp) + ", ax\n";
		//bx = 0;
		tempholder = string(temp);
		single_flag = 1;mul_ind = 1;

}
	else if(mul_ind != 1 && ch1 == "1"){code += "mov ax," + ch2 + "\n";mul_ind = 0;}
	else if(mul_ind != 1 && ch2 == "1"){code += "mov ax," + ch1 + "\n";mul_ind = 0;}
}
	else if(strcmp("/",$2) == 0){
		$$ = $1 / $3;
		string va;         
	ostringstream temp1,temp2;  
	temp1<<$1;
	va=temp1.str();
	if(ax == 0 && prev_ch != ch){code += "mov ax," + ch1 + "\n";ax = 1;}
	if(ch2 == "")code += "mov bx," + ch1 + "\n";
	else code += "mov bx," + ch2 + "\n";
	temp2<<$3;
	va=temp2.str();
	char *temp=newTemp();
	single_flag = 1;
		code += "xor dx,dx\n";
		code += "div bx\n";
		code += "mov "+ string(temp) + ", ax\n";
		//bx = 0;
		tempholder = string(temp);
		single_flag = 1;mul_ind = 0;
}
	else if(strcmp("%",$2) == 0){mf1 = $1;mf2 = $3;$$ = (int)$1 % (int)$3;
		string va;         
	ostringstream temp1,temp2;  
	temp1<<$1;
	va=temp1.str();
	if(ax == 0 && prev_ch != ch){code += "mov ax," + ch1 + "\n";ax = 1;}
	if(ch2 == "")code += "mov bx," + ch1 + "\n";
	else code += "mov bx," + ch2 + "\n";
	temp2<<$3;
	va=temp2.str();
	char *temp=newTemp();
	single_flag = 1;
		code += "xor dx,dx\n";
		code += "div bx\n";
		code += "mov "+ string(temp) + ", dx\n";
		code += "mov ax,dx\n"; 
		//bx = 0;
		tempholder = string(temp);
		single_flag = 1;mul_ind = 0;

}
	ch1 = "";ch2 = "";single_flag = 1;mul_ind = 0;
}
     ;

unary_expression : ADDOP unary_expression  {fprintf(log,"unary_expression : ADDOP unary_expression\n\n");
		if(strcmp("+",$1) == 0)$$ += $2;
			else if(strcmp("-",$1) == 0){
				$$ -= $2;
				fout << "mov ax," + inc_flag + "\n";
				fout << "neg ax\n";
				//fout << "mov " + inc_flag + ",ax\n";
				inc_flag = "";neg_var = 1;
		}
}
		 | NOT unary_expression {fprintf(log,"unary_expression : NOT unary_expression\n\n");$$ = !$2;}
		 | factor {fprintf(log,"unary_expression : factor\n\n");$$ = $1;}
		 ;
	
factor	: variable {fprintf(log,"factor : variable\n\n");$$ = $1;
}
	| LPAREN expression RPAREN {fprintf(log,"factor :LPAREN expression RPAREN \n\n ");$$ = $2;}
	| CONST_INT {fprintf(log,"factor : CONST_INT\n\n");fprintf(log,"%d\n\n",$1);$$ = $1;
		single_flag = 0;
		
		string va;         
		ostringstream temp;  
		temp<<$1;
		//cout << "bal" << ch << "bal";
		va=temp.str();//int t = -100;
		if(var_flag == 0){fout << "\n.CODE\nMAIN PROC\nmov ax,@data\nmov ds,ax\n";var_flag = 1;}
		//int temp1 =  clook_up(ch);int temp2 = clook_up1(ch);//t = g.getFlag(temp1,temp2);cout << t;
		//if(ch != ""){t = g.getFlag(temp1,temp2);cout << t;}
		//if(a_var == 1)a_var = 0;
		//else {
		if(ch1 == "") {ch1 = va;cout << va << "ch1 ";}
		else if(ch2 == "") {ch2 = va;cout << ch2 << "ch2 ";//}
	}
		if(rel_v1 == "")rel_v1 = va;
		else rel_v2 = va;
		//if(ax == 0){code += "mov ax," + va + "\n";ax = 1;}
		//else if	(bx == 0){code += "mov bx," + va + "\n";bx = 1;}
		//else if (cx == 0){code += "mov cx," + va + "\n";cx = 1;}
		//else if (dx == 0){code += "mov dx," + va + "\n";dx = 1;}	
}
	| CONST_FLOAT {fprintf(log,"factor : CONST_FLOAT\n\n");fprintf(log,"%f\n\n",$1);$$ = $1;
		single_flag = 0;			//code += "mov ax,";
		string va;         
		ostringstream temp;  
		temp<<$1;
		va=temp.str();
		if(var_flag == 0){fout << "\n.CODE\nMAIN PROC\nmov ax,@data\nmov ds,ax\n";var_flag = 1;}
		if(ch1 == "") {ch1 = va;cout << ch1 << "ch1 ";}
		else if(ch2 == "") {ch2 = va;cout << ch2 << "ch2 ";}
		if(rel_v1 == "")rel_v1 = va;
		else if(rel_v2 == "")rel_v2 = va;
		//if(ax == 0){code += "mov ax," + va + "\n";ax = 1;}
		//else if	(bx == 0){code += "mov bx," + va + "\n";bx = 1;}
}
	| CONST_CHAR {fprintf(log,"factor : CONST_CHAR\n\n");fprintf(log,"%s\n\n",yylval);$$ = $1;
		if(var_flag == 0){fout << "\n.CODE\nMAIN PROC\nmov ax,@data\nmov ds,ax\n";var_flag = 1;}
		//code += "mov ax," + $1;
		//string va;         
		//ostringstream temp;  
		//temp<<$1;
		//va=temp.str();
		//if(ax == 0){code += "mov ax," + string($1) + "\n";ax = 1;}
		//else if	(bx == 0){code += "mov bx," + string($1) + "\n";bx = 1;}
}
	| variable INCOP {fprintf(log,"factor : factor INCOP\n\n");$$ = $1++;
					if(for_flag != 1)fout << "inc " + inc_flag + "\n";
					else if(for_flag == 1){
						inc_str = "inc " + for_var + "\n";
						ch1 = "";ch = "";ch2 = "";
				}
					inc_flag = "";

}
	| variable DECOP {fprintf(log,"factor : factor DECOP\n\n");$$ = $1--;
				if(for_flag != 1)fout << "dec " + inc_flag + "\n";
				else if(for_flag == 1){
					inc_str = "dec " + for_var + "\n" ;
					ch1 = "";ch = "";ch2 = "";
				}
				inc_flag = "";
		
}
	;

logicop1   : LOGICOP{fprintf(log,"logicop\n\n");
			log_v1 = inc_flag;log_flag = 1;
}

        ;

else1 : ELSE{if_flag = 2;fout << code1 << ":\n";code1 = "";}

	;

for1  : FOR{for_flag = 1;char *label = newLabel();for_label = string(label);
	if(var_flag == 0){fout << "\n.CODE\nMAIN PROC\nmov ax,@data\nmov ds,ax\n";var_flag = 1;}
};
while1  : WHILE{for_flag = 1;char *label = newLabel();for_label = string(label);
	if(var_flag == 0){fout << "\n.CODE\nMAIN PROC\nmov ax,@data\nmov ds,ax\n";var_flag = 1;}
};
//id1 : ID{if(ch != "")ch = $1;cout << "ID\n" << $1;a_var = 1;fout <<"ID1\n";fprintf(log,"ID1\n\n");};

%%

main(int argc,char *argv[])
{	
    if(argc!=2){
		printf("Please provide input file name and try again\n");
		return 0;
	}
	
	FILE *fin=fopen(argv[1],"r");
	if(fin==NULL){
		printf("Cannot open specified file\n");
		return 0;
	}
	fout.open("1305087_code.asm");
	log= fopen("1305087_log.txt","w");
	//token= fopen("1305087_token.txt","w");
	fout << ".MODEL SMALL\n.STACK 100H\n.DATA\n\n";
	yyin= fin;
	
	yyparse();
	
	

	fprintf(log,"\n           Symbol Table     \n\n");
	g.printSymbolTable();
	fprintf(log,"\nLine number : %d\n\n",line_count);
	fprintf(log,"Error number : %d\n\n",error_count);
	
	//fclose(token);
	fclose(log);
	//fclose(fout);
	
	//in.close();
	fclose(yyin);
	return 0;
}
