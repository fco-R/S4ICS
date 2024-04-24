;
; =============
; S4DMX PROGRAM 
; =============	
;
; RUN INSIDE DMX-ETH MOTORS OF SPARC4
;
; VERSION 20230822		; stored on V33 at srart-up)
; ================
; Incluido em V74 das rotinas INIT de WPROT, WPSEL e ASEL o offset
;	entre o ponto de atuação do sensor de referência e a posição
;	da centragem óptica que estava na configuração do S4ICS 
;	(pos_value[0]) com os valores: 900, -5000 e -200, respectivamente.
;
;
; MEMORY MAP
; ----------
; Check "Variable-Subroutine Map.png" file for detailed information.
; S4DMX uses memory as follows:
; V1  to V9:  General purpose memory used as necessary
; V10 to V19: Specific information used frequently by all subroutines
; V20 to V29: Input parameters for subroutines. Written by ICS.
; V30 to V39: Output parameters of subroutines. Read by ICS.
; V40 to V50: Control and configuration variables shared with ICS.
; V51 to V56: WPROT positions WP1-WP16. Written by ICS, used by SUBs 1-16.
; V70 to V80: Hardware specific constants related to all mechanisms.
; V81 to V100: Parameters for automatic WPROT progress. Written by ICS. 
;
; STATUS CODES: V46 < 10 
; ----------------------
; =0 READY, NONE SUBROUTINE IN EXECUTION
; =1 BUSY, SUBROUTINE IN EXECUTION
; =2 MOVING ON WPROT CYCLIC MODE. 
;
; ERROR CODES: 255 <= V46 >= 10 
; -----------------
; 3-DIGIT ERROR CODES ARE USED AS FOLLOWS:
; 1ST DIGIT:	=0 FOR INIT COMMON ERRORS, 
;							=1 FOR GOTO COMMON ERRORS, 
;							=2 FOR SPECIFIC ERRORS:
;									- 200/201			(PRG 0)	Invalid hardware ID
;									- 205					(SUB21)	ECHARPE mirror out of HOME.
;									- 210	TO 216	(PRG 1) WPROT automatic WP progress.
; - FOR COMMON ERROS (>=10 and <= 169):
; 2ND DIGIT:	MECHANISM ID (=1:WPROT,=2:WPSEL,=3:CALW,=4:ASEL,=5:GMIR,=6:GFOC)
; 3RD DIGIT:	COMMON ERROR IDENTIFICATION:
;							=0 Hardware ID does not match			=1 Software ID does not match
;							=2 Predefined position low index	=3 Predefined postion high index
;							=4 Parameter low value						=5 Parameter high value
;							=6 INIT not done									=7 Timeout
;							=8 Position out of tolerancy			=9 Sensor inconsistency
;
; NOTES:
; =====
; - PROGRAM 0 is used for mechanism identification and
; must be configured to execute at boot-up (SLOAD=1 / STORE).
;
; - PROGRAM 1 is used for automatic waveplate progress.
;
; - SUBROUTINES are used for ICS command execution.
; Subroutines are implicitly contained in Program 0 and 
; respond to commands SASTAT0 and SR0. 
;
; - The IF/ELSE/ELSEIF/ENDIF of DMX-ETH language
; is limited to 2 nested structures.
;
; - With normal polarity (POL=0): 
; When DO=0 (firmware), current flows to load.
; When an input is disconnected, firmware reads input_bit=0.
;
; - If LIM+/- inputs is actuated during a
; movement, SUB 31 clears its error flag.
;
; - The available memory (44.5 KB) for standalone programs is 7650 assembly lines
; and each line of pre-compiled code equates to 1-4 lines of assembly lines.
;
; - The DMX-ETH GUI sometimes truncates the S4DMX program during upload, without
; show any error message. To solve this issue, split and compile the code into parts. 
; At the end of S4DMX development, when it becomes a large program (greater than 
; half of available memory of motor), this issue disappeared.
;
;****************************************
PRG 0	; HARDWARE MECHANISM IDENTIFICATION
;****************************************
; V44: INIT flag of all mechanisms.
; V45: Motor polarity, set by S4DMX, used by ICS to write motor POL register.
; V46: Running status. =0 for READY, =1 for BUSY, or error code otherwise.
; V50: Mechanism hardware ID, set by S4DMX.
; --------------------------------------------
	V33 = 20230822		; Current S4DMX version.
	V46 = 1			 			; Set start SUB code
	V50 = 0						; Set ID=0 for unplugged motor
	; Programs can't write POL register, so this routine fills V45
	; with the appropriate POL value and leave to ICS to read
	; V45 value and write it back to the motor POL register.
	V45 = 0						; Default POL for GFOC, GMIR, and CALW
	V44 = 0						; Clear INIT done flag.
	; Wait at least 1.8s for end of *EN (GFOC) pulse.
	DO = 2						; To avoid error on GFOC ID.
	DELAY = 2500
	V11 = MSTX				; Get motor status with DO1=0
	; Clear all status, except for HOME (bit 3), LIM+ (bit 5),
	; and LATCH (bit 8): 2^3+ 2^5+ 2^8 = 296.
	V48 = V11 & 296
	; Add the status of inputs DI1 (bit 0) and DI2 (bit 1)
	V48 = V48 + DI
	; Get state of all inputs with DO1=1 and DO1=0
	DO1 = 1						; Only GFOC needs a pulse on DO1, in order
	DO1 = 0						; to turn active both EN* and LIM+ of GFOC,
	DO1 = 1						; which is used to identify its ID
	DELAY = 100				; Wait for motor input stabilization
	V11 = MSTX				; Get motor status with DO1=1
	; Clear all status, except for HOME (bit 3), LIM+ (bit 5),
	; and LATCH (bit 8): 2^3+ 2^5+ 2^8 = 296.
	V47 = V11 & 296
	; Add the status of inputs DI1 (bit 0) and DI2 (bit 1)
	V47 = V47 + DI
	; DO1 = 0
	;
	; Find which input had its state changed
	; --------------------------------------
	V3 = 0						; reset ID match counter
	; Test +LIM input. MUST PRECEED TEST FOR DI1 AND HOME.
	V1 = V47 & 32
	V2 = V48 & 32
	IF V1 != V2
		V50 = 32				; ID=32 for GFOC alone
		V3 = V3 + 1			; increment match counter
	ENDIF
	; Test HOME input
	V1 = V47 & 8
	V2 = V48 & 8
	IF V1 != V2
		IF V50 = 32			; V50=32 for GFOC alone
			V50 = 48			; ID=48 for GMIR + GFOC
		ELSE
			V50 = 16			; ID=16 for GMIR alone
			V3 = V3 + 1		; increment match counter
		ENDIF
	ENDIF
	; Test DI1 input. MUST PRECEED DI2 TEST.
	V1 = V47 & 1
	V2 = V48 & 1
	IF V1 != V2
		; DI1 also changes its state when
		; GFOC REF switch is actuated. 
;		IF V50 = 32			; V50=32 for GFOC alone
		V4 = V50 & 48		; 48=16+32, GMIR/GFOC IDs bits
		IF V4 = 0				; V4>0 for GMIR or GFOC.
			V50 = 1				; ID=1 for WPROT
			V45 = 16			; POL for WPROT
			V3 = V3 + 1		; increment match counter
		ENDIF
	ENDIF
	; Test DI2 input
	V1 = V47 & 2
	V2 = V48 & 2
	IF V1 != V2
		IF V50 = 1			; V50=1 for WPROT (DI1 state changed)
			; Both DI1 and DI2 had their state changed, so
			V50 = 4				; ID=4 for CALW
			V45 = 0				; POL for CALW
		ELSE
			V50 = 2				; ID=2 for WPSEL
			V45 = 80			; POL for WPSEL
			V3 = V3 + 1		; increment match counter
		ENDIF
	ENDIF
	; Test LATCH input
	V1 = V47 & 256
	V2 = V48 & 256
	IF V1 != V2
		V50 = 8					; ID=8 for ASEL
		V45 = 48				; POL for ASEL
		V3 = V3 + 1			; increment match counter
	ENDIF
	; Test for unplugged motor
	IF V47 = V48
		V50 = 0					; ID=0 for unplugged motor
		V46 = 201				; Unplugged motor error code
		V3 = V3 + 1			; increment match counter
	ENDIF
	; Test for none or multiple matches
	IF V3 != 1
		V50 = -1				; -1 is an invalid ID code
		V46 = 202				; Invalid hardware ID error code
	ENDIF
	; Security: set an invalid (-2) software ID code.
	V49 = -2					; ICS sets V49 = V50 to enable movements
	DO = 3						; Outputs=1, no current flows to load.
	V44 = 0						; Clear INIT flag of all mechanisms
	IF V46 = 1
		V46 = 0					; Set end SUB code
	ENDIF
