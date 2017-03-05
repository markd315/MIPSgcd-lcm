	.data
fi:	.asciiz "Enter first integer n1: "	
si:	.asciiz "Enter second integer n2: "
gc:	.asciiz "The greatest common divisor n1 and n2 is "
lc:	.asciiz "The least common multiple of n1 and n2 is "
	.globl main
	.text
#$v0 is return value. $a0-3 are args.  
main:	la $a0, fi
	li $v0, 4 #print string
	syscall
	li $v0, 5 #read n1
	syscall #Read int syscall
	addi $s0 $v0 0 #store result in s0.
	la $a0, si
	li $v0, 4 #print string
	syscall	
	li $v0, 5 #read n2
	syscall #Read int syscall
	addi $s1 $v0 0 #store result in s1.
	la $a0, gc
	li $v0, 4 #print string
	syscall
	addi $a0 $s0 0
	addi $a1 $s1 0 #load arguments from save registers
	jal gcd #call to gcd
	addi $a0 $v0 0 #a0 is GCD.	
	li $v0, 1 
	syscall #print GCD
	addi $a0, $0, 0xA #ascii code for my newline.
        addi $v0, $0, 11 #syscall 11 prints the lower 8 bits of $a0 as an ascii character according to stackoverflow.
        syscall #So all in all, this one will just give us a newline.
	la $a0, lc
	li $v0, 4 #print string
	syscall
	addi $a0 $s0 0 #load
	addi $a1 $s1 0 #load 
	jal lcm #call to lcm
	addi $a0 $v0 0 #a0 is LCM.	
	li $v0, 1 
	syscall #print GCD
	li $v0, 10 #exit program 
	syscall #exit syscall

gcd:	addi $t2 $ra 0 #Here we save the return address for later when we need it.  Not executed by the recursive calls!
gcdR:	beq $a1 $zero returnG
	addi $t0 $a1 0 #$t0 = $a1 Temporary save for the mod we execute
	#$a1 = mod a0%t0 for ploop, nloop lines.
nloop:	bgt $a0 $zero ndone #while less than zero.
	add $a0 $a0 $t0
	j nloop
ndone:	
ploop:	blt $a0 $t0 pdone #while greater than mod divisor.
	sub $a0 $a0 $t0
	j ploop
pdone:	addi $a1 $a0 0
	addi $a0 $t0 0 #$a0 = $t0
	jal gcdR #Recursive call () if n2!=0
returnG:addi $ra $t2 0 #recover the return address.
	addi $v0 $a0 0 #move a0 to v0 return slot.
	jr $ra #returns once n2 = 0
lcm:	addi $s4 $ra 0 #hold our address pls.
	addi $t1 $a0 0 #$t1 = $a0
	addi $t2 $a1 0 #$t2 = $a1
	mul $s7 $t1 $t2 #s7 holds our division result.
	jal gcd #v0 now has GCD.
	div $v0 $s7 $v0 #v0 now has LCM so we are done.
	mflo $v0
	addi $ra $s4 0 #recover address.
	jr $ra