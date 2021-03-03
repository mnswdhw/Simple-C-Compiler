#include <stdlib.h>
#include <string.h>
#include "scope.h"
#include "symboltable.h"

int scopecount=0;

scopeinfo *create_scope()
{
    scopeinfo *node=(scopeinfo *)malloc(sizeof(scopeinfo));
    node->nest=scopecount++;
    node->parentinfo=NULL;
    return node;

}

scopeinfo *addchildscope(scopeinfo *csi)
{
    scopeinfo *node=create_scope();
    node->parentinfo=csi;
    return node;

}

int check(scopeinfo *csi, int num)
{
    scopeinfo *node = csi;

    while (node != NULL)
    {
        if (node->nest == num)
        {
            return 1;
        }

        node = node->parentinfo;
    }

    return 0;
}

scopeinfo *scopecheck(symbolnode **table, char *value, scopeinfo *csi)
{
    int hashindex= hash(value);

    for (symbolnode *current=table[hashindex];current !=NULL;current=current->next)
    {
        if(strcmp(current->value,value)==0)
        {
            if(check(csi,current->nest))
            {
                return current;
            }
        }
    }  

    return NULL;

}