END									; End Program 0
;
;
;===================================
PRG 1	; AUTOMATIC WAVEPLATE PROGRESS
;===================================
;
; THE DI2 INPUT IS CONNECTED TO THE OUTPUT OF AN ELECTRONIC CIRCUIT 
; THAT DETECTS THE END OF EXPOSURE (FIRE) OF ALL iXon CAMERAS. (DI2=0).
;
; PRG 1 ADVANCES WP TO THE NEXT ENABLED POSITION WHEN DI2 IS ACTIVATED.
; DEPENDING ON THE VALUE OF V97, THE ADVANCE MAY RUN IN THE TRANSITION
; FROM 1 TO 0 (V97=1) OR AFTER DI2 REMAINS AT 0 AT LEAST 50ms (V97>=2).
;
;	THE DO2 OUTPUT IS WIRED-AND WITH THE ARM SIGNAL OF ALL iXon CAMERAS AND
; CONNECTED TO THE EXTERNAL TRIGGER INPUT OF SYNCBOX. PRG 1, AFTER EACH 
; WP PROGRESS, ACTIVATES DO2 (=1) ENABLEING THE SYNCBOX TRIGGER ON THE
; NEXT CAMERA EXPOSITION (ALL ARMs = 1). 
; WHEN DO2=0 (current flows to load) THE SYNCBOX TRIGGER IS DISABLED.
;
; TO STOP PRG1 WITHOUT ANY WP MOVEMENT, ICS MAY WRITE V42=0 AND THEN INVERT
; AND RESTORE THE POLARITY OF DI2 INPUT (POL=2064 / POL=16).
;
; PRG 1 ENABLES THE POSITION LATCH WHEN THE WP ACTUATOR ACTIVATES THE
; REF SWITCH (HOME). ICS CAN READ THAT POSITION AND COMPARE WITH THE
; LATCHED POSITION OF PREVIOUS REVOLUTION IN ORDER TO MEASURE THE 
; DIFFERENCE BETWEEN THEM. THIS DIFFERENCE IS USED TO QUANTIFY AND 
; CORRECT ANY WP ROTATION FAILURE, WRITING IN V98 (AT ANY TIME) THE 
; VALUE TO BE SUBTRACTED IN THE NEXT DISPLACEMENT OF WPROT MOTOR.
;
; PRG1 MOVES WP CONTINOUSLY IN THE SAME DIRECTION WITHOUT CORRECTING
; THE ENCODER VALUE TO FIRST-TURN VALUES, THAT'S UP TO ICS.
;
; ICS ACTIONS BEFORE CALL THIS PROGRAM:
; 1) FILL V81 TO V96 WITH THE VALUES OF DISPLACEMENTS
; 2) FILL V97 WITH 1 FOR TRANSITION MODE OR WITH 2 FOR STATE MODE
; 3) RESET DO2 TO DISABLE EXT.TRIGGER OF SYNCBOX
; 4) MOVE WP TO THE FIRST ENABLED POSITION
;
; AS SOON AS ICS RUNS PRG1 THE EXT.TRIGGER IS ENABLED WHICH
; ALLOWS ARM SIGNALS OF ALL CAMERAS TO TRIGGER SYNCBOX. 
;--------------------
; V42: PRG1 while loop enable. Set by PRG1. ICS must reset it (and POL) to stop PRG1.
; V46: Running status. =0 for READY, =1 for BUSY, error code otherwise.
;	V72: acceptable position error (=2 <-> 0.024 degrees)
;	V73: encoder counts equivalent to 1 WP turn (= 3000)
; V81: displacement from WP1 to next enabled position (=0 if WP1 is disabled).
; V82: displacement from WP2 to next enabled position (=0 if WP2 is disabled).
; ...
; V96: displacement from WP16 to next enabled position (=0 if WP16 is disabled).
; V97: detection flag. =1 for 1 to 0 transition, >1 for 0 pulse > 50ms (=3 ar INIT).
;	V98: correction to be applied on next progress from 1st to 2nd enabled position.
; V99: reserved for V98 CCW correction (V99=-1*V98).
;	V73 = 30000				; Encoder counts equivalent to 1 WP turn CW.
;
; ===========================================
; iXon ARM / FIRE ENABLE ROUTINE,
; V22: Flag to run Automatic Waveplate Progress routine (V22=0) or
;      ARM/FIRE Enable routine. In this case the 8 LSB of V22 are
;      written into the shift register of Trigger Box electronics.
;
; ===========================================
;
	; Check for same hardware and software IDs and both not equal to zero
	V46 = 1			 			; Set start SUB code
	V1 = 1						; Store WPROT ID
	IF V50 != V1
		V46 = 210				; Set Hardware ID error code
	ELSEIF V49 != V1
		V46 = 211				; Set Software ID error code
	ELSEIF V31 < 1
		V46 = 212				; Set position index low value error code
	ELSEIF V31 > 17		; Index=17 when parameter is numeric
		V46 = 213				; Set position index high value error code
	ELSEIF V97 < 1		; V97 is the FIRE=0 reading counter.
		V46 = 214				; Set parameter low value error code
	ELSEIF V44 != V1
		V46 = 216				; Set INIT not executed error code
	ENDIF
	; Check for presence of a WP centered with optical beam
	V11 = MSTX				; Read motor status
	V2 = V11 & 48			; Mask LIM+ and LIM- sensors
	IF V2 != 0
		V46 = 219				; Set error WPSEL out of position
	ENDIF
	IF V46 != 1
		SR1 = 0					; Turn PRG 1 off.
	ENDIF
	; ===========================================
	; INSERT HERE iXon ARM / FIRE ENABLE ROUTINE.
	; IF V22 != 0
	;	....
	; ENDIF
	;	V46 = 0	 				; Set end SUB/PRG1 code
	; SR1 = 0					; Turn PRG 1 off.
	; ===========================================
