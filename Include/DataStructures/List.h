/**
 * @file    list.h
 * @brief   Forward list interface
 * @ingroup DATA_STRUCTURES
 */

#ifndef _LIST_H_
#define _LIST_H_

#include "Include/types.h"

/** The building block that makes up a forward list.*/
typedef struct LIST_NODE LIST_NODE;


/** Forward declaration LIST_PROTOCOL */
typedef struct LIST_PROTOCOL LIST_PROTOCOL;


/**
 * @brief Returns a pointer to the node of the first element.
 * 
 * @return Pointer to the first element. NULL if the list is empry.
 */
typedef
LIST_NODE*
(*LIST_FRONT)(
   IN LIST_PROTOCOL* This);


/** Forward list interface */
typedef struct LIST_PROTOCOL
{
   LIST_FRONT Front; /** Returns a pointer to the node of the first element */
} LIST_PROTOCOL;


/**
 * @brief  Create a forward list protocol.
 *
 * @return On success, returns the pointer to the LIST_PROTOCOL in allocated memory.
 *         To avoid a memory lick, the returned pointer must be deallocated using the
 *         destroy_list function.
 *
 *         On failure, returns a NULL pointer.
 */
LIST_PROTOCOL*
CreateList();


/**
 * @brief   Destroy a forward list protocol. Deallocating internal storage.
 * 
 * @param This Pointer to the LIST_PROTOCOL
 */
void
DestroyList(
   IN OUT LIST_PROTOCOL *This);

#endif // _LIST_H_