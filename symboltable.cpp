#include<bits/stdc++.h>
#include<string>
#define NULL_VALUE -999999
#define INFINITY1 999999

using namespace std;

class SymbolInfo{
public:
    string name;
    string type;
};
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
	int nRow ;
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
};


SymbolTable::SymbolTable()
{
	nRow = 0 ;
	adjList = 0 ;
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
        cout << i << " --> ";
        for(int j=0; j<adjList[i].getLength();j++)
        {
            cout << " < " << adjList[i].getItem(j).name << " : "  << adjList[i].getItem(j).type << " > " << " ";
        }
        cout << endl;
    }
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

SymbolTable::~SymbolTable()
{
    if(adjList) delete [] adjList;
    adjList = 0;
}

int main()
{
    ifstream myfile;
    myfile.open("input.txt");
    int n;
    myfile >> n;
    SymbolTable g;
    g.setnRow(n);
    int random = n;

    while(1)
    {
        string ch;
        myfile >> ch;
        if(ch=="I")
        {
            SymbolInfo v;
            myfile >> v.name >> v.type;
            int u = g.hashFunction(v,random);
            int j = g.look_up(v.name,u);
            if (j != -1 ) cout << "<" << v.name << "," << v.type << "> " << " Already exists!";
            else{
                g.Insert(u, v);
                cout << "<" << v.name << "," << v.type << "> " << " Inserted at " << u << "," << g.getDegree(u) - 1;
            }
            cout << endl;
        }

        else if(ch=="P")
        {
            g.printSymbolTable();
            cout << endl;
        }
         else if(ch=="L")
        {
            SymbolInfo v;
            myfile >> v.name;
            int u = g.hashFunction(v,random);
            int j = g.look_up(v.name,u);
            if (j != -1 ) cout << "Found at " << u << " , " << j << endl;
            else cout << v.name << " not found !" << endl;
            cout << endl;
        }
        else if(ch=="D")
        {
            SymbolInfo v;
            myfile >> v.name;
            int u = g.hashFunction(v,random);
            int j = g.look_up(v.name,u);
            if (j == -1 ) cout << v.name <<" Not found!";
            else{
                g.Delete(u, v);
                cout << "Deleted from " << u << "," << g.getDegree(u);
            }
            cout << endl;
        }
         else if(ch=="E")
        {
            g.~SymbolTable();
            break;
        }
    }
    /*int n;
    SymbolTable g;
    cin >> n;
    g.setnRow(n);
    int random = n;

    while(1)
    {
        string ch;
        cin >> ch;
        if(ch=="I")
        {
            SymbolInfo v;
            cin >> v.name >> v.type;
            int u = g.hashFunction(v,random);
            int j = g.look_up(v.name,u);
            if (j != -1 ) cout << "<" << v.name << "," << v.type << "> " << " Already exists!";
            else{
                g.insert(u, v);
                cout << "<" << v.name << "," << v.type << "> " << " Inserted at " << u << "," << g.getDegree(u) - 1;
            }
            cout << endl;
        }

        else if(ch=="P")
        {
            g.printSymbolTable();
            cout << endl;
        }
         else if(ch=="L")
        {
            SymbolInfo v;
            cin >> v.name;
            int u = g.hashFunction(v,random);
            int j = g.look_up(v.name,u);
            if (j != -1 ) cout << "Found at " << u << " , " << j << endl;
            else cout << v.name << " not found !" << endl;
            cout << endl;
        }
        else if(ch=="D")
        {
            SymbolInfo v;
            cin >> v.name;
            int u = g.hashFunction(v,random);
            int j = g.look_up(v.name,u);
            if (j == -1 ) cout << v.name <<" Not found!";
            else{
                g.delete(u, v);
                cout << "Deleted from " << u << "," << g.getDegree(u);
            }
            cout << endl;
        }
         else if(ch=="E")
        {
            g.~SymbolTable();
            break;
        }
    }*/
}