; 20230818: Motor parameters are written only in the INIT routine
;	HSPD = 250000			; Set motor parameters
;	LSPD = 1000
  EO = 1						; Enable motor driver
	V42 = 1						; Set PRG 1 enable flag
	; Check for cyclic movement.
	; V81 = V73 (= 30000) is a flag to disable WP motion
	; but still monitor FIRE signal and enable EXT.TRIGGER.
	IF V81 = V73
		WHILE V42 = 1
			V2 = V97			; Set FIRE counter (=1 for transition, =2 for pulse)
			DO2 = 1				; Enable Syncbox trigger.
			; Wait for the start of camera exposure (FIRE=1).
			WHILE DI2 = 0	; DI2=1 during camera exposure
			ENDWHILE
			DO2 = 0				; Disable Syncbox trigger.
			; Wait for the end of camera exposure (FIRE=0).
			WHILE V2 > 0
				IF DI2 = 0	; DI2=0 when FIRE=0 (end of exposure)
					V2 = V2 - 1	; Update FIRE counter
				ELSE
					V2 = V97	; Reset FIRE counter
				ENDIF
			ENDWHILE
		ENDWHILE
	ENDIF
	; Cyclic Waveplate movement
	INC								; Set incremental mode (ICS fills V81-96 with offsets)
	V98 = 0						; Clear correction value
	; ICS can set V42=0 in order to stop PRG1.
	WHILE V42 = 1
		LTX = 0					; Enable latching
		LTX = 1
		V99 = -1 * V98	; Convert correction to CCW
		; V81 is the displacement from WP1 to the next enabled position.
		; V42=1 if PRG1 is enabled or =0 if it is disabled.
		V100 = V42 * V81; If WP1 or PRG1 is disabled, V100=0
		IF V100 > 0		
			V10 = V99 - V81;Next displacement added to ICS correction
			V99 = 0				; Clear correction value
			V2 = V97			; Set FIRE counter (=1 for transition, =2 for pulse)
			WAITX					; Wait for motor stop. Unnecessary instruction.
			V31 = 1				; Update current predefined position
			DO2 = 1				; Enable Syncbox trigger.
			; Wait for the start of camera exposure (FIRE=1).
			WHILE DI2 = 0	; DI2=1 during camera exposure
			ENDWHILE
			DO2 = 0				; Disable Syncbox trigger.
			; Wait for the end of camera exposure (FIRE=0).
			WHILE V2 > 0
				IF DI2 = 0	; DI2=0 when FIRE=0 (end of exposure)
					V2 = V2 - 1	; Update FIRE counter
				ELSE
					V2 = V97	; Reset FIRE counter
				ENDIF
			ENDWHILE
			IF V42 = 1		; If PRG1 is disabled (V42=0) displacement is cancelled.
				XV10				; Move WP to the next enabled position.
			ENDIF
		ENDIF
		; V82 is the displacement from WP2 to the next enabled position.
		; V42=1 if PRG1 is enabled or =0 if it is disabled.
		V100 = V42 * V82; If WP2 or PRG1 is disabled, V100=0
		IF V100 > 0			
			V10 = V99 - V82; Next displacement added to ICS correction
			V99 = 0				; Clear correction value
			V2 = V97			; Set FIRE counter (=1 for transition, =2 for pulse)
			WAITX					; Wait for the end of motor movement.
			V31 = 2				; Update current predefined position
			DO2 = 1				; Enable Syncbox trigger.
			; Wait for the start of camera exposure (FIRE=1).
			WHILE DI2 = 0	; DI2=1 during camera exposure
			ENDWHILE
			DO2 = 0				; Disable Syncbox trigger.
			; Wait for the end of camera exposure (FIRE=0).
			WHILE V2 > 0
				IF DI2 = 0		; DI2=0 when FIRE=0 (end of exposure)
					V2 = V2 - 1	; Update FIRE counter
				ELSE
					V2 = V97		; Reset FIRE counter
				ENDIF
			ENDWHILE
			IF V42 = 1		; If PRG1 is disabled (V42=0) displacement is cancelled.
				XV10				; Move WP to the next enabled position.
			ENDIF
		ENDIF
		; V83 is the displacement from WP3 to the next enabled position.
		; V42=1 if PRG1 is enabled or =0 if it is disabled.
		V100 = V42 * V83; If WP3 or PRG1 is disabled, V100=0
		IF V100 > 0			
			V10 = V99 - V83; Next displacement added to ICS correction
			V99 = 0				; Clear correction value
			V2 = V97			; Set FIRE counter (=1 for transition, =2 for pulse)
			WAITX					; Wait for the end of motor movement.
			V31 = 3				; Update current predefined position
			DO2 = 1				; Enable Syncbox trigger.
			; Wait for the start of camera exposure (FIRE=1).
			WHILE DI2 = 0	; DI2=1 during camera exposure
			ENDWHILE
			DO2 = 0				; Disable Syncbox trigger.
			; Wait for the end of camera exposure (FIRE=0).
			WHILE V2 > 0
				IF DI2 = 0		; DI2=0 when FIRE=0 (end of exposure)
					V2 = V2 - 1	; Update FIRE counter
				ELSE
					V2 = V97		; Reset FIRE counter
				ENDIF
			ENDWHILE
			IF V42 = 1		; If PRG1 is disabled (V42=0) displacement is cancelled.
				XV10				; Move WP to the next enabled position.
			ENDIF
		ENDIF
		; V84 is the displacement from WP4 to the next enabled position.
		; V42=1 if PRG1 is enabled or =0 if it is disabled.
		V100 = V42 * V84; If WP4 or PRG1 is disabled, V100=0
		IF V100 > 0			
			V10 = V99 - V84; Next displacement added to ICS correction
			V99 = 0				; Clear correction value
			V2 = V97			; Set FIRE counter (=1 for transition, =2 for pulse)
			WAITX					; Wait for the end of motor movement.
			V31 = 4				; Update current predefined position
			DO2 = 1				; Enable Syncbox trigger.
			; Wait for the start of camera exposure (FIRE=1).
			WHILE DI2 = 0	; DI2=1 during camera exposure
			ENDWHILE
			DO2 = 0				; Disable Syncbox trigger.
			; Wait for the end of camera exposure (FIRE=0).
			WHILE V2 > 0
				IF DI2 = 0		; DI2=0 when FIRE=0 (end of exposure)
					V2 = V2 - 1	; Update FIRE counter
				ELSE
					V2 = V97		; Reset FIRE counter
				ENDIF
			ENDWHILE
			IF V42 = 1		; If PRG1 is disabled (V42=0) displacement is cancelled.
				XV10				; Move WP to the next enabled position.
			ENDIF
		ENDIF
		; V85 is the displacement from WP5 to the next enabled position.
		; V42=1 if PRG1 is enabled or =0 if it is disabled.
		V100 = V42 * V85; If WP5 or PRG1 is disabled, V100=0
		IF V100 > 0			
			V10 = V99 - V85; Next displacement added to ICS correction
			V99 = 0				; Clear correction value
			V2 = V97			; Set FIRE counter (=1 for transition, =2 for pulse)
			WAITX					; Wait for the end of motor movement.
			V31 = 5				; Update current predefined position
			DO2 = 1				; Enable Syncbox trigger.
			; Wait for the start of camera exposure (FIRE=1).
			WHILE DI2 = 0	; DI2=1 during camera exposure
			ENDWHILE
			DO2 = 0				; Disable Syncbox trigger.
			; Wait for the end of camera exposure (FIRE=0).
			WHILE V2 > 0
				IF DI2 = 0		; DI2=0 when FIRE=0 (end of exposure)
					V2 = V2 - 1	; Update FIRE counter
				ELSE
					V2 = V97		; Reset FIRE counter
				ENDIF
			ENDWHILE
			IF V42 = 1		; If PRG1 is disabled (V42=0) displacement is cancelled.
				XV10				; Move WP to the next enabled position.
			ENDIF
		ENDIF
		; V86 is the displacement from WP6 to the next enabled position.
		; V42=1 if PRG1 is enabled or =0 if it is disabled.
		V100 = V42 * V86; If WP6 or PRG1 is disabled, V100=0
		IF V100 > 0			
			V10 = V99 - V86; Next displacement added to ICS correction
			V99 = 0				; Clear correction value
			V2 = V97			; Set FIRE counter (=1 for transition, =2 for pulse)
			WAITX					; Wait for the end of motor movement.
			V31 = 6				; Update current predefined position
			DO2 = 1				; Enable Syncbox trigger.
			; Wait for the start of camera exposure (FIRE=1).
			WHILE DI2 = 0	; DI2=1 during camera exposure
			ENDWHILE
			DO2 = 0				; Disable Syncbox trigger.
			; Wait for the end of camera exposure (FIRE=0).
			WHILE V2 > 0
				IF DI2 = 0		; DI2=0 when FIRE=0 (end of exposure)
					V2 = V2 - 1	; Update FIRE counter
				ELSE
					V2 = V97		; Reset FIRE counter
				ENDIF
			ENDWHILE
			IF V42 = 1		; If PRG1 is disabled (V42=0) displacement is cancelled.
				XV10				; Move WP to the next enabled position.
			ENDIF
		ENDIF
		; V87 is the displacement from WP7 to the next enabled position.
		; V42=1 if PRG1 is enabled or =0 if it is disabled.
		V100 = V42 * V87; If WP7 or PRG1 is disabled, V100=0
		IF V100 > 0			
			V10 = V99 - V87; Next displacement added to ICS correction
			V99 = 0				; Clear correction value
			V2 = V97			; Set FIRE counter (=1 for transition, =2 for pulse)
			WAITX					; Wait for the end of motor movement.
			V31 = 7				; Update current predefined position
			DO2 = 1				; Enable Syncbox trigger.
			; Wait for the start of camera exposure (FIRE=1).
			WHILE DI2 = 0	; DI2=1 during camera exposure
			ENDWHILE
			DO2 = 0				; Disable Syncbox trigger.
			; Wait for the end of camera exposure (FIRE=0).
			WHILE V2 > 0
				IF DI2 = 0		; DI2=0 when FIRE=0 (end of exposure)
					V2 = V2 - 1	; Update FIRE counter
				ELSE
					V2 = V97		; Reset FIRE counter
				ENDIF
			ENDWHILE
			IF V42 = 1		; If PRG1 is disabled (V42=0) displacement is cancelled.
				XV10				; Move WP to the next enabled position.
			ENDIF
		ENDIF
		; V88 is the displacement from WP8 to the next enabled position.
		; V42=1 if PRG1 is enabled or =0 if it is disabled.
		V100 = V42 * V88; If WP8 or PRG1 is disabled, V100=0
		IF V100 > 0			
			V10 = V99 - V88; Next displacement added to ICS correction
			V99 = 0				; Clear correction value
			V2 = V97			; Set FIRE counter (=1 for transition, =2 for pulse)
			WAITX					; Wait for the end of motor movement.
			V31 = 8				; Update current predefined position
			DO2 = 1				; Enable Syncbox trigger.
			; Wait for the start of camera exposure (FIRE=1).
			WHILE DI2 = 0	; DI2=1 during camera exposure
			ENDWHILE
			DO2 = 0				; Disable Syncbox trigger.
			; Wait for the end of camera exposure (FIRE=0).
			WHILE V2 > 0
				IF DI2 = 0		; DI2=0 when FIRE=0 (end of exposure)
					V2 = V2 - 1	; Update FIRE counter
				ELSE
					V2 = V97		; Reset FIRE counter
				ENDIF
			ENDWHILE
			IF V42 = 1		; If PRG1 is disabled (V42=0) displacement is cancelled.
				XV10				; Move WP to the next enabled position.
			ENDIF
		ENDIF
		; V89 is the displacement from WP9 to the next enabled position.
		; V42=1 if PRG1 is enabled or =0 if it is disabled.
		V100 = V42 * V89; If WP9 or PRG1 is disabled, V100=0
		IF V100 > 0			
			V10 = V99 - V89; Next displacement added to ICS correction
			V99 = 0				; Clear correction value
			V2 = V97			; Set FIRE counter (=1 for transition, =2 for pulse)
			WAITX					; Wait for the end of motor movement.
			V31 = 9				; Update current predefined position
			DO2 = 1				; Enable Syncbox trigger.
			; Wait for the start of camera exposure (FIRE=1).
			WHILE DI2 = 0	; DI2=1 during camera exposure
			ENDWHILE
			DO2 = 0				; Disable Syncbox trigger.
			; Wait for the end of camera exposure (FIRE=0).
			WHILE V2 > 0
				IF DI2 = 0		; DI2=0 when FIRE=0 (end of exposure)
					V2 = V2 - 1	; Update FIRE counter
				ELSE
					V2 = V97		; Reset FIRE counter
				ENDIF
			ENDWHILE
			IF V42 = 1		; If PRG1 is disabled (V42=0) displacement is cancelled.
				XV10				; Move WP to the next enabled position.
			ENDIF
		ENDIF
		; V90 is the displacement from WP10 to the next enabled position.
		; V42=1 if PRG1 is enabled or =0 if it is disabled.
		V100 = V42 * V90; If WP10 or PRG1 is disabled, V100=0
		IF V100 > 0			
			V10 = V99 - V90; Next displacement added to ICS correction
			V99 = 0				; Clear correction value
			V2 = V97			; Set FIRE counter (=1 for transition, =2 for pulse)
			WAITX					; Wait for the end of motor movement.
			V31 = 10			; Update current predefined position
			DO2 = 1				; Enable Syncbox trigger.
			; Wait for the start of camera exposure (FIRE=1).
			WHILE DI2 = 0	; DI2=1 during camera exposure
			ENDWHILE
			DO2 = 0				; Disable Syncbox trigger.
			; Wait for the end of camera exposure (FIRE=0).
			WHILE V2 > 0
				IF DI2 = 0		; DI2=0 when FIRE=0 (end of exposure)
					V2 = V2 - 1	; Update FIRE counter
				ELSE
					V2 = V97		; Reset FIRE counter
				ENDIF
			ENDWHILE
			IF V42 = 1		; If PRG1 is disabled (V42=0) displacement is cancelled.
				XV10				; Move WP to the next enabled position.
			ENDIF
		ENDIF
		; V91 is the displacement from WP11 to the next enabled position.
		; V42=1 if PRG1 is enabled or =0 if it is disabled.
		V100 = V42 * V91; If WP11 or PRG1 is disabled, V100=0
		IF V100 > 0			
			V10 = V99 - V91; Next displacement added to ICS correction
			V99 = 0				; Clear correction value
			V2 = V97			; Set FIRE counter (=1 for transition, =2 for pulse)
			WAITX					; Wait for the end of motor movement.
			V31 = 11			; Update current predefined position
			DO2 = 1				; Enable Syncbox trigger.
			; Wait for the start of camera exposure (FIRE=1).
			WHILE DI2 = 0	; DI2=1 during camera exposure
			ENDWHILE
			DO2 = 0				; Disable Syncbox trigger.
			; Wait for the end of camera exposure (FIRE=0).
			WHILE V2 > 0
				IF DI2 = 0		; DI2=0 when FIRE=0 (end of exposure)
					V2 = V2 - 1	; Update FIRE counter
				ELSE
					V2 = V97		; Reset FIRE counter
				ENDIF
			ENDWHILE
			IF V42 = 1		; If PRG1 is disabled (V42=0) displacement is cancelled.
				XV10				; Move WP to the next enabled position.
			ENDIF
		ENDIF
		; V92 is the displacement from WP12 to the next enabled position.
		; V42=1 if PRG1 is enabled or =0 if it is disabled.
		V100 = V42 * V92; If WP12 or PRG1 is disabled, V100=0
		IF V100 > 0			
			V10 = V99 - V92; Next displacement added to ICS correction
			V99 = 0				; Clear correction value
			V2 = V97			; Set FIRE counter (=1 for transition, =2 for pulse)
			WAITX					; Wait for the end of motor movement.
			V31 = 12			; Update current predefined position
			DO2 = 1				; Enable Syncbox trigger.
			; Wait for the start of camera exposure (FIRE=1).
			WHILE DI2 = 0	; DI2=1 during camera exposure
			ENDWHILE
			DO2 = 0				; Disable Syncbox trigger.
			; Wait for the end of camera exposure (FIRE=0).
			WHILE V2 > 0
				IF DI2 = 0		; DI2=0 when FIRE=0 (end of exposure)
					V2 = V2 - 1	; Update FIRE counter
				ELSE
					V2 = V97		; Reset FIRE counter
				ENDIF
			ENDWHILE
			IF V42 = 1		; If PRG1 is disabled (V42=0) displacement is cancelled.
				XV10				; Move WP to the next enabled position.
			ENDIF
		ENDIF
		; V93 is the displacement from WP13 to the next enabled position.
		; V42=1 if PRG1 is enabled or =0 if it is disabled.
		V100 = V42 * V93; If WP13 or PRG1 is disabled, V100=0
		IF V100 > 0			
			V10 = V99 - V93; Next displacement added to ICS correction
			V99 = 0				; Clear correction value
			V2 = V97			; Set FIRE counter (=1 for transition, =2 for pulse)
			WAITX					; Wait for the end of motor movement.
			V31 = 13			; Update current predefined position
			DO2 = 1				; Enable Syncbox trigger.
			; Wait for the start of camera exposure (FIRE=1).
			WHILE DI2 = 0	; DI2=1 during camera exposure
			ENDWHILE
			DO2 = 0				; Disable Syncbox trigger.
			; Wait for the end of camera exposure (FIRE=0).
			WHILE V2 > 0
				IF DI2 = 0		; DI2=0 when FIRE=0 (end of exposure)
					V2 = V2 - 1	; Update FIRE counter
				ELSE
					V2 = V97		; Reset FIRE counter
				ENDIF
			ENDWHILE
			IF V42 = 1		; If PRG1 is disabled (V42=0) displacement is cancelled.
				XV10				; Move WP to the next enabled position.
			ENDIF
		ENDIF
		; V94 is the displacement from WP14 to the next enabled position.
		; V42=1 if PRG1 is enabled or =0 if it is disabled.
		V100 = V42 * V94; If WP14 or PRG1 is disabled, V100=0
		IF V100 > 0			
			V10 = V99 - V94; Next displacement added to ICS correction
			V99 = 0				; Clear correction value
			V2 = V97			; Set FIRE counter (=1 for transition, =2 for pulse)
			WAITX					; Wait for the end of motor movement.
			V31 = 14			; Update current predefined position
			DO2 = 1				; Enable Syncbox trigger.
			; Wait for the start of camera exposure (FIRE=1).
			WHILE DI2 = 0	; DI2=1 during camera exposure
			ENDWHILE
			DO2 = 0				; Disable Syncbox trigger.
			; Wait for the end of camera exposure (FIRE=0).
			WHILE V2 > 0
				IF DI2 = 0		; DI2=0 when FIRE=0 (end of exposure)
					V2 = V2 - 1	; Update FIRE counter
				ELSE
					V2 = V97		; Reset FIRE counter
				ENDIF
			ENDWHILE
			IF V42 = 1		; If PRG1 is disabled (V42=0) displacement is cancelled.
				XV10				; Move WP to the next enabled position.
			ENDIF
		ENDIF
		; V95 is the displacement from WP15 to the next enabled position.
		; V42=1 if PRG1 is enabled or =0 if it is disabled.
		V100 = V42 * V95; If WP15 or PRG1 is disabled, V100=0
		IF V100 > 0			
			V10 = V99 - V95; Next displacement added to ICS correction
			V99 = 0				; Clear correction value
			V2 = V97			; Set FIRE counter (=1 for transition, =2 for pulse)
			WAITX					; Wait for the end of motor movement.
			V31 = 15			; Update current predefined position
			DO2 = 1				; Enable Syncbox trigger.
			; Wait for the start of camera exposure (FIRE=1).
			WHILE DI2 = 0	; DI2=1 during camera exposure
			ENDWHILE
			DO2 = 0				; Disable Syncbox trigger.
			; Wait for the end of camera exposure (FIRE=0).
			WHILE V2 > 0
				IF DI2 = 0		; DI2=0 when FIRE=0 (end of exposure)
					V2 = V2 - 1	; Update FIRE counter
				ELSE
					V2 = V97		; Reset FIRE counter
				ENDIF
			ENDWHILE
			IF V42 = 1		; If PRG1 is disabled (V42=0) displacement is cancelled.
				XV10				; Move WP to the next enabled position.
			ENDIF
		ENDIF
		; V96 is the displacement from WP16 to the next enabled position.
		; V42=1 if PRG1 is enabled or =0 if it is disabled.
		V100 = V42 * V96; If WP16 or PRG1 is disabled, V100=0
		IF V100 > 0			
			V10 = V99 - V96; Next displacement added to ICS correction
			V99 = 0				; Clear correction value
			V2 = V97			; Set FIRE counter (=1 for transition, =2 for pulse)
			WAITX					; Wait for the end of motor movement.
			V31 = 16			; Update current predefined position
			DO2 = 1				; Enable Syncbox trigger.
			; Wait for the start of camera exposure (FIRE=1).
			WHILE DI2 = 0	; DI2=1 during camera exposure
			ENDWHILE
			DO2 = 0				; Disable Syncbox trigger.
			; Wait for the end of camera exposure (FIRE=0).
			WHILE V2 > 0
				IF DI2 = 0		; DI2=0 when FIRE=0 (end of exposure)
					V2 = V2 - 1	; Update FIRE counter
				ELSE
					V2 = V97		; Reset FIRE counter
				ENDIF
			ENDWHILE
			IF V42 = 1		; If PRG1 is disabled (V42=0) displacement is cancelled.
				XV10				; Move WP to the next enabled position.
			ENDIF
		ENDIF
	ENDWHILE
	V46 = 0			 				; Set end SUB/PRG1 code
