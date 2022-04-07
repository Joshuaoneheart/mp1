#include "kernel/types.h"
#include "user/setjmp.h"
#include "user/threads.h"
#include "user/user.h"
#define NULL 0


static struct thread* current_thread = NULL;
static int id = 1;
static jmp_buf env_st;
// static jmp_buf env_tmp;

struct thread *thread_create(void (*f)(void *), void *arg){
    struct thread *t = (struct thread*) malloc(sizeof(struct thread));
    //unsigned long stack_p = 0;
    unsigned long new_stack_p;
    unsigned long new_stack;
    new_stack = (unsigned long) malloc(sizeof(unsigned long)*0x100);
    new_stack_p = new_stack +0x100*8-0x2*8;
    t->fp = f;
    t->arg = arg;
    t->ID  = id;
    t->buf_set = 0;
    t->stack = (void*) new_stack;
    t->stack_p = (void*) new_stack_p;
    id++;
    return t;
}
void thread_add_runqueue(struct thread *t){
    if(current_thread == NULL){
	    current_thread = t;
	    current_thread->next = t;
	    current_thread->previous = t;
    }
    else{
	t->previous = current_thread->previous;
	t->next = current_thread;
        current_thread->previous->next = t;
	current_thread->previous = t;
    }
}

void thread_yield(void){
	if(!setjmp(current_thread->env)){
		schedule();
		dispatch();
	}
}

void dispatch(void){
	if(current_thread->buf_set == 0){
		if(!setjmp(current_thread->env)){
			current_thread->env->sp = (unsigned long)current_thread->stack_p;
			longjmp(current_thread->env, 1);
		}
		current_thread->buf_set++;
		current_thread->fp(current_thread->arg);
		thread_exit();
	}
	else{
		current_thread->buf_set++;
		longjmp(current_thread->env, 1);
	}
}

void schedule(void){
    current_thread = current_thread->next;
}

void thread_exit(void){
    if(current_thread->next != current_thread){
        current_thread->next->previous = current_thread->previous;
	      current_thread->previous->next = current_thread->next;
        struct thread * tmp = current_thread->next;
	      free(current_thread->stack);
	      free(current_thread);
	      current_thread = tmp;
	      dispatch();
    }
    else{
	    free(current_thread->stack);
	    free(current_thread);
    	current_thread = NULL;
	    longjmp(env_st, 1);
    }
}
void thread_start_threading(void){
	schedule();
	if(!setjmp(env_st)) dispatch();
}
