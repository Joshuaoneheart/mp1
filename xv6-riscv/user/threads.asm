
user/_threads:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <thread_create>:
static struct thread* current_thread = NULL;
static int id = 1;
static jmp_buf env_st;
// static jmp_buf env_tmp;

struct thread *thread_create(void (*f)(void *), void *arg){
   0:	7179                	addi	sp,sp,-48
   2:	f406                	sd	ra,40(sp)
   4:	f022                	sd	s0,32(sp)
   6:	ec26                	sd	s1,24(sp)
   8:	e84a                	sd	s2,16(sp)
   a:	e44e                	sd	s3,8(sp)
   c:	1800                	addi	s0,sp,48
   e:	89aa                	mv	s3,a0
  10:	892e                	mv	s2,a1
    struct thread *t = (struct thread*) malloc(sizeof(struct thread));
  12:	0a800513          	li	a0,168
  16:	00001097          	auipc	ra,0x1
  1a:	8ae080e7          	jalr	-1874(ra) # 8c4 <malloc>
  1e:	84aa                	mv	s1,a0
    //unsigned long stack_p = 0;
    unsigned long new_stack_p;
    unsigned long new_stack;
    new_stack = (unsigned long) malloc(sizeof(unsigned long)*0x100);
  20:	6505                	lui	a0,0x1
  22:	80050513          	addi	a0,a0,-2048 # 800 <fprintf+0x28>
  26:	00001097          	auipc	ra,0x1
  2a:	89e080e7          	jalr	-1890(ra) # 8c4 <malloc>
    new_stack_p = new_stack +0x100*8-0x2*8;
    t->fp = f;
  2e:	0134b023          	sd	s3,0(s1)
    t->arg = arg;
  32:	0124b423          	sd	s2,8(s1)
    t->ID  = id;
  36:	00001717          	auipc	a4,0x1
  3a:	a0670713          	addi	a4,a4,-1530 # a3c <id>
  3e:	431c                	lw	a5,0(a4)
  40:	08f4a823          	sw	a5,144(s1)
    t->buf_set = 0;
  44:	0804aa23          	sw	zero,148(s1)
    t->stack = (void*) new_stack;
  48:	e888                	sd	a0,16(s1)
    new_stack_p = new_stack +0x100*8-0x2*8;
  4a:	7f050513          	addi	a0,a0,2032
    t->stack_p = (void*) new_stack_p;
  4e:	ec88                	sd	a0,24(s1)
    id++;
  50:	2785                	addiw	a5,a5,1
  52:	c31c                	sw	a5,0(a4)
    return t;
}
  54:	8526                	mv	a0,s1
  56:	70a2                	ld	ra,40(sp)
  58:	7402                	ld	s0,32(sp)
  5a:	64e2                	ld	s1,24(sp)
  5c:	6942                	ld	s2,16(sp)
  5e:	69a2                	ld	s3,8(sp)
  60:	6145                	addi	sp,sp,48
  62:	8082                	ret

0000000000000064 <thread_add_runqueue>:
void thread_add_runqueue(struct thread *t){
  64:	1141                	addi	sp,sp,-16
  66:	e422                	sd	s0,8(sp)
  68:	0800                	addi	s0,sp,16
    if(current_thread == NULL){
  6a:	00001797          	auipc	a5,0x1
  6e:	9d67b783          	ld	a5,-1578(a5) # a40 <current_thread>
  72:	cb91                	beqz	a5,86 <thread_add_runqueue+0x22>
	    current_thread = t;
	    current_thread->next = t;
	    current_thread->previous = t;
    }
    else{
	t->previous = current_thread->previous;
  74:	6fd8                	ld	a4,152(a5)
  76:	ed58                	sd	a4,152(a0)
	t->next = current_thread;
  78:	f15c                	sd	a5,160(a0)
        current_thread->previous->next = t;
  7a:	6fd8                	ld	a4,152(a5)
  7c:	f348                	sd	a0,160(a4)
	current_thread->previous = t;
  7e:	efc8                	sd	a0,152(a5)
    }
}
  80:	6422                	ld	s0,8(sp)
  82:	0141                	addi	sp,sp,16
  84:	8082                	ret
	    current_thread = t;
  86:	00001797          	auipc	a5,0x1
  8a:	9aa7bd23          	sd	a0,-1606(a5) # a40 <current_thread>
	    current_thread->next = t;
  8e:	f148                	sd	a0,160(a0)
	    current_thread->previous = t;
  90:	ed48                	sd	a0,152(a0)
  92:	b7fd                	j	80 <thread_add_runqueue+0x1c>

0000000000000094 <schedule>:
		current_thread->buf_set++;
		longjmp(current_thread->env, 1);
	}
}

void schedule(void){
  94:	1141                	addi	sp,sp,-16
  96:	e422                	sd	s0,8(sp)
  98:	0800                	addi	s0,sp,16
    current_thread = current_thread->next;
  9a:	00001797          	auipc	a5,0x1
  9e:	9a678793          	addi	a5,a5,-1626 # a40 <current_thread>
  a2:	6398                	ld	a4,0(a5)
  a4:	7358                	ld	a4,160(a4)
  a6:	e398                	sd	a4,0(a5)
}
  a8:	6422                	ld	s0,8(sp)
  aa:	0141                	addi	sp,sp,16
  ac:	8082                	ret

00000000000000ae <thread_exit>:

void thread_exit(void){
  ae:	1101                	addi	sp,sp,-32
  b0:	ec06                	sd	ra,24(sp)
  b2:	e822                	sd	s0,16(sp)
  b4:	e426                	sd	s1,8(sp)
  b6:	1000                	addi	s0,sp,32
    if(current_thread->next != current_thread){
  b8:	00001797          	auipc	a5,0x1
  bc:	9887b783          	ld	a5,-1656(a5) # a40 <current_thread>
  c0:	73d8                	ld	a4,160(a5)
  c2:	04e78063          	beq	a5,a4,102 <thread_exit+0x54>
        current_thread->next->previous = current_thread->previous;
  c6:	6fd4                	ld	a3,152(a5)
  c8:	ef54                	sd	a3,152(a4)
	current_thread->previous->next = current_thread->next;
  ca:	73d8                	ld	a4,160(a5)
  cc:	f2d8                	sd	a4,160(a3)
	free(current_thread->stack);
  ce:	6b88                	ld	a0,16(a5)
  d0:	00000097          	auipc	ra,0x0
  d4:	76c080e7          	jalr	1900(ra) # 83c <free>
	free(current_thread);
  d8:	00001497          	auipc	s1,0x1
  dc:	96848493          	addi	s1,s1,-1688 # a40 <current_thread>
  e0:	6088                	ld	a0,0(s1)
  e2:	00000097          	auipc	ra,0x0
  e6:	75a080e7          	jalr	1882(ra) # 83c <free>
	current_thread = current_thread->next;
  ea:	609c                	ld	a5,0(s1)
  ec:	73dc                	ld	a5,160(a5)
  ee:	e09c                	sd	a5,0(s1)
	dispatch();
  f0:	00000097          	auipc	ra,0x0
  f4:	046080e7          	jalr	70(ra) # 136 <dispatch>
	free(current_thread->stack);
	free(current_thread);
    	current_thread = NULL;
	longjmp(env_st, 1);
    }
}
  f8:	60e2                	ld	ra,24(sp)
  fa:	6442                	ld	s0,16(sp)
  fc:	64a2                	ld	s1,8(sp)
  fe:	6105                	addi	sp,sp,32
 100:	8082                	ret
	free(current_thread->stack);
 102:	6b88                	ld	a0,16(a5)
 104:	00000097          	auipc	ra,0x0
 108:	738080e7          	jalr	1848(ra) # 83c <free>
	free(current_thread);
 10c:	00001497          	auipc	s1,0x1
 110:	93448493          	addi	s1,s1,-1740 # a40 <current_thread>
 114:	6088                	ld	a0,0(s1)
 116:	00000097          	auipc	ra,0x0
 11a:	726080e7          	jalr	1830(ra) # 83c <free>
    	current_thread = NULL;
 11e:	0004b023          	sd	zero,0(s1)
	longjmp(env_st, 1);
 122:	4585                	li	a1,1
 124:	00001517          	auipc	a0,0x1
 128:	92c50513          	addi	a0,a0,-1748 # a50 <env_st>
 12c:	00001097          	auipc	ra,0x1
 130:	8b4080e7          	jalr	-1868(ra) # 9e0 <longjmp>
}
 134:	b7d1                	j	f8 <thread_exit+0x4a>