END
;
;
;***********************
;* GENERAL SUBROUTINES *
;***********************
; Subroutines are implicitly 
; contained in Program 0 and 
; respond to SASTAT0 and SR0. 
;
;
;=====================
SUB 0	; STATUS REQUEST
;=====================
;
;	Insert into V30 some information about motor and mechanism
;
;	Resulting bit fields are:
;	struct	V30 {
;			int track :	 8		// original track and error codes of V46. = V46&255
;			int index	:  5		// predefined position index, =(V11&32)<<10
;			int eo:      1		// motor driver state =(EO<<15)
;			int init:  	 2		// INIT done flag, =(GFOCinit OTHERSinit)<<29
;			int status:	 9		// motor status, =(MST&511)<<16
;			int latch:	 2		// latch status
;			int io:      4		// motor inputs&outputs states, =(DO2 DO1 DI2 DI1)<<25
;
;	100 calls to SUB 0 takes 25 seconds (DMX-ETH GUI running)
;--------------------
;
	V30 = 0						; Clear previous status
	V1 = V46 & 255		; Get tracking/error code (1st 8 bits)
	V2 = V31 << 8			; Predefined position index (bits 8-12)  
	V2 = V32 & 7936		; If V31=-1, V2 = 7936 (all bits 8-12 = 1).
	V3 = 0
	IF EO = 1
		V3 = 8192				; 8192 = 2^13 (bit 13)
	ENDIF
	V4 = V44 & 32			; Mask GFOC INIT done flag
	IF V4 > 0
		V3 = V3 + 16384	; GFOC INIT flag at bit 14
	ENDIF
	V5 = V44 & 31			; V44&31 is greater than zero if initialization was
	IF V5 > 0					; performed (except for GFOC). 
		V3 = V3 + 32768	; INIT done flag of others mechanisms at bit 15
	ENDIF
	V11 = MSTX
	V5 = V11 & 511		; Mask the 11 LSBs of motor status
	V5 = V5 << 16			; bits 16-26
	V6 = LTSX					; Get latch status (2 bits)
	V6 = V6 & 3
	V7 = DO
	V7 = V7 << 2
	V7 = V7 + DI
	V7 = V7 << 2
	V7 = V7 + V6
	V8 = V7 << 27			; Shift the two bits of INIT done, DO, and DI	
	V9 = V1 + V2
	V9 = V9 + V3
	V9 = V9 + V5
	V30 = V9 + V8
ENDSUB
;
;
;===================================================
; SUBROUTINES 1 TO 16 MOVE WAVEPLATE TO THEIR 
; PREDEFINED POSITIONS WITHOUT REQUIRING PARAMETERS, 
; OPTIMIZING THE TIME SPENT IN COMMUNICATION.
;===================================================
;
; ICS FILLS V81 TO V96 ICS BEFORE CALLING THESE SUBROUTINES.
; ----------------------------------------------------------
;
SUB 1									; GO TO WP1
	V21 = 1							; Predefined position index
	V20 = V51						; Predefined position value
	GOSUB 23						; WPROT GOTO subroutine
ENDSUB
;
SUB 2									; GO TO WP2
	V21 = 2							; Predefined position index
	V20 = V52						; Predefined position value
	GOSUB 23						; WPROT GOTO subroutine
ENDSUB
;
SUB 3									; GO TO WP3
	V21 = 3							; Predefined position index
	V20 = V53						; Predefined position value
	GOSUB 23						; WPROT GOTO subroutine
ENDSUB
;
SUB 4									; GO TO WP4
	V21 = 4							; Predefined position index
	V20 = V54						; Predefined position value
	GOSUB 23						; WPROT GOTO subroutine
ENDSUB
;
SUB 5									; GO TO WP5
	V21 = 5							; Predefined position index
	V20 = V55						; Predefined position value
	GOSUB 23						; WPROT GOTO subroutine
ENDSUB
;
SUB 6									; GO TO WP6
	V21 = 6							; Predefined position index
	V20 = V56						; Predefined position value
	GOSUB 23						; WPROT GOTO subroutine
ENDSUB
;
SUB 7									; GO TO WP7
	V21 = 7							; Predefined position index
	V20 = V57						; Predefined position value
	GOSUB 23						; WPROT GOTO subroutine
ENDSUB
;
SUB 8									; GO TO WP8
	V21 = 8							; Predefined position index
	V20 = V58						; Predefined position value
	GOSUB 23						; WPROT GOTO subroutine
ENDSUB
;
SUB 9									; GO TO WP9
	V21 = 9							; Predefined position index
	V20 = V59						; Predefined position value
	GOSUB 23						; WPROT GOTO subroutine
ENDSUB
;
SUB 10								; GO TO WP10
	V21 = 10						; Predefined position index
	V20 = V60						; Predefined position value
	GOSUB 23						; WPROT GOTO subroutine
ENDSUB
;
;
SUB 11								; GO TO WP11
	V21 = 11						; Predefined position index
	V20 = V61						; Predefined position value
	GOSUB 23						; WPROT GOTO subroutine
ENDSUB
;
SUB 12								; GO TO WP12
	V21 = 12						; Predefined position index
	V20 = V62						; Predefined position value
	GOSUB 23						; WPROT GOTO subroutine
ENDSUB
;
SUB 13								; GO TO WP13
	V21 = 13						; Predefined position index
	V20 = V63						; Predefined position value
	GOSUB 23						; WPROT GOTO subroutine
ENDSUB
;
SUB 14								; GO TO WP14
	V21 = 14						; Predefined position index
	V20 = V64						; Predefined position value
	GOSUB 23						; WPROT GOTO subroutine
ENDSUB
;
SUB 15								; GO TO WP15
	V21 = 15						; Predefined position index
	V20 = V65						; Predefined position value
	GOSUB 23						; WPROT GOTO subroutine
ENDSUB
;
SUB 16								; GO TO WP16
	V21 = 16						; Predefined position index
	V20 = V66						; Predefined position value
	GOSUB 23						; WPROT GOTO subroutine
ENDSUB
;
;
;===================
SUB 17	; WPROT INIT
;===================
; 			SUB 31 REQUIRED
;       POL = 16			Set by ICS.
;				Reduction: 1:30
;--------------------
; The reference position is given by the latched position.
; The Final position of the INIT routine is 
; the first predefined position (ID = 1).
;--------------------
; V20: general optical-mechanical offset - predefpos[OFFSET].
;	V21: encoder value after INIT - predefpos[WP1].
; V44: flag bit (V44&1) initialization routine done
;	V72: acceptable position error (5 <-> 0.06 WP degrees)
;	V73: encoder counts equivalent to 1 WP turn
; V74: offset between sensor actuation to center points
; V46: OUTPUT: routine status, =1 during execution, =0 for normal finish, or error code.
; V31: OUTPUT: current predefined position index, -1 for invalid)
;--------------------
;
	; Check for same hardware and software IDs and both not equal to zero
	V46 = 1			 			; Set start SUB code
	V1 = 1						; Store WPROT ID
	IF V50 != V1
		V46 = 10				; Set Hardware ID error code
	ELSEIF V49 != V1
		V46 = 11				; Set Software ID error code
	ENDIF
	; Check for presence of a WP centered with optical beam
	V11 = MSTX				; Read motor status
	V2 = V11 & 48			; Mask LIM+ and LIM- sensors
	IF V2 != 0
		V46 = 212				; Set error WPSEL out of position
	ENDIF
	IF V46 != 1
		SR0 = 0					; End Sub (turn off Program 0)
	ENDIF
	; ===========================================
	; INSERT HERE iXon ARM / FIRE ENABLE ROUTINE.
	; ===========================================
	; Write mechanism constants
	; V72=2 was used until 20230711 when the error reached 3 encoder units.
	V72 = 5						; WPROT acceptable position error (5 <-> 0.06 WP degrees)
	V73 = 30000				; WPROT encoder counts equivalent to 1 WP turn
	V74 = 900					; offset from REF position to 
	V97 = 3						; WPROT CYCLIC delay counter to detect FIRE=0.
;	HSPD = 250000			; Maximum reliable velocity.
	HSPD = 160000			; 20230819 Reliable velocity after change of pulleys
	LSPD = 1000
  EO = 1						; Enable motor driver
	V44 = 0						; Reset INIT flag
	V31 = -1					; Set an invalid position code
	; Rotates WPROT until position is latched twice.
	; The second latching is considered the REF position
	; to assure that it is taken always at same velocity.
	V3 = 2						; While loop counter for latching
	EX = -1000				; As motor rotates CCW, this prevents
	PX = -10000				; both EX and PX from changing sign.
	JOGX-							; Puts motor to rum CCW.
	WHILE V3 > 0
		V15 = 400				; Timeout counter. 400 = 2 WP turns.
		V5 = 0					; Store LTSX status
		; JOG- until position be latched
		; (the first one will be discarded)
		LTX = 0					; Enable latching
		LTX = 1
		WHILE V5 != 2		; Wait for first latching
			V5 = LTSX			; Read latch status
			V15 = V15 - 1
			IF V15 < 1		; Check timeout
				STOPX				; Stop JOG
				V46 = 17		; Set timeout error code
				SR0 = 0			; End Sub (turn off Program 0)
			ENDIF
		ENDWHILE
		V3 = V3 - 1
	ENDWHILE
	STOPX							; Stop WP.
	DELAY = 500
	; Checks that there is no discrepancy between EX and PX (pulses lost).
	V13 = PX					; Get current usteps counter
	V3 = V13 / 10			; and convert it to encoder units
	V12 = EX					; Get current encoder units and 
	V5 = V12 - V3			; determines the absolute difference
	IF V5 < 0					; between both counters.
		V5 = -1 * V5		
	ENDIF
	IF V5 > V72				; If difference greater than acceptable error
		V46 = 18
		SR0 = 0
	ENDIF
	; Move WP to WP1 position
	ABS								; Select absolute mode
	V14 = LTEX				; Current encoder counter
	V6 = V14 - V73		; Next REF position (1 turn ahead, CCW direction).
	V7 = V6 - V74			; Next REF position with mechanical/optical offset.
	V8 = V7 - V20			; Next REF position with software def. predefpos[OFFSET].
	V9 = V8 - V21			; Next REF position with software def. predefpos[WP1].
	V10 = 10 * V9			; Convert encoder to usteps and to CCW direction
	XV10							; Move to WP1 position
	WAITX
	; Set EX and PX with WP1 position
	V12 = -1 * V21		; Negative value due to CCW direction
	EX = V12
	V13 = 10 * V12
	PX = V13					; Set reference positions	
	V31 = 1						; Set current position code
	V44 = V1					; Set flag INIT already executed
	V46 = 0			 			; Set end SUB code
