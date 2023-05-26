include 'emu8086.inc'

JMP START

DATA SEGMENT 
   	N   DW      ?                                                              
	MARKS DB 1024 DUP (?)           ;MAX is 1024
	ID    DB  1024 DUP (?)
	         
	MSG1    DB 'Enter the number of students(MAX 1000): ',0                                   ;0 INDICATES THAT THE MESSAGE ENDS HERE
	MSG2    DB 0Dh,0Ah, 0Dh,0Ah,'Enter the IDs of students: ',0                               ;0Dh,0Ah, 0Dh,0Ah MEANS NEW LINE AND RETURN CURSOR TO ITS BEGINNING ACCORDING TO ASCI CODES 
	MSG3    DB 0Dh,0Ah, 0Dh,0Ah,'Enter the marks of students: ',0                             ;to get the marks 
    MSG4    DB 0Dh,0Ah, 0Dh,0Ah,'**************Sorted Marks******************',0              ;HORIZONTAL ROW  
    MSG5    DB 0Dh,0Ah, 0Dh,0Ah,'ID: ',09H,'MARKS:',0                                
DATA ENDS  

CODE SEGMENT
        	ASSUME DS:DATA CS:CODE     

        	;SETTING DATA SEGMENT  
START:  	
            MOV AX, DATA
	  	    MOV DS, AX                    
	   
	    	;DEFINING FUNCTIONS FOR THE LIBRARY EMU8086 WHICH WILL BE USED LATER
	    	DEFINE_SCAN_NUM           
        	DEFINE_PRINT_STRING 
        	DEFINE_PRINT_NUM
        	DEFINE_PRINT_NUM_UNS
        
        
        	;READING NUMBER OF STUDENTS
        
        	LEA SI,MSG1              ;putting the message in SI
	    	CALL PRINT_STRING        ;using the function to print whatever in SI                                                
	    	CALL SCAN_NUM            ;THE FUNCTION PUTS THE INPUT IN CX
	    	MOV N,CX
	        ; after it we have the number of the students 
	    
	    
	    	;READING IDs OF STUDENTS  
	    	LEA SI,MSG2
	    	CALL PRINT_STRING
	    	MOV SI, 0
	   
LOOP1:  	CALL SCAN_NUM 
        	MOV ID[SI],CL
        	INC SI  
        	PRINT 0AH        ;PRINT NEW LINE
        	PRINT 0DH        ;RETURN CURSOR TO THE BEGINNING 
        	CMP SI,N         ;make sure we did not exceed the number 
        	JNE LOOP1        ;return to the loop 1 to continue
       
        
        
	    	;READING MARKS OF STUDENTS
	    	LEA SI,MSG3
	    	CALL PRINT_STRING
	    	MOV SI, 0
	   
LOOP2:  	CALL SCAN_NUM 
        	MOV MARKS[SI],CL
        	INC SI  
        	PRINT 0AH        ;PRINT NEW LINE
        	PRINT 0DH        ;RETURN CURSOR TO THE BEGINNING 
        	CMP SI,N 
        	JNE LOOP2  
       
        
        
	    	;SORTING THEM ACCORDING TO MARKS USING BUBBLE SORT  
	    
	    	DEC N           ;BECAUSE WE WON'T COMPARE THE LAST ELEMENT 
	   	    MOV CX, N       ;CX AS I          
OUTER:  	MOV SI, 0       ;SI AS J
	    
	   
INNER:  	MOV  AL, MARKS[SI]      ;GET THE J ELEMENT IN AL
	    	MOV  DL, ID[SI]         ;GET THE I ELEMENT IN DL
	    	INC  SI
	    	CMP  MARKS[SI], AL      ;COMPARE AND SWAP
	    	JB   SKIP
	    	XCHG AL, MARKS[SI]      ;IF BIGGER SWAP ELEMENTS
	    	MOV  MARKS[SI-1], AL
	    	XCHG DL, ID[SI]
        	MOV  ID[SI-1], DL  
        
SKIP:   	CMP  SI, CX             ;CHECK END OR NOT
	    	JL   INNER 
	    	LOOP OUTER
	    
	    
	    	INC N                   ;WE INCREMENT N AGAIN BECAUSE WE DECREASED IT BEFORE 
	    	                        ;WE COULD HAVE USE ANOTHER VAR   
	    
	   	   
	    	;PRINT TABLE OF THEIR IDs AND MARKS AFTER SORTING
	    	LEA SI,MSG4   
	    	CALL PRINT_STRING
	    	LEA SI,MSG5
	    	CALL PRINT_STRING
        	PRINT 0AH            ;PRINT NEW LINE 
        	PRINT 0DH            ;RETURN CURSORT TO THE BEGINNING
	   
	    	MOV SI, 0
LOOP3:  	MOV AX,0
        	MOV AL,ID[SI]     
       
        	CALL PRINT_NUM_UNS    
        	PRINT 09H            ;PRINT TAB
        	MOV AL,MARKS[SI]
        	CALL PRINT_NUM_UNS
        	PRINT 0AH            ;PRINT NEW LINE 
        	PRINT 0DH            ;RETURN CURSORT TO THE BEGGINING
        	INC SI 
        	CMP SI,N 
        	JNE LOOP3
       
CODE ENDS
 
END START
  

ret
  
  