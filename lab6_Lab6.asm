#Anirudh Ahuja
#anahuja@ucsc.edu
#1544072
#Lab5
#Section 01I

###Psuedo Code###
#EncryptChar's conditions for caps letters: 65 < x < 90
#EncryptChar's conditions for lowercase letters: 97 < x < 122
#Test code calls EncryptChar, which encrypts the text using a key in test_lab6.asm
#First check if the character is uppercase or lowercase 
#Subtract from the key to make it 0-25 
#Add the plain text with the key to get a new result
#Test code calls EncryptString 
#EncryptString loads the first bit of the plain String
#Loads the first bit of the key string
#It then iterates through the plain String and the Key String 
#Every iteration, the now moved over bit is passed through EncryptChar and then stored in s2
#Move the position of s2 over by one and repeat the previous step
#Once the null character of plain String is hit, return to the test code and print the String. 
#Same thing with DecryptChar and DecryptString, but change some logic around (sub instead of add)


.text

# Subroutine testEC
# input:	None
# output:  	None
# Side effects: Prints report of results of EncryptChar,
#		Also overwrites $a0, $a1, and $v1	
EncryptChar:
	bge $a0, 97, __lowercheck1 #Branch to the lowercase character checker
	blt $a0, 65, __skip #Lowerboud for Uppercase 
	bgt $a0, 90, __skip #Upperbound for Uppercase
	
	addi $a1, $a1, -65 #Set the key value to A-Z = 0-25
	add $a0, $a0, $a1 #Add the key value to the plain char
	bgt $a0, 90, __rollover #If the value crosses Z, subtract by 26 in another label
	
	move $v0, $a0 #Move value to $v0 so it can be printed in test file
	
	jr $ra 
	
# Subroutine testES
# input:	None
# output:  	None
# Side effects: Prints report of results of EncryptString,
#		Also overwrites $a0, $a1, and $v1
EncryptString:	
	beqz $t5, __storage
	lb $t2, ($t0) #Loads the first bit of a0 to t1
	lb $t3, ($t1) #Loads the first bit of a1 to t3
	
	beqz $t2, __exit #If the end of the string for Plain text is reached, go back to test file
	beqz $t3, __update #If end of the Key String is reached, reset to the start
	beq, $t8, 30, __exit #If String is greater than 30, ignore and exit
	
	move $a0, $t2 #Move value of bit to a0 for Encrypt char
	move $a1, $t3 #Move value of key bit to a1 for Encrypt char

	jal EncryptChar #Get the Decrypted value of $a0
	sb $v0, ($a2) #Store the Decrypted character in $a2
	
	#Increment variables
	addi $a2, $a2, 1
	addi $t0, $t0, 1
	addi $t1, $t1, 1
	addi $t8, $t8, 1
	
	#Jump back to the beginning of string for next bit	
	j EncryptString


# Subroutine testDC
# input:	None
# output:  	None
# Side effects: Prints report of results of DecryptChar,
#		Also overwrites $a0, $a1, and $v1
DecryptChar:
	bge $a0, 97, __declowercheck1 #Branch to the lowercase character checker
	blt $a0, 65, __skip2 #Lowerboud for Uppercase 
	bgt $a0, 90, __skip2 #Upperbound for Uppercase
	
	addi $a1, $a1, -65 #Set the key value to A-Z = 0-25
	sub $a0, $a0, $a1 #Sub the key value to the plain char
	blt $a0, 65, __decrollover #If the value crosses Z, add by 26 in another label
	move $v0, $a0 #Move value to $v0 so it can be printed in test file
	jr $ra 
					
# Subroutine testDS
# input:	None
# output:  	None
# Side effects: Prints report of results of DecryptString,
#		Also overwrites $a0, $a1, and $v1				
DecryptString:
	beqz $t7, __storage2 #Go load the registers with certain values before starting the loop
	lb $t2, ($t0) #Loads the first bit of a0 to t1
	lb $t3, ($t1) #Loads the first bit of a1 to t3
	
	beqz $t2, __exit #If the end of the string for Plain text is reached, go back to test file
	beqz $t3, __update2 #If end of the Key String is reached, reset to the start
	beq, $t8, 30, __exit #If String is greater than 30, ignore and exit
	
	move $a0, $t2 #Move value of bit to a0 for Decrypt char
	move $a1, $t3 #Move value of key bit to a1 for Decrypt char

	jal DecryptChar #Get the Decrypted value of $a0
	sb $v0, ($a2) #Store the Decrypted character in $a2
	
	#Increment variables
	addi $a2, $a2, 1
	addi $t0, $t0, 1
	addi $t1, $t1, 1
	addi $t8, $t8, 1
	
	j DecryptString	#Jump back to the beginning of string for next bit			
						
														
#Label for when the value crosses Z / z	in EncryptChar
__rollover:
	addi $a0, $a0, -26
	move $v0, $a0
	jr $ra

#Label for when the value crosses A / a in DecryptChar
__decrollover:
	addi $a0, $a0, 26
	move $v0, $a0
	jr $ra

#Label for checking whether or not character is lowercase for the EncryptChar subroutine
__lowercheck1:
	blt $a0, 122, __lowercheck2 #Upperbound for Lowercase
		
	__lowercheck2: 
		addi $a1, $a1, -65 #Sets the Key's value to 0-25
		add $a0, $a0, $a1 #Adds the value of the key to the plain char
		bgt $a0, 122, __rollover #If the value crosses z, subtract new value by 26
		move $v0, $a0 #Move the value to $vo so it can be printed
		jr $ra #Jump back to the test file
		
#Label for checking whether or not character is lowercase for the DecryptChar subroutine
__declowercheck1:
	blt $a0, 122, __declowercheck2
	
	__declowercheck2:
		addi $a1, $a1, -65 #Sets the Key's value to 0-25
		sub $a0, $a0, $a1 #Adds the value of the key to the plain char
		blt $a0, 97, __decrollover #If the value crosses z, add new value by 26
		move $v0, $a0 #Move the value to $vo so it can be printed
		jr $ra #Jump back to the test file

#Storage of certain values at the beginning of EncryptString to make sure they don't change						
__storage:
	move $t4, $ra 
	move $t0, $a0
	move $t1, $a1
	move $t6, $a1
	addi $t5, $zero, 1
	j EncryptString

#Storage of certain values at the beginning of DecryptString to make sure they don't change		
__storage2: 
	move $t4, $ra 
	move $t0, $a0
	move $t1, $a1
	move $t6, $a1
	add $t8, $zero, $zero
	addi $t7, $zero, 1
	j DecryptString

#Resets the Key when it hits the end of the Key String for EncryptString
__update:
	move $t1, $t6
	j EncryptString

#Resets the key when it hits the end of the Key String for DecryptString
__update2:
	move $t1, $t6
	j DecryptString

#Skip non-alphabet characters but make sure they are printed as well for EncryptString		
__skip:
	sb $t2, ($a2)
	addi $t0, $t0, 1
	addi $a2, $a2, 1
	addi $t8, $t8, 1
	j EncryptString

#Skip non-alphabet characters but make sure they are printed as well for DecryptString
__skip2:
	sb $t2, ($a2)
	addi $t0, $t0, 1
	addi $a2, $a2, 1
	addi $t8, $t8, 1
	j DecryptString

#Jump back to the test file
__exit:
	move $ra, $t4
	jr $ra
	
.data
	
	