ENDSUB
;
;
;===================
SUB 18	; WPSEL INIT
;===================
; 			SUB 31 REQUIRED
;       POL = 80			Set by ICS.
;				Reduction: 5 rotations / mm
;--------------------
; The Final position of the INIT routine is L/4
; The HOME sensor should not be used as a reference 
; because it can also be activated by WPROT actuators.
;--------------------
; V20: general optical-mechanical offset, predefpos[OFFSET].
;	V21: encoder value after INIT, predefpos[L/4].
; V44: flag bit (V44&2) initialization routine done
; V74: offset between sensor actuation to center points
;	V75: offset (uSteps) to move mechanism away from sensors (=250000)
; V46: OUTPUT: routine status, =1 during execution, =0 for normal finish, or error code.
; V31: OUTPUT: current predefined position index, -1 for invalid.
;--------------------
;
	; Check for same hardware and software IDs and both not equal to zero
	V46 = 1			 			; Set start SUB code
	V1 = 2						; Store WPSEL ID
	; Validate ID and HOME offset value
	IF V50 != V1
		V46 = 20				; Set Hardware ID error code
	ELSEIF V49 != V1
		V46 = 21				; Set Software ID error code
	ENDIF
	IF V46 != 1
		SR0 = 0 				; End Sub (turn off Program 0)
	ENDIF
	; Write mechanism constants
	V70 = -10000			; WPSEL minimum target´position in encoder units
	V71 = 810000			; WPSEL maximum target position in encoder units
	V72 = 50					; WPSEL acceptable position error (50 <-> 0.01mm)
	V74 = -5000				; WPSEL offset between sensor actuation to center point
	V75 = 250000			; WPSEL offset (usteps) to move mechanism away from sensors.
	HSPD = 220000			; Set motor parameters
	LSPD = 1000
  EO = 1						; Enable motor driver
	INC								; Select incremental mode
	V44 = 0						; Reset INIT flag
	V31 = -1					; Set an invalid position code
	ECLEARX						; Clear errors
	; If L/4 already activated, move mechanism away from it
	V11 = MSTX				; Vn = MSTX & num is an invalid instruction
	V2 = V11 & 256		; Read L/4 sensor
	IF V2 = 256		
		XV75						; Displacement to move mechanism away from sensors
		WAITX
	ENDIF
	; Move mechanism towards L/4
	V15 = 2000			; Set timeout counter (must be > 1300)
	V4 = 0					; Store LTSX status
	LTX = 0					; Enable latching
	LTX = 1
	X-10000000			; Move towards L/4 (10000000 > operating range) 
	WHILE V4 != 2		; Wait for L/4 activation
		V4 = LTSX			; Read latch status
		V15 = V15 - 1
		IF V15 < 1		; Check timeout
			STOPX
			V46 = 27		; Set Timeout error code
			SR0 = 0			; End Sub (turn off Program 0)
		ENDIF
	ENDWHILE
	STOPX
	DELAY = 500
	; The code below is equivalent to set PX=EX=0 at L/4 actuation point.
	V14 = LTEX				; Read encoder counter at L/4 activation point
	V12 = EX					; DMX-ETH does not support instruction V8=EX-V6
	V12 = V12 - V14		; Get displacement from latched position (V6<V5 ever)
	EX = V12					; set encoder counter with that value (ever negative).
	V13 = 10 * V12
	PX = V13					; Synchronize uStep counter with encoder counter.
	; Apply the HOME offset defined by ICS at V20
	XV75							; First, move mechanism away from L/4 sensor
	WAITX
	ABS
	V5 = V20 + V74		; Sum hardware offset (V74) with configuration offset (V20)
	V10 = 10 * V5			; Convert to uSteps units
	XV10							; Move to L/4 position.
	WAITX
	; Check state of sensors (L/4 must be activated and LIM- not)
	V11 = MSTX				; Read motor status
	V6 = V11 & 272		; Mask L/4 and LIM- sensors
	
	IF V6 != 256			; =256 if L/4 activated and LIM- not
		V46 = 29				; Improper adjustment of sensors error code
	ELSE
		V31 = 1					; Set position ID code of L/4 position
		V13 = 10 * V21	; Convert L/4 offset (encoder units) to usteps
		EX = V21				; Set encoder counter to L/4 configuration offset
		PX = V13				; Set usteps counter to L/4 offset in usteps units
		V44 = V1				; Set flag INIT already executed
		V46 = 0			 		; Set end SUB code
	ENDIF
	EO = 0						; Disable motor driver
ENDSUB
;
;
;==================
SUB 19	; CALW INIT
;==================
; 			SUB 31 REQUIRED
;       POL = 0
;				Reduction: 1:60
;--------------------
; The Final position of the INIT routine is 
; the first predefined position (ID = 1).
;--------------------
; V20: general optical-mechanical offset - predefpos[OFFSET].
;	V21: encoder value after INIT - predefpos[OFF].
; V44: flag bit (V44&4) initialization routine done
; V74: offset between sensor actuation to center points
;	V75: uSteps to reach next position
; V46: OUTPUT: routine status, =1 during execution, =0 for normal finish, or error code.
; V31: OUTPUT: current predefined position index, -1 for invalid)
;--------------------
	; Check for same hardware and software IDs and both not equal to zero
	V46 = 1			 			; Set start SUB code
	V1 = 4						; Set CALW ID code
	IF V50 != V1
		V46 = 30				; Set Hardware ID error code
		SR0 = 0					; End Sub (turn off Program 0)
	ENDIF
	IF V49 != V1
		V46 = 31				; Set Software ID error code
		SR0 = 0					; End Sub (turn off Program 0)
	ENDIF
	V44 = 0						; Reset INIT flag
	; Write mechanism constants
	V72 = 5						; CALW acceptable position error (5 <-> 0.02 degrees, encoder units)
	V73 = 60000				; CALW encoder displacement per turn
	V74 = 3400				; CALW offset (usteps) from sensor actuation to center points
	V75 = 120000			; CALW usteps to move between adjacent positions
	HSPD = 100000 		; Set motor parameters OPD, 9/11/22
	LSPD = 800
	ABS
	V2 = -1 * V75			; uSteps to reach next position
	V31 = -1					; Set an invalid position code
	EX = -1000				; As motor rotates CCW, this prevents
	PX = -10000				; both EX and PX from changing sign.
  EO = 1			 			; Enable motor driver
	; If necessary move CALW to release all sensors
	V11 = MSTX				; Read status (Vn = MSTX & num is an invalid instruction)
	V3 = V11 & 296		; Mask sensor bits. 296=8(CW0)+256(CW1)+32(CW2)
	IF V3 != 	296			; =296 if all sensors are released
		V10 = V2 / 2		; half inter-position displacement
		XV10
		WAITX
	ENDIF
	; Move CALW until a position latching
	V15 = 1000				; Set timeout counter
	LTX = 0						; Enable LATCH trigger
	LTX = 1
	JOGX-							; Move CALW
	V5 = 0						; While loop flag
	WHILE V5 != 2
		V5 = LTSX				; Latch status =2 after latching
		V15 = V15 - 1
		IF V15 < 1			; Test timeout
			STOPX					; Stop motor
			V46 = 47			; Set Timeout error code
			EO = 0
			SR0 = 0				; End Sub (turn off Program 0)
		ENDIF
	ENDWHILE
	STOPX							; Stop motor
	V4 = LTPX					; Get actuation point position of sensor
	V4 = V4 + V74			; Determines the center position of sensor
	V10 = V4 + V2			; Set target position to next position, and
	XV10							; move to it.
	WAITX
	; Check which position has been reached
	V7 = 0						; Position reached flag (=0 not reached)
	V11 = MSTX				; Read status (Vn = MSTX & num is an invalid instruction)
	V6 = V11 & 296		; Mask sensor bits. 296=8(CW0)+256(CW1)+32(CW2)
	IF V6 = 32				; Reached position #3 - PINHOLE
		V7 = 3					; Set position difference to position #1 (OFF)
	ELSEIF V6 = 264		; Reached position #4 - SHUTTER
		V7 = 2					; Set position difference to position #1 (OFF)
	ELSE
		V46 = 39				; Set Search for REF error code
		EO = 0					; Disable motor driver
		SR0 = 0					; End Sub (turn off Program 0)
	ENDIF
	; Move to position #1 (OFF) based on V7
	V7 = V7 * V2			; Displacement (usteps) to reach position #1
	V8 = V20 + V21		; Sum the offsets of predefpos[OFFSET] and predefpos[OFF]
	V8 = -10 * V8			; Convert offset to usteps
	V7 = V7 + V8			; Displacement plus offset (usteps) 
	V10 = V7 + PX			
	XV10
	WAITX
	; Verify if CALW stays at position #1
	DELAY = 50				; Only for safety. 
	V11 = MSTX				; Read status (Vn = MSTX & num is an invalid instruction)
	V6 = V11 & 296		; Mask sensor bits. 296=8(CW0)+256(CW1)+32(CW2)
	IF V6 != 288
		V46 = 39				; Set Sensor CW0 error code
	ELSE
		; Adjust parameters and exit
		V12 = -1 * V21	; Get offset of position #1, correcting it for CCW rotation
		EX = V12				; Set encoder counter to OFF configuration offset
		V13 = 10 * V12
		PX = V13				; Set usteps counter to OFF offset in usteps units
		V31 = 1					; Set current position code
		V44 = V1				; Set flag INIT already executed
		V46 = 0			 		; Set end SUB code
	ENDIF
	EO = 0						; Disable motor driver