0000000000000136 <dispatch>:
void dispatch(void){
 136:	1141                	addi	sp,sp,-16
 138:	e406                	sd	ra,8(sp)
 13a:	e022                	sd	s0,0(sp)
 13c:	0800                	addi	s0,sp,16
	if(current_thread->buf_set == 0){
 13e:	00001517          	auipc	a0,0x1
 142:	90253503          	ld	a0,-1790(a0) # a40 <current_thread>
 146:	09452783          	lw	a5,148(a0)
 14a:	ebb1                	bnez	a5,19e <dispatch+0x68>
		if(!setjmp(current_thread->env)){
 14c:	02050513          	addi	a0,a0,32
 150:	00001097          	auipc	ra,0x1
 154:	858080e7          	jalr	-1960(ra) # 9a8 <setjmp>
 158:	c50d                	beqz	a0,182 <dispatch+0x4c>
		current_thread->buf_set++;
 15a:	00001797          	auipc	a5,0x1
 15e:	8e67b783          	ld	a5,-1818(a5) # a40 <current_thread>
 162:	0947a703          	lw	a4,148(a5)
 166:	2705                	addiw	a4,a4,1
 168:	08e7aa23          	sw	a4,148(a5)
		current_thread->fp(current_thread->arg);
 16c:	6398                	ld	a4,0(a5)
 16e:	6788                	ld	a0,8(a5)
 170:	9702                	jalr	a4
		thread_exit();
 172:	00000097          	auipc	ra,0x0
 176:	f3c080e7          	jalr	-196(ra) # ae <thread_exit>
}
 17a:	60a2                	ld	ra,8(sp)
 17c:	6402                	ld	s0,0(sp)
 17e:	0141                	addi	sp,sp,16
 180:	8082                	ret
			current_thread->env->sp = (unsigned long)current_thread->stack_p;
 182:	00001517          	auipc	a0,0x1
 186:	8be53503          	ld	a0,-1858(a0) # a40 <current_thread>
 18a:	6d1c                	ld	a5,24(a0)
 18c:	e55c                	sd	a5,136(a0)
			longjmp(current_thread->env, 1);
 18e:	4585                	li	a1,1
 190:	02050513          	addi	a0,a0,32
 194:	00001097          	auipc	ra,0x1
 198:	84c080e7          	jalr	-1972(ra) # 9e0 <longjmp>
 19c:	bf7d                	j	15a <dispatch+0x24>
		current_thread->buf_set++;
 19e:	2785                	addiw	a5,a5,1
 1a0:	08f52a23          	sw	a5,148(a0)
		longjmp(current_thread->env, 1);
 1a4:	4585                	li	a1,1
 1a6:	02050513          	addi	a0,a0,32
 1aa:	00001097          	auipc	ra,0x1
 1ae:	836080e7          	jalr	-1994(ra) # 9e0 <longjmp>
}
 1b2:	b7e1                	j	17a <dispatch+0x44>

00000000000001b4 <thread_yield>:
void thread_yield(void){
 1b4:	1141                	addi	sp,sp,-16
 1b6:	e406                	sd	ra,8(sp)
 1b8:	e022                	sd	s0,0(sp)
 1ba:	0800                	addi	s0,sp,16
	if(!setjmp(current_thread->env)){
 1bc:	00001517          	auipc	a0,0x1
 1c0:	88453503          	ld	a0,-1916(a0) # a40 <current_thread>
 1c4:	02050513          	addi	a0,a0,32
 1c8:	00000097          	auipc	ra,0x0
 1cc:	7e0080e7          	jalr	2016(ra) # 9a8 <setjmp>
 1d0:	c509                	beqz	a0,1da <thread_yield+0x26>
}
 1d2:	60a2                	ld	ra,8(sp)
 1d4:	6402                	ld	s0,0(sp)
 1d6:	0141                	addi	sp,sp,16
 1d8:	8082                	ret
		schedule();
 1da:	00000097          	auipc	ra,0x0
 1de:	eba080e7          	jalr	-326(ra) # 94 <schedule>
		dispatch();
 1e2:	00000097          	auipc	ra,0x0
 1e6:	f54080e7          	jalr	-172(ra) # 136 <dispatch>
}
 1ea:	b7e5                	j	1d2 <thread_yield+0x1e>

00000000000001ec <thread_start_threading>:
void thread_start_threading(void){
 1ec:	1141                	addi	sp,sp,-16
 1ee:	e406                	sd	ra,8(sp)
 1f0:	e022                	sd	s0,0(sp)
 1f2:	0800                	addi	s0,sp,16
	schedule();
 1f4:	00000097          	auipc	ra,0x0
 1f8:	ea0080e7          	jalr	-352(ra) # 94 <schedule>
	if(!setjmp(env_st)) dispatch();
 1fc:	00001517          	auipc	a0,0x1
 200:	85450513          	addi	a0,a0,-1964 # a50 <env_st>
 204:	00000097          	auipc	ra,0x0
 208:	7a4080e7          	jalr	1956(ra) # 9a8 <setjmp>
 20c:	c509                	beqz	a0,216 <thread_start_threading+0x2a>
}
 20e:	60a2                	ld	ra,8(sp)
 210:	6402                	ld	s0,0(sp)
 212:	0141                	addi	sp,sp,16
 214:	8082                	ret
	if(!setjmp(env_st)) dispatch();
 216:	00000097          	auipc	ra,0x0
 21a:	f20080e7          	jalr	-224(ra) # 136 <dispatch>
}
 21e:	bfc5                	j	20e <thread_start_threading+0x22>

