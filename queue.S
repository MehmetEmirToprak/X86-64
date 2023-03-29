.intel_syntax noprefix
.global main
.data
	head:
	.quad -1
	tail:
	.quad -1
	max:
	.quad 5
	queue:
	.skip 32
	
	myformat:
	.asciz  "full!!!"
	
.text

main:
	mov rdi, 10 #data

	call enqueue
	call enqueue
	
	call dequeue
	call dequeue
	call dequeue
	ret

	
.global enqueue
enqueue:
	######prologue##########
	push rbp        
	mov rbp, rsp	

	mov r8, [head] #head
	mov r9, [tail]	#tail
	mov r10, [max]  #max
	lea r11, [queue]  #queue
	
	
firstif:
	cmp r8, 0   #head == 0
	jne or1     #head != 0
	dec r10     #max = max-1
	cmp r9, r10  #tail = max-1
	jne or1      #tail != max - 1
	# PRINT FULL
	
	ret
or1:
	mov r12, r9   #tail = r12
	inc r12     #tail + 1
	cmp r8, r12    #head = tail + 1
	jne firstifelse        # head != tail + 1
	


firstifelse:
	cmp r9, -1  #tail == -1
	jne elseif  
	mov QWORD PTR [tail], 0
	mov QWORD PTR [head], 0
	jmp end

elseif:
	cmp r9, r10   #tail == max - 1
	jne else2     #tail != max - 1
	mov QWORD PTR[tail], 0 
	jmp end

else2:
	inc QWORD PTR[tail] #tail++
	mov r14, tail       #r14 = tail
	jmp end
end:
	mov r14, tail     
	mov QWORD PTR[queue+4*r14], rdi  #queue[tail] = data
	
	#######epilogue#########
	mov rsp, rbp
	pop rbp
	ret
	

	
	
	
.global dequeue
dequeue:
	#########prologue###########
	push rbp
	mov rbp, rsp
	mov r8, [head] #head
	mov r9, [tail]	#tail
	mov r10, [max]  #max
	lea r11, [queue]  #queue
	mov rbx, rdi    #data = rbx = 10     
	xor ebx,ebx  #data == null
	
dequeueif:
	cmp r8, -1      #head == -1
	jne dequeueelse
	#print error: empty!
	mov rsp, rbp
	pop rbp
	ret
dequeueelse:
	mov ebx, head    #head = ebx
	mov eax, [queue+4*ebx]
	cmp r8, r9
	jne elseif2 
	mov QWORD PTR[head], -1
	mov QWORD PTR[tail], -1
	jmp end2
	
elseif2:
	dec r10     #max--
	cmp	r8, r10 #tail = max - 1
	jne else3   #tail != max - 1
	mov QWORD PTR[head], 0 #head = 0
	jmp end2

else3:
	inc QWORD PTR[head] #head++
end2:	 
	###########epilogue#########	
	mov rax, rdi 
	mov rsp, rbp 
	pop rbp
	ret


