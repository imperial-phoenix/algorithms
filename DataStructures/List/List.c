/**
 * @file    list.c
 * @brief   Forward list implementation
 * @ingroup DATA_STRUCTURES
 */

#include <stddef.h>
#include <stdint.h>
#include <stdlib.h>

#include "Include/DataStructures/List.h"

struct LIST_NODE
{
   LIST_NODE* Next; /** Pointer to the next node */
   void*      Data; /** Data stored in the node */
};


/** Forward list implementation */
typedef struct LIST_IMPLEMENTATION
{
   LIST_PROTOCOL VTable; /** List interface. Also acts like "this" pointer (in C++).*/

   LIST_NODE* Head; /** Pointer to the first node in the list */
   size_t     Size; /** Number of nodes in the list */
} LIST_IMPLEMENTATION;


LIST_PROTOCOL*
CreateList()
{
   LIST_IMPLEMENTATION* list = malloc(sizeof(LIST_IMPLEMENTATION));
   if (NULL == list) { return NULL; }

   list->Head = NULL;
   list->Size = 0;

   return &list->VTable;
}


void
DestroyList(
   IN OUT LIST_PROTOCOL* This)
{
   (void)This;
}