0000000000000220 <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
 220:	1141                	addi	sp,sp,-16
 222:	e422                	sd	s0,8(sp)
 224:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 226:	87aa                	mv	a5,a0
 228:	0585                	addi	a1,a1,1
 22a:	0785                	addi	a5,a5,1
 22c:	fff5c703          	lbu	a4,-1(a1)
 230:	fee78fa3          	sb	a4,-1(a5)
 234:	fb75                	bnez	a4,228 <strcpy+0x8>
    ;
  return os;
}
 236:	6422                	ld	s0,8(sp)
 238:	0141                	addi	sp,sp,16
 23a:	8082                	ret

000000000000023c <strcmp>:

int
strcmp(const char *p, const char *q)
{
 23c:	1141                	addi	sp,sp,-16
 23e:	e422                	sd	s0,8(sp)
 240:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 242:	00054783          	lbu	a5,0(a0)
 246:	cb91                	beqz	a5,25a <strcmp+0x1e>
 248:	0005c703          	lbu	a4,0(a1)
 24c:	00f71763          	bne	a4,a5,25a <strcmp+0x1e>
    p++, q++;
 250:	0505                	addi	a0,a0,1
 252:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 254:	00054783          	lbu	a5,0(a0)
 258:	fbe5                	bnez	a5,248 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 25a:	0005c503          	lbu	a0,0(a1)
}
 25e:	40a7853b          	subw	a0,a5,a0
 262:	6422                	ld	s0,8(sp)
 264:	0141                	addi	sp,sp,16
 266:	8082                	ret

0000000000000268 <strlen>:

uint
strlen(const char *s)
{
 268:	1141                	addi	sp,sp,-16
 26a:	e422                	sd	s0,8(sp)
 26c:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 26e:	00054783          	lbu	a5,0(a0)
 272:	cf91                	beqz	a5,28e <strlen+0x26>
 274:	0505                	addi	a0,a0,1
 276:	87aa                	mv	a5,a0
 278:	4685                	li	a3,1
 27a:	9e89                	subw	a3,a3,a0
 27c:	00f6853b          	addw	a0,a3,a5
 280:	0785                	addi	a5,a5,1
 282:	fff7c703          	lbu	a4,-1(a5)
 286:	fb7d                	bnez	a4,27c <strlen+0x14>
    ;
  return n;
}
 288:	6422                	ld	s0,8(sp)
 28a:	0141                	addi	sp,sp,16
 28c:	8082                	ret
  for(n = 0; s[n]; n++)
 28e:	4501                	li	a0,0
 290:	bfe5                	j	288 <strlen+0x20>

0000000000000292 <memset>:

void*
memset(void *dst, int c, uint n)
{
 292:	1141                	addi	sp,sp,-16
 294:	e422                	sd	s0,8(sp)
 296:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 298:	ca19                	beqz	a2,2ae <memset+0x1c>
 29a:	87aa                	mv	a5,a0
 29c:	1602                	slli	a2,a2,0x20
 29e:	9201                	srli	a2,a2,0x20
 2a0:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 2a4:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 2a8:	0785                	addi	a5,a5,1
 2aa:	fee79de3          	bne	a5,a4,2a4 <memset+0x12>
  }
  return dst;
}
 2ae:	6422                	ld	s0,8(sp)
 2b0:	0141                	addi	sp,sp,16
 2b2:	8082                	ret

00000000000002b4 <strchr>:

char*
strchr(const char *s, char c)
{
 2b4:	1141                	addi	sp,sp,-16
 2b6:	e422                	sd	s0,8(sp)
 2b8:	0800                	addi	s0,sp,16
  for(; *s; s++)
 2ba:	00054783          	lbu	a5,0(a0)
 2be:	cb99                	beqz	a5,2d4 <strchr+0x20>
    if(*s == c)
 2c0:	00f58763          	beq	a1,a5,2ce <strchr+0x1a>
  for(; *s; s++)
 2c4:	0505                	addi	a0,a0,1
 2c6:	00054783          	lbu	a5,0(a0)
 2ca:	fbfd                	bnez	a5,2c0 <strchr+0xc>
      return (char*)s;
  return 0;
 2cc:	4501                	li	a0,0
}
 2ce:	6422                	ld	s0,8(sp)
 2d0:	0141                	addi	sp,sp,16
 2d2:	8082                	ret
  return 0;
 2d4:	4501                	li	a0,0
 2d6:	bfe5                	j	2ce <strchr+0x1a>

00000000000002d8 <gets>:

