addi r1,r0,#2	; Initialize angular coefficent (A)
addi r2,r0,#3   ; Initialize offset (B)
addi r3,r0,#10  ; Initialize the number of X elements
addi r4,r0,#0   ; Initialize X vector pointer (i)
addi r5,r0,#10  ; Initialize Y vector pointer (j)
addi r7,r0,#0   ; Initialize conditional flag
sw r4,r4,#0     ; Begin initialization loop for X vector
addi r4,r4,#1   ; Increment i
sgt r7,r4,r3    ; Loop condition
beqz r7,#-3     ; Conditional branch to sw r4,r4,#0
addi r4,r0,#0   ; Reset X pointer
lw r8,r4,#0     ; Begin Y = X*A + B loop: load X[i] from memory
addi r4,r4,#1   ; Increment i
mul r8,r8,r1    ; Calculate X*A
add r8,r8,r2    ; X*A + B
sw r8,r5,#0     ; Store result in Y[j]
addi r5,r5,#1   ; Increment j
slt r7,r4,r3    ; Loop condition
bnez r7,#-7     ; Conditional branch to lw r8,r4,#0