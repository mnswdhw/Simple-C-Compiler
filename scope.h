#include "symboltable.h"

typedef struct scopeinfo scopeinfo;

struct scopeinfo
{
    int nest;
    scopeinfo *parentinfo;
};

scopeinfo *create_scope();
scopeinfo *addchildscope(scopeinfo *csi);//csi is current scope info
// scopeinfo *gotoparentscope(scopeinfo *csi)
scopeinfo *scopecheck(symbolnode **symboltable, char *value, scopeinfo *cs);