char*
gets(char *buf, int max)
{
 2d8:	711d                	addi	sp,sp,-96
 2da:	ec86                	sd	ra,88(sp)
 2dc:	e8a2                	sd	s0,80(sp)
 2de:	e4a6                	sd	s1,72(sp)
 2e0:	e0ca                	sd	s2,64(sp)
 2e2:	fc4e                	sd	s3,56(sp)
 2e4:	f852                	sd	s4,48(sp)
 2e6:	f456                	sd	s5,40(sp)
 2e8:	f05a                	sd	s6,32(sp)
 2ea:	ec5e                	sd	s7,24(sp)
 2ec:	1080                	addi	s0,sp,96
 2ee:	8baa                	mv	s7,a0
 2f0:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 2f2:	892a                	mv	s2,a0
 2f4:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 2f6:	4aa9                	li	s5,10
 2f8:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 2fa:	89a6                	mv	s3,s1
 2fc:	2485                	addiw	s1,s1,1
 2fe:	0344d863          	bge	s1,s4,32e <gets+0x56>
    cc = read(0, &c, 1);
 302:	4605                	li	a2,1
 304:	faf40593          	addi	a1,s0,-81
 308:	4501                	li	a0,0
 30a:	00000097          	auipc	ra,0x0
 30e:	19c080e7          	jalr	412(ra) # 4a6 <read>
    if(cc < 1)
 312:	00a05e63          	blez	a0,32e <gets+0x56>
    buf[i++] = c;
 316:	faf44783          	lbu	a5,-81(s0)
 31a:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 31e:	01578763          	beq	a5,s5,32c <gets+0x54>
 322:	0905                	addi	s2,s2,1
 324:	fd679be3          	bne	a5,s6,2fa <gets+0x22>
  for(i=0; i+1 < max; ){
 328:	89a6                	mv	s3,s1
 32a:	a011                	j	32e <gets+0x56>
 32c:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 32e:	99de                	add	s3,s3,s7
 330:	00098023          	sb	zero,0(s3)
  return buf;
}
 334:	855e                	mv	a0,s7
 336:	60e6                	ld	ra,88(sp)
 338:	6446                	ld	s0,80(sp)
 33a:	64a6                	ld	s1,72(sp)
 33c:	6906                	ld	s2,64(sp)
 33e:	79e2                	ld	s3,56(sp)
 340:	7a42                	ld	s4,48(sp)
 342:	7aa2                	ld	s5,40(sp)
 344:	7b02                	ld	s6,32(sp)
 346:	6be2                	ld	s7,24(sp)
 348:	6125                	addi	sp,sp,96
 34a:	8082                	ret

000000000000034c <stat>:

int
stat(const char *n, struct stat *st)
{
 34c:	1101                	addi	sp,sp,-32
 34e:	ec06                	sd	ra,24(sp)
 350:	e822                	sd	s0,16(sp)
 352:	e426                	sd	s1,8(sp)
 354:	e04a                	sd	s2,0(sp)
 356:	1000                	addi	s0,sp,32
 358:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 35a:	4581                	li	a1,0
 35c:	00000097          	auipc	ra,0x0
 360:	172080e7          	jalr	370(ra) # 4ce <open>
  if(fd < 0)
 364:	02054563          	bltz	a0,38e <stat+0x42>
 368:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 36a:	85ca                	mv	a1,s2
 36c:	00000097          	auipc	ra,0x0
 370:	17a080e7          	jalr	378(ra) # 4e6 <fstat>
 374:	892a                	mv	s2,a0
  close(fd);
 376:	8526                	mv	a0,s1
 378:	00000097          	auipc	ra,0x0
 37c:	13e080e7          	jalr	318(ra) # 4b6 <close>
  return r;
}
 380:	854a                	mv	a0,s2
 382:	60e2                	ld	ra,24(sp)
 384:	6442                	ld	s0,16(sp)
 386:	64a2                	ld	s1,8(sp)
 388:	6902                	ld	s2,0(sp)
 38a:	6105                	addi	sp,sp,32
 38c:	8082                	ret
    return -1;
 38e:	597d                	li	s2,-1
 390:	bfc5                	j	380 <stat+0x34>

0000000000000392 <atoi>:

int
atoi(const char *s)
{
 392:	1141                	addi	sp,sp,-16
 394:	e422                	sd	s0,8(sp)
 396:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 398:	00054603          	lbu	a2,0(a0)
 39c:	fd06079b          	addiw	a5,a2,-48
 3a0:	0ff7f793          	andi	a5,a5,255
 3a4:	4725                	li	a4,9
 3a6:	02f76963          	bltu	a4,a5,3d8 <atoi+0x46>
 3aa:	86aa                	mv	a3,a0
  n = 0;
 3ac:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 3ae:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 3b0:	0685                	addi	a3,a3,1
 3b2:	0025179b          	slliw	a5,a0,0x2
 3b6:	9fa9                	addw	a5,a5,a0
 3b8:	0017979b          	slliw	a5,a5,0x1
 3bc:	9fb1                	addw	a5,a5,a2
 3be:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 3c2:	0006c603          	lbu	a2,0(a3)
 3c6:	fd06071b          	addiw	a4,a2,-48
 3ca:	0ff77713          	andi	a4,a4,255
 3ce:	fee5f1e3          	bgeu	a1,a4,3b0 <atoi+0x1e>
  return n;
}
 3d2:	6422                	ld	s0,8(sp)
 3d4:	0141                	addi	sp,sp,16
 3d6:	8082                	ret
  n = 0;
 3d8:	4501                	li	a0,0
 3da:	bfe5                	j	3d2 <atoi+0x40>

00000000000003dc <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 3dc:	1141                	addi	sp,sp,-16
 3de:	e422                	sd	s0,8(sp)
 3e0:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 3e2:	02b57463          	bgeu	a0,a1,40a <memmove+0x2e>
    while(n-- > 0)
 3e6:	00c05f63          	blez	a2,404 <memmove+0x28>
 3ea:	1602                	slli	a2,a2,0x20
 3ec:	9201                	srli	a2,a2,0x20
 3ee:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 3f2:	872a                	mv	a4,a0
      *dst++ = *src++;
 3f4:	0585                	addi	a1,a1,1
 3f6:	0705                	addi	a4,a4,1
 3f8:	fff5c683          	lbu	a3,-1(a1)
 3fc:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 400:	fee79ae3          	bne	a5,a4,3f4 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 404:	6422                	ld	s0,8(sp)
 406:	0141                	addi	sp,sp,16
 408:	8082                	ret
    dst += n;
 40a:	00c50733          	add	a4,a0,a2
    src += n;
 40e:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 410:	fec05ae3          	blez	a2,404 <memmove+0x28>
 414:	fff6079b          	addiw	a5,a2,-1
 418:	1782                	slli	a5,a5,0x20
 41a:	9381                	srli	a5,a5,0x20
 41c:	fff7c793          	not	a5,a5
 420:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 422:	15fd                	addi	a1,a1,-1
 424:	177d                	addi	a4,a4,-1
 426:	0005c683          	lbu	a3,0(a1)
 42a:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 42e:	fee79ae3          	bne	a5,a4,422 <memmove+0x46>
 432:	bfc9                	j	404 <memmove+0x28>

0000000000000434 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 434:	1141                	addi	sp,sp,-16
 436:	e422                	sd	s0,8(sp)
 438:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 43a:	ca05                	beqz	a2,46a <memcmp+0x36>
 43c:	fff6069b          	addiw	a3,a2,-1
 440:	1682                	slli	a3,a3,0x20
 442:	9281                	srli	a3,a3,0x20
 444:	0685                	addi	a3,a3,1
 446:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 448:	00054783          	lbu	a5,0(a0)
 44c:	0005c703          	lbu	a4,0(a1)
 450:	00e79863          	bne	a5,a4,460 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 454:	0505                	addi	a0,a0,1
    p2++;
 456:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 458:	fed518e3          	bne	a0,a3,448 <memcmp+0x14>
  }
  return 0;
 45c:	4501                	li	a0,0
 45e:	a019                	j	464 <memcmp+0x30>
      return *p1 - *p2;
 460:	40e7853b          	subw	a0,a5,a4
}
 464:	6422                	ld	s0,8(sp)
 466:	0141                	addi	sp,sp,16
 468:	8082                	ret
  return 0;
 46a:	4501                	li	a0,0
 46c:	bfe5                	j	464 <memcmp+0x30>

000000000000046e <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 46e:	1141                	addi	sp,sp,-16
 470:	e406                	sd	ra,8(sp)
 472:	e022                	sd	s0,0(sp)
 474:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 476:	00000097          	auipc	ra,0x0
 47a:	f66080e7          	jalr	-154(ra) # 3dc <memmove>
}
 47e:	60a2                	ld	ra,8(sp)
 480:	6402                	ld	s0,0(sp)
 482:	0141                	addi	sp,sp,16
 484:	8082                	ret

0000000000000486 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 486:	4885                	li	a7,1
 ecall
 488:	00000073          	ecall
 ret
 48c:	8082                	ret

000000000000048e <exit>:
.global exit
exit:
 li a7, SYS_exit
 48e:	4889                	li	a7,2
 ecall
 490:	00000073          	ecall
 ret
 494:	8082                	ret

0000000000000496 <wait>:
.global wait
wait:
 li a7, SYS_wait
 496:	488d                	li	a7,3
 ecall
 498:	00000073          	ecall
 ret
 49c:	8082                	ret