ENDSUB 
;
;
;==================
SUB 20	; ASEL INIT
;==================
; 			SUB 31 REQUIRED
;       POL = 48		Set by ICS.
;				Reduction: 1:60
;				Conversion: 1000 encoder units = 6 degrees
;--------------------
; The Final position of the INIT routine is 
; the first predefined position (ID = 1).
;--------------------
; V20: general optical-mechanical offset, predefpos[OFFSET].
;	V21: encoder value after INIT, predefpos[OFF].
; V44: flag bit (V44&8) initialization routine done
; V74: offset between sensor actuation to center points
;	V75: displacement to release HOME and LIM+ sensors
; V46: OUTPUT: routine status, =1 during execution, =0 for normal finish, or error code.
; V31: OUTPUT: current predefined position index, -1 for invalid)
;--------------------
	; Check for same hardware and software IDs and both not equal to zero
	V46 = 1			 			; Set start SUB code
	V1 = 8						; Store ASEL ID
	IF V50 != V1
		V46 = 40				; Set Hardware ID error code
		SR0 = 0					; End Sub (turn off Program 0)
	ENDIF
	IF V49 != V1
		V46 = 41				; Set Software ID error code
		SR0 = 0					; End Sub (turn off Program 0)
	ENDIF
	V31 = -1					; Set invalid position code
	; Write mechanism constants
	V70 = -250				; ASEL minimum target´position in encoder units
	V71 = 50000				; ASEL maximum target position in encoder units
	V74 = -200				; ASEL offset between sensor actuation to home position
	V75 = 5000				; ASEL displacement to release HOME or LIM+ sensors
	HSPD = 10000 			; Set motor parameters
	LSPD = 800
  EO = 1						; Enable motor driver
	V10 = -1 * V75		; Displacement to release HOME and LIM+ sensors 
	; Move ASEL away from HOME sensor if it is actuated
	V11 = MSTX				; Read sensors and mask bits
	V2 = V11 & 40			; 40 = 32 (LIM+) + 8 (HOME)
	IF V2 != 0
		XV10
		WAITX
	ENDIF
	; Search for HOME and apply predefined offset
	HLHOMEX+					; Execute Home operation
	WAITX							; At end, PX=EX=0.
	ABS
	XV10							; Move ASEL away from HOME
	WAITX							; and apply the offset (V20)
	V3 = V20 + V21		; Sum the offsets of predefpos[OFFSET] and predefpos[OFF]	
	V4 = V20 + V74		; Sum the offset between sensor actuation to center points	
	V10 = -1 * V4			; Minus sign due to ccw
	XV10
	WAITX
	EO = 0						; Disable motor
	DELAY = 300
	; Verify sensor states
	V11 = MSTX				; Read sensors and mask bits
	V5 = V11 & 40			; 40 = 32 (LIM+) + 8 (HOME)
	IF V5 != 8				; HOME must be activated and LIM= not.
		V46 = 49				; Set Hardware ID error code
	ELSE
		; Adjust parameters and exit
		V12 = -1 * V21	; Get offset of position #1, correcting it for CCW rotation
		V13 = 10 * V12
		EX = V12				; Set encoder counter to OFF configuration offset
		PX = V13				; Set usteps counter to OFF offset in usteps units
		V44 = V1				; Set flag INIT already executed
		V31 = 1					; Set position code
		V46 = 0					; Set end SUB code
	ENDIF
ENDSUB
;
;
;==================
SUB 21	; GMIR INIT
;==================
; 			SUB 31 REQUIRED
;				POL = 0
;				Reduction: 1:60
;
;--------------------
; V20: displacement for HOME position (encoder units)
; V44: flag bit (V44&16) initialization routine done
; V73: maximum target position (encoder counter, = 60000)
; V74: offset between sensor actuation to center points
; V46: OUTPUT: routine status, =1 during execution, =0 for normal finish, or error code.
; V31: OUTPUT: current predefined position index, -1 for invalid)
;--------------------
	V46 = 1			 			; Set start SUB code
	; Check for same hardware and software IDs and both not equal to zero
	V1 = 16						; Store GFOC ID
	V2 = V50 & V1
	V3 = V49 & V1
	IF V2 = 0
		V46 = 50				; Set Hardware ID error code
	ELSEIF V3 = 0
		V46 = 51				; Set Software ID error code
	; Check for presence of ECHARPE mirror into optical beam
;	ELSEIF DI2 = 0		; DI2 = 1 enable GMIR movements.
;		V46 = 205				; Set ECHARPE mirror error code
	ENDIF
	IF V46 != 1
		SR0 = 0					; End Sub (turn off Program 0)
	ENDIF
	; Reset GMIR INIT flag
	V3 = V44 & V1
	IF V3 != 0
		V44 = V44 - V1
	ENDIF
	V31 = -1					; Set invalid position code
	; Set a positive arbitrary position to avoid negative values
	V12 = 10000				; Arbitrary position value
	EX = V12
	V13 = 10 * V12
	PX = V13
	; Prepare for timeout check
	V15 = 400					; Timeout counter (normally takes ~150 counts)
	V4 = 0						; Store LTSX status
	; Write mechanism constants
	V72 = 5						; GMIR acceptable positioning error (encoder units)
	V73 = 60000				; GMIR encoder counts per turn.
	V74 = 150					; GMIR offset between sensor actuation to ref switch center
	HSPD = 150000			; Set motor max. velocity (4s/turn)
	LSPD = 1000
	ABS								; Select absolute mode
  EO = 1						; Enable motor driver
	; JOG+ until position be latched twice by ref switch
	; (the first one will be discarded)
	LTX = 0						; Enable latching
	LTX = 1
	JOGX+							; Put GMIR to run (always on direct direction).
	WHILE V4 != 2			; Wait for first latching
		V4 = LTSX				; Read latch status
		V15 = V15 - 1
		IF V15 < 1			; Check timeout
			V4 = 2				; Timeout, leave while loop
			V46 = 57			; Set Timeout error code
		ENDIF
	ENDWHILE
	LTX = 0						; Enable latching again
	LTX = 1
	V15 = 400
	V4 = 0
	WHILE V4 != 2			; Wait for second latching
		V4 = LTSX				; Read latch status
		V15 = V15 - 1
		IF V15 < 1			; Check timeout
			V4 = 2				; Timeout, leave while loop
			V46 = 57			; Set Timeout error code
		ENDIF
	ENDWHILE
	STOPX							; Stop GMIR.
	DELAY = 1000
	; Check for rotation 
	V5 = V12 - EX			; Get motor displacement. It must be
	IF V5 < 0					; greater than one complete turn of GMIR
		V5 = -1 * V5		; Get absolute value
	ENDIF
	IF V5 < V73
		V46 = 58				; Motor have been stalled
	ENDIF
	IF V46 != 1
		SR0 = 0					; End Sub (turn off Program 0)
	ENDIF
	; Determine and move to HOME position
	V14 = LTEX				; Latched encoder count
	V6 = V14 + V73		; Next ref. position.
	V7 = V6 + V74			; Sum the centering offset
	V8 = V7 + V20			; Sum the mechanism offset
	V10 = 10 * V8
	XV10							; Move to HOME position
	WAITX
  EO = 0						; Disable motor driver
	DELAY = 300				; Give some time to motor stabilization
	PX = 0						; Set reference positions
	EX = 0
	V31 = 1						; Target position index
	V44 = V44 | V1		; Set INIT executed flag
	V46 = 0			 			; Set end SUB code
ENDSUB
;
;
;==================
SUB 22	; GFOC INIT
;==================
; 			SUB 31 REQUIRED
;				Reduction: 82 pulses / mm. Curse = 19mm. Resolution = 12.2 um
;				After INIT, 3 pulses are required to begin focuser movement,
;				so 1561 pulses (82x19+3) must be applied to reach end position.
;
; Execution time: >85s, from PARK: 12s
; 112 assembly lines
;--------------------
; V20: displacement for HOME position (pulse counts)
; V44: flag bit (V44&32) initialization routine done
; V75: Timeout counter, greater than 1560 (= 2000)
; V46: OUTPUT: routine status, =1 during execution, =0 for normal finish, or error code.
; V32: OUTPUT: current position (pulse counts)
;--------------------
;
	V46 = 1			 			; Set start SUB code
	; Check for same hardware and software IDs and both not equal to zero
	V1 = 32						; Store GFOC ID
	V2 = V50 & V1
	V3 = V49 & V1
	IF V2 = 0
		V46 = 60				; Set Hardware ID error code
		SR0 = 0					; End Sub (turn off Program 0)
	ENDIF
	IF V3 = 0
		V46 = 61				; Set Software ID error code
		SR0 = 0					; End Sub (turn off Program 0)
	ENDIF
	; Write mechanism constants
	V71 = 1560				; GFOC Maximum target position
	V74 = 10					; GFOC # overtravel pulses to eliminate backlash.
	V75 = 2000				; GFOC Timeout counter, greater than 1560
	; Reset GFOC INIT flag
	V3 = V44 & V1
	IF V3 != 0
		V44 = V44 - V1
	ENDIF
	; Turns EN* active
	DO1 = 0
	DO1 = 1
	DO1 = 0
	DO1 = 1
	DELAY = 100				; Wait for input stabilization
	IF DI1 = 1				; DI1=1 if REF sensor is actuated.
		; Moves as necessary to release the sensor.
		DO1 = 0					; Select direct direction
		DELAY = 100			; Wait for input stabilization
		V3 = 100				; Qty. of pulses enough to release REF
		WHILE V3 > 0		; =0 if REF switch not actuated.	
			; The instruction sequence inside this loop had been optimized
			; to generate the fastest reliable 50% duty cycle waveform at DO2.
			; DO NOT ALTER these instructions without careful inspection of pulse waveform.
			; 20221006: T0 = 22, T1 = 22
			DO2 = 0
			V32 = V32 + 1	; Update current position register
			DELAY = 2			; Adjust duty cycle to avoid missing steps
			DO2 = 1
			V3 = V3 - 1		; Decrement pulse counter
			DELAY = 1			; Adjust duty cycle to avoid missing steps
		ENDWHILE
		; REF release test
		DO1 = 1					; Enable REF reading and select reverse direction
		DELAY = 100			; Wait for input stabilization
		IF DI1 = 1			; DI1=1 if REF sensor yet actuated.
			V46 = 69			; REF sensor not released error code
			SR0 = 0
		ENDIF
	ENDIF
	; Move backward until REF switch activation
	V15 = V75					; Timeout=2000. Worst case: 1561 pulses (for x4)
	WHILE DI1 = 0			; =0 if REF switch not actuated.	
		; The instruction sequence inside this loop had been optimized
		; to generate the fastest reliable 50% duty cycle waveform at DO2.
		; DO NOT ALTER these instructions without careful inspection of pulse waveform.
			; 20221006: T0 = 22, T1 = 26
		DO2 = 0
		V32 = V32 - 1		; Update current position register
		DELAY = 2				; Adjust duty cycle to avoid missing steps
		DO2 = 1
		V15 = V15 - 1		; Decrement timeout counter
		IF V15 < 1
			V46 = 67			; Focus in timeout error code
			SR0 = 0				; End Sub (turn off Program 0)
		ENDIF
	ENDWHILE
	V32 = V20					; Equals HOME position to predefpos[OFFSET].
	V44 = V44 | V1		; Set INIT executed flag
	V46 = 0			 			; Set end SUB code