000000000000049e <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 49e:	4891                	li	a7,4
 ecall
 4a0:	00000073          	ecall
 ret
 4a4:	8082                	ret

00000000000004a6 <read>:
.global read
read:
 li a7, SYS_read
 4a6:	4895                	li	a7,5
 ecall
 4a8:	00000073          	ecall
 ret
 4ac:	8082                	ret

00000000000004ae <write>:
.global write
write:
 li a7, SYS_write
 4ae:	48c1                	li	a7,16
 ecall
 4b0:	00000073          	ecall
 ret
 4b4:	8082                	ret

00000000000004b6 <close>:
.global close
close:
 li a7, SYS_close
 4b6:	48d5                	li	a7,21
 ecall
 4b8:	00000073          	ecall
 ret
 4bc:	8082                	ret

00000000000004be <kill>:
.global kill
kill:
 li a7, SYS_kill
 4be:	4899                	li	a7,6
 ecall
 4c0:	00000073          	ecall
 ret
 4c4:	8082                	ret

00000000000004c6 <exec>:
.global exec
exec:
 li a7, SYS_exec
 4c6:	489d                	li	a7,7
 ecall
 4c8:	00000073          	ecall
 ret
 4cc:	8082                	ret

00000000000004ce <open>:
.global open
open:
 li a7, SYS_open
 4ce:	48bd                	li	a7,15
 ecall
 4d0:	00000073          	ecall
 ret
 4d4:	8082                	ret

00000000000004d6 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 4d6:	48c5                	li	a7,17
 ecall
 4d8:	00000073          	ecall
 ret
 4dc:	8082                	ret

00000000000004de <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 4de:	48c9                	li	a7,18
 ecall
 4e0:	00000073          	ecall
 ret
 4e4:	8082                	ret

00000000000004e6 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 4e6:	48a1                	li	a7,8
 ecall
 4e8:	00000073          	ecall
 ret
 4ec:	8082                	ret

00000000000004ee <link>:
.global link
link:
 li a7, SYS_link
 4ee:	48cd                	li	a7,19
 ecall
 4f0:	00000073          	ecall
 ret
 4f4:	8082                	ret

00000000000004f6 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 4f6:	48d1                	li	a7,20
 ecall
 4f8:	00000073          	ecall
 ret
 4fc:	8082                	ret

00000000000004fe <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 4fe:	48a5                	li	a7,9
 ecall
 500:	00000073          	ecall
 ret
 504:	8082                	ret

0000000000000506 <dup>:
.global dup
dup:
 li a7, SYS_dup
 506:	48a9                	li	a7,10
 ecall
 508:	00000073          	ecall
 ret
 50c:	8082                	ret

000000000000050e <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 50e:	48ad                	li	a7,11
 ecall
 510:	00000073          	ecall
 ret
 514:	8082                	ret

0000000000000516 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 516:	48b1                	li	a7,12
 ecall
 518:	00000073          	ecall
 ret
 51c:	8082                	ret

000000000000051e <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 51e:	48b5                	li	a7,13
 ecall
 520:	00000073          	ecall
 ret
 524:	8082                	ret

0000000000000526 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 526:	48b9                	li	a7,14
 ecall
 528:	00000073          	ecall
 ret
 52c:	8082                	ret

000000000000052e <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 52e:	1101                	addi	sp,sp,-32
 530:	ec06                	sd	ra,24(sp)
 532:	e822                	sd	s0,16(sp)
 534:	1000                	addi	s0,sp,32
 536:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 53a:	4605                	li	a2,1
 53c:	fef40593          	addi	a1,s0,-17
 540:	00000097          	auipc	ra,0x0
 544:	f6e080e7          	jalr	-146(ra) # 4ae <write>
}
 548:	60e2                	ld	ra,24(sp)
 54a:	6442                	ld	s0,16(sp)
 54c:	6105                	addi	sp,sp,32
 54e:	8082                	ret

0000000000000550 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 550:	7139                	addi	sp,sp,-64
 552:	fc06                	sd	ra,56(sp)
 554:	f822                	sd	s0,48(sp)
 556:	f426                	sd	s1,40(sp)
 558:	f04a                	sd	s2,32(sp)
 55a:	ec4e                	sd	s3,24(sp)
 55c:	0080                	addi	s0,sp,64
 55e:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 560:	c299                	beqz	a3,566 <printint+0x16>
 562:	0805c863          	bltz	a1,5f2 <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 566:	2581                	sext.w	a1,a1
  neg = 0;
 568:	4881                	li	a7,0
 56a:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 56e:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 570:	2601                	sext.w	a2,a2
 572:	00000517          	auipc	a0,0x0
 576:	4b650513          	addi	a0,a0,1206 # a28 <digits>
 57a:	883a                	mv	a6,a4
 57c:	2705                	addiw	a4,a4,1
 57e:	02c5f7bb          	remuw	a5,a1,a2
 582:	1782                	slli	a5,a5,0x20
 584:	9381                	srli	a5,a5,0x20
 586:	97aa                	add	a5,a5,a0
 588:	0007c783          	lbu	a5,0(a5)
 58c:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 590:	0005879b          	sext.w	a5,a1
 594:	02c5d5bb          	divuw	a1,a1,a2
 598:	0685                	addi	a3,a3,1
 59a:	fec7f0e3          	bgeu	a5,a2,57a <printint+0x2a>
  if(neg)
 59e:	00088b63          	beqz	a7,5b4 <printint+0x64>
    buf[i++] = '-';
 5a2:	fd040793          	addi	a5,s0,-48
 5a6:	973e                	add	a4,a4,a5
 5a8:	02d00793          	li	a5,45
 5ac:	fef70823          	sb	a5,-16(a4)
 5b0:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 5b4:	02e05863          	blez	a4,5e4 <printint+0x94>
 5b8:	fc040793          	addi	a5,s0,-64
 5bc:	00e78933          	add	s2,a5,a4
 5c0:	fff78993          	addi	s3,a5,-1
 5c4:	99ba                	add	s3,s3,a4
 5c6:	377d                	addiw	a4,a4,-1
 5c8:	1702                	slli	a4,a4,0x20
 5ca:	9301                	srli	a4,a4,0x20
 5cc:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 5d0:	fff94583          	lbu	a1,-1(s2)
 5d4:	8526                	mv	a0,s1
 5d6:	00000097          	auipc	ra,0x0
 5da:	f58080e7          	jalr	-168(ra) # 52e <putc>
  while(--i >= 0)
 5de:	197d                	addi	s2,s2,-1
 5e0:	ff3918e3          	bne	s2,s3,5d0 <printint+0x80>
}
 5e4:	70e2                	ld	ra,56(sp)
 5e6:	7442                	ld	s0,48(sp)
 5e8:	74a2                	ld	s1,40(sp)
 5ea:	7902                	ld	s2,32(sp)
 5ec:	69e2                	ld	s3,24(sp)
 5ee:	6121                	addi	sp,sp,64
 5f0:	8082                	ret
    x = -xx;
 5f2:	40b005bb          	negw	a1,a1
    neg = 1;
 5f6:	4885                	li	a7,1
    x = -xx;
 5f8:	bf8d                	j	56a <printint+0x1a>

00000000000005fa <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 5fa:	7119                	addi	sp,sp,-128
 5fc:	fc86                	sd	ra,120(sp)
 5fe:	f8a2                	sd	s0,112(sp)
 600:	f4a6                	sd	s1,104(sp)
 602:	f0ca                	sd	s2,96(sp)
 604:	ecce                	sd	s3,88(sp)
 606:	e8d2                	sd	s4,80(sp)
 608:	e4d6                	sd	s5,72(sp)
 60a:	e0da                	sd	s6,64(sp)
 60c:	fc5e                	sd	s7,56(sp)
 60e:	f862                	sd	s8,48(sp)
 610:	f466                	sd	s9,40(sp)
 612:	f06a                	sd	s10,32(sp)
 614:	ec6e                	sd	s11,24(sp)
 616:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 618:	0005c903          	lbu	s2,0(a1)
 61c:	18090f63          	beqz	s2,7ba <vprintf+0x1c0>
 620:	8aaa                	mv	s5,a0
 622:	8b32                	mv	s6,a2
 624:	00158493          	addi	s1,a1,1
  state = 0;
 628:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 62a:	02500a13          	li	s4,37
      if(c == 'd'){
 62e:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 632:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 636:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 63a:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 63e:	00000b97          	auipc	s7,0x0
 642:	3eab8b93          	addi	s7,s7,1002 # a28 <digits>
 646:	a839                	j	664 <vprintf+0x6a>
        putc(fd, c);
 648:	85ca                	mv	a1,s2
 64a:	8556                	mv	a0,s5
 64c:	00000097          	auipc	ra,0x0
 650:	ee2080e7          	jalr	-286(ra) # 52e <putc>
 654:	a019                	j	65a <vprintf+0x60>
    } else if(state == '%'){
 656:	01498f63          	beq	s3,s4,674 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 65a:	0485                	addi	s1,s1,1
 65c:	fff4c903          	lbu	s2,-1(s1)
 660:	14090d63          	beqz	s2,7ba <vprintf+0x1c0>
    c = fmt[i] & 0xff;
 664:	0009079b          	sext.w	a5,s2
    if(state == 0){
 668:	fe0997e3          	bnez	s3,656 <vprintf+0x5c>
      if(c == '%'){
 66c:	fd479ee3          	bne	a5,s4,648 <vprintf+0x4e>
        state = '%';
 670:	89be                	mv	s3,a5
 672:	b7e5                	j	65a <vprintf+0x60>
      if(c == 'd'){
 674:	05878063          	beq	a5,s8,6b4 <vprintf+0xba>
      } else if(c == 'l') {
 678:	05978c63          	beq	a5,s9,6d0 <vprintf+0xd6>
      } else if(c == 'x') {
 67c:	07a78863          	beq	a5,s10,6ec <vprintf+0xf2>
      } else if(c == 'p') {
 680:	09b78463          	beq	a5,s11,708 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 684:	07300713          	li	a4,115
 688:	0ce78663          	beq	a5,a4,754 <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 68c:	06300713          	li	a4,99
 690:	0ee78e63          	beq	a5,a4,78c <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 694:	11478863          	beq	a5,s4,7a4 <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 698:	85d2                	mv	a1,s4
 69a:	8556                	mv	a0,s5
 69c:	00000097          	auipc	ra,0x0
 6a0:	e92080e7          	jalr	-366(ra) # 52e <putc>
        putc(fd, c);
 6a4:	85ca                	mv	a1,s2
 6a6:	8556                	mv	a0,s5
 6a8:	00000097          	auipc	ra,0x0
 6ac:	e86080e7          	jalr	-378(ra) # 52e <putc>
      }
      state = 0;
 6b0:	4981                	li	s3,0
 6b2:	b765                	j	65a <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 6b4:	008b0913          	addi	s2,s6,8
 6b8:	4685                	li	a3,1
 6ba:	4629                	li	a2,10
 6bc:	000b2583          	lw	a1,0(s6)
 6c0:	8556                	mv	a0,s5
 6c2:	00000097          	auipc	ra,0x0
 6c6:	e8e080e7          	jalr	-370(ra) # 550 <printint>
 6ca:	8b4a                	mv	s6,s2
      state = 0;
 6cc:	4981                	li	s3,0
 6ce:	b771                	j	65a <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 6d0:	008b0913          	addi	s2,s6,8
 6d4:	4681                	li	a3,0
 6d6:	4629                	li	a2,10
 6d8:	000b2583          	lw	a1,0(s6)
 6dc:	8556                	mv	a0,s5
 6de:	00000097          	auipc	ra,0x0
 6e2:	e72080e7          	jalr	-398(ra) # 550 <printint>
 6e6:	8b4a                	mv	s6,s2
      state = 0;
 6e8:	4981                	li	s3,0
 6ea:	bf85                	j	65a <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 6ec:	008b0913          	addi	s2,s6,8
 6f0:	4681                	li	a3,0
 6f2:	4641                	li	a2,16
 6f4:	000b2583          	lw	a1,0(s6)
 6f8:	8556                	mv	a0,s5
 6fa:	00000097          	auipc	ra,0x0
 6fe:	e56080e7          	jalr	-426(ra) # 550 <printint>
 702:	8b4a                	mv	s6,s2
      state = 0;
 704:	4981                	li	s3,0
 706:	bf91                	j	65a <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 708:	008b0793          	addi	a5,s6,8
 70c:	f8f43423          	sd	a5,-120(s0)
 710:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 714:	03000593          	li	a1,48
 718:	8556                	mv	a0,s5
 71a:	00000097          	auipc	ra,0x0
 71e:	e14080e7          	jalr	-492(ra) # 52e <putc>
  putc(fd, 'x');
 722:	85ea                	mv	a1,s10
 724:	8556                	mv	a0,s5
 726:	00000097          	auipc	ra,0x0
 72a:	e08080e7          	jalr	-504(ra) # 52e <putc>
 72e:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 730:	03c9d793          	srli	a5,s3,0x3c
 734:	97de                	add	a5,a5,s7
 736:	0007c583          	lbu	a1,0(a5)
 73a:	8556                	mv	a0,s5
 73c:	00000097          	auipc	ra,0x0
 740:	df2080e7          	jalr	-526(ra) # 52e <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 744:	0992                	slli	s3,s3,0x4
 746:	397d                	addiw	s2,s2,-1
 748:	fe0914e3          	bnez	s2,730 <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 74c:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 750:	4981                	li	s3,0
 752:	b721                	j	65a <vprintf+0x60>
        s = va_arg(ap, char*);
 754:	008b0993          	addi	s3,s6,8
 758:	000b3903          	ld	s2,0(s6)
        if(s == 0)
 75c:	02090163          	beqz	s2,77e <vprintf+0x184>
        while(*s != 0){
 760:	00094583          	lbu	a1,0(s2)
 764:	c9a1                	beqz	a1,7b4 <vprintf+0x1ba>
          putc(fd, *s);
 766:	8556                	mv	a0,s5
 768:	00000097          	auipc	ra,0x0
 76c:	dc6080e7          	jalr	-570(ra) # 52e <putc>
          s++;
 770:	0905                	addi	s2,s2,1
        while(*s != 0){
 772:	00094583          	lbu	a1,0(s2)
 776:	f9e5                	bnez	a1,766 <vprintf+0x16c>
        s = va_arg(ap, char*);
 778:	8b4e                	mv	s6,s3
      state = 0;
 77a:	4981                	li	s3,0
 77c:	bdf9                	j	65a <vprintf+0x60>
          s = "(null)";
 77e:	00000917          	auipc	s2,0x0
 782:	2a290913          	addi	s2,s2,674 # a20 <longjmp_1+0x6>
        while(*s != 0){
 786:	02800593          	li	a1,40
 78a:	bff1                	j	766 <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
 78c:	008b0913          	addi	s2,s6,8
 790:	000b4583          	lbu	a1,0(s6)
 794:	8556                	mv	a0,s5
 796:	00000097          	auipc	ra,0x0
 79a:	d98080e7          	jalr	-616(ra) # 52e <putc>
 79e:	8b4a                	mv	s6,s2
      state = 0;
 7a0:	4981                	li	s3,0
 7a2:	bd65                	j	65a <vprintf+0x60>
        putc(fd, c);
 7a4:	85d2                	mv	a1,s4
 7a6:	8556                	mv	a0,s5
 7a8:	00000097          	auipc	ra,0x0
 7ac:	d86080e7          	jalr	-634(ra) # 52e <putc>
      state = 0;
 7b0:	4981                	li	s3,0
 7b2:	b565                	j	65a <vprintf+0x60>
        s = va_arg(ap, char*);
 7b4:	8b4e                	mv	s6,s3
      state = 0;
 7b6:	4981                	li	s3,0
 7b8:	b54d                	j	65a <vprintf+0x60>
    }
  }
}
 7ba:	70e6                	ld	ra,120(sp)
 7bc:	7446                	ld	s0,112(sp)
 7be:	74a6                	ld	s1,104(sp)
 7c0:	7906                	ld	s2,96(sp)
 7c2:	69e6                	ld	s3,88(sp)
 7c4:	6a46                	ld	s4,80(sp)
 7c6:	6aa6                	ld	s5,72(sp)
 7c8:	6b06                	ld	s6,64(sp)
 7ca:	7be2                	ld	s7,56(sp)
 7cc:	7c42                	ld	s8,48(sp)
 7ce:	7ca2                	ld	s9,40(sp)
 7d0:	7d02                	ld	s10,32(sp)
 7d2:	6de2                	ld	s11,24(sp)
 7d4:	6109                	addi	sp,sp,128
 7d6:	8082                	ret

00000000000007d8 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 7d8:	715d                	addi	sp,sp,-80
 7da:	ec06                	sd	ra,24(sp)
 7dc:	e822                	sd	s0,16(sp)
 7de:	1000                	addi	s0,sp,32
 7e0:	e010                	sd	a2,0(s0)
 7e2:	e414                	sd	a3,8(s0)
 7e4:	e818                	sd	a4,16(s0)
 7e6:	ec1c                	sd	a5,24(s0)
 7e8:	03043023          	sd	a6,32(s0)
 7ec:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 7f0:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 7f4:	8622                	mv	a2,s0
 7f6:	00000097          	auipc	ra,0x0
 7fa:	e04080e7          	jalr	-508(ra) # 5fa <vprintf>
}
 7fe:	60e2                	ld	ra,24(sp)
 800:	6442                	ld	s0,16(sp)
 802:	6161                	addi	sp,sp,80
 804:	8082                	ret

0000000000000806 <printf>:

void
printf(const char *fmt, ...)
{
 806:	711d                	addi	sp,sp,-96
 808:	ec06                	sd	ra,24(sp)
 80a:	e822                	sd	s0,16(sp)
 80c:	1000                	addi	s0,sp,32
 80e:	e40c                	sd	a1,8(s0)
 810:	e810                	sd	a2,16(s0)
 812:	ec14                	sd	a3,24(s0)
 814:	f018                	sd	a4,32(s0)
 816:	f41c                	sd	a5,40(s0)
 818:	03043823          	sd	a6,48(s0)
 81c:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 820:	00840613          	addi	a2,s0,8
 824:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 828:	85aa                	mv	a1,a0
 82a:	4505                	li	a0,1
 82c:	00000097          	auipc	ra,0x0
 830:	dce080e7          	jalr	-562(ra) # 5fa <vprintf>
}
 834:	60e2                	ld	ra,24(sp)
 836:	6442                	ld	s0,16(sp)
 838:	6125                	addi	sp,sp,96
 83a:	8082                	ret

000000000000083c <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 83c:	1141                	addi	sp,sp,-16
 83e:	e422                	sd	s0,8(sp)
 840:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 842:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 846:	00000797          	auipc	a5,0x0
 84a:	2027b783          	ld	a5,514(a5) # a48 <freep>
 84e:	a805                	j	87e <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 850:	4618                	lw	a4,8(a2)
 852:	9db9                	addw	a1,a1,a4
 854:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 858:	6398                	ld	a4,0(a5)
 85a:	6318                	ld	a4,0(a4)
 85c:	fee53823          	sd	a4,-16(a0)
 860:	a091                	j	8a4 <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 862:	ff852703          	lw	a4,-8(a0)
 866:	9e39                	addw	a2,a2,a4
 868:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 86a:	ff053703          	ld	a4,-16(a0)
 86e:	e398                	sd	a4,0(a5)
 870:	a099                	j	8b6 <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 872:	6398                	ld	a4,0(a5)
 874:	00e7e463          	bltu	a5,a4,87c <free+0x40>
 878:	00e6ea63          	bltu	a3,a4,88c <free+0x50>
{
 87c:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 87e:	fed7fae3          	bgeu	a5,a3,872 <free+0x36>
 882:	6398                	ld	a4,0(a5)
 884:	00e6e463          	bltu	a3,a4,88c <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 888:	fee7eae3          	bltu	a5,a4,87c <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 88c:	ff852583          	lw	a1,-8(a0)
 890:	6390                	ld	a2,0(a5)
 892:	02059713          	slli	a4,a1,0x20
 896:	9301                	srli	a4,a4,0x20
 898:	0712                	slli	a4,a4,0x4
 89a:	9736                	add	a4,a4,a3
 89c:	fae60ae3          	beq	a2,a4,850 <free+0x14>
    bp->s.ptr = p->s.ptr;
 8a0:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 8a4:	4790                	lw	a2,8(a5)
 8a6:	02061713          	slli	a4,a2,0x20
 8aa:	9301                	srli	a4,a4,0x20
 8ac:	0712                	slli	a4,a4,0x4
 8ae:	973e                	add	a4,a4,a5
 8b0:	fae689e3          	beq	a3,a4,862 <free+0x26>
  } else
    p->s.ptr = bp;
 8b4:	e394                	sd	a3,0(a5)
  freep = p;
 8b6:	00000717          	auipc	a4,0x0
 8ba:	18f73923          	sd	a5,402(a4) # a48 <freep>
}
 8be:	6422                	ld	s0,8(sp)
 8c0:	0141                	addi	sp,sp,16
 8c2:	8082                	ret

00000000000008c4 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 8c4:	7139                	addi	sp,sp,-64
 8c6:	fc06                	sd	ra,56(sp)
 8c8:	f822                	sd	s0,48(sp)
 8ca:	f426                	sd	s1,40(sp)
 8cc:	f04a                	sd	s2,32(sp)
 8ce:	ec4e                	sd	s3,24(sp)
 8d0:	e852                	sd	s4,16(sp)
 8d2:	e456                	sd	s5,8(sp)
 8d4:	e05a                	sd	s6,0(sp)
 8d6:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 8d8:	02051493          	slli	s1,a0,0x20
 8dc:	9081                	srli	s1,s1,0x20
 8de:	04bd                	addi	s1,s1,15
 8e0:	8091                	srli	s1,s1,0x4
 8e2:	0014899b          	addiw	s3,s1,1
 8e6:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 8e8:	00000517          	auipc	a0,0x0
 8ec:	16053503          	ld	a0,352(a0) # a48 <freep>
 8f0:	c515                	beqz	a0,91c <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8f2:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8f4:	4798                	lw	a4,8(a5)
 8f6:	02977f63          	bgeu	a4,s1,934 <malloc+0x70>
 8fa:	8a4e                	mv	s4,s3
 8fc:	0009871b          	sext.w	a4,s3
 900:	6685                	lui	a3,0x1
 902:	00d77363          	bgeu	a4,a3,908 <malloc+0x44>
 906:	6a05                	lui	s4,0x1
 908:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 90c:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 910:	00000917          	auipc	s2,0x0
 914:	13890913          	addi	s2,s2,312 # a48 <freep>
  if(p == (char*)-1)
 918:	5afd                	li	s5,-1
 91a:	a88d                	j	98c <malloc+0xc8>
    base.s.ptr = freep = prevp = &base;
 91c:	00000797          	auipc	a5,0x0
 920:	1a478793          	addi	a5,a5,420 # ac0 <base>
 924:	00000717          	auipc	a4,0x0
 928:	12f73223          	sd	a5,292(a4) # a48 <freep>
 92c:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 92e:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 932:	b7e1                	j	8fa <malloc+0x36>
      if(p->s.size == nunits)
 934:	02e48b63          	beq	s1,a4,96a <malloc+0xa6>
        p->s.size -= nunits;
 938:	4137073b          	subw	a4,a4,s3
 93c:	c798                	sw	a4,8(a5)
        p += p->s.size;
 93e:	1702                	slli	a4,a4,0x20
 940:	9301                	srli	a4,a4,0x20
 942:	0712                	slli	a4,a4,0x4
 944:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 946:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 94a:	00000717          	auipc	a4,0x0
 94e:	0ea73f23          	sd	a0,254(a4) # a48 <freep>
      return (void*)(p + 1);
 952:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 956:	70e2                	ld	ra,56(sp)
 958:	7442                	ld	s0,48(sp)
 95a:	74a2                	ld	s1,40(sp)
 95c:	7902                	ld	s2,32(sp)
 95e:	69e2                	ld	s3,24(sp)
 960:	6a42                	ld	s4,16(sp)
 962:	6aa2                	ld	s5,8(sp)
 964:	6b02                	ld	s6,0(sp)
 966:	6121                	addi	sp,sp,64
 968:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 96a:	6398                	ld	a4,0(a5)
 96c:	e118                	sd	a4,0(a0)
 96e:	bff1                	j	94a <malloc+0x86>
  hp->s.size = nu;
 970:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 974:	0541                	addi	a0,a0,16
 976:	00000097          	auipc	ra,0x0
 97a:	ec6080e7          	jalr	-314(ra) # 83c <free>
  return freep;
 97e:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 982:	d971                	beqz	a0,956 <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 984:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 986:	4798                	lw	a4,8(a5)
 988:	fa9776e3          	bgeu	a4,s1,934 <malloc+0x70>
    if(p == freep)
 98c:	00093703          	ld	a4,0(s2)
 990:	853e                	mv	a0,a5
 992:	fef719e3          	bne	a4,a5,984 <malloc+0xc0>
  p = sbrk(nu * sizeof(Header));
 996:	8552                	mv	a0,s4
 998:	00000097          	auipc	ra,0x0
 99c:	b7e080e7          	jalr	-1154(ra) # 516 <sbrk>
  if(p == (char*)-1)
 9a0:	fd5518e3          	bne	a0,s5,970 <malloc+0xac>
        return 0;
 9a4:	4501                	li	a0,0
 9a6:	bf45                	j	956 <malloc+0x92>

00000000000009a8 <setjmp>:
 9a8:	e100                	sd	s0,0(a0)
 9aa:	e504                	sd	s1,8(a0)
 9ac:	01253823          	sd	s2,16(a0)
 9b0:	01353c23          	sd	s3,24(a0)
 9b4:	03453023          	sd	s4,32(a0)
 9b8:	03553423          	sd	s5,40(a0)
 9bc:	03653823          	sd	s6,48(a0)
 9c0:	03753c23          	sd	s7,56(a0)
 9c4:	05853023          	sd	s8,64(a0)
 9c8:	05953423          	sd	s9,72(a0)
 9cc:	05a53823          	sd	s10,80(a0)
 9d0:	05b53c23          	sd	s11,88(a0)
 9d4:	06153023          	sd	ra,96(a0)
 9d8:	06253423          	sd	sp,104(a0)
 9dc:	4501                	li	a0,0
 9de:	8082                	ret

00000000000009e0 <longjmp>:
 9e0:	6100                	ld	s0,0(a0)
 9e2:	6504                	ld	s1,8(a0)
 9e4:	01053903          	ld	s2,16(a0)
 9e8:	01853983          	ld	s3,24(a0)
 9ec:	02053a03          	ld	s4,32(a0)
 9f0:	02853a83          	ld	s5,40(a0)
 9f4:	03053b03          	ld	s6,48(a0)
 9f8:	03853b83          	ld	s7,56(a0)
 9fc:	04053c03          	ld	s8,64(a0)
 a00:	04853c83          	ld	s9,72(a0)
 a04:	05053d03          	ld	s10,80(a0)
 a08:	05853d83          	ld	s11,88(a0)
 a0c:	06053083          	ld	ra,96(a0)
 a10:	06853103          	ld	sp,104(a0)
 a14:	c199                	beqz	a1,a1a <longjmp_1>
 a16:	852e                	mv	a0,a1
 a18:	8082                	ret

0000000000000a1a <longjmp_1>:
 a1a:	4505                	li	a0,1
 a1c:	8082                	ret