ENDSUB
;
;
;===================
SUB 23	; WPROT GOTO
;===================
;			Unit: 					encoder counts
;			Range:					0 - 60000
;			Conversion:			1000 counts = 6º
;			ICS unit:				degrees
;			ICS resolution:	0.001º
; 		SUB 31 REQUIRED
; ... assembly lines
;--------------------
; V20: target absolute position, set by ICS, encoder units.
; V21: target predefined position index (set by ICS)
; V31: current predefined position index (set by this subroutine, -1 for invalid)
; V44: flag bit (V44&1) initialization routine done (set by INIT routine).
; V46: routine status, =1 during execution, =0 for normal finish, or error code.
;
;	V73 = 30000				; Encoder counts equivalent to 1 WP turn CW.
;--------------------
;
	V46 = 1			 			; Set SUB running code
	V1 = 1						; Store WPROT ID
	V3 = V20					; Preserve target position
	; Check for same hardware and software IDs and both not equal to zero
	IF V50 != V1
		V46 = 110				; Set Hardware ID error code
	ELSEIF V49 != V1
		V46 = 111				; Set Software ID error code
	ELSEIF V21 < 1
		V46 = 112				; Set position index low value error code
	ELSEIF V21 > 17		; Index=17 when parameter is numeric
		V46 = 113				; Set position index high value error code
	ELSEIF V44 != V1
		V46 = 116				; Set INIT not executed error code
	ENDIF
	IF V46 != 1
		SR0 = 0					; End Sub (turn off Program 0)
	ENDIF
	; Reduce target position to first turn (0 - 360 degrees range)
	V2 = -1 * V73			; Encoder counts equivalent to 1 WP turn CCW.
	IF V3 < 0					; V3 can have a small negative value on WP1 offset
		WHILE V3 < V2		; While target value greater than 1 turn,
			V3 = V3 + V73	; Subtract 1 turn from target position
		ENDWHILE
	ELSE
		WHILE V3 > V73	; While target value greater than 1 turn,
			V3 = V3 - V73	; Subtract 1 turn from target position
		ENDWHILE
	ENDIF
	V3 = -1 * V3			; Convert target position to CCW direction
	; Find target position angle for a moving on CCW direction
	IF V3 > EX				; When V3 is more positive than EX, convert its value
		V3 = V3 - V73		; to the same angle but in CCW direction.
	ENDIF							; (WPROT does not rotate in CW direction to avoid backlash)
; 20230818: Motor parameters are written only in the INIT routine
;	HSPD = 250000			; Set motor parameters
;	LSPD = 1000
	ABS								; Absolute mode
  EO = 1			 			; Enable motor driver
	DELAY = 10				; Wait for driver power stabilization
	V10 = 10 * V3			; Convert encoder to uSteps units
	XV10							; Move to target position
	WAITX
	; Reduce encoder counter to first turn value
	V4 = 10 * V2			; uSteps value equivalent to 1 turn CCW.
	V12 = EX
	V13 = PX
	WHILE V2 >= V12		; Both V2 and V5 are negative values.
		V12 = V12 - V2
		V13 = V13 - V4
		EX = V12				; PX and EX are corrected separately
		PX = V13				; to avoid rounding errors.
	ENDWHILE
	V31 = V21					; Update current position code
	V46 = 0			 			; Set end SUB code
ENDSUB
;
;
;===================
SUB 24	; WPSEL GOTO
;===================
;			Unit: 					encoder counts
;			Range:					0 to 800000
;			Predefined:			ID=1 (L/4): 0, ID=2 (OFF): 400000, ID=3 (L/2): 800000
;			Conversion:			5000 counts = 1mm
;			ICS unit:				mm
;			ICS resolution:	0.0012mm
; 		SUB 31 REQUIRED
;
;--------------------
; V20: absolute target position (encoder units)
; V21: target predefined position index (set by ICS)
; V31: OUTPUT: current predefined position index (set by this subroutine, -1 if invalid)
;	V70: minimum target´position in encoder units (=-10000, -2mm from nominal L/4)
;	V71: maximum target position in encoder units (=810000, 2mm from nominal L/2)
; V72 = 50	Acceptable position error (50 <-> 0.01mm), encoder units
;
	V46 = 1			 			; Set start SUB code
	V1 = 2						; Store WPSEL ID
	V3 = V20					; Preserve target position
	; Check for same hardware and software IDs and both not equal to zero
	IF V50 != V1
		V46 = 120				; Set Hardware ID error code
	ELSEIF V49 != V1
		V46 = 121				; Set Software ID error code
	ELSEIF V21 < 1
		V46 = 122				; Set predefPos Index low value error code
	ELSEIF V21 > 4		; Index=4 when parameter is numeric
		V46 = 123				; Set predefPos Index high value error code
	ELSEIF V3 < V70		; V70: minimum target´position
		V46 = 124				; Set parameter low value error code
	ELSEIF V3 > V71		; V71: maximum target position
		V46 = 125				; Set parameter high value error code
	ELSEIF V44 != V1
		V46 = 126				; Set INIT not executed error code
	ENDIF
	IF V46 != 1
		SR0 = 0					; End Sub (turn off Program 0)
	ENDIF
	V31 = -1					; Set an invalid position code
; 20230818: Motor parameters are written only in the INIT routine
;	HSPD = 220000			; Set motor parameters
;	LSPD = 1000
	ABS
  EO = 1						; Enable motor driver
	DELAY = 10				; Wait for driver power stabilization
	V10 = 10 * V3			; Convert encoder units to uSteps
	XV10							; Move to selected position
	WAITX
	EO = 0						; Disable motor
	; Check positioning error
	V12 = EX					; Get the absolute value between
	V2 = V20 - V12		; current and target positions
	IF V2 < 0
		V2 = -1 * V2
	ENDIF
	IF V2 > V72				; Check for target=current positions
		V46 = 128				; Set Positioning error code
	ENDIF
	; Check sensors state against target predefined position index
	; ------------------------------------------------------------
	; The HOME sensor is not checked on L/2 and L/4 due to 
	; the possibility of being activated by WPROT actuators.
	V11 = MSTX				; Read motor status (sensors)
	V5 = V11 & 304		; 304=256(LATCH)+32(LIM+)+16(LIM-)		
	V6 = DI1					; read L/2 sensor
	V5 = V5 + V6			; join other sensors with DI1 (L/2 sensor)
	V4 = V11 & 8			; HOME sensor state.
	; Determine the expected state of sensors (V6)
	IF V21 = 1				; 1=L/4 index. only LATCH must be activated.
		V6 = 257				; 256 (L/4) + 1 (DI1 released)
	ELSEIF V21 = 2		; 2=OFF index. Must be activated, so
		V5 = V5 + V4		; consider HOME state now.
		V6 = 9					; 8 (HOME) + 1 (DI1 released)
	ELSEIF V21 = 3		; 3=L/2 index. DI1 must be activated.
		V6 = 0					; DI1=0 when L/2 activated
	ELSE
		V6 = V5					; Disable sensor check if ID (V21) invalid
	ENDIF
	IF V5 != V6
		V46 = 129				; Set inconsistent sensor state error code
	ENDIF
	IF V46 = 1
		V31 = V21				; Set position ID code
		V44 = V1				; Set flag INIT already executed
		V46 = 0					; Set end SUB code
	ENDIF
ENDSUB 
;
;
;==================
SUB 25	; CALW GOTO - COM PROBLEMAS - REVISAR !!! 
;==================
;			Unit: 					encoder counts
;			Range:					0 - 60000
;			Conversion:			1000 counts = 6º
;			ICS unit:				degrees
;			ICS resolution:	0.01º
; 		SUB 31 REQUIRED
;--------------------
; V20: target absolute position, set by ICS, encoder units.
; V21: target predefined position index (set by ICS)
; V44: flag bit (V44&4) initialization routine done
;	V72: acceptable position error (encoder units)
;	V73: encoder oounts per turn (=60000)
; V46: OUTPUT: routine status, =1 during execution, =0 for normal 1inish, or error code.
; V31: OUTPUT: current position index
;
	V46 = 1			 			; Set start SUB code
	V1 = 4						; Store CALW ID
	V3 = -1 * V20			; Change target position sign due to CCW direction
	; Calcule the difference between target and current positions
	V12 = EX					; Read encoder position
	V2 = V20 + V12		; Target-Current position diference (V20>0, V12(EX)<0)
	IF V2 < 0
		; Target position is behind current position
		V2 = -1 * V2		; Get absolute value of the difference
		V3 = V3 - V73		; Add 1 turn to target to maintain CCW direction1
	ENDIF
	; Check for same hardware and software IDs and both not equal to zero
	IF V50 != V1
		V46 = 130				; Set Hardware ID error code
	ELSEIF V49 != V1
		V46 = 131				; Set Software ID error code
	ELSEIF V21 < 1
		V46 = 132				; Set postion index low value error code
	ELSEIF V21 > 6		; Index=6 when parameter is numeric
		V46 = 133				; Set position index high value error code
	ELSEIF V44 != V1
		V46 = 136				; Set INIT not executed error code
	ELSEIF V2 <= V72
		V46 = 0					; Target and current positions are equal.
	ENDIF
	IF V46 != 1
		SR0 = 0					; End Sub (turn off Program 0)
	ENDIF
; 20230818: Motor parameters are written only in the INIT routine
;	HSPD = 100000 		; Set motor parameters
;	LSPD = 800
	ABS								; Set absolute mode
	V31 = -1					; Set an invalid position code
  EO = 1			 			; Enable motor driver
	DELAY = 10				; Wait for driver power stabilization
	; Move CALW
	V10 = 10 * V3
	XV10							; Go to target position
	WAITX
	; Reduce position counters to first turn
	V4 = -1 * V73			; Encoder value equivalent to 1 turn CCW
	V5 = 10 * V4			; uSteps value equivalent to 1 turn CCW
	V12 = EX
	V13 = PX
	WHILE V4 >= V12		; V4 is a negative value, so the comparison ">" 
		V12 = V12 - V4
		V13 = V13 - V5
		EX = V12				; Removes one turn from EX
		PX = V13				; and PX.
	ENDWHILE
	; Check for position error
	V5 = V12 + V20		; V20>0 and V12<0, so V5 is the diference between them
	IF V5 < 0
		V5 = -1 * V5		; Get the absolute value of difference
	ENDIF
	IF V5 > V72				; V72 is the acceptable error
		V46 = 138				; Set position error code
	ENDIF
	; Check sensors against predefined position
	V11 = MSTX				; Read status (Vn = MSTX&num is invalid) and mask
	V7 = V11 & 296		; bits. 296=8(CW0,HOME)+256(CW1,LATCH)+32(CW2,LIM+)
	; Determine the expected state of sensors (V8)
	; Remember that when a sensor is activated, its bit is read as 0.
	IF V21 = 1				; 1=OFF index,
		V8 = 288				; only HOME must be activated.
	ELSEIF V21 = 2		; 2=POLARIZER index
		V8 = 40					; only LATCH must be activated.
	ELSEIF V21 = 3		; 3=PINHOLE index 
		V8 = 32					; both HOME and LATCH must be activated.
	ELSEIF V21 = 4		; 4=SHUTTER index
		V8 = 264				; only LIM+ must be activated.
	ELSEIF V21 = 5		; 5=DEPOLARIZER index
		V8 = 256					; both HOME and LIM+ must be activated.
	ELSE
		V8 = V7					; Disable sensor check if ID (V21) invalid
	ENDIF
	IF V8 != V7
		V46 = 139
	ENDIF
	EO = 0						; Disable motor
	IF V46 = 1
		V31 = V21				; Set position ID code
		V46 = 0					; Set end SUB code
	ENDIF
ENDSUB 
;
;
;==================
SUB 26	; ASEL GOTO
;==================
;			Unit: 					encoder counts
;			Range:					0 to -5000
;			Conversion:			100 encoder counts = 6º
;			ICS unit:				%
;			ICS resolution:	0.01%
;--------------------
; V20: target absolute position, set by ICS, encoder units.
; V21: target predefined position index (set by ICS)
; V44: flag bit (V44&8) initialization routine done
;	V70: minimum target´position in encoder units (-250)
;	V71: maximum target position in encoder units (50000)
; V46: OUTPUT: routine status, =1 during execution, =0 for normal finish, or error code.
; V31: OUTPUT: current position index
;
	V46 = 1			 			; Set start SUB code
	V1 = 8						; Store ASEL ID
	V2 = V20					; Preserve target position
	; Check for same hardware and software IDs and both not equal to zero
	IF V50 != V1
		V46 = 140				; Set Hardware ID error code
	ELSEIF V49 != V1
		V46 = 141				; Set Software ID error code
	ELSEIF V21 < 1
		V46 = 142				; Set Parameter low value error code
	ELSEIF V21 > 3		; Index=3 when parameter is numeric
		V46 = 143				; Set Parameter high value error code
	ELSEIF V2 < V70		; V70: minimum target´position
		V46 = 144				; Set parameter low value error code
	ELSEIF V2 > V71		; V71: maximum target position
		V46 = 145				; Set parameter high value error code
	ELSEIF V44 != V1
		V46 = 146				; Set INIT not executed error code
	ELSEIF V2 = EX		; Check for target=current positions
		V46 = 0					; Clear SUB running code
	ENDIF
	IF V46 != 1
		SR0 = 0					; End Sub (turn off Program 0)
	ENDIF
	V31 = -1					; Set an invalid position code
; 20230818: Motor parameters are written only in the INIT routine
;	HSPD = 10000 			; Set motor parameters
;	LSPD = 800
	ABS
  EO = 1						; Enable motor driver
	DELAY = 10				; Wait for driver power stabilization
	; Change sign due to CCW direction, convert to uSteps, and move
	V10 = -10 * V2
	XV10
	WAITX
	DELAY = 100
	; Check sensors state according to predefined position index
	V11 = MSTX				; Read motor status (sensors)
	V3 = DI						; and DI (READY sensor). If V3=0 READY is activated.
	V4 = V11 & 56			; 56 = 32(LIM+)+16(LIM-)+8(HOME)
	V4 = V4 + V3			; Join states of all sensors.
	V4 = V4 & 57			; Mask bits of all sensors.
	; Determine the expected state of sensors (V6)
	IF V21 = 1				; 1=OFF index.
		V5 = 9					; only HOME must be activated.
	ELSEIF V21 = 2		; 2=ON index
		V5 = 0					; only DI1 must be activated.
	ELSE
		V5 = V4					; Disable sensor check if ID (V21) invalid
	ENDIF
	IF V5 != V4
		V46 = 149
	ENDIF
	EO = 0						; Disable motor
	IF V46 = 1
		V31 = V21				; Set position ID code
		V46 = 0					; Set end SUB code
	ENDIF
ENDSUB 
;
;
;==================
SUB 27	; GMIR GOTO
;==================
;			Unit: 					encoder counts
;			Range:					0 to -60000
;			Conversion:			12000 counts = 72º
;			ICS unit:				degrees
;			ICS resolution:	0.01º
; 		SUB 31 REQUIRED
; ... assembly lines
;--------------------
; V20: target position (set by ICS)
; V44: flag bit (V44&16) initialization routine done
; V73: encoder counts per turn (= 60000)
; V72: acceptable positioning error
; V3:  displacement
;
	V46 = 1			 			; Set start SUB code
	; Check for same hardware and software IDs and both not equal to zero
	V1 = 16						; Store GFOC ID
	V2 = V44 & V1			; INIT done flag
	V3 = V20					; Preserve target position	IF V2 = 0
	V4 = V50 & V1			; hardware ID
	V5 = V49 & V1			; software ID
	IF V4 != V1
		V46 = 150				; Set Hardware ID error code
	ELSEIF V5 != V1
		V46 = 151				; Set Software ID error code
	ELSEIF V2 = 0
		V46 = 156				; Set INIT not executed error code
	ELSEIF V3 = EX		; Check for target=current positions
		V46 = 0					; Clear SUB running code
	ENDIF
	IF V46 != 1
		SR0 = 0					; End Sub (turn off Program 0)
	ENDIF
	; Reduce target position to first turn (0 - 360 degrees range)
	V2 = -1 * V73			; Encoder counts equivalent to 1 WP turn CCW.
	IF V3 < 0
		WHILE V3 < V2		; While target value greater than 1 turn,
			V3 = V3 + V73	; Subtract 1 turn from target position
		ENDWHILE
	ELSE
		WHILE V3 > V73	; While target value greater than 1 turn,
			V3 = V3 - V73	; Subtract 1 turn from target position
		ENDWHILE
	ENDIF
	; Find target position angle for a moving on CW direction
	V4 = V3						; Preserv target position with first-turn value
	IF V4 < EX				; If target position is behind current position,
		V4 = V4 + V73		; convert it to the same angle in CW direction.
	ENDIF							; (GMIR does not rotate in CCW direction to avoid backlash)
; 20230818: Motor parameters are written only in the INIT routine
;	HSPD = 150000			; Set motor max. velocity (4s/turn)
;	LSPD = 1000
	ABS								; Select absolute mode
  EO = 1						; Enable motor driver
	V10 = 10 * V4			; Convert encoder unit to step unit
	XV10							; Start movement
	WAITX							; Wait for end of movement
	DELAY = 10
	; Reduce encoder counter to first turn value
	V5 = 10 * V73			; V5 = 1 turn uSteps count
	V13 = PX
	V12 = EX					; Encoder position
	WHILE V12 >= V73	; V12 = encoder position
		V12 = V12 - V73	; V73 = 1 turn encoder turn
		V13 = V13 - V5
		EX = V12
		PX = V13
	ENDWHILE
	; Check position error
	V8 = V3 - V12			; Position error
	IF V8 < 0
		V8 = -1 * V8		; Get absolute value of error
	ENDIF
	IF V8 > V72				; V72 = acceptable error
		V46 = 158				; Set error code
	ELSE
		V46 = 0					; Set end SUB code
	ENDIF
	EO = 0						; Disable motor
ENDSUB
;
;
;==================
SUB 28	; GFOC GOTO
;==================
;			Unit: 					pulse
;			Range:					0 - 1560
;			Conversion:			82 pulses = 1mm
;			ICS unit:				mm
;			ICS resolution:	0.012mm
; 		SUB 31 REQUIRED
;--------------------
; V20: target position (set by ICS)
; V32: current position (set by this subroutine)
; V44: flag bit (V44&32) initialization routine done
; V71: Maximum number of pulses
; V74: number of overtravel pulses to eliminate backlash4
; V4:  displacement
;
;
	V46 = 1			 			; Set start SUB code
	; Check for same hardware and software IDs and both not equal to zero
	V1 = 32						; GFOC ID
	V2 = 48						; GFOC + GMIR ID
	V3 = V44 & V1			; Get INIT executed flag
	IF V50 != V2
		V46 = 160				; Set Hardware ID error code
	ELSEIF V50 = V1
		V46 = 1
	ELSEIF V49 != V2
		V46 = 161				; Set Software ID error code
	ELSEIF V49 = V1
		V46 = 1
	ELSEIF V20 < 0		; Check for minimum target value
		V46 = 162				; Set Parameter low value error code
	ELSEIF V20 > V71	; Check for maximum target value
		V46 = 163				; Set Parameter high value error code
	ELSEIF V3 != V1		; Check for INIT done.
		V46 = 166				; Set INIT not executed error code
	ELSEIF V20 = V32	; Check for target=current positions
		V46 = 0					; Clear SUB running code
	ENDIF
	IF V46 != 1
		SR0 = 0					; End Sub (turn off Program 0)
	ENDIF
	; Turns EN* active
	DO1 = 1
	DO1 = 0
	DO1 = 1
	DELAY = 100				; Wait for input stabilization
	; If sensor GREF is activated, apply 3 pulses
	; to compensated displacement hysteresis.
	IF DI1 = 1				; DI1=1 if REF sensor is actuated.
		; Apply 3 pulses to release the sensor, without V31 update
		DO1 = 0					; Select direct direction
		V4 = 3					; Qty. of pulses enough to release REF
		WHILE V4 > 0	
			; The instruction sequence inside this loop had been optimized
			; to generate the fastest reliable 50% duty cycle waveform at DO2.
			; DO NOT ALTER these instructions without careful inspection of pulse waveform.
			; 20221006: T0 = 16, T1 = 16
			DO2 = 0
			DELAY = 10
			DO2 = 1
			V4 = V4 - 1		; Decrement pulse counter
		ENDWHILE
		V32 = 0					; Clear current position
	ENDIF
	; Find direction and displacement
	IF V20 > V32
		DO1 = 0					; direct movement
		V4 = V20 + V74	; target + overtravel
		; Start direct movement
		WHILE V4 > V32	
			; The instruction sequence inside this loop had been optimized
			; to generate the fastest reliable 50% duty cycle waveform at DO2.
			; DO NOT ALTER these instructions without careful inspection of pulse waveform.
			; 20221006: T0 = 16, T1 = 16
			DO2 = 0
			DELAY = 10
			DO2 = 1
			V32 = V32 + 1	; Increment current position
		ENDWHILE
	ENDIF
	DO1 = 1						; Set reverse direction
	DELAY = 100				; Wait for input stabilization
	WHILE V32 > V20	
		; The instruction sequence inside this loop had been optimized
		; to generate the fastest reliable 50% duty cycle waveform at DO2.
		; DO NOT ALTER these instructions without careful inspection of pulse waveform.
		DO2 = 0
		DELAY = 10
		DO2 = 1
		V32 = V32 - 1		; Increment current position
	ENDWHILE
	V46 = 0			 			; Set end SUB code
ENDSUB 
;
;
;======================
SUB 29	; GOTO DISPATCH
;======================
;	THIS SUBROUTINE CALLS THE GOTO SUBROUTINE OF THE
; MECHANISM IDENTIIFIED BY THE SOFTWARE ID (V49) VALUE. 
;
;--------------------
;	V49 constains the mechanism software ID stored by ICS.
	V1 = V49					; Get mechanism software ID
	IF V49 = 48				; Software ID V49=48 when both GMIR and GFOC are active.
		V1 = V21				; V21 must be =16 for GMIR or =32 for GFOC
	ENDIF
	IF V1 = 1
		GOSUB 23				; WPROT
	ELSEIF V1 = 2
		GOSUB 24				; WPSEL
	ELSEIF V1 = 4
		GOSUB 25				; CALW
	ELSEIF V1 = 8
		GOSUB 26				; ASEL
	ELSEIF V1 = 16
		GOSUB 27				; GMIR
	ELSEIF V1 = 32
		GOSUB 28				; GFOC
	ENDIF
ENDSUB
;
;
;======================
SUB 30	; INIT DISPATCH
;======================
;	THIS SUBROUTINE CALLS THE INIT SUBROUTINE OF THE
; MECHANISM IDENTIIFIED BY THE SOFTWARE ID (V49) VALUE. 
;
;--------------------
;	V49 constains the mechanism software ID found by PRG 0.
	V1 = V49					; Get mechanism software ID
	IF V49 = 48				; Software ID V49=48 when both GMIR and GFOC are active.
		V1 = V21				; V21 must be =16 for GMIR or =32 for GFOC
	ENDIF
	IF V1 = 1
		GOSUB 17				; WPROT
	ELSEIF V1 = 2
		GOSUB 18				; WPSEL
	ELSEIF V1 = 4
		GOSUB 19				; CALW
	ELSEIF V1 = 8
		GOSUB 20				; ASEL
	ELSEIF V1 = 16
		GOSUB 21				; GMIR
	ELSEIF V1 = 32
		GOSUB 22				; GFOC
	ENDIF
ENDSUB
;
;
;=======================
SUB 31	; ERROR HANDLING
;=======================
; 20221003: 3 assembly lines
;--------------------
	; Bit 12 of POL register (Jump to line 0 on error) must be cleared
	ECLEARX			 			; Clear error flag
ENDSUB
;
;