; da65 V2.19 - Git c720c3c48
; Created:    2026-04-12 14:14:36
; Input file: unpacked-prgs/half-pipe.prg
; Page:       1


        .setcpu "6502"

; ----------------------------------------------------------------------------
io_port_register:= $0000
cursor_position := $002D
game_state_function_table_index:= $002F
current_player_index:= $0031
cursor_color_maybe:= $003D
buffer_zp40     := $0040
buffer_zp56     := $0056
stack           := $0100
L0200           := $0200
keyboard_buffer := $0277
datasette_buffer:= $033C
player_1_name   := $0800
player_1_sponsor:= $080F
player_2_name   := $0820
player_2_sponsor:= $082F
player_3_name   := $0840
player_3_sponsor:= $084F
player_4_name   := $0860
player_4_sponsor:= $086F
player_5_name   := $0880
player_5_sponsor:= $088F
player_6_name   := $08A0
player_6_sponsor:= $08AF
player_7_name   := $08C0
player_7_sponsor:= $08CF
player_8_name   := $08E0
player_8_sponsor:= $08EF
hanmi           := $FFFA
hares           := $FFFC
hairq           := $FFFE
; ----------------------------------------------------------------------------
        sei                                     ; 0A00
        cld                                     ; 0A01
        lda     #$25                            ; 0A02
        sta     io_port_register+$01            ; 0A04
        lda     #$00                            ; 0A06
        sta     game_state_function_table_index ; 0A08
        sta     yscroll                         ; 0A0A
        ldy     #$02                            ; 0A0D
L0A0F:  sta     io_port_register,y              ; 0A0F
        iny                                     ; 0A12
        bne     L0A0F                           ; 0A13
        lda     #$FF                            ; 0A15
        sta     $79                             ; 0A17
        lda     #$18                            ; 0A19
        sta     $19                             ; 0A1B
        jsr     LEC00                           ; 0A1D
        jsr     LEC09                           ; 0A20
        jsr     init_buffers_zp40_zp56          ; 0A23
        jsr     L0FF3                           ; 0A26
        jsr     L0A33                           ; 0A29
        jsr     L1190                           ; 0A2C
        cli                                     ; 0A2F
L0A30:  jmp     L0A30                           ; 0A30

; ----------------------------------------------------------------------------
L0A33:  jsr     L1143                           ; 0A33
        lda     #$00                            ; 0A36
        sta     border_color                    ; 0A38
        rts                                     ; 0A3B

; ----------------------------------------------------------------------------
L0A3C:  .byte   $44                             ; 0A3C
L0A3D:  rol     $55                             ; 0A3D
        asl     a                               ; 0A3F
        .byte   $77                             ; 0A40
        asl     a                               ; 0A41
        sta     ($0A),y                         ; 0A42
        tsx                                     ; 0A44
        asl     a                               ; 0A45
        dex                                     ; 0A46
        asl     a                               ; 0A47
L0A48:  stx     $EA,y                           ; 0A48
        and     L765A                           ; 0A4A
        .byte   $7D                             ; 0A4D
L0A4E:  ora     ($02,x)                         ; 0A4E
L0A50:  brk                                     ; 0A50
        .byte   $04                             ; 0A51
        ora     io_port_register                ; 0A52
        rts                                     ; 0A54

; ----------------------------------------------------------------------------
        ldx     #$08                            ; 0A55
        ldy     #$00                            ; 0A57
        lda     #$ED                            ; 0A59
L0A5B:  cmp     LD012                           ; 0A5B
        bcs     L0A5B                           ; 0A5E
        jsr     L0A76                           ; 0A60
        jsr     L0A76                           ; 0A63
        jsr     L0A76                           ; 0A66
        jsr     L0A76                           ; 0A69
        cmp     ($03,x)                         ; 0A6C
        sty     background_color_0              ; 0A6E
        stx     xscroll                         ; 0A71
        inc     $30                             ; 0A74
L0A76:  rts                                     ; 0A76

; ----------------------------------------------------------------------------
        lda     LE7E8                           ; 0A77
        sta     background_color_0              ; 0A7A
        lda     $19                             ; 0A7D
        sta     xscroll                         ; 0A7F
        lda     $78                             ; 0A82
        beq     L0A90                           ; 0A84
        dec     $78                             ; 0A86
        bne     L0A90                           ; 0A88
        sta     sprite_0_y                      ; 0A8A
        sta     sprite_1_y                      ; 0A8D
L0A90:  rts                                     ; 0A90

; ----------------------------------------------------------------------------
        ldy     #$02                            ; 0A91
L0A93:  lda     L0AB4,y                         ; 0A93
        sta     LE3F8,y                         ; 0A96
        lda     L0AB7,y                         ; 0A99
        sta     sprite_0_color,y                ; 0A9C
        dey                                     ; 0A9F
L0AA0:  bpl     L0A93                           ; 0AA0
        ldy     #$05                            ; 0AA2
L0AA4:  lda     L0AAE,y                         ; 0AA4
        sta     sprite_0_x,y                    ; 0AA7
        dey                                     ; 0AAA
        bpl     L0AA4                           ; 0AAB
        rts                                     ; 0AAD

; ----------------------------------------------------------------------------
L0AAE:  .byte   $32                             ; 0AAE
        .byte   $62                             ; 0AAF
        .byte   $32                             ; 0AB0
        .byte   $6B                             ; 0AB1
        .byte   $32                             ; 0AB2
        pla                                     ; 0AB3
L0AB4:  sei                                     ; 0AB4
        .byte   $79                             ; 0AB5
        .byte   $7A                             ; 0AB6
L0AB7:  .byte   $0B                             ; 0AB7
        .byte   $0C                             ; 0AB8
        .byte   $0F                             ; 0AB9
        lda     #$7D                            ; 0ABA
        sta     sprite_0_y                      ; 0ABC
        lda     #$7B                            ; 0ABF
        sta     LE3F8                           ; 0AC1
        lda     #$0F                            ; 0AC4
        sta     sprite_0_color                  ; 0AC6
        rts                                     ; 0AC9

; ----------------------------------------------------------------------------
        lda     #$80                            ; 0ACA
        sta     sprite_2_y                      ; 0ACC
        lda     #$7C                            ; 0ACF
        sta     LE3FA                           ; 0AD1
        lda     #$0C                            ; 0AD4
        sta     sprite_2_color                  ; 0AD6
        rts                                     ; 0AD9

; ----------------------------------------------------------------------------
L0ADA:  jsr     L0BA9                           ; 0ADA
        ldy     $47                             ; 0ADD
        lda     $1C                             ; 0ADF
        cmp     #$0E                            ; 0AE1
        beq     L0AF2                           ; 0AE3
        cmp     #$04                            ; 0AE5
        beq     L0AF2                           ; 0AE7
        lda     L0B89,y                         ; 0AE9
        beq     L0AFB                           ; 0AEC
        lda     $1C                             ; 0AEE
        beq     L0AFB                           ; 0AF0
L0AF2:  ldx     #$02                            ; 0AF2
        jsr     LEC06                           ; 0AF4
        lda     #$00                            ; 0AF7
        sta     $1C                             ; 0AF9
L0AFB:  lda     $52                             ; 0AFB
        eor     $46                             ; 0AFD
        and     #$80                            ; 0AFF
        cmp     L0BA8                           ; 0B01
        sta     L0BA8                           ; 0B04
        beq     L0B16                           ; 0B07
        and     #$80                            ; 0B09
        .byte   $D0                             ; 0B0B
L0B0C:  asl     $20                             ; 0B0C
        .byte   $53                             ; 0B0E
        .byte   $0B                             ; 0B0F
        jmp     L0B16                           ; 0B10

; ----------------------------------------------------------------------------
L0B13:  jsr     L0B1A                           ; 0B13
L0B16:  jmp     LEC03                           ; 0B16

; ----------------------------------------------------------------------------
        rts                                     ; 0B19

; ----------------------------------------------------------------------------
L0B1A:  ldx     #$00                            ; 0B1A
L0B1C:  lda     L0B35,x                         ; 0B1C
        cmp     $51                             ; 0B1F
        lda     L0B36,x                         ; 0B21
        sbc     $52                             ; 0B24
        bcs     L0B2C                           ; 0B26
        inx                                     ; 0B28
        inx                                     ; 0B29
        bne     L0B1C                           ; 0B2A
L0B2C:  txa                                     ; 0B2C
        lsr     a                               ; 0B2D
        tax                                     ; 0B2E
        lda     L0B49,x                         ; 0B2F
        sta     $1C                             ; 0B32
        rts                                     ; 0B34

; ----------------------------------------------------------------------------
L0B35:  .byte   $90                             ; 0B35
L0B36:  ora     ($E8,x)                         ; 0B36
        .byte   $03                             ; 0B38
        sei                                     ; 0B39
        ora     buffer_zp40                     ; 0B3A
        asl     io_port_register                ; 0B3C
        .byte   $80                             ; 0B3E
        cpy     #$F9                            ; 0B3F
        dey                                     ; 0B41
        .byte   $FA                             ; 0B42
        clc                                     ; 0B43
        .byte   $FC                             ; 0B44
L0B45:  bvs     L0B45                           ; 0B45
        .byte   $FF                             ; 0B47
        .byte   $FF                             ; 0B48
L0B49:  brk                                     ; 0B49
        asl     $07                             ; 0B4A
        php                                     ; 0B4C
        ora     #$09                            ; 0B4D
        php                                     ; 0B4F
        .byte   $07                             ; 0B50
        asl     io_port_register                ; 0B51
L0B53:  ldx     #$00                            ; 0B53
L0B55:  lda     L0B6E,x                         ; 0B55
        cmp     $45                             ; 0B58
        lda     L0B6F,x                         ; 0B5A
        sbc     $46                             ; 0B5D
        bcs     L0B65                           ; 0B5F
        inx                                     ; 0B61
        inx                                     ; 0B62
        bne     L0B55                           ; 0B63
L0B65:  txa                                     ; 0B65
        lsr     a                               ; 0B66
        tax                                     ; 0B67
        lda     L0B80,x                         ; 0B68
        sta     $1C                             ; 0B6B
        rts                                     ; 0B6D

; ----------------------------------------------------------------------------
L0B6E:  nop                                     ; 0B6E
L0B6F:  ror     L7F1C,x                         ; 0B6F
        lsr     L8A7F                           ; 0B72
        .byte   $7F                             ; 0B75
        ldx     #$80                            ; 0B76
        dec     L1080,x                         ; 0B78
        sta     ($42,x)                         ; 0B7B
        sta     ($FF,x)                         ; 0B7D
        .byte   $FF                             ; 0B7F
L0B80:  ora     L0B0C                           ; 0B80
        asl     a                               ; 0B83
        brk                                     ; 0B84
        asl     a                               ; 0B85
        .byte   $0B                             ; 0B86
        .byte   $0C                             ; 0B87
        .byte   $0D                             ; 0B88
L0B89:  brk                                     ; 0B89
        ora     (io_port_register,x)            ; 0B8A
        ora     (io_port_register,x)            ; 0B8C
        brk                                     ; 0B8E
        ora     (io_port_register,x)            ; 0B8F
        ora     (io_port_register,x)            ; 0B91
        ora     (io_port_register,x)            ; 0B93
        brk                                     ; 0B95
        brk                                     ; 0B96
        brk                                     ; 0B97
        brk                                     ; 0B98
        brk                                     ; 0B99
        brk                                     ; 0B9A
        brk                                     ; 0B9B
        brk                                     ; 0B9C
        brk                                     ; 0B9D
        brk                                     ; 0B9E
        brk                                     ; 0B9F
        brk                                     ; 0BA0
        brk                                     ; 0BA1
        brk                                     ; 0BA2
        brk                                     ; 0BA3
        brk                                     ; 0BA4
        brk                                     ; 0BA5
        brk                                     ; 0BA6
L0BA7:  brk                                     ; 0BA7
L0BA8:  brk                                     ; 0BA8
L0BA9:  lda     LF0AB                           ; 0BA9
        beq     L0BC9                           ; 0BAC
        lda     game_state_function_table_index ; 0BAE
        cmp     #$05                            ; 0BB0
        beq     L0BCA                           ; 0BB2
        ldx     #$00                            ; 0BB4
        lda     #$0F                            ; 0BB6
        jsr     LEC06                           ; 0BB8
        ldx     #$02                            ; 0BBB
        lda     #$10                            ; 0BBD
        jsr     LEC06                           ; 0BBF
        ldx     #$01                            ; 0BC2
        lda     #$11                            ; 0BC4
        jsr     LEC06                           ; 0BC6
L0BC9:  rts                                     ; 0BC9

; ----------------------------------------------------------------------------
L0BCA:  jsr     L10D8                           ; 0BCA
        and     #$0F                            ; 0BCD
        pha                                     ; 0BCF
        tax                                     ; 0BD0
        lda     L0BE3,x                         ; 0BD1
        ldx     #$00                            ; 0BD4
        jsr     LEC06                           ; 0BD6
        pla                                     ; 0BD9
        tax                                     ; 0BDA
        lda     L0BF3,x                         ; 0BDB
        ldx     #$01                            ; 0BDE
        jmp     LEC06                           ; 0BE0

; ----------------------------------------------------------------------------
L0BE3:  .byte   $12                             ; 0BE3
        .byte   $12                             ; 0BE4
        .byte   $12                             ; 0BE5
        .byte   $13                             ; 0BE6
        .byte   $13                             ; 0BE7
        .byte   $13                             ; 0BE8
        .byte   $13                             ; 0BE9
        .byte   $14                             ; 0BEA
        .byte   $14                             ; 0BEB
        .byte   $14                             ; 0BEC
        .byte   $14                             ; 0BED
        ora     $15,x                           ; 0BEE
        ora     $16,x                           ; 0BF0
        .byte   $17                             ; 0BF2
L0BF3:  .byte   $13                             ; 0BF3
        .byte   $14                             ; 0BF4
        ora     $15,x                           ; 0BF5
        asl     $17,x                           ; 0BF7
        ora     L1716,y                         ; 0BF9
        clc                                     ; 0BFC
        ora     L1716,y                         ; 0BFD
        ora     L1919,y                         ; 0C00
function_pointer_table:
        .addr   L0C2D                           ; 0C03
        .addr   L0C69                           ; 0C05
        .addr   L0C7F                           ; 0C07
        .addr   L0CBB                           ; 0C09
        .addr   L0CC5                           ; 0C0B
        .addr   L0CEB                           ; 0C0D
        .addr   L0D16                           ; 0C0F
        .addr   L0D4A                           ; 0C11
        .addr   L0D5D                           ; 0C13
        .addr   L0E0B                           ; 0C15
        .addr   prompt_play_again               ; 0C17
        .addr   print_yes_no                    ; 0C19
        .addr   L0E81                           ; 0C1B
        .addr   L0E89                           ; 0C1D
        .addr   L0E91                           ; 0C1F
        .addr   L0E9B                           ; 0C21
        .addr   L0EA3                           ; 0C23
        .addr   L0EAB                           ; 0C25
        .addr   L0EC9                           ; 0C27
        .addr   L0ED8                           ; 0C29
        .addr   L0200                           ; 0C2B
; ----------------------------------------------------------------------------
L0C2D:  lda     $081C                           ; 0C2D
        beq     L0C37                           ; 0C30
        lda     #$01                            ; 0C32
        sta     $081D                           ; 0C34
L0C37:  lda     #$00                            ; 0C37
        ldy     #$07                            ; 0C39
L0C3B:  cpy     $081D                           ; 0C3B
        bcs     L0C42                           ; 0C3E
        lda     #$FF                            ; 0C40
L0C42:  sta     current_player_index,y          ; 0C42
        dey                                     ; 0C45
        bpl     L0C3B                           ; 0C46
        ldy     $081D                           ; 0C48
        jmp     L0C5B                           ; 0C4B

; ----------------------------------------------------------------------------
L0C4E:  jsr     L10D8                           ; 0C4E
        and     #$07                            ; 0C51
        tax                                     ; 0C53
        lda     current_player_index,x          ; 0C54
        bpl     L0C4E                           ; 0C56
        tya                                     ; 0C58
        sta     current_player_index,x          ; 0C59
L0C5B:  dey                                     ; 0C5B
        bpl     L0C4E                           ; 0C5C
        ldy     $081D                           ; 0C5E
        dey                                     ; 0C61
        sty     $39                             ; 0C62
        lda     #$01                            ; 0C64
        sta     game_state_function_table_index ; 0C66
        rts                                     ; 0C68

; ----------------------------------------------------------------------------
L0C69:  jsr     L10EA                           ; 0C69
        bcs     L0C7D                           ; 0C6C
        lda     #$02                            ; 0C6E
        sta     game_state_function_table_index ; 0C70
        lda     #$10                            ; 0C72
        sta     $3A                             ; 0C74
        jsr     L103B                           ; 0C76
        lda     #$00                            ; 0C79
        sta     $22                             ; 0C7B
L0C7D:  rts                                     ; 0C7D

; ----------------------------------------------------------------------------
        asl     a                               ; 0C7E
L0C7F:  lda     #$03                            ; 0C7F
        sta     $76                             ; 0C81
        ldy     #$04                            ; 0C83
L0C85:  lda     L16A2,y                         ; 0C85
        sta     L169D,y                         ; 0C88
        lda     #$20                            ; 0C8B
        sta     L1709,y                         ; 0C8D
        dey                                     ; 0C90
        bpl     L0C85                           ; 0C91
        lda     #$30                            ; 0C93
        sta     L170D                           ; 0C95
        jsr     init_buffers_zp40_zp56          ; 0C98
        jsr     set_up_sprite_registers         ; 0C9B
        ldy     $39                             ; 0C9E
        lda     current_player_index,y          ; 0CA0
        jsr     switch_player                   ; 0CA3
        jsr     L1676                           ; 0CA6
        jsr     L16E9                           ; 0CA9
        lda     #$01                            ; 0CAC
        sta     LF0AB                           ; 0CAE
        lda     #$03                            ; 0CB1
        sta     game_state_function_table_index ; 0CB3
        lda     #$37                            ; 0CB5
        sta     yscroll                         ; 0CB7
        rts                                     ; 0CBA

; ----------------------------------------------------------------------------
L0CBB:  jsr     L1106                           ; 0CBB
        bcs     L0CC4                           ; 0CBE
        lda     #$04                            ; 0CC0
        sta     game_state_function_table_index ; 0CC2
L0CC4:  rts                                     ; 0CC4

; ----------------------------------------------------------------------------
L0CC5:  jsr     L0CE2                           ; 0CC5
        jsr     swap_buffers_zp40_zp56          ; 0CC8
        jsr     L0CE2                           ; 0CCB
        jsr     swap_buffers_zp40_zp56          ; 0CCE
        lda     #$05                            ; 0CD1
        sta     game_state_function_table_index ; 0CD3
        lda     #$00                            ; 0CD5
        sta     $1C                             ; 0CD7
        lda     #$01                            ; 0CD9
        sta     L0BA7                           ; 0CDB
        sta     L0BA8                           ; 0CDE
        rts                                     ; 0CE1

; ----------------------------------------------------------------------------
L0CE2:  lda     #$E2                            ; 0CE2
        sta     $51                             ; 0CE4
        lda     #$FF                            ; 0CE6
        sta     $52                             ; 0CE8
        rts                                     ; 0CEA

; ----------------------------------------------------------------------------
L0CEB:  jsr     decimal_4_char_decrement        ; 0CEB
        lda     $47                             ; 0CEE
        lda     $76                             ; 0CF0
        beq     L0CF6                           ; 0CF2
        dec     $76                             ; 0CF4
L0CF6:  asl     a                               ; 0CF6
        tax                                     ; 0CF7
        lda     L0D08,x                         ; 0CF8
        sta     L0D05                           ; 0CFB
        lda     L0D09,x                         ; 0CFE
        sta     L0D06                           ; 0D01
        .byte   $20                             ; 0D04
L0D05:  .byte   $FF                             ; 0D05
L0D06:  .byte   $FF                             ; 0D06
        rts                                     ; 0D07

; ----------------------------------------------------------------------------
L0D08:  .byte   $76                             ; 0D08
L0D09:  asl     $E9,x                           ; 0D09
        asl     $AB,x                           ; 0D0B
        .byte   $17                             ; 0D0D
        .byte   $1A                             ; 0D0E
        .byte   $17                             ; 0D0F
        .byte   $04                             ; 0D10
        clc                                     ; 0D11
        adc     LF918,y                         ; 0D12
        .byte   $17                             ; 0D15
L0D16:  jsr     L10EA                           ; 0D16
        bcs     L0D41                           ; 0D19
        lda     $081C                           ; 0D1B
        bne     L0D3D                           ; 0D1E
        lda     #$07                            ; 0D20
        sta     game_state_function_table_index ; 0D22
        ldy     $39                             ; 0D24
        lda     current_player_index,y          ; 0D26
        tay                                     ; 0D29
        lda     L0D42,y                         ; 0D2A
        tay                                     ; 0D2D
        ldx     #$00                            ; 0D2E
L0D30:  lda     L1708,x                         ; 0D30
        sta     $0810,y                         ; 0D33
        iny                                     ; 0D36
        inx                                     ; 0D37
        cpx     #$09                            ; 0D38
        bne     L0D30                           ; 0D3A
        rts                                     ; 0D3C

; ----------------------------------------------------------------------------
L0D3D:  lda     #$09                            ; 0D3D
        sta     game_state_function_table_index ; 0D3F
L0D41:  rts                                     ; 0D41

; ----------------------------------------------------------------------------
L0D42:  brk                                     ; 0D42
        jsr     L6040                           ; 0D43
        .byte   $80                             ; 0D46
        ldy     #$C0                            ; 0D47
        .byte   $E0                             ; 0D49
L0D4A:  dec     $39                             ; 0D4A
        bpl     L0D53                           ; 0D4C
        lda     #$08                            ; 0D4E
        sta     game_state_function_table_index ; 0D50
        rts                                     ; 0D52

; ----------------------------------------------------------------------------
L0D53:  lda     #$01                            ; 0D53
        sta     game_state_function_table_index ; 0D55
        lda     #$00                            ; 0D57
        sta     yscroll                         ; 0D59
        rts                                     ; 0D5C

; ----------------------------------------------------------------------------
L0D5D:  jsr     LEC09                           ; 0D5D
        jsr     L10D8                           ; 0D60
        and     #$07                            ; 0D63
        bne     L0DE4                           ; 0D65
        lda     #$01                            ; 0D67
        sta     $30                             ; 0D69
        jsr     LEC06                           ; 0D6B
        ldy     #$0F                            ; 0D6E
L0D70:  lda     sprite_0_x,y                    ; 0D70
        sta     L0DF4,y                         ; 0D73
        dey                                     ; 0D76
        bpl     L0D70                           ; 0D77
        lda     #$00                            ; 0D79
        sta     L0E0A                           ; 0D7B
        lda     L0E04                           ; 0D7E
        sta     L0E09                           ; 0D81
L0D84:  lda     $30                             ; 0D84
L0D86:  cmp     $30                             ; 0D86
        beq     L0D86                           ; 0D88
        cmp     #$00                            ; 0D8A
        beq     L0DDA                           ; 0D8C
        cmp     L0E09                           ; 0D8E
        bne     L0DB7                           ; 0D91
        lda     L0E0A                           ; 0D93
        asl     a                               ; 0D96
        tay                                     ; 0D97
        lda     LA080,y                         ; 0D98
        sta     $0F                             ; 0D9B
        lda     LA081,y                         ; 0D9D
        sta     $10                             ; 0DA0
        php                                     ; 0DA2
        sei                                     ; 0DA3
        jsr     L14FF                           ; 0DA4
        jsr     L14FF                           ; 0DA7
        plp                                     ; 0DAA
        inc     L0E0A                           ; 0DAB
        ldy     L0E0A                           ; 0DAE
        lda     L0E04,y                         ; 0DB1
        sta     L0E09                           ; 0DB4
L0DB7:  lda     $30                             ; 0DB7
        lsr     a                               ; 0DB9
        and     #$07                            ; 0DBA
        tay                                     ; 0DBC
        lda     L0DEC,y                         ; 0DBD
        ora     #$18                            ; 0DC0
        sta     $19                             ; 0DC2
        ldx     #$0E                            ; 0DC4
L0DC6:  lda     L0DEC,y                         ; 0DC6
        clc                                     ; 0DC9
        adc     L0DF4,x                         ; 0DCA
        sta     sprite_0_x,x                    ; 0DCD
        dex                                     ; 0DD0
        dex                                     ; 0DD1
        bpl     L0DC6                           ; 0DD2
        jsr     LEC03                           ; 0DD4
        jmp     L0D84                           ; 0DD7

; ----------------------------------------------------------------------------
L0DDA:  lda     #$18                            ; 0DDA
        sta     $19                             ; 0DDC
L0DDE:  lda     $30                             ; 0DDE
        cmp     #$80                            ; 0DE0
        bne     L0DDE                           ; 0DE2
L0DE4:  jsr     LEC09                           ; 0DE4
        lda     #$14                            ; 0DE7
        sta     game_state_function_table_index ; 0DE9
        rts                                     ; 0DEB

; ----------------------------------------------------------------------------
L0DEC:  brk                                     ; 0DEC
        .byte   $03                             ; 0DED
        asl     io_port_register+$01            ; 0DEE
        .byte   $04                             ; 0DF0
        .byte   $07                             ; 0DF1
        .byte   $02                             ; 0DF2
        .byte   $05                             ; 0DF3
L0DF4:  brk                                     ; 0DF4
        brk                                     ; 0DF5
        brk                                     ; 0DF6
        brk                                     ; 0DF7
        brk                                     ; 0DF8
        brk                                     ; 0DF9
        brk                                     ; 0DFA
        brk                                     ; 0DFB
        brk                                     ; 0DFC
        brk                                     ; 0DFD
        brk                                     ; 0DFE
        brk                                     ; 0DFF
        brk                                     ; 0E00
        brk                                     ; 0E01
        brk                                     ; 0E02
        brk                                     ; 0E03
L0E04:  .byte   $64                             ; 0E04
        sei                                     ; 0E05
        sty     L0AA0                           ; 0E06
L0E09:  brk                                     ; 0E09
L0E0A:  brk                                     ; 0E0A
L0E0B:  lda     #$10                            ; 0E0B
        sta     $3A                             ; 0E0D
        jsr     L103B                           ; 0E0F
        inc     game_state_function_table_index ; 0E12
        rts                                     ; 0E14

; ----------------------------------------------------------------------------
prompt_play_again:
        ldy     #$00                            ; 0E15
L0E17:  lda     play_again,y                    ; 0E17
        beq     L0E22                           ; 0E1A
        jsr     print_char                      ; 0E1C
        iny                                     ; 0E1F
        bne     L0E17                           ; 0E20
L0E22:  lda     #$00                            ; 0E22
        sta     $3B                             ; 0E24
        inc     game_state_function_table_index ; 0E26
        jsr     load_cursor                     ; 0E28
        rts                                     ; 0E2B

; ----------------------------------------------------------------------------
play_again:
        .byte   "PLAY AGAIN? "                  ; 0E2C
                                                ; 0E34
; ----------------------------------------------------------------------------
        brk                                     ; 0E38
play_again_yes:
        .byte   "YES"                           ; 0E39
play_again_no:
        .byte   "NO "                           ; 0E3C
; ----------------------------------------------------------------------------
print_yes_no:
        jsr     store_cursor                    ; 0E3F
        ldy     $3B                             ; 0E42
        ldx     #$03                            ; 0E44
L0E46:  lda     play_again_yes,y                ; 0E46
        jsr     print_char                      ; 0E49
        iny                                     ; 0E4C
        dex                                     ; 0E4D
        bne     L0E46                           ; 0E4E
        lda     $79                             ; 0E50
        jsr     read_joysick_maybe              ; 0E52
        tay                                     ; 0E55
        and     #$10                            ; 0E56
        bne     L0E6D                           ; 0E58
        lda     $3B                             ; 0E5A
        bne     L0E68                           ; 0E5C
        lda     #$01                            ; 0E5E
        sta     game_state_function_table_index ; 0E60
        lda     #$00                            ; 0E62
        sta     yscroll                         ; 0E64
        rts                                     ; 0E67

; ----------------------------------------------------------------------------
L0E68:  lda     #$08                            ; 0E68
        sta     game_state_function_table_index ; 0E6A
        rts                                     ; 0E6C

; ----------------------------------------------------------------------------
L0E6D:  tya                                     ; 0E6D
        and     #$01                            ; 0E6E
        bne     L0E77                           ; 0E70
        lda     #$00                            ; 0E72
        sta     $3B                             ; 0E74
        rts                                     ; 0E76

; ----------------------------------------------------------------------------
L0E77:  tya                                     ; 0E77
        and     #$02                            ; 0E78
        bne     L0E80                           ; 0E7A
        lda     #$03                            ; 0E7C
        sta     $3B                             ; 0E7E
L0E80:  rts                                     ; 0E80

; ----------------------------------------------------------------------------
L0E81:  jsr     L10EA                           ; 0E81
        bcs     L0E88                           ; 0E84
        inc     game_state_function_table_index ; 0E86
L0E88:  rts                                     ; 0E88

; ----------------------------------------------------------------------------
L0E89:  lda     $6C                             ; 0E89
        jsr     print_string_at_index_zp6c      ; 0E8B
        inc     game_state_function_table_index ; 0E8E
        rts                                     ; 0E90

; ----------------------------------------------------------------------------
L0E91:  jsr     L1106                           ; 0E91
        bcs     L0E9A                           ; 0E94
        lda     #$06                            ; 0E96
        sta     game_state_function_table_index ; 0E98
L0E9A:  rts                                     ; 0E9A

; ----------------------------------------------------------------------------
L0E9B:  jsr     L10EA                           ; 0E9B
        bcs     L0EA2                           ; 0E9E
        inc     game_state_function_table_index ; 0EA0
L0EA2:  rts                                     ; 0EA2

; ----------------------------------------------------------------------------
L0EA3:  lda     $6C                             ; 0EA3
        jsr     print_string_at_index_zp6c      ; 0EA5
        inc     game_state_function_table_index ; 0EA8
        rts                                     ; 0EAA

; ----------------------------------------------------------------------------
L0EAB:  jsr     L1106                           ; 0EAB
        bcs     L0EC8                           ; 0EAE
        inc     $22                             ; 0EB0
        lda     $22                             ; 0EB2
        cmp     #$03                            ; 0EB4
        beq     L0EC0                           ; 0EB6
        inc     game_state_function_table_index ; 0EB8
        lda     #$00                            ; 0EBA
        sta     yscroll                         ; 0EBC
        rts                                     ; 0EBF

; ----------------------------------------------------------------------------
L0EC0:  lda     #$00                            ; 0EC0
        sta     $6C                             ; 0EC2
        lda     #$0C                            ; 0EC4
        sta     game_state_function_table_index ; 0EC6
L0EC8:  rts                                     ; 0EC8

; ----------------------------------------------------------------------------
L0EC9:  jsr     L10EA                           ; 0EC9
        bcs     L0ED7                           ; 0ECC
        inc     game_state_function_table_index ; 0ECE
        lda     #$10                            ; 0ED0
        sta     $3A                             ; 0ED2
        jsr     L103B                           ; 0ED4
L0ED7:  rts                                     ; 0ED7

; ----------------------------------------------------------------------------
L0ED8:  lda     L170E                           ; 0ED8
        pha                                     ; 0EDB
        lda     L170F                           ; 0EDC
        pha                                     ; 0EDF
        jsr     init_buffers_zp40_zp56          ; 0EE0
        pla                                     ; 0EE3
        sta     L170F                           ; 0EE4
        pla                                     ; 0EE7
        sta     L170E                           ; 0EE8
        jsr     set_up_sprite_registers         ; 0EEB
        ldy     $39                             ; 0EEE
        lda     current_player_index,y          ; 0EF0
        jsr     switch_player                   ; 0EF3
        jsr     L1676                           ; 0EF6
        jsr     L16E9                           ; 0EF9
        lda     #$03                            ; 0EFC
        sta     game_state_function_table_index ; 0EFE
        lda     #$37                            ; 0F00
        sta     yscroll                         ; 0F02
        rts                                     ; 0F05

; ----------------------------------------------------------------------------
L0F06:  lda     $51                             ; 0F06
        sta     L0F47                           ; 0F08
        ldx     #$03                            ; 0F0B
        .byte   $A5                             ; 0F0D
L0F0E:  .byte   $52                             ; 0F0E
L0F0F:  cmp     #$80                            ; 0F0F
        ror     a                               ; 0F11
        ror     L0F47                           ; 0F12
        dex                                     ; 0F15
        bne     L0F0F                           ; 0F16
        sta     L0F48                           ; 0F18
        lda     $51                             ; 0F1B
        sec                                     ; 0F1D
        sbc     L0F47                           ; 0F1E
        sta     L0F49                           ; 0F21
        lda     $52                             ; 0F24
        sbc     L0F48                           ; 0F26
        sta     L0F4A                           ; 0F29
        lda     L0F4A                           ; 0F2C
        bpl     L0F33                           ; 0F2F
        dec     $46                             ; 0F31
L0F33:  lda     L0F49                           ; 0F33
        clc                                     ; 0F36
        adc     $44                             ; 0F37
        sta     $44                             ; 0F39
        lda     L0F4A                           ; 0F3B
        adc     $45                             ; 0F3E
        sta     $45                             ; 0F40
        bcc     L0F46                           ; 0F42
        inc     $46                             ; 0F44
L0F46:  rts                                     ; 0F46

; ----------------------------------------------------------------------------
L0F47:  brk                                     ; 0F47
L0F48:  brk                                     ; 0F48
L0F49:  brk                                     ; 0F49
L0F4A:  brk                                     ; 0F4A
decrement_pointer_51_by_dec100:
        lda     $52                             ; 0F4B
        bmi     increment_pointer_51_by_dec100  ; 0F4D
        lda     $51                             ; 0F4F
        sec                                     ; 0F51
        sbc     #$64                            ; 0F52
        sta     $51                             ; 0F54
        lda     $52                             ; 0F56
        sbc     #$00                            ; 0F58
        sta     $52                             ; 0F5A
        rts                                     ; 0F5C

; ----------------------------------------------------------------------------
increment_pointer_51_by_dec100:
        lda     $51                             ; 0F5D
        clc                                     ; 0F5F
        adc     #$64                            ; 0F60
        sta     $51                             ; 0F62
        lda     $52                             ; 0F64
        adc     #$00                            ; 0F66
        sta     $52                             ; 0F68
        rts                                     ; 0F6A

; ----------------------------------------------------------------------------
L0F6B:  ldy     $47                             ; 0F6B
        lda     $6D                             ; 0F6D
        beq     L0F81                           ; 0F6F
        lda     $6C                             ; 0F71
        beq     L0F79                           ; 0F73
        lda     $6E                             ; 0F75
        beq     L0F81                           ; 0F77
L0F79:  cpy     #$02                            ; 0F79
        beq     decrement_pointer_51_by_dec100  ; 0F7B
        cpy     #$07                            ; 0F7D
        beq     decrement_pointer_51_by_dec100  ; 0F7F
L0F81:  lda     L0FA6,y                         ; 0F81
        beq     L0FA5                           ; 0F84
        lda     $52                             ; 0F86
        bmi     L0F98                           ; 0F88
        lda     $51                             ; 0F8A
        sec                                     ; 0F8C
        sbc     #$03                            ; 0F8D
        sta     $51                             ; 0F8F
        lda     $52                             ; 0F91
        sbc     #$00                            ; 0F93
        sta     $52                             ; 0F95
        rts                                     ; 0F97

; ----------------------------------------------------------------------------
L0F98:  lda     $51                             ; 0F98
        clc                                     ; 0F9A
        adc     #$03                            ; 0F9B
        sta     $51                             ; 0F9D
        lda     $52                             ; 0F9F
        adc     #$00                            ; 0FA1
        sta     $52                             ; 0FA3
L0FA5:  rts                                     ; 0FA5

; ----------------------------------------------------------------------------
L0FA6:  brk                                     ; 0FA6
        ora     (io_port_register+$01,x)        ; 0FA7
        ora     (io_port_register,x)            ; 0FA9
        brk                                     ; 0FAB
        ora     (io_port_register+$01,x)        ; 0FAC
        ora     (io_port_register,x)            ; 0FAE
        brk                                     ; 0FB0
        brk                                     ; 0FB1
        brk                                     ; 0FB2
        brk                                     ; 0FB3
        brk                                     ; 0FB4
        brk                                     ; 0FB5
        brk                                     ; 0FB6
        brk                                     ; 0FB7
        ora     (io_port_register,x)            ; 0FB8
        brk                                     ; 0FBA
        ora     (io_port_register,x)            ; 0FBB
        brk                                     ; 0FBD
        ora     (io_port_register,x)            ; 0FBE
        brk                                     ; 0FC0
        .byte   $01                             ; 0FC1
L0FC2:  stx     L0FF1                           ; 0FC2
        sta     L0FF2                           ; 0FC5
        ldx     $6E                             ; 0FC8
        lda     $1D                             ; 0FCA
        and     L257E,x                         ; 0FCC
        bne     L0FE7                           ; 0FCF
        lda     L0FF2                           ; 0FD1
        ldx     L0FF1                           ; 0FD4
        cmp     #$00                            ; 0FD7
        bpl     L0FDD                           ; 0FD9
        dec     $52                             ; 0FDB
L0FDD:  clc                                     ; 0FDD
        adc     $51                             ; 0FDE
        sta     $51                             ; 0FE0
        bcc     L0FE6                           ; 0FE2
        inc     $52                             ; 0FE4
L0FE6:  rts                                     ; 0FE6

; ----------------------------------------------------------------------------
L0FE7:  lda     #$00                            ; 0FE7
        sta     $51                             ; 0FE9
        sta     $52                             ; 0FEB
        ldx     L0FF1                           ; 0FED
        rts                                     ; 0FF0

; ----------------------------------------------------------------------------
L0FF1:  brk                                     ; 0FF1
L0FF2:  brk                                     ; 0FF2
L0FF3:  php                                     ; 0FF3
        lda     io_port_register+$01            ; 0FF4
        pha                                     ; 0FF6
        sei                                     ; 0FF7
        and     #$FB                            ; 0FF8
        sta     io_port_register+$01            ; 0FFA
        lda     #$00                            ; 0FFC
        sta     $29                             ; 0FFE
        lda     #$D0                            ; 1000
        sta     $2A                             ; 1002
        lda     #$00                            ; 1004
        sta     $27                             ; 1006
        lda     #$EA                            ; 1008
        sta     $28                             ; 100A
        lda     #$40                            ; 100C
        sta     $3C                             ; 100E
L1010:  ldy     #$00                            ; 1010
        tya                                     ; 1012
L1013:  sta     ($27),y                         ; 1013
        lda     ($29),y                         ; 1015
        iny                                     ; 1017
        cpy     #$08                            ; 1018
        bne     L1013                           ; 101A
        lda     $29                             ; 101C
        clc                                     ; 101E
        adc     #$08                            ; 101F
        sta     $29                             ; 1021
        bcc     L1027                           ; 1023
        inc     $2A                             ; 1025
L1027:  lda     $27                             ; 1027
        clc                                     ; 1029
        adc     #$08                            ; 102A
        sta     $27                             ; 102C
        bcc     L1032                           ; 102E
        inc     $28                             ; 1030
L1032:  dec     $3C                             ; 1032
        bne     L1010                           ; 1034
        pla                                     ; 1036
        sta     io_port_register+$01            ; 1037
        plp                                     ; 1039
        rts                                     ; 103A

; ----------------------------------------------------------------------------
L103B:  lda     #$00                            ; 103B
        sta     cursor_color_maybe              ; 103D
        lda     #$C0                            ; 103F
        sta     cursor_position                 ; 1041
        lda     #$DC                            ; 1043
        sta     cursor_position+$01             ; 1045
        ldy     #$27                            ; 1047
        lda     #$00                            ; 1049
L104B:  sta     LE398,y                         ; 104B
        dey                                     ; 104E
        bpl     L104B                           ; 104F
        rts                                     ; 1051

; ----------------------------------------------------------------------------
print_char:
        sty     L108E                           ; 1052
        asl     a                               ; 1055
        asl     a                               ; 1056
        asl     a                               ; 1057
        sta     $29                             ; 1058
        lda     #$EA                            ; 105A
        adc     #$00                            ; 105C
        sta     $2A                             ; 105E
        php                                     ; 1060
        sei                                     ; 1061
        lda     io_port_register+$01            ; 1062
        pha                                     ; 1064
        lda     #$24                            ; 1065
        sta     io_port_register+$01            ; 1067
        ldy     #$07                            ; 1069
L106B:  lda     ($29),y                         ; 106B
        sta     (cursor_position),y             ; 106D
        dey                                     ; 106F
        bpl     L106B                           ; 1070
        pla                                     ; 1072
        sta     io_port_register+$01            ; 1073
        plp                                     ; 1075
        lda     $3A                             ; 1076
        ldy     cursor_color_maybe              ; 1078
        sta     LE398,y                         ; 107A
        lda     cursor_position                 ; 107D
        clc                                     ; 107F
L1080:  adc     #$08                            ; 1080
        sta     cursor_position                 ; 1082
        bcc     L1088                           ; 1084
        inc     cursor_position+$01             ; 1086
L1088:  inc     cursor_color_maybe              ; 1088
        ldy     L108E                           ; 108A
        rts                                     ; 108D

; ----------------------------------------------------------------------------
L108E:  brk                                     ; 108E
switch_player:
        asl     a                               ; 108F
        asl     a                               ; 1090
        asl     a                               ; 1091
        asl     a                               ; 1092
        asl     a                               ; 1093
        .byte   $8D                             ; 1094
        txs                                     ; 1095
        .byte   $10                             ; 1096
        .byte   $A0                             ; 1097
        brk                                     ; 1098
        .byte   $B9                             ; 1099
        brk                                     ; 109A
        php                                     ; 109B
        .byte   $20                             ; 109C
        .byte   $52                             ; 109D
        .byte   $10                             ; 109E
        iny                                     ; 109F
        .byte   $C0                             ; 10A0
        .byte   $0F                             ; 10A1
        .byte   $D0                             ; 10A2
        .byte   $F5                             ; 10A3
        .byte   $AD                             ; 10A4
        .byte   $7E                             ; 10A5
        php                                     ; 10A6
        .byte   $85                             ; 10A7
        .byte   $2B                             ; 10A8
        .byte   $AD                             ; 10A9
        .byte   $7F                             ; 10AA
        php                                     ; 10AB
        .byte   $85                             ; 10AC
        .byte   $2C                             ; 10AD
        .byte   $AC                             ; 10AE
        txs                                     ; 10AF
        .byte   $10                             ; 10B0
        .byte   $B9                             ; 10B1
        .byte   $0F                             ; 10B2
        php                                     ; 10B3
        tax                                     ; 10B4
        dex                                     ; 10B5
        .byte   $30                             ; 10B6
        .byte   $07                             ; 10B7
        .byte   $20                             ; 10B8
        .byte   $CB                             ; 10B9
        .byte   $10                             ; 10BA
        .byte   $D0                             ; 10BB
        .byte   $FB                             ; 10BC
        .byte   $F0                             ; 10BD
        .byte   $F6                             ; 10BE
        .byte   $20                             ; 10BF
        .byte   $CB                             ; 10C0
        .byte   $10                             ; 10C1
        .byte   $F0                             ; 10C2
        .byte   $06                             ; 10C3
        .byte   $20                             ; 10C4
        .byte   $52                             ; 10C5
        .byte   $10                             ; 10C6
        .byte   $4C                             ; 10C7
        .byte   $BF                             ; 10C8
        .byte   $10                             ; 10C9
        rts                                     ; 10CA

; ----------------------------------------------------------------------------
        ldy     #$00                            ; 10CB
        lda     ($2B),y                         ; 10CD
        inc     $2B                             ; 10CF
        bne     L10D5                           ; 10D1
        inc     $2C                             ; 10D3
L10D5:  cmp     #$00                            ; 10D5
        rts                                     ; 10D7

; ----------------------------------------------------------------------------
L10D8:  lda     $08FE                           ; 10D8
        lsr     a                               ; 10DB
        lsr     a                               ; 10DC
        sbc     $08FE                           ; 10DD
        lsr     a                               ; 10E0
        ror     $08FE                           ; 10E1
        lda     $08FE                           ; 10E4
        eor     $30                             ; 10E7
        rts                                     ; 10E9

; ----------------------------------------------------------------------------
L10EA:  lda     $79                             ; 10EA
        and     #$1F                            ; 10EC
        cmp     #$1F                            ; 10EE
        beq     L10F9                           ; 10F0
        lda     #$04                            ; 10F2
        sta     L1105                           ; 10F4
L10F7:  sec                                     ; 10F7
        rts                                     ; 10F8

; ----------------------------------------------------------------------------
L10F9:  dec     L1105                           ; 10F9
        bne     L10F7                           ; 10FC
        lda     #$04                            ; 10FE
        sta     L1105                           ; 1100
        clc                                     ; 1103
        rts                                     ; 1104

; ----------------------------------------------------------------------------
L1105:  .byte   $04                             ; 1105
L1106:  lda     $79                             ; 1106
        and     #$10                            ; 1108
        beq     L1113                           ; 110A
        lda     #$04                            ; 110C
        sta     L111F                           ; 110E
L1111:  sec                                     ; 1111
        rts                                     ; 1112

; ----------------------------------------------------------------------------
L1113:  dec     L111F                           ; 1113
        bne     L1111                           ; 1116
        lda     #$04                            ; 1118
        sta     L111F                           ; 111A
        clc                                     ; 111D
        rts                                     ; 111E

; ----------------------------------------------------------------------------
L111F:  asl     a                               ; 111F
load_cursor:
        lda     cursor_position                 ; 1120
        sta     L1140                           ; 1122
        lda     cursor_position+$01             ; 1125
        sta     L1141                           ; 1127
        lda     cursor_color_maybe              ; 112A
        sta     L1142                           ; 112C
        rts                                     ; 112F

; ----------------------------------------------------------------------------
store_cursor:
        lda     L1140                           ; 1130
        sta     cursor_position                 ; 1133
        lda     L1141                           ; 1135
        sta     cursor_position+$01             ; 1138
        lda     L1142                           ; 113A
        sta     cursor_color_maybe              ; 113D
        rts                                     ; 113F

; ----------------------------------------------------------------------------
L1140:  brk                                     ; 1140
L1141:  brk                                     ; 1141
L1142:  brk                                     ; 1142
L1143:  lda     LDD02                           ; 1143
        ora     #$03                            ; 1146
        sta     LDD02                           ; 1148
        lda     LDD00                           ; 114B
        and     #$FC                            ; 114E
        sta     LDD00                           ; 1150
        lda     #$80                            ; 1153
        and     #$F0                            ; 1155
        sta     screen_and_charset              ; 1157
        lda     #$18                            ; 115A
        sta     xscroll                         ; 115C
        lda     LE7E8                           ; 115F
        sta     background_color_0              ; 1162
        php                                     ; 1165
        sei                                     ; 1166
        lda     io_port_register+$01            ; 1167
        pha                                     ; 1169
        lda     #$25                            ; 116A
        sta     io_port_register+$01            ; 116C
        ldy     #$00                            ; 116E
L1170:  lda     LE400,y                         ; 1170
        sta     color_ram,y                     ; 1173
        lda     LE500,y                         ; 1176
        sta     color_ram+$100,y                ; 1179
        lda     LE600,y                         ; 117C
        sta     color_ram+$200,y                ; 117F
        lda     LE700,y                         ; 1182
        sta     color_ram+$300,y                ; 1185
        dey                                     ; 1188
        bne     L1170                           ; 1189
        pla                                     ; 118B
        sta     io_port_register+$01            ; 118C
        plp                                     ; 118E
        rts                                     ; 118F

; ----------------------------------------------------------------------------
L1190:  cld                                     ; 1190
        sei                                     ; 1191
L1192:  lda     LD012                           ; 1192
L1195:  cmp     LD012                           ; 1195
        beq     L1195                           ; 1198
        bmi     L1192                           ; 119A
        lda     #$7F                            ; 119C
        sta     LDC0D                           ; 119E
        lda     LDC0D                           ; 11A1
        lda     #$25                            ; 11A4
        sta     io_port_register+$01            ; 11A6
        lda     #$BD                            ; 11A8
        sta     hairq                           ; 11AA
        lda     #$11                            ; 11AD
        sta     $FFFF                           ; 11AF
        lda     #$64                            ; 11B2
        sta     LD012                           ; 11B4
        lda     #$01                            ; 11B7
        sta     LD01A                           ; 11B9
        rts                                     ; 11BC

; ----------------------------------------------------------------------------
        cld                                     ; 11BD
        pha                                     ; 11BE
        tya                                     ; 11BF
        pha                                     ; 11C0
        txa                                     ; 11C1
        pha                                     ; 11C2
        lda     LD019                           ; 11C3
        sta     LD019                           ; 11C6
        ldx     L11F0                           ; 11C9
        txa                                     ; 11CC
        asl     a                               ; 11CD
        tay                                     ; 11CE
        lda     L0A3D,y                         ; 11CF
        sta     L11E9                           ; 11D2
        lda     L0A3C,y                         ; 11D5
        sta     L11E8                           ; 11D8
        ldy     L0A4E,x                         ; 11DB
        lda     L0A48,y                         ; 11DE
        sta     LD012                           ; 11E1
        sty     L11F0                           ; 11E4
        .byte   $20                             ; 11E7
L11E8:  .byte   $FF                             ; 11E8
L11E9:  .byte   $FF                             ; 11E9
        pla                                     ; 11EA
        tax                                     ; 11EB
        pla                                     ; 11EC
        tay                                     ; 11ED
        pla                                     ; 11EE
        rti                                     ; 11EF

; ----------------------------------------------------------------------------
L11F0:  .byte   $00                             ; 11F0
L11F1:  .byte   $9A,$9A,$9A,$9A,$9A,$9A,$9A,$9A ; 11F1
        .byte   $9A,$9A,$9A,$9A,$9A,$99,$99,$99 ; 11F9
        .byte   $99,$99,$98,$98,$98,$98,$98,$97 ; 1201
        .byte   $97,$97,$96,$96,$96,$95,$95,$95 ; 1209
        .byte   $94,$94,$94,$93,$93,$92,$92,$92 ; 1211
        .byte   $91,$91,$90,$90,$8F,$8F,$8E,$8E ; 1219
        .byte   $8D,$8D,$8C,$8C,$8B,$8B,$8A,$89 ; 1221
        .byte   $89,$88,$88,$87,$86,$86,$85,$85 ; 1229
        .byte   $84,$83,$83,$82,$81,$80,$80,$7F ; 1231
        .byte   $7E,$7E,$7D,$7C,$7B,$7B,$7A,$79 ; 1239
        .byte   $78,$78,$77,$76,$75,$74,$74,$73 ; 1241
        .byte   $72,$71,$70,$70,$6F,$6E,$6D,$6C ; 1249
        .byte   $6B,$6A,$6A,$69,$68,$67,$66,$65 ; 1251
        .byte   $64,$64,$63,$62,$61,$60,$5F,$5E ; 1259
        .byte   $5D,$5C,$5B,$5B,$5A,$59,$58,$57 ; 1261
        .byte   $56,$55,$54,$53,$52,$51,$50,$50 ; 1269
L1271:  .byte   $05,$06,$07,$08,$09,$0A,$0B,$0C ; 1271
        .byte   $0D,$0E,$0F,$10,$10,$11,$12,$13 ; 1279
        .byte   $14,$15,$16,$17,$18,$19,$19,$1A ; 1281
        .byte   $1B,$1C,$1D,$1E,$1F,$1F,$20,$21 ; 1289
        .byte   $22,$23,$24,$25,$25,$26,$27,$28 ; 1291
        .byte   $29,$29,$2A,$2B,$2C,$2D,$2D,$2E ; 1299
        .byte   $2F,$30,$30,$31,$32,$33,$33,$34 ; 12A1
        .byte   $35,$35,$36,$37,$38,$38,$39,$3A ; 12A9
        .byte   $3A,$3B,$3B,$3C,$3D,$3D,$3E,$3E ; 12B1
        .byte   $3F,$40,$40,$41,$41,$42,$42,$43 ; 12B9
        .byte   $43,$44,$44,$45,$45,$46,$46,$47 ; 12C1
        .byte   $47,$47,$48,$48,$49,$49,$49,$4A ; 12C9
        .byte   $4A,$4A,$4B,$4B,$4B,$4C,$4C,$4C ; 12D1
        .byte   $4D,$4D,$4D,$4D,$4D,$4E,$4E,$4E ; 12D9
        .byte   $4E,$4E,$4F,$4F,$4F,$4F,$4F,$4F ; 12E1
        .byte   $4F,$4F,$4F,$4F,$4F,$4F,$4F,$50 ; 12E9
        .byte   $00                             ; 12F1
L12F2:  .byte   $00                             ; 12F2
L12F3:  .byte   $00                             ; 12F3
L12F4:  .byte   $00                             ; 12F4
L12F5:  .byte   $00                             ; 12F5
L12F6:  .byte   $00                             ; 12F6
L12F7:  .byte   $00                             ; 12F7
L12F8:  .byte   $00                             ; 12F8
L12F9:  .byte   $06                             ; 12F9
L12FA:  .byte   $00                             ; 12FA
L12FB:  .byte   $00                             ; 12FB
L12FC:  .byte   $00,$C0,$80,$40,$00,$C0,$80,$40 ; 12FC
        .byte   $00                             ; 1304
L1305:  .byte   $EA,$E9,$E9,$E9,$E9,$E8,$E8,$E8 ; 1305
        .byte   $E8                             ; 130D
L130E:  .byte   $00,$80,$C0,$E0,$F0,$F8,$FC,$FE ; 130E
        .byte   $FF                             ; 1316
L1317:  .byte   $00,$01,$02,$03,$06,$05,$06,$07 ; 1317
        .byte   $08,$09,$0A,$0B,$0C,$0D         ; 131F
; ----------------------------------------------------------------------------
        .byte   $0E                             ; 1325
        .byte   $0F                             ; 1326
L1327:  lda     $6E                             ; 1327
        bne     *+5                             ; 1329
        jmp     L1387                           ; 132B

; ----------------------------------------------------------------------------
        ldx     $43                             ; 132E
        cpx     #$B3                            ; 1330
        bcc     L1335                           ; 1332
        rts                                     ; 1334

; ----------------------------------------------------------------------------
L1335:  lda     L3000,x                         ; 1335
        clc                                     ; 1338
        adc     #$00                            ; 1339
        sta     $3E                             ; 133B
        lda     L30B4,x                         ; 133D
        adc     #$30                            ; 1340
        sta     $3F                             ; 1342
        lda     L3168,x                         ; 1344
        bpl     L134B                           ; 1347
        dec     $41                             ; 1349
L134B:  adc     buffer_zp40                     ; 134B
        sta     buffer_zp40                     ; 134D
        bcc     L1353                           ; 134F
        inc     $41                             ; 1351
L1353:  lda     $42                             ; 1353
        clc                                     ; 1355
        adc     L321C,x                         ; 1356
        sta     $42                             ; 1359
        ldy     #$00                            ; 135B
        sty     L12F3                           ; 135D
        lda     ($3E),y                         ; 1360
        sta     L12F6                           ; 1362
        clc                                     ; 1365
        adc     L12F5                           ; 1366
        sta     L12F7                           ; 1369
        tay                                     ; 136C
        lda     L12FC,y                         ; 136D
        sta     L143D                           ; 1370
        lda     L1305,y                         ; 1373
        sta     L143E                           ; 1376
        inc     $3E                             ; 1379
        bne     L137F                           ; 137B
        inc     $3F                             ; 137D
L137F:  lda     L12F5                           ; 137F
        sta     $23                             ; 1382
        jmp     L140E                           ; 1384

; ----------------------------------------------------------------------------
L1387:  ldx     $43                             ; 1387
        lda     L8B00,x                         ; 1389
        clc                                     ; 138C
        adc     #$00                            ; 138D
        sta     $3E                             ; 138F
        lda     L8BB4,x                         ; 1391
        adc     #$8B                            ; 1394
        sta     $3F                             ; 1396
        lda     L8C68,x                         ; 1398
        bpl     L139F                           ; 139B
        dec     $41                             ; 139D
L139F:  adc     buffer_zp40                     ; 139F
        sta     buffer_zp40                     ; 13A1
        bcc     L13A7                           ; 13A3
        inc     $41                             ; 13A5
L13A7:  lda     $42                             ; 13A7
        clc                                     ; 13A9
        adc     L8D1C,x                         ; 13AA
        sta     $42                             ; 13AD
        ldy     #$00                            ; 13AF
        sty     L12F3                           ; 13B1
        sty     L12FA                           ; 13B4
        sty     L12F8                           ; 13B7
        lda     ($3E),y                         ; 13BA
        sta     L12F5                           ; 13BC
        sta     L12F6                           ; 13BF
        sta     L12F7                           ; 13C2
        tay                                     ; 13C5
        lda     L12FC,y                         ; 13C6
        sta     L143D                           ; 13C9
        lda     L1305,y                         ; 13CC
        sta     L143E                           ; 13CF
        inc     $3E                             ; 13D2
        bne     L13D8                           ; 13D4
        inc     $3F                             ; 13D6
L13D8:  ldy     L12F9                           ; 13D8
        lda     L130E,y                         ; 13DB
        ora     LD01C                           ; 13DE
        sta     LD01C                           ; 13E1
        lda     L130E,y                         ; 13E4
        eor     #$FF                            ; 13E7
        and     LD01D                           ; 13E9
        sta     LD01D                           ; 13EC
        lda     L130E,y                         ; 13EF
        ora     LD010                           ; 13F2
        sta     LD010                           ; 13F5
        ldx     #$0E                            ; 13F8
        lda     #$80                            ; 13FA
L13FC:  sta     sprite_0_x,x                    ; 13FC
        dex                                     ; 13FF
        dex                                     ; 1400
        dey                                     ; 1401
        bne     L13FC                           ; 1402
        lda     #$00                            ; 1404
        sta     $23                             ; 1406
        lda     L12F6                           ; 1408
        bne     L140E                           ; 140B
        rts                                     ; 140D

; ----------------------------------------------------------------------------
L140E:  lda     L12F6                           ; 140E
        bne     L1416                           ; 1411
        jmp     L14A8                           ; 1413

; ----------------------------------------------------------------------------
L1416:  lda     $3E                             ; 1416
        sta     L1439                           ; 1418
        lda     $3F                             ; 141B
        sta     L143A                           ; 141D
        ldy     #$00                            ; 1420
        lda     ($3E),y                         ; 1422
        tax                                     ; 1424
        eor     #$3F                            ; 1425
        tay                                     ; 1427
        clc                                     ; 1428
        adc     L143D                           ; 1429
        sta     L1447                           ; 142C
        lda     L143E                           ; 142F
        sta     L1448                           ; 1432
        sty     L12F4                           ; 1435
L1438:  .byte   $B9                             ; 1438
L1439:  .byte   $FF                             ; 1439
L143A:  .byte   $FF                             ; 143A
        dey                                     ; 143B
        .byte   $99                             ; 143C
L143D:  .byte   $FF                             ; 143D
L143E:  .byte   $FF                             ; 143E
        bne     L1438                           ; 143F
        txa                                     ; 1441
        beq     L144B                           ; 1442
        tya                                     ; 1444
L1445:  dex                                     ; 1445
        .byte   $9D                             ; 1446
L1447:  .byte   $FF                             ; 1447
L1448:  .byte   $FF                             ; 1448
        bne     L1445                           ; 1449
L144B:  lda     $3E                             ; 144B
        sec                                     ; 144D
        adc     L12F4                           ; 144E
        sta     $3E                             ; 1451
        bcc     L1457                           ; 1453
        inc     $3F                             ; 1455
L1457:  ldy     #$00                            ; 1457
        lda     #$08                            ; 1459
        sec                                     ; 145B
        sbc     L12F7                           ; 145C
        clc                                     ; 145F
        adc     L12F3                           ; 1460
        tax                                     ; 1463
        lda     ($3E),y                         ; 1464
        sty     L12FB                           ; 1466
        pha                                     ; 1469
        and     #$0F                            ; 146A
        tay                                     ; 146C
        lda     L1317,y                         ; 146D
        sta     sprite_0_color,x                ; 1470
        ldy     L12FB                           ; 1473
        pla                                     ; 1476
        bmi     L1482                           ; 1477
        lda     L14F7,x                         ; 1479
        and     LD01C                           ; 147C
        sta     LD01C                           ; 147F
L1482:  asl     a                               ; 1482
        ror     L12F2                           ; 1483
        inc     $3E                             ; 1486
        bne     L148C                           ; 1488
        inc     $3F                             ; 148A
L148C:  lda     L143D                           ; 148C
        clc                                     ; 148F
        adc     #$40                            ; 1490
        sta     L143D                           ; 1492
        bcc     L149A                           ; 1495
        inc     L143E                           ; 1497
L149A:  inc     L12F3                           ; 149A
        lda     L12F3                           ; 149D
        cmp     L12F6                           ; 14A0
        beq     L14A8                           ; 14A3
        jmp     L140E                           ; 14A5

; ----------------------------------------------------------------------------
L14A8:  lda     L12F6                           ; 14A8
        beq     L14E6                           ; 14AB
        asl     a                               ; 14AD
        tay                                     ; 14AE
        dey                                     ; 14AF
        lda     #$0F                            ; 14B0
        sec                                     ; 14B2
        sbc     $23                             ; 14B3
        sbc     $23                             ; 14B5
        tax                                     ; 14B7
L14B8:  lda     ($3E),y                         ; 14B8
        clc                                     ; 14BA
        adc     $42                             ; 14BB
        sta     sprite_0_x,x                    ; 14BD
        cmp     L12FA                           ; 14C0
        bcc     L14C8                           ; 14C3
        sta     L12FA                           ; 14C5
L14C8:  dey                                     ; 14C8
        dex                                     ; 14C9
        lda     ($3E),y                         ; 14CA
        clc                                     ; 14CC
        adc     buffer_zp40                     ; 14CD
        .byte   $9D                             ; 14CF
        brk                                     ; 14D0
L14D1:  bne     *-89                            ; 14D1
        eor     ($69,x)                         ; 14D3
        brk                                     ; 14D5
        lsr     a                               ; 14D6
        bcs     L14E2                           ; 14D7
        lda     L14E7,x                         ; 14D9
        and     LD010                           ; 14DC
        sta     LD010                           ; 14DF
L14E2:  dex                                     ; 14E2
        dey                                     ; 14E3
        bpl     L14B8                           ; 14E4
L14E6:  rts                                     ; 14E6

; ----------------------------------------------------------------------------
L14E7:  inc     LFD01,x                         ; 14E7
        .byte   $02                             ; 14EA
        .byte   $FB                             ; 14EB
        .byte   $04                             ; 14EC
        .byte   $F7                             ; 14ED
        php                                     ; 14EE
        .byte   $EF                             ; 14EF
        bpl     L14D1                           ; 14F0
        jsr     L40BF                           ; 14F2
        .byte   $7F                             ; 14F5
        .byte   $80                             ; 14F6
L14F7:  inc     LFBFD,x                         ; 14F7
        .byte   $F7                             ; 14FA
        .byte   $EF                             ; 14FB
        .byte   $DF                             ; 14FC
        .byte   $BF                             ; 14FD
        .byte   $7F                             ; 14FE
L14FF:  jsr     L15D7                           ; 14FF
        lda     $11                             ; 1502
        sta     L1525                           ; 1504
L1507:  ldx     $13                             ; 1507
        stx     L1526                           ; 1509
        jsr     L1527                           ; 150C
L150F:  ldy     #$09                            ; 150F
        jsr     L159D                           ; 1511
        dec     L1526                           ; 1514
        bne     L150F                           ; 1517
        lda     L1525                           ; 1519
        sta     $11                             ; 151C
        inc     $12                             ; 151E
        dec     $14                             ; 1520
        bne     L1507                           ; 1522
        rts                                     ; 1524

; ----------------------------------------------------------------------------
L1525:  brk                                     ; 1525
L1526:  brk                                     ; 1526
L1527:  ldy     $12                             ; 1527
        lda     L1574,y                         ; 1529
        sta     L15A2                           ; 152C
        sta     L15A8                           ; 152F
        clc                                     ; 1532
        adc     $11                             ; 1533
        sta     L15B2                           ; 1535
L1538:  lda     L155B,y                         ; 1538
        ora     #$E0                            ; 153B
        sta     L15A9                           ; 153D
        eor     #$38                            ; 1540
        sta     L15A3                           ; 1542
        and     #$03                            ; 1545
        adc     #$00                            ; 1547
        asl     L15B2                           ; 1549
        rol     a                               ; 154C
        asl     L15B2                           ; 154D
        rol     a                               ; 1550
        asl     L15B2                           ; 1551
        rol     a                               ; 1554
        ora     #$C0                            ; 1555
        sta     L15B3                           ; 1557
        rts                                     ; 155A

; ----------------------------------------------------------------------------
L155B:  brk                                     ; 155B
        brk                                     ; 155C
        brk                                     ; 155D
        brk                                     ; 155E
        brk                                     ; 155F
        brk                                     ; 1560
        brk                                     ; 1561
        ora     (io_port_register+$01,x)        ; 1562
        ora     (io_port_register+$01,x)        ; 1564
        ora     (io_port_register+$01,x)        ; 1566
        .byte   $02                             ; 1568
        .byte   $02                             ; 1569
        .byte   $02                             ; 156A
        .byte   $02                             ; 156B
        .byte   $02                             ; 156C
        .byte   $02                             ; 156D
        .byte   $02                             ; 156E
        .byte   $03                             ; 156F
        .byte   $03                             ; 1570
        .byte   $03                             ; 1571
        .byte   $03                             ; 1572
        .byte   $03                             ; 1573
L1574:  brk                                     ; 1574
        plp                                     ; 1575
        bvc     L15F0                           ; 1576
        ldy     #$C8                            ; 1578
        beq     L1594                           ; 157A
        rti                                     ; 157C

; ----------------------------------------------------------------------------
        pla                                     ; 157D
        bcc     L1538                           ; 157E
L1580:  cpx     #$08                            ; 1580
        bmi     L15DC                           ; 1582
        .byte   $80                             ; 1584
        tay                                     ; 1585
        bne     L1580                           ; 1586
        jsr     L7048                           ; 1588
        tya                                     ; 158B
        cpy     #$01                            ; 158C
        ora     (io_port_register+$01,x)        ; 158E
        ora     ($02,x)                         ; 1590
        .byte   $02                             ; 1592
        .byte   $02                             ; 1593
L1594:  .byte   $02                             ; 1594
        .byte   $02                             ; 1595
        .byte   $02                             ; 1596
        .byte   $02                             ; 1597
        .byte   $03                             ; 1598
        .byte   $03                             ; 1599
        .byte   $03                             ; 159A
        .byte   $03                             ; 159B
        .byte   $03                             ; 159C
L159D:  ldx     $11                             ; 159D
        lda     ($0F),y                         ; 159F
        .byte   $9D                             ; 15A1
L15A2:  .byte   $FF                             ; 15A2
L15A3:  .byte   $FF                             ; 15A3
        dey                                     ; 15A4
        lda     ($0F),y                         ; 15A5
        .byte   $9D                             ; 15A7
L15A8:  .byte   $FF                             ; 15A8
L15A9:  .byte   $FF                             ; 15A9
        dey                                     ; 15AA
        lda     #$24                            ; 15AB
        sta     io_port_register+$01            ; 15AD
L15AF:  lda     ($0F),y                         ; 15AF
        .byte   $99                             ; 15B1
L15B2:  .byte   $FF                             ; 15B2
L15B3:  .byte   $FF                             ; 15B3
        dey                                     ; 15B4
        bpl     L15AF                           ; 15B5
        lda     #$25                            ; 15B7
        sta     io_port_register+$01            ; 15B9
        lda     $0F                             ; 15BB
        clc                                     ; 15BD
        adc     #$0A                            ; 15BE
        sta     $0F                             ; 15C0
        bcc     L15C6                           ; 15C2
        inc     $10                             ; 15C4
L15C6:  lda     L15B2                           ; 15C6
        clc                                     ; 15C9
        adc     #$08                            ; 15CA
        sta     L15B2                           ; 15CC
        bcc     L15D4                           ; 15CF
        inc     L15B3                           ; 15D1
L15D4:  inc     $11                             ; 15D4
        rts                                     ; 15D6

; ----------------------------------------------------------------------------
L15D7:  ldy     #$00                            ; 15D7
        lda     ($0F),y                         ; 15D9
        .byte   $85                             ; 15DB
L15DC:  .byte   $13                             ; 15DC
        iny                                     ; 15DD
        lda     ($0F),y                         ; 15DE
        sta     $14                             ; 15E0
        iny                                     ; 15E2
        lda     ($0F),y                         ; 15E3
        sta     $11                             ; 15E5
        iny                                     ; 15E7
        lda     ($0F),y                         ; 15E8
        sta     $12                             ; 15EA
        tya                                     ; 15EC
        sec                                     ; 15ED
        adc     $0F                             ; 15EE
L15F0:  sta     $0F                             ; 15F0
        bcc     L15F6                           ; 15F2
        inc     $10                             ; 15F4
L15F6:  rts                                     ; 15F6

; ----------------------------------------------------------------------------
read_joysick_maybe:
        pha                                     ; 15F7
        lda     #$FF                            ; 15F8
        sta     LDC02                           ; 15FA
        lda     #$00                            ; 15FD
        sta     LDC03                           ; 15FF
        lda     #$F7                            ; 1602
        sta     LDC00                           ; 1604
        lda     LDC01                           ; 1607
        and     #$02                            ; 160A
        cmp     #$02                            ; 160C
        beq     L1618                           ; 160E
        lda     #$00                            ; 1610
        sta     $3B                             ; 1612
        pla                                     ; 1614
        and     #$EF                            ; 1615
        rts                                     ; 1617

; ----------------------------------------------------------------------------
L1618:  lda     #$EF                            ; 1618
        sta     LDC00                           ; 161A
        lda     LDC01                           ; 161D
        and     #$80                            ; 1620
        cmp     #$80                            ; 1622
        beq     L162E                           ; 1624
        lda     #$03                            ; 1626
        sta     $3B                             ; 1628
        pla                                     ; 162A
        and     #$EF                            ; 162B
        rts                                     ; 162D

; ----------------------------------------------------------------------------
L162E:  pla                                     ; 162E
        rts                                     ; 162F

; ----------------------------------------------------------------------------
load_sprite:
        lda     $78                             ; 1630
        lsr     a                               ; 1632
        lsr     a                               ; 1633
        and     #$07                            ; 1634
        asl     a                               ; 1636
        tay                                     ; 1637
        lda     $15                             ; 1638
        clc                                     ; 163A
        adc     L1666,y                         ; 163B
        sta     $17                             ; 163E
        lda     $16                             ; 1640
        adc     L1667,y                         ; 1642
        sta     $18                             ; 1645
        ldy     #$3F                            ; 1647
        lda     ($17),y                         ; 1649
        dey                                     ; 164B
        sta     sprite_1_color                  ; 164C
        asl     a                               ; 164F
        rol     a                               ; 1650
        rol     a                               ; 1651
        eor     LD01C                           ; 1652
        and     #$02                            ; 1655
        eor     LD01C                           ; 1657
        sta     LD01C                           ; 165A
L165D:  lda     ($17),y                         ; 165D
        sta     runtime_sprites,y               ; 165F
        dey                                     ; 1662
        bpl     L165D                           ; 1663
        rts                                     ; 1665

; ----------------------------------------------------------------------------
L1666:  brk                                     ; 1666
L1667:  brk                                     ; 1667
        rti                                     ; 1668

; ----------------------------------------------------------------------------
        brk                                     ; 1669
        .byte   $80                             ; 166A
        brk                                     ; 166B
        cpy     #$00                            ; 166C
        brk                                     ; 166E
        ora     (buffer_zp40,x)                 ; 166F
        ora     ($80,x)                         ; 1671
        ora     ($C0,x)                         ; 1673
        .byte   $01                             ; 1675
L1676:  lda     $78                             ; 1676
        beq     L167E                           ; 1678
        and     #$03                            ; 167A
        beq     load_sprite                     ; 167C
L167E:  jsr     load_cursor                     ; 167E
        lda     #$B0                            ; 1681
        sta     cursor_position                 ; 1683
        lda     #$DD                            ; 1685
        sta     cursor_position+$01             ; 1687
        lda     #$1E                            ; 1689
        sta     cursor_color_maybe              ; 168B
        ldy     #$00                            ; 168D
L168F:  lda     L169D,y                         ; 168F
        jsr     print_char                      ; 1692
        iny                                     ; 1695
        cpy     #$04                            ; 1696
        bne     L168F                           ; 1698
        jmp     store_cursor                    ; 169A

; ----------------------------------------------------------------------------
L169D:  and     ($3A),y                         ; 169D
L169F:  .byte   $32                             ; 169F
L16A0:  .byte   $33                             ; 16A0
L16A1:  .byte   $3C                             ; 16A1
L16A2:  and     ($3A),y                         ; 16A2
        and     ($35),y                         ; 16A4
        .byte   $3C                             ; 16A6
decimal_4_char_decrement:
        lda     $6D                             ; 16A7
        bne     L16E3                           ; 16A9
        lda     L169D                           ; 16AB
        ora     L169F                           ; 16AE
        ora     L16A0                           ; 16B1
        cmp     #$30                            ; 16B4
        beq     L16E4                           ; 16B6
        dec     L16A1                           ; 16B8
        bpl     L16E3                           ; 16BB
        lda     #$3B                            ; 16BD
        sta     L16A1                           ; 16BF
        dec     L16A0                           ; 16C2
        lda     L16A0                           ; 16C5
        cmp     #$30                            ; 16C8
        bcs     L16E3                           ; 16CA
        lda     #$39                            ; 16CC
        sta     L16A0                           ; 16CE
        dec     L169F                           ; 16D1
        lda     L169F                           ; 16D4
        cmp     #$30                            ; 16D7
        bcs     L16E3                           ; 16D9
        lda     #$35                            ; 16DB
        sta     L169F                           ; 16DD
        dec     L169D                           ; 16E0
L16E3:  rts                                     ; 16E3

; ----------------------------------------------------------------------------
L16E4:  lda     #$FF                            ; 16E4
        sta     $6D                             ; 16E6
        rts                                     ; 16E8

; ----------------------------------------------------------------------------
L16E9:  jsr     load_cursor                     ; 16E9
        lda     #$D8                            ; 16EC
        sta     cursor_position                 ; 16EE
        lda     #$DD                            ; 16F0
        sta     cursor_position+$01             ; 16F2
        lda     #$23                            ; 16F4
        sta     cursor_color_maybe              ; 16F6
        ldy     #$00                            ; 16F8
L16FA:  lda     L1709,y                         ; 16FA
        jsr     print_char                      ; 16FD
        iny                                     ; 1700
        cpy     #$05                            ; 1701
        bne     L16FA                           ; 1703
        jmp     store_cursor                    ; 1705

; ----------------------------------------------------------------------------
L1708:  .byte   $20                             ; 1708
L1709:  .byte   $20                             ; 1709
        .byte   $20                             ; 170A
L170B:  .byte   $20                             ; 170B
        .byte   $20                             ; 170C
L170D:  .byte   $30                             ; 170D
L170E:  brk                                     ; 170E
L170F:  brk                                     ; 170F
        brk                                     ; 1710
L1711:  lda     $6C                             ; 1711
        bne     L1719                           ; 1713
        .byte   $A9                             ; 1715
L1716:  asl     $85                             ; 1716
        .byte   $76                             ; 1718
L1719:  rts                                     ; 1719

; ----------------------------------------------------------------------------
        lda     #$E7                            ; 171A
        cmp     $54                             ; 171C
        lda     #$03                            ; 171E
        sbc     $55                             ; 1720
        bcs     L172C                           ; 1722
        lda     #$E7                            ; 1724
        sta     $54                             ; 1726
        lda     #$03                            ; 1728
        sta     $55                             ; 172A
L172C:  lda     $54                             ; 172C
        clc                                     ; 172E
        adc     L170E                           ; 172F
        sta     L170E                           ; 1732
        lda     $55                             ; 1735
        adc     L170F                           ; 1737
        sta     L170F                           ; 173A
        lda     #$00                            ; 173D
        sta     $54                             ; 173F
        sta     $55                             ; 1741
        rts                                     ; 1743

; ----------------------------------------------------------------------------
L1744:  sty     L178B                           ; 1744
        sta     L178A                           ; 1747
        lda     #$00                            ; 174A
        sta     L178C                           ; 174C
        sta     L178D                           ; 174F
        lda     L178A                           ; 1752
        sec                                     ; 1755
        sbc     #$C8                            ; 1756
        sta     L178C                           ; 1758
        lda     L178B                           ; 175B
        sbc     #$00                            ; 175E
        sta     L178D                           ; 1760
        bcc     L1777                           ; 1763
        asl     L178C                           ; 1765
        rol     L178D                           ; 1768
        asl     L178C                           ; 176B
        rol     L178D                           ; 176E
        asl     L178C                           ; 1771
        rol     L178D                           ; 1774
L1777:  lda     L178A                           ; 1777
        clc                                     ; 177A
        adc     L178C                           ; 177B
        pha                                     ; 177E
        lda     L178B                           ; 177F
        adc     L178D                           ; 1782
        tay                                     ; 1785
        pla                                     ; 1786
        jmp     L178E                           ; 1787

; ----------------------------------------------------------------------------
L178A:  brk                                     ; 178A
L178B:  brk                                     ; 178B
L178C:  brk                                     ; 178C
L178D:  brk                                     ; 178D
L178E:  clc                                     ; 178E
        adc     $54                             ; 178F
        sta     $54                             ; 1791
        tya                                     ; 1793
        adc     $55                             ; 1794
        sta     $55                             ; 1796
        lda     #$E7                            ; 1798
        cmp     $54                             ; 179A
        lda     #$03                            ; 179C
        sbc     $55                             ; 179E
        bcs     L17AA                           ; 17A0
        lda     #$E7                            ; 17A2
        sta     $54                             ; 17A4
        lda     #$03                            ; 17A6
        sta     $55                             ; 17A8
L17AA:  rts                                     ; 17AA

; ----------------------------------------------------------------------------
        lda     L170E                           ; 17AB
        sta     $74                             ; 17AE
        lda     L170F                           ; 17B0
        sta     $75                             ; 17B3
L17B5:  ldy     #$00                            ; 17B5
        sty     L17F8                           ; 17B7
L17BA:  ldx     #$2F                            ; 17BA
        sec                                     ; 17BC
L17BD:  lda     $74                             ; 17BD
        sbc     L18D3,y                         ; 17BF
        sta     $74                             ; 17C2
        lda     $75                             ; 17C4
        sbc     L18D8,y                         ; 17C6
        sta     $75                             ; 17C9
        inx                                     ; 17CB
        bcs     L17BD                           ; 17CC
        lda     $74                             ; 17CE
        adc     L18D3,y                         ; 17D0
        sta     $74                             ; 17D3
        lda     $75                             ; 17D5
        adc     L18D8,y                         ; 17D7
        sta     $75                             ; 17DA
        txa                                     ; 17DC
        cpx     #$30                            ; 17DD
        beq     L17E4                           ; 17DF
        inc     L17F8                           ; 17E1
L17E4:  ldx     L17F8                           ; 17E4
        bne     L17EF                           ; 17E7
        cpy     #$04                            ; 17E9
        beq     L17EF                           ; 17EB
        lda     #$20                            ; 17ED
L17EF:  sta     L1709,y                         ; 17EF
        iny                                     ; 17F2
        cpy     #$05                            ; 17F3
        bne     L17BA                           ; 17F5
        rts                                     ; 17F7

; ----------------------------------------------------------------------------
L17F8:  brk                                     ; 17F8
        lda     $54                             ; 17F9
        sta     $74                             ; 17FB
        lda     $55                             ; 17FD
        sta     $75                             ; 17FF
        jmp     L17B5                           ; 1801

; ----------------------------------------------------------------------------
        jsr     L10D8                           ; 1804
        sec                                     ; 1807
L1808:  sbc     #$0B                            ; 1808
        bcs     L1808                           ; 180A
        adc     #$0B                            ; 180C
        asl     a                               ; 180E
        tay                                     ; 180F
        lda     LA3E0,y                         ; 1810
        sta     $15                             ; 1813
        lda     LA3E1,y                         ; 1815
        sta     $16                             ; 1818
        ldx     #$3F                            ; 181A
L181C:  lda     #$00                            ; 181C
        sta     runtime_sprites,x               ; 181E
        dey                                     ; 1821
        dex                                     ; 1822
        bpl     L181C                           ; 1823
        ldx     $77                             ; 1825
        lda     #$01                            ; 1827
        sta     sprite_1_color                  ; 1829
        lda     #$00                            ; 182C
        sta     sprite_0_color                  ; 182E
        lda     LD010                           ; 1831
        and     #$FC                            ; 1834
        ora     L1875,x                         ; 1836
        sta     LD010                           ; 1839
        lda     #$02                            ; 183C
        sta     LD01D                           ; 183E
        lda     LD01C                           ; 1841
        and     #$FC                            ; 1844
        sta     LD01C                           ; 1846
        lda     #$87                            ; 1849
        sta     sprite_0_y                      ; 184B
        sta     sprite_1_y                      ; 184E
        lda     L1877,x                         ; 1851
        sta     sprite_1_x                      ; 1854
        clc                                     ; 1857
        adc     L18CC                           ; 1858
        sta     sprite_0_x                      ; 185B
        lda     #$A0                            ; 185E
        sta     LE3F9                           ; 1860
        lda     #$A1                            ; 1863
        sta     LE3F8                           ; 1865
        lda     #$5A                            ; 1868
        sta     $78                             ; 186A
        lda     #$0E                            ; 186C
        sta     $1C                             ; 186E
        rts                                     ; 1870

; ----------------------------------------------------------------------------
        .byte   $3F                             ; 1871
        .byte   $7F                             ; 1872
        .byte   $BF                             ; 1873
        .byte   $FF                             ; 1874
L1875:  brk                                     ; 1875
        .byte   $03                             ; 1876
L1877:  .byte   $32                             ; 1877
        .byte   $14                             ; 1878
        ldy     #$3E                            ; 1879
        lda     #$00                            ; 187B
        sta     L18CC                           ; 187D
L1880:  sta     runtime_sprites_1,y             ; 1880
        dey                                     ; 1883
        bpl     L1880                           ; 1884
        ldx     #$00                            ; 1886
L1888:  lda     L170B,x                         ; 1888
        cmp     #$30                            ; 188B
        beq     L189A                           ; 188D
        ldy     L18CC                           ; 188F
        bne     L189A                           ; 1892
        ldy     L18C9,x                         ; 1894
        sty     L18CC                           ; 1897
L189A:  ldy     L18CC                           ; 189A
        beq     L18C3                           ; 189D
        ldy     L18CD,x                         ; 189F
        sty     cursor_position                 ; 18A2
        ldy     L18D0,x                         ; 18A4
        sty     cursor_position+$01             ; 18A7
        asl     a                               ; 18A9
        asl     a                               ; 18AA
        asl     a                               ; 18AB
        sta     $29                             ; 18AC
        lda     #$EA                            ; 18AE
        adc     #$00                            ; 18B0
        sta     $2A                             ; 18B2
        ldy     #$00                            ; 18B4
L18B6:  lda     ($29),y                         ; 18B6
        sta     (cursor_position),y             ; 18B8
        inc     cursor_position                 ; 18BA
        .byte   $E6                             ; 18BC
L18BD:  and     $C0C8                           ; 18BD
        php                                     ; 18C0
        bne     L18B6                           ; 18C1
L18C3:  inx                                     ; 18C3
        cpx     #$03                            ; 18C4
        bne     L1888                           ; 18C6
        rts                                     ; 18C8

; ----------------------------------------------------------------------------
L18C9:  .byte   $0C                             ; 18C9
        php                                     ; 18CA
        .byte   $04                             ; 18CB
L18CC:  brk                                     ; 18CC
L18CD:  eor     buffer_zp56,x                   ; 18CD
        .byte   $57                             ; 18CF
L18D0:  inx                                     ; 18D0
        inx                                     ; 18D1
        inx                                     ; 18D2
L18D3:  bpl     L18BD                           ; 18D3
        .byte   $64                             ; 18D5
        asl     a                               ; 18D6
        .byte   $01                             ; 18D7
L18D8:  .byte   $27                             ; 18D8
        .byte   $03                             ; 18D9
        brk                                     ; 18DA
        brk                                     ; 18DB
        brk                                     ; 18DC
set_up_sprite_registers:
        lda     #$03                            ; 18DD
        sta     L0A50                           ; 18DF
        lda     #$07                            ; 18E2
        sta     LD01D                           ; 18E4
        sta     LD010                           ; 18E7
        lda     #$FF                            ; 18EA
        sta     LD015                           ; 18EC
        lda     #$00                            ; 18EF
        sta     LD01C                           ; 18F1
        lda     #$00                            ; 18F4
        sta     LD017                           ; 18F6
        lda     #$0A                            ; 18F9
        sta     sprite_multicolor_0             ; 18FB
        lda     #$0B                            ; 18FE
        sta     sprite_multicolor_1             ; 1900
        lda     #$05                            ; 1903
        sta     L12F9                           ; 1905
        rts                                     ; 1908

; ----------------------------------------------------------------------------
L1909:  lda     #$06                            ; 1909
        sta     L12F9                           ; 190B
        lda     #$00                            ; 190E
        sta     L0A50                           ; 1910
        sta     sprite_0_y                      ; 1913
        sta     sprite_1_y                      ; 1916
L1919:  sta     sprite_2_y                      ; 1919
        rts                                     ; 191C

; ----------------------------------------------------------------------------
unknown_table:
        .byte   $C6,$80,$00,$FD,$01,$01,$FD,$19 ; 191D
        .byte   $46,$80,$C6,$80,$02,$00,$27,$1A ; 1925
        .byte   $E6,$7F,$46,$80,$03,$01,$92,$1A ; 192D
        .byte   $66,$7F,$E6,$7F,$04,$02,$D4,$1A ; 1935
        .byte   $00,$03,$66,$7F,$03,$03,$5A,$1B ; 193D
        .byte   $C6,$80,$00,$FD,$06,$06,$A8,$1B ; 1945
        .byte   $46,$80,$C6,$80,$07,$05,$E9,$1B ; 194D
        .byte   $E6,$7F,$46,$80,$08,$06,$6A,$1C ; 1955
        .byte   $66,$7F,$E6,$7F,$09,$07,$AC,$1C ; 195D
        .byte   $00,$03,$66,$7F,$08,$08,$20,$1D ; 1965
        .byte   $2D,$80,$8D,$80,$02,$0B,$57,$1D ; 196D
        .byte   $8D,$80,$B8,$8B,$0A,$0B,$A1,$1D ; 1975
L197D:  .byte   $00                             ; 197D
L197E:  .byte   $00                             ; 197E
L197F:  .byte   $00                             ; 197F
L1980:  .byte   $00,$05,$05,$45,$1E             ; 1980
L1985:  .byte   $00                             ; 1985
L1986:  .byte   $00                             ; 1986
L1987:  .byte   $00                             ; 1987
L1988:  .byte   $00,$01,$01,$5B,$1E             ; 1988
        .byte   $0F,$7F,$6F,$7F,$04,$06,$75,$1E ; 198D
        .byte   $B4,$80,$E8,$FD,$01,$09,$CB,$1E ; 1995
        .byte   $C6,$80,$00,$FD,$11,$11,$B4,$1F ; 199D
        .byte   $46,$80,$C6,$80,$12,$10,$DF,$1F ; 19A5
        .byte   $E6,$7F,$46,$80,$1A,$11,$29,$20 ; 19AD
        .byte   $00,$03,$66,$7F,$14,$14,$50,$20 ; 19B5
        .byte   $66,$7F,$E6,$7F,$13,$15,$88,$20 ; 19BD
        .byte   $E6,$7F,$46,$80,$14,$17,$DA,$20 ; 19C5
        .byte   $C6,$80,$00,$FD,$17,$17,$01,$21 ; 19CD
        .byte   $46,$80,$C6,$80,$18,$16,$2C,$21 ; 19D5
        .byte   $E6,$7F,$46,$80,$14,$17,$78,$21 ; 19DD
        .byte   $00,$03,$66,$7F,$1A,$1A,$9F,$21 ; 19E5
        .byte   $66,$7F,$E6,$7F,$19,$1B,$D7,$21 ; 19ED
        .byte   $E6,$7F,$46,$80,$1A,$11,$25,$22 ; 19F5
; ----------------------------------------------------------------------------
        cli                                     ; 19FD
        lda     #$B4                            ; 19FE
        jsr     L0FC2                           ; 1A00
        lda     #$00                            ; 1A03
        sta     $43                             ; 1A05
        lda     $4B                             ; 1A07
        bne     L1A11                           ; 1A09
        lda     $4A                             ; 1A0B
        cmp     #$64                            ; 1A0D
        bcc     L1A15                           ; 1A0F
L1A11:  lda     #$64                            ; 1A11
        bne     L1A1A                           ; 1A13
L1A15:  lda     #$E7                            ; 1A15
        sec                                     ; 1A17
        sbc     $4A                             ; 1A18
L1A1A:  sta     $42                             ; 1A1A
        lda     #$8C                            ; 1A1C
        sta     buffer_zp40                     ; 1A1E
        lda     #$00                            ; 1A20
        sta     $41                             ; 1A22
        jmp     L2705                           ; 1A24

; ----------------------------------------------------------------------------
        lda     $53                             ; 1A27
        beq     L1A31                           ; 1A29
        ldx     $52                             ; 1A2B
        bmi     L1A45                           ; 1A2D
        bpl     L1A4B                           ; 1A2F
L1A31:  lda     $79                             ; 1A31
        and     #$04                            ; 1A33
        bne     L1A48                           ; 1A35
        lda     #$0C                            ; 1A37
        clc                                     ; 1A39
        adc     $4C                             ; 1A3A
        sta     $6C                             ; 1A3C
        lda     #$11                            ; 1A3E
        sta     $53                             ; 1A40
        jmp     L1A4B                           ; 1A42

; ----------------------------------------------------------------------------
L1A45:  jsr     L25EB                           ; 1A45
L1A48:  jsr     L1F05                           ; 1A48
L1A4B:  cli                                     ; 1A4B
        lda     $4A                             ; 1A4C
        tax                                     ; 1A4E
        lda     #$66                            ; 1A4F
        clc                                     ; 1A51
        adc     L11F1,x                         ; 1A52
        jsr     L0FC2                           ; 1A55
        jsr     L249B                           ; 1A58
        lda     $4A                             ; 1A5B
        eor     #$7F                            ; 1A5D
        sta     $25                             ; 1A5F
        tax                                     ; 1A61
        and     #$78                            ; 1A62
        ora     #$07                            ; 1A64
        tay                                     ; 1A66
        lda     #$14                            ; 1A67
        clc                                     ; 1A69
        adc     L11F1,x                         ; 1A6A
        sec                                     ; 1A6D
        sbc     L11F1,y                         ; 1A6E
        clc                                     ; 1A71
        adc     #$78                            ; 1A72
        sta     buffer_zp40                     ; 1A74
        lda     #$00                            ; 1A76
        adc     #$00                            ; 1A78
        sta     $41                             ; 1A7A
        lda     L1271,x                         ; 1A7C
        sec                                     ; 1A7F
        sbc     L1271,y                         ; 1A80
        clc                                     ; 1A83
        adc     #$EF                            ; 1A84
        sta     $42                             ; 1A86
        lda     $25                             ; 1A88
        lsr     a                               ; 1A8A
        lsr     a                               ; 1A8B
        lsr     a                               ; 1A8C
        sta     $43                             ; 1A8D
        jmp     L2705                           ; 1A8F

; ----------------------------------------------------------------------------
        lda     $4C                             ; 1A92
        beq     L1A9D                           ; 1A94
        jsr     L1711                           ; 1A96
        lda     #$01                            ; 1A99
        sta     $77                             ; 1A9B
L1A9D:  lda     #$00                            ; 1A9D
        sta     $4C                             ; 1A9F
        sta     $4D                             ; 1AA1
        sta     $4E                             ; 1AA3
        sta     $4F                             ; 1AA5
        sta     $50                             ; 1AA7
        jsr     L249B                           ; 1AA9
        cli                                     ; 1AAC
        jsr     L2580                           ; 1AAD
        bne     L1AB6                           ; 1AB0
        lda     #$B2                            ; 1AB2
        bne     L1AB8                           ; 1AB4
L1AB6:  lda     #$10                            ; 1AB6
L1AB8:  sta     $43                             ; 1AB8
        lda     #$EF                            ; 1ABA
        sta     $42                             ; 1ABC
        lda     #$CC                            ; 1ABE
        sta     buffer_zp40                     ; 1AC0
        lda     #$FF                            ; 1AC2
        sta     $41                             ; 1AC4
        lda     buffer_zp40                     ; 1AC6
        clc                                     ; 1AC8
        adc     $4A                             ; 1AC9
        sta     buffer_zp40                     ; 1ACB
        bcc     L1AD1                           ; 1ACD
        inc     $41                             ; 1ACF
L1AD1:  jmp     L2705                           ; 1AD1

; ----------------------------------------------------------------------------
        lda     $53                             ; 1AD4
        beq     L1AE2                           ; 1AD6
        ldx     $52                             ; 1AD8
        bmi     L1AE5                           ; 1ADA
        jsr     L25EB                           ; 1ADC
        jmp     L1AE5                           ; 1ADF

; ----------------------------------------------------------------------------
L1AE2:  jsr     L1F05                           ; 1AE2
L1AE5:  cli                                     ; 1AE5
        lda     $4A                             ; 1AE6
        eor     #$7F                            ; 1AE8
        tax                                     ; 1AEA
        lda     #$9A                            ; 1AEB
        sec                                     ; 1AED
        sbc     L11F1,x                         ; 1AEE
        jsr     L0FC2                           ; 1AF1
        jsr     L249B                           ; 1AF4
        lda     $4A                             ; 1AF7
        eor     #$7F                            ; 1AF9
        sta     $25                             ; 1AFB
        lda     $4A                             ; 1AFD
        tay                                     ; 1AFF
        and     #$78                            ; 1B00
        ora     #$04                            ; 1B02
        tax                                     ; 1B04
        lda     #$14                            ; 1B05
        clc                                     ; 1B07
        adc     L11F1,x                         ; 1B08
        sec                                     ; 1B0B
        sbc     L11F1,y                         ; 1B0C
        clc                                     ; 1B0F
        adc     #$AE                            ; 1B10
        sta     buffer_zp40                     ; 1B12
        lda     #$00                            ; 1B14
        adc     #$FF                            ; 1B16
        sta     $41                             ; 1B18
        lda     #$EF                            ; 1B1A
        sec                                     ; 1B1C
        sbc     L1271,x                         ; 1B1D
        clc                                     ; 1B20
        adc     L1271,y                         ; 1B21
        sta     $42                             ; 1B24
        lda     $25                             ; 1B26
        lsr     a                               ; 1B28
        lsr     a                               ; 1B29
        lsr     a                               ; 1B2A
        clc                                     ; 1B2B
        adc     #$10                            ; 1B2C
        sta     $43                             ; 1B2E
        jsr     L2705                           ; 1B30
        lda     $4A                             ; 1B33
        cmp     #$46                            ; 1B35
        bcs     L1B59                           ; 1B37
        jsr     L2392                           ; 1B39
        bne     L1B59                           ; 1B3C
        jsr     L2256                           ; 1B3E
        ldy     $4A                             ; 1B41
        lda     #$5C                            ; 1B43
        sec                                     ; 1B45
        sbc     L11F1,y                         ; 1B46
        sta     buffer_zp40                     ; 1B49
        lda     #$00                            ; 1B4B
        sbc     #$00                            ; 1B4D
        sta     $41                             ; 1B4F
        lda     L1271,y                         ; 1B51
        sec                                     ; 1B54
        sbc     #$1A                            ; 1B55
        sta     $42                             ; 1B57
L1B59:  rts                                     ; 1B59

; ----------------------------------------------------------------------------
        jsr     L2446                           ; 1B5A
        bne     L1B64                           ; 1B5D
        inc     $6F                             ; 1B5F
        jmp     L2330                           ; 1B61

; ----------------------------------------------------------------------------
L1B64:  jsr     L2392                           ; 1B64
        bne     L1B6C                           ; 1B67
        jsr     L2256                           ; 1B69
L1B6C:  cli                                     ; 1B6C
        lda     #$4C                            ; 1B6D
        jsr     L0FC2                           ; 1B6F
        lda     #$66                            ; 1B72
        sec                                     ; 1B74
        sbc     $4A                             ; 1B75
        sta     $25                             ; 1B77
        lda     #$7C                            ; 1B79
        sbc     $4B                             ; 1B7B
        sta     $26                             ; 1B7D
        lda     #$1F                            ; 1B7F
        sta     $43                             ; 1B81
        lda     $26                             ; 1B83
        bne     L1B8D                           ; 1B85
        lda     $25                             ; 1B87
        cmp     #$64                            ; 1B89
        bcc     L1B91                           ; 1B8B
L1B8D:  lda     #$64                            ; 1B8D
        bne     L1B96                           ; 1B8F
L1B91:  lda     #$EB                            ; 1B91
        sec                                     ; 1B93
        sbc     $25                             ; 1B94
L1B96:  sta     $42                             ; 1B96
        lda     #$C2                            ; 1B98
        sta     buffer_zp40                     ; 1B9A
        lda     #$FF                            ; 1B9C
        sta     $41                             ; 1B9E
        lda     $25                             ; 1BA0
        jsr     L1F2C                           ; 1BA2
        jmp     L2705                           ; 1BA5

; ----------------------------------------------------------------------------
        jsr     L2470                           ; 1BA8
        bne     L1BB2                           ; 1BAB
        inc     $6F                             ; 1BAD
        jmp     L2361                           ; 1BAF

; ----------------------------------------------------------------------------
L1BB2:  jsr     L23EC                           ; 1BB2
        bne     L1BBA                           ; 1BB5
        jsr     L22BB                           ; 1BB7
L1BBA:  cli                                     ; 1BBA
        lda     #$B4                            ; 1BBB
        jsr     L0FC2                           ; 1BBD
        lda     #$3F                            ; 1BC0
        sta     $43                             ; 1BC2
        lda     $4B                             ; 1BC4
        bne     L1BCE                           ; 1BC6
        lda     $4A                             ; 1BC8
        cmp     #$64                            ; 1BCA
        bcc     L1BD2                           ; 1BCC
L1BCE:  lda     #$64                            ; 1BCE
        bne     L1BD7                           ; 1BD0
L1BD2:  lda     #$E7                            ; 1BD2
        sec                                     ; 1BD4
        sbc     $4A                             ; 1BD5
L1BD7:  sta     $42                             ; 1BD7
        lda     #$8C                            ; 1BD9
        sta     buffer_zp40                     ; 1BDB
        lda     #$00                            ; 1BDD
        sta     $41                             ; 1BDF
        lda     $4A                             ; 1BE1
        jsr     L1F48                           ; 1BE3
        jmp     L2705                           ; 1BE6

; ----------------------------------------------------------------------------
        lda     $53                             ; 1BE9
        beq     L1BF7                           ; 1BEB
        ldx     $52                             ; 1BED
        bpl     L1BFA                           ; 1BEF
        jsr     L25EB                           ; 1BF1
        jmp     L1BFA                           ; 1BF4

; ----------------------------------------------------------------------------
L1BF7:  jsr     L1F05                           ; 1BF7
L1BFA:  cli                                     ; 1BFA
        lda     $4A                             ; 1BFB
        tax                                     ; 1BFD
        lda     #$66                            ; 1BFE
        clc                                     ; 1C00
        adc     L11F1,x                         ; 1C01
        jsr     L0FC2                           ; 1C04
        jsr     L249B                           ; 1C07
        lda     $4A                             ; 1C0A
        eor     #$7F                            ; 1C0C
        sta     $25                             ; 1C0E
        tax                                     ; 1C10
        and     #$78                            ; 1C11
        ora     #$07                            ; 1C13
        tay                                     ; 1C15
        lda     #$14                            ; 1C16
        clc                                     ; 1C18
        adc     L11F1,x                         ; 1C19
        sec                                     ; 1C1C
        sbc     L11F1,y                         ; 1C1D
        clc                                     ; 1C20
        adc     #$78                            ; 1C21
        sta     buffer_zp40                     ; 1C23
        lda     #$00                            ; 1C25
        adc     #$00                            ; 1C27
        sta     $41                             ; 1C29
        lda     L1271,x                         ; 1C2B
        sec                                     ; 1C2E
        sbc     L1271,y                         ; 1C2F
        clc                                     ; 1C32
        adc     #$EF                            ; 1C33
        sta     $42                             ; 1C35
        lda     $25                             ; 1C37
        lsr     a                               ; 1C39
        lsr     a                               ; 1C3A
        lsr     a                               ; 1C3B
        eor     #$3F                            ; 1C3C
        sta     $43                             ; 1C3E
        jsr     L2705                           ; 1C40
        lda     $4A                             ; 1C43
        cmp     #$3A                            ; 1C45
        bcc     L1C69                           ; 1C47
        jsr     L23EC                           ; 1C49
        bne     L1C69                           ; 1C4C
        jsr     L22BB                           ; 1C4E
        ldy     $4A                             ; 1C51
        lda     L1271,y                         ; 1C53
        sec                                     ; 1C56
        sbc     #$C4                            ; 1C57
        sta     buffer_zp40                     ; 1C59
        lda     #$00                            ; 1C5B
        sbc     #$FF                            ; 1C5D
        sta     $41                             ; 1C5F
        lda     L11F1,y                         ; 1C61
        sec                                     ; 1C64
        sbc     #$69                            ; 1C65
        sta     $42                             ; 1C67
L1C69:  rts                                     ; 1C69

; ----------------------------------------------------------------------------
        lda     $4C                             ; 1C6A
        beq     L1C75                           ; 1C6C
        jsr     L1711                           ; 1C6E
        lda     #$00                            ; 1C71
        sta     $77                             ; 1C73
L1C75:  lda     #$00                            ; 1C75
        sta     $4C                             ; 1C77
        sta     $4D                             ; 1C79
        sta     $4E                             ; 1C7B
        sta     $4F                             ; 1C7D
        sta     $50                             ; 1C7F
        jsr     L249B                           ; 1C81
        cli                                     ; 1C84
        jsr     L2580                           ; 1C85
        bne     L1C8E                           ; 1C88
        lda     #$B1                            ; 1C8A
        bne     L1C90                           ; 1C8C
L1C8E:  lda     #$30                            ; 1C8E
L1C90:  sta     $43                             ; 1C90
        lda     #$EF                            ; 1C92
        sta     $42                             ; 1C94
        lda     #$2C                            ; 1C96
        sta     buffer_zp40                     ; 1C98
        lda     #$00                            ; 1C9A
        sta     $41                             ; 1C9C
        lda     buffer_zp40                     ; 1C9E
        clc                                     ; 1CA0
        adc     $4A                             ; 1CA1
        sta     buffer_zp40                     ; 1CA3
        bcc     L1CA9                           ; 1CA5
        inc     $41                             ; 1CA7
L1CA9:  jmp     L2705                           ; 1CA9

; ----------------------------------------------------------------------------
        lda     $53                             ; 1CAC
        beq     L1CB6                           ; 1CAE
        ldx     $52                             ; 1CB0
        bpl     L1CCA                           ; 1CB2
        bmi     L1CD0                           ; 1CB4
L1CB6:  lda     $79                             ; 1CB6
        and     #$08                            ; 1CB8
        bne     L1CCD                           ; 1CBA
        lda     #$0C                            ; 1CBC
        clc                                     ; 1CBE
        adc     $4C                             ; 1CBF
        sta     $6C                             ; 1CC1
        lda     #$14                            ; 1CC3
        sta     $53                             ; 1CC5
        jmp     L1CD0                           ; 1CC7

; ----------------------------------------------------------------------------
L1CCA:  jsr     L25EB                           ; 1CCA
L1CCD:  jsr     L1F05                           ; 1CCD
L1CD0:  cli                                     ; 1CD0
        lda     $4A                             ; 1CD1
        eor     #$7F                            ; 1CD3
        tax                                     ; 1CD5
        lda     #$9A                            ; 1CD6
        sec                                     ; 1CD8
        sbc     L11F1,x                         ; 1CD9
        jsr     L0FC2                           ; 1CDC
        jsr     L249B                           ; 1CDF
        lda     $4A                             ; 1CE2
        eor     #$7F                            ; 1CE4
        sta     $25                             ; 1CE6
        lda     $4A                             ; 1CE8
        tay                                     ; 1CEA
        and     #$78                            ; 1CEB
        ora     #$04                            ; 1CED
        tax                                     ; 1CEF
        lda     #$14                            ; 1CF0
        clc                                     ; 1CF2
        adc     L11F1,x                         ; 1CF3
        sec                                     ; 1CF6
        sbc     L11F1,y                         ; 1CF7
        clc                                     ; 1CFA
        adc     #$AE                            ; 1CFB
        sta     buffer_zp40                     ; 1CFD
        lda     #$00                            ; 1CFF
        adc     #$FF                            ; 1D01
        sta     $41                             ; 1D03
        lda     #$EF                            ; 1D05
        sec                                     ; 1D07
        sbc     L1271,x                         ; 1D08
        clc                                     ; 1D0B
        adc     L1271,y                         ; 1D0C
        sta     $42                             ; 1D0F
        lda     $25                             ; 1D11
        lsr     a                               ; 1D13
        lsr     a                               ; 1D14
        lsr     a                               ; 1D15
        clc                                     ; 1D16
        adc     #$10                            ; 1D17
        eor     #$3F                            ; 1D19
        sta     $43                             ; 1D1B
        jmp     L2705                           ; 1D1D

; ----------------------------------------------------------------------------
        cli                                     ; 1D20
        lda     #$4C                            ; 1D21
        jsr     L0FC2                           ; 1D23
        lda     #$66                            ; 1D26
        sec                                     ; 1D28
        sbc     $4A                             ; 1D29
        sta     $25                             ; 1D2B
        lda     #$7C                            ; 1D2D
        sbc     $4B                             ; 1D2F
        sta     $26                             ; 1D31
        lda     #$20                            ; 1D33
        sta     $43                             ; 1D35
        lda     $26                             ; 1D37
        bne     L1D41                           ; 1D39
        lda     $25                             ; 1D3B
        cmp     #$64                            ; 1D3D
        bcc     L1D45                           ; 1D3F
L1D41:  lda     #$64                            ; 1D41
        bne     L1D4A                           ; 1D43
L1D45:  lda     #$EB                            ; 1D45
        sec                                     ; 1D47
        sbc     $25                             ; 1D48
L1D4A:  sta     $42                             ; 1D4A
        lda     #$C2                            ; 1D4C
        sta     buffer_zp40                     ; 1D4E
        lda     #$FF                            ; 1D50
        sta     $41                             ; 1D52
        jmp     L2705                           ; 1D54

; ----------------------------------------------------------------------------
        jsr     L1F05                           ; 1D57
        jsr     L1909                           ; 1D5A
        cli                                     ; 1D5D
        lda     $4A                             ; 1D5E
        tax                                     ; 1D60
        lda     #$66                            ; 1D61
        clc                                     ; 1D63
        adc     L11F1,x                         ; 1D64
        jsr     L0FC2                           ; 1D67
        lda     $4A                             ; 1D6A
        eor     #$7F                            ; 1D6C
        sta     $25                             ; 1D6E
        tax                                     ; 1D70
        and     #$78                            ; 1D71
        ora     #$07                            ; 1D73
        tay                                     ; 1D75
        lda     #$14                            ; 1D76
        clc                                     ; 1D78
        adc     L11F1,x                         ; 1D79
        sec                                     ; 1D7C
        sbc     L11F1,y                         ; 1D7D
        clc                                     ; 1D80
        adc     #$5F                            ; 1D81
        sta     buffer_zp40                     ; 1D83
        lda     #$00                            ; 1D85
        adc     #$00                            ; 1D87
        sta     $41                             ; 1D89
        lda     L1271,x                         ; 1D8B
        sec                                     ; 1D8E
        sbc     L1271,y                         ; 1D8F
        clc                                     ; 1D92
        adc     #$EF                            ; 1D93
        sta     $42                             ; 1D95
        lda     $25                             ; 1D97
        lsr     a                               ; 1D99
        lsr     a                               ; 1D9A
        lsr     a                               ; 1D9B
        sta     $43                             ; 1D9C
        jmp     L2705                           ; 1D9E

; ----------------------------------------------------------------------------
        cli                                     ; 1DA1
        lda     #$BA                            ; 1DA2
        jsr     L0FC2                           ; 1DA4
        ldy     $4A                             ; 1DA7
        lda     #$14                            ; 1DA9
        clc                                     ; 1DAB
        adc     L1DCD,y                         ; 1DAC
        clc                                     ; 1DAF
        adc     #$85                            ; 1DB0
        sta     buffer_zp40                     ; 1DB2
        lda     #$00                            ; 1DB4
        adc     #$00                            ; 1DB6
        sta     $41                             ; 1DB8
        lda     #$DF                            ; 1DBA
        sec                                     ; 1DBC
        sbc     L1DF5,y                         ; 1DBD
        sta     $42                             ; 1DC0
        lda     #$50                            ; 1DC2
        sec                                     ; 1DC4
        sbc     L1E1D,y                         ; 1DC5
        sta     $43                             ; 1DC8
        jmp     L2705                           ; 1DCA

; ----------------------------------------------------------------------------
L1DCD:  .byte   $00,$00,$00,$00,$00,$01,$01,$01 ; 1DCD
        .byte   $01,$02,$00,$00,$01,$02,$02,$03 ; 1DD5
        .byte   $04,$05,$06,$07,$07,$08,$FD,$FE ; 1DDD
        .byte   $FF,$00,$01,$02,$03,$04,$05,$06 ; 1DE5
        .byte   $07,$08,$09,$0A,$0B,$FC,$FD,$FE ; 1DED
L1DF5:  .byte   $00,$01,$02,$03,$04,$05,$06,$07 ; 1DF5
        .byte   $08,$09,$FF,$00,$01,$02,$03,$04 ; 1DFD
        .byte   $05,$06,$07,$08,$09,$0A,$FD,$FE ; 1E05
        .byte   $FF,$00,$01,$01,$02,$02,$03,$03 ; 1E0D
        .byte   $04,$04,$04,$05,$05,$FF,$00,$00 ; 1E15
L1E1D:  .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 1E1D
        .byte   $00,$00,$01,$01,$01,$01,$01,$01 ; 1E25
        .byte   $01,$01,$01,$01,$01,$01,$02,$02 ; 1E2D
        .byte   $02,$02,$02,$02,$02,$02,$02,$02 ; 1E35
        .byte   $02,$02,$02,$02,$02,$03,$03,$03 ; 1E3D
; ----------------------------------------------------------------------------
        lda     #$05                            ; 1E45
        sta     $1C                             ; 1E47
        lda     #$01                            ; 1E49
        sta     $4C                             ; 1E4B
        cli                                     ; 1E4D
        lda     $4A                             ; 1E4E
        lsr     a                               ; 1E50
        lsr     a                               ; 1E51
        lsr     a                               ; 1E52
        clc                                     ; 1E53
        adc     #$47                            ; 1E54
        sta     $43                             ; 1E56
        jmp     L2705                           ; 1E58

; ----------------------------------------------------------------------------
        lda     #$05                            ; 1E5B
        sta     $1C                             ; 1E5D
        lda     #$01                            ; 1E5F
        sta     $4C                             ; 1E61
        cli                                     ; 1E63
        lda     $4A                             ; 1E64
        lsr     a                               ; 1E66
        lsr     a                               ; 1E67
        lsr     a                               ; 1E68
        sta     $25                             ; 1E69
        lda     #$44                            ; 1E6B
        sec                                     ; 1E6D
        sbc     $25                             ; 1E6E
        sta     $43                             ; 1E70
        jmp     L2705                           ; 1E72

; ----------------------------------------------------------------------------
        lda     #$01                            ; 1E75
        sta     $4C                             ; 1E77
        lda     $4A                             ; 1E79
        bpl     L1E7F                           ; 1E7B
        lda     #$7F                            ; 1E7D
L1E7F:  sta     $4A                             ; 1E7F
        cli                                     ; 1E81
        lda     $4A                             ; 1E82
        lsr     a                               ; 1E84
        lsr     a                               ; 1E85
        lsr     a                               ; 1E86
        tay                                     ; 1E87
        clc                                     ; 1E88
        adc     #$5D                            ; 1E89
        sta     $43                             ; 1E8B
        jsr     L1F64                           ; 1E8D
        beq     L1E96                           ; 1E90
        lda     #$14                            ; 1E92
        sta     $53                             ; 1E94
L1E96:  lda     #$8E                            ; 1E96
        sta     buffer_zp40                     ; 1E98
        lda     #$FF                            ; 1E9A
        sta     $41                             ; 1E9C
        lda     #$C0                            ; 1E9E
        sta     $42                             ; 1EA0
        lda     L1EAB,y                         ; 1EA2
        jsr     L0FC2                           ; 1EA5
        jmp     L2705                           ; 1EA8

; ----------------------------------------------------------------------------
L1EAB:  .byte   $9C                             ; 1EAB
        .byte   $9C                             ; 1EAC
        tsx                                     ; 1EAD
        brk                                     ; 1EAE
        brk                                     ; 1EAF
        brk                                     ; 1EB0
        brk                                     ; 1EB1
        brk                                     ; 1EB2
        brk                                     ; 1EB3
        brk                                     ; 1EB4
        .byte   $32                             ; 1EB5
        brk                                     ; 1EB6
        brk                                     ; 1EB7
        brk                                     ; 1EB8
        brk                                     ; 1EB9
        brk                                     ; 1EBA
L1EBB:  brk                                     ; 1EBB
        ora     (io_port_register+$01,x)        ; 1EBC
        ora     (io_port_register+$01,x)        ; 1EBE
        ora     (io_port_register+$01,x)        ; 1EC0
        ora     (io_port_register,x)            ; 1EC2
        brk                                     ; 1EC4
        brk                                     ; 1EC5
        .byte   $FF                             ; 1EC6
        .byte   $FF                             ; 1EC7
        .byte   $FF                             ; 1EC8
        .byte   $FF                             ; 1EC9
        .byte   $FF                             ; 1ECA
        lda     #$01                            ; 1ECB
        sta     $4C                             ; 1ECD
        lda     #$60                            ; 1ECF
        sec                                     ; 1ED1
        sbc     $4A                             ; 1ED2
        cmp     #$5F                            ; 1ED4
        bcc     L1EDA                           ; 1ED6
        lda     #$5F                            ; 1ED8
L1EDA:  cli                                     ; 1EDA
        lsr     a                               ; 1EDB
        lsr     a                               ; 1EDC
        lsr     a                               ; 1EDD
        tay                                     ; 1EDE
        clc                                     ; 1EDF
        adc     #$51                            ; 1EE0
        sta     $43                             ; 1EE2
        jsr     L1F64                           ; 1EE4
        beq     L1EED                           ; 1EE7
        lda     #$11                            ; 1EE9
        sta     $53                             ; 1EEB
L1EED:  lda     #$8D                            ; 1EED
        sta     buffer_zp40                     ; 1EEF
        lda     #$00                            ; 1EF1
        sta     $41                             ; 1EF3
        lda     #$C2                            ; 1EF5
        sta     $42                             ; 1EF7
        lda     #$00                            ; 1EF9
        sec                                     ; 1EFB
        sbc     L1EAB,y                         ; 1EFC
        jsr     L0FC2                           ; 1EFF
        jmp     L2705                           ; 1F02

; ----------------------------------------------------------------------------
L1F05:  txa                                     ; 1F05
        pha                                     ; 1F06
        ldx     #$00                            ; 1F07
        lda     $52                             ; 1F09
        bpl     L1F0E                           ; 1F0B
        inx                                     ; 1F0D
L1F0E:  lda     $46                             ; 1F0E
        bpl     L1F14                           ; 1F10
        inx                                     ; 1F12
        inx                                     ; 1F13
L1F14:  lda     $79                             ; 1F14
        and     L1F28,x                         ; 1F16
        bne     L1F21                           ; 1F19
        lda     L1F24,x                         ; 1F1B
        jsr     L0FC2                           ; 1F1E
L1F21:  pla                                     ; 1F21
        tax                                     ; 1F22
        rts                                     ; 1F23

; ----------------------------------------------------------------------------
L1F24:  asl     a                               ; 1F24
        inc     $0A,x                           ; 1F25
        .byte   $F6                             ; 1F27
L1F28:  .byte   $02                             ; 1F28
        ora     (io_port_register+$01,x)        ; 1F29
        .byte   $02                             ; 1F2B
L1F2C:  cmp     #$1E                            ; 1F2C
        bcc     L1F47                           ; 1F2E
        lda     $52                             ; 1F30
        bmi     L1F47                           ; 1F32
        lda     $4C                             ; 1F34
        bne     L1F47                           ; 1F36
        lda     $47                             ; 1F38
        cmp     #$04                            ; 1F3A
        bne     L1F47                           ; 1F3C
        lda     #$0E                            ; 1F3E
        sta     $6C                             ; 1F40
        lda     #$19                            ; 1F42
        jsr     L25EB                           ; 1F44
L1F47:  rts                                     ; 1F47

; ----------------------------------------------------------------------------
L1F48:  cmp     #$1E                            ; 1F48
        bcc     L1F63                           ; 1F4A
        lda     $52                             ; 1F4C
        bpl     L1F63                           ; 1F4E
        lda     $4C                             ; 1F50
        bne     L1F63                           ; 1F52
        lda     $47                             ; 1F54
        cmp     #$05                            ; 1F56
        bne     L1F63                           ; 1F58
        lda     #$0E                            ; 1F5A
        sta     $6C                             ; 1F5C
        lda     #$16                            ; 1F5E
        jsr     L25EB                           ; 1F60
L1F63:  rts                                     ; 1F63

; ----------------------------------------------------------------------------
L1F64:  lda     L1EBB,y                         ; 1F64
        beq     L1F83                           ; 1F67
        bmi     L1F76                           ; 1F69
        lda     $79                             ; 1F6B
        and     #$10                            ; 1F6D
        beq     L1F75                           ; 1F6F
        lda     #$0B                            ; 1F71
        sta     $6C                             ; 1F73
L1F75:  rts                                     ; 1F75

; ----------------------------------------------------------------------------
L1F76:  lda     $79                             ; 1F76
        and     #$10                            ; 1F78
        eor     #$10                            ; 1F7A
        beq     L1F83                           ; 1F7C
        lda     #$0A                            ; 1F7E
        sta     $6C                             ; 1F80
        rts                                     ; 1F82

; ----------------------------------------------------------------------------
L1F83:  cpy     L1F9E                           ; 1F83
        beq     L1F75                           ; 1F86
        sty     L1F9E                           ; 1F88
        lda     $79                             ; 1F8B
        and     #$10                            ; 1F8D
        bne     L1F9B                           ; 1F8F
        ldy     #$00                            ; 1F91
        lda     #$4B                            ; 1F93
        jsr     L178E                           ; 1F95
        ldy     L1F9E                           ; 1F98
L1F9B:  lda     #$00                            ; 1F9B
        rts                                     ; 1F9D

; ----------------------------------------------------------------------------
L1F9E:  .byte   $FF                             ; 1F9E
        lda     $79                             ; 1F9F
        and     #$10                            ; 1FA1
        bne     L1FB3                           ; 1FA3
        lda     $4F                             ; 1FA5
        ora     $4F                             ; 1FA7
        bne     L1FB3                           ; 1FA9
        lda     $45                             ; 1FAB
        sta     $4F                             ; 1FAD
        lda     $46                             ; 1FAF
        sta     $50                             ; 1FB1
L1FB3:  rts                                     ; 1FB3

; ----------------------------------------------------------------------------
        cli                                     ; 1FB4
        lda     #$B4                            ; 1FB5
        jsr     L0FC2                           ; 1FB7
        ldx     #$A9                            ; 1FBA
        jsr     L224C                           ; 1FBC
        lda     $4B                             ; 1FBF
        bne     L1FC9                           ; 1FC1
        lda     $4A                             ; 1FC3
        cmp     #$64                            ; 1FC5
        bcc     L1FCD                           ; 1FC7
L1FC9:  lda     #$64                            ; 1FC9
        bne     L1FD2                           ; 1FCB
L1FCD:  lda     #$E7                            ; 1FCD
        sec                                     ; 1FCF
        sbc     $4A                             ; 1FD0
L1FD2:  sta     $42                             ; 1FD2
        lda     #$8C                            ; 1FD4
        sta     buffer_zp40                     ; 1FD6
        lda     #$00                            ; 1FD8
        sta     $41                             ; 1FDA
        jmp     L2705                           ; 1FDC

; ----------------------------------------------------------------------------
        cli                                     ; 1FDF
        lda     $4A                             ; 1FE0
        tax                                     ; 1FE2
        lda     #$66                            ; 1FE3
        clc                                     ; 1FE5
        adc     L11F1,x                         ; 1FE6
        jsr     L0FC2                           ; 1FE9
        jsr     L249B                           ; 1FEC
        lda     $4A                             ; 1FEF
        eor     #$7F                            ; 1FF1
        sta     $25                             ; 1FF3
        tax                                     ; 1FF5
        and     #$78                            ; 1FF6
        ora     #$07                            ; 1FF8
        tay                                     ; 1FFA
        lda     #$14                            ; 1FFB
        clc                                     ; 1FFD
        adc     L11F1,x                         ; 1FFE
        sec                                     ; 2001
        sbc     L11F1,y                         ; 2002
        clc                                     ; 2005
        adc     #$78                            ; 2006
        sta     buffer_zp40                     ; 2008
        lda     #$00                            ; 200A
        adc     #$00                            ; 200C
        sta     $41                             ; 200E
        lda     L1271,x                         ; 2010
        sec                                     ; 2013
        sbc     L1271,y                         ; 2014
        clc                                     ; 2017
        adc     #$EF                            ; 2018
        sta     $42                             ; 201A
        lda     $25                             ; 201C
        lsr     a                               ; 201E
        lsr     a                               ; 201F
L2020:  lsr     a                               ; 2020
        clc                                     ; 2021
        adc     #$79                            ; 2022
        sta     $43                             ; 2024
        jmp     L2705                           ; 2026

; ----------------------------------------------------------------------------
        jsr     L249B                           ; 2029
        lda     #$64                            ; 202C
        jsr     L0FC2                           ; 202E
        cli                                     ; 2031
        lda     #$88                            ; 2032
        sta     $43                             ; 2034
        lda     #$EF                            ; 2036
        sta     $42                             ; 2038
        lda     #$2C                            ; 203A
        sta     buffer_zp40                     ; 203C
        lda     #$00                            ; 203E
        sta     $41                             ; 2040
        lda     buffer_zp40                     ; 2042
        clc                                     ; 2044
        adc     $4A                             ; 2045
        sta     buffer_zp40                     ; 2047
        bcc     L204D                           ; 2049
        inc     $41                             ; 204B
L204D:  jmp     L2705                           ; 204D

; ----------------------------------------------------------------------------
        cli                                     ; 2050
        lda     #$4C                            ; 2051
        jsr     L0FC2                           ; 2053
        lda     #$66                            ; 2056
        sec                                     ; 2058
        sbc     $4A                             ; 2059
        sta     $25                             ; 205B
        lda     #$7C                            ; 205D
        sbc     $4B                             ; 205F
        sta     $26                             ; 2061
        ldx     #$AB                            ; 2063
        jsr     L224C                           ; 2065
        lda     $26                             ; 2068
        bne     L2072                           ; 206A
        lda     $25                             ; 206C
        cmp     #$64                            ; 206E
        bcc     L2076                           ; 2070
L2072:  lda     #$64                            ; 2072
        bne     L207B                           ; 2074
L2076:  lda     #$EB                            ; 2076
        sec                                     ; 2078
        sbc     $25                             ; 2079
L207B:  sta     $42                             ; 207B
        lda     #$C2                            ; 207D
        sta     buffer_zp40                     ; 207F
        lda     #$FF                            ; 2081
        sta     $41                             ; 2083
        jmp     L2705                           ; 2085

; ----------------------------------------------------------------------------
        cli                                     ; 2088
        lda     $4A                             ; 2089
        eor     #$7F                            ; 208B
        tax                                     ; 208D
        lda     #$9A                            ; 208E
        sec                                     ; 2090
        sbc     L11F1,x                         ; 2091
        jsr     L0FC2                           ; 2094
        jsr     L249B                           ; 2097
        lda     $4A                             ; 209A
        eor     #$7F                            ; 209C
        sta     $25                             ; 209E
        lda     $4A                             ; 20A0
        tay                                     ; 20A2
        and     #$78                            ; 20A3
        ora     #$04                            ; 20A5
        tax                                     ; 20A7
        lda     #$14                            ; 20A8
        clc                                     ; 20AA
        adc     L11F1,x                         ; 20AB
        sec                                     ; 20AE
        sbc     L11F1,y                         ; 20AF
        clc                                     ; 20B2
        adc     #$B8                            ; 20B3
        sta     buffer_zp40                     ; 20B5
        lda     #$00                            ; 20B7
        adc     #$FF                            ; 20B9
        sta     $41                             ; 20BB
        lda     #$EF                            ; 20BD
        sec                                     ; 20BF
        sbc     L1271,x                         ; 20C0
        clc                                     ; 20C3
        adc     L1271,y                         ; 20C4
        sta     $42                             ; 20C7
        lda     $25                             ; 20C9
        lsr     a                               ; 20CB
        lsr     a                               ; 20CC
        lsr     a                               ; 20CD
        clc                                     ; 20CE
        adc     #$10                            ; 20CF
        eor     #$3F                            ; 20D1
        adc     #$79                            ; 20D3
        sta     $43                             ; 20D5
        jmp     L2705                           ; 20D7

; ----------------------------------------------------------------------------
        jsr     L249B                           ; 20DA
        lda     #$9C                            ; 20DD
        jsr     L0FC2                           ; 20DF
        cli                                     ; 20E2
        lda     #$A8                            ; 20E3
        sta     $43                             ; 20E5
        lda     #$EF                            ; 20E7
        sta     $42                             ; 20E9
        lda     #$CC                            ; 20EB
        sta     buffer_zp40                     ; 20ED
        lda     #$FF                            ; 20EF
        sta     $41                             ; 20F1
        lda     buffer_zp40                     ; 20F3
        clc                                     ; 20F5
        adc     $4A                             ; 20F6
        sta     buffer_zp40                     ; 20F8
        bcc     L20FE                           ; 20FA
        inc     $41                             ; 20FC
L20FE:  jmp     L2705                           ; 20FE

; ----------------------------------------------------------------------------
        cli                                     ; 2101
        lda     #$B4                            ; 2102
        jsr     L0FC2                           ; 2104
        ldx     #$AD                            ; 2107
        jsr     L224C                           ; 2109
        lda     $4B                             ; 210C
        bne     L2116                           ; 210E
        lda     $4A                             ; 2110
        cmp     #$64                            ; 2112
        bcc     L211A                           ; 2114
L2116:  lda     #$64                            ; 2116
        bne     L211F                           ; 2118
L211A:  lda     #$E7                            ; 211A
        sec                                     ; 211C
        sbc     $4A                             ; 211D
L211F:  sta     $42                             ; 211F
        lda     #$8C                            ; 2121
        sta     buffer_zp40                     ; 2123
        lda     #$00                            ; 2125
        sta     $41                             ; 2127
        jmp     L2705                           ; 2129

; ----------------------------------------------------------------------------
        cli                                     ; 212C
        lda     $4A                             ; 212D
        tax                                     ; 212F
        lda     #$66                            ; 2130
        clc                                     ; 2132
        adc     L11F1,x                         ; 2133
        jsr     L0FC2                           ; 2136
        jsr     L249B                           ; 2139
        lda     $4A                             ; 213C
        eor     #$7F                            ; 213E
        sta     $25                             ; 2140
        tax                                     ; 2142
        and     #$78                            ; 2143
        ora     #$07                            ; 2145
        tay                                     ; 2147
        lda     #$14                            ; 2148
        clc                                     ; 214A
        adc     L11F1,x                         ; 214B
        sec                                     ; 214E
        sbc     L11F1,y                         ; 214F
        clc                                     ; 2152
        adc     #$78                            ; 2153
        sta     buffer_zp40                     ; 2155
        lda     #$00                            ; 2157
        adc     #$00                            ; 2159
        sta     $41                             ; 215B
        lda     L1271,x                         ; 215D
        sec                                     ; 2160
        sbc     L1271,y                         ; 2161
        clc                                     ; 2164
        adc     #$EF                            ; 2165
        sta     $42                             ; 2167
        lda     $25                             ; 2169
        lsr     a                               ; 216B
        lsr     a                               ; 216C
        lsr     a                               ; 216D
        eor     #$3F                            ; 216E
        clc                                     ; 2170
        adc     #$39                            ; 2171
        sta     $43                             ; 2173
        jmp     L2705                           ; 2175

; ----------------------------------------------------------------------------
        jsr     L249B                           ; 2178
        lda     #$64                            ; 217B
        jsr     L0FC2                           ; 217D
        cli                                     ; 2180
        lda     #$69                            ; 2181
        sta     $43                             ; 2183
        lda     #$EF                            ; 2185
        sta     $42                             ; 2187
        lda     #$2C                            ; 2189
        sta     buffer_zp40                     ; 218B
        lda     #$00                            ; 218D
        sta     $41                             ; 218F
        lda     buffer_zp40                     ; 2191
        clc                                     ; 2193
        adc     $4A                             ; 2194
        sta     buffer_zp40                     ; 2196
        bcc     L219C                           ; 2198
        inc     $41                             ; 219A
L219C:  jmp     L2705                           ; 219C

; ----------------------------------------------------------------------------
        cli                                     ; 219F
        lda     #$4C                            ; 21A0
        jsr     L0FC2                           ; 21A2
        lda     #$66                            ; 21A5
        sec                                     ; 21A7
        sbc     $4A                             ; 21A8
        sta     $25                             ; 21AA
        lda     #$7C                            ; 21AC
        sbc     $4B                             ; 21AE
        sta     $26                             ; 21B0
        ldx     #$AF                            ; 21B2
        jsr     L224C                           ; 21B4
        lda     $26                             ; 21B7
        bne     L21C1                           ; 21B9
        lda     $25                             ; 21BB
        cmp     #$64                            ; 21BD
        bcc     L21C5                           ; 21BF
L21C1:  lda     #$64                            ; 21C1
        bne     L21CA                           ; 21C3
L21C5:  lda     #$EB                            ; 21C5
        sec                                     ; 21C7
        sbc     $25                             ; 21C8
L21CA:  sta     $42                             ; 21CA
        lda     #$C2                            ; 21CC
        sta     buffer_zp40                     ; 21CE
        lda     #$FF                            ; 21D0
        sta     $41                             ; 21D2
        jmp     L2705                           ; 21D4

; ----------------------------------------------------------------------------
        cli                                     ; 21D7
        lda     $4A                             ; 21D8
        eor     #$7F                            ; 21DA
        tax                                     ; 21DC
        lda     #$9A                            ; 21DD
        sec                                     ; 21DF
        sbc     L11F1,x                         ; 21E0
        jsr     L0FC2                           ; 21E3
        jsr     L249B                           ; 21E6
        lda     $4A                             ; 21E9
        eor     #$7F                            ; 21EB
        sta     $25                             ; 21ED
        lda     $4A                             ; 21EF
        tay                                     ; 21F1
        and     #$78                            ; 21F2
        ora     #$04                            ; 21F4
        tax                                     ; 21F6
        lda     #$14                            ; 21F7
        clc                                     ; 21F9
        adc     L11F1,x                         ; 21FA
        sec                                     ; 21FD
        sbc     L11F1,y                         ; 21FE
        clc                                     ; 2201
        adc     #$AE                            ; 2202
        sta     buffer_zp40                     ; 2204
        lda     #$00                            ; 2206
        adc     #$FF                            ; 2208
        sta     $41                             ; 220A
        lda     #$EF                            ; 220C
        sec                                     ; 220E
        sbc     L1271,x                         ; 220F
        clc                                     ; 2212
        adc     L1271,y                         ; 2213
        sta     $42                             ; 2216
        lda     $25                             ; 2218
        lsr     a                               ; 221A
        lsr     a                               ; 221B
        lsr     a                               ; 221C
        clc                                     ; 221D
        adc     #$89                            ; 221E
        sta     $43                             ; 2220
        jmp     L2705                           ; 2222

; ----------------------------------------------------------------------------
        jsr     L249B                           ; 2225
        lda     #$9C                            ; 2228
        jsr     L0FC2                           ; 222A
        cli                                     ; 222D
        lda     #$89                            ; 222E
        sta     $43                             ; 2230
        lda     #$EF                            ; 2232
        sta     $42                             ; 2234
        lda     #$CC                            ; 2236
        sta     buffer_zp40                     ; 2238
        lda     #$FF                            ; 223A
        sta     $41                             ; 223C
        lda     buffer_zp40                     ; 223E
        clc                                     ; 2240
        adc     $4A                             ; 2241
        sta     buffer_zp40                     ; 2243
        bcc     L2249                           ; 2245
        inc     $41                             ; 2247
L2249:  jmp     L2705                           ; 2249

; ----------------------------------------------------------------------------
L224C:  lda     $30                             ; 224C
        and     #$04                            ; 224E
        beq     L2253                           ; 2250
        inx                                     ; 2252
L2253:  stx     $43                             ; 2253
        rts                                     ; 2255

; ----------------------------------------------------------------------------
L2256:  lda     $4D                             ; 2256
        sec                                     ; 2258
        sbc     #$F8                            ; 2259
        sta     $54                             ; 225B
        lda     $4E                             ; 225D
        sbc     #$F8                            ; 225F
        sta     $55                             ; 2261
        ldx     #$04                            ; 2263
        jsr     right_shift_16bit_zp54_by_x     ; 2265
        lda     #$16                            ; 2268
        sec                                     ; 226A
        sbc     $45                             ; 226B
        pha                                     ; 226D
        lda     #$80                            ; 226E
        sbc     $46                             ; 2270
        tay                                     ; 2272
        pla                                     ; 2273
        jsr     L1744                           ; 2274
        lda     $47                             ; 2277
        cmp     #$04                            ; 2279
        bne     L2284                           ; 227B
        lda     #$C8                            ; 227D
        ldy     #$00                            ; 227F
        jsr     L178E                           ; 2281
L2284:  lda     $45                             ; 2284
        clc                                     ; 2286
        adc     #$0C                            ; 2287
        sta     L197F                           ; 2289
        lda     $46                             ; 228C
        adc     #$00                            ; 228E
        sta     L1980                           ; 2290
        lda     L197F                           ; 2293
        sec                                     ; 2296
        sbc     #$20                            ; 2297
        sta     $45                             ; 2299
        sta     L197D                           ; 229B
        lda     L1980                           ; 229E
        sbc     #$00                            ; 22A1
        sta     $46                             ; 22A3
        sta     L197E                           ; 22A5
        lda     #$00                            ; 22A8
        sec                                     ; 22AA
        sbc     $51                             ; 22AB
        sta     $51                             ; 22AD
        lda     #$00                            ; 22AF
        sbc     $52                             ; 22B1
        sta     $52                             ; 22B3
        lda     #$0C                            ; 22B5
        jsr     L25EB                           ; 22B7
        rts                                     ; 22BA

; ----------------------------------------------------------------------------
L22BB:  lda     #$08                            ; 22BB
        sec                                     ; 22BD
        sbc     $4D                             ; 22BE
        sta     $54                             ; 22C0
        lda     #$07                            ; 22C2
        sbc     $4E                             ; 22C4
        sta     $55                             ; 22C6
        ldx     #$04                            ; 22C8
        jsr     right_shift_16bit_zp54_by_x     ; 22CA
        lda     $45                             ; 22CD
        sec                                     ; 22CF
        sbc     #$16                            ; 22D0
        pha                                     ; 22D2
        lda     $46                             ; 22D3
        sbc     #$80                            ; 22D5
        tay                                     ; 22D7
        pla                                     ; 22D8
        jsr     L1744                           ; 22D9
        lda     $47                             ; 22DC
        cmp     #$05                            ; 22DE
        bne     L22E9                           ; 22E0
        lda     #$C8                            ; 22E2
        ldy     #$00                            ; 22E4
        jsr     L178E                           ; 22E6
L22E9:  lda     $45                             ; 22E9
        sec                                     ; 22EB
        sbc     #$0C                            ; 22EC
        sta     L1985                           ; 22EE
        lda     $46                             ; 22F1
        sbc     #$00                            ; 22F3
        sta     L1986                           ; 22F5
        lda     L1985                           ; 22F8
        clc                                     ; 22FB
        adc     #$20                            ; 22FC
        sta     $45                             ; 22FE
        sta     L1987                           ; 2300
        lda     L1986                           ; 2303
        adc     #$00                            ; 2306
        sta     $46                             ; 2308
        sta     L1988                           ; 230A
        lda     #$00                            ; 230D
        sec                                     ; 230F
        sbc     $51                             ; 2310
        sta     $51                             ; 2312
        lda     #$00                            ; 2314
        sbc     $52                             ; 2316
        sta     $52                             ; 2318
        lda     $45                             ; 231A
        bne     L2320                           ; 231C
        dec     $46                             ; 231E
L2320:  dec     $45                             ; 2320
        lda     #$0D                            ; 2322
        jsr     L25EB                           ; 2324
        rts                                     ; 2327

; ----------------------------------------------------------------------------
right_shift_16bit_zp54_by_x:
        lsr     $55                             ; 2328
        ror     $54                             ; 232A
        dex                                     ; 232C
        bne     right_shift_16bit_zp54_by_x     ; 232D
        rts                                     ; 232F

; ----------------------------------------------------------------------------
L2330:  lda     $4F                             ; 2330
        ora     $50                             ; 2332
        bne     L233E                           ; 2334
        lda     #$77                            ; 2336
        sta     $54                             ; 2338
        lda     #$01                            ; 233A
        sta     $55                             ; 233C
L233E:  lda     #$0F                            ; 233E
        sta     $45                             ; 2340
        lda     #$7F                            ; 2342
        sta     $46                             ; 2344
        lda     #$00                            ; 2346
        sec                                     ; 2348
        sbc     $51                             ; 2349
        sta     $51                             ; 234B
        lda     #$00                            ; 234D
        sbc     $52                             ; 234F
        sta     $52                             ; 2351
        lda     #$14                            ; 2353
        sta     $51                             ; 2355
        lda     #$05                            ; 2357
        sta     $52                             ; 2359
        lda     #$0E                            ; 235B
        jsr     L25EB                           ; 235D
        rts                                     ; 2360

; ----------------------------------------------------------------------------
L2361:  lda     $4F                             ; 2361
        ora     $50                             ; 2363
        bne     L236F                           ; 2365
        lda     #$77                            ; 2367
        sta     $54                             ; 2369
        lda     #$01                            ; 236B
        sta     $55                             ; 236D
L236F:  lda     #$14                            ; 236F
        sta     $45                             ; 2371
        lda     #$81                            ; 2373
        sta     $46                             ; 2375
        lda     #$00                            ; 2377
        sec                                     ; 2379
        sbc     $51                             ; 237A
        sta     $51                             ; 237C
        lda     #$00                            ; 237E
        sbc     $52                             ; 2380
        sta     $52                             ; 2382
        lda     #$EC                            ; 2384
        sta     $51                             ; 2386
        lda     #$FA                            ; 2388
        sta     $52                             ; 238A
        lda     #$0F                            ; 238C
        jsr     L25EB                           ; 238E
        rts                                     ; 2391

; ----------------------------------------------------------------------------
L2392:  lda     $53                             ; 2392
        bne     L23D6                           ; 2394
        lda     $79                             ; 2396
        and     #$08                            ; 2398
        bne     L23D6                           ; 239A
        ldx     #$01                            ; 239C
        lda     $51                             ; 239E
        cmp     #$38                            ; 23A0
        lda     $52                             ; 23A2
        sbc     #$FF                            ; 23A4
        bcc     L23B0                           ; 23A6
        lda     #$38                            ; 23A8
        sta     $51                             ; 23AA
        lda     #$FF                            ; 23AC
        sta     $52                             ; 23AE
L23B0:  ldx     #$02                            ; 23B0
        lda     $51                             ; 23B2
        cmp     #$F8                            ; 23B4
        lda     $52                             ; 23B6
        sbc     #$F8                            ; 23B8
        bcc     L23DD                           ; 23BA
        lda     $4D                             ; 23BC
        ora     $4D                             ; 23BE
        bne     L23CA                           ; 23C0
        lda     $51                             ; 23C2
        sta     $4D                             ; 23C4
        lda     $52                             ; 23C6
        sta     $4E                             ; 23C8
L23CA:  lda     $51                             ; 23CA
        cmp     #$0C                            ; 23CC
        lda     $52                             ; 23CE
        sbc     #$FE                            ; 23D0
        bcc     L23D7                           ; 23D2
        lda     #$00                            ; 23D4
L23D6:  rts                                     ; 23D6

; ----------------------------------------------------------------------------
L23D7:  lda     $47                             ; 23D7
        cmp     #$04                            ; 23D9
        bne     L23E9                           ; 23DB
L23DD:  lda     #$1A                            ; 23DD
        sta     $53                             ; 23DF
        lda     $52                             ; 23E1
        bmi     L23E7                           ; 23E3
        ldx     #$04                            ; 23E5
L23E7:  stx     $6C                             ; 23E7
L23E9:  lda     #$01                            ; 23E9
        rts                                     ; 23EB

; ----------------------------------------------------------------------------
L23EC:  lda     $53                             ; 23EC
        bne     L2430                           ; 23EE
        lda     $79                             ; 23F0
        and     #$04                            ; 23F2
        bne     L2430                           ; 23F4
        ldx     #$01                            ; 23F6
        lda     $51                             ; 23F8
        cmp     #$C8                            ; 23FA
        lda     $52                             ; 23FC
        sbc     #$00                            ; 23FE
        bcs     L240A                           ; 2400
        lda     #$C8                            ; 2402
        sta     $51                             ; 2404
        lda     #$00                            ; 2406
        sta     $52                             ; 2408
L240A:  ldx     #$02                            ; 240A
        lda     $51                             ; 240C
        cmp     #$08                            ; 240E
        lda     $52                             ; 2410
        sbc     #$07                            ; 2412
        bcs     L2437                           ; 2414
        lda     $4D                             ; 2416
        ora     $4E                             ; 2418
        bne     L2424                           ; 241A
        lda     $51                             ; 241C
        sta     $4D                             ; 241E
        lda     $52                             ; 2420
        sta     $4D                             ; 2422
L2424:  lda     $51                             ; 2424
        cmp     #$F4                            ; 2426
        lda     $52                             ; 2428
        sbc     #$01                            ; 242A
        bcs     L2431                           ; 242C
        lda     #$00                            ; 242E
L2430:  rts                                     ; 2430

; ----------------------------------------------------------------------------
L2431:  lda     $47                             ; 2431
        cmp     #$05                            ; 2433
        bne     L2443                           ; 2435
L2437:  lda     #$17                            ; 2437
        sta     $53                             ; 2439
        lda     $52                             ; 243B
        bpl     L2441                           ; 243D
        ldx     #$04                            ; 243F
L2441:  stx     $6C                             ; 2441
L2443:  lda     #$01                            ; 2443
        rts                                     ; 2445

; ----------------------------------------------------------------------------
L2446:  lda     $53                             ; 2446
        bne     L246F                           ; 2448
        lda     $45                             ; 244A
        cmp     #$60                            ; 244C
        lda     $46                             ; 244E
        sbc     #$7F                            ; 2450
        bcc     L246D                           ; 2452
        lda     $51                             ; 2454
        cmp     #$7C                            ; 2456
        lda     $52                             ; 2458
        sbc     #$FC                            ; 245A
        bcs     L246D                           ; 245C
        lda     $51                             ; 245E
        cmp     #$30                            ; 2460
        lda     $52                             ; 2462
        sbc     #$F8                            ; 2464
        bcc     L246D                           ; 2466
        lda     $79                             ; 2468
        and     #$10                            ; 246A
        rts                                     ; 246C

; ----------------------------------------------------------------------------
L246D:  lda     #$01                            ; 246D
L246F:  rts                                     ; 246F

; ----------------------------------------------------------------------------
L2470:  lda     $53                             ; 2470
        bne     L2499                           ; 2472
        lda     $45                             ; 2474
        cmp     #$CB                            ; 2476
        lda     $46                             ; 2478
        sbc     #$80                            ; 247A
        bcs     L2497                           ; 247C
        lda     $51                             ; 247E
        cmp     #$84                            ; 2480
        lda     $52                             ; 2482
        sbc     #$03                            ; 2484
        bcc     L2497                           ; 2486
        lda     $51                             ; 2488
        cmp     #$D0                            ; 248A
        lda     $52                             ; 248C
        sbc     #$07                            ; 248E
        bcs     L2497                           ; 2490
        lda     $79                             ; 2492
        and     #$10                            ; 2494
        rts                                     ; 2496

; ----------------------------------------------------------------------------
L2497:  lda     #$01                            ; 2497
L2499:  rts                                     ; 2499

; ----------------------------------------------------------------------------
L249A:  rts                                     ; 249A

; ----------------------------------------------------------------------------
L249B:  lda     game_state_function_table_index ; 249B
        cmp     #$05                            ; 249D
        bne     L249A                           ; 249F
        lda     $45                             ; 24A1
        cmp     #$C7                            ; 24A3
        lda     $46                             ; 24A5
        sbc     #$7F                            ; 24A7
        bcc     L249A                           ; 24A9
        lda     $45                             ; 24AB
        cmp     #$65                            ; 24AD
        lda     $46                             ; 24AF
        sbc     #$80                            ; 24B1
        bcs     L249A                           ; 24B3
        ldx     $6E                             ; 24B5
        beq     L2530                           ; 24B7
        lda     $1A                             ; 24B9
        beq     L24DC                           ; 24BB
        bmi     L24CF                           ; 24BD
        lda     $45                             ; 24BF
        clc                                     ; 24C1
        adc     #$04                            ; 24C2
        sta     $45                             ; 24C4
        lda     $46                             ; 24C6
        adc     #$00                            ; 24C8
        sta     $46                             ; 24CA
        jmp     L24DC                           ; 24CC

; ----------------------------------------------------------------------------
L24CF:  lda     $45                             ; 24CF
        sec                                     ; 24D1
        sbc     #$04                            ; 24D2
        sta     $45                             ; 24D4
        lda     $46                             ; 24D6
        sbc     #$00                            ; 24D8
        sta     $46                             ; 24DA
L24DC:  lda     $45                             ; 24DC
        sta     $1E                             ; 24DE
        lda     $46                             ; 24E0
        sta     $1F                             ; 24E2
        lda     $51                             ; 24E4
        cmp     #$90                            ; 24E6
        lda     $52                             ; 24E8
        sbc     #$01                            ; 24EA
        bcc     L24F8                           ; 24EC
        lda     $51                             ; 24EE
        cmp     #$70                            ; 24F0
        lda     $52                             ; 24F2
        sbc     #$FE                            ; 24F4
        bcc     L252F                           ; 24F6
L24F8:  lda     #$01                            ; 24F8
        sta     L12F9                           ; 24FA
L24FD:  ldx     $6E                             ; 24FD
        lda     L257E,x                         ; 24FF
        ora     $1D                             ; 2502
        sta     $1D                             ; 2504
        lda     $1D                             ; 2506
        cmp     #$03                            ; 2508
        bne     L252F                           ; 250A
        lda     #$00                            ; 250C
        sta     $51                             ; 250E
        sta     $52                             ; 2510
        lda     $76                             ; 2512
        bne     L252F                           ; 2514
        lda     $78                             ; 2516
        bne     L252F                           ; 2518
        lda     $6C                             ; 251A
        beq     L252B                           ; 251C
        lda     $6D                             ; 251E
        bne     L252B                           ; 2520
        lda     $081C                           ; 2522
        bne     L252B                           ; 2525
        lda     #$0F                            ; 2527
        bne     L252D                           ; 2529
L252B:  lda     #$0C                            ; 252B
L252D:  sta     game_state_function_table_index ; 252D
L252F:  rts                                     ; 252F

; ----------------------------------------------------------------------------
L2530:  lda     $51                             ; 2530
        cmp     #$90                            ; 2532
        lda     $52                             ; 2534
        sbc     #$01                            ; 2536
        bcc     L24FD                           ; 2538
        lda     $51                             ; 253A
        cmp     #$70                            ; 253C
        lda     $52                             ; 253E
        sbc     #$FE                            ; 2540
        bcs     L24FD                           ; 2542
        lda     $1D                             ; 2544
        beq     L252F                           ; 2546
        lda     $45                             ; 2548
        sec                                     ; 254A
        sbc     $1E                             ; 254B
        sta     $20                             ; 254D
        lda     $46                             ; 254F
        sbc     $1F                             ; 2551
        sta     $21                             ; 2553
        lda     #$14                            ; 2555
        cmp     $20                             ; 2557
        lda     #$00                            ; 2559
        sbc     $21                             ; 255B
        bcs     L2569                           ; 255D
        lda     $20                             ; 255F
        cmp     #$EC                            ; 2561
        lda     $21                             ; 2563
        sbc     #$FF                            ; 2565
        bcc     L252F                           ; 2567
L2569:  lda     #$04                            ; 2569
        ldy     $6C                             ; 256B
        beq     L257B                           ; 256D
        sta     $1C                             ; 256F
        lda     $1D                             ; 2571
        ora     #$02                            ; 2573
        sta     $1D                             ; 2575
        lda     $52                             ; 2577
        sta     $1A                             ; 2579
L257B:  jmp     L24FD                           ; 257B

; ----------------------------------------------------------------------------
L257E:  ora     ($02,x)                         ; 257E
L2580:  lda     $51                             ; 2580
        cmp     #$20                            ; 2582
        lda     $52                             ; 2584
        sbc     #$03                            ; 2586
        bcs     L258D                           ; 2588
        lda     #$00                            ; 258A
        rts                                     ; 258C

; ----------------------------------------------------------------------------
L258D:  lda     $51                             ; 258D
        cmp     #$E0                            ; 258F
        lda     $52                             ; 2591
        sbc     #$FC                            ; 2593
        bcc     L259A                           ; 2595
        lda     #$00                            ; 2597
        rts                                     ; 2599

; ----------------------------------------------------------------------------
L259A:  lda     #$01                            ; 259A
        rts                                     ; 259C

; ----------------------------------------------------------------------------
init_buffers_zp40_zp56:
        jsr     init_buffer_zp40                ; 259D
        jsr     swap_buffers_zp40_zp56          ; 25A0
        jsr     init_buffer_zp40                ; 25A3
        jmp     swap_buffers_zp40_zp56          ; 25A6

; ----------------------------------------------------------------------------
init_buffer_zp40:
        ldx     #$15                            ; 25A9
        lda     #$00                            ; 25AB
L25AD:  sta     buffer_zp40,x                   ; 25AD
        dex                                     ; 25AF
        bpl     L25AD                           ; 25B0
        lda     #$B1                            ; 25B2
        sta     $45                             ; 25B4
        lda     #$80                            ; 25B6
        sta     $46                             ; 25B8
        lda     #$0A                            ; 25BA
        jsr     L25EB                           ; 25BC
        lda     #$19                            ; 25BF
        sta     $7B                             ; 25C1
        lda     #$00                            ; 25C3
        sta     $51                             ; 25C5
        sta     $52                             ; 25C7
        lda     #$00                            ; 25C9
        sta     $6C                             ; 25CB
        sta     $54                             ; 25CD
        sta     $55                             ; 25CF
        sta     L170E                           ; 25D1
        sta     L170F                           ; 25D4
        sta     $53                             ; 25D7
        sta     $78                             ; 25D9
        sta     $4C                             ; 25DB
        sta     $6D                             ; 25DD
        sta     $1D                             ; 25DF
        sta     $1C                             ; 25E1
        sta     LF0AB                           ; 25E3
        sta     $1B                             ; 25E6
        sta     $1A                             ; 25E8
        rts                                     ; 25EA

; ----------------------------------------------------------------------------
L25EB:  sta     $47                             ; 25EB
        stx     L2619                           ; 25ED
        ldx     $6E                             ; 25F0
        bne     L25FA                           ; 25F2
        tax                                     ; 25F4
        lda     L261A,x                         ; 25F5
        sta     $47                             ; 25F8
L25FA:  ldx     L2619                           ; 25FA
        sta     $48                             ; 25FD
        lda     #$00                            ; 25FF
        sta     $49                             ; 2601
        lda     $48                             ; 2603
        asl     a                               ; 2605
        rol     $49                             ; 2606
        asl     a                               ; 2608
        rol     $49                             ; 2609
        asl     a                               ; 260B
        rol     $49                             ; 260C
        adc     #$1D                            ; 260E
        sta     $48                             ; 2610
        lda     #$19                            ; 2612
        adc     $49                             ; 2614
        sta     $49                             ; 2616
        rts                                     ; 2618

; ----------------------------------------------------------------------------
L2619:  brk                                     ; 2619
L261A:  brk                                     ; 261A
        ora     ($02,x)                         ; 261B
        .byte   $03                             ; 261D
        .byte   $04                             ; 261E
        ora     $06                             ; 261F
        .byte   $07                             ; 2621
        php                                     ; 2622
        ora     #$0A                            ; 2623
        .byte   $0B                             ; 2625
        .byte   $0C                             ; 2626
        ora     L0F0E                           ; 2627
        brk                                     ; 262A
        ora     ($02,x)                         ; 262B
        ora     #$08                            ; 262D
        .byte   $07                             ; 262F
        ora     $06                             ; 2630
        .byte   $07                             ; 2632
        .byte   $04                             ; 2633
        .byte   $03                             ; 2634
        .byte   $02                             ; 2635
swap_buffers_zp40_zp56:
        ldx     #$15                            ; 2636
L2638:  ldy     buffer_zp40,x                   ; 2638
        lda     buffer_zp56,x                   ; 263A
        sty     buffer_zp56,x                   ; 263C
        sta     buffer_zp40,x                   ; 263E
        dex                                     ; 2640
        bpl     L2638                           ; 2641
        rts                                     ; 2643

; ----------------------------------------------------------------------------
        dec     L2668                           ; 2644
        bpl     L2667                           ; 2647
        lda     #$00                            ; 2649
        sta     L2668                           ; 264B
        lda     $24                             ; 264E
        bne     L2667                           ; 2650
        inc     $24                             ; 2652
        jsr     call_function_at_index_zp2f     ; 2654
        lda     $1B                             ; 2657
        bne     L2665                           ; 2659
        inc     $1B                             ; 265B
        cli                                     ; 265D
        jsr     L0ADA                           ; 265E
        lda     #$00                            ; 2661
        sta     $1B                             ; 2663
L2665:  dec     $24                             ; 2665
L2667:  rts                                     ; 2667

; ----------------------------------------------------------------------------
L2668:  brk                                     ; 2668
call_function_at_index_zp2f:
        lda     game_state_function_table_index ; 2669
        asl     a                               ; 266B
        tay                                     ; 266C
        lda     function_pointer_table,y        ; 266D
        sta     smc_jsr_01+$01                  ; 2670
        lda     function_pointer_table+$01,y    ; 2673
        sta     smc_jsr_01+$02                  ; 2676
        cli                                     ; 2679
smc_jsr_01:
        .byte   $20                             ; 267A
        .byte   $FF                             ; 267B
        .byte   $FF                             ; 267C
        lda     game_state_function_table_index ; 267D
        sta     $7A                             ; 267F
        cmp     #$05                            ; 2681
        bne     L268D                           ; 2683
        lda     $6C                             ; 2685
        beq     L268D                           ; 2687
        lda     #$1F                            ; 2689
        bne     L2695                           ; 268B
L268D:  lda     #$00                            ; 268D
        sta     LDC02                           ; 268F
        lda     LDC00                           ; 2692
L2695:  sta     $79                             ; 2695
        lda     #$00                            ; 2697
        sta     $6E                             ; 2699
        jsr     L26AD                           ; 269B
        jsr     swap_buffers_zp40_zp56          ; 269E
        lda     $7A                             ; 26A1
        sta     game_state_function_table_index ; 26A3
        inc     $6E                             ; 26A5
        jsr     L26AD                           ; 26A7
        jmp     swap_buffers_zp40_zp56          ; 26AA

; ----------------------------------------------------------------------------
L26AD:  lda     game_state_function_table_index ; 26AD
        cmp     #$05                            ; 26AF
        bne     L26B9                           ; 26B1
        jsr     L0F06                           ; 26B3
        jsr     L0F6B                           ; 26B6
L26B9:  lda     game_state_function_table_index ; 26B9
        cmp     #$03                            ; 26BB
        bcs     L26C0                           ; 26BD
        rts                                     ; 26BF

; ----------------------------------------------------------------------------
L26C0:  ldy     #$00                            ; 26C0
        lda     $45                             ; 26C2
        sec                                     ; 26C4
        sbc     ($48),y                         ; 26C5
        sta     $4A                             ; 26C7
        lda     $46                             ; 26C9
        iny                                     ; 26CB
        sbc     ($48),y                         ; 26CC
        sta     $4B                             ; 26CE
        bcs     L26DC                           ; 26D0
        ldy     #$04                            ; 26D2
L26D4:  lda     ($48),y                         ; 26D4
        jsr     L25EB                           ; 26D6
        jmp     L26B9                           ; 26D9

; ----------------------------------------------------------------------------
L26DC:  iny                                     ; 26DC
        lda     $45                             ; 26DD
        cmp     ($48),y                         ; 26DF
        lda     $46                             ; 26E1
        iny                                     ; 26E3
        sbc     ($48),y                         ; 26E4
        bcc     L26EC                           ; 26E6
        ldy     #$05                            ; 26E8
        bne     L26D4                           ; 26EA
L26EC:  ldy     #$06                            ; 26EC
        lda     ($48),y                         ; 26EE
        sta     L26FE                           ; 26F0
        iny                                     ; 26F3
        lda     ($48),y                         ; 26F4
        sta     L26FF                           ; 26F6
        lda     #$00                            ; 26F9
        sta     $6F                             ; 26FB
        .byte   $20                             ; 26FD
L26FE:  .byte   $FF                             ; 26FE
L26FF:  .byte   $FF                             ; 26FF
        lda     $6F                             ; 2700
        bne     L26B9                           ; 2702
        rts                                     ; 2704

; ----------------------------------------------------------------------------
L2705:  lda     $43                             ; 2705
        cmp     #$B3                            ; 2707
        bcc     L270E                           ; 2709
        jmp     L2759                           ; 270B

; ----------------------------------------------------------------------------
L270E:  lda     $45                             ; 270E
        cmp     #$08                            ; 2710
        lda     $46                             ; 2712
        sbc     #$7F                            ; 2714
        bcc     L2722                           ; 2716
        lda     $45                             ; 2718
        cmp     #$24                            ; 271A
        lda     $46                             ; 271C
        sbc     #$81                            ; 271E
        bcc     L272E                           ; 2720
L2722:  lda     #$9C                            ; 2722
        sta     $42                             ; 2724
        lda     #$FA                            ; 2726
        sta     buffer_zp40                     ; 2728
        lda     #$00                            ; 272A
        sta     $41                             ; 272C
L272E:  jsr     L1327                           ; 272E
        ldy     L12F9                           ; 2731
        ldx     #$07                            ; 2734
L2736:  lda     L275A,x                         ; 2736
        sta     LE3F8,x                         ; 2739
        dex                                     ; 273C
        dey                                     ; 273D
        bne     L2736                           ; 273E
        lda     $6E                             ; 2740
        beq     L2759                           ; 2742
        lda     L12FA                           ; 2744
        clc                                     ; 2747
        adc     #$17                            ; 2748
        cmp     #$96                            ; 274A
        bcs     L2750                           ; 274C
        lda     #$96                            ; 274E
L2750:  cmp     #$E1                            ; 2750
        bcc     L2756                           ; 2752
        lda     #$E1                            ; 2754
L2756:  sta     L0A48                           ; 2756
L2759:  rts                                     ; 2759

; ----------------------------------------------------------------------------
L275A:  ldy     #$A1                            ; 275A
        ldx     #$A3                            ; 275C
        ldy     $A5                             ; 275E
        ldx     $A7                             ; 2760
print_string_at_pointer_zp72:
        ldy     #$00                            ; 2762
        lda     ($72),y                         ; 2764
        beq     L2773                           ; 2766
        jsr     print_char                      ; 2768
        inc     $72                             ; 276B
        bne     print_string_at_pointer_zp72    ; 276D
        inc     $73                             ; 276F
        bne     print_string_at_pointer_zp72    ; 2771
L2773:  rts                                     ; 2773

; ----------------------------------------------------------------------------
print_string_at_index_zp6c:
        cli                                     ; 2774
        lda     #$00                            ; 2775
        sta     cursor_color_maybe              ; 2777
        lda     #$C0                            ; 2779
        sta     cursor_position                 ; 277B
        lda     #$DC                            ; 277D
        sta     cursor_position+$01             ; 277F
        lda     $6C                             ; 2781
        asl     a                               ; 2783
        tax                                     ; 2784
        lda     string_pointer_table,x          ; 2785
        sta     $70                             ; 2788
        lda     string_pointer_table+$01,x      ; 278A
        sta     $71                             ; 278D
L278F:  ldy     #$01                            ; 278F
        lda     ($70),y                         ; 2791
        sta     $73                             ; 2793
        dey                                     ; 2795
        lda     ($70),y                         ; 2796
        sta     $72                             ; 2798
        ora     $73                             ; 279A
        beq     L27AE                           ; 279C
        jsr     print_string_at_pointer_zp72    ; 279E
        lda     $70                             ; 27A1
        clc                                     ; 27A3
        adc     #$02                            ; 27A4
        sta     $70                             ; 27A6
        bcc     L278F                           ; 27A8
        inc     $71                             ; 27AA
        bne     L278F                           ; 27AC
L27AE:  lda     cursor_color_maybe              ; 27AE
        cmp     #$1E                            ; 27B0
        bcs     L27BC                           ; 27B2
        lda     #$20                            ; 27B4
        jsr     print_char                      ; 27B6
        jmp     L27AE                           ; 27B9

; ----------------------------------------------------------------------------
L27BC:  rts                                     ; 27BC

; ----------------------------------------------------------------------------
error_messages:
        .byte   "TOO "                          ; 27BD
        .byte   $00                             ; 27C1
        .byte   "SOON "                         ; 27C2
        .byte   $00                             ; 27C7
        .byte   "SLOW "                         ; 27C8
        .byte   $00                             ; 27CD
        .byte   "LATE "                         ; 27CE
        .byte   $00                             ; 27D3
        .byte   "LOW "                          ; 27D4
        .byte   $00                             ; 27D8
        .byte   "HIGH "                         ; 27D9
        .byte   $00                             ; 27DE
        .byte   "EARLY."                        ; 27DF
        .byte   $00                             ; 27E5
        .byte   "KICK TURN."                    ; 27E6
                                                ; 27EE
        .byte   $00                             ; 27F0
        .byte   "HAND PLANT."                   ; 27F1
                                                ; 27F9
        .byte   $00                             ; 27FC
        .byte   "FOR "                          ; 27FD
        .byte   $00                             ; 2801
        .byte   "HELD ON "                      ; 2802
        .byte   $00                             ; 280A
        .byte   "LET GO "                       ; 280B
        .byte   $00                             ; 2812
        .byte   "LONG."                         ; 2813
        .byte   $00                             ; 2818
        .byte   "GAME OVER."                    ; 2819
                                                ; 2821
        .byte   $00                             ; 2823
        .byte   "CAN'T "                        ; 2824
        .byte   $00                             ; 282A
        .byte   "KICK TURN BACKWARDS."          ; 282B
                                                ; 2833
                                                ; 283B
        .byte   $00                             ; 283F
        .byte   "TURNED TOO LONG."              ; 2840
                                                ; 2848
        .byte   $00                             ; 2850
        .byte   "DIDN'T TURN IN TIME."          ; 2851
                                                ; 2859
                                                ; 2861
        .byte   $00                             ; 2865
L2866:  .byte   $19                             ; 2866
        .byte   "("                             ; 2867
        .byte   $00,$00                         ; 2868
L286A:  .byte   $BD                             ; 286A
        .byte   "'"                             ; 286B
        .byte   $C8                             ; 286C
        .byte   "'"                             ; 286D
        .byte   $FD                             ; 286E
        .byte   "'"                             ; 286F
        .byte   $E6                             ; 2870
        .byte   "'"                             ; 2871
        .byte   $00,$00                         ; 2872
L2874:  .byte   $BD                             ; 2874
        .byte   "'"                             ; 2875
        .byte   $C2                             ; 2876
        .byte   "'"                             ; 2877
        .byte   $FD                             ; 2878
        .byte   "'"                             ; 2879
        .byte   $E6                             ; 287A
        .byte   "'"                             ; 287B
        .byte   $00,$00                         ; 287C
L287E:  .byte   $BD                             ; 287E
        .byte   "'"                             ; 287F
        .byte   $D4                             ; 2880
        .byte   "'"                             ; 2881
        .byte   $FD                             ; 2882
        .byte   "'"                             ; 2883
        .byte   $E6                             ; 2884
        .byte   "'"                             ; 2885
        .byte   $00,$00                         ; 2886
L2888:  .byte   $BD                             ; 2888
        .byte   "'"                             ; 2889
        .byte   $CE                             ; 288A
        .byte   "'"                             ; 288B
        .byte   $FD                             ; 288C
        .byte   "'"                             ; 288D
        .byte   $E6                             ; 288E
        .byte   "'"                             ; 288F
        .byte   $00,$00                         ; 2890
L2892:  .byte   $BD                             ; 2892
        .byte   "'"                             ; 2893
        .byte   $C8                             ; 2894
        .byte   "'"                             ; 2895
        .byte   $FD                             ; 2896
        .byte   "'"                             ; 2897
        .byte   $F1                             ; 2898
        .byte   "'"                             ; 2899
        .byte   $00,$00                         ; 289A
L289C:  .byte   $BD                             ; 289C
        .byte   "'"                             ; 289D
        .byte   $C2                             ; 289E
        .byte   "'"                             ; 289F
        .byte   $FD                             ; 28A0
        .byte   "'"                             ; 28A1
        .byte   $F1                             ; 28A2
        .byte   "'"                             ; 28A3
        .byte   $00,$00                         ; 28A4
L28A6:  .byte   $BD                             ; 28A6
        .byte   "'"                             ; 28A7
        .byte   $D4                             ; 28A8
        .byte   "'"                             ; 28A9
        .byte   $FD                             ; 28AA
        .byte   "'"                             ; 28AB
        .byte   $F1                             ; 28AC
        .byte   "'"                             ; 28AD
        .byte   $00,$00                         ; 28AE
L28B0:  .byte   $BD                             ; 28B0
        .byte   "'"                             ; 28B1
        .byte   $CE                             ; 28B2
        .byte   "'"                             ; 28B3
        .byte   $FD                             ; 28B4
        .byte   "'"                             ; 28B5
        .byte   $F1                             ; 28B6
        .byte   "'"                             ; 28B7
        .byte   $00,$00                         ; 28B8
L28BA:  .byte   $BD                             ; 28BA
        .byte   "'"                             ; 28BB
        .byte   $D9                             ; 28BC
        .byte   "'"                             ; 28BD
        .byte   $FD                             ; 28BE
        .byte   "'"                             ; 28BF
        .byte   $F1                             ; 28C0
        .byte   "'"                             ; 28C1
        .byte   $00,$00                         ; 28C2
L28C4:  .byte   $02                             ; 28C4
        .byte   "("                             ; 28C5
        .byte   $BD                             ; 28C6
        .byte   "'"                             ; 28C7
        .byte   $13                             ; 28C8
        .byte   "("                             ; 28C9
        .byte   $00,$00                         ; 28CA
L28CC:  .byte   $0B                             ; 28CC
        .byte   "("                             ; 28CD
        .byte   $BD                             ; 28CE
        .byte   "'"                             ; 28CF
        .byte   $DF                             ; 28D0
        .byte   "'"                             ; 28D1
        .byte   $00,$00                         ; 28D2
L28D4:  .byte   "$(+("                          ; 28D4
        .byte   $00,$00                         ; 28D8
L28DA:  .byte   "@("                            ; 28DA
        .byte   $00,$00                         ; 28DC
L28DE:  .byte   "Q("                            ; 28DE
        .byte   $00,$00                         ; 28E0
; ----------------------------------------------------------------------------
string_pointer_table:
        .addr   L2866                           ; 28E2
        .addr   L286A                           ; 28E4
        .addr   L2874                           ; 28E6
        .addr   L287E                           ; 28E8
        .addr   L2888                           ; 28EA
        .addr   L2892                           ; 28EC
        .addr   L289C                           ; 28EE
        .addr   L28A6                           ; 28F0
        .addr   L28B0                           ; 28F2
        .addr   L28BA                           ; 28F4
        .addr   L28C4                           ; 28F6
        .addr   L28CC                           ; 28F8
        .addr   L28D4                           ; 28FA
        .addr   L28DA                           ; 28FC
        .addr   L28DE                           ; 28FE
; ----------------------------------------------------------------------------
L2900:  sei                                     ; 2900
        inc     border_color                    ; 2901
        jmp     L2900                           ; 2904

; ----------------------------------------------------------------------------
error_messages_2:
        .byte   "AME OVER."                     ; 2907
                                                ; 290F
        .byte   $00                             ; 2910
        .byte   "CAN'T "                        ; 2911
        .byte   $00                             ; 2917
        .byte   "KICK TURN BACKWARDS."          ; 2918
                                                ; 2920
                                                ; 2928
        .byte   $00                             ; 292C
        .byte   "TURNED TOO LONG."              ; 292D
                                                ; 2935
        .byte   $00                             ; 293D
        .byte   "DIDN'T TURN IN TIME."          ; 293E
                                                ; 2946
                                                ; 294E
; ----------------------------------------------------------------------------
        .byte   $00,$06,$29,$00,$00,$AA,$28,$B5 ; 2952
        .byte   $28,$EA,$28,$D3,$28,$00,$00,$AA ; 295A
        .byte   $28,$AF,$28,$EA,$28,$D3,$28,$00 ; 2962
        .byte   $00,$AA,$28,$C1,$28,$EA,$28,$D3 ; 296A
        .byte   $28,$00,$00,$AA,$28,$BB,$28,$EA ; 2972
        .byte   $28,$D3,$28,$00,$00,$AA,$28,$B5 ; 297A
        .byte   $28,$EA,$28,$DE,$28,$00,$00,$AA ; 2982
        .byte   $28,$AF,$28,$EA,$28,$DE,$28,$00 ; 298A
        .byte   $00,$AA,$28,$C1,$28,$EA,$28,$DE ; 2992
        .byte   $28,$00,$00,$AA,$28,$BB,$28,$EA ; 299A
        .byte   $28,$DE,$28,$00,$00,$AA,$28,$C6 ; 29A2
        .byte   $28,$EA,$28,$DE,$28,$00,$00,$EF ; 29AA
        .byte   $28,$AA,$28,$00,$29,$00,$00,$F8 ; 29B2
        .byte   $28,$AA,$28,$CC,$28,$00,$00,$11 ; 29BA
        .byte   $29,$18,$29,$00,$00,$2D,$29,$00 ; 29C2
        .byte   $00,$3E,$29,$00,$00,$53,$29,$57 ; 29CA
        .byte   $29,$61,$29,$6B,$29,$75,$29,$7F ; 29D2
        .byte   $29,$89,$29,$93,$29,$9D,$29,$A7 ; 29DA
        .byte   $29,$B1,$29,$B9,$29,$C1,$29,$C7 ; 29E2
        .byte   $29,$CB,$29,$78,$EE,$20,$D0,$4C ; 29EA
        .byte   $ED,$29,$00,$00,$00,$00,$00,$00 ; 29F2
        .byte   $00,$00,$00,$00,$00,$00         ; 29FA
blank_0:.byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 2A00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 2A08
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 2A10
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 2A18
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 2A20
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 2A28
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 2A30
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 2A38
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 2A40
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 2A48
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 2A50
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 2A58
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 2A60
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 2A68
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 2A70
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 2A78
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 2A80
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 2A88
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 2A90
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 2A98
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 2AA0
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 2AA8
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 2AB0
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 2AB8
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 2AC0
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 2AC8
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 2AD0
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 2AD8
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 2AE0
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 2AE8
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 2AF0
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 2AF8
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 2B00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 2B08
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 2B10
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 2B18
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 2B20
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 2B28
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 2B30
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 2B38
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 2B40
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 2B48
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 2B50
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 2B58
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 2B60
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 2B68
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 2B70
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 2B78
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 2B80
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 2B88
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 2B90
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 2B98
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 2BA0
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 2BA8
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 2BB0
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 2BB8
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 2BC0
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 2BC8
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 2BD0
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 2BD8
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 2BE0
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 2BE8
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 2BF0
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 2BF8
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 2C00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 2C08
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 2C10
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 2C18
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 2C20
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 2C28
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 2C30
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 2C38
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 2C40
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 2C48
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 2C50
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 2C58
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 2C60
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 2C68
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 2C70
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 2C78
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 2C80
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 2C88
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 2C90
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 2C98
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 2CA0
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 2CA8
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 2CB0
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 2CB8
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 2CC0
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 2CC8
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 2CD0
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 2CD8
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 2CE0
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 2CE8
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 2CF0
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 2CF8
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 2D00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 2D08
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 2D10
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 2D18
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 2D20
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 2D28
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 2D30
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 2D38
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 2D40
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 2D48
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 2D50
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 2D58
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 2D60
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 2D68
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 2D70
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 2D78
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 2D80
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 2D88
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 2D90
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 2D98
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 2DA0
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 2DA8
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 2DB0
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 2DB8
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 2DC0
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 2DC8
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 2DD0
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 2DD8
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 2DE0
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 2DE8
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 2DF0
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 2DF8
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 2E00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 2E08
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 2E10
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 2E18
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 2E20
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 2E28
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 2E30
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 2E38
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 2E40
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 2E48
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 2E50
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 2E58
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 2E60
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 2E68
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 2E70
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 2E78
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 2E80
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 2E88
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 2E90
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 2E98
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 2EA0
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 2EA8
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 2EB0
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 2EB8
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 2EC0
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 2EC8
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 2ED0
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 2ED8
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 2EE0
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 2EE8
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 2EF0
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 2EF8
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 2F00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 2F08
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 2F10
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 2F18
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 2F20
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 2F28
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 2F30
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 2F38
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 2F40
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 2F48
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 2F50
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 2F58
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 2F60
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 2F68
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 2F70
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 2F78
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 2F80
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 2F88
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 2F90
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 2F98
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 2FA0
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 2FA8
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 2FB0
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 2FB8
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 2FC0
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 2FC8
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 2FD0
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 2FD8
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 2FE0
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 2FE8
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 2FF0
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 2FF8
L3000:  .byte   $D0,$D0,$72,$14,$BC,$BC,$BC,$69 ; 3000
        .byte   $69,$18,$D6,$94,$57,$57,$20,$0B ; 3008
        .byte   $0B,$EE,$DA,$DA,$A6,$5A,$5A,$EB ; 3010
        .byte   $78,$00,$00,$00,$9C,$9C,$39,$D8 ; 3018
        .byte   $77,$77,$23,$BB,$5C,$5C,$5C,$FB ; 3020
        .byte   $FB,$9E,$9E,$72,$4D,$4D,$32,$23 ; 3028
        .byte   $23,$F8,$E4,$E4,$C8,$C8,$6E,$10 ; 3030
        .byte   $6E,$B2,$B2,$50,$F4,$F4,$A5,$4E ; 3038
        .byte   $F7,$9D,$39,$C1,$52,$DE,$83,$63 ; 3040
        .byte   $37,$ED,$7A,$4D,$3A,$3A,$3A,$69 ; 3048
        .byte   $FA,$A2,$8C,$7B,$6A,$62,$1B,$C7 ; 3050
        .byte   $4D,$F4,$7B,$3C,$04,$39,$E7,$78 ; 3058
        .byte   $14,$B6,$48,$AB,$1F,$9C,$18,$86 ; 3060
        .byte   $29,$D5,$59,$CC,$CC,$40,$C3,$45 ; 3068
        .byte   $B7,$76,$C3,$41,$CF,$64,$E8,$85 ; 3070
        .byte   $37,$E9,$E9,$86,$2F,$D8,$7B,$1E ; 3078
        .byte   $1E,$A2,$24,$A2,$A3,$A3,$35,$35 ; 3080
        .byte   $C4,$4C,$D9,$D9,$59,$59,$14,$14 ; 3088
        .byte   $B7,$42,$F0,$AD,$AD,$65,$65,$08 ; 3090
        .byte   $A3,$3E,$3E,$FC,$FC,$A0,$A0,$4D ; 3098
        .byte   $4D,$E2,$E2,$75,$75,$12,$12,$95 ; 30A0
        .byte   $15,$99,$40,$E0,$94,$46,$FD,$BD ; 30A8
        .byte   $60,$F8,$D3,$00                 ; 30B0
L30B4:  .byte   $02,$02,$03,$04,$04,$04,$04,$05 ; 30B4
        .byte   $05,$06,$06,$07,$08,$08,$09,$0A ; 30BC
        .byte   $0A,$0A,$0B,$0B,$0C,$0D,$0D,$0D ; 30C4
        .byte   $0E,$0F,$0F,$0F,$0F,$0F,$10,$10 ; 30CC
        .byte   $11,$11,$12,$12,$13,$13,$13,$13 ; 30D4
        .byte   $13,$14,$14,$15,$16,$16,$17,$18 ; 30DC
        .byte   $18,$18,$19,$19,$1A,$1A,$1B,$1C ; 30E4
        .byte   $1B,$1C,$1C,$1D,$1D,$1D,$1E,$1F ; 30EC
        .byte   $1F,$20,$21,$21,$22,$22,$23,$24 ; 30F4
        .byte   $25,$25,$26,$27,$28,$28,$28,$05 ; 30FC
        .byte   $28,$29,$2A,$2B,$2C,$2D,$2E,$2E ; 3104
        .byte   $2F,$2F,$30,$31,$32,$10,$32,$33 ; 310C
        .byte   $34,$34,$35,$35,$36,$36,$37,$37 ; 3114
        .byte   $38,$38,$39,$39,$39,$3A,$3A,$3B ; 311C
        .byte   $3B,$3C,$3A,$3D,$3D,$3E,$3E,$3F ; 3124
        .byte   $40,$40,$40,$41,$42,$42,$43,$44 ; 312C
        .byte   $44,$44,$45,$44,$45,$45,$46,$46 ; 3134
        .byte   $46,$47,$47,$47,$48,$48,$49,$49 ; 313C
        .byte   $49,$4A,$4A,$4B,$4B,$4C,$4C,$4D ; 3144
        .byte   $4D,$4E,$4E,$4E,$4E,$4F,$4F,$50 ; 314C
        .byte   $50,$50,$50,$51,$51,$52,$52,$52 ; 3154
        .byte   $53,$53,$54,$54,$55,$56,$56,$57 ; 315C
        .byte   $58,$58,$59,$00                 ; 3164
L3168:  .byte   $00,$00,$00,$00,$00,$FF,$FA,$00 ; 3168
        .byte   $FC,$00,$00,$00,$00,$F6,$00,$00 ; 3170
        .byte   $65,$00,$00,$F5,$00,$00,$F8,$00 ; 3178
        .byte   $00,$00,$FB,$FA,$00,$FE,$00,$00 ; 3180
        .byte   $00,$01,$00,$00,$00,$01,$06,$00 ; 3188
        .byte   $0E,$00,$08,$00,$00,$0B,$00,$00 ; 3190
        .byte   $9B,$00,$00,$0A,$00,$09,$00,$00 ; 3198
        .byte   $0D,$00,$04,$00,$00,$00,$00,$00 ; 31A0
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 31A8
        .byte   $00,$00,$00,$00,$00,$F4,$DF,$F6 ; 31B0
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 31B8
        .byte   $00,$00,$00,$00,$00,$2F,$00,$00 ; 31C0
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 31C8
        .byte   $00,$00,$00,$00,$0A,$00,$00,$00 ; 31D0
        .byte   $00,$00,$1B,$00,$00,$00,$00,$00 ; 31D8
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 31E0
        .byte   $FD,$00,$00,$F0,$00,$F8,$00,$F6 ; 31E8
        .byte   $00,$00,$00,$FA,$00,$F7,$00,$F8 ; 31F0
        .byte   $00,$00,$00,$00,$FF,$00,$FE,$00 ; 31F8
        .byte   $00,$00,$01,$00,$02,$00,$01,$00 ; 3200
        .byte   $04,$00,$0D,$00,$06,$00,$0B,$00 ; 3208
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 3210
        .byte   $00,$00,$00,$00                 ; 3218
L321C:  .byte   $00,$08,$00,$00,$00,$07,$0F,$00 ; 321C
        .byte   $06,$00,$00,$00,$00,$01,$00,$00 ; 3224
        .byte   $FF,$00,$00,$FF,$00,$00,$FB,$00 ; 322C
        .byte   $00,$00,$F8,$EE,$00,$F8,$00,$00 ; 3234
        .byte   $00,$08,$00,$00,$00,$0A,$13,$00 ; 323C
        .byte   $0B,$00,$05,$00,$00,$01,$00,$00 ; 3244
        .byte   $01,$00,$00,$FF,$00,$FF,$00,$00 ; 324C
        .byte   $F5,$00,$F8,$00,$00,$F8,$00,$00 ; 3254
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 325C
        .byte   $00,$00,$00,$00,$00,$00,$04,$E3 ; 3264
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 326C
        .byte   $00,$00,$00,$00,$00,$1C,$00,$00 ; 3274
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 327C
        .byte   $00,$00,$00,$00,$FC,$00,$00,$00 ; 3284
        .byte   $00,$00,$E3,$00,$00,$00,$00,$00 ; 328C
        .byte   $00,$00,$08,$00,$00,$00,$00,$00 ; 3294
        .byte   $07,$00,$00,$0C,$00,$02,$00,$03 ; 329C
        .byte   $00,$00,$00,$FE,$00,$FE,$00,$FB ; 32A4
        .byte   $00,$00,$00,$00,$F6,$00,$F8,$00 ; 32AC
        .byte   $00,$00,$08,$00,$08,$00,$0A,$00 ; 32B4
        .byte   $07,$00,$06,$00,$06,$00,$01,$00 ; 32BC
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 32C4
        .byte   $00,$00,$00,$FF                 ; 32CC
packed_player_sprites:
        .byte   $04,$23,$30,$00,$00,$48,$00,$00 ; 32D0
        .byte   $7F,$00,$00,$7E,$00,$00,$7E,$00 ; 32D8
        .byte   $00,$7E,$00,$00,$FC,$00,$00,$E0 ; 32E0
        .byte   $00,$00,$C0,$00,$00,$40,$07,$35 ; 32E8
        .byte   $30,$00,$00,$30,$00,$00,$30,$00 ; 32F0
        .byte   $00,$70,$04,$0D,$50,$00,$00,$65 ; 32F8
        .byte   $00,$00,$AA,$4C,$00,$AA,$9C,$00 ; 3300
        .byte   $2A,$9C,$00,$3F,$AC,$00,$3F,$30 ; 3308
        .byte   $00,$3F,$00,$00,$3F,$00,$00,$17 ; 3310
        .byte   $00,$00,$95,$00,$00,$99,$50,$00 ; 3318
        .byte   $AA,$AC,$00,$2A,$9C,$00,$00,$1C ; 3320
        .byte   $00,$00,$3C,$00,$00,$30,$88,$06 ; 3328
        .byte   $00,$00,$05,$00,$00,$1A,$3F,$00 ; 3330
        .byte   $60,$FF,$C1,$A0,$FF,$C6,$00,$FD ; 3338
        .byte   $C5,$58,$F5,$55,$6A,$D5,$55,$6A ; 3340
        .byte   $D5,$65,$AA,$DD,$65,$AA,$C9,$85 ; 3348
        .byte   $A8,$00,$06,$00,$00,$02,$00,$00 ; 3350
        .byte   $01,$80,$00,$01,$80,$00,$00,$80 ; 3358
        .byte   $00,$00,$80,$00,$00,$60,$00,$00 ; 3360
        .byte   $10,$88,$A1,$89,$A8,$8C,$A7,$87 ; 3368
        .byte   $95,$86,$04,$20,$00,$40,$00,$01 ; 3370
        .byte   $C0,$00,$03,$00,$00,$03,$C0,$00 ; 3378
        .byte   $03,$E0,$00,$03,$C0,$00,$0F,$80 ; 3380
        .byte   $00,$0F,$00,$00,$7E,$00,$00,$78 ; 3388
        .byte   $00,$00,$60,$07,$26,$08,$00,$00 ; 3390
        .byte   $0C,$00,$00,$0E,$00,$00,$1C,$00 ; 3398
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 33A0
        .byte   $00,$00,$70,$00,$00,$10,$04,$13 ; 33A8
        .byte   $04,$0C,$00,$25,$4F,$00,$2A,$97 ; 33B0
        .byte   $00,$2A,$A7,$00,$0E,$AB,$00,$0F ; 33B8
        .byte   $28,$00,$0F,$00,$00,$17,$00,$00 ; 33C0
        .byte   $95,$00,$00,$99,$50,$00,$AA,$AC ; 33C8
        .byte   $00,$2A,$9C,$00,$00,$1C,$00,$00 ; 33D0
        .byte   $3C,$00,$00,$30,$88,$12,$3F,$00 ; 33D8
        .byte   $15,$FF,$C0,$6A,$FF,$C1,$A0,$FD ; 33E0
        .byte   $D5,$80,$F5,$55,$80,$D5,$55,$AC ; 33E8
        .byte   $D5,$65,$AC,$DD,$66,$AC,$C9,$96 ; 33F0
        .byte   $AC,$00,$2A,$BC,$00,$28,$00,$00 ; 33F8
        .byte   $0A,$00,$00,$02,$80,$00,$00,$80 ; 3400
        .byte   $00,$00,$20,$88,$9D,$98,$A4,$9C ; 3408
        .byte   $A5,$99,$96,$98,$04,$20,$00,$40 ; 3410
        .byte   $00,$01,$C0,$00,$03,$00,$00,$03 ; 3418
        .byte   $C0,$00,$03,$E0,$00,$03,$C0,$00 ; 3420
        .byte   $0F,$80,$00,$0F,$00,$00,$7E,$00 ; 3428
        .byte   $00,$78,$00,$00,$60,$07,$26,$08 ; 3430
        .byte   $00,$00,$0C,$00,$00,$0E,$00,$00 ; 3438
        .byte   $1C,$00,$00,$00,$00,$00,$00,$00 ; 3440
        .byte   $00,$00,$00,$00,$70,$00,$00,$10 ; 3448
        .byte   $04,$13,$04,$0C,$00,$25,$4F,$00 ; 3450
        .byte   $2A,$97,$00,$2A,$A7,$00,$02,$AB ; 3458
        .byte   $00,$00,$28,$00,$00,$00,$00,$14 ; 3460
        .byte   $00,$00,$95,$00,$00,$99,$50,$00 ; 3468
        .byte   $AA,$AC,$00,$2A,$9C,$00,$00,$1C ; 3470
        .byte   $00,$00,$3C,$00,$00,$30,$88,$0C ; 3478
        .byte   $3F,$C0,$00,$FF,$F0,$00,$FF,$F0 ; 3480
        .byte   $55,$15,$F1,$AA,$2A,$76,$80,$37 ; 3488
        .byte   $56,$00,$15,$76,$00,$19,$66,$BF ; 3490
        .byte   $05,$96,$BF,$00,$9A,$BF,$00,$5A ; 3498
        .byte   $BF,$00,$AA,$FC,$00,$A0,$00,$00 ; 34A0
        .byte   $28,$00,$00,$0A,$00,$00,$02,$00 ; 34A8
        .byte   $00,$00,$80,$88,$9D,$A0,$A4,$A4 ; 34B0
        .byte   $A5,$A1,$96,$9E,$04,$26,$01,$00 ; 34B8
        .byte   $00,$01,$00,$00,$07,$80,$00,$0F ; 34C0
        .byte   $C0,$00,$1E,$00,$00,$E4,$00,$00 ; 34C8
        .byte   $C0,$00,$00,$80,$00,$00,$E0,$04 ; 34D0
        .byte   $20,$00,$C0,$00,$00,$C0,$00,$00 ; 34D8
        .byte   $C0,$00,$00,$C0,$00,$00,$E0,$00 ; 34E0
        .byte   $01,$F0,$00,$03,$F8,$00,$8F,$F0 ; 34E8
        .byte   $00,$FF,$80,$00,$C3,$00,$00,$C0 ; 34F0
        .byte   $07,$16,$00,$40,$00,$02,$50,$00 ; 34F8
        .byte   $02,$94,$00,$02,$A4,$C0,$00,$A9 ; 3500
        .byte   $C0,$00,$0B,$C0,$14,$03,$00,$95 ; 3508
        .byte   $00,$00,$9A,$50,$00,$AA,$AC,$00 ; 3510
        .byte   $2A,$9C,$00,$00,$1C,$00,$00,$3C ; 3518
        .byte   $00,$00,$30,$88,$04,$3F,$C0,$04 ; 3520
        .byte   $FF,$F0,$58,$FF,$F1,$A0,$15,$F5 ; 3528
        .byte   $80,$2A,$76,$00,$37,$54,$00,$15 ; 3530
        .byte   $74,$00,$19,$74,$00,$05,$A4,$00 ; 3538
        .byte   $0A,$94,$00,$06,$96,$00,$05,$5A ; 3540
        .byte   $00,$06,$AA,$80,$06,$2B,$FC,$06 ; 3548
        .byte   $0F,$FC,$06,$0F,$F0,$01,$8F,$C0 ; 3550
        .byte   $01,$80,$00,$01,$80,$00,$00,$60 ; 3558
        .byte   $88,$9F,$AB,$99,$A5,$9F,$AA,$95 ; 3560
        .byte   $A2,$05,$32,$00,$7E,$00,$01,$FE ; 3568
        .byte   $00,$FF,$FE,$00,$3F,$80,$00,$0C ; 3570
        .byte   $04,$2B,$00,$03,$E0,$00,$0F,$F0 ; 3578
        .byte   $10,$1F,$E0,$38,$7F,$80,$77,$FF ; 3580
        .byte   $00,$13,$FE,$00,$00,$F8,$07,$18 ; 3588
        .byte   $00,$80,$00,$01,$A0,$00,$06,$80 ; 3590
        .byte   $00,$0A,$00,$00,$18,$01,$00,$20 ; 3598
        .byte   $01,$80,$40,$02,$A0,$00,$02,$A0 ; 35A0
        .byte   $00,$00,$A8,$00,$00,$27,$00,$00 ; 35A8
        .byte   $07,$00,$00,$0F,$00,$00,$0F,$88 ; 35B0
        .byte   $19,$01,$50,$00,$01,$55,$00,$01 ; 35B8
        .byte   $95,$40,$02,$AA,$50,$02,$80,$94 ; 35C0
        .byte   $0A,$C0,$28,$0B,$F5,$00,$3F,$F5 ; 35C8
        .byte   $40,$BF,$FE,$40,$FF,$FF,$00,$FF ; 35D0
        .byte   $EC,$00,$FC,$2C,$00,$30,$30,$88 ; 35D8
        .byte   $13,$0F,$F0,$00,$3F,$FC,$00,$3F ; 35E0
        .byte   $FC,$00,$35,$7C,$00,$0A,$9C,$00 ; 35E8
        .byte   $0D,$D4,$00,$05,$5C,$00,$06,$50 ; 35F0
        .byte   $00,$09,$A4,$00,$0A,$95,$00,$2A ; 35F8
        .byte   $56,$00,$A9,$5A,$00,$29,$60,$00 ; 3600
        .byte   $02,$A0,$00,$00,$A0,$88,$97,$C2 ; 3608
        .byte   $90,$BB,$88,$C0,$97,$BC,$90,$B4 ; 3610
        .byte   $05,$34,$00,$F8,$00,$FF,$FC,$00 ; 3618
        .byte   $3F,$FC,$00,$0C,$3C,$04,$2B,$00 ; 3620
        .byte   $03,$F0,$00,$0F,$F8,$30,$1F,$F0 ; 3628
        .byte   $78,$7F,$80,$F7,$FF,$00,$13,$FC ; 3630
        .byte   $00,$01,$F0,$07,$15,$00,$24,$00 ; 3638
        .byte   $00,$68,$00,$01,$A8,$00,$1A,$85 ; 3640
        .byte   $00,$64,$06,$00,$00,$0A,$00,$00 ; 3648
        .byte   $0A,$80,$00,$02,$80,$00,$02,$80 ; 3650
        .byte   $00,$00,$A0,$00,$00,$B0,$00,$00 ; 3658
        .byte   $70,$00,$01,$F0,$00,$03,$C0,$88 ; 3660
        .byte   $0B,$00,$54,$00,$00,$55,$40,$00 ; 3668
        .byte   $65,$50,$00,$AA,$90,$00,$A8,$94 ; 3670
        .byte   $26,$A8,$24,$AA,$A8,$25,$6A,$A8 ; 3678
        .byte   $25,$AF,$AA,$04,$BF,$AA,$00,$7F ; 3680
        .byte   $FA,$C0,$BF,$0B,$C0,$AC,$0F,$C0 ; 3688
        .byte   $A8,$00,$00,$08,$00,$00,$08,$00 ; 3690
        .byte   $00,$0B,$00,$00,$0F,$88,$13,$03 ; 3698
        .byte   $FC,$00,$0F,$FF,$00,$0F,$FF,$00 ; 36A0
        .byte   $01,$7F,$00,$02,$9F,$00,$01,$D7 ; 36A8
        .byte   $00,$01,$5F,$00,$02,$5C,$00,$09 ; 36B0
        .byte   $69,$00,$2A,$A5,$40,$6A,$95,$80 ; 36B8
        .byte   $A1,$56,$80,$82,$58,$00,$02,$A8 ; 36C0
        .byte   $00,$00,$A0,$88,$8A,$CE,$84,$C7 ; 36C8
        .byte   $7A,$CC,$88,$C7,$84,$C0,$05,$34 ; 36D0
        .byte   $00,$F8,$00,$FF,$FC,$00,$3F,$FC ; 36D8
        .byte   $00,$0C,$3C,$04,$2B,$00,$03,$F0 ; 36E0
        .byte   $00,$0F,$F8,$30,$1F,$F0,$78,$7F ; 36E8
        .byte   $80,$F7,$FF,$00,$13,$F8,$00,$01 ; 36F0
        .byte   $C0,$07,$15,$00,$24,$00,$00,$68 ; 36F8
        .byte   $00,$01,$A8,$00,$1A,$85,$00,$64 ; 3700
        .byte   $06,$00,$00,$0A,$00,$00,$0A,$80 ; 3708
        .byte   $00,$02,$80,$00,$02,$80,$00,$00 ; 3710
        .byte   $A0,$00,$00,$B0,$00,$00,$70,$00 ; 3718
        .byte   $01,$F0,$00,$03,$C0,$88,$0B,$00 ; 3720
        .byte   $54,$00,$00,$55,$40,$00,$65,$50 ; 3728
        .byte   $00,$AA,$90,$00,$A8,$94,$26,$A8 ; 3730
        .byte   $24,$AA,$A8,$25,$6A,$A8,$25,$AF ; 3738
        .byte   $AA,$04,$BF,$AA,$00,$7F,$FA,$C0 ; 3740
        .byte   $BF,$0B,$C0,$AC,$0F,$C0,$A8,$00 ; 3748
        .byte   $00,$08,$00,$00,$08,$00,$00,$0B ; 3750
        .byte   $00,$00,$0F,$88,$13,$03,$FC,$00 ; 3758
        .byte   $0F,$FF,$00,$0F,$FF,$00,$01,$7F ; 3760
        .byte   $00,$02,$9F,$00,$01,$D7,$00,$01 ; 3768
        .byte   $5F,$00,$02,$5C,$00,$09,$69,$00 ; 3770
        .byte   $2A,$A5,$40,$6A,$95,$80,$A1,$56 ; 3778
        .byte   $80,$82,$58,$00,$02,$A8,$00,$00 ; 3780
        .byte   $A0,$88,$83,$D4,$7D,$CD,$73,$D2 ; 3788
        .byte   $81,$CD,$7D,$C6,$05,$28,$04,$00 ; 3790
        .byte   $00,$0F,$83,$00,$1F,$FF,$00,$3E ; 3798
        .byte   $7F,$00,$FC,$FE,$00,$18,$FE,$00 ; 37A0
        .byte   $0C,$FC,$00,$00,$40,$04,$22,$C0 ; 37A8
        .byte   $00,$00,$E0,$00,$00,$78,$3E,$00 ; 37B0
        .byte   $3F,$FF,$80,$1F,$F9,$E0,$0F,$F8 ; 37B8
        .byte   $80,$0F,$F0,$00,$1F,$E0,$00,$2F ; 37C0
        .byte   $C0,$00,$03,$80,$07,$17,$03,$C0 ; 37C8
        .byte   $00,$03,$FF,$00,$0F,$C0,$00,$0F ; 37D0
        .byte   $E8,$00,$3F,$EA,$00,$FF,$AA,$00 ; 37D8
        .byte   $6A,$2A,$C0,$6C,$29,$F0,$A8,$09 ; 37E0
        .byte   $F0,$2A,$03,$C0,$0B,$C0,$00,$07 ; 37E8
        .byte   $C0,$00,$0F,$00,$00,$0C,$88,$07 ; 37F0
        .byte   $3F,$C0,$00,$FF,$F0,$00,$FF,$F0 ; 37F8
        .byte   $00,$17,$F0,$00,$29,$F0,$00,$1D ; 3800
        .byte   $F0,$00,$15,$70,$00,$A5,$F0,$00 ; 3808
        .byte   $95,$C0,$00,$A9,$50,$00,$55,$54 ; 3810
        .byte   $00,$55,$69,$00,$55,$A5,$40,$55 ; 3818
        .byte   $AA,$90,$55,$A1,$50,$56,$95,$60 ; 3820
        .byte   $5A,$AA,$80,$AA,$80,$00,$FF,$C0 ; 3828
        .byte   $88,$25,$60,$00,$00,$94,$00,$00 ; 3830
        .byte   $09,$40,$00,$02,$9A,$00,$00,$A6 ; 3838
        .byte   $00,$00,$25,$00,$00,$09,$00,$00 ; 3840
        .byte   $02,$00,$00,$02,$88,$79,$D4,$7B ; 3848
        .byte   $CB,$78,$D4,$7E,$C4,$6E,$C7,$05 ; 3850
        .byte   $2B,$06,$00,$00,$0F,$83,$00,$3D ; 3858
        .byte   $FF,$00,$7E,$3F,$00,$1C,$FE,$00 ; 3860
        .byte   $09,$FC,$00,$01,$88,$04,$1C,$F0 ; 3868
        .byte   $00,$00,$C0,$00,$00,$80,$00,$00 ; 3870
        .byte   $60,$3E,$00,$3F,$FF,$80,$3F,$FF ; 3878
        .byte   $E0,$3F,$F8,$C0,$3F,$F0,$00,$3F ; 3880
        .byte   $E0,$00,$3F,$C0,$00,$3F,$80,$00 ; 3888
        .byte   $0F,$80,$07,$17,$00,$F0,$00,$03 ; 3890
        .byte   $F0,$00,$03,$F0,$00,$0F,$F0,$00 ; 3898
        .byte   $3F,$E0,$00,$2A,$BC,$00,$1B,$3A ; 38A0
        .byte   $00,$2A,$1A,$00,$2A,$2A,$80,$0A ; 38A8
        .byte   $03,$F0,$0A,$01,$F0,$3F,$03,$00 ; 38B0
        .byte   $D7,$00,$00,$FC,$88,$08,$3F,$C0 ; 38B8
        .byte   $00,$FF,$F0,$00,$FF,$F0,$00,$17 ; 38C0
        .byte   $F0,$00,$29,$F0,$00,$1D,$F0,$00 ; 38C8
        .byte   $15,$70,$00,$A5,$F0,$00,$95,$C0 ; 38D0
        .byte   $00,$A9,$50,$00,$55,$54,$00,$55 ; 38D8
        .byte   $55,$00,$55,$A5,$00,$56,$89,$40 ; 38E0
        .byte   $56,$02,$90,$5A,$01,$50,$58,$05 ; 38E8
        .byte   $A0,$58,$0A,$00,$FC,$88,$21,$59 ; 38F0
        .byte   $56,$80,$26,$AA,$80,$00,$29,$80 ; 38F8
        .byte   $00,$0A,$40,$00,$00,$40,$00,$00 ; 3900
        .byte   $40,$00,$00,$40,$00,$00,$40,$00 ; 3908
        .byte   $00,$40,$00,$00,$40,$88,$73,$D5 ; 3910
        .byte   $78,$CA,$72,$D5,$7C,$C4,$6A,$CA ; 3918
        .byte   $05,$25,$00,$06,$00,$0F,$FF,$00 ; 3920
        .byte   $1F,$FF,$00,$3E,$3F,$00,$7F,$BF ; 3928
        .byte   $00,$FF,$1F,$00,$1C,$1F,$00,$08 ; 3930
        .byte   $10,$80,$00,$10,$04,$1F,$0E,$00 ; 3938
        .byte   $60,$3E,$00,$F0,$FF,$01,$C0,$3F ; 3940
        .byte   $FF,$80,$08,$FF,$80,$03,$FF,$00 ; 3948
        .byte   $07,$FE,$00,$07,$FE,$00,$07,$FC ; 3950
        .byte   $00,$07,$F8,$00,$07,$F8,$07,$0A ; 3958
        .byte   $02,$AC,$00,$03,$FC,$00,$03,$FF ; 3960
        .byte   $00,$03,$FF,$00,$0F,$FF,$00,$0B ; 3968
        .byte   $FF,$00,$2A,$0A,$00,$BC,$0A,$00 ; 3970
        .byte   $6C,$0A,$C0,$6A,$09,$80,$AA,$01 ; 3978
        .byte   $A0,$2A,$80,$A0,$0A,$80,$A0,$02 ; 3980
        .byte   $A0,$20,$00,$AC,$3C,$01,$7C,$1C ; 3988
        .byte   $05,$FC,$FC,$0F,$C0,$88,$0B,$FC ; 3990
        .byte   $00,$00,$FF,$00,$00,$FF,$01,$00 ; 3998
        .byte   $5F,$01,$00,$A7,$01,$40,$75,$0A ; 39A0
        .byte   $00,$57,$26,$00,$97,$58,$00,$59 ; 39A8
        .byte   $90,$00,$A9,$A0,$00,$A5,$80,$00 ; 39B0
        .byte   $55,$00,$00,$54,$00,$00,$54,$00 ; 39B8
        .byte   $00,$54,$00,$00,$50,$00,$00,$50 ; 39C0
        .byte   $00,$00,$40,$88,$0C,$00,$00,$0C ; 39C8
        .byte   $00,$00,$3C,$00,$00,$3C,$00,$00 ; 39D0
        .byte   $04,$00,$00,$08,$00,$00,$0C,$00 ; 39D8
        .byte   $00,$04,$00,$01,$A8,$00,$05,$68 ; 39E0
        .byte   $00,$0A,$58,$00,$1A,$A4,$00,$5A ; 39E8
        .byte   $A8,$01,$A0,$A8,$1A,$80,$A8,$64 ; 39F0
        .byte   $00,$A4,$00,$00,$94,$00,$00,$D8 ; 39F8
        .byte   $88,$5D,$D6,$5D,$CB,$5C,$D5,$67 ; 3A00
        .byte   $C4,$51,$C4,$05,$2B,$20,$00,$00 ; 3A08
        .byte   $70,$00,$00,$FF,$F8,$00,$FC,$3C ; 3A10
        .byte   $00,$FE,$FE,$00,$7F,$3F,$00,$21 ; 3A18
        .byte   $18,$04,$22,$08,$00,$00,$30,$01 ; 3A20
        .byte   $80,$F8,$07,$80,$FE,$1E,$00,$33 ; 3A28
        .byte   $FE,$00,$07,$FC,$00,$07,$F8,$00 ; 3A30
        .byte   $07,$F8,$00,$07,$F0,$00,$0F,$E0 ; 3A38
        .byte   $07,$06,$00,$AA,$00,$00,$AA,$00 ; 3A40
        .byte   $00,$AA,$00,$00,$AA,$00,$02,$AA ; 3A48
        .byte   $00,$03,$FE,$00,$03,$FF,$00,$02 ; 3A50
        .byte   $FF,$00,$03,$FF,$C0,$03,$FE,$C0 ; 3A58
        .byte   $03,$A0,$E0,$01,$40,$50,$0A,$42 ; 3A60
        .byte   $90,$0A,$82,$A0,$0A,$02,$80,$0A ; 3A68
        .byte   $02,$80,$26,$0D,$40,$5C,$0F,$50 ; 3A70
        .byte   $FC,$03,$F0,$88,$0E,$FC,$00,$00 ; 3A78
        .byte   $FF,$00,$00,$FF,$00,$00,$5F,$00 ; 3A80
        .byte   $00,$A7,$00,$00,$75,$00,$94,$57 ; 3A88
        .byte   $26,$60,$97,$9A,$80,$5A,$68,$00 ; 3A90
        .byte   $A9,$A0,$00,$A5,$80,$00,$55,$00 ; 3A98
        .byte   $00,$55,$00,$00,$54,$00,$00,$54 ; 3AA0
        .byte   $00,$00,$50,$00,$00,$50,$88,$0C ; 3AA8
        .byte   $00,$00,$30,$00,$00,$F0,$00,$00 ; 3AB0
        .byte   $F0,$00,$00,$10,$00,$00,$20,$00 ; 3AB8
        .byte   $00,$30,$00,$00,$10,$00,$00,$90 ; 3AC0
        .byte   $00,$09,$A0,$00,$25,$A0,$00,$65 ; 3AC8
        .byte   $60,$02,$59,$90,$09,$AA,$90,$1A ; 3AD0
        .byte   $00,$90,$64,$00,$90,$00,$00,$90 ; 3AD8
        .byte   $00,$00,$90,$88,$5B,$D7,$59,$CE ; 3AE0
        .byte   $56,$D3,$61,$C7,$4D,$C7,$05,$25 ; 3AE8
        .byte   $00,$06,$00,$0F,$FF,$00,$1F,$FF ; 3AF0
        .byte   $00,$3E,$3F,$00,$7F,$BF,$00,$FF ; 3AF8
        .byte   $1F,$00,$1C,$1F,$00,$08,$10,$80 ; 3B00
        .byte   $00,$10,$04,$1C,$01,$00,$00,$0E ; 3B08
        .byte   $00,$60,$3E,$00,$F0,$FF,$01,$C0 ; 3B10
        .byte   $3F,$FF,$80,$08,$FF,$80,$03,$FF ; 3B18
        .byte   $00,$07,$FE,$00,$07,$FE,$00,$07 ; 3B20
        .byte   $FC,$00,$07,$F8,$00,$07,$F8,$07 ; 3B28
        .byte   $09,$02,$AC,$00,$03,$FC,$00,$03 ; 3B30
        .byte   $FF,$00,$03,$FF,$00,$0F,$FF,$00 ; 3B38
        .byte   $0B,$FF,$00,$2A,$0A,$00,$BC,$0A ; 3B40
        .byte   $00,$6C,$0A,$C0,$68,$09,$80,$AA ; 3B48
        .byte   $01,$A0,$2A,$00,$A0,$0A,$80,$A0 ; 3B50
        .byte   $02,$B0,$20,$01,$70,$3C,$0F,$C0 ; 3B58
        .byte   $1C,$00,$00,$5C,$00,$00,$FC,$88 ; 3B60
        .byte   $0B,$FF,$00,$00,$FF,$C0,$00,$FF ; 3B68
        .byte   $C1,$00,$5F,$C1,$00,$A7,$C1,$40 ; 3B70
        .byte   $75,$CA,$00,$57,$E6,$00,$97,$58 ; 3B78
        .byte   $00,$59,$90,$00,$A9,$A0,$00,$A5 ; 3B80
        .byte   $80,$00,$55,$00,$00,$54,$00,$00 ; 3B88
        .byte   $54,$00,$00,$54,$00,$00,$50,$00 ; 3B90
        .byte   $00,$50,$00,$00,$40,$88,$0F,$00 ; 3B98
        .byte   $00,$0C,$00,$00,$0C,$00,$00,$00 ; 3BA0
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 3BA8
        .byte   $08,$00,$01,$A8,$00,$05,$68,$00 ; 3BB0
        .byte   $0A,$58,$00,$1A,$A4,$00,$5A,$A8 ; 3BB8
        .byte   $01,$A0,$A8,$1A,$80,$A8,$64,$00 ; 3BC0
        .byte   $A4,$00,$00,$94,$00,$00,$D8,$88 ; 3BC8
        .byte   $B1,$D3,$B1,$C7,$B0,$D2,$BB,$C1 ; 3BD0
        .byte   $A5,$C2,$05,$2B,$06,$00,$00,$0F ; 3BD8
        .byte   $83,$00,$3D,$FF,$00,$7E,$3F,$00 ; 3BE0
        .byte   $1C,$FE,$00,$09,$FC,$00,$01,$88 ; 3BE8
        .byte   $04,$1D,$F0,$00,$00,$E0,$00,$00 ; 3BF0
        .byte   $E0,$00,$00,$70,$3E,$00,$3F,$FF ; 3BF8
        .byte   $80,$3F,$FF,$E0,$3F,$F8,$C0,$3F ; 3C00
        .byte   $C0,$00,$3F,$80,$00,$3F,$80,$00 ; 3C08
        .byte   $3F,$00,$00,$0E,$07,$13,$03,$C0 ; 3C10
        .byte   $00,$0F,$C0,$00,$0F,$C0,$00,$3F ; 3C18
        .byte   $C0,$00,$FF,$80,$00,$6A,$F0,$00 ; 3C20
        .byte   $AC,$D4,$00,$28,$14,$00,$28,$29 ; 3C28
        .byte   $00,$0A,$0A,$00,$16,$0A,$00,$3F ; 3C30
        .byte   $0A,$00,$00,$05,$00,$00,$0F,$00 ; 3C38
        .byte   $00,$3F,$88,$08,$3F,$C0,$00,$FF ; 3C40
        .byte   $F0,$00,$FF,$F0,$00,$17,$F0,$00 ; 3C48
        .byte   $29,$F0,$00,$1D,$F0,$00,$15,$70 ; 3C50
        .byte   $00,$A5,$F0,$00,$95,$C0,$00,$A9 ; 3C58
        .byte   $50,$00,$55,$54,$00,$55,$55,$00 ; 3C60
        .byte   $55,$A5,$00,$56,$89,$40,$56,$02 ; 3C68
        .byte   $90,$5A,$01,$50,$5A,$05,$A0,$68 ; 3C70
        .byte   $0A,$00,$FC,$88,$21,$59,$56,$80 ; 3C78
        .byte   $26,$AA,$80,$00,$29,$80,$00,$0A ; 3C80
        .byte   $40,$00,$00,$40,$00,$00,$40,$00 ; 3C88
        .byte   $00,$40,$00,$00,$40,$00,$00,$40 ; 3C90
        .byte   $00,$00,$40,$88,$B0,$D5,$B5,$CA ; 3C98
        .byte   $B1,$D5,$B9,$C4,$A7,$CA,$05,$2B ; 3CA0
        .byte   $04,$00,$00,$0F,$83,$00,$1F,$FF ; 3CA8
        .byte   $00,$3E,$7F,$00,$FC,$FE,$00,$18 ; 3CB0
        .byte   $FE,$00,$0C,$1C,$04,$26,$60,$00 ; 3CB8
        .byte   $00,$E0,$F8,$00,$DF,$FE,$00,$3F ; 3CC0
        .byte   $E7,$80,$3F,$C2,$00,$3F,$80,$00 ; 3CC8
        .byte   $3F,$80,$00,$3F,$00,$00,$0F,$07 ; 3CD0
        .byte   $16,$03,$C0,$00,$03,$FF,$00,$0F ; 3CD8
        .byte   $C0,$00,$0F,$E8,$00,$17,$EA,$00 ; 3CE0
        .byte   $1F,$2A,$00,$2C,$FA,$00,$2C,$5B ; 3CE8
        .byte   $00,$5C,$68,$00,$FC,$29,$00,$00 ; 3CF0
        .byte   $2A,$00,$00,$0A,$00,$00,$D6,$00 ; 3CF8
        .byte   $00,$FF,$88,$07,$3F,$C0,$00,$FF ; 3D00
        .byte   $F0,$00,$FF,$F0,$00,$17,$F0,$00 ; 3D08
        .byte   $29,$F0,$00,$1D,$F0,$00,$15,$70 ; 3D10
        .byte   $00,$25,$F0,$00,$95,$C0,$00,$A9 ; 3D18
        .byte   $50,$00,$A5,$54,$00,$95,$69,$00 ; 3D20
        .byte   $55,$A9,$40,$55,$82,$50,$55,$80 ; 3D28
        .byte   $A4,$56,$80,$24,$5A,$80,$18,$AA ; 3D30
        .byte   $00,$00,$FF,$C0,$88,$2E,$60,$00 ; 3D38
        .byte   $00,$94,$00,$00,$09,$40,$00,$02 ; 3D40
        .byte   $A0,$00,$00,$A0,$00,$00,$20,$88 ; 3D48
        .byte   $9E,$D3,$A2,$CB,$9D,$D3,$A3,$C3 ; 3D50
        .byte   $97,$C8,$04,$2B,$3F,$80,$00,$7F ; 3D58
        .byte   $F0,$00,$00,$FF,$00,$03,$FF,$00 ; 3D60
        .byte   $07,$FC,$00,$0F,$F0,$00,$03,$80 ; 3D68
        .byte   $04,$2C,$40,$70,$00,$40,$F8,$00 ; 3D70
        .byte   $63,$DC,$00,$3F,$C8,$00,$1F,$80 ; 3D78
        .byte   $00,$0E,$00,$00,$07,$07,$1C,$00 ; 3D80
        .byte   $F0,$00,$17,$FF,$00,$1F,$FF,$C0 ; 3D88
        .byte   $2C,$7F,$C0,$2C,$7F,$C0,$1D,$FF ; 3D90
        .byte   $00,$F5,$FC,$00,$06,$B0,$00,$0A ; 3D98
        .byte   $80,$00,$00,$90,$00,$01,$70,$00 ; 3DA0
        .byte   $03,$F0,$88,$09,$03,$FC,$00,$0F ; 3DA8
        .byte   $FF,$00,$0F,$FF,$00,$01,$7F,$00 ; 3DB0
        .byte   $02,$9F,$00,$01,$D7,$00,$01,$5F ; 3DB8
        .byte   $00,$02,$5C,$00,$01,$69,$00,$02 ; 3DC0
        .byte   $A5,$40,$0A,$95,$40,$19,$56,$40 ; 3DC8
        .byte   $62,$5B,$90,$82,$AA,$20,$00,$AA ; 3DD0
        .byte   $24,$00,$2A,$08,$00,$0A,$18,$00 ; 3DD8
        .byte   $0A,$28,$88,$9A,$D1,$9D,$CA,$98 ; 3DE0
        .byte   $D1,$99,$C2,$04,$2E,$F8,$00,$00 ; 3DE8
        .byte   $78,$00,$00,$03,$80,$00,$07,$F8 ; 3DF0
        .byte   $00,$0F,$F8,$00,$0F,$80,$04,$29 ; 3DF8
        .byte   $01,$C0,$00,$03,$E0,$00,$0F,$F0 ; 3E00
        .byte   $00,$BC,$20,$00,$3E,$00,$00,$3F ; 3E08
        .byte   $00,$00,$18,$00,$00,$04,$07,$1C ; 3E10
        .byte   $17,$00,$00,$1B,$C0,$00,$2F,$F0 ; 3E18
        .byte   $00,$C8,$30,$00,$F8,$FF,$00,$3C ; 3E20
        .byte   $FF,$00,$0C,$BC,$00,$00,$60,$00 ; 3E28
        .byte   $00,$60,$00,$00,$20,$00,$03,$50 ; 3E30
        .byte   $00,$03,$F0,$88,$0D,$03,$FC,$00 ; 3E38
        .byte   $0F,$FF,$00,$0F,$FF,$00,$01,$7F ; 3E40
        .byte   $00,$02,$9F,$00,$01,$D7,$00,$01 ; 3E48
        .byte   $5C,$00,$02,$59,$00,$01,$65,$40 ; 3E50
        .byte   $02,$95,$50,$06,$56,$A4,$1A,$5B ; 3E58
        .byte   $09,$62,$AA,$02,$80,$AA,$02,$00 ; 3E60
        .byte   $AA,$06,$00,$2A,$0A,$00,$0A,$88 ; 3E68
        .byte   $87,$C5,$8A,$BF,$83,$C5,$83,$B8 ; 3E70
        .byte   $04,$2E,$F8,$00,$00,$78,$00,$00 ; 3E78
        .byte   $03,$80,$00,$07,$F8,$00,$0F,$F8 ; 3E80
        .byte   $00,$0F,$80,$04,$2C,$03,$C0,$00 ; 3E88
        .byte   $0F,$F0,$00,$BC,$60,$00,$BE,$00 ; 3E90
        .byte   $00,$3F,$00,$00,$18,$00,$00,$04 ; 3E98
        .byte   $07,$1C,$17,$00,$00,$1B,$C0,$00 ; 3EA0
        .byte   $2F,$F0,$00,$C8,$30,$00,$F8,$FF ; 3EA8
        .byte   $00,$3C,$FF,$00,$0C,$BC,$00,$00 ; 3EB0
        .byte   $60,$00,$00,$60,$00,$00,$20,$00 ; 3EB8
        .byte   $03,$50,$00,$03,$F0,$88,$0F,$00 ; 3EC0
        .byte   $0F,$00,$00,$67,$C0,$02,$77,$C0 ; 3EC8
        .byte   $01,$57,$C0,$01,$57,$C0,$02,$5F ; 3ED0
        .byte   $C0,$00,$9F,$C0,$00,$A5,$00,$02 ; 3ED8
        .byte   $55,$40,$06,$56,$90,$1A,$5B,$24 ; 3EE0
        .byte   $62,$AA,$09,$80,$AA,$02,$00,$AA ; 3EE8
        .byte   $02,$00,$2A,$06,$00,$0A,$0A,$88 ; 3EF0
        .byte   $86,$C0,$89,$BB,$82,$C0,$82,$B4 ; 3EF8
        .byte   $04,$25,$20,$00,$00,$20,$00,$00 ; 3F00
        .byte   $78,$00,$00,$FC,$00,$00,$3E,$00 ; 3F08
        .byte   $00,$19,$80,$00,$10,$80,$00,$00 ; 3F10
        .byte   $00,$00,$01,$80,$04,$28,$1F,$00 ; 3F18
        .byte   $00,$06,$00,$00,$1E,$00,$00,$7F ; 3F20
        .byte   $00,$00,$3F,$C4,$00,$1F,$FC,$00 ; 3F28
        .byte   $0F,$0C,$00,$00,$0C,$07,$14,$00 ; 3F30
        .byte   $40,$00,$01,$60,$00,$05,$A0,$00 ; 3F38
        .byte   $C6,$A0,$00,$DA,$80,$00,$F8,$00 ; 3F40
        .byte   $00,$30,$05,$00,$00,$05,$80,$00 ; 3F48
        .byte   $19,$80,$01,$6A,$80,$0E,$AA,$00 ; 3F50
        .byte   $0D,$A0,$00,$0D,$00,$00,$0F,$00 ; 3F58
        .byte   $00,$03,$88,$10,$00,$00,$03,$00 ; 3F60
        .byte   $02,$67,$00,$01,$77,$00,$01,$57 ; 3F68
        .byte   $01,$51,$5F,$55,$55,$7F,$AA,$57 ; 3F70
        .byte   $7F,$00,$57,$FF,$02,$55,$FC,$02 ; 3F78
        .byte   $95,$00,$02,$AA,$40,$FF,$A2,$40 ; 3F80
        .byte   $3F,$C2,$40,$3F,$D6,$40,$0F,$E9 ; 3F88
        .byte   $00,$00,$20,$88,$85,$BA,$88,$B7 ; 3F90
        .byte   $7D,$B9,$84,$B3,$04,$22,$38,$00 ; 3F98
        .byte   $00,$0E,$00,$00,$3F,$00,$00,$7F ; 3FA0
        .byte   $00,$00,$3F,$00,$00,$1F,$80,$00 ; 3FA8
        .byte   $1F,$C0,$00,$0F,$E0,$00,$00,$60 ; 3FB0
        .byte   $00,$00,$20,$07,$26,$10,$00,$00 ; 3FB8
        .byte   $30,$00,$00,$70,$00,$00,$38,$00 ; 3FC0
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 3FC8
        .byte   $00,$00,$0E,$00,$00,$08,$04,$14 ; 3FD0
        .byte   $30,$10,$00,$F1,$58,$00,$D6,$A8 ; 3FD8
        .byte   $00,$DA,$A8,$00,$EA,$B0,$00,$28 ; 3FE0
        .byte   $F0,$00,$00,$F0,$00,$00,$D4,$00 ; 3FE8
        .byte   $00,$56,$00,$05,$66,$00,$3A,$AA ; 3FF0
        .byte   $00,$36,$A8,$00,$34,$00,$00,$3C ; 3FF8
        .byte   $00,$00,$0C,$88,$14,$00,$00,$0C ; 4000
        .byte   $54,$09,$9C,$29,$25,$DC,$09,$65 ; 4008
        .byte   $5C,$09,$55,$7C,$E9,$55,$FC,$E9 ; 4010
        .byte   $5D,$FC,$EA,$5F,$FC,$EA,$53,$F0 ; 4018
        .byte   $FA,$A0,$00,$00,$A0,$00,$02,$80 ; 4020
        .byte   $00,$0A,$00,$00,$28,$00,$00,$A0 ; 4028
        .byte   $88,$7F,$A0,$7C,$A3,$72,$A0,$7E ; 4030
        .byte   $9F,$04,$23,$0C,$00,$00,$12,$00 ; 4038
        .byte   $00,$FE,$00,$00,$7E,$00,$00,$7E ; 4040
        .byte   $00,$00,$7E,$00,$00,$3F,$00,$00 ; 4048
        .byte   $07,$00,$00,$03,$00,$00,$02,$07 ; 4050
        .byte   $35,$F0,$00,$00,$F0,$00,$00,$F0 ; 4058
        .byte   $00,$00,$78,$04,$0E,$00,$14,$00 ; 4060
        .byte   $01,$64,$00,$C6,$A8,$00,$DA,$A8 ; 4068
        .byte   $00,$DA,$A0,$00,$EB,$F0,$00,$33 ; 4070
        .byte   $F0,$00,$03,$F0,$00,$03,$F0,$00 ; 4078
        .byte   $03,$50,$00,$01,$58,$00,$15,$98 ; 4080
        .byte   $00,$EA,$A8,$00,$DA,$A0,$00,$D0 ; 4088
        .byte   $00,$00,$F0,$00,$00,$30,$88,$08 ; 4090
        .byte   $50,$00,$00,$A4,$00,$00,$09,$00 ; 4098
        .byte   $00,$0A,$40,$03,$00,$92,$67,$25 ; 40A0
        .byte   $59,$77,$A9,$59,$57,$A9,$55,$5F ; 40A8
        .byte   $AA,$55,$7F,$AA,$53,$7F,$2A,$53 ; 40B0
        .byte   $FF,$00,$90,$FC,$00,$80,$00     ; 40B8
L40BF:  .byte   $02,$40,$00,$02,$40,$00,$0A,$00 ; 40BF
        .byte   $00,$08,$00,$00,$28,$00,$00,$20 ; 40C7
        .byte   $88,$80,$8F,$79,$92,$71,$8D,$7C ; 40CF
        .byte   $8C,$04,$23,$0C,$00,$00,$12,$00 ; 40D7
        .byte   $00,$FE,$00,$00,$7E,$00,$00,$7E ; 40DF
        .byte   $00,$00,$7E,$00,$00,$3F,$00,$00 ; 40E7
        .byte   $07,$00,$00,$03,$00,$00,$02,$07 ; 40EF
        .byte   $35,$F0,$00,$00,$F0,$00,$00,$F0 ; 40F7
        .byte   $00,$00,$78,$04,$0E,$00,$14,$00 ; 40FF
        .byte   $01,$64,$00,$C6,$A8,$00,$DA,$A8 ; 4107
        .byte   $00,$DA,$A0,$00,$EB,$F0,$00,$33 ; 410F
        .byte   $F0,$00,$03,$F0,$00,$03,$F0,$00 ; 4117
        .byte   $03,$50,$00,$01,$58,$00,$15,$98 ; 411F
        .byte   $00,$EA,$A8,$00,$DA,$A0,$00,$D0 ; 4127
        .byte   $00,$00,$F0,$00,$00,$30,$88,$08 ; 412F
        .byte   $50,$00,$00,$A4,$00,$00,$09,$00 ; 4137
        .byte   $00,$0A,$40,$03,$00,$92,$67,$25 ; 413F
        .byte   $59,$77,$A9,$59,$57,$A9,$55,$5F ; 4147
        .byte   $AA,$55,$7F,$AA,$53,$7F,$2A,$53 ; 414F
        .byte   $FF,$00,$90,$FC,$00,$80,$00,$02 ; 4157
        .byte   $40,$00,$02,$40,$00,$0A,$00,$00 ; 415F
        .byte   $08,$00,$00,$28,$00,$00,$20,$88 ; 4167
        .byte   $7F,$87,$78,$8A,$70,$85,$7B,$84 ; 416F
        .byte   $04,$22,$03,$80,$00,$7F,$C0,$00 ; 4177
        .byte   $0F,$E0,$00,$71,$80,$00,$7F,$C0 ; 417F
        .byte   $00,$0F,$C0,$00,$01,$E0,$00,$00 ; 4187
        .byte   $70,$00,$00,$30,$00,$00,$20,$07 ; 418F
        .byte   $1D,$0C,$00,$00,$7C,$00,$00,$7C ; 4197
        .byte   $00,$00,$3C,$00,$00,$78,$00,$00 ; 419F
        .byte   $78,$00,$00,$78,$00,$00,$38,$00 ; 41A7
        .byte   $00,$3C,$00,$00,$1C,$00,$00,$0E ; 41AF
        .byte   $00,$00,$06,$04,$0E,$00,$14,$00 ; 41B7
        .byte   $01,$E4,$00,$C6,$FC,$00,$DB,$FC ; 41BF
        .byte   $00,$DB,$F0,$00,$EB,$F0,$00,$33 ; 41C7
        .byte   $F0,$00,$03,$F0,$00,$03,$F0,$00 ; 41CF
        .byte   $00,$F0,$00,$00,$FC,$00,$15,$FC ; 41D7
        .byte   $00,$EA,$BC,$00,$DA,$A0,$00,$D0 ; 41DF
        .byte   $00,$00,$F0,$00,$00,$30,$88,$14 ; 41E7
        .byte   $00,$03,$F0,$00,$0F,$FC,$00,$0F ; 41EF
        .byte   $FC,$55,$6F,$FC,$55,$6F,$FC,$55 ; 41F7
        .byte   $6D,$FC,$AA,$65,$7C,$AA,$65,$DC ; 41FF
        .byte   $AA,$69,$8C,$00,$90,$00,$0A,$80 ; 4207
        .byte   $00,$2A,$80,$00,$28,$00,$00,$A0 ; 420F
        .byte   $00,$00,$80,$88,$7B,$86,$76,$85 ; 4217
        .byte   $6F,$84,$7B,$85,$04,$25,$38,$00 ; 421F
        .byte   $00,$F8,$00,$00,$F8,$00,$00,$38 ; 4227
        .byte   $00,$00,$FC,$00,$00,$7F,$00,$00 ; 422F
        .byte   $1F,$80,$00,$07,$C0,$00,$01,$C0 ; 4237
        .byte   $04,$2F,$38,$00,$00,$F1,$F0,$00 ; 423F
        .byte   $3F,$F8,$00,$FF,$9C,$00,$FC,$0C ; 4247
        .byte   $00,$78,$07,$11,$03,$F0,$00,$FF ; 424F
        .byte   $F0,$00,$FF,$F0,$00,$FF,$F0,$00 ; 4257
        .byte   $F3,$F0,$00,$03,$FC,$00,$03,$FC ; 425F
        .byte   $00,$00,$FF,$00,$00,$ED,$00,$03 ; 4267
        .byte   $A9,$00,$3E,$A9,$00,$3E,$A8,$00 ; 426F
        .byte   $3F,$00,$00,$3C,$00,$00,$30,$00 ; 4277
        .byte   $00,$30,$88,$10,$00,$03,$F0,$00 ; 427F
        .byte   $0F,$FC,$00,$0F,$FC,$00,$0F,$FC ; 4287
        .byte   $06,$BD,$FC,$15,$A5,$FC,$55,$65 ; 428F
        .byte   $7C,$55,$69,$DC,$55,$A9,$8C,$56 ; 4297
        .byte   $A9,$00,$5A,$89,$00,$00,$09,$00 ; 429F
        .byte   $00,$25,$00,$00,$24,$00,$00,$24 ; 42A7
        .byte   $00,$00,$A0,$88,$77,$98,$7D,$97 ; 42AF
        .byte   $71,$98,$7C,$93,$04,$25,$38,$00 ; 42B7
        .byte   $00,$F8,$00,$00,$F8,$00,$00,$38 ; 42BF
        .byte   $00,$00,$FC,$00,$00,$7F,$00,$00 ; 42C7
        .byte   $1F,$80,$00,$07,$C0,$00,$01,$C0 ; 42CF
        .byte   $04,$2F,$38,$00,$00,$F1,$F0,$00 ; 42D7
        .byte   $3F,$F8,$00,$FF,$9C,$00,$FC,$0C ; 42DF
        .byte   $00,$78,$07,$11,$03,$F0,$00,$FF ; 42E7
        .byte   $F0,$00,$FF,$F0,$00,$FF,$F0,$00 ; 42EF
        .byte   $F3,$F0,$00,$03,$FC,$00,$03,$FC ; 42F7
        .byte   $00,$00,$FF,$00,$00,$FD,$00,$03 ; 42FF
        .byte   $A9,$00,$3E,$A9,$00,$3E,$A8,$00 ; 4307
        .byte   $3F,$00,$00,$3C,$00,$00,$30,$00 ; 430F
        .byte   $00,$30,$88,$07,$00,$FF,$00,$03 ; 4317
        .byte   $FF,$C0,$03,$FF,$C0,$03,$FF,$00 ; 431F
        .byte   $03,$FE,$00,$03,$FD,$00,$03,$F5 ; 4327
        .byte   $00,$06,$F9,$00,$16,$56,$00,$55 ; 432F
        .byte   $56,$00,$55,$64,$00,$55,$A9,$00 ; 4337
        .byte   $56,$A9,$00,$5A,$89,$00,$00,$09 ; 433F
        .byte   $00,$00,$25,$00,$00,$24,$00,$00 ; 4347
        .byte   $24,$00,$00,$A0,$88,$79,$A0,$7F ; 434F
        .byte   $9F,$73,$A0,$7E,$98,$04,$28,$C0 ; 4357
        .byte   $00,$00,$F8,$00,$00,$F8,$40,$00 ; 435F
        .byte   $3F,$E0,$00,$07,$F0,$00,$00,$F8 ; 4367
        .byte   $00,$00,$3C,$00,$00,$1C,$04,$2C ; 436F
        .byte   $02,$00,$00,$0F,$FF,$00,$1B,$FF ; 4377
        .byte   $80,$37,$F3,$80,$77,$E3,$C0,$6F ; 437F
        .byte   $00,$00,$0E,$07,$11,$05,$54,$00 ; 4387
        .byte   $05,$58,$00,$3A,$A0,$00,$3F,$F0 ; 438F
        .byte   $00,$3F,$F0,$00,$FF,$F0,$00,$EF ; 4397
        .byte   $FC,$00,$FB,$FC,$00,$C0,$FF,$00 ; 439F
        .byte   $00,$ED,$00,$03,$A9,$00,$3E,$A9 ; 43A7
        .byte   $00,$3E,$80,$00,$0F,$00,$00,$0F ; 43AF
        .byte   $00,$00,$03,$88,$09,$00,$FF,$00 ; 43B7
        .byte   $03,$FF,$C0,$03,$FF,$C0,$03,$FF ; 43BF
        .byte   $00,$03,$FE,$00,$03,$FD,$00,$03 ; 43C7
        .byte   $F5,$00,$06,$F9,$00,$16,$56,$00 ; 43CF
        .byte   $55,$56,$00,$55,$64,$00,$55,$A9 ; 43D7
        .byte   $00,$56,$A9,$00,$5A,$89,$00,$00 ; 43DF
        .byte   $09,$00,$00,$09,$40,$00,$02,$80 ; 43E7
        .byte   $00,$00,$80,$88,$79,$A6,$7A,$A1 ; 43EF
        .byte   $77,$A4,$7C,$9A,$04,$2B,$60,$00 ; 43F7
        .byte   $00,$F8,$60,$00,$FF,$F0,$00,$5F ; 43FF
        .byte   $F8,$00,$0F,$FE,$00,$03,$FE,$00 ; 4407
        .byte   $00,$3C,$04,$26,$06,$7C,$00,$0D ; 440F
        .byte   $FE,$00,$1F,$EE,$00,$17,$EF,$00 ; 4417
        .byte   $2F,$80,$00,$2E,$00,$00,$5C,$00 ; 441F
        .byte   $00,$58,$00,$00,$38,$07,$0D,$00 ; 4427
        .byte   $20,$00,$0A,$A0,$00,$2A,$A0,$00 ; 442F
        .byte   $2A,$A0,$00,$EA,$80,$00,$FF,$C0 ; 4437
        .byte   $00,$FF,$F0,$00,$3F,$FC,$00,$2F ; 443F
        .byte   $FD,$00,$EB,$FE,$00,$F0,$BE,$00 ; 4447
        .byte   $F0,$A9,$00,$02,$A4,$00,$02,$90 ; 444F
        .byte   $00,$0F,$C0,$00,$0F,$F0,$00,$0F ; 4457
        .byte   $F0,$88,$0C,$00,$FF,$00,$03,$FF ; 445F
        .byte   $C0,$03,$FF,$C0,$03,$FF,$00,$03 ; 4467
        .byte   $FE,$00,$03,$FD,$00,$03,$F5,$00 ; 446F
        .byte   $06,$F9,$00,$26,$56,$00,$95,$56 ; 4477
        .byte   $00,$95,$64,$00,$95,$69,$00,$55 ; 447F
        .byte   $A9,$00,$56,$89,$00,$00,$09,$50 ; 4487
        .byte   $00,$09,$60,$00,$0A,$80,$88,$83 ; 448F
        .byte   $BE,$86,$B7,$83,$BB,$86,$AF,$05 ; 4497
        .byte   $28,$60,$00,$00,$60,$00,$00,$FC ; 449F
        .byte   $00,$00,$DF,$80,$00,$5F,$F0,$00 ; 44A7
        .byte   $5F,$FC,$00,$0F,$FF,$00,$00,$3E ; 44AF
        .byte   $04,$26,$02,$00,$00,$06,$7C,$00 ; 44B7
        .byte   $0D,$FE,$00,$1F,$EF,$00,$17,$E3 ; 44BF
        .byte   $80,$2F,$80,$00,$2E,$00,$00,$5C ; 44C7
        .byte   $00,$00,$18,$07,$0D,$3A,$80,$00 ; 44CF
        .byte   $AA,$80,$00,$AB,$C0,$00,$FF,$C0 ; 44D7
        .byte   $0A,$FF,$A0,$00,$3F,$E8,$00,$3F ; 44DF
        .byte   $FE,$00,$2F,$FE,$00,$28,$3E,$40 ; 44E7
        .byte   $A8,$2A,$40,$E0,$2A,$00,$F0,$A9 ; 44EF
        .byte   $00,$F0,$A4,$00,$00,$A0,$00,$03 ; 44F7
        .byte   $D0,$00,$03,$FC,$00,$03,$FC,$88 ; 44FF
        .byte   $0E,$C0,$00,$00,$F0,$00,$00,$F0 ; 4507
        .byte   $00,$00,$C0,$00,$00,$80,$00,$00 ; 450F
        .byte   $40,$00,$00,$40,$00,$00,$40,$00 ; 4517
        .byte   $00,$80,$00,$00,$80,$00,$00,$00 ; 451F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 4527
        .byte   $80,$00,$00,$40,$00,$00,$90,$00 ; 452F
        .byte   $00,$A4,$88,$13,$00,$FC,$00,$03 ; 4537
        .byte   $FC,$00,$03,$FC,$00,$03,$FC,$00 ; 453F
        .byte   $03,$FC,$00,$03,$FC,$00,$03,$F4 ; 4547
        .byte   $00,$00,$FC,$00,$06,$F8,$00,$26 ; 454F
        .byte   $54,$00,$95,$54,$00,$95,$64,$00 ; 4557
        .byte   $95,$68,$00,$55,$A8,$00,$56,$88 ; 455F
        .byte   $88,$91,$C7,$92,$C1,$91,$C7,$A1 ; 4567
        .byte   $B9,$93,$B9,$05,$28,$60,$00,$00 ; 456F
        .byte   $78,$00,$00,$7F,$E0,$00,$6F,$F0 ; 4577
        .byte   $00,$2F,$FC,$00,$03,$FE,$00,$00 ; 457F
        .byte   $FF,$00,$00,$3E,$04,$26,$02,$00 ; 4587
        .byte   $00,$06,$7E,$00,$0D,$FF,$00,$1F ; 458F
        .byte   $E7,$80,$17,$E1,$C0,$2F,$80,$00 ; 4597
        .byte   $2E,$00,$00,$5C,$00,$00,$18,$07 ; 459F
        .byte   $07,$16,$A0,$90,$26,$80,$A8,$3A ; 45A7
        .byte   $80,$24,$3F,$C0,$15,$3F,$C0,$00 ; 45AF
        .byte   $3F,$80,$00,$3F,$A0,$00,$0F,$E8 ; 45B7
        .byte   $00,$0B,$FE,$00,$2A,$BE,$00,$28 ; 45BF
        .byte   $0A,$40,$A8,$2A,$40,$E0,$2A,$00 ; 45C7
        .byte   $F0,$A9,$00,$F0,$A4,$00,$00,$A0 ; 45CF
        .byte   $00,$03,$DC,$00,$03,$FC,$00,$03 ; 45D7
        .byte   $F0,$88,$0E,$C0,$00,$00,$F0,$00 ; 45DF
        .byte   $00,$F0,$00,$00,$C0,$00,$00,$80 ; 45E7
        .byte   $00,$00,$40,$00,$00,$40,$00,$00 ; 45EF
        .byte   $40,$00,$00,$80,$00,$00,$80,$00 ; 45F7
        .byte   $00,$40,$00,$00,$40,$00,$00,$40 ; 45FF
        .byte   $00,$00,$90,$00,$00,$50,$00,$00 ; 4607
        .byte   $90,$00,$00,$A8,$88,$12,$00,$0F ; 460F
        .byte   $C0,$00,$3F,$C0,$00,$3F,$C0,$00 ; 4617
        .byte   $3F,$C0,$00,$3F,$C0,$00,$3F,$C0 ; 461F
        .byte   $00,$3F,$40,$00,$0F,$C0,$00,$6F ; 4627
        .byte   $80,$00,$65,$40,$01,$55,$40,$09 ; 462F
        .byte   $56,$40,$29,$56,$80,$25,$5A,$80 ; 4637
        .byte   $A5,$6A,$80,$88,$9D,$D0,$9E,$C7 ; 463F
        .byte   $9D,$CE,$AD,$BF,$9B,$BF,$05,$2E ; 4647
        .byte   $00,$40,$00,$C1,$E0,$00,$FF,$F8 ; 464F
        .byte   $00,$E7,$FC,$00,$73,$FE,$00,$00 ; 4657
        .byte   $1E,$04,$1F,$00,$07,$C0,$38,$3F ; 465F
        .byte   $C0,$FF,$FC,$00,$6F,$F0,$00,$07 ; 4667
        .byte   $F0,$00,$07,$F0,$00,$06,$F0,$00 ; 466F
        .byte   $02,$E0,$00,$03,$60,$00,$03,$40 ; 4677
        .byte   $00,$03,$C0,$07,$16,$0F,$C0,$00 ; 467F
        .byte   $0F,$F0,$00,$0F,$F0,$00,$0F,$FC ; 4687
        .byte   $00,$02,$FF,$00,$0F,$FF,$80,$2B ; 468F
        .byte   $3A,$80,$2A,$2A,$00,$28,$2A,$00 ; 4697
        .byte   $F0,$28,$00,$FC,$28,$00,$FC,$FD ; 469F
        .byte   $00,$00,$FF,$00,$00,$FC,$88,$03 ; 46A7
        .byte   $00,$03,$F0,$00,$0F,$F0,$00,$0F ; 46AF
        .byte   $F0,$00,$0F,$F0,$00,$0F,$F0,$00 ; 46B7
        .byte   $0F,$F0,$00,$0F,$F0,$00,$03,$F0 ; 46BF
        .byte   $00,$01,$60,$00,$15,$90,$00,$65 ; 46C7
        .byte   $50,$01,$65,$50,$01,$65,$50,$05 ; 46CF
        .byte   $89,$50,$1A,$09,$50,$A8,$02,$60 ; 46D7
        .byte   $00,$02,$60,$00,$02,$60,$00,$02 ; 46DF
        .byte   $60,$00,$03,$F0,$88,$05,$C0,$00 ; 46E7
        .byte   $00,$F0,$00,$00,$F0,$00,$00,$C0 ; 46EF
        .byte   $00,$00,$80,$00,$00,$40,$00,$00 ; 46F7
        .byte   $40,$00,$00,$40,$00,$00,$A5,$59 ; 46FF
        .byte   $40,$AA,$A6,$00,$68,$00,$00,$A0 ; 4707
        .byte   $00,$00,$80,$00,$00,$80,$00,$00 ; 470F
        .byte   $80,$00,$00,$80,$00,$00,$80,$00 ; 4717
        .byte   $00,$80,$00,$00,$C0,$00,$00,$C0 ; 471F
        .byte   $88,$A9,$D4,$A5,$CA,$A6,$D4,$9D ; 4727
        .byte   $C2,$B1,$C2,$05,$26,$18,$00,$00 ; 472F
        .byte   $3F,$FC,$00,$3F,$FE,$00,$3B,$FF ; 4737
        .byte   $00,$39,$FF,$80,$3C,$1F,$C0,$3E ; 473F
        .byte   $0E,$00,$42,$04,$00,$02,$04,$1F ; 4747
        .byte   $28,$00,$00,$7C,$0F,$00,$3F,$FF ; 474F
        .byte   $C0,$3F,$FF,$80,$0F,$F0,$00,$07 ; 4757
        .byte   $F0,$00,$07,$F0,$00,$06,$F0,$00 ; 475F
        .byte   $02,$E0,$00,$02,$E0,$00,$02,$C0 ; 4767
        .byte   $07,$09,$00,$EA,$00,$00,$FF,$00 ; 476F
        .byte   $03,$FF,$00,$03,$FF,$00,$03,$FF ; 4777
        .byte   $C0,$03,$FF,$80,$03,$FE,$A0,$02 ; 477F
        .byte   $80,$F8,$0E,$80,$E4,$0A,$82,$A4 ; 4787
        .byte   $2A,$02,$A8,$2A,$0A,$A0,$28,$0A ; 478F
        .byte   $80,$28,$2A,$00,$F0,$E8,$00,$F0 ; 4797
        .byte   $F5,$00,$F0,$FD,$40,$00,$0F,$C0 ; 479F
        .byte   $88,$06,$00,$03,$C0,$00,$0F,$C0 ; 47A7
        .byte   $00,$0F,$C0,$00,$0F,$C0,$00,$0F ; 47AF
        .byte   $C0,$50,$0F,$C0,$50,$0F,$C0,$24 ; 47B7
        .byte   $0F,$C0,$25,$43,$C0,$09,$99,$40 ; 47BF
        .byte   $02,$9A,$80,$00,$96,$80,$00,$15 ; 47C7
        .byte   $40,$00,$05,$40,$00,$05,$40,$00 ; 47CF
        .byte   $05,$40,$00,$01,$40,$00,$01,$40 ; 47D7
        .byte   $00,$00,$40,$88,$0B,$F0,$00,$00 ; 47DF
        .byte   $FC,$00,$00,$FC,$00,$00,$FC,$00 ; 47E7
        .byte   $00,$F0,$00,$00,$E0,$00,$00,$D0 ; 47EF
        .byte   $00,$00,$50,$00,$00,$60,$00,$00 ; 47F7
        .byte   $A4,$00,$00,$9A,$00,$00,$6A,$40 ; 47FF
        .byte   $00,$AA,$50,$00,$A0,$A4,$00,$A0 ; 4807
        .byte   $2A,$40,$A0,$01,$80,$A0,$00,$00 ; 480F
        .byte   $A0,$88,$B8,$D3,$B7,$C8,$B5,$D2 ; 4817
        .byte   $AF,$C0,$C1,$C0,$05,$2B,$40,$20 ; 481F
        .byte   $00,$FF,$E0,$00,$FF,$E0,$00,$FF ; 4827
        .byte   $F8,$00,$EF,$FE,$00,$67,$FF,$00 ; 482F
        .byte   $00,$3F,$04,$26,$60,$7C,$00,$FD ; 4837
        .byte   $FF,$80,$1D,$FF,$00,$1F,$F0,$00 ; 483F
        .byte   $1B,$E0,$00,$3B,$C0,$00,$37,$80 ; 4847
        .byte   $00,$6C,$00,$00,$40,$07,$0F,$02 ; 484F
        .byte   $AA,$00,$02,$F8,$00,$00,$FC,$00 ; 4857
        .byte   $00,$FC,$00,$00,$FF,$00,$00,$FF ; 485F
        .byte   $80,$00,$FF,$A0,$02,$FE,$A0,$0A ; 4867
        .byte   $A2,$90,$0A,$8A,$50,$0A,$0A,$40 ; 486F
        .byte   $2A,$09,$00,$28,$0A,$00,$FC,$3E ; 4877
        .byte   $00,$FC,$3F,$40,$00,$3F,$C0,$88 ; 487F
        .byte   $0A,$00,$0F,$00,$00,$3F,$00,$00 ; 4887
        .byte   $3F,$00,$00,$3F,$00,$00,$3F,$00 ; 488F
        .byte   $00,$3F,$00,$00,$3F,$00,$00,$AF ; 4897
        .byte   $00,$02,$6A,$00,$0A,$59,$00,$0A ; 489F
        .byte   $99,$00,$2A,$15,$00,$28,$15,$00 ; 48A7
        .byte   $A0,$15,$00,$00,$1A,$00,$00,$2A ; 48AF
        .byte   $00,$00,$2A,$00,$00,$02,$88,$11 ; 48B7
        .byte   $F0,$00,$00,$FC,$00,$00,$FC,$00 ; 48BF
        .byte   $00,$FC,$00,$00,$F0,$00,$00,$E0 ; 48C7
        .byte   $00,$00,$D0,$00,$00,$E0,$00,$00 ; 48CF
        .byte   $54,$00,$00,$55,$00,$00,$56,$40 ; 48D7
        .byte   $00,$6A,$58,$00,$A0,$AA,$50,$80 ; 48DF
        .byte   $09,$40,$80,$00,$00,$80,$88,$C3 ; 48E7
        .byte   $D7,$C4,$CE,$BE,$D6,$BD,$C6,$CD ; 48EF
        .byte   $C6,$05,$26,$18,$00,$00,$3F,$FC ; 48F7
        .byte   $00,$3F,$FE,$00,$3B,$FF,$00,$39 ; 48FF
        .byte   $FF,$80,$3C,$1F,$C0,$3E,$0E,$00 ; 4907
        .byte   $42,$04,$00,$02,$04,$22,$1C,$0F ; 490F
        .byte   $00,$7F,$FF,$C0,$3F,$FF,$80,$0F ; 4917
        .byte   $F0,$00,$07,$F8,$00,$07,$F8,$00 ; 491F
        .byte   $06,$F0,$00,$02,$F0,$00,$02,$E0 ; 4927
        .byte   $00,$02,$E0,$07,$0B,$00,$EA,$00 ; 492F
        .byte   $00,$FF,$00,$03,$FF,$00,$03,$FF ; 4937
        .byte   $00,$03,$FF,$C0,$03,$FF,$80,$03 ; 493F
        .byte   $FE,$A0,$02,$80,$F8,$0E,$80,$E4 ; 4947
        .byte   $0A,$82,$A4,$2A,$02,$A8,$2A,$0A ; 494F
        .byte   $A0,$28,$0A,$80,$28,$2A,$00,$A0 ; 4957
        .byte   $E8,$00,$F0,$F7,$00,$F0,$FF,$00 ; 495F
        .byte   $F0,$88,$06,$00,$03,$C0,$00,$0F ; 4967
        .byte   $C0,$00,$0F,$C0,$00,$0F,$C0,$00 ; 496F
        .byte   $0F,$C0,$00,$0F,$C0,$00,$0F,$C0 ; 4977
        .byte   $00,$0F,$C0,$00,$03,$C0,$00,$19 ; 497F
        .byte   $40,$00,$5A,$80,$01,$56,$80,$65 ; 4987
        .byte   $95,$40,$0A,$A5,$40,$00,$05,$40 ; 498F
        .byte   $00,$05,$40,$00,$01,$40,$00,$01 ; 4997
        .byte   $40,$00,$00,$40,$88,$0B,$F0,$00 ; 499F
        .byte   $00,$FC,$00,$00,$FC,$00,$00,$FC ; 49A7
        .byte   $00,$00,$F0,$00,$00,$E0,$00,$00 ; 49AF
        .byte   $D0,$00,$00,$50,$00,$00,$60,$00 ; 49B7
        .byte   $00,$A4,$00,$00,$9A,$00,$00,$6A ; 49BF
        .byte   $40,$00,$AA,$50,$00,$A0,$A4,$00 ; 49C7
        .byte   $A0,$2A,$40,$A0,$01,$80,$A0,$00 ; 49CF
        .byte   $00,$A0,$88,$64,$D5,$63,$CB,$61 ; 49D7
        .byte   $D4,$5B,$C2,$6D,$C2,$05,$2F,$02 ; 49DF
        .byte   $00,$00,$07,$83,$00,$1F,$FF,$00 ; 49E7
        .byte   $3F,$E7,$00,$7F,$CE,$00,$78,$04 ; 49EF
        .byte   $1F,$00,$06,$00,$38,$3F,$80,$FF ; 49F7
        .byte   $FF,$00,$6F,$FC,$00,$07,$F8,$00 ; 49FF
        .byte   $03,$D8,$00,$03,$D8,$00,$01,$E8 ; 4A07
        .byte   $00,$01,$E8,$00,$00,$E8,$00,$00 ; 4A0F
        .byte   $E8,$07,$16,$00,$FC,$00,$03,$FC ; 4A17
        .byte   $00,$03,$FC,$00,$0F,$FC,$00,$3F ; 4A1F
        .byte   $E0,$00,$BF,$FC,$00,$AB,$3A,$00 ; 4A27
        .byte   $2A,$2A,$00,$2A,$0A,$00,$0A,$03 ; 4A2F
        .byte   $C0,$0A,$0F,$C0,$1F,$CF,$C0,$3F ; 4A37
        .byte   $C0,$00,$0F,$C0,$88,$03,$00,$03 ; 4A3F
        .byte   $F0,$00,$0F,$F0,$00,$0F,$F0,$00 ; 4A47
        .byte   $0F,$F0,$00,$0F,$F0,$00,$0F,$F0 ; 4A4F
        .byte   $00,$0F,$F0,$00,$03,$F0,$00,$01 ; 4A57
        .byte   $60,$00,$15,$90,$00,$65,$50,$01 ; 4A5F
        .byte   $65,$50,$01,$6A,$50,$05,$8A,$90 ; 4A67
        .byte   $1A,$0A,$90,$A8,$0A,$A0,$00,$0A ; 4A6F
        .byte   $A0,$00,$0A,$A0,$00,$0A,$A0,$00 ; 4A77
        .byte   $03,$F0,$88,$05,$C0,$00,$00,$F0 ; 4A7F
        .byte   $00,$00,$F0,$00,$00,$C0,$00,$00 ; 4A87
        .byte   $80,$00,$00,$40,$00,$00,$40,$00 ; 4A8F
        .byte   $00,$40,$00,$00,$A0,$00,$00,$A5 ; 4A97
        .byte   $65,$00,$6A,$98,$00,$A0,$00,$00 ; 4A9F
        .byte   $80,$00,$00,$80,$00,$00,$80,$00 ; 4AA7
        .byte   $00,$80,$00,$00,$80,$00,$00,$80 ; 4AAF
        .byte   $00,$00,$C0,$00,$00,$C0,$88,$67 ; 4AB7
        .byte   $D6,$69,$CC,$68,$D6,$61,$C4,$75 ; 4ABF
        .byte   $C4,$04,$29,$00,$06,$00,$00,$1E ; 4AC7
        .byte   $00,$07,$FE,$00,$0F,$F6,$00,$3F ; 4ACF
        .byte   $F4,$00,$7F,$C0,$00,$FF,$00,$00 ; 4AD7
        .byte   $7C,$04,$28,$0F,$B0,$00,$1F,$D8 ; 4ADF
        .byte   $00,$3D,$FC,$00,$79,$F6,$00,$08 ; 4AE7
        .byte   $7A,$00,$00,$1B,$00,$00,$0D,$00 ; 4AEF
        .byte   $00,$05,$07,$06,$06,$0A,$94,$2A ; 4AF7
        .byte   $02,$98,$18,$02,$AC,$54,$03,$FC ; 4AFF
        .byte   $00,$03,$FC,$00,$02,$FC,$00,$0A ; 4B07
        .byte   $FC,$00,$2B,$F0,$00,$BF,$E0,$00 ; 4B0F
        .byte   $BE,$A8,$01,$A0,$28,$01,$A8,$2A ; 4B17
        .byte   $00,$A8,$0B,$00,$6A,$0F,$00,$1A ; 4B1F
        .byte   $0F,$00,$0A,$00,$00,$37,$C0,$00 ; 4B27
        .byte   $3F,$C0,$00,$0F,$C0,$88,$10,$03 ; 4B2F
        .byte   $FC,$00,$0F,$FF,$00,$0F,$FF,$00 ; 4B37
        .byte   $0F,$FF,$00,$0F,$FF,$00,$0F,$FF ; 4B3F
        .byte   $00,$03,$FC,$00,$00,$E8,$00,$01 ; 4B47
        .byte   $58,$00,$01,$55,$00,$05,$95,$40 ; 4B4F
        .byte   $05,$A5,$90,$16,$A9,$24,$5A,$A9 ; 4B57
        .byte   $00,$00,$09,$00,$00,$0A,$88,$7C ; 4B5F
        .byte   $D0,$7A,$C8,$74,$CE,$78,$C0,$04 ; 4B67
        .byte   $29,$00,$06,$00,$00,$06,$00,$00 ; 4B6F
        .byte   $3F,$00,$01,$FB,$00,$0F,$FA,$00 ; 4B77
        .byte   $3F,$FA,$00,$FF,$F0,$00,$7C,$04 ; 4B7F
        .byte   $25,$00,$10,$00,$0F,$98,$00,$1F ; 4B87
        .byte   $EC,$00,$3D,$FE,$00,$71,$FA,$00 ; 4B8F
        .byte   $00,$7D,$00,$00,$1D,$00,$00,$0E ; 4B97
        .byte   $80,$00,$06,$07,$0C,$00,$02,$AC ; 4B9F
        .byte   $00,$02,$AA,$00,$03,$EA,$A0,$03 ; 4BA7
        .byte   $FF,$00,$0A,$FF,$00,$2B,$FC,$00 ; 4BAF
        .byte   $BF,$FC,$00,$BF,$F8,$01,$BC,$28 ; 4BB7
        .byte   $01,$A8,$2A,$00,$A8,$0B,$00,$6A ; 4BBF
        .byte   $0F,$00,$1A,$0F,$00,$0A,$00,$00 ; 4BC7
        .byte   $07,$C0,$00,$3F,$C0,$00,$3F,$C0 ; 4BCF
        .byte   $88,$11,$0F,$F0,$00,$3F,$FC,$00 ; 4BD7
        .byte   $3F,$FC,$00,$3F,$FC,$00,$3F,$FC ; 4BDF
        .byte   $00,$3F,$FC,$00,$0F,$F0,$00,$02 ; 4BE7
        .byte   $A9,$00,$01,$59,$80,$01,$55,$60 ; 4BEF
        .byte   $01,$95,$60,$02,$95,$60,$0A,$A5 ; 4BF7
        .byte   $50,$06,$29,$50,$18,$00,$00,$68 ; 4BFF
        .byte   $88,$89,$C7,$87,$C1,$81,$C7,$83 ; 4C07
        .byte   $BA,$04,$29,$00,$06,$00,$00,$06 ; 4C0F
        .byte   $00,$00,$3F,$00,$01,$FB,$00,$0F ; 4C17
        .byte   $FA,$00,$3F,$FA,$00,$FF,$F0,$00 ; 4C1F
        .byte   $7C,$04,$25,$00,$10,$00,$0F,$98 ; 4C27
        .byte   $00,$1F,$EC,$00,$3D,$FE,$00,$71 ; 4C2F
        .byte   $FA,$00,$00,$7D,$00,$00,$1D,$00 ; 4C37
        .byte   $00,$0E,$80,$00,$06,$07,$0C,$00 ; 4C3F
        .byte   $02,$AC,$00,$02,$AA,$00,$03,$EA ; 4C47
        .byte   $A0,$03,$FF,$00,$0A,$FF,$00,$2B ; 4C4F
        .byte   $FC,$00,$BF,$FC,$00,$BF,$F8,$01 ; 4C57
        .byte   $BC,$28,$01,$A8,$2A,$00,$A8,$0B ; 4C5F
        .byte   $00,$6A,$0F,$00,$1A,$0F,$00,$0A ; 4C67
        .byte   $00,$00,$07,$C0,$00,$3F,$C0,$00 ; 4C6F
        .byte   $3F,$C0,$88,$11,$0F,$F0,$00,$3F ; 4C77
        .byte   $FC,$00,$3F,$FC,$00,$3F,$FC,$00 ; 4C7F
        .byte   $3F,$FC,$00,$3F,$FC,$00,$0F,$F0 ; 4C87
        .byte   $00,$02,$A9,$00,$01,$59,$80,$01 ; 4C8F
        .byte   $55,$60,$01,$95,$60,$02,$95,$60 ; 4C97
        .byte   $0A,$A5,$50,$06,$29,$50,$18,$00 ; 4C9F
        .byte   $00,$68,$88,$92,$C2,$90,$BC,$8A ; 4CA7
        .byte   $C2,$8D,$B5,$04,$29,$00,$0C,$00 ; 4CAF
        .byte   $00,$7C,$00,$08,$7C,$00,$1F,$F0 ; 4CB7
        .byte   $00,$3F,$80,$00,$7C,$00,$00,$F0 ; 4CBF
        .byte   $00,$00,$E0,$04,$2B,$00,$10,$00 ; 4CC7
        .byte   $3F,$FC,$00,$7F,$FE,$00,$73,$F7 ; 4CCF
        .byte   $00,$F1,$FB,$80,$00,$3D,$80,$00 ; 4CD7
        .byte   $1C,$07,$10,$15,$50,$00,$25,$50 ; 4CDF
        .byte   $00,$0A,$AC,$00,$0F,$FC,$00,$0F ; 4CE7
        .byte   $FC,$00,$0F,$FF,$00,$3F,$FB,$00 ; 4CEF
        .byte   $3F,$EF,$00,$FF,$03,$00,$7B,$00 ; 4CF7
        .byte   $00,$6A,$C0,$00,$6A,$BC,$00,$02 ; 4CFF
        .byte   $BC,$00,$00,$F0,$00,$00,$F0,$00 ; 4D07
        .byte   $00,$C0,$88,$0B,$3F,$C0,$00,$FF ; 4D0F
        .byte   $F0,$00,$FF,$F0,$00,$FF,$F0,$00 ; 4D17
        .byte   $FF,$F0,$00,$FF,$F0,$00,$3F,$C0 ; 4D1F
        .byte   $00,$0F,$A4,$00,$05,$65,$00,$05 ; 4D27
        .byte   $55,$40,$06,$55,$40,$1A,$95,$40 ; 4D2F
        .byte   $1A,$A5,$40,$18,$A9,$40,$18,$00 ; 4D37
        .byte   $00,$58,$00,$00,$A0,$00,$00,$80 ; 4D3F
        .byte   $88,$9C,$B8,$98,$B3,$9C,$B6,$97 ; 4D47
        .byte   $AC,$04,$29,$00,$0C,$00,$00,$7C ; 4D4F
        .byte   $00,$08,$7C,$00,$1F,$F0,$00,$3F ; 4D57
        .byte   $80,$00,$7C,$00,$00,$F0,$00,$00 ; 4D5F
        .byte   $E0,$04,$2B,$00,$10,$00,$3F,$FC ; 4D67
        .byte   $00,$7F,$FE,$00,$73,$F6,$00,$F0 ; 4D6F
        .byte   $FB,$00,$00,$3D,$80,$00,$0C,$07 ; 4D77
        .byte   $10,$15,$50,$00,$29,$50,$00,$0A ; 4D7F
        .byte   $AC,$00,$0A,$FC,$00,$0F,$FC,$00 ; 4D87
        .byte   $0F,$FF,$00,$3F,$FB,$00,$3F,$EF ; 4D8F
        .byte   $00,$FF,$03,$00,$7B,$00,$00,$6A ; 4D97
        .byte   $C0,$00,$6A,$BC,$00,$02,$BC,$00 ; 4D9F
        .byte   $00,$F0,$00,$00,$F0,$00,$00,$C0 ; 4DA7
        .byte   $88,$05,$30,$00,$00,$36,$00,$00 ; 4DAF
        .byte   $FD,$40,$00,$FF,$50,$00,$FF,$50 ; 4DB7
        .byte   $00,$FF,$D0,$00,$FF,$E0,$00,$FF ; 4DBF
        .byte   $A9,$00,$3D,$59,$40,$01,$95,$50 ; 4DC7
        .byte   $01,$95,$50,$06,$A5,$50,$06,$A9 ; 4DCF
        .byte   $50,$06,$2A,$50,$06,$00,$00,$06 ; 4DD7
        .byte   $00,$00,$08,$00,$00,$18,$00,$00 ; 4DDF
        .byte   $20,$00,$00,$20,$88,$A1,$A9,$9D ; 4DE7
        .byte   $A4,$A1,$A7,$9A,$9D,$04,$23,$18 ; 4DEF
        .byte   $00,$00,$38,$00,$00,$60,$00,$00 ; 4DF7
        .byte   $7F,$C0,$00,$7F,$E0,$00,$3F,$E0 ; 4DFF
        .byte   $00,$4F,$E0,$00,$3F,$00,$00,$3F ; 4E07
        .byte   $C0,$00,$10,$07,$1D,$30,$00,$00 ; 4E0F
        .byte   $3C,$00,$00,$38,$00,$00,$3C,$00 ; 4E17
        .byte   $00,$1E,$00,$00,$1E,$00,$00,$1E ; 4E1F
        .byte   $00,$00,$1C,$00,$00,$3E,$00,$00 ; 4E27
        .byte   $3E,$00,$00,$7E,$00,$00,$18,$04 ; 4E2F
        .byte   $10,$10,$00,$00,$6D,$00,$00,$3E ; 4E37
        .byte   $4C,$00,$3F,$9C,$00,$3F,$BC,$00 ; 4E3F
        .byte   $3F,$BC,$00,$3F,$3C,$00,$3F,$00 ; 4E47
        .byte   $00,$3F,$00,$00,$3F,$00,$00,$FF ; 4E4F
        .byte   $00,$00,$FF,$00,$00,$BE,$00,$00 ; 4E57
        .byte   $2A,$F0,$00,$02,$F0,$00,$00,$F0 ; 4E5F
        .byte   $88,$0C,$00,$00,$14,$C9,$80,$60 ; 4E67
        .byte   $DD,$41,$A0,$F5,$56,$80,$FD,$DA ; 4E6F
        .byte   $00,$FF,$D5,$50,$FF,$D5,$50,$FF ; 4E77
        .byte   $D5,$50,$FF,$EA,$A0,$3F,$2A,$A0 ; 4E7F
        .byte   $00,$2A,$A0,$00,$0A,$A0,$00,$02 ; 4E87
        .byte   $A0,$00,$01,$80,$00,$00,$80,$00 ; 4E8F
        .byte   $00,$60,$00,$00,$20,$88,$9F,$A1 ; 4E97
        .byte   $A7,$A1,$A8,$A0,$96,$9F,$04,$22 ; 4E9F
        .byte   $18,$00,$00,$38,$00,$00,$7B,$80 ; 4EA7
        .byte   $00,$7F,$F0,$00,$7F,$F0,$00,$3F ; 4EAF
        .byte   $F8,$00,$01,$F8,$00,$00,$18,$00 ; 4EB7
        .byte   $00,$60,$00,$00,$10,$07,$1D,$30 ; 4EBF
        .byte   $00,$00,$3C,$00,$00,$38,$00,$00 ; 4EC7
        .byte   $3C,$00,$00,$1E,$00,$00,$1E,$00 ; 4ECF
        .byte   $00,$1E,$00,$00,$1C,$00,$00,$3E ; 4ED7
        .byte   $00,$00,$3E,$00,$00,$7E,$00,$00 ; 4EDF
        .byte   $18,$04,$0D,$10,$00,$00,$6D,$00 ; 4EE7
        .byte   $00,$3E,$4C,$00,$3F,$9C,$00,$3F ; 4EEF
        .byte   $BC,$00,$3F,$BC,$00,$3F,$3C,$00 ; 4EF7
        .byte   $3F,$00,$00,$3F,$00,$00,$3F,$00 ; 4EFF
        .byte   $00,$FF,$00,$00,$FF,$50,$00,$3E ; 4F07
        .byte   $AC,$00,$0A,$BC,$00,$00,$3C,$00 ; 4F0F
        .byte   $00,$3C,$00,$00,$0C,$88,$18,$00 ; 4F17
        .byte   $00,$14,$00,$01,$60,$C9,$95,$80 ; 4F1F
        .byte   $DD,$56,$00,$F5,$58,$00,$FD,$DA ; 4F27
        .byte   $00,$FF,$D5,$54,$FF,$E5,$54,$FF ; 4F2F
        .byte   $E9,$54,$FF,$EA,$A8,$3F,$0A,$A8 ; 4F37
        .byte   $00,$00,$A8,$00,$00,$28,$88,$9D ; 4F3F
        .byte   $8F,$A7,$90,$A8,$8F,$94,$8D,$04 ; 4F47
        .byte   $22,$18,$00,$00,$38,$00,$00,$7B ; 4F4F
        .byte   $80,$00,$7F,$F0,$00,$7F,$F0,$00 ; 4F57
        .byte   $3F,$F8,$00,$01,$F8,$00,$00,$18 ; 4F5F
        .byte   $00,$00,$60,$00,$00,$10,$07,$1D ; 4F67
        .byte   $30,$00,$00,$3C,$00,$00,$38,$00 ; 4F6F
        .byte   $00,$3C,$00,$00,$1E,$00,$00,$1E ; 4F77
        .byte   $00,$00,$1E,$00,$00,$1C,$00,$00 ; 4F7F
        .byte   $3E,$00,$00,$3E,$00,$00,$7E,$00 ; 4F87
        .byte   $00,$18,$04,$0D,$10,$00,$00,$6D ; 4F8F
        .byte   $00,$00,$3E,$4C,$00,$3F,$9C,$00 ; 4F97
        .byte   $3F,$BC,$00,$3F,$BC,$00,$3F,$3C ; 4F9F
        .byte   $00,$3F,$00,$00,$3F,$00,$00,$3F ; 4FA7
        .byte   $00,$00,$FF,$00,$00,$FF,$50,$00 ; 4FAF
        .byte   $3E,$AC,$00,$0A,$BC,$00,$00,$3C ; 4FB7
        .byte   $00,$00,$3C,$00,$00,$0C,$88,$18 ; 4FBF
        .byte   $00,$00,$14,$00,$01,$60,$C9,$95 ; 4FC7
        .byte   $80,$DD,$56,$00,$F5,$58,$00,$FD ; 4FCF
        .byte   $DA,$00,$FF,$D5,$54,$FF,$E5,$54 ; 4FD7
        .byte   $FF,$E9,$54,$FF,$EA,$A8,$3F,$0A ; 4FDF
        .byte   $A8,$00,$00,$A8,$00,$00,$28,$88 ; 4FE7
        .byte   $9D,$87,$A7,$88,$A8,$87,$94,$85 ; 4FEF
        .byte   $04,$28,$18,$00,$00,$38,$00,$00 ; 4FF7
        .byte   $7B,$80,$00,$7F,$F0,$00,$7F,$F0 ; 4FFF
        .byte   $00,$7F,$F8,$00,$7F,$F8,$00,$20 ; 5007
        .byte   $38,$07,$1D,$30,$00,$00,$3C,$00 ; 500F
        .byte   $00,$38,$00,$00,$3C,$00,$00,$1E ; 5017
        .byte   $00,$00,$1E,$00,$00,$1E,$00,$00 ; 501F
        .byte   $1C,$00,$00,$3E,$00,$00,$3E,$00 ; 5027
        .byte   $00,$7E,$00,$00,$18,$04,$0D,$10 ; 502F
        .byte   $00,$00,$6D,$00,$00,$3E,$4C,$00 ; 5037
        .byte   $3F,$9C,$00,$3F,$BC,$00,$3F,$BC ; 503F
        .byte   $00,$3F,$3C,$00,$3F,$00,$00,$3F ; 5047
        .byte   $00,$00,$3F,$00,$00,$FF,$00,$00 ; 504F
        .byte   $FF,$50,$00,$3E,$AC,$00,$0A,$BC ; 5057
        .byte   $00,$00,$3C,$00,$00,$3C,$00,$00 ; 505F
        .byte   $0C,$88,$15,$00,$00,$14,$00,$00 ; 5067
        .byte   $18,$30,$01,$60,$F9,$85,$80,$FD ; 506F
        .byte   $56,$00,$FD,$D8,$00,$FF,$DA,$00 ; 5077
        .byte   $FF,$D5,$54,$FF,$E5,$54,$FF,$E9 ; 507F
        .byte   $54,$3F,$29,$68,$00,$0A,$58,$00 ; 5087
        .byte   $00,$A4,$00,$00,$28,$88,$9D,$87 ; 508F
        .byte   $A7,$88,$A8,$87,$94,$84,$04,$29 ; 5097
        .byte   $10,$00,$00,$39,$80,$00,$7F,$F0 ; 509F
        .byte   $00,$7F,$F8,$00,$7F,$F8,$00,$7F ; 50A7
        .byte   $F8,$00,$71,$F0,$00,$40,$07,$26 ; 50AF
        .byte   $60,$00,$00,$F8,$00,$00,$7C,$00 ; 50B7
        .byte   $00,$3E,$00,$00,$0F,$00,$00,$3E ; 50BF
        .byte   $00,$00,$1E,$00,$00,$3C,$00,$00 ; 50C7
        .byte   $1C,$04,$10,$50,$00,$00,$64,$00 ; 50CF
        .byte   $00,$F9,$00,$00,$FE,$40,$00,$FE ; 50D7
        .byte   $C0,$00,$FF,$C0,$00,$FF,$C0,$00 ; 50DF
        .byte   $FF,$00,$00,$FF,$00,$00,$3F,$00 ; 50E7
        .byte   $00,$3D,$40,$00,$3E,$9C,$00,$2A ; 50EF
        .byte   $AC,$00,$2A,$3C,$00,$00,$3C,$00 ; 50F7
        .byte   $00,$0C,$88,$12,$00,$00,$10,$00 ; 50FF
        .byte   $00,$50,$00,$00,$60,$00,$01,$80 ; 5107
        .byte   $3F,$05,$80,$FF,$C6,$00,$FF,$D6 ; 510F
        .byte   $00,$FF,$D5,$00,$FF,$D5,$54,$FF ; 5117
        .byte   $EA,$54,$FF,$EA,$A8,$3F,$2A,$A8 ; 511F
        .byte   $00,$06,$A8,$00,$01,$6C,$00,$00 ; 5127
        .byte   $08,$88,$9C,$8B,$A7,$8C,$A7,$8A ; 512F
        .byte   $93,$86,$04,$2E,$1F,$C0,$00,$1F ; 5137
        .byte   $F8,$00,$3F,$FC,$00,$3D,$FC,$00 ; 513F
        .byte   $4E,$7C,$00,$66,$18,$07,$26,$7C ; 5147
        .byte   $00,$00,$FE,$00,$00,$FE,$00,$00 ; 514F
        .byte   $DE,$00,$00,$BE,$00,$00,$3C,$00 ; 5157
        .byte   $00,$78,$00,$00,$70,$00,$00,$60 ; 515F
        .byte   $04,$1F,$0F,$00,$00,$3F,$C0,$00 ; 5167
        .byte   $3F,$C0,$00,$3F,$C0,$00,$FF,$C0 ; 516F
        .byte   $00,$BF,$80,$00,$0D,$5B,$00,$06 ; 5177
        .byte   $AF,$00,$0A,$7F,$00,$00,$3C,$00 ; 517F
        .byte   $00,$30,$88,$12,$3F,$00,$00,$FF ; 5187
        .byte   $C0,$00,$FF,$C0,$00,$FF,$F8,$00 ; 518F
        .byte   $FF,$FE,$00,$F7,$FE,$80,$D5,$BE ; 5197
        .byte   $AF,$C5,$9F,$BF,$09,$A5,$BF,$00 ; 519F
        .byte   $29,$6F,$00,$18,$5B,$00,$60,$1B ; 51A7
        .byte   $00,$40,$2F,$00,$80,$2E,$00,$00 ; 51AF
        .byte   $02,$88,$9C,$8C,$A9,$8D,$A7,$8E ; 51B7
        .byte   $94,$89,$04,$2E,$0F,$C0,$00,$07 ; 51BF
        .byte   $F0,$00,$03,$DC,$00,$03,$EE,$00 ; 51C7
        .byte   $1E,$E6,$00,$72,$60,$07,$26,$01 ; 51CF
        .byte   $C0,$00,$01,$E0,$00,$01,$E0,$00 ; 51D7
        .byte   $03,$E0,$00,$37,$80,$00,$37,$00 ; 51DF
        .byte   $00,$7E,$00,$00,$E0,$00,$00,$E0 ; 51E7
        .byte   $04,$14,$C0,$00,$00,$F0,$00,$00 ; 51EF
        .byte   $FF,$00,$00,$7F,$C0,$00,$AF,$F0 ; 51F7
        .byte   $00,$9B,$F0,$00,$1F,$FF,$00,$3F ; 51FF
        .byte   $EF,$00,$BF,$AB,$00,$F9,$97,$00 ; 5207
        .byte   $B9,$53,$00,$69,$40,$00,$6E,$80 ; 520F
        .byte   $00,$53,$80,$00,$03,$88,$14,$3F ; 5217
        .byte   $00,$00,$FF,$C0,$00,$FF,$C0,$00 ; 521F
        .byte   $FD,$E7,$00,$F5,$67,$F0,$D5,$66 ; 5227
        .byte   $FC,$DD,$66,$BC,$C9,$66,$AC,$00 ; 522F
        .byte   $16,$EC,$00,$5A,$EC,$00,$60,$A8 ; 5237
        .byte   $00,$60,$28,$01,$80,$18,$01,$80 ; 523F
        .byte   $04,$06,$88,$9A,$8F,$A3,$92,$A3 ; 5247
        .byte   $90,$93,$8C,$04,$29,$0E,$00,$00 ; 524F
        .byte   $3E,$00,$00,$7C,$00,$00,$18,$00 ; 5257
        .byte   $00,$0F,$C0,$00,$1F,$C0,$00,$3F ; 525F
        .byte   $00,$00,$02,$07,$35,$1C,$00,$00 ; 5267
        .byte   $7E,$00,$00,$3E,$00,$00,$06,$04 ; 526F
        .byte   $10,$14,$0C,$00,$15,$5C,$00,$5A ; 5277
        .byte   $9C,$00,$56,$AC,$00,$95,$30,$00 ; 527F
        .byte   $29,$40,$00,$3E,$90,$00,$17,$20 ; 5287
        .byte   $00,$9F,$00,$00,$9A,$50,$00,$AA ; 528F
        .byte   $9C,$00,$2A,$AC,$00,$00,$2C,$00 ; 5297
        .byte   $00,$3C,$00,$00,$0C,$00,$00,$0C ; 529F
        .byte   $88,$13,$3F,$00,$00,$FF,$C0,$50 ; 52A7
        .byte   $FF,$C5,$50,$FF,$C5,$50,$FD,$D6 ; 52AF
        .byte   $90,$F5,$55,$50,$D5,$65,$60,$DD ; 52B7
        .byte   $6A,$A0,$C9,$4A,$80,$00,$06,$80 ; 52BF
        .byte   $00,$06,$80,$00,$16,$00,$00,$18 ; 52C7
        .byte   $00,$00,$60,$00,$00,$60,$88,$9F ; 52CF
        .byte   $96,$A6,$9A,$A5,$95,$95,$95,$04 ; 52D7
        .byte   $23,$30,$00,$00,$78,$00,$00,$78 ; 52DF
        .byte   $00,$00,$7F,$00,$00,$3F,$00,$00 ; 52E7
        .byte   $3F,$00,$00,$FC,$00,$00,$E0,$00 ; 52EF
        .byte   $00,$C0,$00,$00,$40,$07,$35,$38 ; 52F7
        .byte   $00,$00,$30,$00,$00,$30,$00,$00 ; 52FF
        .byte   $78,$04,$0A,$14,$00,$00,$19,$40 ; 5307
        .byte   $00,$6A,$93,$00,$2A,$A7,$00,$0A ; 530F
        .byte   $A7,$00,$0F,$EB,$00,$0F,$CC,$00 ; 5317
        .byte   $0F,$C0,$00,$0F,$C0,$00,$05,$C0 ; 531F
        .byte   $00,$25,$40,$00,$26,$54,$00,$2A ; 5327
        .byte   $AB,$00,$0A,$A7,$00,$00,$0F,$00 ; 532F
        .byte   $00,$0F,$00,$00,$03,$00,$00,$03 ; 5337
        .byte   $88,$06,$00,$00,$05,$00,$00,$1A ; 533F
        .byte   $3F,$00,$60,$FF,$C1,$A0,$FF,$C6 ; 5347
        .byte   $00,$FF,$C5,$58,$FD,$D9,$6A,$F5 ; 534F
        .byte   $59,$6A,$D5,$69,$AA,$DD,$65,$AA ; 5357
        .byte   $C9,$85,$A8,$00,$06,$00,$00,$02 ; 535F
        .byte   $00,$00,$01,$80,$00,$01,$80,$00 ; 5367
        .byte   $00,$80,$00,$00,$80,$00,$00,$60 ; 536F
        .byte   $00,$00,$10,$88,$A1,$99,$A8,$9C ; 5377
        .byte   $A5,$97,$95,$96,$05,$23,$0C,$00 ; 537F
        .byte   $00,$12,$00,$00,$FE,$00,$00,$7E ; 5387
        .byte   $00,$00,$7E,$00,$00,$7E,$00,$00 ; 538F
        .byte   $3F,$00,$00,$07,$00,$00,$03,$00 ; 5397
        .byte   $00,$02,$07,$35,$F0,$00,$00,$F0 ; 539F
        .byte   $00,$00,$F0,$00,$00,$78,$04,$0E ; 53A7
        .byte   $00,$14,$00,$01,$64,$00,$C5,$68 ; 53AF
        .byte   $00,$D6,$A8,$00,$EA,$A0,$00,$EB ; 53B7
        .byte   $F0,$00,$33,$F0,$00,$03,$F0,$00 ; 53BF
        .byte   $03,$F0,$00,$03,$50,$00,$02,$58 ; 53C7
        .byte   $00,$15,$98,$00,$EA,$A8,$00,$DA ; 53CF
        .byte   $A0,$00,$D0,$00,$00,$F0,$00,$00 ; 53D7
        .byte   $30,$88,$02,$10,$00,$00,$18,$00 ; 53DF
        .byte   $00,$D8,$00,$00,$D8,$00,$00,$18 ; 53E7
        .byte   $00,$00,$18,$00,$00,$18,$00,$00 ; 53EF
        .byte   $18,$00,$00,$18,$00,$00,$18,$00 ; 53F7
        .byte   $00,$18,$00,$00,$18,$00,$00,$18 ; 53FF
        .byte   $00,$00,$18,$00,$00,$18,$00,$00 ; 5407
        .byte   $18,$00,$00,$18,$00,$00,$D8,$00 ; 540F
        .byte   $00,$D8,$00,$00,$18,$00,$00,$08 ; 5417
        .byte   $8D,$08,$50,$00,$00,$A4,$00,$00 ; 541F
        .byte   $09,$00,$00,$0A,$40,$03,$00,$92 ; 5427
        .byte   $63,$25,$59,$77,$A9,$59,$57,$A9 ; 542F
        .byte   $55,$5F,$AA,$55,$7F,$AA,$53,$7F ; 5437
        .byte   $2A,$53,$FF,$00,$90,$FC,$00,$80 ; 543F
        .byte   $00,$02,$40,$00,$02,$40,$00,$09 ; 5447
        .byte   $00,$00,$08,$00,$00,$24,$00,$00 ; 544F
        .byte   $10,$88,$7F,$87,$78,$8A,$70,$85 ; 5457
        .byte   $6B,$84,$7B,$84,$05,$23,$0C,$00 ; 545F
        .byte   $00,$12,$00,$00,$FE,$00,$00,$7E ; 5467
        .byte   $00,$00,$7E,$00,$00,$7E,$00,$00 ; 546F
        .byte   $3F,$00,$00,$07,$00,$00,$03,$00 ; 5477
        .byte   $00,$02,$07,$35,$F0,$00,$00,$F0 ; 547F
        .byte   $00,$00,$F0,$00,$00,$78,$04,$14 ; 5487
        .byte   $00,$01,$00,$00,$C6,$40,$03,$D6 ; 548F
        .byte   $00,$03,$5A,$80,$03,$AB,$80,$03 ; 5497
        .byte   $AF,$00,$00,$FE,$80,$00,$3E,$80 ; 549F
        .byte   $00,$3E,$80,$00,$35,$80,$00,$A5 ; 54A7
        .byte   $80,$35,$59,$80,$35,$AA,$80,$FA ; 54AF
        .byte   $AA,$00,$C0,$88,$08,$00,$60,$00 ; 54B7
        .byte   $00,$60,$00,$00,$60,$00,$03,$60 ; 54BF
        .byte   $00,$03,$80,$00,$01,$80,$00,$01 ; 54C7
        .byte   $80,$00,$05,$80,$00,$06,$00,$00 ; 54CF
        .byte   $06,$00,$00,$06,$00,$00,$16,$00 ; 54D7
        .byte   $00,$18,$00,$00,$18,$00,$00,$18 ; 54DF
        .byte   $00,$00,$58,$00,$00,$E0,$00,$00 ; 54E7
        .byte   $E0,$00,$00,$60,$8D,$08,$50,$00 ; 54EF
        .byte   $00,$94,$00,$00,$29,$00,$00,$0A ; 54F7
        .byte   $40,$00,$00,$92,$63,$25,$59,$77 ; 54FF
        .byte   $A9,$59,$57,$AA,$55,$5F,$AA,$55 ; 5507
        .byte   $7F,$AA,$53,$7F,$2A,$53,$FF,$00 ; 550F
        .byte   $90,$FC,$00,$80,$00,$00,$80,$00 ; 5517
        .byte   $02,$40,$00,$02,$40,$00,$02,$40 ; 551F
        .byte   $00,$09,$00,$00,$09,$88,$81,$88 ; 5527
        .byte   $7C,$8B,$71,$86,$6D,$85,$7D,$85 ; 552F
        .byte   $05,$25,$03,$80,$00,$03,$C0,$00 ; 5537
        .byte   $1F,$C0,$00,$0F,$00,$00,$0F,$00 ; 553F
        .byte   $00,$7F,$00,$00,$7F,$C0,$00,$3B ; 5547
        .byte   $E0,$00,$00,$20,$07,$2F,$04,$00 ; 554F
        .byte   $00,$0C,$00,$00,$7C,$00,$00,$7C ; 5557
        .byte   $00,$00,$1C,$00,$00,$0E,$04,$22 ; 555F
        .byte   $01,$50,$00,$02,$50,$00,$02,$A0 ; 5567
        .byte   $00,$03,$C0,$00,$03,$C0,$00,$01 ; 556F
        .byte   $40,$00,$09,$60,$00,$16,$60,$00 ; 5577
        .byte   $AA,$A0,$00,$AA,$80,$88,$14,$00 ; 557F
        .byte   $20,$00,$00,$D8,$00,$00,$D8,$00 ; 5587
        .byte   $00,$58,$00,$01,$78,$00,$01,$78 ; 558F
        .byte   $00,$01,$60,$00,$05,$60,$00,$05 ; 5597
        .byte   $80,$00,$15,$80,$00,$D6,$00,$00 ; 559F
        .byte   $56,$00,$00,$78,$00,$00,$58,$00 ; 55A7
        .byte   $00,$60,$8D,$10,$50,$00,$00,$15 ; 55AF
        .byte   $40,$00,$02,$92,$63,$01,$51,$77 ; 55B7
        .byte   $A9,$59,$57,$AA,$99,$5F,$AA,$65 ; 55BF
        .byte   $7F,$AA,$63,$7F,$2A,$53,$FF,$00 ; 55C7
        .byte   $90,$FC,$00,$50,$00,$00,$90,$00 ; 55CF
        .byte   $00,$90,$00,$00,$90,$00,$00,$50 ; 55D7
        .byte   $00,$00,$40,$88,$7D,$8C,$79,$8F ; 55DF
        .byte   $73,$8E,$6C,$8A,$7B,$8A,$05,$2F ; 55E7
        .byte   $1F,$00,$00,$7F,$80,$00,$FF,$80 ; 55EF
        .byte   $00,$FB,$C0,$00,$F9,$C0,$00,$70 ; 55F7
        .byte   $07,$2F,$1C,$00,$00,$7C,$00,$00 ; 55FF
        .byte   $F8,$00,$00,$FC,$00,$00,$7F,$00 ; 5607
        .byte   $00,$3E,$04,$2B,$00,$50,$00,$05 ; 560F
        .byte   $F8,$00,$D5,$58,$00,$55,$58,$00 ; 5617
        .byte   $D5,$58,$00,$05,$F8,$00,$00,$50 ; 561F
        .byte   $8D,$26,$3F,$00,$00,$FF,$C0,$00 ; 5627
        .byte   $FF,$F0,$00,$FF,$D0,$00,$BD,$40 ; 562F
        .byte   $00,$21,$80,$00,$AB,$C0,$00,$AF ; 5637
        .byte   $C0,$00,$2C,$88,$14,$00,$3F,$C0 ; 563F
        .byte   $00,$FF,$F0,$00,$FF,$F0,$00,$FD ; 5647
        .byte   $F0,$00,$F5,$70,$0A,$97,$70,$2A ; 564F
        .byte   $55,$C0,$2A,$55,$00,$2A,$58,$00 ; 5657
        .byte   $2A,$50,$00,$AA,$90,$00,$AA,$A4 ; 565F
        .byte   $00,$AA,$A9,$40,$AA,$02,$40,$A8 ; 5667
        .byte   $88,$7B,$8A,$75,$8C,$6D,$92,$73 ; 566F
        .byte   $90,$7B,$86,$05,$29,$1E,$00,$00 ; 5677
        .byte   $3C,$00,$00,$FE,$00,$00,$F1,$00 ; 567F
        .byte   $00,$C0,$00,$00,$01,$80,$00,$07 ; 5687
        .byte   $00,$00,$02,$07,$29,$78,$00,$00 ; 568F
        .byte   $F8,$00,$00,$F8,$00,$00,$7C,$00 ; 5697
        .byte   $00,$7E,$00,$00,$1E,$00,$00,$1F ; 569F
        .byte   $00,$00,$07,$04,$11,$00,$05,$00 ; 56A7
        .byte   $00,$09,$00,$00,$F0,$00,$D7,$F0 ; 56AF
        .byte   $00,$F7,$F0,$00,$FA,$FC,$00,$F0 ; 56B7
        .byte   $FC,$00,$00,$FC,$00,$00,$FF,$00 ; 56BF
        .byte   $00,$3F,$00,$00,$6F,$00,$01,$6A ; 56C7
        .byte   $00,$36,$AA,$00,$3E,$80,$00,$0F ; 56CF
        .byte   $00,$00,$03,$88,$0D,$10,$00,$00 ; 56D7
        .byte   $68,$00,$00,$68,$00,$00,$6A,$00 ; 56DF
        .byte   $00,$DA,$00,$00,$DA,$00,$00,$1A ; 56E7
        .byte   $00,$00,$1A,$80,$00,$06,$80,$00 ; 56EF
        .byte   $06,$80,$00,$06,$A0,$00,$01,$A0 ; 56F7
        .byte   $00,$01,$A0,$00,$01,$A8,$00,$01 ; 56FF
        .byte   $A8,$00,$03,$68,$00,$03,$60,$8D ; 5707
        .byte   $0D,$00,$0F,$C0,$00,$3F,$F0,$00 ; 570F
        .byte   $3F,$F0,$00,$3F,$F0,$01,$3F,$F0 ; 5717
        .byte   $05,$77,$F0,$15,$55,$F0,$56,$97 ; 571F
        .byte   $70,$6A,$A6,$30,$AA,$90,$00,$AA ; 5727
        .byte   $90,$00,$02,$40,$00,$02,$40,$00 ; 572F
        .byte   $02,$90,$00,$0A,$A4,$00,$0A,$24 ; 5737
        .byte   $00,$28,$04,$88,$7F,$8F,$79,$91 ; 573F
        .byte   $72,$8F,$6D,$91,$7C,$8B,$05,$22 ; 5747
        .byte   $03,$80,$00,$7F,$C0,$00,$0F,$E0 ; 574F
        .byte   $00,$71,$80,$00,$7F,$C0,$00,$0F ; 5757
        .byte   $C0,$00,$01,$E0,$00,$00,$70,$00 ; 575F
        .byte   $00,$30,$00,$00,$20,$07,$1D,$0C ; 5767
        .byte   $00,$00,$7C,$00,$00,$7C,$00,$00 ; 576F
        .byte   $3C,$00,$00,$78,$00,$00,$78,$00 ; 5777
        .byte   $00,$78,$00,$00,$38,$00,$00,$3C ; 577F
        .byte   $00,$00,$1C,$00,$00,$0E,$00,$00 ; 5787
        .byte   $06,$04,$0E,$00,$14,$00,$01,$E4 ; 578F
        .byte   $00,$C6,$FC,$00,$DB,$FC,$00,$DB ; 5797
        .byte   $F0,$00,$EB,$F0,$00,$33,$F0,$00 ; 579F
        .byte   $03,$F0,$00,$03,$F0,$00,$00,$F0 ; 57A7
        .byte   $00,$00,$FC,$00,$15,$FC,$00,$EA ; 57AF
        .byte   $BC,$00,$DA,$A0,$00,$D0,$00,$00 ; 57B7
        .byte   $F0,$00,$00,$30,$88,$02,$10,$00 ; 57BF
        .byte   $00,$18,$00,$00,$D8,$00,$00,$D8 ; 57C7
        .byte   $00,$00,$18,$00,$00,$18,$00,$00 ; 57CF
        .byte   $18,$00,$00,$18,$00,$00,$18,$00 ; 57D7
        .byte   $00,$18,$00,$00,$18,$00,$00,$18 ; 57DF
        .byte   $00,$00,$18,$00,$00,$18,$00,$00 ; 57E7
        .byte   $18,$00,$00,$18,$00,$00,$18,$00 ; 57EF
        .byte   $00,$D8,$00,$00,$D8,$00,$00,$18 ; 57F7
        .byte   $00,$00,$08,$8D,$14,$00,$03,$F0 ; 57FF
        .byte   $00,$0F,$FC,$00,$0F,$FC,$55,$6F ; 5807
        .byte   $FC,$55,$6F,$FC,$55,$6D,$FC,$AA ; 580F
        .byte   $65,$7C,$AA,$65,$DC,$AA,$69,$8C ; 5817
        .byte   $00,$90,$00,$0A,$80,$00,$2A,$80 ; 581F
        .byte   $00,$28,$00,$00,$A0,$00,$00,$80 ; 5827
        .byte   $88,$7D,$96,$78,$95,$71,$94,$6C ; 582F
        .byte   $93,$7D,$95,$05,$35,$00,$1E,$00 ; 5837
        .byte   $7F,$FF,$00,$1F,$A1,$00,$06,$04 ; 583F
        .byte   $2E,$10,$01,$C0,$38,$07,$80,$77 ; 5847
        .byte   $F8,$00,$17,$F0,$00,$03,$F0,$00 ; 584F
        .byte   $01,$E0,$07,$16,$02,$A8,$00,$02 ; 5857
        .byte   $AF,$00,$00,$FF,$00,$BF,$FF,$00 ; 585F
        .byte   $6F,$FA,$80,$6B,$F9,$80,$AA,$01 ; 5867
        .byte   $A0,$2A,$80,$A0,$0A,$80,$A0,$02 ; 586F
        .byte   $A0,$20,$00,$AC,$3C,$01,$7C,$1C ; 5877
        .byte   $05,$FC,$FC,$0F,$C0,$88,$0B,$F0 ; 587F
        .byte   $00,$00,$FC,$00,$00,$FC,$00,$00 ; 5887
        .byte   $FC,$00,$00,$7C,$00,$00,$5C,$00 ; 588F
        .byte   $00,$7C,$00,$00,$70,$00,$00,$65 ; 5897
        .byte   $40,$00,$A5,$90,$00,$AA,$A0,$00 ; 589F
        .byte   $60,$24,$00,$60,$08,$00,$60,$08 ; 58A7
        .byte   $00,$60,$00,$00,$A8,$00,$00,$A8 ; 58AF
        .byte   $00,$00,$A8,$88,$0C,$00,$00,$F0 ; 58B7
        .byte   $00,$03,$F0,$00,$03,$F0,$00,$01 ; 58BF
        .byte   $50,$00,$02,$A0,$00,$03,$70,$00 ; 58C7
        .byte   $01,$50,$00,$01,$90,$00,$05,$50 ; 58CF
        .byte   $00,$0A,$60,$00,$19,$90,$00,$59 ; 58D7
        .byte   $A0,$01,$A2,$50,$1A,$82,$A0,$64 ; 58DF
        .byte   $00,$90,$00,$00,$50,$00,$00,$20 ; 58E7
        .byte   $88,$B8,$8F,$B6,$88,$B7,$8E,$C0 ; 58EF
        .byte   $80,$AC,$80,$04,$20,$00,$40,$00 ; 58F7
        .byte   $01,$C0,$00,$03,$00,$00,$03,$C0 ; 58FF
        .byte   $00,$03,$E0,$00,$03,$C0,$00,$0F ; 5907
        .byte   $80,$00,$0F,$00,$00,$7E,$00,$00 ; 590F
        .byte   $78,$00,$00,$60,$07,$26,$08,$00 ; 5917
        .byte   $00,$0C,$00,$00,$0E,$00,$00,$1C ; 591F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 5927
        .byte   $00,$00,$00,$70,$00,$00,$10,$04 ; 592F
        .byte   $13,$04,$0C,$00,$25,$4F,$00,$2A ; 5937
        .byte   $97,$00,$2A,$A7,$00,$02,$AB,$00 ; 593F
        .byte   $00,$28,$00,$00,$00,$00,$14,$00 ; 5947
        .byte   $00,$95,$00,$00,$99,$50,$00,$AA ; 594F
        .byte   $AC,$00,$2A,$9C,$00,$00,$1C,$00 ; 5957
        .byte   $00,$3C,$00,$00,$30,$88,$0C,$3F ; 595F
        .byte   $C0,$00,$FF,$F0,$00,$FF,$F0,$55 ; 5967
        .byte   $15,$F1,$AA,$2A,$76,$80,$37,$56 ; 596F
        .byte   $00,$15,$76,$00,$19,$66,$BF,$05 ; 5977
        .byte   $96,$BF,$00,$9A,$BF,$00,$5A,$BF ; 597F
        .byte   $00,$AA,$FC,$00,$A0,$00,$00,$28 ; 5987
        .byte   $00,$00,$0A,$00,$00,$02,$00,$00 ; 598F
        .byte   $00,$80,$88,$77,$AE,$7E,$B2,$7F ; 5997
        .byte   $AF,$70,$AC,$05,$22,$18,$00,$00 ; 599F
        .byte   $38,$00,$00,$7B,$80,$00,$7F,$F0 ; 59A7
        .byte   $00,$7F,$F0,$00,$3F,$F8,$00,$01 ; 59AF
        .byte   $F8,$00,$00,$18,$00,$00,$60,$00 ; 59B7
        .byte   $00,$10,$07,$1D,$30,$00,$00,$3C ; 59BF
        .byte   $00,$00,$38,$00,$00,$3C,$00,$00 ; 59C7
        .byte   $1E,$00,$00,$1E,$00,$00,$1E,$00 ; 59CF
        .byte   $00,$1C,$00,$00,$3E,$00,$00,$3E ; 59D7
        .byte   $00,$00,$7E,$00,$00,$18,$04,$0D ; 59DF
        .byte   $10,$00,$00,$6D,$00,$00,$3E,$4C ; 59E7
        .byte   $00,$3F,$9C,$00,$3F,$BC,$00,$3F ; 59EF
        .byte   $BC,$00,$3F,$3C,$00,$3F,$00,$00 ; 59F7
        .byte   $3F,$00,$00,$3F,$00,$00,$FF,$00 ; 59FF
        .byte   $00,$FF,$50,$00,$3E,$AC,$00,$0A ; 5A07
        .byte   $BC,$00,$00,$3C,$00,$00,$3C,$00 ; 5A0F
        .byte   $00,$0C,$88,$02,$10,$00,$00,$90 ; 5A17
        .byte   $00,$00,$9C,$00,$00,$9C,$00,$00 ; 5A1F
        .byte   $90,$00,$00,$90,$00,$00,$90,$00 ; 5A27
        .byte   $00,$90,$00,$00,$90,$00,$00,$90 ; 5A2F
        .byte   $00,$00,$90,$00,$00,$90,$00,$00 ; 5A37
        .byte   $90,$00,$00,$90,$00,$00,$90,$00 ; 5A3F
        .byte   $00,$90,$00,$00,$90,$00,$00,$9C ; 5A47
        .byte   $00,$00,$9C,$00,$00,$90,$00,$00 ; 5A4F
        .byte   $80,$8D,$18,$00,$00,$14,$00,$01 ; 5A57
        .byte   $60,$C9,$95,$80,$DD,$56,$00,$F5 ; 5A5F
        .byte   $58,$00,$FD,$DA,$00,$FF,$D5,$54 ; 5A67
        .byte   $FF,$E5,$54,$FF,$E9,$54,$FF,$EA ; 5A6F
        .byte   $A8,$3F,$0A,$A8,$00,$00,$A8,$00 ; 5A77
        .byte   $00,$28,$88,$9C,$A9,$A6,$AA,$A7 ; 5A7F
        .byte   $A9,$B3,$A8,$93,$A7,$05,$26,$1F ; 5A87
        .byte   $00,$00,$3F,$00,$00,$7C,$00,$00 ; 5A8F
        .byte   $7E,$00,$00,$1F,$80,$00,$07,$80 ; 5A97
        .byte   $00,$01,$80,$00,$06,$00,$00,$01 ; 5A9F
        .byte   $07,$1D,$30,$00,$00,$3C,$00,$00 ; 5AA7
        .byte   $38,$00,$00,$3C,$00,$00,$1E,$00 ; 5AAF
        .byte   $00,$1E,$00,$00,$1E,$00,$00,$1C ; 5AB7
        .byte   $00,$00,$3E,$00,$00,$3E,$00,$00 ; 5ABF
        .byte   $7E,$00,$00,$18,$04,$0D,$10,$00 ; 5AC7
        .byte   $00,$6D,$00,$00,$3E,$4C,$00,$3F ; 5ACF
        .byte   $9C,$00,$3F,$BC,$00,$3F,$BC,$00 ; 5AD7
        .byte   $3F,$BC,$00,$3F,$A0,$00,$3F,$00 ; 5ADF
        .byte   $00,$3F,$00,$00,$FF,$00,$00,$FF ; 5AE7
        .byte   $50,$00,$3E,$AC,$00,$0A,$BC,$00 ; 5AEF
        .byte   $00,$3C,$00,$00,$3C,$00,$00,$0C ; 5AF7
        .byte   $88,$02,$10,$00,$00,$90,$00,$00 ; 5AFF
        .byte   $9C,$00,$00,$9C,$00,$00,$90,$00 ; 5B07
        .byte   $00,$90,$00,$00,$90,$00,$00,$90 ; 5B0F
        .byte   $00,$00,$90,$00,$00,$90,$00,$00 ; 5B17
        .byte   $90,$00,$00,$90,$00,$00,$90,$00 ; 5B1F
        .byte   $00,$90,$00,$00,$90,$00,$00,$90 ; 5B27
        .byte   $00,$00,$90,$00,$00,$9C,$00,$00 ; 5B2F
        .byte   $9C,$00,$00,$90,$00,$00,$80,$8D ; 5B37
        .byte   $0F,$C0,$00,$00,$D9,$00,$00,$FD ; 5B3F
        .byte   $45,$00,$FD,$E5,$50,$FF,$E9,$A0 ; 5B47
        .byte   $FF,$D5,$A0,$FF,$E5,$A0,$FF,$E9 ; 5B4F
        .byte   $50,$3F,$2A,$A0,$00,$2A,$A0,$00 ; 5B57
        .byte   $0A,$A0,$00,$09,$A0,$00,$01,$40 ; 5B5F
        .byte   $00,$02,$40,$00,$00,$90,$00,$00 ; 5B67
        .byte   $20,$88,$A0,$A5,$A6,$A5,$A7,$A4 ; 5B6F
        .byte   $B3,$A3,$97,$A3,$05,$1D,$18,$00 ; 5B77
        .byte   $00,$20,$00,$00,$7C,$00,$00,$F8 ; 5B7F
        .byte   $00,$00,$64,$00,$00,$7C,$00,$00 ; 5B87
        .byte   $70,$00,$00,$40,$00,$00,$00,$00 ; 5B8F
        .byte   $00,$80,$00,$00,$E0,$00,$00,$40 ; 5B97
        .byte   $07,$23,$70,$00,$00,$7C,$00,$00 ; 5B9F
        .byte   $3F,$00,$00,$1E,$00,$00,$0C,$00 ; 5BA7
        .byte   $00,$1E,$00,$00,$3F,$00,$00,$7F ; 5BAF
        .byte   $00,$00,$3E,$00,$00,$78,$04,$10 ; 5BB7
        .byte   $14,$00,$00,$19,$40,$00,$3E,$93 ; 5BBF
        .byte   $00,$2F,$A7,$00,$2F,$EF,$00,$2F ; 5BC7
        .byte   $DF,$00,$2F,$EF,$00,$2F,$E4,$00 ; 5BCF
        .byte   $2F,$C8,$00,$AF,$C0,$00,$AF,$C0 ; 5BD7
        .byte   $00,$3F,$5F,$00,$2E,$AF,$00,$0A ; 5BDF
        .byte   $AF,$00,$00,$07,$00,$00,$03,$88 ; 5BE7
        .byte   $02,$10,$00,$00,$90,$00,$00,$9C ; 5BEF
        .byte   $00,$00,$9C,$00,$00,$90,$00,$00 ; 5BF7
        .byte   $90,$00,$00,$90,$00,$00,$90,$00 ; 5BFF
        .byte   $00,$90,$00,$00,$90,$00,$00,$90 ; 5C07
        .byte   $00,$00,$90,$00,$00,$90,$00,$00 ; 5C0F
        .byte   $90,$00,$00,$90,$00,$00,$90,$00 ; 5C17
        .byte   $00,$90,$00,$00,$9C,$00,$00,$9C ; 5C1F
        .byte   $00,$00,$90,$00,$00,$80,$8D,$0F ; 5C27
        .byte   $00,$01,$00,$3F,$05,$40,$FF,$C9 ; 5C2F
        .byte   $40,$FF,$DA,$40,$FF,$DA,$80,$FF ; 5C37
        .byte   $DA,$80,$FF,$EA,$80,$FF,$EA,$00 ; 5C3F
        .byte   $3F,$2A,$00,$00,$28,$00,$00,$18 ; 5C47
        .byte   $00,$00,$0A,$00,$00,$02,$80,$00 ; 5C4F
        .byte   $00,$A0,$00,$00,$28,$00,$00,$04 ; 5C57
        .byte   $88,$A3,$A4,$A7,$A3,$A6,$A1,$B3 ; 5C5F
        .byte   $9F,$98,$A4,$05,$1D,$0C,$00,$00 ; 5C67
        .byte   $18,$00,$00,$34,$00,$00,$6C,$00 ; 5C6F
        .byte   $00,$7C,$00,$00,$78,$00,$00,$60 ; 5C77
        .byte   $00,$00,$40,$00,$00,$00,$00,$00 ; 5C7F
        .byte   $20,$00,$00,$10,$00,$00,$08,$07 ; 5C87
        .byte   $26,$3C,$00,$00,$7E,$00,$00,$1C ; 5C8F
        .byte   $00,$00,$18,$00,$00,$1C,$00,$00 ; 5C97
        .byte   $1E,$00,$00,$1E,$00,$00,$3E,$00 ; 5C9F
        .byte   $00,$38,$04,$04,$05,$00,$00,$3E ; 5CA7
        .byte   $4C,$00,$3F,$9C,$00,$BF,$BC,$00 ; 5CAF
        .byte   $BF,$7C,$00,$BF,$9C,$00,$3F,$90 ; 5CB7
        .byte   $00,$3F,$20,$00,$3F,$00,$00,$FF ; 5CBF
        .byte   $00,$00,$FF,$50,$00,$AA,$BC,$00 ; 5CC7
        .byte   $2A,$BC,$00,$00,$1C,$00,$00,$0C ; 5CCF
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 5CD7
        .byte   $00,$00,$00,$10,$00,$00,$24,$88 ; 5CDF
        .byte   $02,$10,$00,$00,$90,$00,$00,$9C ; 5CE7
        .byte   $00,$00,$9C,$00,$00,$90,$00,$00 ; 5CEF
        .byte   $90,$00,$00,$90,$00,$00,$90,$00 ; 5CF7
        .byte   $00,$90,$00,$00,$90,$00,$00,$90 ; 5CFF
        .byte   $00,$00,$90,$00,$00,$90,$00,$00 ; 5D07
        .byte   $90,$00,$00,$90,$00,$00,$90,$00 ; 5D0F
        .byte   $00,$90,$00,$00,$9C,$00,$00,$9C ; 5D17
        .byte   $00,$00,$90,$00,$00,$80,$8D,$0F ; 5D1F
        .byte   $00,$05,$00,$3F,$05,$40,$FF,$EA ; 5D27
        .byte   $80,$FF,$DA,$80,$FF,$DA,$80,$FF ; 5D2F
        .byte   $DA,$80,$FD,$EA,$80,$FD,$4A,$00 ; 5D37
        .byte   $D9,$08,$00,$C0,$0A,$00,$00,$06 ; 5D3F
        .byte   $00,$00,$02,$80,$00,$00,$A0,$00 ; 5D47
        .byte   $00,$28,$00,$00,$0A,$00,$00,$02 ; 5D4F
        .byte   $88,$A3,$A2,$A7,$A0,$A7,$9F,$B2 ; 5D57
        .byte   $9C,$99,$A3,$04,$26,$40,$00,$00 ; 5D5F
        .byte   $C0,$00,$00,$C0,$00,$00,$C0,$00 ; 5D67
        .byte   $00,$E0,$00,$00,$F0,$00,$00,$60 ; 5D6F
        .byte   $00,$00,$60,$00,$00,$30,$07,$26 ; 5D77
        .byte   $70,$00,$00,$F0,$00,$00,$F0,$00 ; 5D7F
        .byte   $00,$40,$00,$00,$F0,$00,$00,$F0 ; 5D87
        .byte   $00,$00,$F0,$00,$00,$F0,$00,$00 ; 5D8F
        .byte   $70,$04,$05,$24,$00,$00,$94,$00 ; 5D97
        .byte   $00,$9C,$00,$00,$BC,$00,$00,$B4 ; 5D9F
        .byte   $00,$00,$94,$00,$00,$94,$00,$00 ; 5DA7
        .byte   $94,$00,$00,$94,$00,$00,$94,$00 ; 5DAF
        .byte   $00,$94,$00,$00,$94,$00,$00,$94 ; 5DB7
        .byte   $00,$00,$94,$00,$00,$94,$00,$00 ; 5DBF
        .byte   $9C,$00,$00,$BC,$00,$00,$B4,$00 ; 5DC7
        .byte   $00,$94,$00,$00,$90,$8D,$03,$00 ; 5DCF
        .byte   $FC,$00,$03,$EA,$90,$03,$EA,$A0 ; 5DD7
        .byte   $03,$EA,$A0,$03,$FA,$00,$07,$F0 ; 5DDF
        .byte   $00,$07,$EA,$90,$37,$EA,$A0,$F7 ; 5DE7
        .byte   $EA,$A0,$F7,$EA,$00,$F5,$B0,$00 ; 5DEF
        .byte   $FE,$B0,$00,$FE,$B0,$00,$3E,$B0 ; 5DF7
        .byte   $00,$0E,$80,$00,$02,$80,$00,$00 ; 5DFF
        .byte   $A0,$00,$00,$28,$00,$00,$09,$00 ; 5E07
        .byte   $00,$02,$40,$88,$A6,$A3,$A8,$9E ; 5E0F
        .byte   $AD,$9A,$A2,$9E,$04,$26,$40,$00 ; 5E17
        .byte   $00,$E0,$00,$00,$E0,$00,$00,$F8 ; 5E1F
        .byte   $00,$00,$C0,$00,$00,$60,$00,$00 ; 5E27
        .byte   $70,$00,$00,$78,$00,$00,$30,$07 ; 5E2F
        .byte   $32,$07,$C0,$00,$1F,$C0,$00,$3F ; 5E37
        .byte   $80,$00,$7E,$00,$00,$4E,$04,$08 ; 5E3F
        .byte   $14,$00,$00,$54,$00,$00,$5C,$00 ; 5E47
        .byte   $00,$FC,$00,$00,$D4,$00,$00,$54 ; 5E4F
        .byte   $00,$00,$54,$00,$00,$54,$00,$00 ; 5E57
        .byte   $54,$00,$00,$54,$00,$00,$54,$00 ; 5E5F
        .byte   $00,$54,$00,$00,$54,$00,$00,$5C ; 5E67
        .byte   $00,$00,$FC,$00,$00,$D4,$00,$00 ; 5E6F
        .byte   $54,$00,$00,$58,$00,$00,$A0,$8D ; 5E77
        .byte   $01,$03,$A8,$00,$0F,$AA,$80,$0F ; 5E7F
        .byte   $EA,$90,$3F,$FA,$A0,$3F,$EA,$A0 ; 5E87
        .byte   $3F,$AA,$80,$2A,$AA,$90,$2A,$AA ; 5E8F
        .byte   $A0,$36,$A2,$A0,$F6,$82,$80,$F5 ; 5E97
        .byte   $A0,$00,$F5,$A0,$00,$F5,$A0,$00 ; 5E9F
        .byte   $FD,$A0,$00,$FD,$B0,$00,$3D,$80 ; 5EA7
        .byte   $00,$01,$80,$00,$00,$90,$00,$00 ; 5EAF
        .byte   $20,$00,$00,$24,$00,$00,$08,$88 ; 5EB7
        .byte   $A7,$A1,$A5,$9D,$AE,$98,$A4,$9D ; 5EBF
        .byte   $03,$2F,$00,$40,$00,$40,$C0,$00 ; 5EC7
        .byte   $7E,$00,$00,$3C,$00,$00,$34,$00 ; 5ECF
        .byte   $00,$20,$07,$11,$00,$18,$00,$00 ; 5ED7
        .byte   $D8,$00,$00,$D8,$00,$01,$78,$00 ; 5EDF
        .byte   $01,$78,$00,$01,$60,$00,$05,$60 ; 5EE7
        .byte   $00,$05,$60,$00,$05,$60,$00,$05 ; 5EEF
        .byte   $80,$00,$35,$80,$00,$36,$00,$00 ; 5EF7
        .byte   $1E,$00,$00,$5C,$00,$00,$58,$00 ; 5EFF
        .byte   $00,$A0,$8D,$04,$00,$04,$00,$0A ; 5F07
        .byte   $59,$00,$05,$5A,$00,$29,$A6,$00 ; 5F0F
        .byte   $A9,$A4,$00,$A9,$64,$00,$2A,$94 ; 5F17
        .byte   $00,$2A,$94,$00,$0A,$A4,$00,$0A ; 5F1F
        .byte   $A8,$00,$09,$A8,$00,$0D,$A8,$00 ; 5F27
        .byte   $0E,$7C,$00,$0E,$6B,$00,$0F,$9B ; 5F2F
        .byte   $00,$03,$9C,$00,$00,$60,$00,$00 ; 5F37
        .byte   $24,$00,$00,$08,$00,$00,$09,$88 ; 5F3F
        .byte   $A7,$A5,$A2,$98,$A3,$9E,$05,$23 ; 5F47
        .byte   $0E,$00,$00,$E6,$00,$00,$F6,$00 ; 5F4F
        .byte   $00,$78,$00,$00,$70,$00,$00,$60 ; 5F57
        .byte   $00,$00,$40,$00,$00,$E0,$00,$00 ; 5F5F
        .byte   $60,$00,$00,$30,$07,$35,$C1,$80 ; 5F67
        .byte   $00,$C3,$80,$00,$E3,$80,$00,$60 ; 5F6F
        .byte   $04,$07,$DB,$C0,$00,$DB,$C0,$00 ; 5F77
        .byte   $F7,$40,$00,$3A,$40,$00,$2A,$50 ; 5F7F
        .byte   $00,$2A,$50,$00,$2A,$A4,$00,$0B ; 5F87
        .byte   $A9,$00,$0B,$A5,$00,$09,$A9,$00 ; 5F8F
        .byte   $01,$BB,$00,$01,$6A,$00,$03,$69 ; 5F97
        .byte   $00,$03,$5F,$00,$00,$DC,$00,$00 ; 5F9F
        .byte   $60,$00,$00,$24,$00,$00,$08,$00 ; 5FA7
        .byte   $00,$09,$88,$1C,$00,$0F,$00,$02 ; 5FAF
        .byte   $64,$00,$FC,$A9,$00,$28,$89,$40 ; 5FB7
        .byte   $18,$92,$40,$18,$9A,$40,$1B,$9A ; 5FBF
        .byte   $80,$1B,$9A,$00,$1B,$90,$00,$37 ; 5FC7
        .byte   $90,$00,$37,$90,$00,$3F,$C0,$88 ; 5FCF
        .byte   $2E,$00,$00,$30,$00,$00,$5D,$30 ; 5FD7
        .byte   $15,$5E,$5D,$55,$A8,$5D,$6A,$00 ; 5FDF
        .byte   $2A,$80,$8D,$A8,$A2,$A3,$9F,$A3 ; 5FE7
        .byte   $9F,$A3,$97,$9E,$93,$04,$2C,$E8 ; 5FEF
        .byte   $00,$00,$78,$00,$00,$3C,$00,$00 ; 5FF7
        .byte   $20,$00,$00,$60,$00,$00,$60,$00 ; 5FFF
        .byte   $00,$60,$07,$32,$60,$00,$00,$7C ; 6007
        .byte   $00,$00,$7C,$00,$00,$78,$00,$00 ; 600F
        .byte   $30,$04,$27,$03,$00,$00,$73,$00 ; 6017
        .byte   $00,$B5,$40,$00,$29,$54,$30,$02 ; 601F
        .byte   $97,$70,$00,$2B,$54,$00,$02,$94 ; 6027
        .byte   $00,$00,$28,$8D,$01,$35,$A4,$00 ; 602F
        .byte   $F6,$64,$00,$FE,$94,$00,$FF,$94 ; 6037
        .byte   $00                             ; 603F
L6040:  .byte   $FE,$A4,$00,$3A,$A4,$00,$2A,$40 ; 6040
        .byte   $00,$2A,$40,$00,$0A,$40,$00,$0A ; 6048
        .byte   $A0,$00,$0E,$94,$00,$0A,$94,$00 ; 6050
        .byte   $0E,$A4,$00,$0E,$78,$00,$0E,$68 ; 6058
        .byte   $00,$0E,$7C,$00,$0E,$7C,$00,$03 ; 6060
        .byte   $B0,$00,$00,$80,$00,$00,$90,$00 ; 6068
        .byte   $00,$20,$88,$AB,$A3,$A4,$9E,$A3 ; 6070
        .byte   $98,$A5,$9D,$05,$20,$10,$00,$00 ; 6078
        .byte   $38,$00,$00,$38,$00,$00,$70,$00 ; 6080
        .byte   $00,$60,$00,$00,$C1,$80,$00,$C3 ; 6088
        .byte   $40,$00,$C2,$80,$00,$30,$00,$00 ; 6090
        .byte   $30,$00,$00,$30,$07,$29,$10,$00 ; 6098
        .byte   $00,$70,$40,$00,$F0,$00,$00,$70 ; 60A0
        .byte   $00,$00,$21,$80,$00,$01,$00,$00 ; 60A8
        .byte   $00,$00,$00,$02,$04,$2E,$F0,$00 ; 60B0
        .byte   $00,$F0,$00,$00,$30,$00,$00,$0C ; 60B8
        .byte   $00,$00,$01,$80,$00,$00,$80,$88 ; 60C0
        .byte   $16,$90,$00,$00,$9C,$00,$00,$24 ; 60C8
        .byte   $00,$00,$24,$00,$00,$09,$00,$00 ; 60D0
        .byte   $09,$00,$00,$02,$40,$00,$02,$40 ; 60D8
        .byte   $00,$00,$90,$00,$00,$9C,$00,$00 ; 60E0
        .byte   $24,$00,$00,$24,$00,$00,$09,$00 ; 60E8
        .byte   $00,$09,$8D,$02,$0E,$F0,$00,$0E ; 60F0
        .byte   $7C,$00,$2D,$55,$00,$29,$55,$C0 ; 60F8
        .byte   $29,$69,$F0,$29,$69,$30,$A9,$59 ; 6100
        .byte   $00,$A5,$55,$00,$A5,$B5,$00,$AA ; 6108
        .byte   $85,$00,$A9,$01,$00,$D9,$40,$00 ; 6110
        .byte   $D9,$40,$00,$EA,$40,$00,$E7,$80 ; 6118
        .byte   $00,$E6,$80,$00,$E7,$C0,$00,$2B ; 6120
        .byte   $00,$00,$08,$00,$00,$18,$00,$00 ; 6128
        .byte   $20,$88,$AD,$9F,$B0,$9C,$B4,$9B ; 6130
        .byte   $B5,$98,$AD,$9D,$05,$26,$30,$00 ; 6138
        .byte   $00,$70,$00,$00,$7F,$80,$00,$7F ; 6140
        .byte   $80,$00,$7C,$00,$00,$E0,$00,$00 ; 6148
        .byte   $80,$00,$00,$70,$00,$00,$30,$07 ; 6150
        .byte   $35,$38,$00,$00,$78,$00,$00,$78 ; 6158
        .byte   $00,$00,$70,$04,$16,$54,$00,$00 ; 6160
        .byte   $65,$30,$00,$69,$70,$00,$56,$B0 ; 6168
        .byte   $00,$56,$80,$00,$2A,$40,$00,$3F ; 6170
        .byte   $00,$00,$3F,$00,$00,$3C,$00,$00 ; 6178
        .byte   $D5,$6C,$00,$55,$AC,$00,$5A,$9C ; 6180
        .byte   $00,$28,$1C,$00,$00,$0C,$88,$02 ; 6188
        .byte   $10,$00,$00,$90,$00,$00,$9C,$00 ; 6190
        .byte   $00,$9C,$00,$00,$90,$00,$00,$90 ; 6198
        .byte   $00,$00,$90,$00,$00,$24,$00,$00 ; 61A0
        .byte   $24,$00,$00,$24,$00,$00,$24,$00 ; 61A8
        .byte   $00,$24,$00,$00,$24,$00,$00,$24 ; 61B0
        .byte   $00,$00,$24,$00,$00,$09,$00,$00 ; 61B8
        .byte   $09,$00,$00,$09,$C0,$00,$09,$C0 ; 61C0
        .byte   $00,$09,$00,$00,$08,$8D,$15,$00 ; 61C8
        .byte   $00,$14,$3F,$01,$54,$FF,$C5,$A8 ; 61D0
        .byte   $FF,$E5,$54,$FD,$E5,$54,$FD,$65 ; 61D8
        .byte   $68,$F5,$65,$A8,$DD,$66,$80,$D9 ; 61E0
        .byte   $4A,$00,$C9,$0A,$40,$00,$02,$80 ; 61E8
        .byte   $00,$00,$90,$00,$00,$24,$00,$00 ; 61F0
        .byte   $08,$88,$A9,$B2,$B2,$B3,$B1,$AE ; 61F8
        .byte   $BB,$AB,$9D,$B1,$05,$23,$30,$00 ; 6200
        .byte   $00,$48,$00,$00,$7F,$00,$00,$7E ; 6208
        .byte   $00,$00,$7E,$00,$00,$7E,$00,$00 ; 6210
        .byte   $FC,$00,$00,$E0,$00,$00,$C0,$00 ; 6218
        .byte   $00,$40,$07,$35,$30,$00,$00,$30 ; 6220
        .byte   $00,$00,$30,$00,$00,$70,$04,$0D ; 6228
        .byte   $50,$00,$00,$65,$00,$00,$AA,$4C ; 6230
        .byte   $00,$AA,$9C,$00,$2A,$9C,$00,$3F ; 6238
        .byte   $AC,$00,$3F,$30,$00,$3F,$00,$00 ; 6240
        .byte   $3F,$00,$00,$17,$00,$00,$95,$00 ; 6248
        .byte   $00,$99,$50,$00,$AA,$AC,$00,$2A ; 6250
        .byte   $9C,$00,$00,$1C,$00,$00,$3C,$00 ; 6258
        .byte   $00,$30,$88,$02,$10,$00,$00,$90 ; 6260
        .byte   $00,$00,$9C,$00,$00,$9C,$00,$00 ; 6268
        .byte   $90,$00,$00,$90,$00,$00,$90,$00 ; 6270
        .byte   $00,$90,$00,$00,$90,$00,$00,$90 ; 6278
        .byte   $00,$00,$90,$00,$00,$90,$00,$00 ; 6280
        .byte   $90,$00,$00,$90,$00,$00,$90,$00 ; 6288
        .byte   $00,$90,$00,$00,$90,$00,$00,$9C ; 6290
        .byte   $00,$00,$9C,$00,$00,$90,$00,$00 ; 6298
        .byte   $80,$8D,$06,$00,$00,$05,$00,$00 ; 62A0
        .byte   $1A,$3F,$00,$60,$FF,$C1,$A0,$FF ; 62A8
        .byte   $C6,$00,$FD,$C5,$58,$F5,$55,$6A ; 62B0
        .byte   $D5,$55,$6A,$D5,$65,$AA,$DD,$65 ; 62B8
        .byte   $AA,$C9,$85,$A8,$00,$06,$00,$00 ; 62C0
        .byte   $02,$00,$00,$01,$80,$00,$01,$80 ; 62C8
        .byte   $00,$00,$80,$00,$00,$80,$00,$00 ; 62D0
        .byte   $60,$00,$00,$10,$88,$AC,$B9,$B3 ; 62D8
        .byte   $BC,$B2,$B7,$BF,$B6,$A0,$B6,$04 ; 62E0
        .byte   $22,$78,$00,$00,$F0,$00,$00,$40 ; 62E8
        .byte   $00,$00,$10,$00,$00,$18,$00,$00 ; 62F0
        .byte   $1C,$00,$00,$0E,$00,$00,$01,$80 ; 62F8
        .byte   $00,$00,$C0,$00,$00,$80,$07,$35 ; 6300
        .byte   $80,$00,$00,$00,$00,$00,$30,$00 ; 6308
        .byte   $00,$78,$04,$0E,$00,$14,$00,$01 ; 6310
        .byte   $64,$00,$C6,$A8,$00,$DA,$A4,$00 ; 6318
        .byte   $DA,$98,$00,$EB,$68,$00,$31,$A0 ; 6320
        .byte   $00,$06,$B0,$00,$1A,$F0,$00,$2B ; 6328
        .byte   $50,$00,$01,$58,$00,$15,$98,$00 ; 6330
        .byte   $EA,$A8,$00,$DA,$A0,$00,$D0,$00 ; 6338
        .byte   $00,$F0,$00,$00,$30,$88,$17,$05 ; 6340
        .byte   $00,$C0,$16,$99,$C0,$5A,$5D,$C0 ; 6348
        .byte   $6A,$55,$C0,$A9,$55,$C0,$AA,$57 ; 6350
        .byte   $C0,$AA,$5F,$C0,$2A,$DF,$C0,$00 ; 6358
        .byte   $BF,$00,$02,$40,$00,$02,$40,$00 ; 6360
        .byte   $0A,$00,$00,$28,$00,$00,$10,$88 ; 6368
        .byte   $AD,$A5,$A8,$A8,$A0,$A3,$AB,$A5 ; 6370
        .byte   $04,$1D,$60,$00,$00,$F0,$00,$00 ; 6378
        .byte   $40,$00,$00,$10,$00,$00,$10,$00 ; 6380
        .byte   $00,$10,$00,$00,$08,$00,$00,$00 ; 6388
        .byte   $00,$00,$00,$00,$00,$04,$00,$00 ; 6390
        .byte   $0C,$00,$00,$08,$07,$35,$80,$00 ; 6398
        .byte   $00,$00,$00,$00,$30,$00,$00,$78 ; 63A0
        .byte   $04,$0E,$00,$05,$00,$00,$59,$00 ; 63A8
        .byte   $31,$A9,$00,$36,$A9,$00,$36,$95 ; 63B0
        .byte   $00,$39,$6A,$00,$36,$AA,$00,$66 ; 63B8
        .byte   $2C,$00,$A8,$3C,$00,$A0,$D4,$00 ; 63C0
        .byte   $00,$56,$00,$05,$66,$00,$3A,$AA ; 63C8
        .byte   $00,$36,$A8,$00,$34,$00,$00,$3C ; 63D0
        .byte   $00,$00,$0C,$88,$11,$01,$40,$00 ; 63D8
        .byte   $05,$42,$F0,$05,$A5,$BC,$06,$95 ; 63E0
        .byte   $DC,$0A,$99,$9C,$0A,$95,$9C,$0A ; 63E8
        .byte   $A5,$DC,$02,$A9,$7C,$00,$A2,$F0 ; 63F0
        .byte   $00,$20,$00,$00,$90,$00,$02,$80 ; 63F8
        .byte   $00,$0A,$00,$00,$28,$00,$00,$A0 ; 6400
        .byte   $00,$00,$40,$88,$AC,$A3,$A8,$A6 ; 6408
        .byte   $9E,$A0,$A6,$A3,$04,$20,$20,$00 ; 6410
        .byte   $00,$70,$00,$00,$20,$00,$00,$10 ; 6418
        .byte   $00,$00,$10,$00,$00,$10,$00,$00 ; 6420
        .byte   $08,$00,$00,$00,$00,$00,$00,$00 ; 6428
        .byte   $00,$20,$00,$00,$40,$07,$38,$30 ; 6430
        .byte   $00,$00,$78,$00,$00,$10,$04,$02 ; 6438
        .byte   $00,$04,$00,$00,$59,$00,$31,$A9 ; 6440
        .byte   $00,$36,$A9,$00,$36,$95,$00,$39 ; 6448
        .byte   $6A,$00,$36,$AA,$00,$66,$2C,$00 ; 6450
        .byte   $A8,$3C,$00,$A0,$D4,$00,$00,$56 ; 6458
        .byte   $00,$05,$66,$00,$3A,$AA,$00,$36 ; 6460
        .byte   $A8,$00,$34,$00,$00,$3C,$00,$00 ; 6468
        .byte   $0C,$00,$00,$00,$00,$00,$00,$00 ; 6470
        .byte   $00,$04,$00,$00,$18,$88,$11,$00 ; 6478
        .byte   $50,$00,$01,$50,$FC,$01,$6B,$FF ; 6480
        .byte   $01,$A7,$FF,$02,$A7,$7F,$02,$A5 ; 6488
        .byte   $7F,$02,$A9,$5F,$00,$A1,$77,$00 ; 6490
        .byte   $22,$67,$00,$A0,$03,$00,$90,$00 ; 6498
        .byte   $02,$80,$00,$0A,$00,$00,$28,$00 ; 64A0
        .byte   $00,$A0,$00,$00,$80,$88,$AB,$A3 ; 64A8
        .byte   $A8,$A5,$9E,$9E,$A3,$A3,$04,$31 ; 64B0
        .byte   $0F,$00,$00,$1F,$80,$00,$3F,$C0 ; 64B8
        .byte   $00,$7F,$B0,$00,$60,$20,$07,$34 ; 64C0
        .byte   $F8,$00,$00,$FE,$00,$00,$03,$00 ; 64C8
        .byte   $00,$00,$80,$04,$05,$0D,$40,$00 ; 64D0
        .byte   $05,$50,$00,$06,$A0,$00,$0A,$A0 ; 64D8
        .byte   $00,$01,$54,$00,$01,$54,$00,$09 ; 64E0
        .byte   $FE,$00,$0B,$FF,$00,$0B,$FF,$00 ; 64E8
        .byte   $0B,$FF,$00,$03,$FF,$00,$03,$FF ; 64F0
        .byte   $00,$03,$FF,$00,$03,$FF,$00,$00 ; 64F8
        .byte   $FC,$00,$00,$90,$00,$02,$80,$00 ; 6500
        .byte   $0A,$00,$00,$18,$00,$00,$60,$88 ; 6508
        .byte   $11,$00,$10,$00,$0D,$50,$00,$0E ; 6510
        .byte   $A0,$00,$0E,$A0,$00,$0A,$50,$00 ; 6518
        .byte   $05,$A8,$00,$1A,$A8,$00,$68,$B0 ; 6520
        .byte   $00,$A0,$F0,$00,$83,$50,$00,$01 ; 6528
        .byte   $50,$00,$05,$90,$00,$0A,$A0,$00 ; 6530
        .byte   $0A,$A0,$00,$0C,$00,$00,$0C,$88 ; 6538
        .byte   $A5,$A1,$A7,$9F,$A1,$9F,$9C,$9F ; 6540
        .byte   $03,$34,$1F,$80,$00,$1F,$C0,$00 ; 6548
        .byte   $7F,$B0,$00,$60,$20,$07,$31,$FF ; 6550
        .byte   $00,$00,$FF,$80,$00,$7F,$80,$00 ; 6558
        .byte   $03,$80,$00,$00,$80,$04,$02,$3F ; 6560
        .byte   $00,$00,$D5,$50,$00,$55,$54,$00 ; 6568
        .byte   $6A,$68,$00,$AA,$68,$00,$15,$68 ; 6570
        .byte   $00,$15,$60,$00,$9F,$E0,$00,$BF ; 6578
        .byte   $F0,$00,$BF,$F0,$00,$BF,$F0,$00 ; 6580
        .byte   $3F,$F0,$00,$3F,$F0,$00,$3F,$F0 ; 6588
        .byte   $00,$3F,$F0,$00,$0F,$C0,$00,$09 ; 6590
        .byte   $00,$00,$28,$00,$00,$20,$00,$00 ; 6598
        .byte   $A0,$00,$00,$80,$88,$A3,$A1,$A7 ; 65A0
        .byte   $9E,$A3,$9D,$04,$31,$07,$80,$00 ; 65A8
        .byte   $3F,$60,$00,$7E,$E0,$00,$40,$E0 ; 65B0
        .byte   $00,$00,$40,$07,$2E,$3C,$00,$00 ; 65B8
        .byte   $FF,$80,$00,$FF,$C0,$00,$1F,$C0 ; 65C0
        .byte   $00,$07,$C0,$00,$07,$80,$04,$08 ; 65C8
        .byte   $01,$AA,$00,$01,$56,$00,$02,$6A ; 65D0
        .byte   $00,$00,$6A,$00,$01,$6A,$00,$05 ; 65D8
        .byte   $68,$00,$2F,$E8,$00,$3F,$F0,$00 ; 65E0
        .byte   $3F,$F0,$00,$3F,$F0,$00,$3F,$F0 ; 65E8
        .byte   $00,$3F,$F0,$00,$3F,$F0,$00,$3F ; 65F0
        .byte   $F0,$00,$0F,$C0,$00,$09,$00,$00 ; 65F8
        .byte   $28,$00,$00,$20,$00,$00,$A0,$88 ; 6600
        .byte   $32,$F0,$00,$00,$3C,$00,$00,$14 ; 6608
        .byte   $00,$00,$58,$00,$00,$68,$88,$A4 ; 6610
        .byte   $A3,$AA,$A0,$A2,$A0,$A9,$9C,$04 ; 6618
        .byte   $2C,$60,$00,$00,$77,$00,$00,$3E ; 6620
        .byte   $C0,$00,$05,$80,$00,$03,$00,$00 ; 6628
        .byte   $02,$00,$00,$02,$07,$31,$FF,$80 ; 6630
        .byte   $00,$FF,$C0,$00,$3F,$C0,$00,$07 ; 6638
        .byte   $C0,$00,$07,$80,$04,$0B,$05,$58 ; 6640
        .byte   $00,$09,$A8,$00,$01,$A8,$00,$05 ; 6648
        .byte   $A8,$00,$01,$A0,$00,$3F,$A0,$00 ; 6650
        .byte   $FF,$C0,$00,$FF,$C0,$00,$FF,$C0 ; 6658
        .byte   $00,$FF,$C0,$00,$FF,$C0,$00,$FF ; 6660
        .byte   $C0,$00,$FF,$C0,$00,$3F,$00,$00 ; 6668
        .byte   $09,$00,$00,$28,$00,$00,$20,$00 ; 6670
        .byte   $00,$A0,$88,$28,$0F,$C0,$00,$02 ; 6678
        .byte   $F0,$00,$06,$CF,$00,$1A,$0F,$C0 ; 6680
        .byte   $68,$0A,$00,$60,$09,$00,$AA,$09 ; 6688
        .byte   $00,$0A,$89,$88,$A6,$A3,$A8,$A1 ; 6690
        .byte   $A2,$A1,$A4,$9B,$04,$2F,$0F,$80 ; 6698
        .byte   $00,$1F,$80,$00,$7F,$00,$00,$7F ; 66A0
        .byte   $00,$00,$0E,$00,$00,$02,$07,$2B ; 66A8
        .byte   $03,$C0,$00,$1F,$E0,$00,$1F,$E0 ; 66B0
        .byte   $00,$7F,$E0,$00,$FF,$C0,$00,$F7 ; 66B8
        .byte   $C0,$00,$07,$80,$04,$02,$01,$40 ; 66C0
        .byte   $00,$06,$40,$00,$1A,$00,$00,$59 ; 66C8
        .byte   $60,$00,$6A,$A0,$00,$66,$A0,$00 ; 66D0
        .byte   $06,$A0,$00,$06,$80,$00,$0A,$80 ; 66D8
        .byte   $00,$3F,$80,$00,$FF,$C0,$00,$FF ; 66E0
        .byte   $C0,$00,$FF,$C0,$00,$FF,$C0,$00 ; 66E8
        .byte   $FF,$C0,$00,$FF,$C0,$00,$FF,$C0 ; 66F0
        .byte   $00,$3F,$00,$00,$08,$00,$00,$28 ; 66F8
        .byte   $00,$00,$20,$88,$35,$0F,$00,$00 ; 6700
        .byte   $3F,$00,$00,$FC,$00,$00,$F0,$88 ; 6708
        .byte   $A5,$A2,$A5,$9E,$A1,$9E,$A5,$9C ; 6710
        .byte   $03,$2F,$1E,$00,$00,$3E,$00,$00 ; 6718
        .byte   $7E,$00,$00,$3E,$00,$00,$7E,$00 ; 6720
        .byte   $00,$02,$07,$2C,$07,$80,$00,$3F ; 6728
        .byte   $C0,$00,$7F,$C0,$00,$7F,$C0,$00 ; 6730
        .byte   $FD,$C0,$00,$F1,$C0,$00,$30,$04 ; 6738
        .byte   $01,$03,$C0,$00,$0E,$C0,$00,$3E ; 6740
        .byte   $A0,$00,$FA,$A0,$00,$DA,$A0,$00 ; 6748
        .byte   $1A,$A0,$00,$5A,$A8,$00,$5A,$A8 ; 6750
        .byte   $00,$6A,$A8,$00,$03,$F8,$00,$0F ; 6758
        .byte   $FC,$00,$0F,$FC,$00,$0F,$FC,$00 ; 6760
        .byte   $0F,$FC,$00,$0F,$FC,$00,$0F,$FC ; 6768
        .byte   $00,$0F,$FC,$00,$03,$F0,$00,$00 ; 6770
        .byte   $80,$00,$00,$90,$00,$00,$20,$88 ; 6778
        .byte   $A2,$A2,$A0,$9F,$9B,$9E,$04,$1F ; 6780
        .byte   $70,$00,$00,$7E,$00,$00,$0F,$C0 ; 6788
        .byte   $00,$71,$E0,$00,$7F,$80,$00,$7F ; 6790
        .byte   $C0,$00,$0F,$C0,$00,$01,$E0,$00 ; 6798
        .byte   $00,$70,$00,$00,$30,$00,$00,$20 ; 67A0
        .byte   $07,$1D,$3C,$00,$00,$7C,$00,$00 ; 67A8
        .byte   $7C,$00,$00,$3C,$00,$00,$78,$00 ; 67B0
        .byte   $00,$78,$00,$00,$78,$00,$00,$38 ; 67B8
        .byte   $00,$00,$3C,$00,$00,$1C,$00,$00 ; 67C0
        .byte   $0E,$00,$00,$06,$04,$17,$00,$E4 ; 67C8
        .byte   $00,$01,$FC,$00,$37,$FC,$00,$3B ; 67D0
        .byte   $F0,$00,$3B,$F0,$00,$33,$F0,$00 ; 67D8
        .byte   $03,$F0,$00,$03,$F0,$00,$00,$F0 ; 67E0
        .byte   $00,$D4,$FC,$00,$E9,$FC,$00,$DA ; 67E8
        .byte   $BC,$00,$F0,$A0,$00,$30,$88,$17 ; 67F0
        .byte   $50,$00,$00,$55,$43,$F0,$55,$6F ; 67F8
        .byte   $FC,$55,$6F,$FC,$55,$6F,$FC,$AA ; 6800
        .byte   $6F,$FC,$0A,$6D,$FC,$00,$65,$7C ; 6808
        .byte   $00,$99,$DC,$0A,$99,$8C,$2A,$80 ; 6810
        .byte   $00,$28,$00,$00,$A0,$00,$00,$80 ; 6818
        .byte   $88,$A1,$A0,$9C,$A0,$95,$A0,$A1 ; 6820
        .byte   $A1,$04,$22,$03,$80,$00,$7F,$C0 ; 6828
        .byte   $00,$0F,$E0,$00,$71,$80,$00,$7F ; 6830
        .byte   $C0,$00,$0F,$C0,$00,$01,$E0,$00 ; 6838
        .byte   $00,$70,$00,$00,$30,$00,$00,$20 ; 6840
        .byte   $07,$1D,$0C,$00,$00,$7C,$00,$00 ; 6848
        .byte   $7C,$00,$00,$3C,$00,$00,$78,$00 ; 6850
        .byte   $00,$78,$00,$00,$78,$00,$00,$38 ; 6858
        .byte   $00,$00,$3C,$00,$00,$1C,$00,$00 ; 6860
        .byte   $0E,$00,$00,$06,$04,$0E,$00,$14 ; 6868
        .byte   $00,$01,$E4,$00,$C6,$FC,$00,$DB ; 6870
        .byte   $FC,$00,$DB,$F0,$00,$EB,$F0,$00 ; 6878
        .byte   $33,$F0,$00,$03,$F0,$00,$03,$F0 ; 6880
        .byte   $00,$00,$F0,$00,$00,$FC,$00,$15 ; 6888
        .byte   $FC,$00,$EA,$BC,$00,$DA,$A0,$00 ; 6890
        .byte   $D0,$00,$00,$F0,$00,$00,$30,$88 ; 6898
        .byte   $14,$00,$03,$F0,$00,$0F,$FC,$00 ; 68A0
        .byte   $0F,$FC,$55,$6F,$FC,$55,$6F,$FC ; 68A8
        .byte   $55,$6D,$FC,$AA,$65,$7C,$AA,$65 ; 68B0
        .byte   $DC,$AA,$69,$8C,$00,$90,$00,$0A ; 68B8
        .byte   $80,$00,$2A,$80,$00,$28,$00,$00 ; 68C0
        .byte   $A0,$00,$00,$80,$88,$A5,$B0,$A0 ; 68C8
        .byte   $AF,$99,$AE,$A5,$AF,$05,$31,$03 ; 68D0
        .byte   $C0,$00,$FF,$F0,$00,$FF,$F8,$00 ; 68D8
        .byte   $7E,$1F,$80,$00,$03,$07,$2C,$0F ; 68E0
        .byte   $00,$00,$2F,$C0,$00,$CF,$C0,$00 ; 68E8
        .byte   $3F,$C0,$00,$7F,$C0,$00,$7F,$F0 ; 68F0
        .byte   $00,$1C,$04,$24,$00,$3F,$00,$05 ; 68F8
        .byte   $FF,$C0,$55,$FF,$C0,$59,$5F,$C0 ; 6900
        .byte   $5A,$55,$D0,$AA,$A5,$68,$AA,$AA ; 6908
        .byte   $50,$AA,$AE,$95,$00,$00,$2A,$88 ; 6910
        .byte   $25,$00,$03,$C0,$00,$0F,$F5,$54 ; 6918
        .byte   $7F,$F5,$A5,$7F,$FA,$0A,$BF,$FA ; 6920
        .byte   $D4,$5F,$FC,$E9,$5F,$FC,$AA,$AF ; 6928
        .byte   $00,$02,$A0,$88,$26,$0C,$00,$00 ; 6930
        .byte   $3C,$00,$00,$F0,$00,$00,$00,$00 ; 6938
        .byte   $00,$0C,$00,$00,$3C,$00,$00,$FC ; 6940
        .byte   $00,$00,$F8,$00,$00,$C0,$88,$5C ; 6948
        .byte   $E1,$52,$E1,$5E,$E0,$48,$E1,$43 ; 6950
        .byte   $E1,$04,$30,$03,$C0,$00,$7F,$F0 ; 6958
        .byte   $00,$7F,$F8,$00,$7E,$1F,$80,$00 ; 6960
        .byte   $03,$80,$07,$2C,$0F,$00,$00,$2F ; 6968
        .byte   $C0,$00,$CF,$C0,$00,$3F,$C0,$00 ; 6970
        .byte   $7F,$C0,$00,$7F,$F0,$00,$1C,$04 ; 6978
        .byte   $25,$00,$3F,$00,$00,$FF,$C0,$05 ; 6980
        .byte   $FF,$C0,$55,$FF,$C0,$59,$5F,$C5 ; 6988
        .byte   $5A,$55,$56,$AA,$A5,$68,$AA,$AA ; 6990
        .byte   $80,$AA,$A8,$88,$19,$0F,$00,$00 ; 6998
        .byte   $3F,$C0,$00,$FD,$C0,$00,$FD,$40 ; 69A0
        .byte   $00,$09,$43,$C0,$09,$4F,$F5,$09 ; 69A8
        .byte   $7F,$F5,$09,$BF,$FA,$09,$BF,$FA ; 69B0
        .byte   $09,$5F,$FC,$0A,$5F,$FC,$0A,$AF ; 69B8
        .byte   $00,$02,$A0,$88,$65,$E1,$5B,$E1 ; 69C0
        .byte   $67,$DF,$51,$DD,$04,$33,$1F,$F0 ; 69C8
        .byte   $00,$FF,$FB,$80,$7F,$FF,$80,$1E ; 69D0
        .byte   $0F,$80,$07,$29,$1C,$00,$00,$37 ; 69D8
        .byte   $00,$00,$6F,$80,$00,$1F,$80,$00 ; 69E0
        .byte   $0F,$80,$00,$0F,$00,$00,$0E,$00 ; 69E8
        .byte   $00,$08,$04,$1E,$00,$04,$00,$00 ; 69F0
        .byte   $18,$00,$00,$7F,$01,$05,$FF,$55 ; 69F8
        .byte   $55,$F5,$58,$59,$56,$80,$5A,$6B ; 6A00
        .byte   $C0,$AA,$AF,$C0,$AA,$AB,$C0,$02 ; 6A08
        .byte   $AE,$C0,$00,$00,$C0,$88,$1F,$0F ; 6A10
        .byte   $00,$00,$0F,$00,$14,$3D,$02,$54 ; 6A18
        .byte   $3E,$4E,$58,$36,$7F,$D8,$FA,$7F ; 6A20
        .byte   $E8,$FA,$9F,$F0,$CA,$9F,$C0,$02 ; 6A28
        .byte   $AF,$C0,$00,$AF,$00,$00,$2C,$88 ; 6A30
        .byte   $64,$DC,$5D,$DD,$68,$D9,$54,$DB ; 6A38
        .byte   $04,$33,$1F,$FE,$00,$FF,$FF,$80 ; 6A40
        .byte   $1F,$F9,$E0,$07,$80,$60,$07,$28 ; 6A48
        .byte   $38,$00,$00,$7E,$00,$00,$7F,$00 ; 6A50
        .byte   $00,$5F,$C0,$00,$5F,$E0,$00,$0F ; 6A58
        .byte   $F0,$00,$07,$F8,$00,$00,$3C,$04 ; 6A60
        .byte   $1E,$00,$00,$FC,$50,$2B,$FF,$55 ; 6A68
        .byte   $67,$FF,$15,$65,$FF,$15,$69,$FF ; 6A70
        .byte   $0A,$AA,$7F,$0A,$AA,$5F,$00,$0A ; 6A78
        .byte   $97,$00,$00,$A7,$00,$00,$25,$00 ; 6A80
        .byte   $00,$09,$88,$11,$00,$50,$00,$0D ; 6A88
        .byte   $50,$00,$3F,$60,$00,$3F,$E0,$00 ; 6A90
        .byte   $3F,$E0,$00,$FF,$F0,$00,$EF,$FC ; 6A98
        .byte   $00,$FB,$FC,$00,$C0,$FF,$00,$00 ; 6AA0
        .byte   $ED,$00,$03,$A9,$00,$3E,$A9,$00 ; 6AA8
        .byte   $3E,$80,$00,$0F,$00,$00,$0F,$00 ; 6AB0
        .byte   $00,$03,$88,$70,$D5,$6C,$D6,$72 ; 6AB8
        .byte   $D4,$6A,$D5,$04,$2E,$03,$F8,$00 ; 6AC0
        .byte   $0F,$FE,$00,$3F,$9E,$00,$78,$06 ; 6AC8
        .byte   $00,$00,$02,$00,$00,$02,$07,$2E ; 6AD0
        .byte   $20,$00,$00,$78,$00,$00,$7F,$00 ; 6AD8
        .byte   $00,$7F,$E0,$00,$5F,$F0,$00,$03 ; 6AE0
        .byte   $C0,$04,$12,$05,$50,$FC,$15,$57 ; 6AE8
        .byte   $FF,$55,$97,$FF,$5A,$A7,$FF,$EA ; 6AF0
        .byte   $A7,$FF,$3A,$27,$7F,$3C,$25,$5F ; 6AF8
        .byte   $3C,$25,$77,$00,$26,$63,$00,$24 ; 6B00
        .byte   $80,$00,$08,$80,$00,$09,$00,$00 ; 6B08
        .byte   $02,$00,$00,$02,$40,$00,$00,$80 ; 6B10
        .byte   $88,$1D,$03,$00,$00,$0F,$00,$00 ; 6B18
        .byte   $0F,$C0,$00,$0F,$F0,$00,$0F,$FC ; 6B20
        .byte   $00,$0F,$F9,$00,$FE,$E6,$40,$F5 ; 6B28
        .byte   $69,$40,$FA,$A9,$80,$FA,$A9,$80 ; 6B30
        .byte   $CC,$00,$00,$C0,$88,$74,$D1,$72 ; 6B38
        .byte   $D4,$75,$D1,$70,$D4,$04,$32,$01 ; 6B40
        .byte   $F8,$00,$1F,$FC,$00,$7F,$8C,$00 ; 6B48
        .byte   $3C,$00,$00,$10,$07,$38,$E0,$00 ; 6B50
        .byte   $00,$70,$00,$00,$38,$04,$0F,$00 ; 6B58
        .byte   $00,$FC,$01,$57,$FF,$15,$57,$FF ; 6B60
        .byte   $55,$A7,$FF,$55,$A7,$FF,$1A,$A7 ; 6B68
        .byte   $7F,$2A,$25,$5F,$20,$25,$77,$00 ; 6B70
        .byte   $26,$63,$00,$24,$80,$00,$24,$68 ; 6B78
        .byte   $00,$04,$00,$00,$09,$00,$00,$01 ; 6B80
        .byte   $00,$00,$02,$40,$00,$00,$80,$88 ; 6B88
        .byte   $22,$00,$C0,$00,$3F,$F0,$00,$3B ; 6B90
        .byte   $FC,$00,$EB,$FC,$00,$CB,$68,$00 ; 6B98
        .byte   $CF,$98,$00,$0F,$98,$00,$0C,$98 ; 6BA0
        .byte   $00,$00,$A8,$00,$00,$20,$88,$8B ; 6BA8
        .byte   $CD,$87,$D0,$8B,$CC,$82,$D0,$05 ; 6BB0
        .byte   $2F,$40,$20,$00,$FF,$E0,$00,$F8 ; 6BB8
        .byte   $60,$00,$F8,$70,$00,$E8,$10,$00 ; 6BC0
        .byte   $60,$04,$23,$20,$0E,$00,$30,$7F ; 6BC8
        .byte   $00,$1D,$FF,$00,$1D,$FC,$00,$1F ; 6BD0
        .byte   $F0,$00,$1B,$E0,$00,$3B,$C0,$00 ; 6BD8
        .byte   $37,$80,$00,$6C,$00,$00,$40,$07 ; 6BE0
        .byte   $24,$00,$0F,$00,$0C,$0F,$00,$3E ; 6BE8
        .byte   $FF,$C0,$FE,$BF,$80,$FE,$FF,$A0 ; 6BF0
        .byte   $FA,$FE,$A0,$02,$FE,$90,$02,$A2 ; 6BF8
        .byte   $90,$00,$80,$A0,$88,$0A,$03,$C0 ; 6C00
        .byte   $00,$0F,$C0,$00,$0F,$C0,$00,$0F ; 6C08
        .byte   $C0,$00,$8F,$C0,$00,$8F,$C0,$00 ; 6C10
        .byte   $AF,$C0,$00,$AB,$C0,$00,$1A,$80 ; 6C18
        .byte   $00,$06,$40,$00,$06,$40,$00,$05 ; 6C20
        .byte   $40,$00,$05,$40,$00,$05,$40,$00 ; 6C28
        .byte   $06,$80,$00,$0A,$80,$00,$0A,$80 ; 6C30
        .byte   $00,$00,$80,$88,$11,$F0,$00,$00 ; 6C38
        .byte   $FC,$00,$00,$FC,$00,$00,$FC,$00 ; 6C40
        .byte   $00,$F0,$00,$00,$E0,$00,$00,$D0 ; 6C48
        .byte   $16,$00,$E1,$68,$00,$55,$60,$00 ; 6C50
        .byte   $55,$80,$00,$56,$00,$00,$68,$00 ; 6C58
        .byte   $00,$A0,$00,$00,$80,$00,$00,$80 ; 6C60
        .byte   $00,$00,$80,$88,$93,$D0,$94,$C7 ; 6C68
        .byte   $8D,$D0,$93,$C0,$9D,$C0,$05,$2E ; 6C70
        .byte   $40,$20,$00,$FF,$E0,$00,$FF,$E0 ; 6C78
        .byte   $00,$FF,$F8,$00,$EF,$F8,$00,$67 ; 6C80
        .byte   $E0,$04,$23,$60,$00,$00,$70,$7C ; 6C88
        .byte   $00,$1D,$FF,$80,$1D,$FF,$00,$1F ; 6C90
        .byte   $F0,$00,$1B,$E0,$00,$3B,$C0,$00 ; 6C98
        .byte   $37,$80,$00,$6C,$00,$00,$40,$07 ; 6CA0
        .byte   $19,$00,$A0,$00,$00,$80,$00,$FF ; 6CA8
        .byte   $F8,$00,$FF,$FA,$00,$FF,$EA,$00 ; 6CB0
        .byte   $BF,$E9,$00,$BF,$A5,$00,$A0,$A4 ; 6CB8
        .byte   $00,$E0,$D0,$00,$C0,$E0,$00,$F3 ; 6CC0
        .byte   $E0,$00,$F3,$C0,$00,$F3,$C0,$88 ; 6CC8
        .byte   $0A,$00,$3C,$00,$00,$FC,$00,$00 ; 6CD0
        .byte   $FC,$00,$00,$FC,$00,$00,$FC,$00 ; 6CD8
        .byte   $00,$FC,$00,$A8,$FC,$00,$2A,$BC ; 6CE0
        .byte   $00,$09,$A8,$00,$00,$64,$00,$00 ; 6CE8
        .byte   $64,$00,$00,$54,$00,$00,$54,$00 ; 6CF0
        .byte   $00,$54,$00,$00,$68,$00,$00,$A8 ; 6CF8
        .byte   $00,$00,$A8,$00,$00,$08,$88,$11 ; 6D00
        .byte   $F0,$00,$00,$FC,$00,$00,$FC,$00 ; 6D08
        .byte   $00,$FC,$00,$00,$F0,$00,$00,$E0 ; 6D10
        .byte   $00,$00,$D0,$00,$00,$E0,$00,$00 ; 6D18
        .byte   $54,$00,$00,$55,$00,$00,$56,$40 ; 6D20
        .byte   $00,$6A,$58,$00,$A0,$AA,$50,$80 ; 6D28
        .byte   $09,$40,$80,$00,$00,$80,$88,$99 ; 6D30
        .byte   $C4,$9A,$BB,$98,$C4,$95,$B4,$A3 ; 6D38
        .byte   $B4,$04,$1D,$38,$00,$00,$7C,$00 ; 6D40
        .byte   $00,$3C,$00,$00,$1E,$00,$00,$1E ; 6D48
        .byte   $00,$00,$0C,$00,$00,$0C,$00,$00 ; 6D50
        .byte   $04,$00,$00,$04,$00,$00,$07,$00 ; 6D58
        .byte   $00,$07,$00,$00,$07,$07,$32,$7E ; 6D60
        .byte   $00,$00,$FF,$00,$00,$7F,$00,$00 ; 6D68
        .byte   $70,$00,$00,$60,$04,$04,$05,$50 ; 6D70
        .byte   $00,$15,$50,$00,$1D,$50,$00,$1D ; 6D78
        .byte   $50,$00,$9E,$50,$00,$9F,$90,$00 ; 6D80
        .byte   $AF,$94,$FC,$A0,$97,$FF,$80,$97 ; 6D88
        .byte   $FF,$00,$A7,$FF,$00,$27,$FF,$00 ; 6D90
        .byte   $27,$7F,$00,$25,$5F,$00,$25,$77 ; 6D98
        .byte   $00,$26,$63,$00,$92,$00,$00,$92 ; 6DA0
        .byte   $00,$00,$90,$00,$00,$90,$00,$00 ; 6DA8
        .byte   $90,$88,$2C,$0F,$00,$00,$3F,$00 ; 6DB0
        .byte   $00,$FD,$00,$00,$F9,$00,$00,$09 ; 6DB8
        .byte   $00,$00,$0A,$00,$00,$0A,$88,$98 ; 6DC0
        .byte   $B1,$95,$AE,$91,$AE,$8C,$AC,$04 ; 6DC8
        .byte   $2C,$08,$00,$00,$0A,$00,$00,$0A ; 6DD0
        .byte   $00,$00,$8A,$00,$00,$8A,$00,$00 ; 6DD8
        .byte   $A8,$00,$00,$20,$87,$2B,$B2,$00 ; 6DE0
        .byte   $00,$1F,$80,$00,$0F,$E0,$00,$03 ; 6DE8
        .byte   $E8,$00,$00,$EC,$00,$00,$3C,$00 ; 6DF0
        .byte   $00,$0C,$04,$10,$20,$00,$00,$14 ; 6DF8
        .byte   $00,$00,$08,$00,$00,$09,$00,$00 ; 6E00
        .byte   $02,$40,$40,$02,$41,$68,$00,$91 ; 6E08
        .byte   $68,$40,$99,$A8,$9F,$95,$A8,$3F ; 6E10
        .byte   $A6,$A0,$3F,$EA,$A0,$3F,$FA,$80 ; 6E18
        .byte   $3F,$FE,$00,$3F,$FC,$00,$3F,$FC ; 6E20
        .byte   $00,$0F,$F0,$88,$11,$00,$C0,$00 ; 6E28
        .byte   $00,$F0,$00,$00,$F0,$00,$02,$BC ; 6E30
        .byte   $00,$6A,$BC,$00,$6A,$C0,$00,$7B ; 6E38
        .byte   $00,$00,$FF,$03,$00,$3F,$EF,$00 ; 6E40
        .byte   $3F,$FB,$00,$0F,$FF,$00,$0A,$FC ; 6E48
        .byte   $00,$09,$FC,$00,$09,$6C,$00,$09 ; 6E50
        .byte   $60,$00,$0A,$88,$A4,$AA,$A1,$A5 ; 6E58
        .byte   $9A,$A7,$A1,$9E,$04,$2F,$01,$C0 ; 6E60
        .byte   $00,$07,$E0,$00,$0F,$F0,$00,$CF ; 6E68
        .byte   $D0,$00,$C8,$80,$00,$40,$07,$38 ; 6E70
        .byte   $7C,$00,$00,$3C,$00,$00,$1C,$04 ; 6E78
        .byte   $0F,$01,$00,$00,$02,$40,$00,$00 ; 6E80
        .byte   $40,$00,$00,$90,$00,$00,$10,$00 ; 6E88
        .byte   $29,$18,$00,$02,$18,$00,$C9,$98 ; 6E90
        .byte   $00,$DD,$58,$14,$F5,$58,$54,$FD ; 6E98
        .byte   $D9,$54,$FF,$D9,$56,$FF,$D9,$9A ; 6EA0
        .byte   $FF,$DA,$A8,$FF,$EA,$A0,$3F,$0A ; 6EA8
        .byte   $80,$88,$13,$0C,$30,$00,$0F,$3C ; 6EB0
        .byte   $00,$03,$FC,$00,$05,$DC,$00,$06 ; 6EB8
        .byte   $5C,$00,$19,$60,$00,$65,$80,$00 ; 6EC0
        .byte   $A5,$80,$00,$AA,$00,$00,$2A,$80 ; 6EC8
        .byte   $00,$0A,$A0,$00,$0F,$F0,$00,$0F ; 6ED0
        .byte   $F0,$00,$00,$F0,$00,$00,$30,$88 ; 6ED8
        .byte   $9F,$AD,$A8,$AD,$95,$A5,$A3,$A2 ; 6EE0
        .byte   $04,$23,$20,$00,$00,$20,$00,$00 ; 6EE8
        .byte   $30,$00,$00,$1C,$00,$00,$0F,$F0 ; 6EF0
        .byte   $00,$0F,$F8,$00,$01,$F8,$00,$00 ; 6EF8
        .byte   $00,$00,$40,$00,$00,$C0,$07,$2C ; 6F00
        .byte   $3C,$00,$00,$3C,$00,$00,$7C,$00 ; 6F08
        .byte   $00,$7C,$00,$00,$70,$00,$00,$70 ; 6F10
        .byte   $00,$00,$78,$04,$19,$01,$00,$00 ; 6F18
        .byte   $16,$80,$00,$66,$80,$00,$66,$80 ; 6F20
        .byte   $00,$AF,$C0,$00,$3F,$C0,$00,$3F ; 6F28
        .byte   $C0,$00,$3F,$F0,$00,$3F,$FC,$00 ; 6F30
        .byte   $3F,$3C,$00,$3F,$00,$00,$03,$C0 ; 6F38
        .byte   $00,$00,$C0,$88,$08,$40,$00,$00 ; 6F40
        .byte   $90,$00,$00,$24,$00,$00,$09,$00 ; 6F48
        .byte   $00,$01,$80,$00,$C1,$80,$00,$DD ; 6F50
        .byte   $90,$00,$F9,$90,$00,$FD,$A0,$00 ; 6F58
        .byte   $FF,$68,$00,$FF,$55,$50,$FF,$95 ; 6F60
        .byte   $50,$FF,$A5,$50,$3F,$AA,$A0,$02 ; 6F68
        .byte   $AA,$A0,$06,$02,$A0,$06,$00,$A0 ; 6F70
        .byte   $18,$00,$00,$18,$88,$9F,$9C,$AD ; 6F78
        .byte   $9F,$AB,$9C,$9A,$96,$04,$22,$80 ; 6F80
        .byte   $00,$00,$C0,$00,$00,$E0,$00,$00 ; 6F88
        .byte   $7F,$00,$00,$7F,$C0,$00,$3F,$F8 ; 6F90
        .byte   $00,$01,$F8,$00,$00,$18,$00,$00 ; 6F98
        .byte   $60,$00,$00,$10,$07,$1D,$30,$00 ; 6FA0
        .byte   $00,$FC,$00,$00,$78,$00,$00,$7C ; 6FA8
        .byte   $00,$00,$1E,$00,$00,$1E,$00,$00 ; 6FB0
        .byte   $1E,$00,$00,$1C,$00,$00,$3E,$00 ; 6FB8
        .byte   $00,$3E,$00,$00,$7E,$00,$00,$18 ; 6FC0
        .byte   $04,$17,$50,$00,$00,$64,$30,$00 ; 6FC8
        .byte   $A9,$70,$00,$AF,$B0,$00,$0F,$F0 ; 6FD0
        .byte   $00,$0F,$F0,$00,$0F,$C0,$00,$0F ; 6FD8
        .byte   $C0,$00,$0F,$F0,$00,$0F,$FC,$00 ; 6FE0
        .byte   $0F,$DC,$00,$3F,$EC,$00,$3F,$EC ; 6FE8
        .byte   $00,$0F,$88,$05,$00,$10,$00,$00 ; 6FF0
        .byte   $20,$00,$00,$18,$00,$00,$18,$00 ; 6FF8
        .byte   $00,$18,$00,$00,$60,$00,$00,$60 ; 7000
        .byte   $00,$CA,$60,$00,$DE,$60,$00,$F6 ; 7008
        .byte   $68,$00,$FE,$DA,$00,$FF,$D5,$54 ; 7010
        .byte   $FF,$E5,$54,$FF,$E9,$54,$FF,$EA ; 7018
        .byte   $A8,$3F,$AA,$A8,$01,$80,$A8,$01 ; 7020
        .byte   $80,$28,$06,$00,$00,$06,$88,$9E ; 7028
        .byte   $8F,$A8,$90,$A7,$8E,$95,$88,$04 ; 7030
        .byte   $22,$80,$00,$00,$C0,$00,$00,$E0 ; 7038
        .byte   $00,$00,$7F,$00,$00,$7F,$C0,$00 ; 7040
L7048:  .byte   $3F,$F8,$00,$01,$F8,$00,$00,$18 ; 7048
        .byte   $00,$00,$60,$00,$00,$10,$07,$1D ; 7050
        .byte   $30,$00,$00,$FC,$00,$00,$78,$00 ; 7058
        .byte   $00,$7C,$00,$00,$1E,$00,$00,$1E ; 7060
        .byte   $00,$00,$1E,$00,$00,$1C,$00,$00 ; 7068
        .byte   $3E,$00,$00,$3E,$00,$00,$7E,$00 ; 7070
        .byte   $00,$18,$04,$17,$50,$00,$00,$64 ; 7078
        .byte   $30,$00,$A9,$70,$00,$AF,$B0,$00 ; 7080
        .byte   $0F,$F0,$00,$0F,$F0,$00,$0F,$C0 ; 7088
        .byte   $00,$0F,$C0,$00,$0F,$F0,$00,$0F ; 7090
        .byte   $FC,$00,$0F,$DC,$00,$3F,$EC,$00 ; 7098
        .byte   $3F,$EC,$00,$0F,$88,$05,$00,$10 ; 70A0
        .byte   $00,$00,$20,$00,$00,$18,$00,$00 ; 70A8
        .byte   $18,$00,$00,$18,$00,$00,$60,$00 ; 70B0
        .byte   $00,$60,$00,$CA,$60,$00,$DE,$60 ; 70B8
        .byte   $00,$F6,$68,$00,$FE,$DA,$00,$FF ; 70C0
        .byte   $D5,$54,$FF,$E5,$54,$FF,$E9,$54 ; 70C8
        .byte   $FF,$EA,$A8,$3F,$AA,$A8,$01,$80 ; 70D0
        .byte   $A8,$01,$80,$28,$06,$00,$00,$06 ; 70D8
        .byte   $88,$9E,$87,$A8,$88,$A7,$86,$95 ; 70E0
        .byte   $80,$04,$26,$20,$00,$00,$70,$00 ; 70E8
        .byte   $00,$78,$00,$00,$3C,$00,$00,$1E ; 70F0
        .byte   $00,$00,$1F,$80,$00,$1F,$80,$00 ; 70F8
        .byte   $67,$80,$00,$E0,$07,$35,$30,$00 ; 7100
        .byte   $00,$30,$00,$00,$30,$00,$00,$70 ; 7108
        .byte   $04,$10,$04,$00,$00,$19,$00,$00 ; 7110
        .byte   $1A,$43,$00,$1A,$97,$00,$06,$AF ; 7118
        .byte   $00,$0F,$EC,$00,$0F,$CC,$00,$0F ; 7120
        .byte   $C0,$00,$0F,$C0,$00,$5A,$C0,$00 ; 7128
        .byte   $96,$80,$00,$95,$40,$00,$AA,$F0 ; 7130
        .byte   $00,$2B,$F0,$00,$03,$C0,$00,$03 ; 7138
        .byte   $C0,$88,$05,$00,$00,$40,$00,$00 ; 7140
        .byte   $40,$00,$01,$80,$00,$01,$80,$3F ; 7148
        .byte   $06,$00,$FF,$C6,$00,$FF,$D8,$00 ; 7150
        .byte   $FD,$D6,$00,$F5,$55,$AA,$D5,$55 ; 7158
        .byte   $6A,$D5,$65,$AA,$DD,$65,$AA,$C9 ; 7160
        .byte   $95,$A8,$00,$14,$00,$00,$60,$00 ; 7168
        .byte   $00,$60,$00,$01,$80,$00,$01,$80 ; 7170
        .byte   $00,$06,$00,$00,$08,$88,$9F,$89 ; 7178
        .byte   $A8,$8C,$A5,$88,$95,$84,$04,$26 ; 7180
        .byte   $C0,$00,$00,$40,$00,$00,$60,$00 ; 7188
        .byte   $00,$38,$00,$00,$3E,$00,$00,$3F ; 7190
        .byte   $00,$00,$7F,$00,$00,$8E,$00,$00 ; 7198
        .byte   $80,$07,$2F,$08,$00,$00,$0C,$00 ; 71A0
        .byte   $00,$0E,$00,$00,$1E,$00,$00,$7C ; 71A8
        .byte   $00,$00,$38,$04,$0B,$00,$40,$00 ; 71B0
        .byte   $01,$50,$00,$01,$90,$00,$01,$A4 ; 71B8
        .byte   $00,$03,$A9,$F0,$0F,$FA,$F0,$0F ; 71C0
        .byte   $F3,$C0,$0F,$F0,$00,$1F,$F0,$00 ; 71C8
        .byte   $5B,$C0,$00,$6A,$C0,$00,$6A,$00 ; 71D0
        .byte   $00,$18,$00,$00,$1A,$00,$00,$06 ; 71D8
        .byte   $00,$00,$3F,$C0,$00,$3F,$C0,$00 ; 71E0
        .byte   $0F,$88,$04,$01,$00,$00,$02,$40 ; 71E8
        .byte   $00,$00,$60,$00,$3F,$90,$00,$FF ; 71F0
        .byte   $DC,$00,$FF,$DC,$00,$15,$D8,$00 ; 71F8
        .byte   $2A,$68,$00,$37,$68,$AA,$15,$6A ; 7200
        .byte   $AA,$19,$6A,$AA,$05,$AA,$A8,$00 ; 7208
        .byte   $28,$00,$00,$28,$00,$00,$18,$00 ; 7210
        .byte   $00,$18,$00,$00,$18,$00,$00,$20 ; 7218
        .byte   $00,$00,$60,$00,$00,$40,$88,$9F ; 7220
        .byte   $98,$A4,$9C,$A1,$98,$94,$93,$04 ; 7228
        .byte   $26,$C0,$00,$00,$40,$00,$00,$60 ; 7230
        .byte   $00,$00,$38,$00,$00,$3E,$00,$00 ; 7238
        .byte   $3F,$00,$00,$7F,$00,$00,$8E,$00 ; 7240
        .byte   $00,$80,$07,$2F,$08,$00,$00,$0C ; 7248
        .byte   $00,$00,$0E,$00,$00,$1E,$00,$00 ; 7250
        .byte   $7C,$00,$00,$38,$04,$0B,$00,$40 ; 7258
        .byte   $00,$01,$50,$00,$01,$90,$00,$01 ; 7260
        .byte   $A4,$00,$03,$A9,$F0,$0F,$FA,$F0 ; 7268
        .byte   $0F,$F3,$C0,$0F,$F0,$00,$1F,$F0 ; 7270
        .byte   $00,$5B,$C0,$00,$6A,$C0,$00,$6A ; 7278
        .byte   $00,$00,$18,$00,$00,$1A,$00,$00 ; 7280
        .byte   $06,$00,$00,$3F,$C0,$00,$3F,$C0 ; 7288
        .byte   $00,$0F,$88,$04,$01,$00,$00,$02 ; 7290
        .byte   $40,$00,$00,$60,$00,$3F,$90,$00 ; 7298
        .byte   $FF,$DC,$00,$FF,$DC,$00,$15,$D8 ; 72A0
        .byte   $00,$2A,$68,$00,$37,$68,$AA,$15 ; 72A8
        .byte   $6A,$AA,$19,$6A,$AA,$05,$AA,$A8 ; 72B0
        .byte   $00,$28,$00,$00,$28,$00,$00,$18 ; 72B8
        .byte   $00,$00,$18,$00,$00,$18,$00,$00 ; 72C0
        .byte   $20,$00,$00,$60,$00,$00,$40,$88 ; 72C8
        .byte   $9F,$A1,$A4,$A5,$A3,$A1,$96,$9C ; 72D0
        .byte   $04,$32,$03,$80,$00,$01,$80,$00 ; 72D8
        .byte   $60,$80,$00,$E0,$00,$00,$C0,$04 ; 72E0
        .byte   $20,$00,$C0,$00,$00,$C0,$00,$00 ; 72E8
        .byte   $C0,$00,$00,$C0,$00,$00,$E0,$00 ; 72F0
        .byte   $01,$F0,$00,$03,$F8,$00,$8F,$F0 ; 72F8
        .byte   $00,$FF,$80,$00,$C3,$00,$00,$C0 ; 7300
        .byte   $07,$14,$01,$40,$00,$01,$B0,$00 ; 7308
        .byte   $05,$B0,$00,$05,$B0,$00,$06,$80 ; 7310
        .byte   $00,$F6,$00,$00,$FE,$00,$00,$3F ; 7318
        .byte   $00,$00,$1F,$00,$00,$16,$00,$00 ; 7320
        .byte   $16,$00,$00,$04,$00,$00,$F5,$00 ; 7328
        .byte   $00,$FF,$00,$00,$3F,$88,$04,$3F ; 7330
        .byte   $C0,$04,$FF,$F0,$58,$FF,$F1,$A0 ; 7338
        .byte   $15,$F5,$80,$2A,$76,$00,$37,$54 ; 7340
        .byte   $00,$15,$74,$00,$19,$74,$00,$05 ; 7348
        .byte   $A4,$00,$0A,$94,$00,$06,$96,$00 ; 7350
        .byte   $05,$5A,$00,$06,$AA,$80,$06,$2B ; 7358
        .byte   $C0,$06,$0F,$C0,$06,$0F,$C0,$01 ; 7360
        .byte   $8F,$C0,$01,$80,$00,$01,$80,$00 ; 7368
        .byte   $00,$60,$88,$A1,$AA,$99,$A5,$9F ; 7370
        .byte   $AB,$95,$A2,$04,$32,$03,$80,$00 ; 7378
        .byte   $01,$80,$00,$60,$80,$00,$E0,$00 ; 7380
        .byte   $00,$C0,$04,$20,$00,$C0,$00,$00 ; 7388
        .byte   $C0,$00,$00,$C0,$00,$00,$C0,$00 ; 7390
        .byte   $00,$E0,$00,$01,$F0,$00,$03,$F8 ; 7398
        .byte   $00,$8F,$F0,$00,$FF,$80,$00,$C3 ; 73A0
        .byte   $00,$00,$C0,$07,$14,$01,$40,$00 ; 73A8
        .byte   $01,$B0,$00,$05,$B0,$00,$05,$B0 ; 73B0
        .byte   $00,$06,$80,$00,$F6,$00,$00,$FE ; 73B8
        .byte   $00,$00,$3F,$00,$00,$1F,$00,$00 ; 73C0
        .byte   $16,$00,$00,$16,$00,$00,$04,$00 ; 73C8
        .byte   $00,$F5,$00,$00,$FF,$00,$00,$3F ; 73D0
        .byte   $88,$04,$3F,$C0,$04,$FF,$F0,$58 ; 73D8
        .byte   $FF,$F1,$A0,$15,$F5,$80,$2A,$76 ; 73E0
        .byte   $00,$37,$54,$00,$15,$74,$00,$19 ; 73E8
        .byte   $74,$00,$05,$A4,$00,$0A,$94,$00 ; 73F0
        .byte   $06,$96,$00,$05,$5A,$00,$06,$AA ; 73F8
        .byte   $80,$06,$2B,$C0,$06,$0F,$C0,$06 ; 7400
        .byte   $0F,$C0,$01,$8F,$C0,$01,$80,$00 ; 7408
        .byte   $01,$80,$00,$00,$60,$88,$A0,$B3 ; 7410
        .byte   $98,$AD,$9E,$B3,$94,$AA,$04,$35 ; 7418
        .byte   $10,$00,$00,$10,$00,$00,$30,$00 ; 7420
        .byte   $00,$E0,$04,$25,$00,$0C,$00,$C0 ; 7428
        .byte   $18,$00,$40,$18,$00,$00,$30,$00 ; 7430
        .byte   $00,$70,$00,$03,$E0,$00,$1F,$E0 ; 7438
        .byte   $00,$0F,$C0,$00,$01,$C0,$07,$1C ; 7440
        .byte   $01,$40,$00,$01,$80,$00,$06,$85 ; 7448
        .byte   $00,$36,$95,$40,$FA,$9A,$40,$F8 ; 7450
        .byte   $9A,$70,$F0,$9A,$B0,$30,$1A,$B0 ; 7458
        .byte   $03,$E9,$F0,$03,$E3,$C0,$00,$F0 ; 7460
        .byte   $00,$00,$30,$88,$13,$00,$FF,$00 ; 7468
        .byte   $03,$FF,$C0,$43,$FF,$C1,$43,$57 ; 7470
        .byte   $C1,$90,$A9,$C1,$10,$DD,$46,$24 ; 7478
        .byte   $55,$C4,$29,$65,$98,$0A,$9A,$68 ; 7480
        .byte   $00,$A9,$A0,$00,$A6,$80,$00,$96 ; 7488
        .byte   $00,$00,$96,$00,$00,$AA,$00,$00 ; 7490
        .byte   $AA,$88,$9A,$BE,$95,$B4,$8A,$B9 ; 7498
        .byte   $8F,$AF,$04,$35,$10,$00,$00,$10 ; 74A0
        .byte   $00,$00,$30,$00,$00,$E0,$04,$25 ; 74A8
        .byte   $00,$18,$00,$C0,$18,$00,$40,$10 ; 74B0
        .byte   $00,$00,$30,$00,$00,$60,$00,$03 ; 74B8
        .byte   $C0,$00,$1F,$C0,$00,$0F,$80,$00 ; 74C0
        .byte   $01,$80,$07,$1E,$00,$14,$00,$C0 ; 74C8
        .byte   $54,$00,$F1,$98,$00,$F6,$A8,$50 ; 74D0
        .byte   $3A,$09,$54,$30,$09,$A4,$00,$06 ; 74D8
        .byte   $A7,$00,$F6,$AB,$00,$FE,$EB,$00 ; 74E0
        .byte   $3E,$DF,$00,$3C,$3C,$88,$13,$00 ; 74E8
        .byte   $3F,$C0,$40,$FF,$F0,$90,$FF,$F1 ; 74F0
        .byte   $10,$D5,$F1,$24,$2A,$76,$09,$37 ; 74F8
        .byte   $56,$02,$55,$58,$02,$99,$A0,$00 ; 7500
        .byte   $A6,$80,$00,$AA,$80,$00,$A6,$00 ; 7508
        .byte   $02,$9A,$00,$02,$98,$00,$02,$A8 ; 7510
        .byte   $00,$02,$A8,$88,$93,$CB,$8F,$C1 ; 7518
        .byte   $80,$C5,$89,$BC,$04,$35,$10,$00 ; 7520
        .byte   $00,$10,$00,$00,$30,$00,$00,$E0 ; 7528
        .byte   $04,$28,$C0,$18,$00,$40,$10,$00 ; 7530
        .byte   $00,$30,$00,$00,$60,$00,$03,$C0 ; 7538
        .byte   $00,$1F,$C0,$00,$0F,$80,$00,$01 ; 7540
        .byte   $80,$07,$1E,$00,$14,$00,$C0,$54 ; 7548
        .byte   $00,$F1,$98,$00,$F6,$A8,$50,$3A ; 7550
        .byte   $09,$54,$30,$09,$A4,$00,$06,$A7 ; 7558
        .byte   $00,$F6,$AB,$00,$FE,$EB,$00,$3E ; 7560
        .byte   $DF,$00,$3C,$3C,$88,$13,$00,$FF ; 7568
        .byte   $00,$03,$FF,$C0,$03,$FF,$C0,$03 ; 7570
        .byte   $57,$C0,$00,$A9,$C0,$00,$DD,$40 ; 7578
        .byte   $05,$55,$40,$9A,$66,$50,$22,$9A ; 7580
        .byte   $95,$02,$AA,$29,$02,$98,$00,$0A ; 7588
        .byte   $68,$00,$0A,$60,$00,$0A,$A0,$00 ; 7590
        .byte   $0A,$A0,$88,$8A,$D1,$86,$C8,$77 ; 7598
        .byte   $CB,$81,$C2,$04,$31,$00,$60,$00 ; 75A0
        .byte   $40,$60,$00,$20,$60,$00,$10,$40 ; 75A8
        .byte   $00,$08,$C0,$04,$25,$00,$18,$00 ; 75B0
        .byte   $C0,$18,$00,$40,$10,$00,$00,$30 ; 75B8
        .byte   $00,$00,$60,$00,$03,$C0,$00,$1F ; 75C0
        .byte   $C0,$00,$0F,$80,$00,$01,$80,$07 ; 75C8
        .byte   $15,$C0,$00,$00,$F0,$00,$00,$F0 ; 75D0
        .byte   $00,$00,$E5,$7C,$00,$E9,$7C,$00 ; 75D8
        .byte   $02,$7D,$40,$00,$BD,$40,$00,$FD ; 75E0
        .byte   $50,$00,$FA,$90,$00,$0E,$9C,$00 ; 75E8
        .byte   $0E,$AC,$00,$03,$AC,$00,$03,$BC ; 75F0
        .byte   $00,$00,$F0,$88,$10,$00,$40,$00 ; 75F8
        .byte   $43,$7C,$00,$4F,$7F,$00,$4F,$5F ; 7600
        .byte   $00,$4D,$9F,$00,$42,$A7,$00,$93 ; 7608
        .byte   $65,$00,$25,$69,$00,$29,$9A,$00 ; 7610
        .byte   $0A,$68,$00,$0A,$A8,$00,$0A,$60 ; 7618
        .byte   $00,$29,$A0,$00,$29,$80,$00,$2A ; 7620
        .byte   $80,$00,$2A,$80,$88,$74,$DC,$76 ; 7628
        .byte   $D2,$69,$D3,$74,$CC,$04,$32,$30 ; 7630
        .byte   $00,$00,$18,$00,$00,$18,$00,$00 ; 7638
        .byte   $38,$00,$00,$60,$04,$29,$C0,$0C ; 7640
        .byte   $00,$40,$18,$00,$20,$60,$00,$71 ; 7648
        .byte   $80,$00,$FF,$00,$00,$7C,$00,$00 ; 7650
        .byte   $70,$00                         ; 7658
L765A:  .byte   $00,$20,$07,$0D,$03,$F0,$00,$0F ; 765A
        .byte   $F0,$00,$FF,$C0,$00,$FF,$40,$00 ; 7662
        .byte   $F2,$40,$00,$26,$40,$00,$26,$90 ; 766A
        .byte   $00,$25,$90,$00,$29,$90,$00,$09 ; 7672
        .byte   $90,$00,$09,$94,$00,$0A,$A4,$00 ; 767A
        .byte   $0A,$A7,$00,$0E,$AB,$00,$03,$EB ; 7682
        .byte   $00,$00,$EF,$00,$00,$3C,$88,$16 ; 768A
        .byte   $00,$3F,$C0,$00,$FF,$F0,$00,$FF ; 7692
        .byte   $F0,$00,$D5,$F0,$00,$26,$70,$14 ; 769A
        .byte   $37,$50,$29,$55,$55,$4A,$96,$A9 ; 76A2
        .byte   $80,$A6,$A9,$00,$AA,$89,$02,$9A ; 76AA
        .byte   $09,$0A,$6A,$2A,$2A,$68,$05,$02 ; 76B2
        .byte   $A0,$88,$68,$E0,$6B,$DA,$5D,$D4 ; 76BA
        .byte   $63,$D5,$04,$2C,$00,$03,$80,$03 ; 76C2
        .byte   $09,$C0,$07,$F8,$80,$1F,$E0,$00 ; 76CA
        .byte   $7F,$80,$00,$3F,$00,$00,$03,$07 ; 76D2
        .byte   $31,$A8,$00,$00,$AA,$80,$00,$0A ; 76DA
        .byte   $A8,$00,$02,$A0,$00,$00,$80,$84 ; 76E2
        .byte   $1F,$C0,$00,$00,$C0,$1F,$00,$F0 ; 76EA
        .byte   $5F,$FF,$F5,$AF,$FF,$3A,$81,$7F ; 76F2
        .byte   $30,$05,$BF,$03,$C6,$BC,$03,$D6 ; 76FA
        .byte   $00,$0F,$DA,$00,$0F,$E8,$00,$0F ; 7702
        .byte   $80,$88,$09,$03,$FC,$00,$0F,$FF ; 770A
        .byte   $00,$0F,$FF,$00,$0D,$5F,$00,$02 ; 7712
        .byte   $A7,$00,$03,$75,$00,$01,$57,$00 ; 771A
        .byte   $01,$9B,$00,$02,$69,$00,$02,$AA ; 7722
        .byte   $40,$0A,$6A,$40,$09,$AA,$90,$29 ; 772A
        .byte   $A8,$90,$AA,$88,$90,$AA,$88,$90 ; 7732
        .byte   $AA,$09,$90,$AA,$00,$A0,$00,$00 ; 773A
        .byte   $24,$88,$5B,$E0,$56,$E5,$4B,$E4 ; 7742
        .byte   $5C,$D8,$04,$2F,$20,$00,$00,$FC ; 774A
        .byte   $00,$00,$FC,$00,$00,$FC,$00,$00 ; 7752
        .byte   $3E,$00,$00,$06,$04,$2C,$E0,$00 ; 775A
        .byte   $00,$E0,$00,$00,$F0,$00,$00,$EC ; 7762
        .byte   $00,$00,$EC,$00,$00,$18,$00,$00 ; 776A
        .byte   $10,$07,$1B,$00,$2A,$40,$00,$EA ; 7772
        .byte   $40,$03,$EA,$40,$03,$FA,$40,$0F ; 777A
        .byte   $FE,$40,$3F,$FE,$70,$FE,$7E,$70 ; 7782
        .byte   $FE,$9E,$60,$F0,$A6,$60,$00,$2A ; 778A
        .byte   $60,$00,$0A,$50,$00,$00,$90,$88 ; 7792
        .byte   $0A,$00,$FF,$00,$03,$FF,$C0,$03 ; 779A
        .byte   $FF,$C0,$03,$F5,$00,$03,$DA,$00 ; 77A2
        .byte   $02,$5D,$00,$05,$D5,$00,$25,$55 ; 77AA
        .byte   $00,$26,$94,$00,$26,$A0,$00,$26 ; 77B2
        .byte   $90,$00,$24,$90,$00,$A4,$90,$00 ; 77BA
        .byte   $04,$90,$00,$04,$90,$00,$00,$90 ; 77C2
        .byte   $00,$00,$90,$00,$00,$A4,$88,$C5 ; 77CA
        .byte   $E2,$CD,$DE,$BF,$E1,$C8,$D8,$04 ; 77D2
        .byte   $31,$03,$00,$00,$C3,$C0,$00,$70 ; 77DA
        .byte   $F0,$00,$10,$FC,$00,$0F,$C0,$04 ; 77E2
        .byte   $2B,$0F,$00,$00,$3F,$C0,$00,$78 ; 77EA
        .byte   $F4,$00,$19,$F0,$00,$03,$F0,$00 ; 77F2
        .byte   $00,$E0,$00,$00,$80,$07,$28,$0E ; 77FA
        .byte   $5C,$00,$0F,$9F,$00,$3F,$E7,$C0 ; 7802
        .byte   $F9,$E7,$F0,$FA,$7F,$94,$C2,$95 ; 780A
        .byte   $94,$00,$A5,$A8,$00,$2A,$88,$09 ; 7812
        .byte   $00,$3F,$C0,$00,$FF,$F0,$00,$FF ; 781A
        .byte   $F0,$00,$FD,$40,$00,$F6,$80,$00 ; 7822
        .byte   $D7,$40,$00,$35,$40,$00,$25,$40 ; 782A
        .byte   $05,$65,$00,$15,$5A,$00,$16,$56 ; 7832
        .byte   $00,$17,$96,$00,$56,$AA,$00,$5A ; 783A
        .byte   $A9,$00,$5A,$89,$00,$5A,$09,$00 ; 7842
        .byte   $00,$09,$40,$00,$02,$40,$88,$BB ; 784A
        .byte   $E1,$BD,$DA,$B5,$E1,$BC,$D2,$05 ; 7852
        .byte   $2B,$01,$C0,$00,$CF,$E0,$00,$FF ; 785A
        .byte   $B0,$00,$FC,$78,$00,$7F,$3C,$00 ; 7862
        .byte   $3F,$9E,$00,$11,$80,$04,$1C,$00 ; 786A
        .byte   $00,$F0,$00,$00,$70,$00,$00,$70 ; 7872
        .byte   $07,$C0,$E0,$1F,$FF,$C0,$7F,$FF ; 787A
        .byte   $C0,$31,$FF,$C0,$00,$3F,$C0,$00 ; 7882
        .byte   $1F,$C0,$00,$1F,$C0,$00,$0F,$C0 ; 788A
        .byte   $00,$07,$07,$25,$00,$F0,$00,$00 ; 7892
        .byte   $F0,$00,$00,$FC,$00,$F0,$FC,$00 ; 789A
        .byte   $D0,$FF,$00,$E7,$FF,$40,$E5,$7D ; 78A2
        .byte   $40,$25,$4E,$80,$0A,$80,$88,$06 ; 78AA
        .byte   $00,$3F,$C0,$00,$FF,$F0,$00,$FF ; 78B2
        .byte   $F0,$00,$FD,$40,$00,$F6,$80,$00 ; 78BA
        .byte   $F7,$40,$00,$D5,$40,$00,$F5,$A0 ; 78C2
        .byte   $00,$35,$60,$00,$56,$A0,$01,$55 ; 78CA
        .byte   $50,$05,$55,$50,$05,$A5,$50,$16 ; 78D2
        .byte   $29,$50,$68,$09,$50,$54,$02,$50 ; 78DA
        .byte   $A5,$02,$50,$0A,$02,$90,$00,$03 ; 78E2
        .byte   $F0,$88,$23,$A5,$59,$40,$AA,$A6 ; 78EA
        .byte   $00,$9A,$00,$00,$68,$00,$00,$40 ; 78F2
        .byte   $00,$00,$40,$00,$00,$40,$00,$00 ; 78FA
        .byte   $40,$00,$00,$40,$00,$00,$40,$88 ; 7902
        .byte   $A9,$DC,$A0,$D1,$A7,$DC,$9C,$CB ; 790A
        .byte   $AE,$D1,$04,$2B,$03,$80,$00,$FF ; 7912
        .byte   $E0,$00,$7F,$F0,$00,$3E,$F8,$00 ; 791A
        .byte   $1F,$3C,$00,$0F,$1E,$00,$07,$0E ; 7922
        .byte   $04,$28,$0E,$00,$00,$FF,$00,$00 ; 792A
        .byte   $3F,$C0,$00,$10,$F4,$00,$01,$F0 ; 7932
        .byte   $00,$03,$F0,$00,$00,$60,$00,$00 ; 793A
        .byte   $80,$07,$0A,$00,$20,$00,$00,$00 ; 7942
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 794A
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 7952
        .byte   $00,$00,$00,$00,$00,$00,$00,$0F ; 795A
        .byte   $00,$03,$FF,$C0,$03,$FF,$C0,$3C ; 7962
        .byte   $FF,$F0,$F9,$FF,$FC,$F9,$7C,$FC ; 796A
        .byte   $CA,$96,$94,$00,$94,$A8,$00,$28 ; 7972
        .byte   $88,$0D,$00,$3F,$C0,$00,$FF,$F0 ; 797A
        .byte   $00,$FF,$F0,$00,$FD,$40,$00,$F6 ; 7982
        .byte   $80,$00,$D7,$40,$00,$35,$40,$00 ; 798A
        .byte   $65,$80,$01,$59,$40,$15,$56,$80 ; 7992
        .byte   $5A,$95,$90,$60,$E5,$A4,$60,$AA ; 799A
        .byte   $89,$60,$AA,$02,$40,$AA,$00,$00 ; 79A2
        .byte   $A8,$00,$00,$A0,$88,$A0,$D6,$9C ; 79AA
        .byte   $CE,$99,$CE,$98,$C7,$04,$2B,$FF ; 79B2
        .byte   $80,$00,$7F,$80,$00,$7F,$C0,$00 ; 79BA
        .byte   $7C,$C0,$00,$3E,$E0,$00,$0E,$F0 ; 79C2
        .byte   $00,$0F,$70,$04,$28,$03,$00,$00 ; 79CA
        .byte   $1F,$00,$00,$73,$DE,$00,$20,$FE ; 79D2
        .byte   $00,$00,$7C,$00,$00,$FC,$00,$01 ; 79DA
        .byte   $F8,$00,$03,$F0,$07,$22,$00,$FC ; 79E2
        .byte   $00,$00,$FF,$C0,$00,$FF,$C0,$00 ; 79EA
        .byte   $FF,$C0,$3C,$FF,$C0,$F9,$FF,$F0 ; 79F2
        .byte   $F9,$7E,$F0,$CA,$96,$50,$00,$96 ; 79FA
        .byte   $60,$00,$28,$88,$0D,$00,$0F,$F0 ; 7A02
        .byte   $00,$3F,$FC,$00,$3F,$FC,$00,$3F ; 7A0A
        .byte   $50,$00,$3D,$A0,$00,$35,$D0,$00 ; 7A12
        .byte   $0D,$50,$00,$09,$60,$00,$16,$50 ; 7A1A
        .byte   $00,$55,$A0,$01,$A5,$60,$06,$39 ; 7A22
        .byte   $60,$18,$2A,$A0,$60,$AA,$80,$02 ; 7A2A
        .byte   $AA,$80,$02,$AA,$00,$02,$A8,$88 ; 7A32
        .byte   $8C,$C8,$8B,$C0,$84,$C8,$87,$B8 ; 7A3A
        .byte   $04,$1C,$00,$40,$00,$00,$00,$00 ; 7A42
        .byte   $01,$00,$00,$02,$00,$00,$0E,$00 ; 7A4A
        .byte   $00,$38,$00,$00,$78,$00,$00,$78 ; 7A52
        .byte   $00,$00,$FF,$00,$00,$71,$C0,$00 ; 7A5A
        .byte   $41,$C0,$00,$00,$80,$07,$22,$7F ; 7A62
        .byte   $F0,$00,$7F,$F8,$00,$7F,$F8,$00 ; 7A6A
        .byte   $00,$F0,$00,$00,$78,$00,$01,$F8 ; 7A72
        .byte   $00,$03,$FC,$00,$07,$FC,$00,$00 ; 7A7A
        .byte   $F8,$00,$00,$E0,$04,$19,$FC,$00 ; 7A82
        .byte   $00,$FF,$00,$00,$25,$5F,$C0,$25 ; 7A8A
        .byte   $5F,$C0,$2A,$AF,$C0,$0A,$AF,$00 ; 7A92
        .byte   $00,$EF,$00,$00,$2F,$C0,$00,$AF ; 7A9A
        .byte   $F0,$00,$97,$F0,$00,$97,$F0,$00 ; 7AA2
        .byte   $17,$C0,$00,$28,$88,$08,$05,$40 ; 7AAA
        .byte   $00,$0A,$50,$00,$00,$94,$00,$00 ; 7AB2
        .byte   $25,$00,$00,$27,$FC,$00,$AF,$FF ; 7ABA
        .byte   $0A,$9F,$FF,$2A,$5F,$D4,$AA,$5F ; 7AC2
        .byte   $68,$A9,$AD,$74,$A9,$AB,$54,$A5 ; 7ACA
        .byte   $6A,$58,$A8,$90,$94,$A0,$90,$00 ; 7AD2
        .byte   $00,$90,$00,$02,$40,$00,$02,$40 ; 7ADA
        .byte   $00,$09,$00,$00,$08,$88,$8F,$BE ; 7AE2
        .byte   $82,$C3,$7C,$C1,$8B,$BB,$04,$1C ; 7AEA
        .byte   $00,$40,$00,$00,$E0,$00,$01,$E0 ; 7AF2
        .byte   $00,$03,$80,$00,$0F,$00,$00,$3E ; 7AFA
        .byte   $00,$00,$7E,$00,$00,$7E,$00,$00 ; 7B02
        .byte   $FF,$00,$00,$71,$C0,$00,$41,$C0 ; 7B0A
        .byte   $00,$00,$80,$07,$1F,$0F,$00,$00 ; 7B12
        .byte   $7F,$C0,$00,$3F,$E0,$00,$0F,$E0 ; 7B1A
        .byte   $00,$03,$C0,$00,$01,$E0,$00,$07 ; 7B22
        .byte   $E0,$00,$0F,$F0,$00,$1F,$F0,$00 ; 7B2A
        .byte   $03,$E0,$00,$03,$80,$04,$0D,$FC ; 7B32
        .byte   $00,$00,$FA,$00,$00,$3A,$00,$00 ; 7B3A
        .byte   $0A,$00,$00,$0A,$C0,$00,$0A,$F0 ; 7B42
        .byte   $00,$02,$FC,$00,$00,$FC,$00,$00 ; 7B4A
        .byte   $FC,$00,$0F,$F0,$00,$0E,$F0,$00 ; 7B52
        .byte   $02,$FC,$00,$0A,$FF,$00,$09,$7F ; 7B5A
        .byte   $00,$09,$7F,$00,$01,$7C,$00,$02 ; 7B62
        .byte   $80,$88,$08,$05,$40,$00,$0A,$50 ; 7B6A
        .byte   $00,$00,$94,$00,$00,$25,$00,$00 ; 7B72
        .byte   $25,$00,$00,$A4,$FC,$0A,$97,$7F ; 7B7A
        .byte   $2A,$55,$5F,$AA,$59,$77,$A9,$59 ; 7B82
        .byte   $67,$A9,$5A,$67,$A5,$59,$77,$A8 ; 7B8A
        .byte   $91,$5F,$A0,$90,$3C,$00,$90,$00 ; 7B92
        .byte   $02,$40,$00,$02,$40,$00,$09,$00 ; 7B9A
        .byte   $00,$08,$88,$8B,$BA,$80,$BB,$7C ; 7BA2
        .byte   $B6,$87,$B7,$04,$22,$00,$80,$00 ; 7BAA
        .byte   $01,$C0,$00,$61,$C0,$00,$FF,$00 ; 7BB2
        .byte   $00,$7E,$00,$00,$7E,$00,$00,$7E ; 7BBA
        .byte   $00,$00,$3F,$00,$00,$03,$80,$00 ; 7BC2
        .byte   $01,$E0,$07,$1D,$30,$00,$00,$7C ; 7BCA
        .byte   $00,$00,$7E,$00,$00,$1F,$00,$00 ; 7BD2
        .byte   $07,$80,$00,$07,$00,$00,$07,$00 ; 7BDA
        .byte   $00,$0F,$00,$00,$0F,$00,$00,$0F ; 7BE2
        .byte   $00,$00,$0F,$00,$00,$0F,$04,$13 ; 7BEA
        .byte   $05,$00,$00,$E9,$C0,$00,$EB,$F0 ; 7BF2
        .byte   $00,$FB,$F0,$00,$3F,$FC,$00,$00 ; 7BFA
        .byte   $FC,$00,$00,$FC,$00,$00,$FC,$00 ; 7C02
        .byte   $00,$DC,$00,$0F,$D4,$00,$0F,$D4 ; 7C0A
        .byte   $00,$3D,$D4,$00,$39,$94,$00,$32 ; 7C12
        .byte   $90,$00,$00,$90,$88,$03,$08,$00 ; 7C1A
        .byte   $00,$09,$00,$00,$02,$40,$00,$02 ; 7C22
        .byte   $40,$00,$00,$90,$00,$00,$90,$3C ; 7C2A
        .byte   $00,$91,$5F,$25,$59,$77,$A9,$5A ; 7C32
        .byte   $67,$A9,$59,$67,$AA,$59,$77,$AA ; 7C3A
        .byte   $55,$5F,$0A,$97,$7F,$00,$A4,$FC ; 7C42
        .byte   $00,$05,$00,$00,$09,$00,$00,$01 ; 7C4A
        .byte   $40,$00,$02,$40,$00,$00,$90,$00 ; 7C52
        .byte   $00,$28,$88,$86,$B1,$7D,$AF,$77 ; 7C5A
        .byte   $AE,$82,$AD,$04,$23,$01,$80,$00 ; 7C62
        .byte   $01,$80,$00,$1E,$00,$00,$F0,$00 ; 7C6A
        .byte   $00,$F0,$00,$00,$F0,$00,$00,$78 ; 7C72
        .byte   $00,$00,$3C,$00,$00,$0C,$00,$00 ; 7C7A
        .byte   $0C,$07,$32,$10,$00,$00,$70,$00 ; 7C82
        .byte   $00,$F0,$00,$00,$C0,$00,$00,$C0 ; 7C8A
        .byte   $04,$14,$3D,$54,$00,$3E,$A5,$00 ; 7C92
        .byte   $FE,$A9,$00,$F0,$E9,$00,$00,$F8 ; 7C9A
        .byte   $00,$03,$F0,$00,$03,$F0,$00,$03 ; 7CA2
        .byte   $C0,$00,$03,$C0,$00,$00,$50,$00 ; 7CAA
        .byte   $01,$54,$00,$31,$A4,$00,$F5,$A0 ; 7CB2
        .byte   $00,$F6,$80,$00,$EA,$88,$01,$00 ; 7CBA
        .byte   $24,$00,$00,$09,$00,$00,$09,$00 ; 7CC2
        .byte   $00,$09,$00,$00,$09,$00,$00,$09 ; 7CCA
        .byte   $00,$00,$09,$3C,$25,$55,$5F,$A9 ; 7CD2
        .byte   $65,$77,$A9,$66,$67,$AA,$65,$67 ; 7CDA
        .byte   $AA,$69,$77,$0A,$52,$5F,$00,$93 ; 7CE2
        .byte   $7F,$00,$90,$FC,$00,$90,$00,$00 ; 7CEA
        .byte   $A0,$00,$00,$90,$00,$00,$90,$00 ; 7CF2
        .byte   $00,$90,$00,$00,$24,$88,$83,$9E ; 7CFA
        .byte   $7E,$A0,$76,$9C,$7C,$99,$04,$22 ; 7D02
        .byte   $00,$30,$00,$78,$30,$00,$3F,$C0 ; 7D0A
        .byte   $00,$1F,$80,$00,$1F,$80,$00,$1F ; 7D12
        .byte   $80,$00,$0F,$C0,$00,$01,$C0,$00 ; 7D1A
        .byte   $00,$C0,$00,$00,$80,$07,$35,$0C ; 7D22
        .byte   $00,$00,$3C,$00,$00,$70,$00,$00 ; 7D2A
        .byte   $70,$04,$19,$00,$05,$00,$0F,$19 ; 7D32
        .byte   $40,$0F,$6A,$40,$3F,$AA,$40,$3E ; 7D3A
        .byte   $AE,$00,$00,$FC,$00,$00,$FC,$00 ; 7D42
        .byte   $00,$F0,$00,$3C,$F0,$00,$FD,$54 ; 7D4A
        .byte   $00,$FD,$55,$00,$F9,$99,$00,$02 ; 7D52
        .byte   $A8,$88,$02,$00,$02,$40,$00,$09 ; 7D5A
        .byte   $00,$00,$04,$00,$00,$04,$00,$00 ; 7D62
        .byte   $04,$00,$00,$04,$00,$00,$04,$0F ; 7D6A
        .byte   $25,$59,$77,$A9,$5A,$67,$A9,$59 ; 7D72
        .byte   $77,$AA,$59,$57,$AA,$55,$5F,$0A ; 7D7A
        .byte   $53,$7F,$00,$93,$FF,$00,$90,$FC ; 7D82
        .byte   $00,$90,$00,$02,$40,$00,$02,$40 ; 7D8A
        .byte   $00,$01,$00,$00,$09,$00,$00,$09 ; 7D92
        .byte   $88,$7E,$8F,$79,$90,$71,$8B,$7C ; 7D9A
        .byte   $8A,$04,$22,$00,$30,$00,$78,$30 ; 7DA2
        .byte   $00,$3F,$C0,$00,$1F,$80,$00,$1F ; 7DAA
        .byte   $80,$00,$1F,$80,$00,$0F,$C0,$00 ; 7DB2
        .byte   $01,$C0,$00,$00,$C0,$00,$00,$80 ; 7DBA
        .byte   $07,$35,$0C,$00,$00,$3C,$00,$00 ; 7DC2
        .byte   $70,$00,$00,$70,$04,$19,$00,$05 ; 7DCA
        .byte   $00,$0F,$19,$40,$0F,$6A,$40,$3F ; 7DD2
        .byte   $AA,$40,$3E,$AE,$00,$00,$FC,$00 ; 7DDA
        .byte   $00,$FC,$00,$00,$F0,$00,$3C,$F0 ; 7DE2
        .byte   $00,$FD,$54,$00,$FD,$55,$00,$F9 ; 7DEA
        .byte   $99,$00,$02,$A8,$88,$02,$00,$02 ; 7DF2
        .byte   $40,$00,$09,$00,$00,$04,$00,$00 ; 7DFA
        .byte   $04,$00,$00,$04,$00,$00,$04,$00 ; 7E02
        .byte   $00,$04,$0F,$25,$59,$77,$A9,$5A ; 7E0A
        .byte   $67,$A9,$59,$77,$AA,$59,$57,$AA ; 7E12
        .byte   $55,$5F,$0A,$53,$7F,$00,$93,$FF ; 7E1A
        .byte   $00,$90,$FC,$00,$90,$00,$02,$40 ; 7E22
        .byte   $00,$02,$40,$00,$01,$00,$00,$09 ; 7E2A
        .byte   $00,$00,$09,$88,$7D,$87,$78,$88 ; 7E32
        .byte   $70,$83,$7B,$82,$04,$1F,$00,$40 ; 7E3A
        .byte   $00,$00,$60,$00,$03,$E0,$00,$1F ; 7E42
        .byte   $E0,$00,$71,$80,$00,$0F,$C0,$00 ; 7E4A
        .byte   $1F,$C0,$00,$01,$E0,$00,$00,$70 ; 7E52
        .byte   $00,$00,$30,$00,$00,$20,$07,$1D ; 7E5A
        .byte   $0C,$00,$00,$7C,$00,$00,$7C,$00 ; 7E62
        .byte   $00,$7C,$00,$00,$38,$00,$00,$F8 ; 7E6A
        .byte   $00,$00,$F8,$00,$00,$F8,$00,$00 ; 7E72
        .byte   $7C,$00,$00,$3C,$00,$00,$0E,$00 ; 7E7A
        .byte   $00,$06,$04,$0B,$00,$50,$00,$01 ; 7E82
        .byte   $FC,$00,$C7,$FC,$00,$DB,$F0,$00 ; 7E8A
        .byte   $EB,$F0,$00,$EB,$F0,$00,$33,$F0 ; 7E92
        .byte   $00,$03,$F0,$00,$03,$F0,$00,$00 ; 7E9A
        .byte   $FC,$00,$02,$FC,$00,$0A,$BC,$00 ; 7EA2
        .byte   $2A,$90,$00,$E9,$40,$00,$E4,$00 ; 7EAA
        .byte   $00,$F0,$00,$00,$F0,$00,$00,$30 ; 7EB2
        .byte   $88,$08,$A4,$00,$00,$09,$00,$00 ; 7EBA
        .byte   $02,$43,$F0,$02,$4F,$FC,$02,$4F ; 7EC2
        .byte   $FC,$05,$6F,$FC,$15,$6F,$FC,$AA ; 7ECA
        .byte   $6D,$FC,$AA,$65,$7C,$AA,$65,$DC ; 7ED2
        .byte   $AA,$69,$8C,$A0,$50,$00,$82,$40 ; 7EDA
        .byte   $00,$02,$40,$00,$09,$00,$00,$09 ; 7EE2
        .byte   $00,$00,$08,$00,$00,$08,$00,$00 ; 7EEA
        .byte   $08,$88,$72,$84,$6D,$86,$66,$86 ; 7EF2
        .byte   $72,$82,$04,$23,$7C,$00,$00,$1F ; 7EFA
        .byte   $C0,$00,$63,$E0,$00,$1F,$C0,$00 ; 7F02
        .byte   $03,$80,$00,$01,$C0,$00,$01,$C0 ; 7F0A
        .byte   $00,$01,$E0,$00,$01,$E0,$00,$01 ; 7F12
        .byte   $07,$1D                         ; 7F1A
L7F1C:  .byte   $1E,$00,$00,$3E,$00,$00,$3E,$00 ; 7F1C
        .byte   $00,$1C,$00,$00,$7C,$00,$00,$7C ; 7F24
        .byte   $00,$00,$7D,$00,$00,$3F,$00,$00 ; 7F2C
        .byte   $0F,$00,$00,$0F,$00,$00,$06,$00 ; 7F34
        .byte   $00,$04,$04,$19,$C0,$00,$00,$F5 ; 7F3C
        .byte   $FC,$00,$FA,$FE,$00,$CA,$FE,$00 ; 7F44
        .byte   $00,$FE,$00,$00,$FE,$00,$F0,$3E ; 7F4C
        .byte   $00,$F4,$3E,$00,$E9,$3E,$00,$E9 ; 7F54
        .byte   $7C,$00,$C2,$BC,$00,$00,$BC,$00 ; 7F5C
        .byte   $00,$20,$88,$10,$40,$0F,$C0,$55 ; 7F64
        .byte   $7F,$F0,$55,$7F,$F0,$55,$BF,$F0 ; 7F6C
        .byte   $A5,$BF,$F0,$A9,$B7,$F4,$29,$95 ; 7F74
        .byte   $F9,$01,$97,$72,$01,$66,$30,$02 ; 7F7C
        .byte   $40,$00,$02,$40,$00,$02,$40,$00 ; 7F84
        .byte   $00,$90,$00,$00,$90,$00,$00,$24 ; 7F8C
        .byte   $00,$00,$09,$88,$74,$9A,$6E,$99 ; 7F94
        .byte   $67,$98,$75,$9A,$04,$23,$7C,$30 ; 7F9C
        .byte   $00,$1F,$E0,$00,$63,$E0,$00,$1F ; 7FA4
        .byte   $C0,$00,$03,$80,$00,$01,$C0,$00 ; 7FAC
        .byte   $01,$C0,$00,$01,$E0,$00,$01,$E0 ; 7FB4
        .byte   $00,$01,$07,$20,$38,$00,$00,$78 ; 7FBC
        .byte   $00,$00,$38,$00,$00,$F0,$00,$00 ; 7FC4
        .byte   $F0,$00,$00,$F0,$00,$00,$F4,$00 ; 7FCC
        .byte   $00,$7C,$00,$00,$3C,$00,$00,$38 ; 7FD4
        .byte   $00,$00,$10,$04,$16,$0F,$00,$00 ; 7FDC
        .byte   $3D,$00,$00,$31,$7F,$00,$02,$7F ; 7FE4
        .byte   $80,$02,$7F,$80,$02,$BF,$80,$00 ; 7FEC
        .byte   $BF,$80,$00,$BF,$80,$3C,$0F,$80 ; 7FF4
        .byte   $39,$0F,$80,$F9,$4F,$00,$F2,$9F ; 7FFC
        .byte   $00,$00,$AF,$00,$00,$28,$88,$07 ; 8004
        .byte   $00,$00,$40,$00,$05,$80,$40,$5A ; 800C
        .byte   $00,$55,$6F,$C0,$55,$7F,$F0,$55 ; 8014
        .byte   $BF,$F0,$A5,$BF,$F0,$A9,$BF,$F0 ; 801C
        .byte   $29,$B7,$F0,$01,$95,$F0,$01,$57 ; 8024
        .byte   $70,$02,$66,$30,$02,$40,$00,$02 ; 802C
        .byte   $40,$00,$02,$40,$00,$02,$40,$00 ; 8034
        .byte   $02,$40,$00,$02,$40,$00,$00,$90 ; 803C
        .byte   $88,$79,$A9,$75,$A8,$6A,$A6,$7A ; 8044
        .byte   $A7,$04,$28,$2E,$00,$00,$73,$E0 ; 804C
        .byte   $00,$1F,$C0,$00,$03,$80,$00,$01 ; 8054
        .byte   $C0,$00,$01,$C0,$00,$00,$E0,$00 ; 805C
        .byte   $00,$60,$07,$2B,$07,$C0,$00,$0F ; 8064
        .byte   $A0,$00,$3F,$80,$00,$7F,$00,$00 ; 806C
        .byte   $7F,$00,$00,$7F,$00,$00,$0F,$40 ; 8074
        .byte   $04,$18,$3C,$00,$00,$FF,$F0,$00 ; 807C
        .byte   $3C,$F0,$00,$24,$90,$00,$24,$90 ; 8084
        .byte   $00,$24,$9C,$00,$24,$9F,$00,$25 ; 808C
        .byte   $BF,$A8,$29,$FF,$A8,$09,$FF,$A8 ; 8094
        .byte   $0A,$FF,$A8,$00,$FF,$A8,$00,$0F ; 809C
        .byte   $A8,$88,$0D,$80,$00,$00,$94,$00 ; 80A4
        .byte   $00,$95,$7F,$C0,$95,$BF,$F0,$A5 ; 80AC
        .byte   $BF,$F0,$A9,$BF,$F0,$29,$BF,$F4 ; 80B4
        .byte   $29,$9F,$F9,$02,$57,$F0,$02,$5D ; 80BC
        .byte   $F0,$00,$98,$C0,$00,$90,$00,$00 ; 80C4
        .byte   $24,$00,$00,$24,$00,$00,$08,$00 ; 80CC
        .byte   $00,$09,$00,$00,$01,$88,$7F,$BC ; 80D4
        .byte   $77,$BA,$6F,$B5,$80,$BB,$04,$28 ; 80DC
        .byte   $30,$00,$00,$7F,$E0,$00,$FC,$40 ; 80E4
        .byte   $00,$1F,$80,$00,$03,$C0,$00,$01 ; 80EC
        .byte   $C0,$00,$00,$E0,$00,$00,$60,$07 ; 80F4
        .byte   $2B,$01,$F0,$00,$0F,$E8,$00,$7F ; 80FC
        .byte   $E0,$00,$7F,$80,$00,$3F,$00,$00 ; 8104
        .byte   $1F,$00,$00,$03,$10,$04,$12,$F0 ; 810C
        .byte   $F0,$00,$FC,$3C,$00,$3C,$3C,$00 ; 8114
        .byte   $10,$2C,$00,$10,$28,$00,$14,$90 ; 811C
        .byte   $00,$24,$90,$00,$25,$70,$00,$2B ; 8124
        .byte   $FC,$00,$2F,$FE,$A0,$0F,$FA,$A0 ; 812C
        .byte   $03,$FA,$A0,$00,$FA,$A0,$00,$3A ; 8134
        .byte   $A0,$00,$02,$A0,$88,$15,$80,$00 ; 813C
        .byte   $00,$90,$00,$00,$95,$7F,$C0,$95 ; 8144
        .byte   $BF,$F0,$A5,$BF,$F4,$A9,$BF,$F9 ; 814C
        .byte   $29,$BF,$F0,$29,$AF,$F0,$0A,$5B ; 8154
        .byte   $F0,$02,$96,$F0,$00,$25,$C0,$00 ; 815C
        .byte   $09,$40,$00,$02,$54,$00,$00,$A4 ; 8164
        .byte   $88,$84,$C8,$7A,$C6,$76,$BF,$85 ; 816C
        .byte   $C7,$04,$26,$3C,$00,$00,$6C,$00 ; 8174
        .byte   $00,$F3,$00,$00,$3F,$E0,$00,$0F ; 817C
        .byte   $80,$00,$07,$80,$00,$07,$C0,$00 ; 8184
        .byte   $01,$E0,$00,$01,$07,$2B,$00,$40 ; 818C
        .byte   $00,$3C,$F0,$00,$7F,$38,$00,$1F ; 8194
        .byte   $F0,$00,$0F,$80,$00,$03,$00,$00 ; 819C
        .byte   $01,$80,$04,$0A,$3C,$00,$00,$3C ; 81A4
        .byte   $00,$00,$0F,$00,$00,$1F,$0C,$00 ; 81AC
        .byte   $1F,$0C,$00,$18,$3C,$00,$68,$7C ; 81B4
        .byte   $00,$69,$BC,$00,$62,$80,$00,$A2 ; 81BC
        .byte   $C0,$00,$A3,$F0,$00,$BF,$F0,$00 ; 81C4
        .byte   $FF,$E8,$00,$3F,$AA,$00,$3F,$AA ; 81CC
        .byte   $00,$0F,$AA,$00,$03,$AA,$00,$00 ; 81D4
        .byte   $AA,$88,$15,$50,$00,$00,$50,$00 ; 81DC
        .byte   $00,$94,$00,$00,$95,$00,$00,$A5 ; 81E4
        .byte   $40,$00,$A9,$7F,$C0,$A9,$BF,$F1 ; 81EC
        .byte   $29,$7F,$F6,$29,$7F,$F8,$09,$6F ; 81F4
        .byte   $D0,$02,$59,$60,$00,$96,$B0,$00 ; 81FC
        .byte   $2A,$F0,$00,$00,$C0,$88,$99,$D6 ; 8204
        .byte   $90,$D2,$90,$C9,$9A,$D5,$04,$28 ; 820C
        .byte   $7C,$00,$00,$FF,$F0,$00,$1F,$80 ; 8214
        .byte   $00,$03,$E0,$00,$00,$40,$00,$00 ; 821C
        .byte   $C0,$00,$01,$C0,$00,$00,$80,$07 ; 8224
        .byte   $2E,$00,$F0,$00,$3F,$3C,$00,$7F ; 822C
        .byte   $DE,$00,$FF,$F8,$00,$1F,$F0,$00 ; 8234
        .byte   $01,$E0,$04,$1E,$FF,$3C,$00,$F6 ; 823C
        .byte   $24,$00,$08,$09,$00,$14,$3F,$C0 ; 8244
        .byte   $57,$FF,$F0,$AB,$FF,$F0,$2F,$FF ; 824C
        .byte   $D4,$0F,$FF,$E4,$00,$3F,$E8,$00 ; 8254
        .byte   $03,$A8,$00,$00,$28,$88,$16,$55 ; 825C
        .byte   $00,$00,$A5,$57,$FD,$A9,$57,$FF ; 8264
        .byte   $A9,$5F,$FF,$AA,$9F,$FF,$2A,$9F ; 826C
        .byte   $FF,$0A,$5F,$FF,$02,$6B,$FF,$09 ; 8274
        .byte   $42,$FF,$09,$80,$BC,$09,$00,$00 ; 827C
        .byte   $0A,$00,$00,$05,$40,$00,$09,$40 ; 8284
        .byte   $88,$A8,$DF,$9B,$DC,$95,$D9,$A7 ; 828C
        .byte   $DF,$04,$28,$7C,$00,$00,$FF,$F0 ; 8294
        .byte   $00,$1F,$80,$00,$03,$E0,$00,$00 ; 829C
        .byte   $40,$00,$00,$C0,$00,$01,$C0,$00 ; 82A4
        .byte   $00,$80,$07,$2E,$0F,$F0,$00,$3F ; 82AC
        .byte   $3C,$00,$7F,$DE,$00,$FF,$F8,$00 ; 82B4
        .byte   $1F,$F0,$00,$01,$E0,$04,$21,$FF ; 82BC
        .byte   $0F,$00,$F6,$09,$00,$08,$02,$40 ; 82C4
        .byte   $0A,$0F,$F0,$15,$FF,$FC,$2A,$FF ; 82CC
        .byte   $F5,$0B,$FF,$F9,$03,$FF,$FA,$00 ; 82D4
        .byte   $0F,$EA,$00,$00,$EA,$88,$16,$55 ; 82DC
        .byte   $03,$FC,$A5,$5F,$FF,$A9,$5F,$FF ; 82E4
        .byte   $A9,$5F,$FF,$AA,$9F,$FF,$2A,$9F ; 82EC
        .byte   $57,$0A,$5D,$A9,$02,$65,$DD,$09 ; 82F4
        .byte   $49,$54,$09,$82,$A0,$09,$00,$00 ; 82FC
        .byte   $0A,$00,$00,$05,$40,$00,$09,$40 ; 8304
        .byte   $88,$B9,$E2,$AC,$E0,$A4,$DD,$B8 ; 830C
        .byte   $E2,$05,$2B,$1F,$C0,$00,$7F,$F8 ; 8314
        .byte   $00,$FE,$60,$00,$01,$F0,$00,$00 ; 831C
        .byte   $10,$00,$00,$30,$00,$00,$60,$07 ; 8324
        .byte   $32,$01,$FC,$00,$3F,$F0,$00,$7F ; 832C
        .byte   $E0,$00,$7F,$C0,$00,$7E,$04,$27 ; 8334
        .byte   $0D,$40,$00,$0E,$94,$00,$50,$2F ; 833C
        .byte   $C0,$54,$FF,$50,$A7,$FF,$90,$2B ; 8344
        .byte   $FF,$A0,$0B,$FE,$A0,$03,$FE,$A0 ; 834C
        .byte   $88,$31,$3F,$00,$00,$FF,$C0,$00 ; 8354
        .byte   $FD,$40,$00,$02,$80,$00,$00,$80 ; 835C
        .byte   $88,$17,$00,$03,$FC,$55,$0F,$FF ; 8364
        .byte   $A5,$4F,$FF,$A9,$5F,$FF,$AA,$9F ; 836C
        .byte   $FF,$AA,$9F,$57,$2A,$5D,$A9,$02 ; 8374
        .byte   $65,$DD,$09,$49,$54,$25,$82,$A0 ; 837C
        .byte   $24,$00,$00,$28,$00,$00,$15,$00 ; 8384
        .byte   $00,$25,$88,$BF,$E5,$B5,$E4,$AF ; 838C
        .byte   $E2,$A6,$E2,$C0,$E4,$04,$23,$C0 ; 8394
        .byte   $00,$00,$C0,$00,$00,$E0,$00,$00 ; 839C
        .byte   $FC,$00,$00,$7E,$00,$00,$7E,$00 ; 83A4
        .byte   $00,$7F,$00,$00,$FF,$00,$00,$E3 ; 83AC
        .byte   $00,$00,$C0,$07,$35,$30,$00,$00 ; 83B4
        .byte   $30,$00,$00,$30,$00,$00,$70,$04 ; 83BC
        .byte   $0D,$50,$00,$00,$65,$00,$00,$AA ; 83C4
        .byte   $4C,$00,$AA,$9C,$00,$2A,$9C,$00 ; 83CC
        .byte   $3F,$AC,$00,$3F,$30,$00,$3F,$00 ; 83D4
        .byte   $00,$3F,$00,$00,$17,$00,$00,$95 ; 83DC
        .byte   $00,$00,$99,$50,$00,$AA,$AC,$00 ; 83E4
        .byte   $2A,$9C,$00,$00,$1C,$00,$00,$3C ; 83EC
        .byte   $00,$00,$30,$88,$01,$00,$00,$40 ; 83F4
        .byte   $00,$01,$80,$00,$01,$80,$3F,$06 ; 83FC
        .byte   $00,$FF,$C6,$00,$FF,$C6,$00,$FD ; 8404
        .byte   $D6,$00,$F5,$55,$58,$D5,$55,$6A ; 840C
        .byte   $D5,$65,$6A,$DD,$65,$AA,$C9,$85 ; 8414
        .byte   $AA,$00,$05,$A8,$00,$06,$00,$00 ; 841C
        .byte   $06,$00,$00,$06,$00,$00,$06,$00 ; 8424
        .byte   $00,$06,$00,$00,$18,$00,$00,$18 ; 842C
        .byte   $00,$00,$04,$88,$A1,$88,$A8,$8E ; 8434
        .byte   $A7,$89,$95,$84,$04,$29,$D0,$00 ; 843C
        .byte   $00,$FF,$C0,$00,$1F,$80,$00,$1F ; 8444
        .byte   $80,$00,$1F,$80,$00,$3F,$00,$00 ; 844C
        .byte   $70,$00,$00,$E0,$07,$35,$30,$00 ; 8454
        .byte   $00,$30,$00,$00,$30,$00,$00,$70 ; 845C
        .byte   $04,$0D,$50,$00,$00,$65,$00,$00 ; 8464
        .byte   $AA,$4C,$00,$AA,$9C,$00,$2A,$9C ; 846C
        .byte   $00,$3F,$AC,$00,$3F,$30,$00,$3F ; 8474
        .byte   $00,$00,$3F,$00,$00,$17,$00,$00 ; 847C
        .byte   $95,$00,$00,$99,$50,$00,$AA,$AC ; 8484
        .byte   $00,$3A,$9C,$00,$0C,$1C,$00,$00 ; 848C
        .byte   $3C,$00,$00,$30,$88,$02,$04,$00 ; 8494
        .byte   $00,$09,$00,$00,$01,$80,$00,$00 ; 849C
        .byte   $60,$00,$3F,$60,$00,$FF,$D8,$00 ; 84A4
        .byte   $FF,$D8,$00,$FD,$D5,$58,$F5,$55 ; 84AC
        .byte   $6A,$D5,$55,$6A,$D5,$65,$AA,$DD ; 84B4
        .byte   $65,$AA,$C9,$95,$A8,$00,$16,$00 ; 84BC
        .byte   $00,$18,$00,$00,$60,$00,$00,$60 ; 84C4
        .byte   $00,$01,$80,$00,$01,$80,$00,$02 ; 84CC
        .byte   $00,$00,$02,$88,$9F,$8E,$A8,$8D ; 84D4
        .byte   $A7,$88,$95,$88,$04,$25,$00,$E0 ; 84DC
        .byte   $00,$7F,$C0,$00,$0F,$E0,$00,$73 ; 84E4
        .byte   $80,$00,$7F,$C0,$00,$0F,$E0,$00 ; 84EC
        .byte   $01,$F0,$00,$00,$78,$00,$00,$38 ; 84F4
        .byte   $07,$1D,$0C,$00,$00,$7C,$00,$00 ; 84FC
        .byte   $7C,$00,$00,$3C,$00,$00,$78,$00 ; 8504
        .byte   $00,$78,$00,$00,$78,$00,$00,$38 ; 850C
        .byte   $00,$00,$3C,$00,$00,$1C,$00,$00 ; 8514
        .byte   $0E,$00,$00,$06,$04,$11,$01,$E4 ; 851C
        .byte   $00,$C6,$FC,$00,$DB,$FC,$00,$DB ; 8524
        .byte   $F0,$00,$EB,$F0,$00,$33,$F0,$00 ; 852C
        .byte   $03,$F0,$00,$03,$F0,$00,$00,$F0 ; 8534
        .byte   $00,$00,$FC,$00,$15,$FC,$00,$EA ; 853C
        .byte   $BC,$00,$DA,$A0,$00,$D0,$00,$00 ; 8544
        .byte   $F0,$00,$00,$30,$88,$06,$00,$24 ; 854C
        .byte   $00,$00,$24,$00,$00,$90,$00,$00 ; 8554
        .byte   $93,$F0,$00,$4F,$FC,$02,$4F,$FC ; 855C
        .byte   $55,$6F,$FC,$55,$6F,$FC,$55,$6D ; 8564
        .byte   $FC,$AA,$65,$7C,$AA,$65,$DC,$AA ; 856C
        .byte   $69,$8C,$02,$90,$00,$00,$24,$00 ; 8574
        .byte   $00,$24,$00,$00,$09,$00,$00,$09 ; 857C
        .byte   $00,$00,$02,$40,$00,$00,$80,$88 ; 8584
        .byte   $7B,$86,$76,$86,$6F,$86,$7B,$82 ; 858C
        .byte   $04,$22,$03,$80,$00,$7F,$C0,$00 ; 8594
        .byte   $0F,$E0,$00,$71,$80,$00,$7F,$C0 ; 859C
        .byte   $00,$0F,$C0,$00,$01,$E0,$00,$00 ; 85A4
        .byte   $70,$00,$00,$30,$00,$00,$20,$07 ; 85AC
        .byte   $1D,$0C,$00,$00,$7C,$00,$00,$7C ; 85B4
        .byte   $00,$00,$3C,$00,$00,$78,$00,$00 ; 85BC
        .byte   $78,$00,$00,$78,$00,$00,$38,$00 ; 85C4
        .byte   $00,$3C,$00,$00,$1C,$00,$00,$0E ; 85CC
        .byte   $00,$00,$06,$04,$11,$01,$E4,$00 ; 85D4
        .byte   $C6,$FC,$00,$DB,$FC,$00,$DB,$F0 ; 85DC
        .byte   $00,$EB,$F0,$00,$33,$F0,$00,$03 ; 85E4
        .byte   $F0,$00,$03,$F0,$00,$00,$F0,$00 ; 85EC
        .byte   $00,$FC,$00,$15,$FC,$00,$EA,$BC ; 85F4
        .byte   $00,$DA,$A0,$00,$D0,$00,$00,$F0 ; 85FC
        .byte   $00,$00,$30,$88,$0B,$10,$00,$00 ; 8604
        .byte   $24,$00,$00,$09,$03,$F0,$02,$4F ; 860C
        .byte   $FC,$55,$4F,$FC,$55,$6F,$FC,$55 ; 8614
        .byte   $6F,$FC,$AA,$6D,$FC,$AA,$65,$7C ; 861C
        .byte   $AA,$65,$DC,$00,$99,$8C,$00,$90 ; 8624
        .byte   $00,$02,$40,$00,$02,$40,$00,$02 ; 862C
        .byte   $00,$00,$09,$00,$00,$08,$00,$00 ; 8634
        .byte   $08,$88,$7B,$89,$76,$88,$6F,$88 ; 863C
        .byte   $7B,$87,$04,$22,$18,$00,$00,$38 ; 8644
        .byte   $00,$00,$7B,$80,$00,$7F,$F0,$00 ; 864C
        .byte   $7F,$F0,$00,$1F,$F8,$00,$07,$F8 ; 8654
        .byte   $00,$80,$78,$00,$E0,$00,$00,$00 ; 865C
        .byte   $10,$07,$1D,$30,$00,$00,$3C,$00 ; 8664
        .byte   $00,$38,$00,$00,$3C,$00,$00,$1E ; 866C
        .byte   $00,$00,$1E,$00,$00,$1E,$00,$00 ; 8674
        .byte   $1C,$00,$00,$3E,$00,$00,$3E,$00 ; 867C
        .byte   $00,$7E,$00,$00,$18,$04,$0D,$10 ; 8684
        .byte   $00,$00,$6D,$00,$00,$3E,$4C,$00 ; 868C
        .byte   $3F,$9C,$00,$3F,$BC,$00,$3F,$BC ; 8694
        .byte   $00,$3F,$3C,$00,$3F,$00,$00,$3F ; 869C
        .byte   $00,$00,$3F,$00,$00,$FF,$00,$00 ; 86A4
        .byte   $FF,$50,$00,$3E,$AC,$00,$0A,$BC ; 86AC
        .byte   $00,$00,$3C,$00,$00,$3C,$00,$00 ; 86B4
        .byte   $0C,$88,$0A,$00,$00,$10,$00,$00 ; 86BC
        .byte   $60,$00,$01,$40,$C9,$85,$80,$DD ; 86C4
        .byte   $56,$00,$F5,$54,$00,$FD,$D8,$00 ; 86CC
        .byte   $FF,$DA,$00,$FF,$D5,$54,$FF,$E5 ; 86D4
        .byte   $54,$FF,$E9,$54,$3F,$6A,$A8,$00 ; 86DC
        .byte   $5A,$A8,$00,$60,$A8,$00,$60,$28 ; 86E4
        .byte   $00,$60,$00,$01,$80,$00,$01,$80 ; 86EC
        .byte   $88,$9D,$87,$A7,$87,$A8,$86,$94 ; 86F4
        .byte   $83,$04,$22,$60,$00,$00,$70,$00 ; 86FC
        .byte   $00,$73,$00,$00,$77,$C0,$00,$7F ; 8704
        .byte   $F0,$00,$3D,$F8,$00,$01,$F8,$00 ; 870C
        .byte   $00,$18,$00,$60,$60,$00,$60,$10 ; 8714
        .byte   $07,$1D,$30,$00,$00,$3C,$00,$00 ; 871C
        .byte   $38,$00,$00,$3C,$00,$00,$1E,$00 ; 8724
        .byte   $00,$1E,$00,$00,$1E,$00,$00,$1C ; 872C
        .byte   $00,$00,$3E,$00,$00,$3E,$00,$00 ; 8734
        .byte   $7E,$00,$00,$18,$04,$0D,$10,$00 ; 873C
        .byte   $00,$6D,$00,$00,$3E,$4C,$00,$3F ; 8744
        .byte   $9C,$00,$3F,$BC,$00,$3F,$BC,$00 ; 874C
        .byte   $3F,$3C,$00,$3F,$00,$00,$3F,$00 ; 8754
        .byte   $00,$3F,$00,$00,$FF,$00,$00,$FF ; 875C
        .byte   $50,$00,$3E,$AC,$00,$0A,$BC,$00 ; 8764
        .byte   $00,$3C,$00,$00,$3C,$00,$00,$0C ; 876C
        .byte   $88,$01,$01,$80,$00,$01,$80,$00 ; 8774
        .byte   $00,$60,$00,$00,$60,$00,$00,$50 ; 877C
        .byte   $00,$00,$10,$00,$C9,$90,$00,$DD ; 8784
        .byte   $68,$00,$F5,$58,$00,$FD,$DA,$00 ; 878C
        .byte   $FF,$D5,$54,$FF,$E5,$54,$FF,$E9 ; 8794
        .byte   $54,$FF,$EA,$A8,$3F,$1A,$A8,$00 ; 879C
        .byte   $18,$28,$00,$18,$08,$00,$18,$00 ; 87A4
        .byte   $00,$28,$00,$00,$09,$00,$00,$02 ; 87AC
        .byte   $88,$9D,$87,$A7,$89,$A8,$88,$94 ; 87B4
        .byte   $81,$04,$25,$00,$30,$00,$00,$70 ; 87BC
        .byte   $00,$1F,$C0,$00,$7F,$80,$00,$7F ; 87C4
        .byte   $80,$00,$0F,$C0,$00,$01,$C0,$00 ; 87CC
        .byte   $00,$C0,$00,$00,$80,$07,$2F,$02 ; 87D4
        .byte   $00,$00,$0E,$00,$00,$7C,$00,$00 ; 87DC
        .byte   $FC,$00,$00,$F8,$00,$00,$78,$04 ; 87E4
        .byte   $0E,$00,$14,$00,$01,$64,$00,$C6 ; 87EC
        .byte   $A8,$00,$DA,$A8,$00,$DA,$A0,$00 ; 87F4
        .byte   $EB,$F0,$00,$33,$F0,$00,$03,$F0 ; 87FC
        .byte   $00,$03,$F0,$00,$03,$50,$00,$01 ; 8804
        .byte   $58,$00,$15,$98,$00,$EA,$A8,$00 ; 880C
        .byte   $DA,$A0,$00,$D0,$00,$00,$F0,$00 ; 8814
        .byte   $00,$30,$88,$08,$00,$40,$00,$00 ; 881C
        .byte   $90,$00,$00,$24,$00,$00,$08,$00 ; 8824
        .byte   $00,$08,$00,$00,$14,$00,$00,$14 ; 882C
        .byte   $03,$A9,$56,$67,$A9,$59,$77,$AA ; 8834
        .byte   $59,$57,$AA,$55,$5F,$AA,$55,$7F ; 883C
        .byte   $2A,$93,$7F,$02,$43,$FF,$02,$40 ; 8844
        .byte   $FC,$0A,$00,$00,$28,$00,$00,$A0 ; 884C
        .byte   $00,$00,$80,$88,$7D,$88,$78,$88 ; 8854
        .byte   $70,$84,$7B,$83,$04,$25,$0C,$00 ; 885C
        .byte   $00,$12,$00,$00,$FC,$00,$00,$7C ; 8864
        .byte   $00,$00,$7C,$00,$00,$7C,$00,$00 ; 886C
        .byte   $3F,$80,$00,$03,$C0,$00,$01,$C0 ; 8874
        .byte   $07,$32,$F0,$00,$00,$F0,$00,$00 ; 887C
        .byte   $F0,$00,$00,$78,$00,$00,$08,$04 ; 8884
        .byte   $0E,$00,$14,$00,$01,$64,$00,$C6 ; 888C
        .byte   $A8,$00,$DA,$A8,$00,$DA,$A0,$00 ; 8894
        .byte   $EB,$F0,$00,$33,$F0,$00,$03,$F0 ; 889C
        .byte   $00,$03,$F0,$00,$03,$50,$00,$01 ; 88A4
        .byte   $58,$00,$15,$98,$00,$EA,$A8,$00 ; 88AC
        .byte   $DA,$A0,$00,$D0,$00,$00,$F0,$00 ; 88B4
        .byte   $00,$30,$88,$10,$14,$00,$00,$29 ; 88BC
        .byte   $40,$0C,$0A,$99,$9C,$25,$65,$DC ; 88C4
        .byte   $A9,$65,$5C,$A9,$65,$7C,$AA,$55 ; 88CC
        .byte   $FC,$AA,$5D,$FC,$2A,$97,$FC,$00 ; 88D4
        .byte   $A7,$F0,$00,$24,$00,$00,$24,$00 ; 88DC
        .byte   $00,$24,$00,$00,$10,$00,$00,$90 ; 88E4
        .byte   $00,$00,$40,$88,$7F,$87,$78,$8A ; 88EC
        .byte   $70,$86,$7B,$86,$05,$2B,$40,$20 ; 88F4
        .byte   $00,$FF,$E0,$00,$FF,$E0,$00,$FF ; 88FC
        .byte   $F8,$00,$EF,$FE,$00,$67,$FF,$00 ; 8904
        .byte   $00,$3F,$04,$26,$60,$78,$00,$FD ; 890C
        .byte   $FE,$00,$1D,$FF,$00,$1F,$C6,$00 ; 8914
        .byte   $1B,$C0,$00,$3B,$80,$00,$37,$00 ; 891C
        .byte   $00,$6C,$00,$00,$40,$07,$0F,$02 ; 8924
        .byte   $AA,$00,$02,$F8,$00,$00,$FC,$00 ; 892C
        .byte   $00,$FC,$00,$00,$FF,$00,$00,$FF ; 8934
        .byte   $80,$00,$FF,$A0,$02,$FE,$A0,$0A ; 893C
        .byte   $A2,$90,$0A,$8A,$50,$0A,$0A,$40 ; 8944
        .byte   $2A,$09,$00,$28,$0A,$00,$FC,$3E ; 894C
        .byte   $00,$FC,$3F,$40,$00,$3F,$C0,$88 ; 8954
        .byte   $0A,$00,$F0,$00,$03,$F0,$00,$03 ; 895C
        .byte   $F0,$00,$03,$F0,$00,$03,$F0,$00 ; 8964
        .byte   $03,$F0,$00,$03,$F0,$00,$02,$F0 ; 896C
        .byte   $00,$06,$A0,$00,$15,$90,$00,$69 ; 8974
        .byte   $90,$00,$81,$50,$00,$81,$50,$00 ; 897C
        .byte   $81,$50,$00,$91,$A0,$00,$22,$A0 ; 8984
        .byte   $00,$02,$A0,$00,$00,$20,$88,$0B ; 898C
        .byte   $F0,$00,$00,$FC,$00,$00,$FC,$00 ; 8994
        .byte   $00,$FC,$00,$00,$F0,$00,$00,$E0 ; 899C
        .byte   $00,$00,$D0,$00,$00,$E0,$00,$00 ; 89A4
        .byte   $50,$00,$00,$54,$00,$00,$54,$00 ; 89AC
        .byte   $00,$69,$00,$00,$A9,$00,$00,$82 ; 89B4
        .byte   $40,$00,$82,$40,$00,$82,$40,$00 ; 89BC
        .byte   $0A,$00,$00,$09,$88,$5E,$D8,$5F ; 89C4
        .byte   $CF,$59,$D7,$5C,$C7,$68,$C7,$05 ; 89CC
        .byte   $2B,$20,$00,$00,$70,$00,$00,$FF ; 89D4
        .byte   $F8,$00,$FC,$3C,$00,$FE,$FE,$00 ; 89DC
        .byte   $7F,$3F,$00,$21,$18,$04,$25,$1C ; 89E4
        .byte   $01,$80,$38,$07,$80,$7E,$1E,$00 ; 89EC
        .byte   $31,$FE,$00,$01,$FC,$00,$03,$F8 ; 89F4
        .byte   $00,$03,$F8,$00,$03,$F0,$00,$01 ; 89FC
        .byte   $E0,$07,$06,$00,$AA,$00,$00,$AA ; 8A04
        .byte   $00,$00,$AA,$00,$00,$AA,$00,$02 ; 8A0C
        .byte   $AA,$00,$03,$FE,$00,$03,$FF,$00 ; 8A14
        .byte   $02,$FF,$00,$03,$FF,$C0,$03,$FE ; 8A1C
        .byte   $C0,$03,$A0,$E0,$01,$40,$50,$0A ; 8A24
        .byte   $42,$90,$0A,$82,$A0,$0A,$02,$80 ; 8A2C
        .byte   $0A,$02,$80,$26,$0D,$40,$5C,$0F ; 8A34
        .byte   $50,$FC,$03,$F0,$88,$0D,$FC,$00 ; 8A3C
        .byte   $00,$FF,$00,$00,$FF,$00,$00,$5F ; 8A44
        .byte   $00,$00,$A7,$00,$00,$75,$00,$00 ; 8A4C
        .byte   $57,$00,$00,$97,$80,$00,$5A,$40 ; 8A54
        .byte   $00,$A9,$90,$00,$A5,$A0,$00,$55 ; 8A5C
        .byte   $24,$00,$55,$08,$00,$54,$08,$00 ; 8A64
        .byte   $54,$08,$00,$50,$18,$00,$50,$28 ; 8A6C
        .byte   $88,$08,$00,$30,$00,$00,$F0,$00 ; 8A74
        .byte   $00,$F0,$00                     ; 8A7C
L8A7F:  .byte   $00,$10,$00,$00,$20,$00,$00,$30 ; 8A7F
        .byte   $00,$00,$10,$00,$00,$10,$00,$01 ; 8A87
        .byte   $A0,$00,$01,$A0,$00,$05,$60,$00 ; 8A8F
        .byte   $05,$90,$00,$16,$90,$00,$18,$90 ; 8A97
        .byte   $00,$60,$90,$00,$60,$90,$00,$60 ; 8A9F
        .byte   $90,$00,$50,$00,$00,$A0,$88,$C0 ; 8AA7
        .byte   $D6,$BE,$CE,$BB,$D2,$C6,$C6,$BA ; 8AAF
        .byte   $C6,$00,$00,$00,$00,$00,$00,$00 ; 8AB7
        .byte   $00,$00,$00,$00,$00,$00,$2F,$2F ; 8ABF
        .byte   $2F,$2F,$00,$00,$00,$00,$00,$00 ; 8AC7
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 8ACF
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 8AD7
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 8ADF
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 8AE7
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 8AEF
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 8AF7
        .byte   $00                             ; 8AFF
L8B00:  .byte   $D0,$D0,$12,$12,$54,$54,$54,$93 ; 8B00
        .byte   $93,$CC,$CC,$FC,$20,$20,$3E,$56 ; 8B08
        .byte   $56,$6A,$84,$84,$A4,$CA,$CA,$FC ; 8B10
        .byte   $FC,$37,$37,$37,$77,$77,$B9,$FB ; 8B18
        .byte   $B9,$B9,$77,$77,$3D,$3D,$3D,$FC ; 8B20
        .byte   $FC,$7A,$7A,$A4,$84,$84,$6A,$A6 ; 8B28
        .byte   $A6,$3E,$20,$20,$FC,$FC,$BA,$BA ; 8B30
        .byte   $BA,$E4,$E4,$E4,$12,$12,$D0,$1D ; 8B38
        .byte   $D0,$5F,$92,$B6,$E0,$1C,$5E,$5F ; 8B40
        .byte   $60,$61,$62,$63,$3E,$3E,$3E,$93 ; 8B48
        .byte   $64,$A6,$A7,$A8,$A9,$AA,$AB,$AC ; 8B50
        .byte   $AD,$AE,$AF,$B0,$B1,$B9,$B9,$B9 ; 8B58
        .byte   $B9,$B2,$F4,$33,$64,$7B,$96,$C3 ; 8B60
        .byte   $05,$47,$48,$49,$4A,$4B,$4C,$4D ; 8B68
        .byte   $4E,$4F,$50,$51,$52,$53,$54,$55 ; 8B70
        .byte   $56,$57,$58,$59,$5A,$5B,$5C,$5D ; 8B78
        .byte   $5E,$5F,$60,$61,$62,$63,$64,$65 ; 8B80
        .byte   $66,$67,$68,$69,$6A,$6B,$6C,$6D ; 8B88
        .byte   $6E,$6F,$70,$71,$72,$73,$74,$75 ; 8B90
        .byte   $76,$77,$78,$79,$7A,$7B,$7C,$7D ; 8B98
        .byte   $7E,$7F,$80,$81,$82,$83,$84,$85 ; 8BA0
        .byte   $86,$D0,$87,$B9,$C9,$D0,$0B,$B9 ; 8BA8
        .byte   $4D,$8F,$A3,$1F                 ; 8BB0
L8BB4:  .byte   $02,$02,$03,$03,$03,$03,$03,$03 ; 8BB4
        .byte   $03,$03,$03,$03,$04,$04,$04,$04 ; 8BBC
        .byte   $04,$04,$04,$04,$04,$04,$04,$04 ; 8BC4
        .byte   $04,$05,$05,$05,$05,$05,$05,$05 ; 8BCC
        .byte   $05,$05,$05,$05,$06,$06,$06,$04 ; 8BD4
        .byte   $04,$06,$06,$04,$04,$04,$04,$06 ; 8BDC
        .byte   $06,$04,$04,$04,$03,$03,$06,$06 ; 8BE4
        .byte   $06,$06,$06,$06,$03,$03,$02,$07 ; 8BEC
        .byte   $02,$07,$07,$07,$07,$08,$08,$08 ; 8BF4
        .byte   $08,$08,$08,$08,$04,$04,$04,$03 ; 8BFC
        .byte   $08,$08,$08,$08,$08,$08,$08,$08 ; 8C04
        .byte   $08,$08,$08,$08,$08,$05,$05,$05 ; 8C0C
        .byte   $05,$08,$08,$09,$09,$09,$09,$09 ; 8C14
        .byte   $0A,$0A,$0A,$0A,$0A,$0A,$0A,$0A ; 8C1C
        .byte   $0A,$0A,$0A,$0A,$0A,$0A,$0A,$0A ; 8C24
        .byte   $0A,$0A,$0A,$0A,$0A,$0A,$0A,$0A ; 8C2C
        .byte   $0A,$0A,$0A,$0A,$0A,$0A,$0A,$0A ; 8C34
        .byte   $0A,$0A,$0A,$0A,$0A,$0A,$0A,$0A ; 8C3C
        .byte   $0A,$0A,$0A,$0A,$0A,$0A,$0A,$0A ; 8C44
        .byte   $0A,$0A,$0A,$0A,$0A,$0A,$0A,$0A ; 8C4C
        .byte   $0A,$0A,$0A,$0A,$0A,$0A,$0A,$0A ; 8C54
        .byte   $0A,$02,$0A,$05,$0A,$02,$0B,$05 ; 8C5C
        .byte   $0B,$0B,$0B,$57                 ; 8C64
L8C68:  .byte   $00,$00,$00,$00,$00,$FF,$FA,$00 ; 8C68
        .byte   $FC,$00,$F9,$00,$00,$F6,$00,$00 ; 8C70
        .byte   $65,$00,$00,$F5,$00,$00,$F8,$00 ; 8C78
        .byte   $FF,$00,$FB,$FA,$00,$FE,$00,$00 ; 8C80
        .byte   $FE,$FF,$FE,$00,$00,$01,$06,$FF ; 8C88
        .byte   $0D,$00,$08,$00,$F5,$00,$00,$00 ; 8C90
        .byte   $9B,$00,$F6,$00,$00,$09,$00,$09 ; 8C98
        .byte   $0D,$00,$04,$05,$00,$00,$00,$00 ; 8CA0
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 8CA8
        .byte   $00,$00,$00,$00,$5B,$4F,$3A,$F6 ; 8CB0
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 8CB8
        .byte   $00,$00,$00,$00,$00,$2F,$2F,$2F ; 8CC0
        .byte   $2F,$00,$00,$00,$00,$00,$00,$00 ; 8CC8
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 8CD0
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 8CD8
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 8CE0
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 8CE8
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 8CF0
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 8CF8
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 8D00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 8D08
        .byte   $00,$00,$00,$FE,$00,$00,$00,$FF ; 8D10
        .byte   $00,$00,$00,$00                 ; 8D18
L8D1C:  .byte   $00,$08,$00,$08,$00,$07,$0F,$00 ; 8D1C
        .byte   $06,$00,$06,$00,$00,$01,$00,$00 ; 8D24
        .byte   $FF,$00,$00,$FF,$00,$00,$FB,$00 ; 8D2C
        .byte   $FB,$00,$F8,$EE,$00,$F8,$00,$00 ; 8D34
        .byte   $F7,$FF,$F8,$00,$00,$0A,$13,$FB ; 8D3C
        .byte   $06,$00,$05,$00,$FF,$00,$00,$00 ; 8D44
        .byte   $01,$FF,$01,$00,$00,$FF,$00,$FB ; 8D4C
        .byte   $F5,$00,$F8,$F1,$08,$00,$08,$00 ; 8D54
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 8D5C
        .byte   $00,$00,$00,$00,$B5,$B5,$B9,$E3 ; 8D64
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 8D6C
        .byte   $00,$00,$00,$00,$00,$1C,$16,$12 ; 8D74
        .byte   $10,$00,$00,$00,$00,$00,$00,$00 ; 8D7C
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 8D84
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 8D8C
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 8D94
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 8D9C
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 8DA4
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 8DAC
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 8DB4
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 8DBC
        .byte   $00,$00,$00,$F8,$00,$FF,$00,$F7 ; 8DC4
        .byte   $00,$00,$00,$00,$01             ; 8DCC
; ----------------------------------------------------------------------------
        .byte   $02                             ; 8DD1
packed_player_sprites_2:
        .byte   $10,$00,$00,$90,$00,$00,$9C,$00 ; 8DD2
        .byte   $00,$9C,$00,$00,$90,$00,$00,$90 ; 8DDA
        .byte   $00,$00,$90,$00,$00,$90,$00,$00 ; 8DE2
        .byte   $90,$00,$00,$90,$00,$00,$90,$00 ; 8DEA
        .byte   $00,$90,$00,$00,$90,$00,$00,$90 ; 8DF2
        .byte   $00,$00,$90,$00,$00,$90,$00,$00 ; 8DFA
        .byte   $90,$00,$00,$9C,$00,$00,$9C,$00 ; 8E02
        .byte   $00,$90,$00,$00,$80,$8D,$B4,$86 ; 8E0A
        .byte   $01,$02,$04,$00,$00,$24,$00,$00 ; 8E12
        .byte   $27,$00,$00,$27,$00,$00,$24,$00 ; 8E1A
        .byte   $00,$24,$00,$00,$24,$00,$00,$24 ; 8E22
        .byte   $00,$00,$24,$00,$00,$24,$00,$00 ; 8E2A
        .byte   $90,$00,$00,$90,$00,$00,$90,$00 ; 8E32
        .byte   $00,$90,$00,$00,$90,$00,$00,$90 ; 8E3A
        .byte   $00,$00,$90,$00,$00,$9C,$00,$00 ; 8E42
        .byte   $9C,$00,$00,$90,$00,$00,$80,$8D ; 8E4A
        .byte   $B2,$97,$01,$05,$00,$90,$00,$00 ; 8E52
        .byte   $90,$00,$00,$9C,$00,$02,$9C,$00 ; 8E5A
        .byte   $02,$40,$00,$02,$40,$00,$02,$40 ; 8E62
        .byte   $00,$0A,$40,$00,$09,$00,$00,$09 ; 8E6A
        .byte   $00,$00,$09,$00,$00,$09,$00,$00 ; 8E72
        .byte   $29,$00,$00,$24,$00,$00,$24,$00 ; 8E7A
        .byte   $00,$27,$00,$00,$A7,$00,$00,$90 ; 8E82
        .byte   $00,$00,$90,$00,$00,$40,$8D,$A9 ; 8E8A
        .byte   $A9,$01,$0B,$00,$00,$80,$00,$02 ; 8E92
        .byte   $80,$00,$02,$40,$00,$0A,$C0,$00 ; 8E9A
        .byte   $09,$C0,$00,$28,$00,$00,$24,$00 ; 8EA2
        .byte   $00,$A0,$00,$00,$90,$00,$02,$80 ; 8EAA
        .byte   $00,$02,$40,$00,$0A,$00,$00,$09 ; 8EB2
        .byte   $00,$00,$28,$00,$00,$27,$00,$00 ; 8EBA
        .byte   $A3,$00,$00,$90,$00,$00,$40,$8D ; 8EC2
        .byte   $98,$C1,$01,$14,$00,$00,$A4,$00 ; 8ECA
        .byte   $00,$90,$00,$02,$90,$00,$0A,$70 ; 8ED2
        .byte   $00,$09,$30,$00,$29,$00,$00,$A4 ; 8EDA
        .byte   $00,$02,$90,$00,$02,$90,$00,$0A ; 8EE2
        .byte   $40,$00,$09,$00,$00,$29,$00,$00 ; 8EEA
        .byte   $A7,$00,$00,$A7,$00,$00,$50,$8D ; 8EF2
        .byte   $89,$CF,$01,$20,$00,$00,$A0,$00 ; 8EFA
        .byte   $02,$90,$00,$0A,$40,$00,$29,$C0 ; 8F02
        .byte   $00,$A4,$C0,$02,$90,$00,$0A,$40 ; 8F0A
        .byte   $00,$29,$00,$00,$A4,$00,$00,$9C ; 8F12
        .byte   $00,$00,$4C,$8D,$7B,$DA,$01,$26 ; 8F1A
        .byte   $00,$00,$A8,$00,$02,$A4,$00,$0A ; 8F22
        .byte   $50,$00,$A9,$30,$0A,$A4,$30,$2A ; 8F2A
        .byte   $50,$00,$A5,$00,$00,$5C,$00,$00 ; 8F32
        .byte   $0C,$8D,$71,$DE,$01,$2C,$00,$00 ; 8F3A
        .byte   $A8,$00,$AA,$AA,$AA,$AA,$55,$6A ; 8F42
        .byte   $55,$0C,$15,$00,$0C,$0C,$00,$00 ; 8F4A
        .byte   $0C,$8D,$5D,$E4,$01,$30,$AA,$AA ; 8F52
        .byte   $A8,$6A,$AA,$AA,$15,$55,$55,$0C ; 8F5A
        .byte   $00,$0C,$0C,$00,$0C,$8D,$54,$E5 ; 8F62
        .byte   $01,$2A,$2A,$00,$00,$AA,$AA,$00 ; 8F6A
        .byte   $55,$AA,$AA,$30,$55,$A9,$30,$00 ; 8F72
        .byte   $54,$00,$00,$30,$00,$00,$30,$8D ; 8F7A
        .byte   $B1,$E1,$01,$24,$A8,$00,$00,$6A ; 8F82
        .byte   $00,$00,$16,$80,$00,$31,$A8,$00 ; 8F8A
        .byte   $30,$6A,$80,$00,$16,$A0,$00,$01 ; 8F92
        .byte   $68,$00,$00,$D4,$00,$00,$C0,$8D ; 8F9A
        .byte   $AD,$DE,$01,$1E,$A0,$00,$00,$68 ; 8FA2
        .byte   $00,$00,$1A,$00,$00,$36,$80,$00 ; 8FAA
        .byte   $31,$A0,$00,$00,$68,$00,$00,$1A ; 8FB2
        .byte   $00,$00,$06,$80,$00,$01,$A0,$00 ; 8FBA
        .byte   $03,$60,$00,$03,$10,$8D,$99,$DA ; 8FC2
        .byte   $01,$12,$68,$00,$00,$18,$00,$00 ; 8FCA
        .byte   $1A,$00,$00,$36,$80,$00,$31,$80 ; 8FD2
        .byte   $00,$01,$A0,$00,$00,$68,$00,$00 ; 8FDA
        .byte   $1A,$00,$00,$1A,$00,$00,$06,$80 ; 8FE2
        .byte   $00,$01,$80,$00,$01,$A0,$00,$03 ; 8FEA
        .byte   $68,$00,$03,$68,$00,$00,$14,$8D ; 8FF2
        .byte   $93,$D4,$01,$09,$80,$00,$00,$A0 ; 8FFA
        .byte   $00,$00,$60,$00,$00,$E8,$00,$00 ; 9002
        .byte   $D8,$00,$00,$0A,$00,$00,$06,$00 ; 900A
        .byte   $00,$02,$80,$00,$01,$80,$00,$00 ; 9012
        .byte   $A0,$00,$00,$60,$00,$00,$28,$00 ; 901A
        .byte   $00,$18,$00,$00,$0A,$00,$00,$36 ; 9022
        .byte   $00,$00,$32,$80,$00,$01,$80,$00 ; 902A
        .byte   $00,$40,$8D,$80,$C6,$01,$04,$18 ; 9032
        .byte   $00,$00,$18,$00,$00,$D8,$00,$00 ; 903A
        .byte   $DA,$00,$00,$06,$00,$00,$06,$00 ; 9042
        .byte   $00,$06,$00,$00,$06,$80,$00,$01 ; 904A
        .byte   $80,$00,$01,$80,$00,$01,$80,$00 ; 9052
        .byte   $01,$80,$00,$01,$A0,$00,$00,$60 ; 905A
        .byte   $00,$00,$60,$00,$03,$60,$00,$03 ; 9062
        .byte   $68,$00,$00,$18,$00,$00,$18,$00 ; 906A
        .byte   $00,$04,$8D,$77,$B8,$01,$02,$10 ; 9072
        .byte   $00,$00,$18,$00,$00,$D8,$00,$00 ; 907A
        .byte   $D8,$00,$00,$18,$00,$00,$18,$00 ; 9082
        .byte   $00,$18,$00,$00,$18,$00,$00,$18 ; 908A
        .byte   $00,$00,$18,$00,$00,$06,$00,$00 ; 9092
        .byte   $06,$00,$00,$06,$00,$00,$06,$00 ; 909A
        .byte   $00,$06,$00,$00,$06,$00,$00,$06 ; 90A2
        .byte   $00,$00,$36,$00,$00,$36,$00,$00 ; 90AA
        .byte   $06,$00,$00,$02,$8D,$6E,$9E,$01 ; 90B2
        .byte   $02,$10,$00,$00,$18,$00,$00,$D8 ; 90BA
        .byte   $00,$00,$D8,$00,$00,$18,$00,$00 ; 90C2
        .byte   $18,$00,$00,$18,$00,$00,$18,$00 ; 90CA
        .byte   $00,$18,$00,$00,$18,$00,$00,$18 ; 90D2
        .byte   $00,$00,$18,$00,$00,$18,$00,$00 ; 90DA
        .byte   $18,$00,$00,$18,$00,$00,$18,$00 ; 90E2
        .byte   $00,$18,$00,$00,$D8,$00,$00,$D8 ; 90EA
        .byte   $00,$00,$18,$00,$00,$08,$8D,$6C ; 90F2
        .byte   $8C,$01,$02,$10,$00,$00,$18,$00 ; 90FA
        .byte   $00,$D8,$00,$00,$D8,$00,$00,$18 ; 9102
        .byte   $00,$00,$18,$00,$00,$18,$00,$00 ; 910A
        .byte   $18,$00,$00,$18,$00,$00,$18,$00 ; 9112
        .byte   $00,$18,$00,$00,$18,$00,$00,$18 ; 911A
        .byte   $00,$00,$18,$00,$00,$18,$00,$00 ; 9122
        .byte   $18,$00,$00,$18,$00,$00,$D8,$00 ; 912A
        .byte   $00,$D8,$00,$00,$18,$00,$00,$08 ; 9132
        .byte   $8D,$6B,$84,$01,$07,$18,$00,$00 ; 913A
        .byte   $D8,$00,$00,$DA,$00,$00,$06,$00 ; 9142
        .byte   $00,$06,$00,$00,$06,$00,$00,$06 ; 914A
        .byte   $80,$00,$01,$80,$00,$01,$80,$00 ; 9152
        .byte   $01,$80,$00,$01,$80,$00,$01,$A0 ; 915A
        .byte   $00,$00,$60,$00,$00,$60,$00,$03 ; 9162
        .byte   $60,$00,$03,$68,$00,$00,$18,$00 ; 916A
        .byte   $00,$18,$00,$00,$04,$8D,$71,$A7 ; 9172
        .byte   $01,$18,$60,$00,$00,$68,$00,$00 ; 917A
        .byte   $DA,$00,$00,$C6,$00,$00,$06,$80 ; 9182
        .byte   $00,$01,$A0,$00,$00,$68,$00,$00 ; 918A
        .byte   $68,$00,$00,$1A,$00,$00,$06,$00 ; 9192
        .byte   $00,$06,$80,$00,$0D,$A0,$00,$0C ; 919A
        .byte   $50,$8D,$8D,$D0,$01,$30,$2A,$AA ; 91A2
        .byte   $AA,$AA,$AA,$A9,$55,$55,$54,$30 ; 91AA
        .byte   $00,$30,$30,$00,$30,$8D,$B9,$E4 ; 91B2
        .byte   $01,$1A,$00,$00,$90,$00,$02,$90 ; 91BA
        .byte   $00,$0A,$70,$00,$09,$30,$00,$29 ; 91C2
        .byte   $00,$00,$A4,$00,$02,$90,$00,$02 ; 91CA
        .byte   $90,$00,$0A,$40,$00,$09,$00,$00 ; 91D2
        .byte   $29,$00,$00,$A7,$00,$00,$53,$8D ; 91DA
        .byte   $89,$D0,$01,$0B,$00,$90,$00,$00 ; 91E2
        .byte   $9C,$00,$02,$9C,$00,$02,$40,$00 ; 91EA
        .byte   $02,$40,$00,$02,$40,$00,$0A,$40 ; 91F2
        .byte   $00,$09,$00,$00,$09,$00,$00,$09 ; 91FA
        .byte   $00,$00,$09,$00,$00,$29,$00,$00 ; 9202
        .byte   $24,$00,$00,$24,$00,$00,$27,$00 ; 920A
        .byte   $00,$A7,$00,$00,$90,$00,$00,$40 ; 9212
        .byte   $8D,$A4,$B9,$01,$02,$10,$00,$00 ; 921A
        .byte   $90,$00,$00,$9C,$00,$00,$9C,$00 ; 9222
        .byte   $00,$90,$00,$00,$90,$00,$00,$90 ; 922A
        .byte   $00,$00,$90,$00,$00,$90,$00,$00 ; 9232
        .byte   $90,$00,$00,$90,$00,$00,$90,$00 ; 923A
        .byte   $00,$90,$00,$00,$90,$00,$00,$90 ; 9242
        .byte   $00,$00,$90,$00,$00,$90,$00,$00 ; 924A
        .byte   $9C,$00,$00,$9C,$00,$00,$90,$00 ; 9252
        .byte   $00,$80,$8D,$B4,$86,$01,$11,$A0 ; 925A
        .byte   $00,$00,$A0,$00,$00,$A0,$00,$00 ; 9262
        .byte   $A0,$00,$00,$A0,$00,$00,$A8,$00 ; 926A
        .byte   $00,$28,$00,$00,$28,$00,$00,$28 ; 9272
        .byte   $00,$00,$2A,$00,$00,$0A,$00,$00 ; 927A
        .byte   $0A,$00,$00,$0A,$00,$00,$0A,$00 ; 9282
        .byte   $00,$09,$00,$00,$04,$8D,$B0,$8B ; 928A
        .byte   $01,$20,$20,$00,$00,$A8,$00,$00 ; 9292
        .byte   $A8,$00,$00,$6A,$00,$00,$EA,$00 ; 929A
        .byte   $00,$2A,$80,$00,$1A,$80,$00,$0A ; 92A2
        .byte   $A0,$00,$0A,$50,$00,$05,$30,$00 ; 92AA
        .byte   $0C,$8D,$AE,$90,$01,$1A,$00,$01 ; 92B2
        .byte   $C0,$00,$09,$C0,$00,$29,$00,$00 ; 92BA
        .byte   $A9,$00,$02,$A9,$C0,$02,$A9,$C0 ; 92C2
        .byte   $0A,$A4,$00,$2A,$90,$00,$AA,$40 ; 92CA
        .byte   $00,$A9,$00,$00,$A4,$00,$00,$90 ; 92D2
        .byte   $00,$00,$40,$8D,$A4,$95,$01,$08 ; 92DA
        .byte   $09,$00,$00,$09,$C0,$00,$09,$C0 ; 92E2
        .byte   $00,$09,$00,$00,$09,$00,$00,$24 ; 92EA
        .byte   $00,$00,$24,$00,$00,$24,$00,$00 ; 92F2
        .byte   $24,$00,$00,$24,$00,$00,$24,$00 ; 92FA
        .byte   $00,$24,$00,$00,$90,$00,$00,$90 ; 9302
        .byte   $00,$00,$90,$00,$00,$9C,$00,$00 ; 930A
        .byte   $9C,$00,$00,$90,$00,$00,$90,$8D ; 9312
        .byte   $AE,$96,$01,$02,$10,$00,$00,$90 ; 931A
        .byte   $00,$00,$9C,$00,$00,$9C,$00,$00 ; 9322
        .byte   $90,$00,$00,$90,$00,$00,$90,$00 ; 932A
        .byte   $00,$90,$00,$00,$90,$00,$00,$90 ; 9332
        .byte   $00,$00,$90,$00,$00,$90,$00,$00 ; 933A
        .byte   $90,$00,$00,$90,$00,$00,$90,$00 ; 9342
        .byte   $00,$90,$00,$00,$90,$00,$00,$9C ; 934A
        .byte   $00,$00,$9C,$00,$00,$90,$00,$00 ; 9352
        .byte   $80,$8D,$B4,$96,$00,$00,$00,$00 ; 935A
        .byte   $00,$00,$01,$02,$04,$00,$00,$24 ; 9362
        .byte   $00,$00,$27,$00,$00,$27,$00,$00 ; 936A
        .byte   $24,$00,$00,$24,$00,$00,$24,$00 ; 9372
        .byte   $00,$24,$00,$00,$24,$00,$00,$24 ; 937A
        .byte   $00,$00,$90,$00,$00,$90,$00,$00 ; 9382
        .byte   $90,$00,$00,$90,$00,$00,$90,$00 ; 938A
        .byte   $00,$90,$00,$00,$90,$00,$00,$9C ; 9392
        .byte   $00,$00,$9C,$00,$00,$90,$00,$00 ; 939A
        .byte   $80,$8D,$8C,$AD,$00,$00,$00,$00 ; 93A2
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 93AA
        .byte   $01,$02,$60,$00,$00,$68,$00,$00 ; 93B2
        .byte   $68,$00,$00,$68,$00,$00,$68,$00 ; 93BA
        .byte   $00,$68,$00,$00,$68,$00,$00,$68 ; 93C2
        .byte   $00,$00,$68,$00,$00,$68,$00,$00 ; 93CA
        .byte   $68,$00,$00,$68,$00,$00,$68,$00 ; 93D2
        .byte   $00,$68,$00,$00,$68,$00,$00,$68 ; 93DA
        .byte   $00,$00,$68,$00,$00,$68,$00,$00 ; 93E2
        .byte   $68,$00,$00,$68,$00,$00,$18,$8D ; 93EA
        .byte   $9C,$9C,$01,$05,$50,$00,$00,$A4 ; 93F2
        .byte   $00,$00,$A8,$00,$00,$A8,$00,$00 ; 93FA
        .byte   $A8,$00,$00,$A8,$00,$00,$A8,$00 ; 9402
        .byte   $00,$A8,$00,$00,$A8,$00,$00,$A8 ; 940A
        .byte   $00,$00,$A8,$00,$00,$A8,$00,$00 ; 9412
        .byte   $A8,$00,$00,$A8,$00,$00,$A8,$00 ; 941A
        .byte   $00,$A8,$00,$00,$A8,$00,$00,$A8 ; 9422
        .byte   $00,$00,$28,$00,$00,$08,$8D,$A5 ; 942A
        .byte   $99,$01,$13,$50,$00,$00,$A4,$00 ; 9432
        .byte   $00,$A9,$00,$00,$A9,$00,$00,$A9 ; 943A
        .byte   $00,$00,$2A,$40,$00,$2A,$40,$00 ; 9442
        .byte   $2A,$40,$00,$2A,$40,$00,$0A,$90 ; 944A
        .byte   $00,$0A,$90,$00,$02,$90,$00,$02 ; 9452
        .byte   $A4,$00,$00,$A4,$00,$00,$24,$8D ; 945A
        .byte   $A8,$99,$01,$2D,$0C,$00,$00,$55 ; 9462
        .byte   $00,$00,$AA,$54,$30,$2A,$A9,$55 ; 946A
        .byte   $00,$AA,$AA,$00,$02,$A8,$8D,$A1 ; 9472
        .byte   $98,$01,$29,$00,$00,$D0,$00,$01 ; 947A
        .byte   $60,$00,$16,$A0,$0D,$6A,$80,$16 ; 9482
        .byte   $A8,$00,$6A,$80,$00,$68,$00,$00 ; 948A
        .byte   $40,$8D,$9E,$99,$01,$17,$00,$06 ; 9492
        .byte   $00,$00,$36,$00,$00,$18,$00,$00 ; 949A
        .byte   $18,$00,$00,$60,$00,$00,$60,$00 ; 94A2
        .byte   $01,$80,$00,$01,$80,$00,$06,$00 ; 94AA
        .byte   $00,$36,$00,$00,$18,$00,$00,$18 ; 94B2
        .byte   $00,$00,$60,$00,$00,$60,$8D,$95 ; 94BA
        .byte   $9A,$01,$02,$01,$00,$00,$01,$80 ; 94C2
        .byte   $00,$0D,$80,$00,$0D,$80,$00,$01 ; 94CA
        .byte   $80,$00,$01,$80,$00,$01,$80,$00 ; 94D2
        .byte   $06,$00,$00,$06,$00,$00,$06,$00 ; 94DA
        .byte   $00,$06,$00,$00,$06,$00,$00,$06 ; 94E2
        .byte   $00,$00,$06,$00,$00,$06,$00,$00 ; 94EA
        .byte   $18,$00,$00,$18,$00,$00,$D8,$00 ; 94F2
        .byte   $00,$D8,$00,$00,$18,$00,$00,$08 ; 94FA
        .byte   $8D,$91,$9E,$01,$02,$10,$00,$00 ; 9502
        .byte   $18,$00,$00,$D8,$00,$00,$D8,$00 ; 950A
        .byte   $00,$18,$00,$00,$18,$00,$00,$18 ; 9512
        .byte   $00,$00,$18,$00,$00,$18,$00,$00 ; 951A
        .byte   $18,$00,$00,$18,$00,$00,$18,$00 ; 9522
        .byte   $00,$18,$00,$00,$18,$00,$00,$18 ; 952A
        .byte   $00,$00,$18,$00,$00,$18,$00,$00 ; 9532
        .byte   $D8,$00,$00,$D8,$00,$00,$18,$00 ; 953A
        .byte   $00,$08,$8D,$94,$AD,$00,$00,$00 ; 9542
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 954A
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 9552
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 955A
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 9562
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 956A
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 9572
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 957A
        .byte   $00,$00,$00,$00,$00,$01,$02,$10 ; 9582
        .byte   $00,$00,$90,$00,$00,$9C,$00,$00 ; 958A
        .byte   $9C,$00,$00,$90,$00,$00,$90,$00 ; 9592
        .byte   $00,$90,$00,$00,$90,$00,$00,$90 ; 959A
        .byte   $00,$00,$90,$00,$00,$90,$00,$00 ; 95A2
        .byte   $90,$00,$00,$90,$00,$00,$90,$00 ; 95AA
        .byte   $00,$90,$00,$00,$90,$00,$00,$90 ; 95B2
        .byte   $00,$00,$9C,$00,$00,$9C,$00,$00 ; 95BA
        .byte   $90,$00,$00,$80,$8D,$B4,$88,$01 ; 95C2
        .byte   $02,$10,$00,$00,$18,$00,$00,$D8 ; 95CA
        .byte   $00,$00,$D8,$00,$00,$18,$00,$00 ; 95D2
        .byte   $18,$00,$00,$18,$00,$00,$18,$00 ; 95DA
        .byte   $00,$18,$00,$00,$18,$00,$00,$18 ; 95E2
        .byte   $00,$00,$18,$00,$00,$18,$00,$00 ; 95EA
        .byte   $18,$00,$00,$18,$00,$00,$18,$00 ; 95F2
        .byte   $00,$18,$00,$00,$D8,$00,$00,$D8 ; 95FA
        .byte   $00,$00,$18,$00,$00,$08,$8D,$6A ; 9602
        .byte   $85,$01,$02,$10,$00,$00,$90,$00 ; 960A
        .byte   $00,$9C,$00,$00,$9C,$00,$00,$90 ; 9612
        .byte   $00,$00,$90,$00,$00,$90,$00,$00 ; 961A
        .byte   $90,$00,$00,$90,$00,$00,$90,$00 ; 9622
        .byte   $00,$90,$00,$00,$90,$00,$00,$90 ; 962A
        .byte   $00,$00,$90,$00,$00,$90,$00,$00 ; 9632
        .byte   $90,$00,$00,$90,$00,$00,$9C,$00 ; 963A
        .byte   $00,$9C,$00,$00,$90,$00,$00,$80 ; 9642
        .byte   $8D,$B4,$87,$01,$02,$10,$00,$00 ; 964A
        .byte   $18,$00,$00,$D8,$00,$00,$D8,$00 ; 9652
        .byte   $00,$18,$00,$00,$18,$00,$00,$18 ; 965A
        .byte   $00,$00,$18,$00,$00,$18,$00,$00 ; 9662
        .byte   $18,$00,$00,$18,$00,$00,$18,$00 ; 966A
        .byte   $00,$18,$00,$00,$18,$00,$00,$18 ; 9672
        .byte   $00,$00,$18,$00,$00,$18,$00,$00 ; 967A
        .byte   $D8,$00,$00,$D8,$00,$00,$18,$00 ; 9682
        .byte   $00,$08,$8D,$6B,$85,$01,$30,$2A ; 968A
        .byte   $AA,$AA,$AA,$AA,$A9,$55,$55,$54 ; 9692
        .byte   $30,$00,$30,$30,$00,$30,$8D,$54 ; 969A
        .byte   $E5,$01,$30,$AA,$AA,$A8,$6A,$AA ; 96A2
        .byte   $AA,$15,$55,$55,$0C,$00,$0C,$0C ; 96AA
        .byte   $00,$0C,$8D,$B9,$E4             ; 96B2
; ----------------------------------------------------------------------------
        brk                                     ; 96B7
        brk                                     ; 96B8
        brk                                     ; 96B9
        brk                                     ; 96BA
        brk                                     ; 96BB
        brk                                     ; 96BC
        brk                                     ; 96BD
        brk                                     ; 96BE
        brk                                     ; 96BF
blank_1:.byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 96C0
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 96C8
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 96D0
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 96D8
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 96E0
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 96E8
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 96F0
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 96F8
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 9700
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 9708
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 9710
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 9718
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 9720
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 9728
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 9730
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 9738
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 9740
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 9748
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 9750
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 9758
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 9760
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 9768
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 9770
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 9778
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 9780
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 9788
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 9790
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 9798
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 97A0
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 97A8
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 97B0
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 97B8
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 97C0
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 97C8
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 97D0
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 97D8
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 97E0
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 97E8
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 97F0
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 97F8
        .byte   $A2,$5E,$A9,$7C,$60,$7C,$77,$31 ; 9800
        .byte   $57,$8D,$84,$BF,$B6,$72,$95,$75 ; 9808
        .byte   $DA,$CD,$88,$54,$6B,$B2,$70,$8E ; 9810
        .byte   $6A,$9F,$57,$85,$79,$AB,$61,$7B ; 9818
        .byte   $7A,$21,$E6,$00,$8A,$73,$49,$39 ; 9820
        .byte   $7D,$A3,$53,$12,$00,$00,$0E,$51 ; 9828
        .byte   $17,$05,$6C,$B8,$61,$5F,$97,$85 ; 9830
        .byte   $6D,$AE,$67,$AA,$40,$DC,$B2,$8B ; 9838
        .byte   $7B,$6B,$E0,$75,$68,$52,$0B,$BF ; 9840
        .byte   $AD,$5A,$6A,$73,$4A,$13,$BF,$CB ; 9848
        .byte   $3C,$63,$ED,$E7,$FC,$A2,$4C,$27 ; 9850
        .byte   $51,$D7,$45,$6C,$2F,$E7,$FC,$A2 ; 9858
        .byte   $4C,$47,$B1,$57,$45,$6C,$B8,$7C ; 9860
        .byte   $60,$7C,$1F,$F1,$F4,$A4,$7B,$61 ; 9868
        .byte   $7C,$1F,$86,$5D,$A6,$7C,$60,$7C ; 9870
        .byte   $A8,$57,$8D,$F1,$8A,$A1,$5E,$86 ; 9878
        .byte   $F2,$89,$44,$B4,$0A,$9F,$88,$54 ; 9880
        .byte   $6B,$B9,$77,$80,$60,$99,$67,$20 ; 9888
        .byte   $79,$67,$21,$78,$67,$22,$77,$67 ; 9890
        .byte   $23,$65,$48,$21,$AF,$73,$92,$4B ; 9898
        .byte   $5C,$5A,$5C,$B7,$1D,$2F,$94,$01 ; 98A0
        .byte   $87,$88,$58,$98,$01,$3F,$AF,$88 ; 98A8
        .byte   $E2,$B7,$57,$8D,$88,$BB,$BD,$94 ; 98B0
        .byte   $AF,$BD,$74,$DB,$B1,$73,$DC,$CD ; 98B8
        .byte   $66,$7E,$89,$BA,$D9,$5A,$8A,$73 ; 98C0
        .byte   $DD,$CC,$DE,$06,$8B,$B8,$D9,$72 ; 98C8
        .byte   $72,$84,$BF,$D9,$57,$8D,$75,$DA ; 98D0
        .byte   $B1,$76,$D9,$D1,$54,$DB,$51,$D3 ; 98D8
        .byte   $DC,$4D,$F6,$AA,$56,$B1,$4B,$8E ; 98E0
        .byte   $56,$8E,$75,$DA,$D0,$55,$DB,$EC ; 98E8
        .byte   $08,$40,$99,$57,$8D,$75,$DA,$CD ; 98F0
        .byte   $56,$8E,$76,$D9,$D0,$54,$DC,$EC ; 98F8
        .byte   $28,$E1,$D5,$52,$54,$B6,$00,$AB ; 9900
        .byte   $D2,$8B,$96,$60,$C9,$68,$9F,$3E ; 9908
        .byte   $9F,$B2,$A9,$C8,$39,$B0,$47,$0A ; 9910
        .byte   $8F,$67,$09,$BF,$08,$27,$BA,$40 ; 9918
        .byte   $94,$79,$CA,$E9,$40,$FF,$8E,$07 ; 9920
        .byte   $7A,$8E,$D2,$A9,$C0,$E9,$40,$B9 ; 9928
        .byte   $1E,$E9,$40,$94,$6E,$D5,$E9,$40 ; 9930
        .byte   $B3,$4F,$2D,$25,$C1,$7E,$75,$8C ; 9938
        .byte   $76,$25,$64,$82,$9F,$56,$8A,$75 ; 9940
        .byte   $26,$15,$D1,$A3,$57,$85,$78,$23 ; 9948
        .byte   $17,$CD,$A1,$59,$4B,$37,$05,$79 ; 9950
        .byte   $32,$D2,$E4,$19,$C7,$34,$D6,$1F ; 9958
        .byte   $B6,$58,$F3,$1D,$A0,$E6,$7A,$78 ; 9960
        .byte   $79,$AF,$E7,$79,$78,$7A,$4D,$F8 ; 9968
        .byte   $BF,$9F,$60,$AB,$65,$BE,$FD,$45 ; 9970
        .byte   $BE,$20,$0B,$35,$C6,$D4,$06,$23 ; 9978
        .byte   $B2,$50,$34,$56,$0E,$84,$BF,$D5 ; 9980
        .byte   $51,$97,$73,$DD,$C8,$52,$96,$88 ; 9988
        .byte   $BB,$D5,$53,$8D,$7C,$A1,$67,$85 ; 9990
        .byte   $6A,$0C,$8A,$70,$06,$B9,$CC,$84 ; 9998
        .byte   $88,$5F,$D6,$46,$E8,$68,$49,$57 ; 99A0
        .byte   $85,$6F,$B5,$61,$7B,$70,$AB,$65 ; 99A8
        .byte   $AC,$40,$94,$71,$D2,$E9,$40,$94 ; 99B0
        .byte   $72,$A9,$60,$20,$D2,$13,$C4,$F6 ; 99B8
        .byte   $11,$3F,$11,$D2,$13,$A5,$FF,$57 ; 99C0
        .byte   $20,$C9,$1C,$C5,$06,$2A,$52,$96 ; 99C8
        .byte   $21,$C6,$06,$01,$3A,$16,$D2,$13 ; 99D0
        .byte   $A5,$76,$D2,$13,$47,$7C,$3B,$1D ; 99D8
        .byte   $C9,$1C,$A0,$51,$0F,$F2,$D9,$03 ; 99E0
        .byte   $8D,$C8,$1B,$E6,$F7,$11,$08,$FF ; 99E8
        .byte   $FF,$E9,$25,$0B,$09,$FF,$C8,$16 ; 99F0
        .byte   $F7,$09,$FA,$FD,$0B,$FF,$E9,$00 ; 99F8
        .byte   $00,$F6,$EE,$74,$A8,$DB,$0A,$9D ; 9A00
        .byte   $87,$A0,$59,$6E,$72,$A0,$83,$65 ; 9A08
        .byte   $96,$5C,$89,$47,$44,$79,$97,$E0 ; 9A10
        .byte   $29,$49,$2E,$01,$E3,$9C,$D4,$35 ; 9A18
        .byte   $56,$49,$61,$5F,$18,$91,$4E,$69 ; 9A20
        .byte   $B8,$73,$6C,$BA,$C6,$87,$1A,$88 ; 9A28
        .byte   $57,$C9,$48,$E7,$55,$62,$51,$AA ; 9A30
        .byte   $57,$8D,$73,$DD,$4F,$D4,$DD,$73 ; 9A38
        .byte   $AB,$31,$D4,$DD,$73,$B3,$21,$5C ; 9A40
        .byte   $6A,$42,$D4,$DD,$93,$92,$22,$5C ; 9A48
        .byte   $22,$D6,$72,$00,$00,$00,$00,$42 ; 9A50
        .byte   $D4,$DD,$73,$B0,$E8,$00,$00,$C5 ; 9A58
        .byte   $53,$DD,$6D,$00,$03,$B3,$DD,$6D ; 9A60
        .byte   $00,$03,$B3,$DD,$6D,$00,$53,$E8 ; 9A68
        .byte   $86,$42,$B3,$DD,$6D,$00,$03,$B3 ; 9A70
        .byte   $DD,$C0,$E8,$87,$A1,$53,$DD,$6D ; 9A78
        .byte   $00,$03,$B3,$DD,$6D,$00,$03,$B3 ; 9A80
        .byte   $DD,$6D,$00,$53,$E9,$85,$42,$B3 ; 9A88
        .byte   $DD,$6D,$00,$03,$B3,$DD,$C0,$E9 ; 9A90
        .byte   $86,$A1,$53,$DD,$6D,$00,$03,$B3 ; 9A98
        .byte   $DD,$6D,$00,$03,$B3,$DD,$6D,$00 ; 9AA0
        .byte   $53,$EA,$84,$42,$B3,$DD,$6D,$00 ; 9AA8
        .byte   $03,$B3,$DD,$C0,$EA,$85,$A1,$53 ; 9AB0
        .byte   $DD,$6D,$00,$03,$B3,$DD,$6D,$00 ; 9AB8
        .byte   $03,$B3,$DD,$6D,$00,$53,$EB,$83 ; 9AC0
        .byte   $42,$B3,$DD,$6D,$00,$03,$B3,$DD ; 9AC8
        .byte   $C0,$EB,$84,$DE,$FE,$E8,$B0,$29 ; 9AD0
        .byte   $77,$6D,$73,$DD,$CC,$7B,$61,$7C ; 9AD8
        .byte   $A1,$5E,$86,$76,$C0,$44,$0D,$AC ; 9AE0
        .byte   $47,$0B,$05,$F3,$E5,$E8,$25,$99 ; 9AE8
        .byte   $6A,$0C,$8A,$70,$06,$9C,$60,$BE ; 9AF0
        .byte   $4B,$04,$B0,$43,$0B,$B3,$4B,$03 ; 9AF8
        .byte   $11,$82,$67,$BA,$C0,$70,$78,$29 ; 9B00
        .byte   $6D,$47,$B7,$89,$77,$CC,$84,$AB ; 9B08
        .byte   $0D,$A9,$4D,$05,$AD,$4F,$04,$A3 ; 9B10
        .byte   $CC,$20,$6C,$05,$A3,$63,$89,$6D ; 9B18
        .byte   $04,$A3,$5E,$8E,$77,$D8,$C5,$68 ; 9B20
        .byte   $84,$76,$D9,$C5,$DF,$0D,$7F,$D0 ; 9B28
        .byte   $C5,$6F,$7D,$80,$CF,$C5,$72,$B6 ; 9B30
        .byte   $46,$ED,$90,$6D,$05,$8D,$6F,$04 ; 9B38
        .byte   $61,$00,$2D,$B3,$C5,$9D,$7A,$A1 ; 9B40
        .byte   $00,$48,$98,$63,$D4,$F6,$46,$E7 ; 9B48
        .byte   $B2,$AF,$4A,$6D,$8E,$63,$D0,$FA ; 9B50
        .byte   $46,$EA,$94,$82,$C0,$BE,$87,$BB ; 9B58
        .byte   $D2,$65,$E5,$26,$BE,$00,$2B,$CF ; 9B60
        .byte   $06,$28,$96,$87,$BB,$90,$E0,$05 ; 9B68
        .byte   $B7,$09,$F8,$88,$78,$AC,$7C,$60 ; 9B70
        .byte   $7C,$5F,$49,$56,$8E,$FB,$85,$95 ; 9B78
        .byte   $66,$24,$D4,$DD,$73,$AB,$B2,$53 ; 9B80
        .byte   $DD,$4C,$B6,$AE,$73,$DD,$D0,$53 ; 9B88
        .byte   $DD,$6C,$07,$3D,$73,$DD,$F0,$33 ; 9B90
        .byte   $DD,$13,$0B,$CE,$B7,$EE,$1A,$85 ; 9B98
        .byte   $83,$72,$07,$17,$6D,$73,$DD,$4C ; 9BA0
        .byte   $C6,$9E,$73,$DD,$4F,$D4,$DD,$93 ; 9BA8
        .byte   $8B,$4E,$D7,$6D,$73,$DD,$ED,$06 ; 9BB0
        .byte   $F8,$E5,$DB,$85,$53,$AF,$00,$00 ; 9BB8
        .byte   $00,$72,$8E,$00,$00,$00,$00,$00 ; 9BC0
        .byte   $72,$8E,$00,$00,$00,$00,$00,$72 ; 9BC8
        .byte   $8E,$00,$F1,$00,$00,$00,$50,$FC ; 9BD0
        .byte   $F9,$FC,$12,$F2,$DB,$29,$05,$05 ; 9BD8
        .byte   $F2,$0D,$02,$CC,$33,$F6,$FB,$01 ; 9BE0
        .byte   $DB,$71,$63,$F2,$0E,$DC,$32,$E4 ; 9BE8
        .byte   $0F,$6B,$51,$45,$F0,$10,$DA,$32 ; 9BF0
        .byte   $E4,$11,$69,$4D,$65,$BE,$FD,$45 ; 9BF8
        .byte   $BE,$20,$0B,$35,$C6,$6A,$2A,$96 ; 9C00
        .byte   $5C,$89,$93,$71,$77,$A0,$5C,$89 ; 9C08
        .byte   $9B,$60,$20,$5C,$89,$8C,$6D,$CA ; 9C10
        .byte   $08,$28,$F8,$24,$76,$96,$5C,$89 ; 9C18
        .byte   $93,$71,$B7,$60,$5C,$89,$9B,$60 ; 9C20
        .byte   $B1,$4D,$22,$5C,$89,$C3,$08,$28 ; 9C28
        .byte   $28,$5C,$89,$05,$56,$4D,$E8,$78 ; 9C30
        .byte   $13,$5C,$89,$A0,$54,$27,$5C,$89 ; 9C38
        .byte   $A0,$56,$51,$30,$89,$43,$46,$07 ; 9C40
        .byte   $78,$95,$69,$AA,$3F,$A9,$EC,$84 ; 9C48
        .byte   $BD,$46,$E8,$AD,$5C,$84,$73,$28 ; 9C50
        .byte   $DB,$0A,$0B,$F3,$49,$13,$A8,$71 ; 9C58
        .byte   $31,$7C,$60,$7C,$AC,$64,$BF,$B5 ; 9C60
        .byte   $70,$34,$46,$1E,$84,$BF,$DD,$53 ; 9C68
        .byte   $DD,$4C,$E6,$76,$71,$B7,$68,$BB ; 9C70
        .byte   $B5,$72,$B2,$57,$8D,$88,$BB,$50 ; 9C78
        .byte   $DB,$0A,$63,$F8,$42,$7D,$81,$60 ; 9C80
        .byte   $BD,$E2,$67,$97,$22,$47,$82,$C2 ; 9C88
        .byte   $20,$00,$00,$2F,$67,$0B,$8D,$91 ; 9C90
        .byte   $DE,$C9,$1D,$DD,$46,$DA,$76,$9F ; 9C98
        .byte   $00,$00,$00,$00,$A1,$B0,$AF,$00 ; 9CA0
        .byte   $61,$B0,$B0,$30,$A0,$B0,$B0,$0F ; 9CA8
        .byte   $00,$01,$B0,$30,$A0,$B0,$B0,$1F ; 9CB0
        .byte   $71,$B0,$B0,$2F,$A1,$B0,$AF,$00 ; 9CB8
        .byte   $00,$00,$00,$00,$A1,$B0,$AF,$00 ; 9CC0
        .byte   $61,$B0,$B0,$30,$A0,$B0,$B0,$0F ; 9CC8
        .byte   $00,$01,$B0,$30,$A0,$B0,$B0,$1F ; 9CD0
        .byte   $71,$B0,$B0,$2F,$A1,$B0,$AF,$BE ; 9CD8
        .byte   $43,$07,$96,$63,$02,$BB,$43,$09 ; 9CE0
        .byte   $94,$63,$07,$C3,$06,$21,$B1,$65 ; 9CE8
        .byte   $45,$B6,$00,$40,$EB,$18,$DB,$12 ; 9CF0
        .byte   $EE,$10,$F0,$11,$07,$E8,$13,$F0 ; 9CF8
blank_2:.byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 9D00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 9D08
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 9D10
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 9D18
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 9D20
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 9D28
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 9D30
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 9D38
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 9D40
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 9D48
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 9D50
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 9D58
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 9D60
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 9D68
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 9D70
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 9D78
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 9D80
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 9D88
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 9D90
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 9D98
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 9DA0
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 9DA8
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 9DB0
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 9DB8
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 9DC0
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 9DC8
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 9DD0
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 9DD8
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 9DE0
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 9DE8
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 9DF0
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 9DF8
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 9E00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 9E08
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 9E10
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 9E18
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 9E20
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 9E28
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 9E30
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 9E38
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 9E40
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 9E48
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 9E50
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 9E58
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 9E60
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 9E68
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 9E70
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 9E78
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 9E80
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 9E88
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 9E90
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 9E98
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 9EA0
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 9EA8
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 9EB0
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 9EB8
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 9EC0
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 9EC8
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 9ED0
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 9ED8
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 9EE0
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 9EE8
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 9EF0
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 9EF8
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 9F00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 9F08
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 9F10
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 9F18
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 9F20
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 9F28
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 9F30
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 9F38
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 9F40
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 9F48
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 9F50
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 9F58
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 9F60
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 9F68
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 9F70
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 9F78
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 9F80
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 9F88
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 9F90
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 9F98
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 9FA0
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 9FA8
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 9FB0
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 9FB8
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 9FC0
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 9FC8
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 9FD0
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 9FD8
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 9FE0
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 9FE8
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 9FF0
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 9FF8
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; A000
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; A008
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; A010
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; A018
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; A020
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; A028
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; A030
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; A038
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; A040
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; A048
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; A050
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; A058
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; A060
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; A068
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; A070
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; A078
LA080:  .byte   $88                             ; A080
LA081:  .byte   $A0,$45,$A1,$02,$A2,$BF,$A2,$03 ; A081
        .byte   $02,$10,$05,$88,$62,$79,$51,$59 ; A089
        .byte   $51,$78,$60,$15,$1F,$88,$22,$48 ; A091
        .byte   $62,$48,$52,$58,$50,$15,$2F,$88 ; A099
        .byte   $16,$94,$16,$94,$16,$14,$16,$15 ; A0A1
        .byte   $3F,$00,$22,$AA,$AA,$AA,$AA,$AA ; A0A9
        .byte   $AA,$35,$01,$55,$11,$AA,$AA,$AA ; A0B1
        .byte   $AA,$AA,$AA,$15,$3F,$D5,$D5,$AA ; A0B9
        .byte   $AA,$AA,$AA,$AA,$AA,$15,$0F,$04 ; A0C1
        .byte   $03,$03,$14,$FF,$FF,$FF,$FC,$F0 ; A0C9
        .byte   $03,$0F,$FF,$35,$3B,$FC,$C0,$03 ; A0D1
        .byte   $3E,$F6,$F4,$F4,$FA,$47,$AB,$3F ; A0D9
        .byte   $FF,$AF,$AB,$AB,$AB,$1F,$1F,$47 ; A0E1
        .byte   $0B,$C3,$F0,$FC,$FF,$FF,$FF,$FF ; A0E9
        .byte   $FF,$37,$0B,$AA,$AA,$AA,$AA,$AA ; A0F1
        .byte   $AA,$AA,$AA,$3B,$05,$FA,$EA,$EA ; A0F9
        .byte   $EA,$AA,$6A,$4A,$41,$47,$1B,$9F ; A101
        .byte   $AF,$BF,$BF,$BF,$FF,$FF,$00,$47 ; A109
        .byte   $3B,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; A111
        .byte   $00,$37,$FB,$09,$A9,$32,$CC,$33 ; A119
        .byte   $CC,$33,$CC,$7B,$85,$A3,$AB,$A9 ; A121
        .byte   $44,$11,$44,$11,$44,$57,$04,$00 ; A129
        .byte   $AA,$33,$CC,$33,$CC,$33,$CC,$4B ; A131
        .byte   $C5,$00,$AA,$33,$CC,$33,$CC,$33 ; A139
        .byte   $CC,$EB,$A5,$00,$03,$02,$10,$05 ; A141
        .byte   $88,$62,$78,$52,$75,$75,$79,$61 ; A149
        .byte   $15,$0F,$88,$22,$88,$22,$48,$62 ; A151
        .byte   $58,$50,$15,$0F,$88,$16,$94,$16 ; A159
        .byte   $94,$16,$14,$16,$15,$3F,$00,$22 ; A161
        .byte   $AA,$AA,$AA,$AA,$AA,$AA,$35,$31 ; A169
        .byte   $55,$5D,$AA,$AA,$AA,$AA,$AA,$AA ; A171
        .byte   $15,$0F,$D5,$75,$AA,$AA,$AA,$AA ; A179
        .byte   $AA,$AA,$15,$0F,$04,$03,$03,$14 ; A181
        .byte   $FF,$FF,$FF,$FC,$F0,$03,$0F,$FF ; A189
        .byte   $35,$0B,$FC,$C0,$03,$3F,$FF,$FF ; A191
        .byte   $FD,$FD,$47,$3B,$3F,$FF,$FF,$EA ; A199
        .byte   $6A,$6A,$2A,$8A,$47,$3B,$C3,$F0 ; A1A1
        .byte   $FC,$FF,$BF,$BF,$BF,$FF,$37,$3B ; A1A9
        .byte   $AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA ; A1B1
        .byte   $3B,$35,$FE,$FA,$FA,$EA,$DA,$DA ; A1B9
        .byte   $4A,$62,$47,$3B,$A1,$A5,$A7,$AB ; A1C1
        .byte   $AB,$AF,$AF,$80,$47,$3B,$FF,$FF ; A1C9
        .byte   $FF,$FF,$FF,$FF,$FF,$00,$37,$0B ; A1D1
        .byte   $09,$A9,$31,$CC,$33,$CC,$33,$CC ; A1D9
        .byte   $7B,$B5,$A8,$AB,$AB,$A8,$11,$44 ; A1E1
        .byte   $11,$44,$57,$A4,$40,$6A,$33,$CC ; A1E9
        .byte   $33,$CC,$33,$CC,$4B,$05,$00,$AA ; A1F1
        .byte   $33,$CC,$33,$CC,$33,$CC,$EB,$95 ; A1F9
        .byte   $00,$03,$02,$10,$05,$88,$62,$78 ; A201
        .byte   $52,$58,$F2,$D5,$65,$15,$3F,$88 ; A209
        .byte   $22,$88,$22,$88,$22,$48,$60,$15 ; A211
        .byte   $1F,$88,$16,$94,$16,$94,$16,$14 ; A219
        .byte   $16,$15,$3F,$03,$22,$AA,$AA,$AA ; A221
        .byte   $AA,$AA,$AA,$35,$01,$50,$5D,$AA ; A229
        .byte   $AA,$AA,$AA,$AA,$AA,$15,$4F,$15 ; A231
        .byte   $75,$AA,$AA,$AA,$AA,$AA,$AA,$15 ; A239
        .byte   $8F,$04,$03,$03,$14,$FF,$FF,$FF ; A241
        .byte   $FC,$F0,$03,$0F,$FF,$35,$3B,$FC ; A249
        .byte   $C0,$03,$3F,$FF,$FF,$FF,$FF,$47 ; A251
        .byte   $FB,$3F,$FF,$FF,$FF,$FE,$F6,$F6 ; A259
        .byte   $D2,$47,$3B,$C3,$F0,$FC,$FF,$BF ; A261
        .byte   $AF,$AF,$AB,$37,$3B,$AA,$AA,$AA ; A269
        .byte   $AA,$AA,$AA,$AA,$2A,$3B,$35,$FF ; A271
        .byte   $FF,$FF,$FE,$FE,$F6,$F6,$D2,$47 ; A279
        .byte   $3B,$D0,$A8,$AA,$AA,$AA,$AA,$AA ; A281
        .byte   $A8,$47,$6B,$AB,$07,$17,$9F,$9F ; A289
        .byte   $FF,$FF,$00,$47,$0B,$02,$AA,$33 ; A291
        .byte   $CC,$33,$CC,$33,$CC,$7B,$35,$F0 ; A299
        .byte   $E8,$2A,$6A,$1A,$44,$11,$44,$57 ; A2A1
        .byte   $0B,$A8,$15,$13,$4C,$33,$CC,$33 ; A2A9
        .byte   $CC,$47,$05,$00,$AA,$33,$CC,$33 ; A2B1
        .byte   $CC,$33,$CC,$EB,$25,$00,$03,$02 ; A2B9
        .byte   $10,$05,$88,$62,$78,$52,$58,$52 ; A2C1
        .byte   $78,$42,$15,$BF,$88,$22,$88,$22 ; A2C9
        .byte   $80,$20,$88,$20,$15,$6F,$88,$16 ; A2D1
        .byte   $94,$16,$94,$16,$14,$16,$15,$AF ; A2D9
        .byte   $00,$22,$AB,$BF,$AA,$AA,$AA,$AA ; A2E1
        .byte   $35,$C1,$00,$55,$5A,$6A,$AA,$AA ; A2E9
        .byte   $AA,$AA,$15,$6F,$35,$75,$AA,$AA ; A2F1
        .byte   $AA,$AA,$AA,$AA,$15,$3F,$05,$03 ; A2F9
        .byte   $03,$14,$FF,$FF,$FF,$FC,$F0,$03 ; A301
        .byte   $0F,$FF,$35,$8B,$FC,$C0,$03,$3F ; A309
        .byte   $FF,$FF,$FF,$FF,$47,$0B,$3F,$FF ; A311
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$47,$0B ; A319
        .byte   $C3,$F0,$FC,$FF,$FF,$FF,$FF,$FF ; A321
        .byte   $37,$0B,$F0,$FF,$3F,$0F,$C0,$F0 ; A329
        .byte   $FC,$FF,$5E,$EB,$AA,$AA,$AA,$AA ; A331
        .byte   $AA,$AA,$AA,$0A,$3B,$85,$FF,$FF ; A339
        .byte   $FF,$FF,$FF,$FF,$FF,$FB,$47,$0B ; A341
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$5A ; A349
        .byte   $47,$1B,$FF,$FF,$FF,$FF,$FF,$FF ; A351
        .byte   $FF,$A5,$47,$0B,$FF,$FF,$FF,$FF ; A359
        .byte   $FF,$FF,$FF,$E0,$47,$0B,$02,$AA ; A361
        .byte   $33,$CC,$33,$CC,$33,$CC,$7B,$F5 ; A369
        .byte   $EB,$EA,$EA,$6B,$1B,$44,$11,$44 ; A371
        .byte   $57,$3B,$FA,$2A,$2A,$FA,$FA,$44 ; A379
        .byte   $11,$44,$57,$34,$5A,$54,$54,$5A ; A381
        .byte   $5A,$CC,$33,$CC,$74,$25,$94,$56 ; A389
        .byte   $57,$94,$93,$CC,$33,$CC,$7B,$35 ; A391
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; A399
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; A3A1
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; A3A9
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; A3B1
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; A3B9
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; A3C1
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; A3C9
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; A3D1
        .byte   $00,$00,$00,$00,$00,$00,$00     ; A3D9
LA3E0:  .byte   $F6                             ; A3E0
LA3E1:  .byte   $A3,$F6,$A5,$F6,$A7,$F6,$A9,$F6 ; A3E1
        .byte   $AB,$F6,$AD,$F6,$AF,$F6,$B1,$F6 ; A3E9
        .byte   $B3,$F6,$B5,$F6                 ; A3F1
; ----------------------------------------------------------------------------
        .byte   $B7                             ; A3F5
sprites_bonus_jagged:
        .byte   $00,$08,$00,$80,$08,$00,$C0,$1C ; A3F6
        .byte   $00,$70,$1C,$03,$3C,$3E,$0E,$1F ; A3FE
        .byte   $3E,$7C,$0F,$FF,$F8,$07,$FF,$F0 ; A406
        .byte   $07,$FF,$E0,$0F,$FF,$F0,$3F,$FF ; A40E
        .byte   $FC,$FF,$FF,$FF,$3F,$FF,$FC,$0F ; A416
        .byte   $FF,$F0,$07,$FF,$F8,$0F,$FF,$FC ; A41E
        .byte   $1F,$FF,$FE,$3C,$F9,$C0,$60,$70 ; A426
        .byte   $C0,$00,$20,$40,$00,$00,$00,$47 ; A42E
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; A436
        .byte   $00,$00,$08,$00,$18,$1C,$00,$0E ; A43E
        .byte   $3E,$38,$07,$FF,$F0,$03,$FF,$E0 ; A446
        .byte   $01,$FF,$C0,$03,$FF,$E0,$07,$FF ; A44E
        .byte   $F0,$0F,$FF,$F8,$07,$FF,$F0,$03 ; A456
        .byte   $FF,$E0,$03,$FF,$C0,$06,$7C,$60 ; A45E
        .byte   $0C,$38,$30,$00,$10,$00,$00,$00 ; A466
        .byte   $00,$00,$00,$00,$00,$00,$00,$48 ; A46E
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; A476
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; A47E
        .byte   $08,$00,$00,$1C,$00,$02,$3E,$40 ; A486
        .byte   $01,$FF,$80,$00,$FF,$00,$01,$FF ; A48E
        .byte   $80,$03,$FF,$C0,$01,$FF,$80,$00 ; A496
        .byte   $FF,$00,$01,$3E,$80,$00,$1C,$00 ; A49E
        .byte   $00,$08,$00,$00,$00,$00,$00,$00 ; A4A6
        .byte   $00,$00,$00,$00,$00,$00,$00,$42 ; A4AE
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; A4B6
        .byte   $00,$00,$08,$00,$18,$1C,$00,$0E ; A4BE
        .byte   $3E,$38,$07,$FF,$F0,$03,$FF,$E0 ; A4C6
        .byte   $01,$FF,$C0,$03,$FF,$E0,$07,$FF ; A4CE
        .byte   $F0,$0F,$FF,$F8,$07,$FF,$F0,$03 ; A4D6
        .byte   $FF,$E0,$03,$FF,$C0,$06,$7C,$C0 ; A4DE
        .byte   $0C,$38,$60,$00,$10,$20,$00,$00 ; A4E6
        .byte   $00,$00,$00,$00,$00,$00,$00,$48 ; A4EE
        .byte   $00,$08,$00,$80,$08,$00,$C0,$1C ; A4F6
        .byte   $00,$70,$1C,$03,$3C,$3E,$0E,$1F ; A4FE
        .byte   $3E,$7C,$0F,$FF,$F8,$07,$FF,$F0 ; A506
        .byte   $07                             ; A50E
LA50F:  .byte   $FF,$E0,$0F,$FF,$F0,$3F,$FF,$FC ; A50F
        .byte   $FF,$FF,$FF,$3F,$FF,$FC,$0F,$FF ; A517
        .byte   $F0,$07,$FF,$F8,$0F,$FF,$FC,$1F ; A51F
        .byte   $FF,$FE,$3C,$F9,$C0,$60,$70,$C0 ; A527
        .byte   $00,$20,$40,$00,$00,$00,$47     ; A52F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; A536
        .byte   $00,$00,$08,$00,$18,$1C,$00,$0E ; A53E
        .byte   $3E,$38,$07,$FF,$F0,$03,$FF,$E0 ; A546
        .byte   $01,$FF,$C0,$03,$FF,$E0,$07,$FF ; A54E
        .byte   $F0,$0F,$FF,$F8,$07,$FF,$F0,$03 ; A556
        .byte   $FF,$E0,$03,$FF,$C0,$06,$7C,$C0 ; A55E
        .byte   $0C,$38,$60,$00,$10,$20,$00,$00 ; A566
        .byte   $00,$00,$00,$00,$00,$00,$00,$48 ; A56E
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; A576
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; A57E
        .byte   $08,$00,$00,$1C,$00,$02,$3E,$40 ; A586
        .byte   $01,$FF,$80,$00,$FF,$00,$01,$FF ; A58E
        .byte   $80,$03,$FF,$C0,$01,$FF,$80,$00 ; A596
        .byte   $FF,$00,$01,$3E,$80,$00,$1C,$00 ; A59E
        .byte   $00,$08,$00,$00,$00,$00,$00,$00 ; A5A6
        .byte   $00,$00,$00,$00,$00,$00,$00,$42 ; A5AE
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; A5B6
        .byte   $00,$00,$08,$00,$18,$1C,$00,$0E ; A5BE
        .byte   $3E,$38,$07,$FF,$F0,$03,$FF,$E0 ; A5C6
        .byte   $01,$FF,$C0,$03,$FF,$E0,$07,$FF ; A5CE
        .byte   $F0,$0F,$FF,$F8,$07,$FF,$F0,$03 ; A5D6
        .byte   $FF,$E0,$03,$FF,$C0,$06,$7C,$C0 ; A5DE
        .byte   $0C,$38,$60,$00,$10,$20,$00,$00 ; A5E6
        .byte   $00,$00,$00,$00,$00,$00,$00,$48 ; A5EE
sprites_bonus_splash:
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; A5F6
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; A5FE
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; A606
        .byte   $00,$38,$00,$00,$7C,$00,$00,$7C ; A60E
        .byte   $00,$00,$7C,$00,$00,$7C,$00,$00 ; A616
        .byte   $38,$00,$00,$00,$00,$00,$00,$00 ; A61E
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; A626
        .byte   $00,$00,$00,$00,$00,$00,$00,$46 ; A62E
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; A636
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; A63E
        .byte   $00,$00,$00,$38,$00,$00,$7C,$00 ; A646
        .byte   $00,$FE,$00,$00,$FE,$00,$00,$FE ; A64E
        .byte   $00,$00,$FE,$00,$00,$FE,$00,$00 ; A656
        .byte   $7C,$00,$00,$38,$00,$00,$00,$00 ; A65E
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; A666
        .byte   $00,$00,$00,$00,$00,$00,$00,$46 ; A66E
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; A676
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; A67E
        .byte   $38,$00,$00,$7C,$00,$00,$FE,$00 ; A686
        .byte   $00,$FE,$00,$01,$FF,$00,$01,$FF ; A68E
        .byte   $00,$01,$FF,$00,$00,$FE,$00,$00 ; A696
        .byte   $FE,$00,$00,$7C,$00,$00,$38,$00 ; A69E
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; A6A6
        .byte   $00,$00,$00,$00,$00,$00,$00,$4E ; A6AE
        .byte   $00,$00,$00,$00,$00,$00,$00,$18 ; A6B6
        .byte   $00,$00,$7E,$00,$00,$FF,$00,$01 ; A6BE
        .byte   $FF,$80,$01,$FF,$80,$03,$FF,$C0 ; A6C6
        .byte   $03,$FF,$C0,$07,$FF,$E0,$07,$FF ; A6CE
        .byte   $E0,$07,$FF,$E0,$03,$FF,$E0,$03 ; A6D6
        .byte   $FF,$C0,$01,$FF,$C0,$01,$FF,$80 ; A6DE
        .byte   $00,$FF,$00,$00,$7E,$00,$00,$18 ; A6E6
        .byte   $00,$00,$00,$00,$00,$00,$00,$4E ; A6EE
        .byte   $00,$08,$06,$00,$3C,$8E,$00,$FF ; A6F6
        .byte   $18,$05,$FF,$A0,$C3,$FF,$C0,$E7 ; A6FE
        .byte   $FF,$E0,$77,$FF,$E0,$0F,$FF,$F0 ; A706
        .byte   $0F,$FF,$F0,$1F,$FF,$F8,$1F,$FF ; A70E
        .byte   $F8,$1F,$FF,$F9,$1F,$FF,$F8,$1F ; A716
        .byte   $FF,$F0,$6F,$FF,$F0,$C7,$FF,$E0 ; A71E
        .byte   $C7,$FF,$E0,$03,$FF,$C0,$09,$FF ; A726
        .byte   $E0,$00,$FF,$38,$00,$3C,$18,$43 ; A72E
        .byte   $00,$00,$00,$00,$00,$00,$00,$18 ; A736
        .byte   $00,$00,$7E,$00,$00,$FF,$00,$01 ; A73E
        .byte   $FF,$80,$01,$FF,$80,$03,$FF,$C0 ; A746
        .byte   $03,$FF,$C0,$07,$FF,$E0,$07,$FF ; A74E
        .byte   $E0,$07,$FF,$E0,$03,$FF,$E0,$03 ; A756
        .byte   $FF,$C0,$01,$FF,$C0,$01,$FF,$80 ; A75E
        .byte   $00,$FF,$00,$00,$7E,$00,$00,$18 ; A766
        .byte   $00,$00,$00,$00,$00,$00,$00,$4E ; A76E
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; A776
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; A77E
        .byte   $38,$00,$00,$7C,$00,$00,$FE,$00 ; A786
        .byte   $00,$FE,$00,$01,$FF,$00,$01,$FF ; A78E
        .byte   $00,$01,$FF,$00,$00,$FE,$00,$00 ; A796
        .byte   $FE,$00,$00,$7C,$00,$00,$38,$00 ; A79E
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; A7A6
        .byte   $00,$00,$00,$00,$00,$00,$00,$4E ; A7AE
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; A7B6
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; A7BE
        .byte   $00,$00,$00,$00,$00,$00,$38,$00 ; A7C6
        .byte   $00,$7C,$00,$00,$FE,$00,$00,$FE ; A7CE
        .byte   $00,$00,$FE,$00,$00,$FE,$00,$00 ; A7D6
        .byte   $7C,$00,$00,$38,$00,$00,$00,$00 ; A7DE
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; A7E6
        .byte   $00,$00,$00,$00,$00,$00,$00,$46 ; A7EE
sprites_bonus_atom:
        .byte   $00,$00,$00,$00,$00,$00,$2A,$00 ; A7F6
        .byte   $54,$22,$81,$44,$20,$A5,$04,$23 ; A7FE
        .byte   $28,$04,$28,$5A,$14,$08,$42,$10 ; A806
        .byte   $0A,$42,$90,$02,$00,$8C,$36,$81 ; A80E
        .byte   $A0,$04,$81,$20,$14,$A5,$28,$10 ; A816
        .byte   $28,$08,$10,$5A,$08,$11,$42,$88 ; A81E
        .byte   $15,$0C,$A8,$00,$00,$00,$00,$00 ; A826
        .byte   $00,$00,$00,$00,$00,$00,$00,$C5 ; A82E
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; A836
        .byte   $00,$00,$03,$00,$00,$00,$00,$00 ; A83E
        .byte   $00,$00,$00,$00,$00,$AA,$AA,$AA ; A846
        .byte   $AA,$AA,$AA,$55,$55,$55,$55,$55 ; A84E
        .byte   $55,$00,$00,$00,$00,$00,$00,$00 ; A856
        .byte   $00,$30,$00,$00,$00,$03,$00,$00 ; A85E
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; A866
        .byte   $00,$00,$00,$00,$00,$00,$00,$C5 ; A86E
        .byte   $00,$00,$00,$00,$0C,$00,$15,$00 ; A876
        .byte   $A8,$11,$42,$88,$10,$5A,$08,$10 ; A87E
        .byte   $28,$08,$14,$A5,$28,$04,$81,$20 ; A886
        .byte   $06,$81,$A0,$02,$00,$83,$0A,$42 ; A88E
        .byte   $90,$08,$42,$10,$28,$5A,$14,$20 ; A896
        .byte   $28,$04,$2C,$A5,$04,$22,$81,$44 ; A89E
        .byte   $2A,$00,$54,$00,$00,$00,$00,$03 ; A8A6
        .byte   $00,$00,$00,$00,$00,$00,$00,$C5 ; A8AE
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; A8B6
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; A8BE
        .byte   $00,$00,$00,$00,$00,$55,$55,$55 ; A8C6
        .byte   $55,$5D,$55,$AA,$AA,$AA,$AA,$AA ; A8CE
        .byte   $AA,$00,$00,$00,$00,$00,$30,$03 ; A8D6
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; A8DE
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; A8E6
        .byte   $00,$00,$00,$00,$00,$00,$00,$C5 ; A8EE
        .byte   $00,$00,$00,$00,$00,$00,$2A,$00 ; A8F6
        .byte   $54,$22,$81,$44,$20,$A5,$04,$23 ; A8FE
        .byte   $28,$04,$28,$5A,$14,$08,$42,$10 ; A906
        .byte   $0A,$42,$90,$02,$00,$8C,$36,$81 ; A90E
        .byte   $A0,$04,$81,$20,$14,$A5,$28,$10 ; A916
        .byte   $28,$08,$10,$5A,$08,$11,$42,$88 ; A91E
        .byte   $15,$0C,$A8,$00,$00,$00,$00,$00 ; A926
        .byte   $00,$00,$00,$00,$00,$00,$00,$C5 ; A92E
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; A936
        .byte   $00,$00,$03,$00,$00,$00,$00,$00 ; A93E
        .byte   $00,$00,$00,$00,$00,$AA,$AA,$AA ; A946
        .byte   $AA,$AA,$AA,$55,$55,$55,$55,$55 ; A94E
        .byte   $55,$00,$00,$00,$00,$00,$00,$00 ; A956
        .byte   $00,$30,$00,$00,$00,$03,$00,$00 ; A95E
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; A966
        .byte   $00,$00,$00,$00,$00,$00,$00,$C5 ; A96E
        .byte   $00,$00,$00,$00,$0C,$00,$15,$00 ; A976
        .byte   $A8,$11,$42,$88,$10,$5A,$08,$10 ; A97E
        .byte   $28,$08,$14,$A5,$28,$04,$81,$20 ; A986
        .byte   $06,$81,$A0,$02,$00,$83,$0A,$42 ; A98E
        .byte   $90,$08,$42,$10,$28,$5A,$14,$20 ; A996
        .byte   $28,$04,$2C,$A5,$04,$22,$81,$44 ; A99E
        .byte   $2A,$00,$54,$00,$00,$00,$00,$03 ; A9A6
        .byte   $00,$00,$00,$00,$00,$00,$00,$C5 ; A9AE
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; A9B6
        .byte   $00,$00,$0C,$00,$00,$00,$00,$00 ; A9BE
        .byte   $00,$00,$00,$00,$00,$55,$55,$55 ; A9C6
        .byte   $55,$55,$55,$AA,$AA,$AA,$AA,$AA ; A9CE
        .byte   $AA,$00,$00,$00,$00,$00,$00,$03 ; A9D6
        .byte   $00,$00,$00,$00,$00,$00,$00,$30 ; A9DE
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; A9E6
        .byte   $00,$00,$00,$00,$00,$00,$00,$C5 ; A9EE
sprites_bonus_star:
        .byte   $00,$08,$00,$00,$08,$00,$00,$1C ; A9F6
        .byte   $00,$00,$1C,$00,$00,$3E,$00,$00 ; A9FE
        .byte   $3E,$00,$00,$7F,$00,$7F,$FF,$FF ; AA06
        .byte   $3F,$F7,$FE,$1F,$F7,$FC,$0F,$C1 ; AA0E
        .byte   $F8,$07,$EB,$F0,$03,$DD,$E0,$03 ; AA16
        .byte   $FF,$E0,$07,$FF,$F0,$07,$FF,$F0 ; AA1E
        .byte   $0F,$F7,$F8,$0F,$C1,$F8,$1F,$00 ; AA26
        .byte   $7C,$1C,$00,$1C,$30,$00,$06,$42 ; AA2E
        .byte   $00,$08,$00,$00,$08,$00,$00,$1C ; AA36
        .byte   $00,$00,$1C,$00,$00,$3E,$00,$00 ; AA3E
        .byte   $3E,$00,$00,$7F,$00,$7F,$FF,$FF ; AA46
        .byte   $3F,$F7,$FE,$1F,$E3,$FC,$0F,$00 ; AA4E
        .byte   $78,$07,$80,$F0,$03,$C1,$E0,$03 ; AA56
        .byte   $8C,$E0,$07,$3E,$70,$07,$FF,$F0 ; AA5E
        .byte   $0F,$F7,$F8,$0F,$C1,$F8,$1F,$00 ; AA66
        .byte   $7C,$1C,$00,$1C,$30,$00,$06,$42 ; AA6E
        .byte   $00,$08,$00,$00,$08,$00,$00,$1C ; AA76
        .byte   $00,$00,$1C,$00,$00,$3E,$00,$00 ; AA7E
        .byte   $36,$00,$00,$77,$00,$7F,$E3,$FF ; AA86
        .byte   $3F,$C1,$FE,$1C,$00,$1C,$0E,$00 ; AA8E
        .byte   $38,$07,$00,$70,$03,$80,$E0,$03 ; AA96
        .byte   $00,$60,$06,$1C,$30,$06,$7F,$30 ; AA9E
        .byte   $0D,$F7,$D8,$0F,$C1,$F8,$1F,$00 ; AAA6
        .byte   $7C,$1C,$00,$1C,$30,$00,$06,$42 ; AAAE
        .byte   $00,$08,$00,$00,$08,$00,$00,$1C ; AAB6
        .byte   $00,$00,$1C,$00,$00,$3E,$00,$00 ; AABE
        .byte   $3E,$00,$00,$7F,$00,$7F,$FF,$FF ; AAC6
        .byte   $3F,$F7,$FE,$1F,$E3,$FC,$0F,$00 ; AACE
        .byte   $78,$07,$80,$F0,$03,$C1,$E0,$03 ; AAD6
        .byte   $8C,$E0,$07,$3E,$70,$07,$FF,$F0 ; AADE
        .byte   $0F,$F7,$F8,$0F,$C1,$F8,$1F,$00 ; AAE6
        .byte   $7C,$1C,$00,$1C,$30,$00,$06,$42 ; AAEE
        .byte   $00,$08,$00,$00,$08,$00,$00,$1C ; AAF6
        .byte   $00,$00,$1C,$00,$00,$3E,$00,$00 ; AAFE
        .byte   $3E,$00,$00,$7F,$00,$7F,$FF,$FF ; AB06
        .byte   $3F,$F7,$FE,$1F,$F7,$FC,$0F,$C1 ; AB0E
        .byte   $F8,$07,$EB,$F0,$03,$DD,$E0,$03 ; AB16
        .byte   $FF,$E0,$07,$FF,$F0,$07,$FF,$F0 ; AB1E
        .byte   $0F,$F7,$F8,$0F,$C1,$F8,$1F,$00 ; AB26
        .byte   $7C,$1C,$00,$1C,$30,$00,$06,$42 ; AB2E
        .byte   $00,$08,$00,$00,$08,$00,$00,$1C ; AB36
        .byte   $00,$00,$1C,$00,$00,$3E,$00,$00 ; AB3E
        .byte   $3E,$00,$00,$7F,$00,$7F,$FF,$FF ; AB46
        .byte   $3F,$FF,$FE,$1F,$FF,$FC,$0F,$FF ; AB4E
        .byte   $F8,$07,$FF,$F0,$03,$FF,$E0,$03 ; AB56
        .byte   $FF,$E0,$07,$FF,$F0,$07,$FF,$F0 ; AB5E
        .byte   $0F,$F7,$F8,$0F,$C1,$F8,$1F,$00 ; AB66
        .byte   $7C,$1C,$00,$1C,$30,$00,$06,$42 ; AB6E
        .byte   $00,$08,$00,$00,$08,$00,$00,$1C ; AB76
        .byte   $00,$00,$1C,$00,$00,$3E,$00,$00 ; AB7E
        .byte   $3E,$00,$00,$7F,$00,$7F,$FF,$FF ; AB86
        .byte   $3F,$FF,$FE,$1F,$FF,$FC,$0F,$FF ; AB8E
        .byte   $F8,$07,$FF,$F0,$03,$FF,$E0,$03 ; AB96
        .byte   $FF,$E0,$07,$FF,$F0,$07,$FF,$F0 ; AB9E
        .byte   $0F,$F7,$F8,$0F,$C1,$F8,$1F,$00 ; ABA6
        .byte   $7C,$1C,$00,$1C,$30,$00,$06,$42 ; ABAE
        .byte   $00,$08,$00,$00,$08,$00,$00,$1C ; ABB6
        .byte   $00,$00,$1C,$00,$00,$3E,$00,$00 ; ABBE
        .byte   $3E,$00,$00,$7F,$00,$7F,$FF,$FF ; ABC6
        .byte   $3F,$FF,$FE,$1F,$FF,$FC,$0F,$FF ; ABCE
        .byte   $F8,$07,$FF,$F0,$03,$FF,$E0,$03 ; ABD6
        .byte   $FF,$E0,$07,$FF,$F0,$07,$FF,$F0 ; ABDE
        .byte   $0F,$F7,$F8,$0F,$C1,$F8,$1F,$00 ; ABE6
        .byte   $7C,$1C,$00,$1C,$30,$00,$06,$42 ; ABEE
sprites_bonus_skull:
        .byte   $00,$38,$00,$30,$7C,$18,$30,$FE ; ABF6
        .byte   $18,$79,$FF,$3C,$7D,$FF,$7C,$0F ; ABFE
        .byte   $93,$E0,$07,$11,$C0,$03,$11,$80 ; AC06
        .byte   $03,$11,$80,$01,$39,$00,$01,$FF ; AC0E
        .byte   $00,$00,$D6,$00,$00,$C6,$00,$01 ; AC16
        .byte   $D7,$00,$03,$FF,$80,$37,$7D,$D8 ; AC1E
        .byte   $3E,$28,$F8,$2C,$54,$68,$0C,$7C ; AC26
        .byte   $60,$00,$38,$00,$00,$00,$00,$41 ; AC2E
        .byte   $00,$38,$00,$30,$7C,$18,$30,$FE ; AC36
        .byte   $18,$79,$FF,$3C,$7D,$FF,$7C,$0F ; AC3E
        .byte   $93,$E0,$07,$11,$C0,$03,$11,$80 ; AC46
        .byte   $03,$11,$80,$01,$39,$00,$01,$FF ; AC4E
        .byte   $00,$00,$D6,$00,$00,$C6,$00,$01 ; AC56
        .byte   $D7,$00,$03,$FF,$80,$37,$7D,$D8 ; AC5E
        .byte   $3E,$28,$F8,$2C,$54,$68,$0C,$7C ; AC66
        .byte   $60,$00,$38,$00,$00,$00,$00,$41 ; AC6E
        .byte   $00,$38,$00,$30,$7C,$18,$30,$FE ; AC76
        .byte   $18,$79,$FF,$3C,$7D,$FF,$7C,$0F ; AC7E
        .byte   $93,$E0,$07,$11,$C0,$03,$11,$80 ; AC86
        .byte   $03,$11,$80,$01,$39,$00,$01,$FF ; AC8E
        .byte   $00,$00,$D6,$00,$00,$C6,$00,$01 ; AC96
        .byte   $D7,$00,$03,$FF,$80,$37,$7D,$D8 ; AC9E
        .byte   $3E,$28,$F8,$2C,$54,$68,$0C,$7C ; ACA6
        .byte   $60,$00,$38,$00,$00,$00,$00,$41 ; ACAE
        .byte   $00,$38,$00,$30,$7C,$18,$30,$FE ; ACB6
        .byte   $18,$79,$FF,$3C,$7D,$FF,$7C,$0F ; ACBE
        .byte   $93,$E0,$07,$11,$C0,$03,$11,$80 ; ACC6
        .byte   $03,$11,$80,$01,$39,$00,$01,$FF ; ACCE
        .byte   $00,$00,$D6,$00,$00,$C6,$00,$01 ; ACD6
        .byte   $D7,$00,$03,$7D,$80,$37,$29,$D8 ; ACDE
        .byte   $3E,$00,$F8,$2C,$44,$68,$0C,$54 ; ACE6
        .byte   $60,$00,$7C,$00,$00,$38,$00,$41 ; ACEE
        .byte   $00,$38,$00,$30,$7C,$18,$30,$FE ; ACF6
        .byte   $18,$79,$FF,$3C,$7D,$FF,$7C,$0F ; ACFE
        .byte   $93,$E0,$07,$11,$C0,$03,$11,$80 ; AD06
        .byte   $03,$11,$80,$01,$39,$00,$01,$FF ; AD0E
        .byte   $00,$00,$D6,$00,$00,$C6,$00,$01 ; AD16
        .byte   $D7,$00,$03,$7D,$80,$37,$29,$D8 ; AD1E
        .byte   $3E,$00,$F8,$2C,$44,$68,$0C,$54 ; AD26
        .byte   $60,$00,$7C,$00,$00,$38,$00,$41 ; AD2E
        .byte   $00,$38,$00,$30,$7C,$18,$30,$FE ; AD36
        .byte   $18,$79,$FF,$3C,$7D,$FF,$7C,$0F ; AD3E
        .byte   $93,$E0,$07,$11,$C0,$03,$11,$80 ; AD46
        .byte   $03,$11,$80,$01,$39,$00,$01,$FF ; AD4E
        .byte   $00,$00,$D6,$00,$00,$C6,$00,$01 ; AD56
        .byte   $D7,$00,$03,$7D,$80,$37,$29,$D8 ; AD5E
        .byte   $3E,$00,$F8,$2C,$44,$68,$0C,$54 ; AD66
        .byte   $60,$00,$7C,$00,$00,$38,$00,$41 ; AD6E
        .byte   $00,$38,$00,$30,$7C,$18,$30,$FE ; AD76
        .byte   $18,$79,$FF,$3C,$7D,$FF,$7C,$0F ; AD7E
        .byte   $93,$E0,$07,$11,$C0,$03,$11,$80 ; AD86
        .byte   $03,$11,$80,$01,$39,$00,$01,$FF ; AD8E
        .byte   $00,$00,$D6,$00,$00,$C6,$00,$01 ; AD96
        .byte   $D7,$00,$03,$FF,$80,$37,$7D,$D8 ; AD9E
        .byte   $3E,$28,$F8,$2C,$54,$68,$0C,$7C ; ADA6
        .byte   $60,$00,$38,$00,$00,$00,$00,$41 ; ADAE
        .byte   $00,$38,$00,$30,$7C,$18,$30,$FE ; ADB6
        .byte   $18,$79,$FF,$3C,$7D,$FF,$7C,$0F ; ADBE
        .byte   $93,$E0,$07,$11,$C0,$03,$11,$80 ; ADC6
        .byte   $03,$11,$80,$01,$39,$00,$01,$FF ; ADCE
        .byte   $00,$00,$D6,$00,$00,$C6,$00,$01 ; ADD6
        .byte   $D7,$00,$03,$7D,$80,$37,$29,$D8 ; ADDE
        .byte   $3E,$00,$F8,$2C,$44,$68,$0C,$54 ; ADE6
        .byte   $60,$00,$7C,$00,$00,$38,$00,$41 ; ADEE
sprites_bonus_squiggle:
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; ADF6
        .byte   $00,$1F,$3F,$38,$07,$E7,$E0,$00 ; ADFE
        .byte   $00,$00,$03,$FF,$C0,$07,$FF,$E0 ; AE06
        .byte   $0F,$FF,$F0,$0F,$FF,$F0,$0F,$FF ; AE0E
        .byte   $F0,$0F,$FF,$F0,$0F,$FF,$F0,$0F ; AE16
        .byte   $FF,$F0,$0F,$FF,$F0,$07,$FD,$E0 ; AE1E
        .byte   $03,$FF,$C0,$00,$00,$00,$1F,$3F ; AE26
        .byte   $38,$07,$E7,$E0,$00,$00,$00,$41 ; AE2E
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; AE36
        .byte   $00,$1E,$7E,$78,$13,$F3,$F0,$00 ; AE3E
        .byte   $00,$00,$03,$FF,$C0,$07,$FF,$E0 ; AE46
        .byte   $0F,$FF,$F0,$0F,$7F,$F0,$0F,$FF ; AE4E
        .byte   $F0,$0F,$FF,$F0,$0F,$FF,$F0,$0F ; AE56
        .byte   $FF,$F0,$0F,$FF,$F0,$07,$FF,$E0 ; AE5E
        .byte   $03,$FF,$C0,$00,$00,$00,$1E,$7E ; AE66
        .byte   $78,$13,$F3,$F0,$00,$00,$00,$41 ; AE6E
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; AE76
        .byte   $00,$1C,$FC,$F8,$19,$F9,$F8,$00 ; AE7E
        .byte   $00,$00,$03,$FF,$C0,$07,$FF,$E0 ; AE86
        .byte   $0F,$FF,$F0,$0F,$FF,$F0,$0F,$FF ; AE8E
        .byte   $F0,$0F,$FF,$F0,$0F,$FF,$F0,$0F ; AE96
        .byte   $FF,$F0,$0F,$FB,$F0,$07,$FF,$E0 ; AE9E
        .byte   $03,$FF,$C0,$00,$00,$00,$1C,$FC ; AEA6
        .byte   $F8,$19,$F9,$F8,$00,$00,$00,$41 ; AEAE
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; AEB6
        .byte   $00,$19,$F9,$F8,$1C,$FC,$F8,$00 ; AEBE
        .byte   $00,$00,$03,$FF,$C0,$07,$FF,$E0 ; AEC6
        .byte   $0F,$FE,$F0,$0F,$FF,$F0,$0F,$FF ; AECE
        .byte   $F0,$0F,$FF,$F0,$0F,$FF,$F0,$0F ; AED6
        .byte   $FF,$F0,$0F,$FF,$F0,$07,$FF,$E0 ; AEDE
        .byte   $03,$FF,$C0,$00,$00,$00,$19,$F9 ; AEE6
        .byte   $F8,$1C,$FC,$F8,$00,$00,$00,$41 ; AEEE
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; AEF6
        .byte   $00,$13,$F3,$F0,$1E,$7E,$78,$00 ; AEFE
        .byte   $00,$00,$03,$FF,$C0,$07,$FF,$E0 ; AF06
        .byte   $0F,$FF,$F0,$0F,$FF,$F0,$0F,$FF ; AF0E
        .byte   $F0,$0F,$F7,$F0,$0F,$FF,$F0,$0F ; AF16
        .byte   $FF,$F0,$0F,$FF,$F0,$07,$FF,$E0 ; AF1E
        .byte   $03,$FF,$C0,$00,$00,$00,$13,$F3 ; AF26
        .byte   $F0,$1E,$7E,$78,$00,$00,$00,$41 ; AF2E
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; AF36
        .byte   $00,$07,$E7,$E0,$1F,$3F,$38,$00 ; AF3E
        .byte   $00,$00,$03,$FF,$C0,$07,$FF,$E0 ; AF46
        .byte   $0F,$FF,$F0,$0F,$FF,$F0,$0F,$FF ; AF4E
        .byte   $F0,$0F,$FF,$F0,$0F,$FF,$F0,$0F ; AF56
        .byte   $FF,$F0,$0F,$FF,$B0,$07,$FF,$E0 ; AF5E
        .byte   $03,$FF,$C0,$00,$00,$00,$07,$E7 ; AF66
        .byte   $E0,$1F,$3F,$38,$00,$00,$00,$41 ; AF6E
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; AF76
        .byte   $00,$0F,$CF,$C8,$1F,$9F,$98,$00 ; AF7E
        .byte   $00,$00,$03,$FF,$C0,$07,$FF,$E0 ; AF86
        .byte   $0F,$FF,$F0,$0F,$FF,$F0,$0F,$FF ; AF8E
        .byte   $F0,$0F,$FF,$F0,$0F,$FF,$F0,$0E ; AF96
        .byte   $FF,$F0,$0F,$FF,$F0,$07,$FF,$E0 ; AF9E
        .byte   $03,$FF,$C0,$00,$00,$00,$0F,$CF ; AFA6
        .byte   $C8,$1F,$9F,$98,$00,$00,$00,$41 ; AFAE
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; AFB6
        .byte   $00,$1F,$9F,$98,$0F,$CF,$C8,$00 ; AFBE
        .byte   $00,$00,$03,$FF,$C0,$07,$F7,$E0 ; AFC6
        .byte   $0F,$FF,$F0,$0F,$FF,$F0,$0F,$FF ; AFCE
        .byte   $F0,$0F,$FF,$F0,$0F,$FF,$F0,$0F ; AFD6
        .byte   $FF,$F0,$0F,$FF,$F0,$07,$FF,$E0 ; AFDE
        .byte   $03,$FF,$C0,$00,$00,$00,$1F,$9F ; AFE6
        .byte   $98,$0F,$CF,$C8,$00,$00,$00,$41 ; AFEE
sprites_bonus_sparkle:
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; AFF6
        .byte   $00,$00,$00,$02,$00,$00,$00,$00 ; AFFE
        .byte   $00,$00,$03,$FF,$C0,$07,$FF,$E0 ; B006
        .byte   $0F,$FF,$F0,$0F,$FF,$F0,$4F,$FF ; B00E
        .byte   $F0,$EF,$FF,$F0,$4F,$FF,$F0,$0F ; B016
        .byte   $FF,$F0,$0F,$FF,$F0,$07,$FF,$E0 ; B01E
        .byte   $03,$FF,$C0,$00,$00,$04,$01,$00 ; B026
        .byte   $0E,$00,$00,$04,$00,$00,$00,$41 ; B02E
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; B036
        .byte   $02,$10,$00,$07,$00,$00,$02,$00 ; B03E
        .byte   $00,$00,$03,$FF,$C0,$07,$FF,$E0 ; B046
        .byte   $0F,$FF,$F0,$0F,$FF,$F0,$0F,$FF ; B04E
        .byte   $F0,$4F,$FF,$F0,$0F,$FF,$F0,$0F ; B056
        .byte   $FF,$F0,$0F,$FF,$F0,$07,$FF,$E0 ; B05E
        .byte   $03,$FF,$C0,$01,$00,$00,$03,$80 ; B066
        .byte   $04,$01,$00,$00,$00,$00,$00,$41 ; B06E
        .byte   $00,$00,$00,$00,$00,$00,$10,$00 ; B076
        .byte   $00,$38,$00,$00,$10,$00,$00,$00 ; B07E
        .byte   $00,$00,$03,$FF,$C0,$07,$FF,$E0 ; B086
        .byte   $0F,$FF,$F0,$0F,$FF,$F0,$0F,$FF ; B08E
        .byte   $F0,$0F,$FF,$F0,$0F,$FF,$F0,$0F ; B096
        .byte   $FF,$F0,$0F,$FF,$F0,$07,$FF,$E0 ; B09E
        .byte   $03,$FF,$C0,$00,$00,$00,$01,$00 ; B0A6
        .byte   $00,$00,$08,$00,$00,$00,$00,$41 ; B0AE
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; B0B6
        .byte   $00,$10,$00,$00,$00,$00,$00,$00 ; B0BE
        .byte   $00,$00,$03,$FF,$C0,$07,$FF,$E0 ; B0C6
        .byte   $0F,$FF,$F0,$0F,$FF,$F0,$0F,$FF ; B0CE
        .byte   $F0,$0F,$FF,$F0,$0F,$FF,$F0,$0F ; B0D6
        .byte   $FF,$F0,$0F,$FF,$F0,$07,$FF,$E0 ; B0DE
        .byte   $03,$FF,$C0,$00,$00,$00,$00,$08 ; B0E6
        .byte   $00,$00,$1C,$00,$00,$08,$00,$41 ; B0EE
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; B0F6
        .byte   $00,$00,$20,$00,$00,$00,$00,$00 ; B0FE
        .byte   $00,$00,$03,$FF,$C0,$07,$FF,$E0 ; B106
        .byte   $0F,$FF,$F0,$0F,$FF,$F0,$0F,$FF ; B10E
        .byte   $F0,$0F,$FF,$F0,$0F,$FF,$F0,$0F ; B116
        .byte   $FF,$F0,$0F,$FF,$F0,$07,$FF,$E0 ; B11E
        .byte   $03,$FF,$C0,$00,$00,$00,$00,$00 ; B126
        .byte   $00,$08,$08,$00,$00,$00,$00,$41 ; B12E
        .byte   $00,$00,$00,$00,$00,$80,$00,$20 ; B136
        .byte   $00,$00,$70,$00,$00,$20,$00,$00 ; B13E
        .byte   $00,$00,$03,$FF,$C0,$07,$FF,$E0 ; B146
        .byte   $0F,$FF,$F0,$0F,$FF,$F0,$0F,$FF ; B14E
        .byte   $F0,$0F,$FF,$F0,$0F,$FF,$F0,$0F ; B156
        .byte   $FF,$F0,$0F,$FF,$F0,$07,$FF,$E0 ; B15E
        .byte   $03,$FF,$C0,$00,$00,$00,$08,$00 ; B166
        .byte   $00,$1C,$00,$80,$08,$00,$00,$41 ; B16E
        .byte   $00,$00,$80,$00,$01,$C0,$00,$00 ; B176
        .byte   $80,$00,$20,$00,$00,$00,$00,$00 ; B17E
        .byte   $00,$00,$03,$FF,$C0,$07,$FF,$E0 ; B186
        .byte   $0F,$FF,$F0,$0F,$FF,$F0,$0F,$FF ; B18E
        .byte   $F0,$0F,$FF,$F0,$0F,$FF,$F0,$0F ; B196
        .byte   $FF,$F0,$0F,$FF,$F0,$07,$FF,$E0 ; B19E
        .byte   $03,$FF,$C0,$00,$00,$00,$00,$00 ; B1A6
        .byte   $80,$08,$01,$C0,$00,$00,$80,$41 ; B1AE
        .byte   $00,$00,$00,$00,$00,$80,$00,$00 ; B1B6
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; B1BE
        .byte   $00,$00,$03,$FF,$C0,$07,$FF,$E0 ; B1C6
        .byte   $0F,$FF,$F0,$0F,$FF,$F0,$0F,$FF ; B1CE
        .byte   $F0,$4F,$FF,$F0,$0F,$FF,$F0,$0F ; B1D6
        .byte   $FF,$F0,$0F,$FF,$F0,$07,$FF,$E0 ; B1DE
        .byte   $03,$FF,$C0,$00,$00,$00,$00,$00 ; B1E6
        .byte   $04,$00,$00,$80,$00,$00,$00,$41 ; B1EE
sprites_bonus_spikey:
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; B1F6
        .byte   $00,$00,$00,$00,$00,$C3,$00,$00 ; B1FE
        .byte   $C3,$00,$00,$C3,$00,$02,$AA,$80 ; B206
        .byte   $02,$AA,$80,$02,$AA,$BF,$02,$AA ; B20E
        .byte   $BF,$FE,$AA,$80,$FE,$AA,$80,$02 ; B216
        .byte   $AA,$BF,$02,$AA,$BF,$02,$AA,$80 ; B21E
        .byte   $00,$3C,$00,$00,$3C,$00,$00,$3C ; B226
        .byte   $00,$00,$00,$00,$00,$00,$00,$C1 ; B22E
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; B236
        .byte   $00,$00,$00,$00,$00,$C3,$00,$00 ; B23E
        .byte   $C3,$00,$00,$C3,$00,$02,$AA,$80 ; B246
        .byte   $02,$AA,$80,$0E,$AA,$BC,$0E,$AA ; B24E
        .byte   $BC,$3E,$AA,$B0,$3E,$AA,$B0,$0E ; B256
        .byte   $AA,$BC,$0E,$AA,$BC,$02,$AA,$80 ; B25E
        .byte   $00,$3C,$00,$00,$3C,$00,$00,$3C ; B266
        .byte   $00,$00,$00,$00,$00,$00,$00,$C1 ; B26E
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; B276
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; B27E
        .byte   $C3,$00,$00,$FF,$00,$02,$AA,$80 ; B286
        .byte   $02,$AA,$80,$3E,$AA,$B0,$3E,$AA ; B28E
        .byte   $B0,$0E,$AA,$BC,$0E,$AA,$BC,$3E ; B296
        .byte   $AA,$B0,$3E,$AA,$B0,$02,$AA,$80 ; B29E
        .byte   $00,$FF,$00,$00,$3C,$00,$00,$00 ; B2A6
        .byte   $00,$00,$00,$00,$00,$00,$00,$C1 ; B2AE
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; B2B6
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; B2BE
        .byte   $3C,$00,$00,$FF,$00,$02,$AA,$80 ; B2C6
        .byte   $02,$AA,$80,$FE,$AA,$80,$FE,$AA ; B2CE
        .byte   $80,$02,$AA,$BF,$02,$AA,$BF,$FE ; B2D6
        .byte   $AA,$80,$FE,$AA,$80,$02,$AA,$80 ; B2DE
        .byte   $00,$FF,$00,$00,$C3,$00,$00,$00 ; B2E6
        .byte   $00,$00,$00,$00,$00,$00,$00,$C1 ; B2EE
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; B2F6
        .byte   $00,$00,$00,$00,$00,$3C,$00,$00 ; B2FE
        .byte   $3C,$00,$00,$3C,$00,$02,$AA,$80 ; B306
        .byte   $02,$AA,$80,$FE,$AA,$80,$FE,$AA ; B30E
        .byte   $80,$02,$AA,$BF,$02,$AA,$BF,$FE ; B316
        .byte   $AA,$80,$FE,$AA,$80,$02,$AA,$80 ; B31E
        .byte   $00,$C3,$00,$00,$C3,$00,$00,$C3 ; B326
        .byte   $00,$00,$00,$00,$00,$00,$00,$C1 ; B32E
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; B336
        .byte   $00,$00,$00,$00,$00,$3C,$00,$00 ; B33E
        .byte   $3C,$00,$00,$3C,$00,$02,$AA,$80 ; B346
        .byte   $02,$AA,$80,$3E,$AA,$B0,$3E,$AA ; B34E
        .byte   $B0,$0E,$AA,$BC,$0E,$AA,$BC,$3E ; B356
        .byte   $AA,$B0,$3E,$AA,$B0,$02,$AA,$80 ; B35E
        .byte   $00,$C3,$00,$00,$C3,$00,$00,$C3 ; B366
        .byte   $00,$00,$00,$00,$00,$00,$00,$C1 ; B36E
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; B376
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; B37E
        .byte   $3C,$00,$00,$FF,$00,$02,$AA,$80 ; B386
        .byte   $02,$AA,$80,$0E,$AA,$BC,$0E,$AA ; B38E
        .byte   $BC,$3E,$AA,$B0,$3E,$AA,$B0,$0E ; B396
        .byte   $AA,$BC,$0E,$AA,$BC,$02,$AA,$80 ; B39E
        .byte   $00,$FF,$00,$00,$C3,$00,$00,$00 ; B3A6
        .byte   $00,$00,$00,$00,$00,$00,$00,$C1 ; B3AE
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; B3B6
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; B3BE
        .byte   $C3,$00,$00,$FF,$00,$02,$AA,$80 ; B3C6
        .byte   $02,$AA,$80,$02,$AA,$BF,$02,$AA ; B3CE
        .byte   $BF,$FE,$AA,$80,$FE,$AA,$80,$02 ; B3D6
        .byte   $AA,$BF,$02,$AA,$BF,$02,$AA,$80 ; B3DE
        .byte   $00,$FF,$00,$00,$3C,$00,$00,$00 ; B3E6
        .byte   $00,$00,$00,$00,$00,$00,$00,$C1 ; B3EE
sprites_bonus_something:
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; B3F6
        .byte   $00,$00,$10,$04,$70,$38,$1C,$3C ; B3FE
        .byte   $3C,$78,$3F,$FF,$F0,$0F,$FF,$F0 ; B406
        .byte   $0F,$FF,$F0,$0F,$FF,$F0,$3F,$FF ; B40E
        .byte   $FC,$7F,$FF,$FF,$7F,$FF,$FC,$0F ; B416
        .byte   $FF,$F0,$0F,$FF,$F0,$1F,$FF,$F8 ; B41E
        .byte   $3F,$FF,$FE,$38,$3C,$1F,$30,$38 ; B426
        .byte   $00,$00,$08,$00,$00,$00,$00,$41 ; B42E
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; B436
        .byte   $00,$30,$18,$04,$30,$1C,$0E,$3C ; B43E
        .byte   $3C,$3C,$1F,$FF,$F0,$0F,$FF,$F0 ; B446
        .byte   $0F,$FF,$F0,$0F,$FF,$F0,$1F,$FF ; B44E
        .byte   $F8,$7F,$FF,$FE,$FF,$FF,$FE,$CF ; B456
        .byte   $FF,$F4,$0F,$FF,$F0,$1F,$FF,$F8 ; B45E
        .byte   $7B,$FF,$F8,$70,$38,$1F,$20,$78 ; B466
        .byte   $18,$00,$C0,$00,$00,$00,$00,$41 ; B46E
        .byte   $00,$00,$00,$00,$00,$00,$30,$08 ; B476
        .byte   $00,$30,$1C,$1C,$38,$1C,$0E,$3E ; B47E
        .byte   $1C,$3C,$3F,$9F,$F0,$0F,$FF,$E0 ; B486
        .byte   $0F,$FF,$F0,$2F,$FF,$F0,$7F,$FF ; B48E
        .byte   $FA,$7F,$FF,$FE,$FF,$FF,$FE,$8F ; B496
        .byte   $FF,$F6,$0F,$FF,$F2,$1F,$FF,$F8 ; B49E
        .byte   $3B,$9F,$F8,$70,$18,$1E,$70,$70 ; B4A6
        .byte   $3C,$70,$C0,$4C,$00,$00,$00,$41 ; B4AE
        .byte   $00,$00,$00,$40,$40,$00,$70,$38 ; B4B6
        .byte   $0C,$30,$1C,$1C,$38,$1C,$0E,$1E ; B4BE
        .byte   $1C,$3C,$0F,$9F,$A0,$0F,$FF,$C0 ; B4C6
        .byte   $0F,$FF,$F0,$AF,$FF,$F0,$FF,$FF ; B4CE
        .byte   $F8,$FF,$FF,$FE,$4F,$FF,$FE,$0F ; B4D6
        .byte   $FF,$F4,$0F,$FF,$F0,$1E,$7F,$F8 ; B4DE
        .byte   $3A,$1F,$F8,$70,$18,$18,$7C,$78 ; B4E6
        .byte   $3C,$44,$6E,$68,$00,$02,$30,$41 ; B4EE
        .byte   $00,$00,$00,$18,$78,$00,$38,$38 ; B4F6
        .byte   $0C,$30,$0C,$1C,$18,$0C,$0E,$0E ; B4FE
        .byte   $0C,$0C,$0F,$9F,$80,$0F,$FF,$C0 ; B506
        .byte   $CF,$FF,$F0,$EF,$FF,$F0,$FF,$FF ; B50E
        .byte   $F8,$EF,$FF,$FC,$07,$FF,$FC,$07 ; B516
        .byte   $FF,$FC,$0F,$FF,$F8,$1E,$7F,$FE ; B51E
        .byte   $3A,$1F,$F8,$70,$98,$F8,$70,$F8 ; B526
        .byte   $3C,$78,$6C,$28,$00,$00,$00,$41 ; B52E
        .byte   $00,$00,$00,$10,$00,$00,$3C,$38 ; B536
        .byte   $00,$1C,$3C,$08,$0C,$3C,$00,$0E ; B53E
        .byte   $0C,$7C,$0F,$9F,$FC,$EF,$FF,$F8 ; B546
        .byte   $FF,$FF,$F0,$FF,$FF,$F0,$7F,$FF ; B54E
        .byte   $FA,$2F,$FF,$FE,$07,$FF,$FE,$07 ; B556
        .byte   $FF,$FC,$0F,$FF,$F8,$1E,$7F,$FE ; B55E
        .byte   $1B,$9F,$FB,$71,$88,$FB,$7C,$E8 ; B566
        .byte   $38,$1C,$4E,$00,$00,$0E,$00,$41 ; B56E
        .byte   $00,$00,$00,$00,$00,$00,$0C,$18 ; B576
        .byte   $00,$0C,$1C,$00,$0F,$3C,$1C,$0F ; B57E
        .byte   $1C,$7C,$0F,$9F,$FC,$0F,$FF,$F8 ; B586
        .byte   $7F,$FF,$F0,$7F,$FF,$F0,$7F,$FF ; B58E
        .byte   $FF,$3F,$FF,$FF,$1F,$FF,$FE,$07 ; B596
        .byte   $FF,$FC,$0F,$FF,$F8,$1F,$FF,$FE ; B59E
        .byte   $1F,$FF,$FF,$7D,$9C,$FF,$7C,$0C ; B5A6
        .byte   $3C,$10,$0E,$00,$00,$0E,$00,$41 ; B5AE
        .byte   $00,$00,$00,$00,$00,$00,$00,$10 ; B5B6
        .byte   $00,$08,$18,$00,$18,$1C,$0C,$7E ; B5BE
        .byte   $3C,$1C,$3F,$BF,$F8,$1F,$FF,$F0 ; B5C6
        .byte   $1F,$FF,$F0,$1F,$FF,$F0,$7F,$FF ; B5CE
        .byte   $F7,$3F,$FF,$FF,$7F,$FF,$FC,$27 ; B5D6
        .byte   $FF,$F8,$0F,$FF,$F8,$0F,$FF,$FC ; B5DE
        .byte   $1F,$FF,$FF,$3D,$9C,$3F,$78,$0C ; B5E6
        .byte   $04,$10,$0C,$00,$00,$00,$00,$41 ; B5EE
sprites_bonus_worms:
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; B5F6
        .byte   $00,$00,$00,$00,$0F,$FC,$00,$10 ; B5FE
        .byte   $00,$00,$23,$FF,$C0,$07,$FF,$E0 ; B606
        .byte   $0F,$FF,$F2,$0F,$FF,$F2,$0F,$FF ; B60E
        .byte   $F2,$0F,$FF,$F2,$0F,$FF,$F2,$0F ; B616
        .byte   $FF,$F2,$4F,$FF,$F2,$47,$FF,$E2 ; B61E
        .byte   $23,$FF,$C4,$10,$00,$00,$0F,$E0 ; B626
        .byte   $00,$00,$00,$00,$00,$00,$00,$41 ; B62E
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; B636
        .byte   $00,$00,$00,$00,$0F,$FF,$80,$00 ; B63E
        .byte   $00,$00,$03,$FF,$C0,$07,$FF,$E0 ; B646
        .byte   $0F,$FF,$F0,$0F,$FF,$F0,$0F,$FF ; B64E
        .byte   $F2,$0F,$FF,$F2,$4F,$FF,$F2,$4F ; B656
        .byte   $FF,$F2,$4F,$FF,$F2,$47,$FF,$E2 ; B65E
        .byte   $23,$FF,$C4,$10,$00,$08,$0F,$00 ; B666
        .byte   $10,$00,$00,$00,$00,$00,$00,$41 ; B66E
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; B676
        .byte   $00,$00,$00,$00,$01,$FF,$F0,$00 ; B67E
        .byte   $00,$00,$03,$FF,$C0,$07,$FF,$E0 ; B686
        .byte   $0F,$FF,$F0,$0F,$FF,$F0,$4F,$FF ; B68E
        .byte   $F0,$4F,$FF,$F0,$4F,$FF,$F2,$4F ; B696
        .byte   $FF,$F2,$4F,$FF,$F2,$47,$FF,$E2 ; B69E
        .byte   $23,$FF,$C4,$10,$00,$08,$08,$00 ; B6A6
        .byte   $F0,$00,$00,$00,$00,$00,$00,$41 ; B6AE
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; B6B6
        .byte   $00,$00,$00,$00,$00,$3F,$F0,$00 ; B6BE
        .byte   $00,$08,$03,$FF,$C4,$07,$FF,$E0 ; B6C6
        .byte   $4F,$FF,$F0,$4F,$FF,$F0,$4F,$FF ; B6CE
        .byte   $F0,$4F,$FF,$F0,$4F,$FF,$F0,$4F ; B6D6
        .byte   $FF,$F0,$4F,$FF,$F2,$47,$FF,$E2 ; B6DE
        .byte   $23,$FF,$C4,$00,$00,$08,$00,$07 ; B6E6
        .byte   $F0,$00,$00,$00,$00,$00,$00,$41 ; B6EE
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; B6F6
        .byte   $00,$00,$00,$00,$00,$07,$F0,$00 ; B6FE
        .byte   $00,$08,$23,$FF,$C4,$47,$FF,$E2 ; B706
        .byte   $4F,$FF,$F2,$4F,$FF,$F0,$4F,$FF ; B70E
        .byte   $F0,$4F,$FF,$F0,$4F,$FF,$F0,$4F ; B716
        .byte   $FF,$F0,$4F,$FF,$F0,$07,$FF,$E0 ; B71E
        .byte   $03,$FF,$C4,$00,$00,$08,$00,$3F ; B726
        .byte   $F0,$00,$00,$00,$00,$00,$00,$41 ; B72E
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; B736
        .byte   $00,$00,$00,$00,$08,$00,$F0,$10 ; B73E
        .byte   $00,$08,$23,$FF,$C4,$47,$FF,$E2 ; B746
        .byte   $4F,$FF,$F2,$4F,$FF,$F2,$4F,$FF ; B74E
        .byte   $F2,$4F,$FF,$F0,$4F,$FF,$F0,$0F ; B756
        .byte   $FF,$F0,$0F,$FF,$F0,$07,$FF,$E0 ; B75E
        .byte   $03,$FF,$C0,$00,$00,$00,$01,$FF ; B766
        .byte   $F0,$00,$00,$00,$00,$00,$00,$41 ; B76E
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; B776
        .byte   $00,$00,$00,$00,$0F,$00,$10,$10 ; B77E
        .byte   $00,$08,$23,$FF,$C4,$47,$FF,$E2 ; B786
        .byte   $4F,$FF,$F2,$4F,$FF,$F2,$4F,$FF ; B78E
        .byte   $F2,$0F,$FF,$F2,$0F,$FF,$F2,$0F ; B796
        .byte   $FF,$F0,$0F,$FF,$F0,$07,$FF,$E0 ; B79E
        .byte   $03,$FF,$C0,$00,$00,$00,$0F,$FF ; B7A6
        .byte   $80,$00,$00,$00,$00,$00,$00,$41 ; B7AE
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; B7B6
        .byte   $00,$00,$00,$00,$0F,$E0,$00,$10 ; B7BE
        .byte   $00,$00,$23,$FF,$C4,$47,$FF,$E2 ; B7C6
        .byte   $4F,$FF,$F2,$0F,$FF,$F2,$0F,$FF ; B7CE
        .byte   $F2,$0F,$FF,$F2,$0F,$FF,$F2,$0F ; B7D6
        .byte   $FF,$F2,$0F,$FF,$F2,$07,$FF,$E0 ; B7DE
        .byte   $23,$FF,$C0,$10,$00,$00,$0F,$FC ; B7E6
        .byte   $00,$00,$00,$00,$00,$00,$00,$41 ; B7EE
sprites_bonus_banded:
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; B7F6
        .byte   $00,$00,$00,$00,$0F,$FC,$00,$1F ; B7FE
        .byte   $FC,$00,$3F,$FE,$00,$0F,$FF,$C0 ; B806
        .byte   $07,$FF,$FE,$07,$FF,$FE,$07,$FF ; B80E
        .byte   $FE,$07,$FF,$FE,$07,$FF,$FE,$0F ; B816
        .byte   $FF,$FE,$1F,$FF,$FE,$7F,$FF,$FE ; B81E
        .byte   $3F,$E0,$00,$1F,$E0,$00,$0F,$E0 ; B826
        .byte   $00,$00,$00,$00,$00,$00,$00,$41 ; B82E
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; B836
        .byte   $00,$00,$00,$00,$0F,$FF,$00,$0F ; B83E
        .byte   $FF,$80,$07,$FF,$80,$03,$FF,$C0 ; B846
        .byte   $03,$FF,$E0,$03,$FF,$E0,$03,$FF ; B84E
        .byte   $FC,$03,$FF,$FE,$3F,$FF,$FE,$7F ; B856
        .byte   $FF,$FE,$7F,$FF,$FE,$7F,$FF,$FE ; B85E
        .byte   $3F,$00,$3C,$1F,$00,$38,$0E,$00 ; B866
        .byte   $10,$00,$00,$00,$00,$00,$00,$41 ; B86E
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; B876
        .byte   $00,$00,$00,$00,$01,$FF,$F0,$01 ; B87E
        .byte   $FF,$F0,$01,$FF,$F0,$03,$FF,$E0 ; B886
        .byte   $07,$FF,$E0,$07,$FF,$E0,$7F,$FF ; B88E
        .byte   $E0,$7F,$FF,$E0,$7F,$FF,$FE,$7F ; B896
        .byte   $FF,$FE,$7F,$FF,$FE,$7F,$FF,$FE ; B89E
        .byte   $3C,$00,$FC,$1C,$00,$F8,$08,$00 ; B8A6
        .byte   $F0,$00,$00,$00,$00,$00,$00,$41 ; B8AE
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; B8B6
        .byte   $00,$00,$00,$00,$00,$3F,$F0,$00 ; B8BE
        .byte   $3F,$F8,$00,$3F,$FC,$03,$FF,$F8 ; B8C6
        .byte   $7F,$FF,$F0,$7F,$FF,$F0,$7F,$FF ; B8CE
        .byte   $F0,$7F,$FF,$F0,$7F,$FF,$F0,$7F ; B8D6
        .byte   $FF,$F0,$7F,$FF,$FE,$7F,$FF,$FE ; B8DE
        .byte   $30,$07,$FC,$00,$07,$F8,$00,$07 ; B8E6
        .byte   $F0,$00,$00,$00,$00,$00,$00,$41 ; B8EE
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; B8F6
        .byte   $00,$00,$00,$00,$00,$07,$F0,$00 ; B8FE
        .byte   $07,$F8,$30,$07,$FC,$7F,$FF,$FE ; B906
        .byte   $7F,$FF,$FE,$7F,$FF,$E0,$7F,$FF ; B90E
        .byte   $E0,$7F,$FF,$E0,$7F,$FF,$E0,$7F ; B916
        .byte   $FF,$E0,$7F,$FF,$E0,$03,$FF,$F0 ; B91E
        .byte   $00,$3F,$F8,$00,$3F,$F8,$00,$3F ; B926
        .byte   $F0,$00,$00,$00,$00,$00,$00,$41 ; B92E
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; B936
        .byte   $00,$00,$00,$00,$00,$00,$F0,$18 ; B93E
        .byte   $00,$F8,$3C,$00,$FC,$7F,$FF,$FE ; B946
        .byte   $7F,$FF,$FE,$7F,$FF,$FE,$7F,$FF ; B94E
        .byte   $FE,$7F,$FF,$E0,$7F,$FF,$E0,$07 ; B956
        .byte   $FF,$E0,$07,$FF,$E0,$03,$FF,$E0 ; B95E
        .byte   $01,$FF,$E0,$01,$FF,$E0,$01,$FF ; B966
        .byte   $E0,$00,$00,$00,$00,$00,$00,$41 ; B96E
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; B976
        .byte   $00,$00,$00,$00,$0F,$00,$10,$1F ; B97E
        .byte   $00,$18,$3F,$00,$1C,$7F,$FF,$FE ; B986
        .byte   $7F,$FF,$FE,$7F,$FF,$FE,$7F,$FF ; B98E
        .byte   $FE,$07,$FF,$FE,$07,$FF,$FE,$07 ; B996
        .byte   $FF,$E0,$07,$FF,$E0,$07,$FF,$C0 ; B99E
        .byte   $07,$FF,$80,$07,$FF,$80,$07,$FF ; B9A6
        .byte   $80,$00,$00,$00,$00,$00,$00,$41 ; B9AE
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; B9B6
        .byte   $00,$00,$00,$00,$0F,$E0,$00,$1F ; B9BE
        .byte   $E0,$00,$3F,$E0,$00,$7F,$FF,$FE ; B9C6
        .byte   $7F,$FF,$FE,$07,$FF,$FE,$07,$FF ; B9CE
        .byte   $FE,$07,$FF,$FE,$07,$FF,$FE,$07 ; B9D6
        .byte   $FF,$FE,$07,$FF,$FE,$0F,$FF,$C0 ; B9DE
        .byte   $1F,$FC,$00,$1F,$FC,$00,$0F,$FC ; B9E6
        .byte   $00,$00,$00,$00,$00,$00,$00,$41 ; B9EE
blank_3:.byte   $00,$00,$00,$00,$00,$00,$00,$00 ; B9F6
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; B9FE
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; BA06
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; BA0E
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; BA16
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; BA1E
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; BA26
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; BA2E
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; BA36
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; BA3E
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; BA46
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; BA4E
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; BA56
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; BA5E
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; BA66
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; BA6E
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; BA76
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; BA7E
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; BA86
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; BA8E
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; BA96
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; BA9E
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; BAA6
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; BAAE
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; BAB6
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; BABE
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; BAC6
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; BACE
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; BAD6
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; BADE
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; BAE6
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; BAEE
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; BAF6
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; BAFE
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; BB06
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; BB0E
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; BB16
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; BB1E
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; BB26
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; BB2E
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; BB36
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; BB3E
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; BB46
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; BB4E
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; BB56
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; BB5E
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; BB66
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; BB6E
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; BB76
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; BB7E
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; BB86
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; BB8E
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; BB96
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; BB9E
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; BBA6
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; BBAE
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; BBB6
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; BBBE
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; BBC6
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; BBCE
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; BBD6
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; BBDE
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; BBE6
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; BBEE
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; BBF6
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; BBFE
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; BC06
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; BC0E
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; BC16
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; BC1E
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; BC26
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; BC2E
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; BC36
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; BC3E
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; BC46
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; BC4E
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; BC56
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; BC5E
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; BC66
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; BC6E
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; BC76
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; BC7E
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; BC86
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; BC8E
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; BC96
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; BC9E
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; BCA6
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; BCAE
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; BCB6
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; BCBE
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; BCC6
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; BCCE
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; BCD6
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; BCDE
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; BCE6
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; BCEE
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; BCF6
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; BCFE
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; BD06
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; BD0E
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; BD16
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; BD1E
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; BD26
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; BD2E
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; BD36
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; BD3E
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; BD46
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; BD4E
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; BD56
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; BD5E
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; BD66
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; BD6E
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; BD76
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; BD7E
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; BD86
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; BD8E
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; BD96
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; BD9E
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; BDA6
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; BDAE
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; BDB6
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; BDBE
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; BDC6
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; BDCE
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; BDD6
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; BDDE
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; BDE6
        .byte   $00,$00                         ; BDEE
LBDF0:  .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; BDF0
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; BDF8
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; BE00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; BE08
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; BE10
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; BE18
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; BE20
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; BE28
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; BE30
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; BE38
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; BE40
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; BE48
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; BE50
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; BE58
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; BE60
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; BE68
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; BE70
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; BE78
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; BE80
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; BE88
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; BE90
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; BE98
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; BEA0
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; BEA8
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; BEB0
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; BEB8
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; BEC0
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; BEC8
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; BED0
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; BED8
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; BEE0
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; BEE8
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; BEF0
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; BEF8
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; BF00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; BF08
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; BF10
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; BF18
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; BF20
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; BF28
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; BF30
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; BF38
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; BF40
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; BF48
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; BF50
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; BF58
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; BF60
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; BF68
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; BF70
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; BF78
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; BF80
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; BF88
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; BF90
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; BF98
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; BFA0
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; BFA8
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; BFB0
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; BFB8
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; BFC0
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; BFC8
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; BFD0
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; BFD8
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; BFE0
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; BFE8
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; BFF0
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; BFF8
background_bitmap:
        .byte   $BF,$FF,$FF,$F5,$D5,$52,$6B,$BB ; C000
        .byte   $FF,$FF,$FF,$56,$A9,$56,$D5,$56 ; C008
        .byte   $FF,$FF,$FF,$5F,$A5,$5A,$A6,$6A ; C010
        .byte   $95,$5F,$7F,$7F,$D5,$57,$9F,$6D ; C018
        .byte   $6A,$A9,$A6,$A9,$96,$99,$57,$AA ; C020
        .byte   $5F,$A6,$5A,$A5,$5A,$AA,$AA,$56 ; C028
        .byte   $AA,$AA,$6A,$FF,$55,$FD,$57,$55 ; C030
        .byte   $FF,$FF,$FF,$FF,$7F,$9F,$A7,$69 ; C038
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; C040
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; C048
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; C050
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; C058
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; C060
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; C068
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; C070
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; C078
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; C080
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; C088
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; C090
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; C098
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; C0A0
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; C0A8
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; C0B0
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; C0B8
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; C0C0
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; C0C8
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; C0D0
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; C0D8
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; C0E0
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; C0E8
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; C0F0
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; C0F8
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; C100
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; C108
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; C110
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; C118
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; C120
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; C128
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; C130
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; C138
        .byte   $F5,$F4,$D2,$DB,$5B,$6D,$7D,$7D ; C140
        .byte   $4A,$A9,$F5,$56,$4A,$2A,$A1,$84 ; C148
        .byte   $AF,$F5,$56,$A1,$6A,$85,$55,$45 ; C150
        .byte   $55,$D5,$12,$5A,$1F,$77,$D5,$D5 ; C158
        .byte   $55,$AA,$94,$A5,$61,$E8,$DA,$79 ; C160
        .byte   $7A,$56,$A9,$4A,$52,$54,$55,$85 ; C168
        .byte   $A7,$A8,$AA,$AA,$AA,$BA,$BE,$BD ; C170
        .byte   $D5,$D5,$F5,$3D,$BF,$BF,$BF,$9F ; C178
        .byte   $7F,$7F,$BF,$BF,$BF,$BF,$FF,$FF ; C180
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; C188
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; C190
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; C198
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; C1A0
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; C1A8
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; C1B0
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; C1B8
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; C1C0
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; C1C8
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; C1D0
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; C1D8
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; C1E0
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; C1E8
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; C1F0
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; C1F8
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; C200
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; C208
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; C210
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; C218
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; C220
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; C228
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; C230
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; C238
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; C240
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; C248
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; C250
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; C258
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; C260
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; C268
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; C270
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; C278
        .byte   $B8,$F9,$F9,$F9,$F9,$F9,$FD,$FD ; C280
        .byte   $96,$96,$A6,$E6,$EA,$E9,$EA,$E6 ; C288
        .byte   $EC,$EE,$2E,$2E,$4A,$58,$19,$91 ; C290
        .byte   $95,$55,$44,$77,$7F,$7F,$4C,$4D ; C298
        .byte   $7A,$7D,$77,$79,$59,$58,$5A,$56 ; C2A0
        .byte   $A5,$21,$69,$49,$50,$56,$66,$66 ; C2A8
        .byte   $95,$AA,$BF,$6F,$6F,$97,$A9,$E9 ; C2B0
        .byte   $AF,$5B,$56,$D6,$F5,$FD,$FD,$FD ; C2B8
        .byte   $FF,$FF,$FF,$FF,$BF,$BF,$7F,$7F ; C2C0
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; C2C8
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; C2D0
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; C2D8
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; C2E0
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; C2E8
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; C2F0
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; C2F8
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; C300
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; C308
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; C310
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; C318
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; C320
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; C328
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; C330
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; C338
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; C340
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; C348
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; C350
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; C358
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; C360
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; C368
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; C370
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; C378
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; C380
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; C388
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; C390
player_name_bitmap:
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; C398
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; C3A0
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; C3A8
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; C3B0
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; C3B8
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; C3C0
        .byte   $D8,$1A,$4A,$6A,$62,$C4,$D5,$F5 ; C3C8
        .byte   $94,$16,$56,$16,$96,$94,$91,$90 ; C3D0
        .byte   $82,$96,$92,$5E,$5E,$4E,$7E,$7E ; C3D8
        .byte   $D7,$C7,$F7,$F7,$F5,$31,$3D,$8D ; C3E0
        .byte   $75,$71,$BD,$3C,$6F,$5B,$D7,$B6 ; C3E8
        .byte   $5F,$13,$9B,$99,$99,$99,$99,$11 ; C3F0
        .byte   $BF,$BF,$BF,$6F,$6F,$6F,$6F,$6F ; C3F8
        .byte   $BF,$BF,$FF,$FF,$FF,$FF,$FF,$FF ; C400
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; C408
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; C410
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; C418
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; C420
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; C428
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$C0 ; C430
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$0B,$22 ; C438
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$AF ; C440
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; C448
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; C450
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; C458
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; C460
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; C468
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; C470
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; C478
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; C480
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; C488
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; C490
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; C498
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; C4A0
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; C4A8
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; C4B0
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; C4B8
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; C4C0
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; C4C8
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; C4D0
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; C4D8
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; C4E0
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; C4E8
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; C4F0
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; C4F8
        .byte   $FF,$FF,$55,$55,$55,$05,$A5,$95 ; C500
        .byte   $FD,$E9,$A9,$A9,$AA,$AA,$AA,$AA ; C508
        .byte   $40,$50,$57,$53,$4F,$4F,$7F,$5F ; C510
        .byte   $C5,$E5,$E4,$E4,$E4,$E4,$A4,$A4 ; C518
        .byte   $F6,$F7,$37,$37,$33,$FF,$CF,$C3 ; C520
        .byte   $7A,$7E,$5E,$1E,$1F,$1F,$1F,$5F ; C528
        .byte   $FF,$7F,$7F,$7F,$7F,$7F,$FF,$F0 ; C530
        .byte   $9F,$9F,$DF,$DF,$F0,$C0,$00,$22 ; C538
        .byte   $FF,$FF,$FF,$FC,$00,$22,$88,$22 ; C540
        .byte   $FF,$FF,$FF,$00,$00,$00,$80,$02 ; C548
        .byte   $FF,$FF,$00,$00,$08,$22,$88,$22 ; C550
        .byte   $FF,$00,$00,$00,$88,$22,$88,$22 ; C558
        .byte   $FC,$00,$00,$22,$88,$20,$88,$22 ; C560
        .byte   $00,$00,$80,$02,$08,$22,$88,$22 ; C568
        .byte   $08,$22,$88,$22,$88,$22,$88,$22 ; C570
        .byte   $88,$22,$88,$22,$88,$22,$88,$22 ; C578
        .byte   $AA,$22,$88,$22,$88,$22,$88,$22 ; C580
        .byte   $AB,$AA,$88,$22,$88,$22,$88,$22 ; C588
        .byte   $FF,$2A,$8A,$22,$88,$22,$88,$22 ; C590
        .byte   $FF,$FF,$AF,$20,$88,$22,$88,$22 ; C598
        .byte   $FF,$FF,$FF,$00,$80,$00,$80,$22 ; C5A0
        .byte   $FF,$FF,$FF,$2A,$88,$22,$88,$22 ; C5A8
        .byte   $FF,$FF,$FF,$AF,$8A,$22,$88,$22 ; C5B0
        .byte   $FF,$FF,$FF,$FF,$AB,$2A,$88,$22 ; C5B8
        .byte   $FF,$FF,$FF,$FF,$FF,$AA,$AA,$22 ; C5C0
        .byte   $FF,$FF,$FF,$FF,$FF,$AF,$AA,$AA ; C5C8
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$AB,$A2 ; C5D0
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$2A ; C5D8
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$AF ; C5E0
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; C5E8
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; C5F0
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; C5F8
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; C600
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; C608
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; C610
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; C618
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; C620
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; C628
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; C630
        .byte   $AA,$AA,$AA,$AA,$AA,$AA,$AA,$A0 ; C638
        .byte   $7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F ; C640
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$CF ; C648
        .byte   $D7,$D3,$DB,$D3,$DB,$DB,$D7,$1B ; C650
        .byte   $F5,$F5,$F5,$F5,$FD,$FD,$FD,$FF ; C658
        .byte   $70,$3C,$FC,$FF,$FF,$FE,$CA,$DA ; C660
        .byte   $5A,$5A,$6A,$6A,$AA,$AA,$AA,$AA ; C668
        .byte   $C0,$A0,$A8,$AA,$AA,$AA,$AA,$AA ; C670
        .byte   $88,$00,$00,$00,$A0,$AA,$AA,$AA ; C678
        .byte   $80,$00,$08,$22,$88,$A2,$AA,$AA ; C680
        .byte   $08,$22,$88,$22,$88,$22,$A8,$AA ; C688
        .byte   $88,$22,$88,$22,$88,$22,$88,$A2 ; C690
        .byte   $88,$22,$88,$22,$88,$22,$88,$22 ; C698
        .byte   $88,$22,$88,$22,$88,$22,$80,$20 ; C6A0
        .byte   $88,$16,$94,$16,$97,$15,$15,$16 ; C6A8
        .byte   $88,$16,$94,$16,$D4,$56,$54,$14 ; C6B0
        .byte   $85,$15,$D8,$52,$58,$52,$D8,$15 ; C6B8
        .byte   $88,$62,$78,$52,$58,$52,$78,$60 ; C6C0
        .byte   $88,$52,$58,$52,$58,$52,$58,$50 ; C6C8
        .byte   $88,$16,$94,$16,$94,$16,$14,$16 ; C6D0
        .byte   $88,$1E,$94,$16,$B7,$25,$8D,$01 ; C6D8
        .byte   $88,$36,$94,$1E,$D8,$52,$78,$62 ; C6E0
        .byte   $88,$22,$88,$71,$59,$DD,$95,$15 ; C6E8
        .byte   $88,$22,$88,$36,$94,$DE,$58,$52 ; C6F0
        .byte   $CC,$33,$CC,$35,$D5,$93,$5C,$53 ; C6F8
        .byte   $88,$22,$88,$22,$C8,$D2,$F9,$F3 ; C700
        .byte   $88,$22,$88,$22,$BC,$FF,$CB,$E3 ; C708
        .byte   $88,$22,$88,$22,$8B,$23,$4B,$E3 ; C710
        .byte   $88,$22,$88,$22,$FF,$E7,$CB,$E3 ; C718
        .byte   $AA,$22,$88,$22,$8A,$21,$C5,$E4 ; C720
        .byte   $AB,$22,$88,$22,$AA,$4A,$52,$14 ; C728
        .byte   $FF,$22,$88,$22,$48,$96,$65,$69 ; C730
        .byte   $FF,$2F,$88,$22,$88,$21,$96,$6A ; C738
        .byte   $FF,$FF,$BF,$22,$54,$69,$96,$A9 ; C740
        .byte   $FF,$FF,$FF,$2F,$88,$22,$48,$22 ; C748
        .byte   $FF,$FF,$FF,$FF,$88,$22,$88,$22 ; C750
        .byte   $FF,$FF,$FF,$FF,$FF,$22,$88,$22 ; C758
        .byte   $AA,$AA,$AA,$AA,$AA,$33,$CC,$33 ; C760
        .byte   $AA,$AA,$AA,$AA,$AA,$AA,$CC,$33 ; C768
        .byte   $AA,$AA,$AA,$AA,$AA,$AA,$CE,$33 ; C770
        .byte   $AF,$AB,$AB,$AB,$AB,$AB,$AB,$13 ; C778
        .byte   $7A,$7A,$7F,$57,$41,$40,$40,$40 ; C780
        .byte   $AA,$AA,$A8,$6B,$5B,$D5,$3D,$03 ; C788
        .byte   $F2,$DA,$C8,$FA,$2A,$2A,$5A,$56 ; C790
        .byte   $FF,$CF,$FF,$FC,$FD,$FD,$F1,$F5 ; C798
        .byte   $4F,$6F,$5F,$4F,$6F,$BF,$7F,$3F ; C7A0
        .byte   $FF,$FF,$FF,$FF,$33,$FF,$FF,$FF ; C7A8
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$3F,$FC ; C7B0
        .byte   $AA,$AA,$AA,$AA,$AA,$AA,$2A,$AA ; C7B8
        .byte   $AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA ; C7C0
        .byte   $AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA ; C7C8
        .byte   $A8,$AA,$AA,$AA,$AA,$AA,$AA,$AA ; C7D0
        .byte   $88,$A2,$AA,$AA,$AA,$AA,$AA,$AA ; C7D8
        .byte   $88,$22,$88,$A2,$AA,$AA,$AA,$AA ; C7E0
        .byte   $14,$14,$80,$22,$AA,$AA,$2A,$AA ; C7E8
        .byte   $14,$16,$08,$AA,$AA,$AA,$AA,$A8 ; C7F0
        .byte   $05,$22,$AA,$AA,$AA,$AA,$AA,$AA ; C7F8
        .byte   $00,$22,$AA,$AA,$AA,$AA,$AA,$AA ; C800
        .byte   $55,$11,$AA,$AA,$AA,$AA,$AA,$AA ; C808
        .byte   $D5,$D5,$AA,$AA,$AA,$AA,$AA,$AA ; C810
        .byte   $71,$71,$AA,$AA,$AA,$AA,$AA,$AA ; C818
        .byte   $48,$60,$A8,$AA,$AA,$AA,$AA,$AA ; C820
        .byte   $B5,$04,$04,$A6,$AA,$AA,$AA,$AA ; C828
        .byte   $70,$60,$48,$6A,$AA,$AA,$AA,$AA ; C830
        .byte   $58,$D2,$15,$A5,$AA,$AA,$AA,$AA ; C838
        .byte   $51,$71,$43,$A0,$AA,$AA,$AA,$AA ; C840
        .byte   $49,$61,$49,$55,$94,$AA,$AA,$AA ; C848
        .byte   $49,$41,$C1,$21,$88,$22,$A8,$AA ; C850
        .byte   $41,$42,$46,$58,$A3,$0F,$BC,$0F ; C858
        .byte   $30,$A9,$A6,$98,$A3,$8D,$36,$E6 ; C860
        .byte   $8F,$58,$A5,$16,$6A,$AA,$98,$62 ; C868
        .byte   $BB,$AE,$FE,$EF,$AA,$22,$84,$E5 ; C870
        .byte   $8F,$55,$A9,$BA,$4E,$6C,$9C,$9B ; C878
        .byte   $8C,$2F,$7F,$4B,$D2,$FE,$FC,$3F ; C880
        .byte   $CC,$33,$CC,$F3,$CC,$33,$7C,$73 ; C888
        .byte   $CC,$33,$CC,$33,$CC,$33,$CC,$33 ; C890
        .byte   $CC,$33,$CC,$33,$CC,$33,$CC,$33 ; C898
        .byte   $CC,$33,$CC,$33,$CC,$33,$CC,$33 ; C8A0
        .byte   $CC,$33,$CC,$33,$CC,$33,$CC,$32 ; C8A8
        .byte   $CC,$33,$CC,$33,$CD,$15,$56,$68 ; C8B0
        .byte   $CE,$32,$D6,$56,$6A,$82,$02,$02 ; C8B8
        .byte   $C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0 ; C8C0
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; C8C8
        .byte   $EA,$3E,$03,$00,$00,$00,$00,$00 ; C8D0
        .byte   $AC,$6F,$5C,$D5,$3D,$03,$00,$00 ; C8D8
        .byte   $AA,$AA,$AA,$AA,$AA,$5A,$D6,$3D ; C8E0
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$BF ; C8E8
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; C8F0
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; C8F8
        .byte   $33,$FC,$FF,$FF,$FF,$FF,$FF,$FF ; C900
        .byte   $FF,$CF,$F3,$FF,$FF,$FF,$FF,$FF ; C908
        .byte   $AA,$AA,$2A,$8A,$A8,$AA,$AA,$AA ; C910
        .byte   $AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA ; C918
        .byte   $AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA ; C920
        .byte   $AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA ; C928
        .byte   $AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA ; C930
        .byte   $AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA ; C938
        .byte   $2A,$A2,$AA,$AA,$AA,$AA,$AA,$AA ; C940
        .byte   $AA,$AA,$A2,$AA,$AA,$AA,$AA,$AA ; C948
        .byte   $AA,$AA,$8A,$AA,$AA,$AA,$AA,$AA ; C950
        .byte   $AA,$AA,$AA,$AA,$A8,$AA,$AA,$AA ; C958
        .byte   $AA,$AA,$AA,$AA,$AA,$22,$A8,$AA ; C960
        .byte   $AA,$AA,$AA,$AA,$AA,$AA,$88,$AA ; C968
        .byte   $AA,$AA,$AA,$AA,$AA,$22,$AA,$AA ; C970
        .byte   $AA,$AA,$AA,$AA,$AA,$2A,$AA,$AA ; C978
        .byte   $AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA ; C980
        .byte   $AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA ; C988
        .byte   $A8,$AB,$A3,$AF,$AF,$A3,$AC,$8A ; C990
        .byte   $EC,$32,$CA,$EA,$29,$A9,$AA,$AA ; C998
        .byte   $9A,$62,$6C,$6F,$A3,$AC,$8E,$B2 ; C9A0
        .byte   $02,$A0,$B1,$30,$F8,$F8,$EA,$EA ; C9A8
        .byte   $08,$9A,$92,$16,$14,$97,$87,$A7 ; C9B0
        .byte   $DE,$DE,$DC,$F4,$2C,$AC,$2C,$EC ; C9B8
        .byte   $2F,$23,$8B,$8B,$BB,$BB,$B3,$BF ; C9C0
        .byte   $E8,$22,$88,$22,$88,$AA,$AA,$AA ; C9C8
        .byte   $CC,$33,$CC,$33,$CC,$33,$FF,$FF ; C9D0
        .byte   $CC,$33,$CC,$33,$CC,$32,$CA,$29 ; C9D8
        .byte   $CC,$33,$CD,$15,$56,$68,$80,$00 ; C9E0
        .byte   $D5,$56,$68,$80,$00,$00,$00,$00 ; C9E8
        .byte   $C0,$00,$00,$00,$00,$00,$00,$00 ; C9F0
        .byte   $02,$02,$02,$02,$02,$02,$02,$02 ; C9F8
        .byte   $C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0 ; CA00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; CA08
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; CA10
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; CA18
        .byte   $03,$00,$00,$00,$00,$00,$00,$00 ; CA20
        .byte   $5F,$97,$29,$02,$00,$00,$00,$00 ; CA28
        .byte   $AA,$AA,$AA,$FA,$7F,$17,$01,$00 ; CA30
        .byte   $AA,$AA,$AA,$AA,$FF,$A8,$F8,$7C ; CA38
        .byte   $AA,$AA,$AA,$AA,$FF,$AA,$AA,$AA ; CA40
        .byte   $FF,$FF,$FF,$FF,$AF,$3F,$3F,$3F ; CA48
        .byte   $AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA ; CA50
        .byte   $AA,$AA,$AA,$2A,$AA,$AA,$A2,$AA ; CA58
        .byte   $AA,$AA,$AA,$AA,$AA,$AA,$22,$AA ; CA60
        .byte   $AA,$AA,$AA,$AA,$AA,$AA,$AA,$88 ; CA68
        .byte   $AA,$AA,$AA,$AA,$22,$AA,$AA,$AA ; CA70
        .byte   $AA,$AA,$AA,$AA,$22,$A8,$AA,$AA ; CA78
        .byte   $AA,$AA,$AA,$AA,$AA,$2A,$AA,$AA ; CA80
        .byte   $AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA ; CA88
        .byte   $AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA ; CA90
        .byte   $AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA ; CA98
        .byte   $AA,$AA,$AA,$AA,$AA,$AA,$AA,$8A ; CAA0
        .byte   $AA,$AA,$AA,$A2,$AA,$AA,$AA,$AA ; CAA8
        .byte   $AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA ; CAB0
        .byte   $AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA ; CAB8
        .byte   $AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA ; CAC0
        .byte   $AA,$AA,$AA,$AA,$2A,$AA,$AA,$AA ; CAC8
        .byte   $AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA ; CAD0
        .byte   $AA,$AA,$AA,$AA,$2A,$8A,$AA,$AA ; CAD8
        .byte   $2A,$AA,$AA,$AA,$AA,$AA,$AA,$AA ; CAE0
        .byte   $BF,$BF,$BF,$BB,$AB,$AC,$AD,$AC ; CAE8
        .byte   $53,$57,$57,$77,$BA,$FC,$FC,$FC ; CAF0
        .byte   $88,$AA,$AA,$AA,$FF,$AA,$AA,$AA ; CAF8
        .byte   $6A,$2A,$AA,$AA,$FF,$2A,$2A,$2B ; CB00
        .byte   $AA,$AA,$AA,$AA,$FF,$AA,$D5,$55 ; CB08
        .byte   $AA,$AA,$AA,$AA,$FF,$AA,$55,$55 ; CB10
        .byte   $7C,$60,$60,$60,$A0,$60,$E0,$E0 ; CB18
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; CB20
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; CB28
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; CB30
        .byte   $01,$01,$01,$01,$01,$01,$01,$01 ; CB38
        .byte   $C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0 ; CB40
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; CB48
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; CB50
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; CB58
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; CB60
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; CB68
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; CB70
        .byte   $3E,$03,$00,$00,$00,$00,$00,$00 ; CB78
        .byte   $AA,$5A,$D6,$3D,$03,$00,$00,$00 ; CB80
        .byte   $3F,$3F,$3F,$3F,$BF,$7F,$3F,$3F ; CB88
        .byte   $AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA ; CB90
        .byte   $AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA ; CB98
        .byte   $AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA ; CBA0
        .byte   $AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA ; CBA8
        .byte   $AA,$AA,$AA,$AA,$AA,$AA,$AA,$96 ; CBB0
        .byte   $AA,$AA,$AA,$AA,$AA,$AA,$A6,$99 ; CBB8
        .byte   $AA,$AA,$AA,$AA,$AA,$AA,$4A,$52 ; CBC0
        .byte   $AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA ; CBC8
        .byte   $AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA ; CBD0
        .byte   $AA,$AA,$A8,$AA,$AA,$AA,$AA,$AA ; CBD8
        .byte   $AA,$AA,$88,$AA,$AA,$AA,$AA,$AA ; CBE0
        .byte   $AA,$A2,$8A,$AA,$AA,$AA,$AA,$AA ; CBE8
        .byte   $AA,$2A,$AA,$AA,$AA,$AA,$AA,$AA ; CBF0
        .byte   $AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA ; CBF8
        .byte   $AA,$AA,$AA,$8A,$AA,$AA,$AA,$AA ; CC00
        .byte   $AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA ; CC08
        .byte   $AA,$AA,$AA,$AA,$AA,$AA,$AA,$A8 ; CC10
        .byte   $AA,$AA,$AA,$AA,$AA,$AA,$A2,$8A ; CC18
        .byte   $AA,$AA,$AA,$A8,$A2,$AA,$AA,$AA ; CC20
        .byte   $F9,$F8,$FA,$F8,$C9,$E3,$E7,$E3 ; CC28
        .byte   $FC,$FC,$FC,$FC,$FC,$FE,$F9,$FC ; CC30
        .byte   $AA,$AA,$A9,$97,$7C,$C0,$00,$00 ; CC38
        .byte   $2B,$BC,$C0,$00,$00,$00,$00,$00 ; CC40
        .byte   $3F,$3F,$3F,$3F,$3F,$3F,$3F,$3F ; CC48
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; CC50
        .byte   $E0,$E0,$E0,$E0,$E0,$E0,$E0,$20 ; CC58
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; CC60
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; CC68
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; CC70
        .byte   $02,$02,$02,$02,$02,$02,$02,$02 ; CC78
        .byte   $C0,$C0,$C0,$C0,$F0,$F0,$F0,$F0 ; CC80
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; CC88
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; CC90
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; CC98
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; CCA0
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; CCA8
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; CCB0
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; CCB8
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; CCC0
        .byte   $3F,$3F,$3F,$3F,$3F,$3F,$3F,$3F ; CCC8
        .byte   $AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA ; CCD0
        .byte   $AA,$AA,$AA,$AA,$A8,$AA,$AA,$AA ; CCD8
        .byte   $AA,$A2,$AA,$AA,$AA,$AA,$AA,$AA ; CCE0
        .byte   $A8,$8F,$31,$F6,$CA,$28,$A3,$8F ; CCE8
        .byte   $F1,$98,$37,$90,$72,$CB,$23,$A3 ; CCF0
        .byte   $12,$AF,$9B,$49,$BA,$2C,$DF,$EF ; CCF8
        .byte   $7F,$9B,$E2,$FC,$9F,$AB,$22,$AA ; CD00
        .byte   $2A,$EA,$2A,$8A,$22,$AA,$2A,$AA ; CD08
        .byte   $AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA ; CD10
        .byte   $AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA ; CD18
        .byte   $AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA ; CD20
        .byte   $AA,$AA,$AA,$AA,$A2,$2A,$AA,$AA ; CD28
        .byte   $AA,$AA,$A2,$AA,$2A,$AA,$AA,$AA ; CD30
        .byte   $AA,$AA,$2A,$AA,$AA,$AA,$AA,$AA ; CD38
        .byte   $AA,$AA,$AA,$AA,$AA,$AA,$AA,$A8 ; CD40
        .byte   $A2,$8A,$AA,$AA,$AA,$AA,$2A,$AA ; CD48
        .byte   $AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA ; CD50
        .byte   $AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA ; CD58
        .byte   $AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA ; CD60
        .byte   $D7,$D3,$DB,$D3,$DB,$D3,$D7,$D3 ; CD68
        .byte   $A8,$A8,$A8,$A8,$A8,$A8,$A8,$A8 ; CD70
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; CD78
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; CD80
        .byte   $3F,$3F,$3F,$3F,$3F,$3F,$3F,$3C ; CD88
        .byte   $FC,$F0,$F0,$C0,$C0,$00,$00,$00 ; CD90
        .byte   $30,$30,$30,$30,$30,$30,$30,$30 ; CD98
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; CDA0
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; CDA8
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; CDB0
        .byte   $03,$03,$03,$03,$03,$0F,$0F,$0F ; CDB8
        .byte   $A0,$A0,$A0,$A0,$A0,$A0,$A8,$A8 ; CDC0
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; CDC8
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; CDD0
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; CDD8
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; CDE0
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; CDE8
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; CDF0
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; CDF8
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; CE00
        .byte   $3F,$3F,$3F,$3F,$3F,$3F,$3F,$3F ; CE08
        .byte   $AA,$AA,$AA,$A2,$AA,$AA,$AA,$AA ; CE10
        .byte   $AA,$AA,$0A,$AA,$AA,$AA,$AA,$AA ; CE18
        .byte   $AA,$AA,$AA,$AA,$AA,$AA,$AA,$A9 ; CE20
        .byte   $14,$88,$AA,$AA,$AA,$BB,$EE,$95 ; CE28
        .byte   $83,$88,$A8,$AA,$2A,$58,$F1,$FA ; CE30
        .byte   $C3,$F0,$32,$32,$AC,$AC,$AC,$AC ; CE38
        .byte   $2A,$AA,$2A,$AA,$AA,$AA,$AA,$AA ; CE40
        .byte   $AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA ; CE48
        .byte   $AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA ; CE50
        .byte   $AA,$AA,$AA,$AA,$AA,$A8,$AA,$AA ; CE58
        .byte   $AA,$A8,$AA,$AA,$22,$AA,$AA,$AA ; CE60
        .byte   $A8,$8A,$AA,$AA,$2A,$AA,$AA,$AA ; CE68
        .byte   $AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA ; CE70
        .byte   $AA,$AA,$AA,$AA,$AB,$BA,$E9,$A5 ; CE78
        .byte   $8A,$AA,$AA,$AA,$EA,$6E,$5B,$56 ; CE80
        .byte   $AA,$AA,$AA,$AA,$AB,$AE,$B9,$A6 ; CE88
        .byte   $AA,$AA,$AA,$AA,$BF,$E5,$55,$56 ; CE90
        .byte   $AA,$AA,$AA,$AA,$AA,$BA,$9A,$66 ; CE98
        .byte   $AA,$A2,$8A,$AA,$AA,$AA,$AA,$AA ; CEA0
        .byte   $DB,$13,$DB,$D3,$DB,$D3,$DB,$D3 ; CEA8
        .byte   $28,$A8,$A8,$A8,$A8,$A8,$A8,$A8 ; CEB0
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; CEB8
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; CEC0
        .byte   $28,$20,$20,$00,$00,$00,$00,$00 ; CEC8
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; CED0
        .byte   $30,$00,$00,$00,$00,$00,$00,$00 ; CED8
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; CEE0
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; CEE8
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; CEF0
        .byte   $0F,$0F,$0F,$0F,$0F,$0F,$3F,$3F ; CEF8
        .byte   $A8,$A8,$A8,$A8,$A8,$A8,$AA,$8A ; CF00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; CF08
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; CF10
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; CF18
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; CF20
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; CF28
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; CF30
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; CF38
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; CF40
        .byte   $0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F ; CF48
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$F3 ; CF50
        .byte   $AA,$AA,$AA,$AA,$AA,$AA,$AA,$2A ; CF58
        .byte   $A2,$AA,$A9,$AA,$AA,$AA,$AA,$2A ; CF60
        .byte   $65,$65,$99,$A9,$A9,$A9,$A8,$2A ; CF68
        .byte   $66,$66,$29,$8A,$AA,$2A,$6A,$6A ; CF70
        .byte   $A9,$A9,$A9,$A9,$A9,$A9,$A9,$A8 ; CF78
        .byte   $2A,$2A,$2A,$2A,$2A,$2A,$2A,$4A ; CF80
        .byte   $AA,$AA,$AA,$AA,$AA,$2A,$AA,$AA ; CF88
        .byte   $AA,$AA,$A8,$8A,$2A,$AA,$AA,$AA ; CF90
        .byte   $AA,$88,$AA,$AA,$AA,$AA,$AA,$AA ; CF98
        .byte   $AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA ; CFA0
        .byte   $AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA ; CFA8
        .byte   $AA,$AA,$A8,$A2,$AA,$AA,$AA,$AA ; CFB0
        .byte   $FB,$EE,$88,$AA,$AA,$AA,$AA,$AA ; CFB8
        .byte   $EF,$EB,$CA,$3A,$BA,$BA,$8E,$2C ; CFC0
        .byte   $A6,$99,$AA,$AA,$AA,$AA,$AA,$AA ; CFC8
        .byte   $FE,$BE,$BA,$BA,$BA,$BA,$BA,$BA ; CFD0
        .byte   $EA,$BA,$AA,$AA,$AA,$AA,$AA,$AA ; CFD8
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$CC ; CFE0
        .byte   $DB,$D3,$D7,$D3,$DB,$D3,$DB,$D3 ; CFE8
        .byte   $A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0 ; CFF0
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; CFF8
sprite_0_x:
        .byte   $00                             ; D000
sprite_0_y:
        .byte   $00                             ; D001
sprite_1_x:
        .byte   $00                             ; D002
sprite_1_y:
        .byte   $00                             ; D003
sprite_2_x:
        .byte   $00                             ; D004
sprite_2_y:
        .byte   $00                             ; D005
sprite_3_x:
        .byte   $00                             ; D006
sprite_3_y:
        .byte   $00                             ; D007
sprite_4_x:
        .byte   $00                             ; D008
sprite_4_y:
        .byte   $00                             ; D009
sprite_5_x:
        .byte   $00                             ; D00A
sprite_5_y:
        .byte   $00                             ; D00B
sprite_6_x:
        .byte   $00                             ; D00C
sprite_6_y:
        .byte   $00                             ; D00D
sprite_7_x:
        .byte   $00                             ; D00E
sprite_7_y:
        .byte   $00                             ; D00F
LD010:  .byte   $00                             ; D010
yscroll:.byte   $00                             ; D011
LD012:  .byte   $00,$00,$00                     ; D012
LD015:  .byte   $00                             ; D015
xscroll:.byte   $00                             ; D016
LD017:  .byte   $00                             ; D017
screen_and_charset:
        .byte   $00                             ; D018
LD019:  .byte   $00                             ; D019
LD01A:  .byte   $00,$00                         ; D01A
LD01C:  .byte   $00                             ; D01C
LD01D:  .byte   $00,$00,$00                     ; D01D
border_color:
        .byte   $00                             ; D020
background_color_0:
        .byte   $00                             ; D021
background_color_1:
        .byte   $00                             ; D022
background_color_2:
        .byte   $00                             ; D023
background_color_3:
        .byte   $00                             ; D024
sprite_multicolor_0:
        .byte   $00                             ; D025
sprite_multicolor_1:
        .byte   $00                             ; D026
sprite_0_color:
        .byte   $00                             ; D027
sprite_1_color:
        .byte   $00                             ; D028
sprite_2_color:
        .byte   $00                             ; D029
sprite_3_color:
        .byte   $00                             ; D02A
sprite_4_color:
        .byte   $00                             ; D02B
sprite_5_color:
        .byte   $00                             ; D02C
sprite_6_color:
        .byte   $00                             ; D02D
sprite_7_color:
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; D02E
        .byte   $00,$00,$2A,$2A,$2A,$2A,$2A,$2A ; D036
        .byte   $AA,$A2,$8A,$8A,$8A,$8A,$8A,$8A ; D03E
        .byte   $8E,$8E,$00,$00,$00,$00,$00,$C0 ; D046
        .byte   $C0,$C0,$00,$00,$00,$00,$00,$00 ; D04E
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; D056
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; D05E
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; D066
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; D06E
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; D076
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; D07E
        .byte   $00,$00,$02,$02,$02,$02,$02,$02 ; D086
        .byte   $02,$02,$FF,$FF,$FF,$FF,$FF,$FF ; D08E
        .byte   $FF,$FF,$88,$AA,$AA,$AA,$AA,$AA ; D096
        .byte   $AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA ; D09E
        .byte   $AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA ; D0A6
        .byte   $AA,$AA,$EA,$E8,$EA,$EA,$EA,$EA ; D0AE
        .byte   $EA,$EA,$AA,$8A,$AA,$AA,$AA,$AA ; D0B6
        .byte   $AA,$AA,$CA,$CA,$CA,$C8,$CA,$CA ; D0BE
        .byte   $CA,$CA,$AA,$AA,$A2,$AA,$AA,$AA ; D0C6
        .byte   $AA,$AA,$AA,$22,$AA,$AA,$AA,$AA ; D0CE
        .byte   $AA,$AA,$AA,$2A,$AA,$AA,$AA,$AA ; D0D6
        .byte   $AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA ; D0DE
        .byte   $AA,$AA,$AA,$22,$AA,$AA,$AA,$AA ; D0E6
        .byte   $AA,$AA,$AA,$22,$AA,$AA,$AA,$AA ; D0EE
        .byte   $AA,$AA,$88,$2A,$AA,$AA,$AA,$AA ; D0F6
        .byte   $AA,$AA,$AE,$A3,$AB,$A8,$AA,$AA ; D0FE
        .byte   $AA,$AA,$AA,$AA,$AA,$EA,$EA,$3A ; D106
        .byte   $8E,$A3,$BA,$3A,$CA,$EA,$EA,$EA ; D10E
        .byte   $EA,$EA,$AA,$AA,$AA,$AA,$AA,$AA ; D116
        .byte   $AA,$AA,$FF,$FF,$FF,$FF,$FF,$FF ; D11E
        .byte   $FF,$FF,$EB,$E3,$8F,$AF,$8F,$9F ; D126
        .byte   $8F,$AF,$80,$80,$80,$80,$80,$80 ; D12E
        .byte   $80,$80,$00,$00,$00,$00,$00,$00 ; D136
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; D13E
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; D146
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; D14E
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; D156
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; D15E
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; D166
        .byte   $00,$00,$00,$00,$00,$00,$00,$03 ; D16E
        .byte   $03,$03,$A2,$A2,$A2,$A2,$A2,$A2 ; D176
        .byte   $B2,$B2,$86,$82,$86,$86,$85,$85 ; D17E
        .byte   $80,$8A,$C0,$C0,$C0,$F0,$F0,$F0 ; D186
        .byte   $F0,$F0,$00,$00,$00,$00,$00,$00 ; D18E
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; D196
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; D19E
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; D1A6
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; D1AE
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; D1B6
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; D1BE
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; D1C6
        .byte   $00,$00,$AA,$03,$FF,$FF,$57,$7F ; D1CE
        .byte   $57,$7F,$FF,$55,$55,$55,$A9,$99 ; D1D6
        .byte   $A5,$99,$AA,$55,$55,$55,$7F,$75 ; D1DE
        .byte   $7F,$75,$AA,$55,$55,$55,$57,$DD ; D1E6
        .byte   $5F,$75,$AA,$55,$55,$55,$55,$D7 ; D1EE
        .byte   $D7,$77,$AA,$55,$55,$55,$F7,$57 ; D1F6
        .byte   $57,$57,$FF,$55,$55,$55,$A6,$56 ; D1FE
        .byte   $A6,$56,$52,$A0,$AA,$AA,$FA,$BA ; D206
        .byte   $EA,$BA,$AA,$00,$AB,$BF,$BC,$BF ; D20E
        .byte   $B3,$BF,$FF,$00,$FF,$01,$A0,$AA ; D216
        .byte   $EA,$56,$FF,$00,$FF,$C2,$0E,$AA ; D21E
        .byte   $AA,$A5,$FF,$00,$FF,$AA,$EE,$AA ; D226
        .byte   $AA,$B9,$FF,$00,$FF,$55,$55,$47 ; D22E
        .byte   $55,$A9,$FF,$00,$FF,$57,$57,$57 ; D236
        .byte   $77,$57,$FF,$00,$FF,$FF,$FF,$FF ; D23E
        .byte   $FF,$F5,$FF,$00,$FF,$FF,$FF,$FF ; D246
        .byte   $FD,$96,$AA,$00,$AA,$AA,$AA,$65 ; D24E
        .byte   $DF,$5D,$AA,$00,$AA,$AA,$AB,$ED ; D256
        .byte   $77,$5F,$A3,$05,$A3,$A3,$A3,$63 ; D25E
        .byte   $A3,$55,$AA,$00,$AA,$AA,$AA,$AA ; D266
        .byte   $AA,$FF,$00,$00,$00,$00,$00,$00 ; D26E
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; D276
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; D27E
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; D286
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; D28E
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; D296
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; D29E
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; D2A6
        .byte   $00,$00,$03,$03,$03,$0F,$0F,$0F ; D2AE
        .byte   $0F,$0F,$92,$82,$92,$92,$12,$52 ; D2B6
        .byte   $02,$A2,$8E,$86,$86,$86,$86,$86 ; D2BE
        .byte   $86,$86,$FC,$3C,$BC,$3C,$8F,$0F ; D2C6
        .byte   $8F,$0F,$00,$00,$00,$00,$00,$00 ; D2CE
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; D2D6
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; D2DE
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; D2E6
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; D2EE
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; D2F6
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; D2FE
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; D306
        .byte   $00,$00,$56,$2A,$2A,$3E,$0A,$0E ; D30E
        .byte   $02,$02,$77,$FF,$FF,$AB,$BB,$AF ; D316
        .byte   $BB,$BB,$EF,$FF,$FF,$D5,$DF,$D5 ; D31E
        .byte   $DF,$DF,$EF,$FF,$FF,$FD,$77,$F5 ; D326
        .byte   $DF,$DF,$BA,$AA,$AA,$AA,$69,$69 ; D32E
        .byte   $99,$9A,$F7,$55,$55,$A6,$56,$56 ; D336
        .byte   $56,$A6,$5D,$FF,$FF,$AE,$FE,$AE ; D33E
        .byte   $FE,$AE,$9A,$AA,$AA,$FA,$BA,$EA ; D346
        .byte   $BA,$BA,$D5,$DD,$D1,$D6,$D1,$E5 ; D34E
        .byte   $D5,$D9,$96,$A9,$99,$96,$96,$75 ; D356
        .byte   $55,$95,$59,$D9,$5A,$65,$65,$D7 ; D35E
        .byte   $55,$9E,$D7,$D7,$DB,$D7,$D7,$55 ; D366
        .byte   $58,$55,$AE,$AE,$AE,$BA,$EA,$AA ; D36E
        .byte   $A6,$FE,$3E,$FE,$3E,$EE,$3E,$FE ; D376
        .byte   $CE,$CE,$A7,$AD,$AF,$A5,$AF,$AD ; D37E
        .byte   $A5,$A5,$AF,$BB,$FD,$F9,$B9,$B5 ; D386
        .byte   $65,$96,$96,$6B,$EF,$EE,$BE,$BF ; D38E
        .byte   $FA,$FA,$6A,$EA,$EA,$EA,$FB,$FB ; D396
        .byte   $FF,$FF,$AA,$FA,$FB,$FB,$FF,$BE ; D39E
        .byte   $BA,$BA,$FC,$5C,$5C,$5C,$70,$70 ; D3A6
        .byte   $40,$40,$00,$00,$00,$00,$00,$00 ; D3AE
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; D3B6
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; D3BE
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; D3C6
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; D3CE
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; D3D6
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; D3DE
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; D3E6
        .byte   $00,$00,$3F,$3C,$3E,$3E,$FE,$F2 ; D3EE
        .byte   $FA,$FA,$52,$42,$72,$72,$42,$52 ; D3F6
        .byte   $72,$52                         ; D3FE
LD400:  .byte   $86                             ; D400
LD401:  .byte   $86                             ; D401
LD402:  .byte   $86                             ; D402
LD403:  .byte   $86,$86                         ; D403
LD405:  .byte   $86                             ; D405
LD406:  .byte   $86,$86,$8F,$07,$87,$07,$C5,$05 ; D406
        .byte   $C5,$05,$C0,$C0,$C0,$F0,$F0     ; D40E
LD415:  .byte   $F0                             ; D415
LD416:  .byte   $BC                             ; D416
LD417:  .byte   $BC                             ; D417
LD418:  .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; D418
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; D420
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; D428
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; D430
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; D438
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; D440
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; D448
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; D450
        .byte   $FF,$FF,$2B,$3B,$0F,$03,$03,$00 ; D458
        .byte   $FF,$FF,$D5,$DF,$D5,$DF,$DF,$FF ; D460
        .byte   $FF,$FF,$FE,$BB,$FA,$EF,$EF,$FF ; D468
        .byte   $FF,$FF,$FF,$BE,$BE,$EE,$EF,$FF ; D470
        .byte   $AA,$AA,$59,$A9,$A9,$A9,$59,$AA ; D478
        .byte   $FF,$FF,$5D,$FD,$5D,$FD,$5D,$FF ; D480
        .byte   $AA,$AA,$5A,$9A,$6A,$9A,$9A,$AA ; D488
        .byte   $D5,$D9,$D5,$D5,$D5,$DD,$D5,$FF ; D490
        .byte   $5D,$77,$7F,$7B,$7F,$7B,$F3,$FF ; D498
        .byte   $7D,$7D,$7D,$7D,$77,$77,$F3,$FC ; D4A0
        .byte   $7D,$9D,$9D,$5D,$DF,$DF,$FC,$FF ; D4A8
        .byte   $AA,$AA,$BB,$AE,$EE,$BA,$6A,$AA ; D4B0
        .byte   $FE,$3E,$FE,$FA,$BE,$FE,$FE,$AA ; D4B8
        .byte   $AF,$AF,$AA,$AA,$95,$55,$55,$95 ; D4C0
        .byte   $55,$55,$AA,$AA,$EA,$FA,$FA,$EA ; D4C8
        .byte   $55,$55,$AA,$AA,$FF,$BB,$BB,$AA ; D4D0
        .byte   $AA,$AA,$55,$55,$55,$FF,$F7,$5C ; D4D8
        .byte   $FF,$FF,$50,$58,$60,$80,$00,$00 ; D4E0
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; D4E8
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; D4F0
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; D4F8
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; D500
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; D508
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; D510
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; D518
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; D520
        .byte   $03,$03,$03,$0F,$0F,$0F,$3F,$3C ; D528
        .byte   $F5,$C5,$D5,$DB,$2E,$79,$6F,$55 ; D530
        .byte   $52,$F2,$F2,$F2,$62,$B2,$62,$F2 ; D538
        .byte   $82,$80,$88,$82,$8A,$82,$88,$8E ; D540
        .byte   $C0,$F5,$3C,$0F,$C3,$F0,$CC,$BB ; D548
        .byte   $3F,$AF,$4F,$C3,$37,$DD,$34,$05 ; D550
        .byte   $00,$00,$C0,$C0,$F0,$F0,$FC,$7C ; D558
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; D560
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; D568
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; D570
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; D578
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; D580
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; D588
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; D590
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; D598
        .byte   $3F,$03,$00,$00,$00,$00,$00,$00 ; D5A0
        .byte   $55,$55,$3F,$02,$00,$00,$00,$00 ; D5A8
        .byte   $55,$55,$AA,$FF,$00,$00,$00,$00 ; D5B0
        .byte   $55,$55,$AA,$FF,$00,$FF,$00,$00 ; D5B8
        .byte   $55,$55,$AA,$FF,$00,$FF,$00,$00 ; D5C0
        .byte   $55,$55,$A1,$F1,$01,$FF,$00,$00 ; D5C8
        .byte   $AA,$55,$AA,$FF,$00,$FF,$00,$00 ; D5D0
        .byte   $AA,$55,$AA,$FF,$00,$FF,$00,$00 ; D5D8
        .byte   $AA,$55,$AA,$FF,$00,$FF,$00,$00 ; D5E0
        .byte   $AA,$55,$AA,$FF,$00,$FF,$00,$00 ; D5E8
        .byte   $AA,$55,$AA,$FF,$00,$FF,$00,$00 ; D5F0
        .byte   $AA,$55,$AA,$FF,$00,$FF,$00,$00 ; D5F8
        .byte   $AA,$55,$AA,$FF,$00,$FF,$00,$00 ; D600
        .byte   $FF,$55,$FF,$AA,$00,$00,$00,$00 ; D608
        .byte   $FF,$55,$F4,$80,$00,$00,$00,$00 ; D610
        .byte   $E0,$80,$00,$00,$00,$00,$00,$00 ; D618
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; D620
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; D628
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; D630
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; D638
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; D640
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; D648
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; D650
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; D658
        .byte   $00,$00,$03,$03,$0F,$0F,$3F,$3D ; D660
        .byte   $FD,$F0,$F5,$E0,$C0,$AA,$A8,$A0 ; D668
        .byte   $55,$00,$54,$A0,$03,$0E,$3A,$EA ; D670
        .byte   $42,$02,$22,$B2,$02,$F2,$F2,$F2 ; D678
        .byte   $83,$8C,$8F,$8F,$8F,$8F,$8F,$8F ; D680
        .byte   $22,$88,$AA,$AA,$AA,$AA,$AA,$AA ; D688
        .byte   $83,$E0,$F8,$FE,$FF,$FF,$FF,$FC ; D690
        .byte   $BF,$AF,$2F,$0B,$C2,$B0,$8C,$0F ; D698
        .byte   $00,$00,$C0,$C0,$F0,$FC,$3F,$0F ; D6A0
        .byte   $00,$00,$00,$00,$00,$00,$00,$C0 ; D6A8
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; D6B0
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; D6B8
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; D6C0
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; D6C8
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; D6D0
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; D6D8
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; D6E0
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; D6E8
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; D6F0
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; D6F8
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; D700
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; D708
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; D710
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; D718
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; D720
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; D728
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; D730
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; D738
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; D740
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; D748
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; D750
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; D758
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; D760
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; D768
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; D770
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; D778
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; D780
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; D788
        .byte   $00,$00,$00,$00,$00,$00,$00,$03 ; D790
        .byte   $00,$00,$03,$03,$0F,$3F,$FC,$F0 ; D798
        .byte   $FE,$FA,$F8,$E0,$C3,$0E,$32,$F0 ; D7A0
        .byte   $83,$0E,$3A,$EA,$AA,$AA,$AA,$2A ; D7A8
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; D7B0
        .byte   $F2,$F2,$F2,$F2,$F2,$F2,$F2,$F2 ; D7B8
        .byte   $8F,$8F,$8F,$8F,$88,$80,$82,$8A ; D7C0
        .byte   $AA,$AA,$A0,$80,$03,$3F,$FF,$FF ; D7C8
        .byte   $A0,$03,$0E,$FA,$FF,$FF,$FF,$FF ; D7D0
        .byte   $3A,$EA,$AA,$AA,$FF,$FF,$FF,$FF ; D7D8
        .byte   $C3,$B0,$AC,$AB,$FF,$FF,$FF,$FF ; D7E0
        .byte   $F0,$FC,$3F,$0F,$C3,$F0,$CC,$0F ; D7E8
        .byte   $00,$00,$00,$C0,$F0,$FC,$3F,$0F ; D7F0
        .byte   $00,$00,$00,$00,$00,$00,$00,$80 ; D7F8
color_ram:
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; D800
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; D808
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; D810
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; D818
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; D820
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; D828
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; D830
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; D838
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; D840
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; D848
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; D850
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; D858
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; D860
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; D868
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; D870
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; D878
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; D880
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; D888
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; D890
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; D898
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; D8A0
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; D8A8
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; D8B0
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; D8B8
        .byte   $00,$00,$00,$00,$00,$00,$00,$03 ; D8C0
        .byte   $00,$00,$00,$03,$0F,$3F,$FC,$F0 ; D8C8
        .byte   $0F,$3F,$FC,$F0,$C3,$03,$3C,$FC ; D8D0
        .byte   $C3,$0E,$3A,$EA,$FF,$FF,$FF,$3F ; D8D8
        .byte   $AC,$AB,$AA,$AA,$FF,$FF,$FF,$FF ; D8E0
        .byte   $0A,$C0,$B0,$AF,$FF,$FF,$FF,$FF ; D8E8
        .byte   $FF,$FF,$0F,$03,$A0,$A8,$AA,$AA ; D8F0
        .byte   $A3,$A3,$A3,$A3,$33,$03,$C3,$F3 ; D8F8
        .byte   $8A,$8A,$8A,$8A,$8A,$8A,$8A,$8A ; D900
        .byte   $AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA ; D908
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FC,$F0 ; D910
        .byte   $FF,$FF,$FF,$FF,$F3,$03,$0F,$FF ; D918
        .byte   $FC,$C0,$28,$AA,$AA,$69,$41,$69 ; D920
        .byte   $3F,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; D928
        .byte   $C3,$F0,$FC,$FF,$FF,$FF,$FF,$FF ; D930
        .byte   $F0,$FF,$3F,$0F,$C0,$F0,$FC,$FF ; D938
        .byte   $00,$00,$F0,$FF,$FF,$0F,$30,$0F ; D940
        .byte   $00,$00,$00,$00,$A8,$AA,$AA,$02 ; D948
        .byte   $00,$00,$00,$00,$00,$A8,$AA,$AA ; D950
        .byte   $00,$00,$00,$00,$00,$00,$AA,$AA ; D958
        .byte   $00,$00,$00,$00,$00,$00,$00,$AA ; D960
        .byte   $00,$00,$00,$00,$00,$00,$00,$80 ; D968
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; D970
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; D978
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; D980
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; D988
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; D990
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; D998
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; D9A0
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; D9A8
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; D9B0
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; D9B8
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; D9C0
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; D9C8
        .byte   $00,$00,$00,$00,$00,$00,$00,$0A ; D9D0
        .byte   $00,$00,$00,$00,$00,$00,$00,$AA ; D9D8
        .byte   $00,$00,$00,$00,$00,$00,$AA,$AA ; D9E0
        .byte   $00,$00,$00,$00,$00,$2A,$AA,$AA ; D9E8
        .byte   $00,$00,$00,$00,$3F,$FF,$FF,$C0 ; D9F0
        .byte   $00,$00,$0F,$FF,$FF,$F0,$0C,$F0 ; D9F8
        .byte   $0F,$FF,$FC,$F0,$03,$0F,$3F,$FF ; DA00
        .byte   $C3,$0F,$3F,$FF,$FF,$FF,$FF,$FF ; DA08
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; DA10
        .byte   $03,$C0,$FC,$FF,$FF,$FF,$FF,$FF ; DA18
        .byte   $FF,$FF,$3F,$0F,$C3,$F0,$FC,$FF ; DA20
        .byte   $AA,$AA,$AA,$AA,$AA,$AA,$2A,$0A ; DA28
        .byte   $AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA ; DA30
        .byte   $F3,$F3,$F3,$F3,$F3,$F3,$F3,$F3 ; DA38
        .byte   $CF,$CF,$CF,$CF,$CF,$CF,$CC,$00 ; DA40
        .byte   $AA,$AA,$A8,$A0,$82,$0A,$2A,$00 ; DA48
        .byte   $82,$0A,$2A,$AA,$AA,$AA,$AA,$00 ; DA50
        .byte   $AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA ; DA58
        .byte   $EB,$AA,$BE,$BE,$BE,$AA,$BE,$69 ; DA60
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$00 ; DA68
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$00 ; DA70
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$00 ; DA78
        .byte   $C3,$F0,$FC,$FF,$FF,$FC,$F0,$00 ; DA80
        .byte   $FC,$CF,$3C,$0C,$CC,$FC,$FC,$00 ; DA88
        .byte   $03,$FC,$F3,$C3,$CF,$0F,$3F,$00 ; DA90
        .byte   $FF,$00,$FF,$FF,$FF,$FF,$FF,$00 ; DA98
        .byte   $FF,$FF,$00,$FF,$FF,$FF,$FF,$00 ; DAA0
        .byte   $FF,$FF,$3F,$C0,$FF,$FF,$FF,$00 ; DAA8
        .byte   $FF,$FF,$FF,$00,$FF,$FF,$FF,$00 ; DAB0
        .byte   $FF,$FF,$FF,$00,$FF,$FF,$FF,$00 ; DAB8
        .byte   $FF,$FF,$FF,$00,$FF,$FF,$FF,$00 ; DAC0
        .byte   $FF,$FF,$FF,$00,$FF,$FF,$FF,$00 ; DAC8
        .byte   $FF,$FF,$FF,$00,$FF,$FF,$FF,$00 ; DAD0
        .byte   $FF,$FF,$FF,$00,$FF,$FF,$FF,$00 ; DAD8
        .byte   $FF,$FF,$FF,$00,$FF,$FF,$FF,$00 ; DAE0
        .byte   $FF,$FF,$FF,$00,$FF,$FF,$FF,$00 ; DAE8
        .byte   $FF,$FF,$FF,$00,$FF,$FF,$FF,$00 ; DAF0
        .byte   $FF,$FF,$FF,$00,$FF,$FF,$FF,$00 ; DAF8
        .byte   $FF,$FF,$FF,$00,$FF,$FF,$FF,$00 ; DB00
        .byte   $FF,$FF,$FF,$00,$FF,$FF,$FF,$00 ; DB08
        .byte   $FF,$FF,$F0,$0F,$FF,$FF,$FF,$00 ; DB10
        .byte   $FF,$FF,$00,$FF,$FF,$FF,$FF,$00 ; DB18
        .byte   $FF,$00,$FF,$FF,$FF,$FF,$FF,$00 ; DB20
        .byte   $C0,$3F,$CF,$C3,$F3,$F0,$FC,$00 ; DB28
        .byte   $3F,$F3,$3C,$30,$33,$3F,$3F,$00 ; DB30
        .byte   $C3,$0F,$3F,$FF,$FF,$3F,$0F,$02 ; DB38
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$AB,$BA ; DB40
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$00 ; DB48
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$00 ; DB50
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$00 ; DB58
        .byte   $AA,$AA,$AA,$AA,$AA,$AA,$AA,$00 ; DB60
        .byte   $82,$A0,$A8,$AA,$AA,$AA,$AA,$00 ; DB68
        .byte   $FF,$3F,$0F,$C3,$F0,$FC,$FF,$00 ; DB70
        .byte   $F3,$F3,$F3,$F3,$F3,$33,$F3,$00 ; DB78
        .byte   $00,$FF,$22,$88,$22,$88,$22,$88 ; DB80
        .byte   $00,$FF,$22,$88,$22,$88,$22,$88 ; DB88
        .byte   $00,$AA,$33,$CC,$33,$CC,$33,$CC ; DB90
        .byte   $2A,$AA,$3A,$CE,$33,$CC,$33,$CC ; DB98
        .byte   $C3,$EB,$AA,$AA,$29,$44,$11,$44 ; DBA0
        .byte   $00,$AA,$33,$CC,$33,$CC,$33,$CC ; DBA8
        .byte   $00,$AA,$33,$CC,$33,$CC,$33,$CC ; DBB0
        .byte   $00,$AA,$33,$CC,$33,$CC,$33,$CC ; DBB8
        .byte   $00,$AA,$33,$CC,$33,$CC,$33,$CC ; DBC0
        .byte   $00,$AA,$33,$CC,$33,$CC,$33,$CC ; DBC8
        .byte   $00,$AA,$33,$CC,$33,$CC,$33,$CC ; DBD0
        .byte   $00,$AA,$33,$CC,$33,$CC,$33,$CC ; DBD8
        .byte   $00,$AA,$33,$CC,$33,$CC,$33,$CC ; DBE0
        .byte   $00,$AA,$33,$CC,$33,$CC,$33,$CC ; DBE8
        .byte   $00,$AA,$33,$CC,$33,$CC,$33,$CC ; DBF0
        .byte   $00,$AA,$33,$CC,$33,$CC,$33,$CC ; DBF8
LDC00:  .byte   $00                             ; DC00
LDC01:  .byte   $AA                             ; DC01
LDC02:  .byte   $33                             ; DC02
LDC03:  .byte   $CC,$33,$CC,$33,$CC,$00,$AA,$33 ; DC03
        .byte   $CC,$33                         ; DC0B
LDC0D:  .byte   $CC,$33,$CC,$00,$AA,$33,$CC,$33 ; DC0D
        .byte   $CC,$33,$CC,$00,$AA,$33,$CC,$33 ; DC15
        .byte   $CC,$33,$CC,$00,$AA,$33,$CC,$33 ; DC1D
        .byte   $CC,$33,$CC,$00,$AA,$33,$CC,$33 ; DC25
        .byte   $CC,$33,$CC,$00,$AA,$33,$CC,$33 ; DC2D
        .byte   $CC,$33,$CC,$00,$AA,$33,$CC,$33 ; DC35
        .byte   $CC,$33,$CC,$00,$AA,$33,$CC,$33 ; DC3D
        .byte   $CC,$33,$CC,$00,$AA,$33,$CC,$33 ; DC45
        .byte   $CC,$33,$CC,$00,$AA,$33,$CC,$33 ; DC4D
        .byte   $CC,$33,$CC,$00,$AA,$33,$CC,$33 ; DC55
        .byte   $CC,$33,$CC,$00,$AA,$33,$CC,$33 ; DC5D
        .byte   $CC,$33,$CC,$00,$AA,$33,$CC,$33 ; DC65
        .byte   $CC,$33,$CC,$00,$A9,$31,$C5,$14 ; DC6D
        .byte   $41,$00,$C0,$56,$AA,$45,$17,$4C ; DC75
        .byte   $30,$C0,$3C,$95,$55,$45,$11,$7C ; DC7D
        .byte   $DF,$3F,$FF,$00,$5A,$53,$37,$7F ; DC85
        .byte   $FF,$FF,$F0,$00,$AA,$33,$CC,$F3 ; DC8D
        .byte   $CC,$03,$CC,$00,$AA,$33,$CC,$33 ; DC95
        .byte   $CC,$33,$CC,$00,$AA,$33,$CC,$33 ; DC9D
        .byte   $CC,$33,$CC,$00,$FF,$22,$88,$22 ; DCA5
        .byte   $88,$22,$88,$00,$FF,$22,$88,$22 ; DCAD
        .byte   $88,$22,$88,$00,$FF,$22,$88,$22 ; DCB5
        .byte   $88,$22,$88,$FF,$FF,$FF,$FF,$FF ; DCBD
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; DCC5
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; DCCD
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; DCD5
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; DCDD
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; DCE5
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; DCED
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; DCF5
        .byte   $FF,$FF,$FF                     ; DCFD
LDD00:  .byte   $FF,$FF                         ; DD00
LDD02:  .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; DD02
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; DD0A
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; DD12
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; DD1A
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; DD22
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; DD2A
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; DD32
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; DD3A
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; DD42
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; DD4A
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; DD52
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; DD5A
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; DD62
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; DD6A
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; DD72
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; DD7A
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; DD82
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; DD8A
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; DD92
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; DD9A
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; DDA2
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; DDAA
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; DDB2
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; DDBA
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; DDC2
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; DDCA
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; DDD2
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; DDDA
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; DDE2
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; DDEA
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; DDF2
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$00,$00 ; DDFA
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; DE02
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; DE0A
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; DE12
        .byte   $C0,$00,$01,$00,$00,$02,$00,$00 ; DE1A
        .byte   $0C,$00,$00,$10,$00,$00,$20,$00 ; DE22
        .byte   $00,$C0,$00,$01,$00,$00,$02,$00 ; DE2A
        .byte   $00,$0C,$00,$00,$10,$00,$00,$20 ; DE32
        .byte   $00,$00,$C0,$00,$00,$00,$00,$00 ; DE3A
        .byte   $C0,$00,$01,$C0,$00,$03,$C0,$00 ; DE42
        .byte   $0F,$C0,$00,$1F,$C0,$00,$3F,$C0 ; DE4A
        .byte   $00,$FF,$C0,$01,$FF,$C0,$03,$FF ; DE52
        .byte   $C0,$0F,$FF,$C0,$1F,$FF,$C0,$3F ; DE5A
        .byte   $FF,$C0,$7F,$FF,$C0,$7F,$FF,$C0 ; DE62
        .byte   $7F,$FF,$C0,$7F,$FF,$C0,$7F,$FF ; DE6A
        .byte   $C0,$7F,$FF,$C0,$7F,$FF,$C0,$7F ; DE72
        .byte   $FF,$C0,$7F,$FF,$C0,$00,$00,$00 ; DE7A
        .byte   $C0,$00,$01,$C0,$00,$03,$00,$00 ; DE82
        .byte   $0E,$00,$00,$1C,$00,$00,$30,$00 ; DE8A
        .byte   $00,$E0,$00,$01,$C0,$00,$03,$00 ; DE92
        .byte   $00,$0E,$00,$00,$1C,$00,$00,$30 ; DE9A
        .byte   $00,$00,$60,$00,$00,$C0,$00,$00 ; DEA2
        .byte   $00,$00,$00,$80,$00,$00,$80,$00 ; DEAA
        .byte   $00,$80,$00,$00,$80,$00,$00,$80 ; DEB2
        .byte   $00,$00,$80,$00,$00,$00,$80,$00 ; DEBA
        .byte   $00,$80,$00,$00,$80,$00,$00,$80 ; DEC2
        .byte   $00,$00,$80,$00,$00,$80,$00,$00 ; DECA
        .byte   $80,$00,$00,$80,$00,$00,$80,$00 ; DED2
        .byte   $00,$80,$00,$00,$80,$00,$00,$80 ; DEDA
        .byte   $00,$00,$80,$00,$00,$80,$00,$00 ; DEE2
        .byte   $80,$00,$00,$80,$00,$00,$80,$00 ; DEEA
        .byte   $00,$80,$00,$00,$00,$00,$00,$00 ; DEF2
        .byte   $00,$00,$00,$00,$00,$00,$7F,$FF ; DEFA
        .byte   $00,$7F,$FF,$00,$7F,$FF,$00,$7F ; DF02
        .byte   $FF,$00,$7F,$FF,$00,$7F,$FF,$00 ; DF0A
        .byte   $7F,$FF,$00,$7F,$FF,$00,$7F,$FF ; DF12
        .byte   $00,$7F,$FF,$00,$7F,$FF,$00,$7F ; DF1A
        .byte   $FF,$00,$7F,$FF,$00,$7F,$FF,$00 ; DF22
        .byte   $7F,$FF,$00,$00,$00,$00,$00,$00 ; DF2A
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; DF32
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; DF3A
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; DF42
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; DF4A
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; DF52
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; DF5A
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; DF62
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; DF6A
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; DF72
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; DF7A
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; DF82
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; DF8A
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; DF92
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; DF9A
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; DFA2
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; DFAA
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; DFB2
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; DFBA
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; DFC2
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; DFCA
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; DFD2
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; DFDA
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; DFE2
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; DFEA
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; DFF2
        .byte   $00,$00,$00,$00,$00,$00         ; DFFA
background_color:
        .byte   $5B,$5D,$D5,$5E,$5D,$D5,$5E,$D5 ; E000
        .byte   $38,$3B,$3B,$3B,$3B,$3B,$3B,$3B ; E008
        .byte   $3B,$3B,$3B,$3B,$3B,$3B,$3B,$3B ; E010
        .byte   $3B,$3B,$3B,$3B,$3B,$3B,$3B,$38 ; E018
        .byte   $38,$3B,$3B,$38,$38,$38,$38,$38 ; E020
        .byte   $5B,$5B,$5B,$5B,$5B,$5B,$5B,$5B ; E028
        .byte   $D5,$3B,$3B,$3B,$3B,$3B,$38,$38 ; E030
        .byte   $38,$38,$38,$38,$38,$38,$38,$38 ; E038
        .byte   $38,$38,$3B,$3B,$3B,$3B,$3B,$3B ; E040
        .byte   $3B,$38,$3B,$3B,$38,$38,$38,$38 ; E048
        .byte   $B5,$5B,$FB,$5D,$5B,$5B,$D5,$5D ; E050
        .byte   $5D,$3B,$3B,$3B,$38,$38,$38,$38 ; E058
        .byte   $38,$38,$38,$38,$38,$38,$38,$38 ; E060
        .byte   $38,$38,$38,$38,$3B,$3B,$3B,$3B ; E068
        .byte   $3B,$3B,$3B,$3B,$3B,$38,$38,$38 ; E070
        .byte   $38,$BF,$FB,$F5,$5F,$5F,$EB,$5D ; E078
        .byte   $15,$15,$15,$15,$35,$35,$B5,$B5 ; E080
        .byte   $35,$38,$38,$38,$38,$38,$38,$38 ; E088
        .byte   $38,$38,$38,$38,$38,$38,$3B,$3B ; E090
        .byte   $3B,$3B,$3B,$3F,$3B,$3B,$38,$38 ; E098
        .byte   $5B,$B5,$B5,$B5,$B5,$F5,$D5,$D5 ; E0A0
        .byte   $35,$35,$35,$A5,$B5,$B5,$B5,$35 ; E0A8
        .byte   $35,$35,$35,$35,$35,$35,$35,$35 ; E0B0
        .byte   $35,$35,$35,$35,$35,$38,$38,$3B ; E0B8
        .byte   $3B,$3B,$3B,$3F,$3B,$3B,$3B,$3E ; E0C0
        .byte   $BE,$3E,$B7,$BE,$F5,$F5,$35,$35 ; E0C8
        .byte   $35,$35,$35,$35,$35,$15,$15,$15 ; E0D0
        .byte   $15,$15,$15,$15,$15,$15,$15,$1F ; E0D8
        .byte   $F5,$F5,$F5,$F5,$B5,$B5,$D5,$D5 ; E0E0
        .byte   $D5,$D5,$F5,$F5,$FE,$BE,$BE,$5E ; E0E8
        .byte   $B5,$F5,$F5,$BE,$B7,$BA,$BA,$35 ; E0F0
        .byte   $35,$35,$35,$35,$35,$15,$15,$15 ; E0F8
        .byte   $35,$15,$15,$15,$15,$15,$15,$15 ; E100
        .byte   $15,$15,$15,$15,$D5,$D5,$B5,$D5 ; E108
        .byte   $DB,$BE,$BE,$BE,$3E,$3F,$FB,$FB ; E110
        .byte   $35,$35,$3F,$F5,$F5,$AF,$3A,$3A ; E118
        .byte   $3A,$3A,$35,$35,$35,$35,$35,$35 ; E120
        .byte   $35,$35,$35,$35,$35,$35,$35,$35 ; E128
        .byte   $35,$35,$35,$D5,$D5,$FB,$FB,$DB ; E130
        .byte   $3B,$35,$3E,$BF,$FB,$FB,$38,$3B ; E138
        .byte   $35,$35,$35,$35,$35,$FB,$B5,$B5 ; E140
        .byte   $35,$3F,$35,$35,$35,$35,$35,$35 ; E148
        .byte   $35,$35,$35,$35,$35,$35,$35,$35 ; E150
        .byte   $35,$35,$35,$35,$35,$75,$BF,$35 ; E158
        .byte   $B5,$B5,$B5,$5F,$35,$35,$35,$B5 ; E160
        .byte   $35,$35,$35,$35,$35,$3E,$35,$3F ; E168
        .byte   $F5,$BF,$35,$35,$35,$35,$D5,$D5 ; E170
        .byte   $B5,$35,$35,$35,$35,$35,$35,$35 ; E178
        .byte   $35,$35,$35,$35,$35,$FB,$BF,$F5 ; E180
        .byte   $3F,$35,$3E,$3F,$35,$35,$35,$3B ; E188
        .byte   $5E,$35,$35,$35,$35,$3E,$35,$35 ; E190
        .byte   $35,$3A,$35,$35,$35,$D5,$D5,$D5 ; E198
        .byte   $D5,$35,$35,$35,$35,$35,$35,$35 ; E1A0
        .byte   $35,$35,$35,$35,$35,$B7,$35,$35 ; E1A8
        .byte   $35,$35,$3E,$35,$35,$35,$35,$5A ; E1B0
        .byte   $5B,$3E,$3B,$3B,$3B,$3E,$3B,$35 ; E1B8
        .byte   $35,$3A,$35,$35,$D5,$B5,$D5,$35 ; E1C0
        .byte   $35,$35,$35,$35,$35,$35,$05,$B5 ; E1C8
        .byte   $B5,$B5,$B5,$B5,$35,$BF,$35,$35 ; E1D0
        .byte   $35,$3B,$BE,$B9,$B9,$B9,$3E,$5A ; E1D8
        .byte   $5B,$5E,$3B,$3B,$3B,$3E,$3E,$3B ; E1E0
        .byte   $3B,$3E,$3A,$F5,$B5,$B5,$B5,$B5 ; E1E8
        .byte   $B5,$35,$35,$35,$35,$35,$35,$35 ; E1F0
        .byte   $35,$B5,$35,$35,$3A,$B7,$35,$3B ; E1F8
        .byte   $3B,$3E,$BE,$B9,$B9,$BE,$9E,$3B ; E200
        .byte   $3B,$5E,$3E,$3B,$3B,$3B,$3E,$3B ; E208
        .byte   $3B,$35,$3E,$95,$A5,$A5,$A5,$A5 ; E210
        .byte   $A5,$35,$95,$A5,$35,$B5,$A5,$A5 ; E218
        .byte   $35,$A5,$75,$A5,$31,$FB,$35,$3B ; E220
        .byte   $3B,$BE,$B9,$B9,$B9,$3E,$5E,$3B ; E228
        .byte   $1B,$5E,$3E,$3B,$3B,$3B,$3B,$3E ; E230
        .byte   $3B,$3B,$21,$F2,$F1,$F1,$F1,$F1 ; E238
        .byte   $F5,$1F,$F1,$2E,$2E,$2E,$E2,$EF ; E240
        .byte   $B0,$BA,$B1,$A1,$B1,$01,$3B,$3B ; E248
        .byte   $3E,$3E,$B9,$B9,$BE,$3E,$5F,$1B ; E250
        .byte   $1B,$57,$3E,$3E,$3B,$3B,$3B,$3E ; E258
        .byte   $3E,$3B,$2F,$25,$25,$25,$2F,$F2 ; E260
        .byte   $52,$5F,$EB,$E2,$E2,$EB,$BE,$F1 ; E268
        .byte   $B1,$DB,$AB,$AB,$5B,$D5,$3B,$3E ; E270
        .byte   $3E,$3B,$B9,$BE,$3E,$3E,$F1,$6B ; E278
        .byte   $1B,$17,$71,$3E,$3B,$3B,$3B,$3B ; E280
        .byte   $3E,$3E,$1E,$12,$52,$25,$25,$5F ; E288
        .byte   $52,$5F,$EF,$2B,$2F,$2F,$BE,$F1 ; E290
        .byte   $21,$B1,$B1,$1B,$1F,$1E,$3E,$3E ; E298
        .byte   $3B,$3B,$3B,$1E,$1E,$1F,$1F,$FB ; E2A0
        .byte   $1B,$15,$51,$5E,$3E,$3B,$3B,$3B ; E2A8
        .byte   $3B,$3B,$3E,$3E,$1B,$F5,$F1,$F1 ; E2B0
        .byte   $F1,$F1,$F1,$F1,$F1,$F1,$F1,$F1 ; E2B8
        .byte   $F1,$F5,$F5,$3F,$3E,$3E,$3B,$3B ; E2C0
        .byte   $3B,$3B,$3E,$3E,$5E,$F5,$15,$1B ; E2C8
        .byte   $3B,$B5,$8B,$85,$5E,$5E,$3B,$3B ; E2D0
        .byte   $3B,$3B,$3B,$3B,$3E,$3E,$3E,$3E ; E2D8
        .byte   $3B,$3B,$3B,$B9,$B9,$B9,$3B,$3B ; E2E0
        .byte   $3B,$3E,$3E,$3E,$3B,$3B,$3B,$3B ; E2E8
        .byte   $3B,$3E,$5E,$5E,$35,$35,$3B,$3B ; E2F0
        .byte   $3B,$85,$85,$85,$35,$5E,$5E,$5B ; E2F8
        .byte   $3B,$3B,$3B,$3B,$3B,$3B,$3B,$3E ; E300
        .byte   $3E,$3E,$B3,$B3,$B3,$B3,$B3,$3E ; E308
        .byte   $3E,$3B,$3B,$3B,$3B,$3B,$3B,$3E ; E310
        .byte   $5E,$5E,$5E,$35,$35,$35,$3B,$35 ; E318
        .byte   $3B,$EB,$EA,$35,$47,$47,$37,$5E ; E320
        .byte   $5F,$5B,$5B,$5B,$5B,$5B,$3B,$3B ; E328
        .byte   $3B,$3B,$3B,$3B,$3B,$3B,$3B,$3B ; E330
        .byte   $3B,$3B,$5B,$5B,$5B,$5B,$5E,$5E ; E338
        .byte   $5E,$35,$35,$35,$35,$3B,$3B,$35 ; E340
        .byte   $35,$AB,$AB,$3B,$87,$47,$37,$3F ; E348
        .byte   $3F,$35,$35,$35,$35,$35,$35,$35 ; E350
        .byte   $35,$35,$35,$35,$35,$35,$35,$35 ; E358
        .byte   $35,$35,$35,$35,$35,$35,$35,$38 ; E360
        .byte   $38,$35,$35,$35,$3B,$3B,$35,$35 ; E368
        .byte   $E5,$85,$8B,$8B,$57,$4B,$EB,$FB ; E370
        .byte   $FB,$EB,$EB,$EB,$EB,$EB,$EB,$EB ; E378
        .byte   $3B,$3B,$3B,$3B,$3B,$3B,$3B,$EB ; E380
        .byte   $EB,$EB,$EB,$EB,$EB,$EB,$8B,$8B ; E388
        .byte   $8B,$8B,$EB,$EB,$EB,$E5,$E5,$E5 ; E390
LE398:  .byte   $38,$38,$38,$38,$38,$38,$38,$38 ; E398
        .byte   $38,$38,$38,$38,$38,$38,$38,$38 ; E3A0
        .byte   $38,$38,$38,$38,$38,$38,$38,$38 ; E3A8
        .byte   $38,$38,$38,$38,$38,$38,$38,$38 ; E3B0
        .byte   $38,$38,$38,$38,$38,$38,$38,$38 ; E3B8
        .byte   $38,$38,$38,$38,$38,$38,$38,$38 ; E3C0
        .byte   $38,$38,$38,$38,$38,$38,$38,$38 ; E3C8
        .byte   $38,$38,$38,$38,$38,$38,$38,$38 ; E3D0
        .byte   $38,$38,$38,$38,$7D,$3D,$DF,$3F ; E3D8
        .byte   $3B,$38,$37,$38,$E9,$3A,$3D,$3F ; E3E0
        .byte   $FE,$00,$00,$00,$00,$00,$00,$00 ; E3E8
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; E3F0
LE3F8:  .byte   $00                             ; E3F8
LE3F9:  .byte   $00                             ; E3F9
LE3FA:  .byte   $00,$00,$00,$00,$00,$00         ; E3FA
LE400:  .byte   $8E,$0E,$7E,$0D,$6E,$0E,$BD,$8E ; E400
        .byte   $0E,$AE,$0E,$6E,$0E,$BE,$8E,$0E ; E408
        .byte   $AE,$0E,$6E,$0E,$0E,$8E,$0E,$0E ; E410
        .byte   $AE,$AE,$6E,$0E,$AE,$0E,$0E,$9E ; E418
        .byte   $AE,$6E,$0E,$AE,$0E,$0E,$AE,$AE ; E420
        .byte   $6E,$0E,$AD,$0D,$0D,$EE,$AE,$6E ; E428
        .byte   $0E,$0E,$AE,$0E,$0E,$0E,$AE,$FE ; E430
        .byte   $0E,$AE,$0E,$0E,$0E,$AE,$FE,$0E ; E438
        .byte   $AE,$0E,$0E,$0E,$9E,$FE,$0E,$AE ; E440
        .byte   $0E,$0E,$0E,$0E,$AE,$FE,$6E,$5E ; E448
        .byte   $0E,$0E,$05,$AB,$FD,$6E,$EE,$0E ; E450
        .byte   $0E,$0E,$3E,$FE,$6E,$AE,$0E,$0E ; E458
        .byte   $2E,$FE,$0E,$6E,$6E,$AE,$0E,$0E ; E460
        .byte   $3E,$2E,$0E,$6E,$AE,$0E,$0E,$3E ; E468
        .byte   $2E,$0E,$6E,$AE,$0E,$0E,$3E,$2E ; E470
        .byte   $0E,$6E,$AE,$0B,$0B,$0E,$05,$AE ; E478
        .byte   $0E,$6E,$AE,$AE,$0E,$0E,$AE,$0E ; E480
        .byte   $6E,$AE,$AE,$0E,$0E,$AE,$0E,$6E ; E488
        .byte   $AE,$AE,$0E,$0E,$AE,$0E,$6E,$6E ; E490
        .byte   $FE,$AE,$0E,$0E,$AE,$0E,$6E,$FE ; E498
        .byte   $AE,$0E,$0F,$AF,$0F,$6E,$7E,$AE ; E4A0
        .byte   $0E,$0E,$AE,$0E,$6E,$5A,$AA,$0A ; E4A8
        .byte   $0A,$BE,$AE,$0E,$AE,$FE,$0E,$2E ; E4B0
        .byte   $0E,$CE,$AE,$0E,$FE,$AE,$0E,$CE ; E4B8
        .byte   $FE,$6E,$AE,$FE,$0E,$AE,$AE,$0F ; E4C0
        .byte   $A5,$75,$35,$A5,$4B,$DE,$AE,$0A ; E4C8
        .byte   $9A,$AA,$0A,$4B,$F1,$3F,$6F,$DF ; E4D0
        .byte   $6F,$5F,$AF,$CF,$8F,$FF,$2F,$55 ; E4D8
        .byte   $F1,$A1,$81,$61,$21,$0E,$6E,$8E ; E4E0
        .byte   $FE,$FE,$5E,$FE,$F5,$25,$55,$FB ; E4E8
        .byte   $8F,$FB,$FB,$25,$05,$F5,$05,$0A ; E4F0
        .byte   $AE,$3A,$0E,$0E,$6E,$0F,$0F,$0F ; E4F8
LE500:  .byte   $01,$0F,$0F,$0F,$0F,$0F,$0F,$0F ; E500
        .byte   $0F,$0F,$0F,$0B,$0B,$0B,$0D,$0B ; E508
        .byte   $65,$05,$05,$65,$F5,$F5,$65,$F5 ; E510
        .byte   $FB,$FE,$0B,$FB,$FB,$05,$F5,$F5 ; E518
        .byte   $05,$F5,$FA,$FA,$6A,$FA,$FE,$6E ; E520
        .byte   $FE,$FE,$6E,$0E,$FE,$FE,$0E,$6E ; E528
        .byte   $FE,$FE,$6B,$FB,$FB,$65,$F5,$F5 ; E530
        .byte   $05,$0B,$F5,$F5,$05,$F5,$FB,$05 ; E538
        .byte   $FB,$FE,$0E,$0E,$0B,$C5,$CF,$0F ; E540
        .byte   $3F,$35,$0E,$CE,$CE,$0E,$0A,$3A ; E548
        .byte   $3E,$6E,$CE,$CE,$6E,$5E,$3E,$FE ; E550
        .byte   $FE,$AE,$FE,$0E,$6E,$0B,$05,$6F ; E558
        .byte   $FF,$FF,$FF,$3B,$FE,$0E,$0E,$FE ; E560
        .byte   $FB,$0E,$FE,$CE,$0E,$05,$FE,$CB ; E568
        .byte   $6B,$F5,$FE,$6E,$0A,$FA,$8A,$0A ; E570
        .byte   $AA,$0A,$8A,$6A,$0E,$FE,$6E,$FE ; E578
        .byte   $0E,$6E,$AE,$0E,$0E,$05,$05,$FB ; E580
        .byte   $0B,$0B,$0B,$0B,$6E,$FE,$0E,$05 ; E588
        .byte   $0B,$0E,$CE,$0E,$0E,$05,$0E,$FE ; E590
        .byte   $0E,$05,$6A,$0A,$AA,$6B,$0B,$0B ; E598
        .byte   $6B,$0B,$0E,$FE,$0E,$6E,$0A,$0A ; E5A0
        .byte   $6A,$0A,$0A,$6E,$3A,$05,$FA,$0E ; E5A8
        .byte   $0E,$CB,$0B,$0F,$0E,$0E,$0E,$0B ; E5B0
        .byte   $FE,$0B,$0E,$0E,$6E,$0B,$0E,$FE ; E5B8
        .byte   $0E,$05,$0A,$6A,$0A,$0D,$0B,$0B ; E5C0
        .byte   $0E,$0E,$6A,$0A,$0A,$0A,$0A,$0D ; E5C8
        .byte   $0D,$6D,$0D,$0D,$0A,$05,$0A,$0E ; E5D0
        .byte   $6E,$0E,$09,$0F,$03,$0E,$0B,$6B ; E5D8
        .byte   $0E,$0B,$0E,$0E,$0E,$0B,$6B,$0E ; E5E0
        .byte   $0E,$05,$05,$0A,$0A,$6A,$0A,$0A ; E5E8
        .byte   $0A,$0A,$0A,$0A,$6A,$0A,$0A,$0B ; E5F0
        .byte   $0B,$0D,$0B,$6B,$05,$05,$0E,$0E ; E5F8
LE600:  .byte   $0E,$0B,$69,$0E,$03,$09,$0B,$05 ; E600
        .byte   $05,$0B,$0B,$6E,$0E,$0E,$0B,$0E ; E608
        .byte   $0E,$0E,$65,$0B,$0B,$0B,$0B,$0B ; E610
        .byte   $0B,$6A,$0B,$09,$0B,$09,$0B,$0B ; E618
        .byte   $6B,$0B,$0B,$01,$05,$05,$0E,$6E ; E620
        .byte   $0E,$09,$0E,$03,$03,$0B,$6B,$05 ; E628
        .byte   $05,$0B,$0B,$AE,$0E,$6E,$FE,$FB ; E630
        .byte   $0E,$0E,$AF,$01,$65,$F5,$F5,$05 ; E638
        .byte   $01,$A5,$0E,$61,$F1,$F1,$01,$01 ; E640
        .byte   $81,$01,$6A,$6B,$AF,$AB,$01,$3E ; E648
        .byte   $AB,$0B,$6E,$A3,$A9,$0B,$0B,$25 ; E650
        .byte   $D7,$0B,$6B,$0B,$FE,$0E,$5E,$0B ; E658
        .byte   $5B,$0E,$65,$0F,$DF,$0F,$05,$55 ; E660
        .byte   $0F,$62,$01,$51,$01,$02,$52,$0E ; E668
        .byte   $6A,$0A,$5D,$0D,$0D,$0B,$0E,$6B ; E670
        .byte   $0B,$0E,$A3,$F3,$6B,$EB,$0B,$01 ; E678
        .byte   $05,$0B,$FB,$0B,$6E,$FE,$0E,$0E ; E680
        .byte   $0B,$5B,$FB,$6F,$6F,$0F,$0F,$02 ; E688
        .byte   $3F,$F2,$C1,$6E,$8E,$0E,$02,$0E ; E690
        .byte   $7B,$C2,$6F,$5F,$0B,$0B,$0B,$7B ; E698
        .byte   $8E,$6E,$FE,$0B,$0B,$0B,$5B,$51 ; E6A0
        .byte   $65,$0B,$0B,$0B,$FB,$0E,$0E,$6E ; E6A8
        .byte   $0E,$0E,$0B,$BB,$0F,$A1,$65,$05 ; E6B0
        .byte   $05,$65,$05,$F5,$05,$05,$65,$05 ; E6B8
        .byte   $35,$61,$01,$01,$6B,$0B,$0E,$0E ; E6C0
        .byte   $0E,$0E,$0B,$0B,$0B,$0B,$0B,$05 ; E6C8
        .byte   $A5,$F8,$65,$AB,$AB,$0B,$FE,$AE ; E6D0
        .byte   $FE,$6E,$AE,$AE,$0B,$FB,$5B,$FB ; E6D8
        .byte   $6E,$5E,$5E,$0E,$FE,$5E,$FE,$6E ; E6E0
        .byte   $6E,$AB,$AB,$0B,$FE,$AE,$AE,$6E ; E6E8
        .byte   $AE,$AB,$0B,$FB,$AB,$AB,$65,$55 ; E6F0
        .byte   $55,$0B,$0B,$5B,$5B,$0B,$0B,$AE ; E6F8
LE700:  .byte   $AE,$0E,$6E,$AE,$AE,$0E,$AE,$AB ; E700
        .byte   $0B,$6B,$A9,$A9,$09,$59,$59,$05 ; E708
        .byte   $65,$55,$55,$05,$55,$55,$05,$A5 ; E710
        .byte   $FB,$6B,$AB,$AB,$0B,$AB,$A5,$FB ; E718
        .byte   $A5,$0A,$FB,$AB,$6B,$AB,$3B,$3B ; E720
        .byte   $AB,$0E,$CE,$FE,$0E,$AE,$0E,$0E ; E728
        .byte   $AE,$5E,$7E,$AE,$0E,$2E,$AE,$CE ; E730
        .byte   $AE,$4E,$BE,$AE,$6E,$4E,$FB,$3B ; E738
        .byte   $1B,$FB,$3B,$5B,$FB,$55,$85,$6B ; E740
        .byte   $DB,$F8,$88,$55,$F3,$2B,$2B,$6B ; E748
        .byte   $9B,$FB,$FB,$1B,$0B,$FB,$2B,$FB ; E750
        .byte   $AB,$0B,$FB,$2B,$0B,$FB,$8B,$6B ; E758
        .byte   $FB,$1B,$FB,$8B,$0B,$FB,$FB,$6B ; E760
        .byte   $FB,$FB,$6B,$FB,$75,$F5,$FB,$0B ; E768
        .byte   $FB,$FB,$65,$F5,$64,$F5,$F5,$05 ; E770
        .byte   $F5,$15,$05,$F5,$E5,$F5,$F5,$F5 ; E778
        .byte   $05,$F5,$55,$05,$F5,$F5,$05,$F5 ; E780
        .byte   $F5,$F5,$65,$F5,$75,$65,$F5,$F5 ; E788
        .byte   $65,$05,$F5,$F5,$F5,$6B,$FB,$DB ; E790
        .byte   $65,$F5,$F5,$65,$F5,$F5,$05,$05 ; E798
        .byte   $F5,$55,$05,$F5,$F5,$05,$F5,$F5 ; E7A0
        .byte   $05,$05,$05,$F5,$65,$05,$F5,$F5 ; E7A8
        .byte   $05,$F5,$F5,$05,$05,$F5,$A5,$65 ; E7B0
        .byte   $F5,$F5,$65,$F5,$F5,$05,$F5,$F5 ; E7B8
        .byte   $B5,$05,$F5,$75,$05,$05,$F5,$85 ; E7C0
        .byte   $85,$F5,$15,$F5,$F5,$95,$D5,$15 ; E7C8
        .byte   $45,$F5,$A5,$85,$F5,$95,$05,$A5 ; E7D0
        .byte   $45,$B5,$75,$45,$85,$45,$E5,$F5 ; E7D8
        .byte   $95,$A5,$F5,$85,$85,$45,$F5,$E5 ; E7E0
LE7E8:  .byte   $0C,$00,$00,$00,$00,$00,$00,$00 ; E7E8
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; E7F0
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; E7F8
runtime_sprites:
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; E800
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; E808
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; E810
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; E818
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; E820
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; E828
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; E830
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; E838
runtime_sprites_1:
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; E840
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; E848
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; E850
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; E858
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; E860
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; E868
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; E870
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; E878
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; E880
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; E888
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; E890
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; E898
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; E8A0
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; E8A8
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; E8B0
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; E8B8
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; E8C0
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; E8C8
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; E8D0
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; E8D8
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; E8E0
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; E8E8
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; E8F0
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; E8F8
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; E900
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; E908
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; E910
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; E918
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; E920
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; E928
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; E930
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; E938
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; E940
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; E948
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; E950
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; E958
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; E960
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; E968
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; E970
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; E978
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; E980
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; E988
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; E990
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; E998
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; E9A0
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; E9A8
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; E9B0
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; E9B8
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; E9C0
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; E9C8
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; E9D0
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; E9D8
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; E9E0
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; E9E8
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; E9F0
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; E9F8
font:   .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; EA00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; EA08
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; EA10
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; EA18
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; EA20
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; EA28
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; EA30
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; EA38
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; EA40
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; EA48
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; EA50
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; EA58
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; EA60
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; EA68
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; EA70
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; EA78
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; EA80
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; EA88
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; EA90
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; EA98
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; EAA0
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; EAA8
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; EAB0
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; EAB8
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; EAC0
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; EAC8
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; EAD0
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; EAD8
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; EAE0
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; EAE8
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; EAF0
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; EAF8
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; EB00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; EB08
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; EB10
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; EB18
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; EB20
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; EB28
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; EB30
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; EB38
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; EB40
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; EB48
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; EB50
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; EB58
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; EB60
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; EB68
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; EB70
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; EB78
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; EB80
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; EB88
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; EB90
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; EB98
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; EBA0
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; EBA8
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; EBB0
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; EBB8
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; EBC0
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; EBC8
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; EBD0
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; EBD8
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; EBE0
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; EBE8
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; EBF0
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; EBF8
; ----------------------------------------------------------------------------
LEC00:  jmp     LF227                           ; EC00

; ----------------------------------------------------------------------------
LEC03:  jmp     LEC96                           ; EC03

; ----------------------------------------------------------------------------
LEC06:  jmp     LEC18                           ; EC06

; ----------------------------------------------------------------------------
LEC09:  jmp     LEC47                           ; EC09

; ----------------------------------------------------------------------------
        jmp     LEC5C                           ; EC0C

; ----------------------------------------------------------------------------
        jmp     LEC22                           ; EC0F

; ----------------------------------------------------------------------------
        jmp     LEC28                           ; EC12

; ----------------------------------------------------------------------------
        jmp     LEC41                           ; EC15

; ----------------------------------------------------------------------------
LEC18:  jsr     LEC22                           ; EC18
        jsr     LEC28                           ; EC1B
        jsr     LEC41                           ; EC1E
        rts                                     ; EC21

; ----------------------------------------------------------------------------
LEC22:  ldy     #$02                            ; EC22
        sty     LF029                           ; EC24
        rts                                     ; EC27

; ----------------------------------------------------------------------------
LEC28:  jsr     LEC5C                           ; EC28
        sta     LF0A7,x                         ; EC2B
        lda     #$03                            ; EC2E
        sta     LF080,x                         ; EC30
        lda     #$FF                            ; EC33
        sta     LF094,x                         ; EC35
        lda     LF046                           ; EC38
        bne     LEC40                           ; EC3B
        sta     LF0B1,x                         ; EC3D
LEC40:  rts                                     ; EC40

; ----------------------------------------------------------------------------
LEC41:  lda     #$01                            ; EC41
        sta     LF029                           ; EC43
        rts                                     ; EC46

; ----------------------------------------------------------------------------
LEC47:  stx     LEC95                           ; EC47
        jsr     LEC22                           ; EC4A
        ldx     #$02                            ; EC4D
LEC4F:  jsr     LEC5C                           ; EC4F
        dex                                     ; EC52
        bpl     LEC4F                           ; EC53
        jsr     LEC41                           ; EC55
        ldx     LEC95                           ; EC58
        rts                                     ; EC5B

; ----------------------------------------------------------------------------
LEC5C:  pha                                     ; EC5C
        stx     LEC94                           ; EC5D
        jsr     LF1AF                           ; EC60
        ldx     LEC94                           ; EC63
        lda     #$00                            ; EC66
        sta     LF080,x                         ; EC68
        lda     #$00                            ; EC6B
        jsr     LF1E5                           ; EC6D
        lda     #$FF                            ; EC70
        sta     LF090,x                         ; EC72
        ldy     LF02B,x                         ; EC75
        lda     #$00                            ; EC78
        sta     LD400,y                         ; EC7A
        sta     LD401,y                         ; EC7D
        ldy     LF02E,x                         ; EC80
        sta     LD401,y                         ; EC83
        sta     LD402,y                         ; EC86
        sta     LF061,x                         ; EC89
        jsr     LF219                           ; EC8C
        ldx     LEC94                           ; EC8F
        pla                                     ; EC92
        rts                                     ; EC93

; ----------------------------------------------------------------------------
LEC94:  brk                                     ; EC94
LEC95:  brk                                     ; EC95
LEC96:  lda     LF029                           ; EC96
        cmp     #$02                            ; EC99
        beq     LED14                           ; EC9B
        lda     LF02A                           ; EC9D
        bne     LED14                           ; ECA0
        lda     #$01                            ; ECA2
        sta     LF02A                           ; ECA4
        jsr     LF6D4                           ; ECA7
        ldx     #$02                            ; ECAA
LECAC:  lda     LF080,x                         ; ECAC
        cmp     #$03                            ; ECAF
        bne     LECB6                           ; ECB1
        jsr     LED15                           ; ECB3
LECB6:  cmp     #$01                            ; ECB6
        bne     LED09                           ; ECB8
        lda     LF094,x                         ; ECBA
        cmp     #$FF                            ; ECBD
        bne     LECDA                           ; ECBF
        lda     LF072,x                         ; ECC1
        bne     LECD4                           ; ECC4
        lda     LF076,x                         ; ECC6
        bne     LECD1                           ; ECC9
        jsr     LEE50                           ; ECCB
        jmp     LED09                           ; ECCE

; ----------------------------------------------------------------------------
LECD1:  dec     LF076,x                         ; ECD1
LECD4:  dec     LF072,x                         ; ECD4
        jmp     LED09                           ; ECD7

; ----------------------------------------------------------------------------
LECDA:  lda     LF072,x                         ; ECDA
        bne     LECF0                           ; ECDD
        lda     LF076,x                         ; ECDF
        bne     LECED                           ; ECE2
        jsr     LF2C5                           ; ECE4
        jsr     LF219                           ; ECE7
        jmp     LECF3                           ; ECEA

; ----------------------------------------------------------------------------
LECED:  dec     LF076,x                         ; ECED
LECF0:  dec     LF072,x                         ; ECF0
LECF3:  lda     LF07A,x                         ; ECF3
        bne     LED06                           ; ECF6
        lda     LF07D,x                         ; ECF8
        bne     LED03                           ; ECFB
        jsr     LEE50                           ; ECFD
        jmp     LED09                           ; ED00

; ----------------------------------------------------------------------------
LED03:  dec     LF07D,x                         ; ED03
LED06:  dec     LF07A,x                         ; ED06
LED09:  dex                                     ; ED09
        bpl     LECAC                           ; ED0A
        jsr     LED46                           ; ED0C
        lda     #$00                            ; ED0F
        sta     LF02A                           ; ED11
LED14:  rts                                     ; ED14

; ----------------------------------------------------------------------------
LED15:  ldy     LF0A7,x                         ; ED15
        lda     LFFAD,y                         ; ED18
        beq     LED40                           ; ED1B
        sta     LF06E,x                         ; ED1D
        lda     LFF93,y                         ; ED20
        sta     LF06A,x                         ; ED23
        lda     #$02                            ; ED26
        sta     LF044                           ; ED28
        lda     #$02                            ; ED2B
        sta     LF043                           ; ED2D
        txa                                     ; ED30
        sta     LF084,x                         ; ED31
        lda     #$01                            ; ED34
        sta     LF080,x                         ; ED36
        jsr     LEE50                           ; ED39
        lda     LF080,x                         ; ED3C
        rts                                     ; ED3F

; ----------------------------------------------------------------------------
LED40:  lda     #$00                            ; ED40
        sta     LF080,x                         ; ED42
        rts                                     ; ED45

; ----------------------------------------------------------------------------
LED46:  ldx     #$05                            ; ED46
LED48:  lda     LF111,x                         ; ED48
        cmp     #$FF                            ; ED4B
        beq     LED5E                           ; ED4D
        lda     LF129,x                         ; ED4F
        cmp     #$01                            ; ED52
        beq     LED5E                           ; ED54
        lda     #$00                            ; ED56
        sta     LF11D,x                         ; ED58
        sta     LF123,x                         ; ED5B
LED5E:  dex                                     ; ED5E
        bpl     LED48                           ; ED5F
        ldx     #$05                            ; ED61
LED63:  lda     LF0F9,x                         ; ED63
        cmp     #$01                            ; ED66
        bne     LED9E                           ; ED68
        dec     LF0FF,x                         ; ED6A
        bne     LED9E                           ; ED6D
        clc                                     ; ED6F
        lda     LF0D5,x                         ; ED70
        adc     LF0ED,x                         ; ED73
        sta     LF0D5,x                         ; ED76
        lda     LF0DB,x                         ; ED79
        adc     LF0F3,x                         ; ED7C
        sta     LF0DB,x                         ; ED7F
        lda     LF0E1,x                         ; ED82
        bne     LED95                           ; ED85
        lda     LF0E7,x                         ; ED87
        bne     LED92                           ; ED8A
        jsr     LEE28                           ; ED8C
        jmp     LED9E                           ; ED8F

; ----------------------------------------------------------------------------
LED92:  dec     LF0E7,x                         ; ED92
LED95:  dec     LF0E1,x                         ; ED95
        lda     LF0CF,x                         ; ED98
        sta     LF0FF,x                         ; ED9B
LED9E:  lda     LF0F9,x                         ; ED9E
        cmp     #$04                            ; EDA1
        beq     LEDBF                           ; EDA3
        cmp     #$00                            ; EDA5
        beq     LEDBF                           ; EDA7
        ldy     LF105,x                         ; EDA9
        clc                                     ; EDAC
        lda     LF11D,y                         ; EDAD
        adc     LF0D5,x                         ; EDB0
        sta     LF11D,y                         ; EDB3
        lda     LF123,y                         ; EDB6
        adc     LF0DB,x                         ; EDB9
        sta     LF123,y                         ; EDBC
LEDBF:  dex                                     ; EDBF
        bpl     LED63                           ; EDC0
        ldy     #$05                            ; EDC2
LEDC4:  ldx     LF111,y                         ; EDC4
        cpx     #$FF                            ; EDC7
        beq     LEE24                           ; EDC9
        ldx     LF10B,y                         ; EDCB
        lda     LF084,x                         ; EDCE
        sta     LF04B                           ; EDD1
        lda     LF117,y                         ; EDD4
        cmp     #$01                            ; EDD7
        bne     LEDFF                           ; EDD9
        ldx     LF10B,y                         ; EDDB
        clc                                     ; EDDE
        lda     LF051,x                         ; EDDF
        adc     LF11D,y                         ; EDE2
        pha                                     ; EDE5
        lda     LF055,x                         ; EDE6
        adc     LF123,y                         ; EDE9
        pha                                     ; EDEC
        ldx     LF04B                           ; EDED
        lda     LF02B,x                         ; EDF0
        tax                                     ; EDF3
        pla                                     ; EDF4
        sta     LD401,x                         ; EDF5
        pla                                     ; EDF8
        sta     LD400,x                         ; EDF9
        jmp     LEE24                           ; EDFC

; ----------------------------------------------------------------------------
LEDFF:  cmp     #$02                            ; EDFF
        bne     LEE24                           ; EE01
        clc                                     ; EE03
        lda     LF059,x                         ; EE04
        adc     LF11D,y                         ; EE07
        pha                                     ; EE0A
        lda     LF05D,x                         ; EE0B
        adc     LF123,y                         ; EE0E
        pha                                     ; EE11
        ldx     LF04B                           ; EE12
        lda     LF02B,x                         ; EE15
        tax                                     ; EE18
        pla                                     ; EE19
        sta     LD403,x                         ; EE1A
        pla                                     ; EE1D
        sta     LD402,x                         ; EE1E
        jmp     LEE24                           ; EE21

; ----------------------------------------------------------------------------
LEE24:  dey                                     ; EE24
        bpl     LEDC4                           ; EE25
        rts                                     ; EE27

; ----------------------------------------------------------------------------
LEE28:  lda     LF0B7,x                         ; EE28
        sta     $02                             ; EE2B
        lda     LF0BD,x                         ; EE2D
        sta     $03                             ; EE30
        stx     LF045                           ; EE32
        lda     #$01                            ; EE35
        sta     LF043                           ; EE37
        lda     #$01                            ; EE3A
        sta     LF044                           ; EE3C
        jsr     LEE67                           ; EE3F
        lda     #$02                            ; EE42
        sta     LF043                           ; EE44
        lda     #$01                            ; EE47
        sta     LF044                           ; EE49
        ldx     LF045                           ; EE4C
        rts                                     ; EE4F

; ----------------------------------------------------------------------------
LEE50:  lda     LF06A,x                         ; EE50
        sta     $02                             ; EE53
        lda     LF06E,x                         ; EE55
        sta     $03                             ; EE58
        stx     LF050                           ; EE5A
        lda     #$02                            ; EE5D
        sta     LF043                           ; EE5F
        lda     #$02                            ; EE62
        sta     LF044                           ; EE64
LEE67:  ldy     #$00                            ; EE67
        lda     ($02),y                         ; EE69
        bpl     LEE88                           ; EE6B
        cmp     #$FF                            ; EE6D
        beq     LEE77                           ; EE6F
        jsr     LF65D                           ; EE71
        jmp     LEF18                           ; EE74

; ----------------------------------------------------------------------------
LEE77:  lda     LF048                           ; EE77
        cmp     #$01                            ; EE7A
        beq     LEE81                           ; EE7C
        jsr     LEF1C                           ; EE7E
LEE81:  rts                                     ; EE81

; ----------------------------------------------------------------------------
        jsr     LEF42                           ; EE82
        jmp     LEE67                           ; EE85

; ----------------------------------------------------------------------------
LEE88:  sta     LF04D                           ; EE88
        tay                                     ; EE8B
        lda     LEF8D,y                         ; EE8C
        sta     LEE9C                           ; EE8F
        lda     LEF43,y                         ; EE92
        sta     LEE9B                           ; EE95
        ldy     #$01                            ; EE98
        .byte   $20                             ; EE9A
LEE9B:  .byte   $11                             ; EE9B
LEE9C:  ora     ($AE),y                         ; EE9C
        eor     LBDF0                           ; EE9E
        .byte   $D7                             ; EEA1
        .byte   $EF                             ; EEA2
        clc                                     ; EEA3
        adc     $02                             ; EEA4
        sta     $02                             ; EEA6
        bcc     LEEAC                           ; EEA8
        inc     $03                             ; EEAA
LEEAC:  ldy     LF044                           ; EEAC
        lda     LF043                           ; EEAF
        cmp     #$01                            ; EEB2
        beq     LEEC7                           ; EEB4
        ldx     LF050                           ; EEB6
        lda     $02                             ; EEB9
        sta     LF06A,x                         ; EEBB
        lda     $03                             ; EEBE
        sta     LF06E,x                         ; EEC0
        cpy     #$02                            ; EEC3
        beq     LEEDD                           ; EEC5
LEEC7:  ldx     LF045                           ; EEC7
        lda     $02                             ; EECA
        sta     LF0B7,x                         ; EECC
        lda     $03                             ; EECF
        sta     LF0BD,x                         ; EED1
        cpy     #$03                            ; EED4
        bne     LEEDD                           ; EED6
        lda     #$02                            ; EED8
        sta     LF044                           ; EEDA
LEEDD:  ldx     LF050                           ; EEDD
        lda     LF04D                           ; EEE0
        cmp     #$0C                            ; EEE3
        beq     LEF11                           ; EEE5
        cmp     #$12                            ; EEE7
        beq     LEF1B                           ; EEE9
        ldy     LF043                           ; EEEB
        cpy     #$01                            ; EEEE
        beq     LEEF5                           ; EEF0
        jmp     LEE67                           ; EEF2

; ----------------------------------------------------------------------------
LEEF5:  cmp     #$5E                            ; EEF5
        bne     LEF07                           ; EEF7
        lda     #$00                            ; EEF9
        ldx     LF045                           ; EEFB
        sta     LF0F9,x                         ; EEFE
        lda     #$02                            ; EF01
        sta     LF043                           ; EF03
        rts                                     ; EF06

; ----------------------------------------------------------------------------
LEF07:  ldy     LF047                           ; EF07
        cpy     #$01                            ; EF0A
        beq     LEF1B                           ; EF0C
        jmp     LEE67                           ; EF0E

; ----------------------------------------------------------------------------
LEF11:  lda     LF043                           ; EF11
        cmp     #$01                            ; EF14
        beq     LEF1B                           ; EF16
LEF18:  jsr     LF12F                           ; EF18
LEF1B:  rts                                     ; EF1B

; ----------------------------------------------------------------------------
LEF1C:  ldx     LF050                           ; EF1C
        lda     #$00                            ; EF1F
        sta     LF080,x                         ; EF21
        jsr     LF1E5                           ; EF24
        jsr     LF1AF                           ; EF27
        lda     LF0A3,x                         ; EF2A
        cmp     #$FF                            ; EF2D
        beq     LEF41                           ; EF2F
        ldy     LF084,x                         ; EF31
        tax                                     ; EF34
        tya                                     ; EF35
        sta     LF084,x                         ; EF36
        lda     #$01                            ; EF39
        sta     LF080,x                         ; EF3B
        jsr     LF1E5                           ; EF3E
LEF41:  rts                                     ; EF41

; ----------------------------------------------------------------------------
LEF42:  .byte   $60                             ; EF42
LEF43:  .byte   $BB,$BC,$C5,$CE,$DA,$E6,$02,$15 ; EF43
        .byte   $2C,$3F,$00,$56,$5E,$6A,$70,$7B ; EF4B
        .byte   $B5,$00,$C8,$00,$00,$00,$00,$00 ; EF53
        .byte   $F8,$00,$C6,$CF,$00,$D8,$00,$00 ; EF5B
        .byte   $00,$14,$61,$24,$30,$38,$41,$4A ; EF63
        .byte   $53,$5C,$7C,$8E,$A0,$B3,$05,$06 ; EF6B
        .byte   $46,$51,$5C,$67,$6D,$73,$00,$00 ; EF73
        .byte   $00,$00,$79,$73,$00,$B4,$00,$C2 ; EF7B
        .byte   $DD,$00,$00,$00,$0D,$27,$3C,$00 ; EF83
        .byte   $7F,$50                         ; EF8B
LEF8D:  .byte   $F2,$F2,$F2,$F2,$F2,$F2,$F3,$F3 ; EF8D
        .byte   $F3,$F3,$00,$F3,$F3,$F3,$F3,$F3 ; EF95
        .byte   $F3,$00,$F3,$00,$00,$00,$00,$00 ; EF9D
        .byte   $F3,$00,$F4,$F4,$00,$F4,$00,$00 ; EFA5
        .byte   $00,$F5,$F5,$F4,$F4,$F4,$F4,$F4 ; EFAD
        .byte   $F4,$F4,$F4,$F4,$F4,$F4,$F9,$F9 ; EFB5
        .byte   $F9,$F9,$F9,$F9,$F9,$F9,$00,$00 ; EFBD
        .byte   $00,$00,$F9,$F5,$00,$F5,$00,$F5 ; EFC5
        .byte   $F5,$00,$00,$00,$F6,$F6,$F6,$00 ; EFCD
        .byte   $F9,$F6,$01,$01,$01,$03,$03,$02 ; EFD5
        .byte   $02,$02,$02,$02,$01,$02,$03,$01 ; EFDD
        .byte   $01,$02,$03,$01,$02,$01,$01,$01 ; EFE5
        .byte   $01,$01,$08,$01,$02,$02,$01,$02 ; EFED
        .byte   $01,$01,$01,$02,$02,$03,$02,$01 ; EFF5
        .byte   $01,$01,$01,$03,$02,$02,$01,$01 ; EFFD
        .byte   $01,$02,$02,$02,$02,$02,$02,$02 ; F005
        .byte   $01,$01,$01,$02,$01,$08,$01,$06 ; F00D
        .byte   $01,$03,$03,$01,$02,$01,$01,$01 ; F015
        .byte   $01,$01,$02,$02                 ; F01D
LF021:  .byte   $00                             ; F021
LF022:  .byte   $00,$00                         ; F022
LF024:  .byte   $00                             ; F024
LF025:  .byte   $00                             ; F025
LF026:  .byte   $00                             ; F026
LF027:  .byte   $00                             ; F027
LF028:  .byte   $00                             ; F028
LF029:  .byte   $00                             ; F029
LF02A:  .byte   $00                             ; F02A
LF02B:  .byte   $00,$07,$0E                     ; F02B
LF02E:  .byte   $04,$0B,$12                     ; F02E
LF031:  .byte   $00                             ; F031
LF032:  .byte   $00                             ; F032
LF033:  .byte   $01,$02,$04,$08,$10,$20,$40,$80 ; F033
LF03B:  .byte   $FE,$FD,$FB,$F7,$EF,$DF,$BF,$7F ; F03B
LF043:  .byte   $02                             ; F043
LF044:  .byte   $01                             ; F044
LF045:  .byte   $00                             ; F045
LF046:  .byte   $00                             ; F046
LF047:  .byte   $00                             ; F047
LF048:  .byte   $02                             ; F048
LF049:  .byte   $00                             ; F049
LF04A:  .byte   $00                             ; F04A
LF04B:  .byte   $00,$00                         ; F04B
LF04D:  .byte   $00                             ; F04D
LF04E:  .byte   $00                             ; F04E
LF04F:  .byte   $00                             ; F04F
LF050:  .byte   $00                             ; F050
LF051:  .byte   $00,$00,$00,$00                 ; F051
LF055:  .byte   $00,$00,$00,$00                 ; F055
LF059:  .byte   $00,$00,$00,$00                 ; F059
LF05D:  .byte   $00,$00,$00,$00                 ; F05D
LF061:  .byte   $00,$00,$00                     ; F061
LF064:  .byte   $00,$00,$00                     ; F064
LF067:  .byte   $00,$00,$00                     ; F067
LF06A:  .byte   $00,$00,$00,$00                 ; F06A
LF06E:  .byte   $00,$00,$00,$00                 ; F06E
LF072:  .byte   $00,$00,$00,$00                 ; F072
LF076:  .byte   $00,$00,$00,$00                 ; F076
LF07A:  .byte   $00,$00,$00                     ; F07A
LF07D:  .byte   $00,$00,$00                     ; F07D
LF080:  .byte   $00,$00,$00,$00                 ; F080
LF084:  .byte   $00,$00,$00,$00                 ; F084
LF088:  .byte   $00,$00,$00,$00                 ; F088
LF08C:  .byte   $00,$00,$00,$00                 ; F08C
LF090:  .byte   $00,$00,$00,$00                 ; F090
LF094:  .byte   $00,$00,$00                     ; F094
LF097:  .byte   $00,$00,$00                     ; F097
LF09A:  .byte   $00,$00,$00                     ; F09A
LF09D:  .byte   $00,$00,$00                     ; F09D
LF0A0:  .byte   $00,$00,$00                     ; F0A0
LF0A3:  .byte   $00,$00,$00,$00                 ; F0A3
LF0A7:  .byte   $00,$00,$00,$00                 ; F0A7
LF0AB:  .byte   $00,$00,$00                     ; F0AB
LF0AE:  .byte   $00,$00,$00                     ; F0AE
LF0B1:  .byte   $00,$00,$00                     ; F0B1
LF0B4:  .byte   $00,$00,$00                     ; F0B4
LF0B7:  .byte   $00,$00,$00,$00,$00,$00         ; F0B7
LF0BD:  .byte   $00,$00,$00,$00,$00,$00         ; F0BD
LF0C3:  .byte   $00,$00,$00,$00,$00,$00         ; F0C3
LF0C9:  .byte   $00,$00,$00,$00,$00,$00         ; F0C9
LF0CF:  .byte   $00,$00,$00,$00,$00,$00         ; F0CF
LF0D5:  .byte   $00,$00,$00,$00,$00,$00         ; F0D5
LF0DB:  .byte   $00,$00,$00,$00,$00,$00         ; F0DB
LF0E1:  .byte   $00,$00,$00,$00,$00,$00         ; F0E1
LF0E7:  .byte   $00,$00,$00,$00,$00,$00         ; F0E7
LF0ED:  .byte   $00,$00,$00,$00,$00,$00         ; F0ED
LF0F3:  .byte   $00,$00,$00,$00,$00,$00         ; F0F3
LF0F9:  .byte   $00,$00,$00,$00,$00,$00         ; F0F9
LF0FF:  .byte   $00,$00,$00,$00,$00,$00         ; F0FF
LF105:  .byte   $00,$00,$00,$00,$00,$00         ; F105
LF10B:  .byte   $00,$00,$00                     ; F10B
LF10E:  .byte   $00,$00,$00                     ; F10E
LF111:  .byte   $00,$00,$00,$00,$00,$00         ; F111
LF117:  .byte   $00,$00,$00                     ; F117
LF11A:  .byte   $00,$00,$00                     ; F11A
LF11D:  .byte   $00,$00,$00,$00,$00,$00         ; F11D
LF123:  .byte   $00,$00,$00,$00,$00,$00         ; F123
LF129:  .byte   $00,$00,$00,$00,$00,$00         ; F129
; ----------------------------------------------------------------------------
LF12F:  ldy     LF084,x                         ; F12F
LF132:  cpx     LF027                           ; F132
        beq     LF139                           ; F135
        bne     LF178                           ; F137
LF139:  lda     LF051,x                         ; F139
        sta     LD415                           ; F13C
        lda     LF055,x                         ; F13F
        sta     LD416                           ; F142
        jsr     LF164                           ; F145
        lda     LF05D,x                         ; F148
        cmp     LF028                           ; F14B
        beq     LF163                           ; F14E
        sta     LF028                           ; F150
        and     #$70                            ; F153
        sta     LF021                           ; F155
        lda     LF025                           ; F158
        and     #$0F                            ; F15B
        ora     LF021                           ; F15D
        sta     LD418                           ; F160
LF163:  rts                                     ; F163

; ----------------------------------------------------------------------------
LF164:  lda     LF059,x                         ; F164
        and     #$F0                            ; F167
        sta     LF021                           ; F169
        lda     LF026                           ; F16C
        and     #$07                            ; F16F
        ora     LF021                           ; F171
        sta     LD417                           ; F174
        rts                                     ; F177

; ----------------------------------------------------------------------------
LF178:  lda     LF02B,y                         ; F178
        tay                                     ; F17B
        lda     LF051,x                         ; F17C
        sta     LD400,y                         ; F17F
        iny                                     ; F182
        lda     LF055,x                         ; F183
        sta     LD400,y                         ; F186
        iny                                     ; F189
        lda     LF059,x                         ; F18A
        sta     LD400,y                         ; F18D
        iny                                     ; F190
        lda     LF05D,x                         ; F191
        sta     LD400,y                         ; F194
        iny                                     ; F197
        lda     LF061,x                         ; F198
        and     #$F7                            ; F19B
        sta     LD400,y                         ; F19D
        iny                                     ; F1A0
        lda     LF064,x                         ; F1A1
        sta     LD400,y                         ; F1A4
        iny                                     ; F1A7
        lda     LF067,x                         ; F1A8
        sta     LD400,y                         ; F1AB
        rts                                     ; F1AE

; ----------------------------------------------------------------------------
LF1AF:  ldy     LF084,x                         ; F1AF
        stx     LF022                           ; F1B2
        ldx     LF02B,y                         ; F1B5
        lda     #$00                            ; F1B8
        sta     LD400,x                         ; F1BA
        sta     LD401,x                         ; F1BD
        sta     LD405,x                         ; F1C0
        sta     LD406,x                         ; F1C3
        ldx     LF02E,y                         ; F1C6
        ldy     LF022                           ; F1C9
        sta     LF061,y                         ; F1CC
        sta     LD400,x                         ; F1CF
        ldx     LF022                           ; F1D2
        rts                                     ; F1D5

; ----------------------------------------------------------------------------
LF1D6:  ldx     #$02                            ; F1D6
LF1D8:  lda     LF080,x                         ; F1D8
        cmp     #$00                            ; F1DB
        beq     LF1E4                           ; F1DD
        dex                                     ; F1DF
        bpl     LF1D8                           ; F1E0
        ldx     #$FF                            ; F1E2
LF1E4:  rts                                     ; F1E4

; ----------------------------------------------------------------------------
LF1E5:  sta     LF04F                           ; F1E5
        stx     LF04E                           ; F1E8
        ldy     #$05                            ; F1EB
LF1ED:  lda     LF10B,y                         ; F1ED
        cmp     LF04E                           ; F1F0
        bne     LF212                           ; F1F3
        ldx     #$05                            ; F1F5
LF1F7:  tya                                     ; F1F7
        cmp     LF105,x                         ; F1F8
        bne     LF203                           ; F1FB
        lda     LF04F                           ; F1FD
        sta     LF0F9,x                         ; F200
LF203:  dex                                     ; F203
        bpl     LF1F7                           ; F204
        lda     LF04F                           ; F206
        cmp     #$00                            ; F209
        bne     LF212                           ; F20B
        lda     #$FF                            ; F20D
        sta     LF111,y                         ; F20F
LF212:  dey                                     ; F212
        bpl     LF1ED                           ; F213
        ldx     LF04E                           ; F215
        rts                                     ; F218

; ----------------------------------------------------------------------------
LF219:  ldy     LF084,x                         ; F219
        lda     LF02E,y                         ; F21C
        tay                                     ; F21F
        lda     LF061,x                         ; F220
        sta     LD400,y                         ; F223
        rts                                     ; F226

; ----------------------------------------------------------------------------
LF227:  lda     #$00                            ; F227
        ldy     #$17                            ; F229
LF22B:  sta     LD400,y                         ; F22B
        dey                                     ; F22E
        bpl     LF22B                           ; F22F
        lda     #$4F                            ; F231
        sta     LD418                           ; F233
        ldy     #$02                            ; F236
LF238:  lda     #$00                            ; F238
        sta     LF06E,y                         ; F23A
        sta     LF06A,y                         ; F23D
        lda     #$00                            ; F240
        sta     LF080,y                         ; F242
        lda     #$FF                            ; F245
        sta     LF084,y                         ; F247
        lda     #$FF                            ; F24A
        sta     LF090,y                         ; F24C
        lda     #$FF                            ; F24F
        sta     LF094,y                         ; F251
        lda     #$FF                            ; F254
        sta     LF0A3,y                         ; F256
        lda     #$02                            ; F259
        sta     LF097,y                         ; F25B
        lda     #$00                            ; F25E
        sta     LF09A,y                         ; F260
        sta     LF09D,y                         ; F263
        lda     #$FF                            ; F266
        sta     LF0A0,y                         ; F268
        lda     #$00                            ; F26B
        sta     LF0AB,y                         ; F26D
        dey                                     ; F270
        bpl     LF238                           ; F271
        ldy     #$05                            ; F273
LF275:  lda     #$00                            ; F275
        sta     LF0F9,y                         ; F277
        dey                                     ; F27A
        bpl     LF275                           ; F27B
        ldy     #$05                            ; F27D
LF27F:  tya                                     ; F27F
        sta     LF10B,y                         ; F280
        lda     #$FF                            ; F283
        sta     LF111,y                         ; F285
        lda     #$01                            ; F288
        sta     LF117,y                         ; F28A
        lda     #$02                            ; F28D
        sta     LF129,y                         ; F28F
        dey                                     ; F292
        bpl     LF27F                           ; F293
        ldy     #$02                            ; F295
LF297:  lda     #$02                            ; F297
        sta     LF11A,y                         ; F299
        tya                                     ; F29C
        sta     LF10E,y                         ; F29D
        dey                                     ; F2A0
        bpl     LF297                           ; F2A1
        lda     #$00                            ; F2A3
        sta     LF032                           ; F2A5
        sta     LF046                           ; F2A8
        lda     #$0F                            ; F2AB
        sta     LF025                           ; F2AD
        lda     #$04                            ; F2B0
        sta     LF028                           ; F2B2
        lda     #$03                            ; F2B5
        sta     LF027                           ; F2B7
        rts                                     ; F2BA

; ----------------------------------------------------------------------------
        rts                                     ; F2BB

; ----------------------------------------------------------------------------
LF2BC:  lda     LF061,x                         ; F2BC
        ora     #$01                            ; F2BF
        sta     LF061,x                         ; F2C1
        rts                                     ; F2C4

; ----------------------------------------------------------------------------
LF2C5:  lda     LF061,x                         ; F2C5
        and     #$FE                            ; F2C8
        sta     LF061,x                         ; F2CA
        rts                                     ; F2CD

; ----------------------------------------------------------------------------
        lda     ($02),y                         ; F2CE
        sta     LF051,x                         ; F2D0
        iny                                     ; F2D3
        lda     ($02),y                         ; F2D4
        sta     LF055,x                         ; F2D6
        rts                                     ; F2D9

; ----------------------------------------------------------------------------
        lda     ($02),y                         ; F2DA
        sta     LF059,x                         ; F2DC
        iny                                     ; F2DF
        lda     ($02),y                         ; F2E0
        sta     LF05D,x                         ; F2E2
        rts                                     ; F2E5

; ----------------------------------------------------------------------------
        lda     ($02),y                         ; F2E6
        and     #$0F                            ; F2E8
        asl     a                               ; F2EA
        asl     a                               ; F2EB
        asl     a                               ; F2EC
        asl     a                               ; F2ED
        sta     LF021                           ; F2EE
        lda     #$FF                            ; F2F1
        sta     LF084,x                         ; F2F3
        lda     LF064,x                         ; F2F6
        and     #$0F                            ; F2F9
        ora     LF021                           ; F2FB
        sta     LF064,x                         ; F2FE
        rts                                     ; F301

; ----------------------------------------------------------------------------
        lda     ($02),y                         ; F302
        and     #$0F                            ; F304
        sta     LF021                           ; F306
        lda     LF064,x                         ; F309
        and     #$F0                            ; F30C
        ora     LF021                           ; F30E
        sta     LF064,x                         ; F311
        rts                                     ; F314

; ----------------------------------------------------------------------------
        lda     ($02),y                         ; F315
        and     #$0F                            ; F317
        asl     a                               ; F319
        asl     a                               ; F31A
        asl     a                               ; F31B
        asl     a                               ; F31C
        sta     LF021                           ; F31D
        lda     LF067,x                         ; F320
        and     #$0F                            ; F323
        ora     LF021                           ; F325
        sta     LF067,x                         ; F328
        rts                                     ; F32B

; ----------------------------------------------------------------------------
        lda     ($02),y                         ; F32C
        and     #$0F                            ; F32E
        sta     LF021                           ; F330
        lda     LF067,x                         ; F333
        and     #$F0                            ; F336
        ora     LF021                           ; F338
        sta     LF067,x                         ; F33B
        rts                                     ; F33E

; ----------------------------------------------------------------------------
        lda     ($02),y                         ; F33F
        and     #$0F                            ; F341
        asl     a                               ; F343
        asl     a                               ; F344
        asl     a                               ; F345
        asl     a                               ; F346
        sta     LF021                           ; F347
        lda     LF061,x                         ; F34A
        and     #$0F                            ; F34D
        ora     LF021                           ; F34F
        sta     LF061,x                         ; F352
        rts                                     ; F355

; ----------------------------------------------------------------------------
        lda     ($02),y                         ; F356
        and     #$0F                            ; F358
        sta     LF025                           ; F35A
        rts                                     ; F35D

; ----------------------------------------------------------------------------
        lda     ($02),y                         ; F35E
        sta     LF072,x                         ; F360
        iny                                     ; F363
        lda     ($02),y                         ; F364
        sta     LF076,x                         ; F366
        rts                                     ; F369

; ----------------------------------------------------------------------------
        lda     #$FE                            ; F36A
        sta     LF094,x                         ; F36C
        rts                                     ; F36F

; ----------------------------------------------------------------------------
        lda     $02                             ; F370
        sta     LF088,x                         ; F372
        lda     $03                             ; F375
        sta     LF08C,x                         ; F377
        rts                                     ; F37A

; ----------------------------------------------------------------------------
        lda     LF090,x                         ; F37B
        cmp     #$FF                            ; F37E
        bne     LF38D                           ; F380
        lda     ($02),y                         ; F382
        sec                                     ; F384
        sbc     #$01                            ; F385
        sta     LF090,x                         ; F387
        jmp     LF399                           ; F38A

; ----------------------------------------------------------------------------
LF38D:  lda     LF090,x                         ; F38D
        cmp     #$FE                            ; F390
        beq     LF399                           ; F392
        dec     LF090,x                         ; F394
        beq     LF3AF                           ; F397
LF399:  lda     LF088,x                         ; F399
        sta     LF06A,x                         ; F39C
        sta     $02                             ; F39F
        lda     LF08C,x                         ; F3A1
        sta     LF06E,x                         ; F3A4
        sta     $03                             ; F3A7
        lda     #$0E                            ; F3A9
        sta     LF04D                           ; F3AB
        rts                                     ; F3AE

; ----------------------------------------------------------------------------
LF3AF:  lda     #$FF                            ; F3AF
        sta     LF090,x                         ; F3B1
        rts                                     ; F3B4

; ----------------------------------------------------------------------------
        lda     ($02),y                         ; F3B5
        sta     LF3C3                           ; F3B7
        iny                                     ; F3BA
        lda     ($02),y                         ; F3BB
        sta     LF3C4                           ; F3BD
        txa                                     ; F3C0
        pha                                     ; F3C1
        .byte   $20                             ; F3C2
LF3C3:  .byte   $11                             ; F3C3
LF3C4:  ora     ($68),y                         ; F3C4
        tax                                     ; F3C6
        rts                                     ; F3C7

; ----------------------------------------------------------------------------
        lda     #$02                            ; F3C8
        sta     LF080,x                         ; F3CA
        lda     #$04                            ; F3CD
        jsr     LF1E5                           ; F3CF
        jsr     LF2C5                           ; F3D2
        lda     LF084,x                         ; F3D5
        pha                                     ; F3D8
        lda     #$FF                            ; F3D9
        sta     LF084,x                         ; F3DB
        jsr     LF1D6                           ; F3DE
        ldy     #$01                            ; F3E1
        lda     ($02),y                         ; F3E3
        jsr     LEC18                           ; F3E5
        lda     LF050                           ; F3E8
        sta     LF0A3,x                         ; F3EB
        lda     #$01                            ; F3EE
        sta     LF029                           ; F3F0
        pla                                     ; F3F3
        sta     LF084,x                         ; F3F4
        rts                                     ; F3F7

; ----------------------------------------------------------------------------
        lda     ($02),y                         ; F3F8
        sta     LF051,x                         ; F3FA
        iny                                     ; F3FD
        lda     ($02),y                         ; F3FE
        sta     LF055,x                         ; F400
        iny                                     ; F403
        lda     ($02),y                         ; F404
        sta     LF059,x                         ; F406
        iny                                     ; F409
        lda     ($02),y                         ; F40A
        sta     LF05D,x                         ; F40C
        iny                                     ; F40F
        lda     ($02),y                         ; F410
        and     #$F7                            ; F412
        sta     LF061,x                         ; F414
        iny                                     ; F417
        lda     ($02),y                         ; F418
        sta     LF064,x                         ; F41A
        iny                                     ; F41D
        lda     ($02),y                         ; F41E
        sta     LF067,x                         ; F420
        rts                                     ; F423

; ----------------------------------------------------------------------------
        lda     ($02),y                         ; F424
        sta     LF064,x                         ; F426
        iny                                     ; F429
        lda     ($02),y                         ; F42A
        sta     LF067,x                         ; F42C
        rts                                     ; F42F

; ----------------------------------------------------------------------------
        lda     ($02),y                         ; F430
        and     #$F7                            ; F432
        sta     LF061,x                         ; F434
        rts                                     ; F437

; ----------------------------------------------------------------------------
        lda     LF061,x                         ; F438
        ora     #$02                            ; F43B
        sta     LF061,x                         ; F43D
        rts                                     ; F440

; ----------------------------------------------------------------------------
        lda     LF061,x                         ; F441
        and     #$FD                            ; F444
        sta     LF061,x                         ; F446
        rts                                     ; F449

; ----------------------------------------------------------------------------
        lda     LF061,x                         ; F44A
        ora     #$04                            ; F44D
        sta     LF061,x                         ; F44F
        rts                                     ; F452

; ----------------------------------------------------------------------------
        lda     LF061,x                         ; F453
        and     #$FB                            ; F456
        sta     LF061,x                         ; F458
        rts                                     ; F45B

; ----------------------------------------------------------------------------
        ldx     LF027                           ; F45C
        lda     ($02),y                         ; F45F
        sta     LF021                           ; F461
        and     #$07                            ; F464
        sta     LF051,x                         ; F466
        iny                                     ; F469
        lda     ($02),y                         ; F46A
        ldy     #$04                            ; F46C
LF46E:  rol     LF021                           ; F46E
        rol     a                               ; F471
        dey                                     ; F472
        bpl     LF46E                           ; F473
        sta     LF055,x                         ; F475
        jsr     LF139                           ; F478
        rts                                     ; F47B

; ----------------------------------------------------------------------------
        lda     ($02),y                         ; F47C
        asl     a                               ; F47E
        asl     a                               ; F47F
        asl     a                               ; F480
        asl     a                               ; F481
        and     #$F0                            ; F482
        ldx     LF027                           ; F484
        sta     LF059,x                         ; F487
        jsr     LF132                           ; F48A
        rts                                     ; F48D

; ----------------------------------------------------------------------------
        lda     ($02),y                         ; F48E
        asl     a                               ; F490
        asl     a                               ; F491
        asl     a                               ; F492
        asl     a                               ; F493
        and     #$70                            ; F494
        ldx     LF027                           ; F496
        sta     LF05D,x                         ; F499
        jsr     LF139                           ; F49C
        rts                                     ; F49F

; ----------------------------------------------------------------------------
        ldy     LF084,x                         ; F4A0
        lda     LF026                           ; F4A3
        ora     LF033,y                         ; F4A6
        sta     LF026                           ; F4A9
        ldx     LF027                           ; F4AC
        jsr     LF164                           ; F4AF
        rts                                     ; F4B2

; ----------------------------------------------------------------------------
        ldy     LF084,x                         ; F4B3
        lda     LF026                           ; F4B6
        and     LF03B,y                         ; F4B9
        sta     LF026                           ; F4BC
        ldx     LF027                           ; F4BF
        jsr     LF164                           ; F4C2
        rts                                     ; F4C5

; ----------------------------------------------------------------------------
        lda     ($02),y                         ; F4C6
        tax                                     ; F4C8
        lda     #$05                            ; F4C9
        sta     LF0F9,x                         ; F4CB
        rts                                     ; F4CE

; ----------------------------------------------------------------------------
        lda     ($02),y                         ; F4CF
        tax                                     ; F4D1
        lda     #$00                            ; F4D2
        sta     LF0F9,x                         ; F4D4
        rts                                     ; F4D7

; ----------------------------------------------------------------------------
        lda     ($02),y                         ; F4D8
LF4DA:  pha                                     ; F4DA
        tax                                     ; F4DB
        lda     LF0C3,x                         ; F4DC
        sta     LF0B7,x                         ; F4DF
        lda     LF0C9,x                         ; F4E2
        sta     LF0BD,x                         ; F4E5
        lda     #$01                            ; F4E8
        sta     LF0F9,x                         ; F4EA
        cpx     #$03                            ; F4ED
        bmi     LF4FE                           ; F4EF
        ldx     LF050                           ; F4F1
        inx                                     ; F4F4
        inx                                     ; F4F5
        inx                                     ; F4F6
        sta     LF111,x                         ; F4F7
        pla                                     ; F4FA
        jmp     LF505                           ; F4FB

; ----------------------------------------------------------------------------
LF4FE:  ldx     LF050                           ; F4FE
        sta     LF111,x                         ; F501
        pla                                     ; F504
LF505:  tax                                     ; F505
        lda     #$00                            ; F506
        sta     LF0E1,x                         ; F508
        sta     LF0E7,x                         ; F50B
        lda     #$01                            ; F50E
        sta     LF0FF,x                         ; F510
        rts                                     ; F513

; ----------------------------------------------------------------------------
        lda     ($02),y                         ; F514
        sta     LF045                           ; F516
LF519:  lda     #$01                            ; F519
        sta     LF111,x                         ; F51B
        lda     #$00                            ; F51E
        sta     LF11D,x                         ; F520
        sta     LF123,x                         ; F523
        lda     #$02                            ; F526
        sta     LF129,x                         ; F528
        txa                                     ; F52B
        ldx     LF045                           ; F52C
        sta     LF105,x                         ; F52F
        lda     #$00                            ; F532
        sta     LF0ED,x                         ; F534
        sta     LF0F3,x                         ; F537
        ldy     $02                             ; F53A
        lda     #$01                            ; F53C
        sta     LF0F9,x                         ; F53E
        iny                                     ; F541
        iny                                     ; F542
        tya                                     ; F543
        sta     LF0C3,x                         ; F544
        sta     LF0B7,x                         ; F547
        ldy     $03                             ; F54A
        bcc     LF54F                           ; F54C
        iny                                     ; F54E
LF54F:  tya                                     ; F54F
        sta     LF0C9,x                         ; F550
        sta     LF0BD,x                         ; F553
        lda     #$01                            ; F556
        sta     LF044                           ; F558
        lda     #$02                            ; F55B
        sta     LF043                           ; F55D
        rts                                     ; F560

; ----------------------------------------------------------------------------
        lda     ($02),y                         ; F561
        sta     LF045                           ; F563
        stx     LF022                           ; F566
        lda     #$03                            ; F569
        clc                                     ; F56B
        adc     LF022                           ; F56C
        tax                                     ; F56F
        jmp     LF519                           ; F570

; ----------------------------------------------------------------------------
        lda     LF044                           ; F573
        cmp     #$01                            ; F576
        bne     LF5B3                           ; F578
        ldx     LF045                           ; F57A
        lda     ($02),y                         ; F57D
        sta     LF0D5,x                         ; F57F
        iny                                     ; F582
        lda     ($02),y                         ; F583
        sta     LF0DB,x                         ; F585
        iny                                     ; F588
LF589:  lda     ($02),y                         ; F589
        sta     LF0ED,x                         ; F58B
        iny                                     ; F58E
        lda     ($02),y                         ; F58F
        sta     LF0F3,x                         ; F591
        iny                                     ; F594
        lda     ($02),y                         ; F595
        sta     LF0CF,x                         ; F597
        sta     LF0FF,x                         ; F59A
        iny                                     ; F59D
        lda     ($02),y                         ; F59E
        sta     LF0E1,x                         ; F5A0
        iny                                     ; F5A3
        lda     ($02),y                         ; F5A4
        sta     LF0E7,x                         ; F5A6
        lda     #$03                            ; F5A9
        sta     LF044                           ; F5AB
        lda     #$01                            ; F5AE
        sta     LF047                           ; F5B0
LF5B3:  rts                                     ; F5B3

; ----------------------------------------------------------------------------
        lda     LF044                           ; F5B4
        cmp     #$01                            ; F5B7
        bne     LF5C1                           ; F5B9
        ldx     LF045                           ; F5BB
        jmp     LF589                           ; F5BE

; ----------------------------------------------------------------------------
LF5C1:  rts                                     ; F5C1

; ----------------------------------------------------------------------------
        lda     LF044                           ; F5C2
        cmp     #$01                            ; F5C5
        bne     LF5DC                           ; F5C7
        ldx     LF045                           ; F5C9
        lda     ($02),y                         ; F5CC
        sta     LF0D5,x                         ; F5CE
        iny                                     ; F5D1
        lda     ($02),y                         ; F5D2
        sta     LF0DB,x                         ; F5D4
        lda     #$02                            ; F5D7
        sta     LF047                           ; F5D9
LF5DC:  rts                                     ; F5DC

; ----------------------------------------------------------------------------
        lda     LF044                           ; F5DD
        cmp     #$01                            ; F5E0
        bne     LF60C                           ; F5E2
        ldx     LF045                           ; F5E4
        lda     #$01                            ; F5E7
        sta     LF0CF,x                         ; F5E9
        sta     LF0FF,x                         ; F5EC
        lda     ($02),y                         ; F5EF
        sta     LF0E1,x                         ; F5F1
        iny                                     ; F5F4
        lda     ($02),y                         ; F5F5
        sta     LF0E7,x                         ; F5F7
        lda     #$00                            ; F5FA
        sta     LF0ED,x                         ; F5FC
        sta     LF0F3,x                         ; F5FF
        lda     #$03                            ; F602
        sta     LF044                           ; F604
        lda     #$01                            ; F607
        sta     LF047                           ; F609
LF60C:  rts                                     ; F60C

; ----------------------------------------------------------------------------
        lda     LF044                           ; F60D
        cmp     #$01                            ; F610
        bne     LF626                           ; F612
        ldx     LF045                           ; F614
        lda     #$05                            ; F617
        sta     LF0F9,x                         ; F619
        lda     #$03                            ; F61C
        sta     LF044                           ; F61E
        lda     #$01                            ; F621
        sta     LF047                           ; F623
LF626:  rts                                     ; F626

; ----------------------------------------------------------------------------
        lda     LF044                           ; F627
        cmp     #$01                            ; F62A
        bne     LF63B                           ; F62C
        ldx     LF045                           ; F62E
        lda     #$00                            ; F631
        sta     LF0F9,x                         ; F633
        lda     #$01                            ; F636
        sta     LF047                           ; F638
LF63B:  rts                                     ; F63B

; ----------------------------------------------------------------------------
        lda     LF043                           ; F63C
        cmp     #$01                            ; F63F
        beq     LF64F                           ; F641
        lda     LF044                           ; F643
        cmp     #$01                            ; F646
        bne     LF64F                           ; F648
        lda     #$03                            ; F64A
        sta     LF044                           ; F64C
LF64F:  rts                                     ; F64F

; ----------------------------------------------------------------------------
        ldx     LF045                           ; F650
        lda     LF105,x                         ; F653
        tax                                     ; F656
        lda     ($02),y                         ; F657
        sta     LF129,x                         ; F659
        rts                                     ; F65C

; ----------------------------------------------------------------------------
LF65D:  sta     LF094,x                         ; F65D
        cmp     #$FE                            ; F660
        bne     LF66A                           ; F662
LF664:  jsr     LF2C5                           ; F664
        jmp     LF69D                           ; F667

; ----------------------------------------------------------------------------
LF66A:  and     #$7F                            ; F66A
        sty     LF024                           ; F66C
        clc                                     ; F66F
        adc     LF09D,x                         ; F670
        clc                                     ; F673
        adc     LF032                           ; F674
        cmp     #$60                            ; F677
        bpl     LF664                           ; F679
        tay                                     ; F67B
        lda     LF823,y                         ; F67C
        sta     LF055,x                         ; F67F
        lda     LF7C3,y                         ; F682
        sta     LF051,x                         ; F685
        jsr     LF2BC                           ; F688
        ldy     LF0A0,x                         ; F68B
        cpy     #$FF                            ; F68E
        beq     LF69A                           ; F690
        txa                                     ; F692
        pha                                     ; F693
        tya                                     ; F694
        jsr     LF4DA                           ; F695
        pla                                     ; F698
        tax                                     ; F699
LF69A:  ldy     LF024                           ; F69A
LF69D:  iny                                     ; F69D
        lda     ($02),y                         ; F69E
        tay                                     ; F6A0
        lda     LF883,y                         ; F6A1
        sta     LF07A,x                         ; F6A4
        lda     LF8C4,y                         ; F6A7
        sta     LF07D,x                         ; F6AA
        lda     LF097,x                         ; F6AD
        tay                                     ; F6B0
        lda     LF782,y                         ; F6B1
        sta     LF6BE                           ; F6B4
        lda     LF785,y                         ; F6B7
        sta     LF6BF                           ; F6BA
        .byte   $20                             ; F6BD
LF6BE:  .byte   $11                             ; F6BE
LF6BF:  ora     ($A9),y                         ; F6BF
        .byte   $02                             ; F6C1
        clc                                     ; F6C2
        adc     $02                             ; F6C3
        sta     $02                             ; F6C5
        sta     LF06A,x                         ; F6C7
        lda     $03                             ; F6CA
        adc     #$00                            ; F6CC
        sta     $03                             ; F6CE
        sta     LF06E,x                         ; F6D0
        rts                                     ; F6D3

; ----------------------------------------------------------------------------
LF6D4:  ldx     #$02                            ; F6D4
LF6D6:  lda     LF0AB,x                         ; F6D6
        beq     LF6E3                           ; F6D9
        jsr     LF6E7                           ; F6DB
        lda     #$00                            ; F6DE
        sta     LF0AB,x                         ; F6E0
LF6E3:  dex                                     ; F6E3
        bpl     LF6D6                           ; F6E4
        rts                                     ; F6E6

; ----------------------------------------------------------------------------
LF6E7:  lda     LF0B1,x                         ; F6E7
        beq     LF718                           ; F6EA
        sta     $05                             ; F6EC
        lda     LF0AE,x                         ; F6EE
        sta     $04                             ; F6F1
        ldy     LF0B4,x                         ; F6F3
        lda     ($04),y                         ; F6F6
        cmp     #$FF                            ; F6F8
        beq     LF718                           ; F6FA
        cmp     #$FE                            ; F6FC
        bne     LF708                           ; F6FE
        ldy     #$00                            ; F700
        tya                                     ; F702
        sta     LF0B4,x                         ; F703
        lda     ($04),y                         ; F706
LF708:  ldy     #$01                            ; F708
        sty     LF046                           ; F70A
        jsr     LEC18                           ; F70D
        ldy     #$00                            ; F710
        sty     LF046                           ; F712
        inc     LF0B4,x                         ; F715
LF718:  rts                                     ; F718

; ----------------------------------------------------------------------------
        tay                                     ; F719
        lda     LFFCC,y                         ; F71A
        beq     LF718                           ; F71D
        sta     LF0B1,x                         ; F71F
        lda     LFFC7,y                         ; F722
        sta     LF0AE,x                         ; F725
LF728:  lda     #$00                            ; F728
        sta     LF0B4,x                         ; F72A
        sta     LF0AB,x                         ; F72D
        jmp     LF6E7                           ; F730

; ----------------------------------------------------------------------------
        sta     LF0AE,x                         ; F733
        tya                                     ; F736
        sta     LF0B1,x                         ; F737
        jmp     LF728                           ; F73A

; ----------------------------------------------------------------------------
        tay                                     ; F73D
        lda     LFFCC,y                         ; F73E
        beq     LF751                           ; F741
        sta     LF0B1,x                         ; F743
        lda     LFFC7,y                         ; F746
        sta     LF0AE,x                         ; F749
        lda     #$00                            ; F74C
        sta     LF0B4,x                         ; F74E
LF751:  rts                                     ; F751

; ----------------------------------------------------------------------------
        sta     LF031                           ; F752
        txa                                     ; F755
        pha                                     ; F756
        lda     #$00                            ; F757
        sta     LF883                           ; F759
        sta     LF8C4                           ; F75C
        lda     #$FF                            ; F75F
        sta     LF021                           ; F761
        ldy     #$01                            ; F764
LF766:  clc                                     ; F766
        adc     LF031                           ; F767
        sta     LF883,y                         ; F76A
        bcc     LF772                           ; F76D
        inc     LF021                           ; F76F
LF772:  tax                                     ; F772
        lda     LF021                           ; F773
        sta     LF8C4,y                         ; F776
        txa                                     ; F779
        iny                                     ; F77A
        cpy     #$41                            ; F77B
        bmi     LF766                           ; F77D
        pla                                     ; F77F
        tax                                     ; F780
        rts                                     ; F781

; ----------------------------------------------------------------------------
LF782:  dey                                     ; F782
        sty     $A7,x                           ; F783
LF785:  .byte   $F7                             ; F785
        .byte   $F7                             ; F786
        .byte   $F7                             ; F787
        lda     LF09A,x                         ; F788
        sta     LF072,x                         ; F78B
        lda     #$00                            ; F78E
        sta     LF076,x                         ; F790
        rts                                     ; F793

; ----------------------------------------------------------------------------
        lda     LF07A,x                         ; F794
        sec                                     ; F797
        sbc     LF09A,x                         ; F798
        sta     LF072,x                         ; F79B
        lda     LF07D,x                         ; F79E
        sbc     #$00                            ; F7A1
        sta     LF076,x                         ; F7A3
        rts                                     ; F7A6

; ----------------------------------------------------------------------------
        lda     LF07D,x                         ; F7A7
        sta     LF076,x                         ; F7AA
        lda     LF07A,x                         ; F7AD
        sta     LF072,x                         ; F7B0
        ldy     LF09A,x                         ; F7B3
        beq     LF7C2                           ; F7B6
LF7B8:  clc                                     ; F7B8
        ror     LF076,x                         ; F7B9
        ror     LF072,x                         ; F7BC
        dey                                     ; F7BF
        bpl     LF7B8                           ; F7C0
LF7C2:  rts                                     ; F7C2

; ----------------------------------------------------------------------------
LF7C3:  .byte   $0C,$1C,$2D,$3E,$51,$66,$7B,$91 ; F7C3
        .byte   $A9,$C3,$DD,$FA,$18,$38,$5A,$7D ; F7CB
        .byte   $A3,$CC,$F6,$23,$53,$86,$BB,$F4 ; F7D3
        .byte   $30,$70,$B4,$FB,$47,$98,$ED,$47 ; F7DB
        .byte   $A7,$0C,$77,$E9,$61,$E1,$68,$F7 ; F7E3
        .byte   $8F,$30,$DA,$8F,$4E,$18,$EF,$D2 ; F7EB
        .byte   $C3,$C3,$D1,$EF,$1F,$60,$B5,$1E ; F7F3
        .byte   $9C,$31,$DF,$A5,$87,$86,$A2,$DF ; F7FB
        .byte   $3E,$C1,$6B,$3C,$39,$63,$BE,$4B ; F803
        .byte   $0F,$0C,$45,$BF,$7D,$83,$D6,$79 ; F80B
        .byte   $73,$C7,$7C,$97,$1E,$18,$8B,$7E ; F813
        .byte   $FA,$06,$AC,$F3,$E6,$8F,$F8,$2E ; F81B
LF823:  .byte   $01,$01,$01,$01,$01,$01,$01,$01 ; F823
        .byte   $01,$01,$01,$01,$02,$02,$02,$02 ; F82B
        .byte   $02,$02,$02,$03,$03,$03,$03,$03 ; F833
        .byte   $04,$04,$04,$04,$05,$05,$05,$06 ; F83B
        .byte   $06,$07,$07,$07,$08,$08,$09,$09 ; F843
        .byte   $0A,$0B,$0B,$0C,$0D,$0E,$0E,$0F ; F84B
        .byte   $10,$11,$12,$13,$15,$16,$17,$19 ; F853
        .byte   $1A,$1C,$1D,$1F,$21,$23,$25,$27 ; F85B
        .byte   $2A,$2C,$2F,$32,$35,$38,$3B,$3F ; F863
        .byte   $43,$47,$4B,$4F,$54,$59,$5E,$64 ; F86B
        .byte   $6A,$70,$77,$7E,$86,$8E,$96,$9F ; F873
        .byte   $A8,$B3,$BD,$C8,$D4,$E1,$EE,$FD ; F87B
LF883:  .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; F883
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; F88B
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; F893
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; F89B
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; F8A3
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; F8AB
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; F8B3
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; F8BB
        .byte   $00                             ; F8C3
LF8C4:  .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; F8C4
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; F8CC
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; F8D4
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; F8DC
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; F8E4
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; F8EC
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; F8F4
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; F8FC
        .byte   $00,$60                         ; F904
; ----------------------------------------------------------------------------
        lda     LF06A,x                         ; F906
        sta     LF049                           ; F909
        lda     LF06E,x                         ; F90C
        sta     LF04A                           ; F90F
        lda     ($02),y                         ; F912
        tay                                     ; F914
        lda     LFFAD,y                         ; F915
LF918:  beq     LF945                           ; F918
        sta     LF06E,x                         ; F91A
        lda     LFF93,y                         ; F91D
        sta     LF06A,x                         ; F920
        lda     #$01                            ; F923
        sta     LF048                           ; F925
        jsr     LEE50                           ; F928
        lda     #$02                            ; F92B
        sta     LF048                           ; F92D
        lda     LF04A                           ; F930
        sta     LF06E,x                         ; F933
        sta     $03                             ; F936
        lda     LF049                           ; F938
        sta     LF06A,x                         ; F93B
        sta     $02                             ; F93E
        lda     #$2F                            ; F940
        sta     LF04D                           ; F942
LF945:  rts                                     ; F945

; ----------------------------------------------------------------------------
        .byte   $A9,$00,$9D,$97,$F0,$B1,$02,$9D ; F946
        .byte   $9A,$F0,$60,$A9,$01,$9D,$97,$F0 ; F94E
        .byte   $B1,$02,$9D,$9A,$F0,$60,$A9,$02 ; F956
        .byte   $9D,$97,$F0,$B1,$02,$9D,$9A,$F0 ; F95E
        .byte   $60,$B1,$02,$20,$52,$F7,$60,$B1 ; F966
        .byte   $02,$8D,$32,$F0,$60,$B1,$02,$9D ; F96E
        .byte   $9D,$F0,$60,$A9,$01,$9D,$AB,$F0 ; F976
        .byte   $60,$B1,$02,$9D,$A0,$F0,$60,$18 ; F97E
        .byte   $1C,$25,$00,$00,$81,$9B,$EB,$2C ; F986
        .byte   $29,$E8,$03,$2A,$0F,$2B,$01,$21 ; F98E
        .byte   $02,$49,$01,$3B,$AC,$92,$43,$E5 ; F996
        .byte   $01,$58,$02,$46,$0C,$C8,$00,$02 ; F99E
        .byte   $0C,$28,$00,$FF,$09,$08,$23,$01 ; F9A6
        .byte   $A7,$2D,$0B,$0F,$28,$26,$03,$F0 ; F9AE
        .byte   $D2,$01,$21,$02,$49,$02,$40,$02 ; F9B6
        .byte   $00,$3F,$0C,$30,$40,$01,$00,$3F ; F9BE
        .byte   $B8,$88,$40,$01,$00,$3F,$6A,$36 ; F9C6
        .byte   $40,$02,$00,$3F,$F2,$2F,$40,$02 ; F9CE
        .byte   $00,$3B,$E0,$B1,$60,$F0,$01,$28 ; F9D6
        .byte   $00,$46,$0C,$0A,$00,$02,$0C,$1E ; F9DE
        .byte   $00,$FF,$23,$01,$B5,$2D,$03,$84 ; F9E6
        .byte   $03,$24,$81,$21,$02,$49,$02,$3B ; F9EE
        .byte   $60,$70,$4D,$01,$01,$03,$00,$3B ; F9F6
        .byte   $00,$00,$F6,$FF,$01,$28,$00,$46 ; F9FE
        .byte   $0C,$04,$00,$02,$0C,$0A,$00,$FF ; FA06
        .byte   $23,$98,$00,$03,$30,$11,$24,$81 ; FA0E
        .byte   $21,$02,$49,$01,$3B,$F6,$FF,$FE ; FA16
        .byte   $FF,$01,$28,$00,$46,$0C,$21,$00 ; FA1E
        .byte   $02,$FF,$23,$88,$00,$03,$00,$19 ; FA26
        .byte   $24,$81,$21,$02,$49,$01,$3B,$F8 ; FA2E
        .byte   $FF,$F8,$FF,$01,$28,$00,$46,$0C ; FA36
        .byte   $18,$00,$02,$FF,$23,$67,$00,$03 ; FA3E
        .byte   $80,$25,$24,$81,$21,$02,$49,$01 ; FA46
        .byte   $3B,$EC,$FF,$DB,$FF,$01,$28,$00 ; FA4E
        .byte   $46,$0C,$13,$00,$02,$FF,$23,$56 ; FA56
        .byte   $00,$03,$89,$2D,$24,$81,$21,$02 ; FA5E
        .byte   $49,$01,$3B,$B0,$FF,$D8,$FF,$01 ; FA66
        .byte   $28,$00,$46,$0C,$10,$00,$02,$FF ; FA6E
        .byte   $23,$97,$00,$03,$B8,$0B,$24,$81 ; FA76
        .byte   $21,$02,$49,$01,$3B,$05,$00,$04 ; FA7E
        .byte   $00,$01,$28,$00,$46,$0C,$1E,$00 ; FA86
        .byte   $02,$FF,$23,$95,$00,$03,$24,$13 ; FA8E
        .byte   $24,$81,$21,$02,$49,$01,$3B,$09 ; FA96
        .byte   $00,$05,$00,$01,$28,$00,$46,$0C ; FA9E
        .byte   $1A,$00,$02,$FF,$23,$86,$00,$03 ; FAA6
        .byte   $64,$19,$24,$81,$21,$02,$49,$01 ; FAAE
        .byte   $3B,$0E,$00,$08,$00,$01,$28,$00 ; FAB6
        .byte   $46,$0C,$13,$00,$02,$FF,$23,$84 ; FABE
        .byte   $00,$03,$40,$1F,$24,$81,$21,$02 ; FAC6
        .byte   $49,$01,$3B,$19,$00,$2D,$00,$01 ; FACE
        .byte   $28,$00,$46,$0C,$0F,$00,$02,$FF ; FAD6
        .byte   $18,$87,$21,$2C,$01,$41,$00,$E3 ; FADE
        .byte   $2D,$22,$02,$3B,$00,$00,$86,$00 ; FAE6
        .byte   $01,$A0,$0F,$46,$0C,$02,$00,$03 ; FAEE
        .byte   $3C,$32,$0C,$02,$00,$03,$BE,$3B ; FAF6
        .byte   $0C,$02,$00,$03,$0F,$43,$0C,$04 ; FAFE
        .byte   $00,$02,$0C,$12,$00,$FF,$18,$00 ; FB06
        .byte   $00,$00,$00,$80,$06,$C6,$2D,$34 ; FB0E
        .byte   $00,$35,$00,$30,$04,$21,$00,$3B ; FB16
        .byte   $96,$00,$00,$00,$01,$FF,$FF,$46 ; FB1E
        .byte   $0E,$87,$02,$87,$02,$C5,$02,$C5 ; FB26
        .byte   $02,$87,$04,$C5,$04,$87,$02,$87 ; FB2E
        .byte   $02,$C5,$02,$87,$02,$87,$02,$87 ; FB36
        .byte   $02,$C5,$02,$C5,$02,$0F,$02,$3A ; FB3E
        .byte   $FF,$18,$00,$00,$00,$00,$80,$07 ; FB46
        .byte   $F7,$2C,$2B,$04,$2A,$0F,$29,$6C ; FB4E
        .byte   $07,$35,$00,$30,$02,$21,$01,$3B ; FB56
        .byte   $00,$00,$00,$80,$01,$FF,$FF,$46 ; FB5E
        .byte   $0E,$DF,$02,$0F,$20,$3A,$FF,$18 ; FB66
        .byte   $00,$00,$2C,$01,$40,$21,$94,$2D ; FB6E
        .byte   $31,$02,$35,$F4,$33,$06,$0E,$A4 ; FB76
        .byte   $02,$0F,$0E,$A2,$02,$A3,$02,$0E ; FB7E
        .byte   $A4,$02,$0F,$0D,$A1,$02,$A2,$02 ; FB86
        .byte   $A3,$02,$3A,$FF,$18,$00,$00,$00 ; FB8E
        .byte   $00,$80,$06,$C6,$2D,$34,$00,$35 ; FB96
        .byte   $00,$30,$04,$21,$01,$3B,$96,$00 ; FB9E
        .byte   $00,$00,$01,$FF,$FF,$46,$0E,$87 ; FBA6
        .byte   $02,$87,$02,$C5,$02,$C5,$02,$87 ; FBAE
        .byte   $04,$C5,$04,$87,$02,$87,$02,$C5 ; FBB6
        .byte   $02,$87,$02,$87,$02,$87,$02,$C5 ; FBBE
        .byte   $02,$C5,$02,$0F,$06,$3A,$FF,$18 ; FBC6
        .byte   $00,$00,$2C,$01,$40,$88,$06,$2D ; FBCE
        .byte   $35,$00,$31,$02,$22,$04,$3B,$00 ; FBD6
        .byte   $00,$04,$00,$01,$BC,$02,$3D,$FC ; FBDE
        .byte   $FF,$01,$E8,$FD,$46,$0E,$A4,$01 ; FBE6
        .byte   $FE,$01,$0F,$08,$0E,$A7,$01,$FE ; FBEE
        .byte   $01,$0F,$08,$0E,$A9,$01,$FE     ; FBF6
LFBFD:  .byte   $01,$0F,$08,$AA,$03,$FE,$01,$AA ; FBFD
        .byte   $01,$FE,$01,$AB,$02,$FE,$02,$AB ; FC05
        .byte   $01,$FE,$01,$AB,$02,$FE,$02,$B0 ; FC0D
        .byte   $02,$FE,$02,$0E,$B0,$01,$FE,$01 ; FC15
        .byte   $0F,$05,$B3,$03,$FE,$01,$B3,$03 ; FC1D
        .byte   $FE,$01,$0E,$B3,$01,$FE,$01,$0F ; FC25
        .byte   $03,$B3,$03,$FE,$01,$B5,$03,$0E ; FC2D
        .byte   $FE,$01,$B5,$01,$0F,$03,$FE,$01 ; FC35
        .byte   $B0,$03,$FE,$01,$B0,$10,$FE,$02 ; FC3D
        .byte   $B0,$03,$FE,$01,$B0,$01,$FE,$01 ; FC45
        .byte   $B0,$01,$FE,$01,$B0,$02,$AB,$01 ; FC4D
        .byte   $FE,$01,$AE,$02,$B0,$03,$FE,$01 ; FC55
        .byte   $B0,$02,$FE,$02,$B0,$01,$FE,$01 ; FC5D
        .byte   $AB,$03,$FE,$01,$AB,$03,$FE,$01 ; FC65
        .byte   $A9,$02,$FE,$02,$AB,$02,$A9,$01 ; FC6D
        .byte   $FE,$01,$AB,$02,$A7,$04,$A4,$02 ; FC75
        .byte   $A4,$01,$FE,$01,$A4,$01,$FE,$01 ; FC7D
        .byte   $0E,$A4,$01,$FE,$01,$0F,$06,$3A ; FC85
        .byte   $FF,$18,$00,$00,$00,$08,$20,$34 ; FC8D
        .byte   $82,$2D,$31,$03,$35,$00,$33,$06 ; FC95
        .byte   $0E,$98,$02,$0F,$08,$0E,$9B,$02 ; FC9D
        .byte   $0F,$08,$0E,$9D,$02,$0F,$08,$9E ; FCA5
        .byte   $02,$9E,$02,$9E,$02,$9F,$02,$9F ; FCAD
        .byte   $02,$9F,$02,$9F,$02,$9F,$02,$0E ; FCB5
        .byte   $A4,$02,$0F,$08,$0E,$9B,$02,$0F ; FCBD
        .byte   $08,$0E,$9F,$02,$0F,$06,$A2,$02 ; FCC5
        .byte   $A2,$02,$0E,$A4,$02,$0F,$05,$9F ; FCCD
        .byte   $02,$A2,$02,$A3,$02,$A4,$02,$0E ; FCD5
        .byte   $A4,$02,$0F,$07,$0E,$9D,$02,$0F ; FCDD
        .byte   $08,$0E,$9F,$02,$0F,$06,$9B,$02 ; FCE5
        .byte   $9B,$02,$0E,$98,$02,$0F,$08,$3A ; FCED
        .byte   $FF,$18,$00,$00,$10,$05,$40,$33 ; FCF5
        .byte   $B3,$2D,$31,$02                 ; FCFD
LFD01:  .byte   $35,$F4,$33,$06,$22,$03,$3B,$00 ; FD01
        .byte   $00,$EA,$FF,$01,$30,$00,$3D,$16 ; FD09
        .byte   $00,$01,$30,$00,$3D,$EA,$FF,$01 ; FD11
        .byte   $30,$00,$3D,$16,$00,$01,$30,$00 ; FD19
        .byte   $3D,$EA,$FF,$01,$30,$00,$3D,$16 ; FD21
        .byte   $00,$01,$30,$00,$3D,$EA,$FF,$01 ; FD29
        .byte   $30,$00,$3D,$16,$00,$01,$30,$00 ; FD31
        .byte   $3B,$00,$00,$EA,$FF,$01,$30,$00 ; FD39
        .byte   $3D,$16,$00,$01,$30,$00,$3D,$EA ; FD41
        .byte   $FF,$01,$30,$00,$3D,$16,$00,$01 ; FD49
        .byte   $30,$00,$3D,$EA,$FF,$01,$30,$00 ; FD51
        .byte   $3D,$16,$00,$01,$30,$00,$3D,$EA ; FD59
        .byte   $FF,$01,$30,$00,$3D,$16,$00,$01 ; FD61
        .byte   $30,$00,$3B,$00,$00,$EA,$FF,$01 ; FD69
        .byte   $30,$00,$3D,$16,$00,$01,$30,$00 ; FD71
        .byte   $3D,$EA,$FF,$01,$30,$00,$3D,$16 ; FD79
        .byte   $00,$01,$30,$00,$3D,$EA,$FF,$01 ; FD81
        .byte   $30,$00,$3D,$16,$00,$01,$30,$00 ; FD89
        .byte   $3D,$EA,$FF,$01,$30,$00,$3D,$16 ; FD91
        .byte   $00,$01,$30,$00,$45,$46,$98,$10 ; FD99
        .byte   $9B,$10,$9D,$10,$9E,$06,$9F,$0A ; FDA1
        .byte   $A4,$10,$9B,$10,$9F,$0C,$A2,$04 ; FDA9
        .byte   $A4,$0A,$9F,$02,$A2,$02,$A3,$02 ; FDB1
        .byte   $A4,$10,$9D,$10,$9F,$0C,$9B,$04 ; FDB9
        .byte   $98,$10,$3A,$FF,$18,$00,$00,$00 ; FDC1
        .byte   $00,$80,$05,$C5,$2D,$35,$00,$30 ; FDC9
        .byte   $04,$21,$01,$3B,$96,$00,$00,$00 ; FDD1
        .byte   $01,$FF,$FF,$46,$0E,$23,$05,$C5 ; FDD9
        .byte   $87,$02,$87,$02,$C5,$04,$87,$02 ; FDE1
        .byte   $87,$02,$C5,$02,$23,$03,$C3,$CB ; FDE9
        .byte   $01,$CB,$01,$0F,$0C,$3A,$FF,$18 ; FDF1
        .byte   $00,$00,$00,$00,$80,$05,$C5,$2D ; FDF9
        .byte   $35,$00,$30,$04,$21,$01,$3B,$96 ; FE01
        .byte   $00,$00,$00,$01,$FF,$FF,$46,$0E ; FE09
        .byte   $87,$02,$87,$02,$C5,$02,$23,$05 ; FE11
        .byte   $05,$CB,$01,$CB,$01,$23,$05,$C5 ; FE19
        .byte   $87,$02,$87,$02,$C5,$02,$C5,$02 ; FE21
        .byte   $87,$02,$87,$02,$C5,$02,$C5,$02 ; FE29
        .byte   $87,$02,$23,$05,$05,$CB,$01,$CB ; FE31
        .byte   $01,$23,$05,$C5,$C5,$02,$87,$02 ; FE39
        .byte   $0F,$06,$3A,$FF,$2D,$18,$00,$00 ; FE41
        .byte   $FF,$07,$40,$95,$63,$35,$00,$31 ; FE49
        .byte   $03,$BC,$04,$BA,$02,$BC,$04,$BA ; FE51
        .byte   $02,$BC,$02,$BA,$02,$BC,$04,$BA ; FE59
        .byte   $02,$B7,$04,$BA,$02,$BC,$02,$BA ; FE61
        .byte   $02,$BC,$04,$BA,$02,$BC,$04,$BA ; FE69
        .byte   $02,$BC,$02,$BA,$01,$FE,$01,$23 ; FE71
        .byte   $85,$63,$BF,$01,$FE,$01,$BF,$01 ; FE79
        .byte   $FE,$01,$BF,$01,$BC,$01,$BA,$02 ; FE81
        .byte   $C1,$01,$FE,$01,$C1,$01,$FE,$01 ; FE89
        .byte   $C1,$01,$BF,$01,$BC,$02,$23,$95 ; FE91
        .byte   $63,$BC,$04,$BA,$02,$BC,$04,$23 ; FE99
        .byte   $85,$63,$BA,$01,$FE,$01,$BC,$01 ; FEA1
        .byte   $FE,$01,$BA,$01,$FE,$01,$23,$95 ; FEA9
        .byte   $63,$BC,$03,$FE,$01,$BA,$02,$B7 ; FEB1
        .byte   $04,$BA,$02,$BC,$02,$BA,$01,$FE ; FEB9
        .byte   $01,$23,$85,$63,$BF,$01,$BE,$01 ; FEC1
        .byte   $BC,$02,$BA,$02,$B7,$02,$23,$95 ; FEC9
        .byte   $63,$BA,$04,$BE,$04,$BC,$0C,$FE ; FED1
        .byte   $04,$22,$05,$3B,$5C,$F9,$0A,$00 ; FED9
        .byte   $01,$10,$27,$46,$C3,$06,$C2,$06 ; FEE1
        .byte   $C1,$04,$BF,$06,$BC,$0A,$BA,$06 ; FEE9
        .byte   $B7,$06,$BF,$04,$BC,$0C,$FE,$04 ; FEF1
        .byte   $3A,$FF,$2D,$18,$00,$00,$20,$03 ; FEF9
        .byte   $40,$04,$04,$35,$F4,$31,$03,$22 ; FF01
        .byte   $05,$3B,$00,$00,$02,$00,$01,$10 ; FF09
        .byte   $27,$46,$0E,$23,$30,$92,$09,$04 ; FF11
        .byte   $BF,$01,$BC,$01,$BA,$01,$BF,$01 ; FF19
        .byte   $FE,$01,$BF,$01,$BC,$01,$BA,$01 ; FF21
        .byte   $BF,$01,$BC,$01,$BA,$01,$BA,$01 ; FF29
        .byte   $BF,$01,$BC,$01,$BA,$01,$BA,$01 ; FF31
        .byte   $BF,$01,$BC,$01,$BA,$01,$BF,$01 ; FF39
        .byte   $FE,$01,$BF,$01,$BC,$01,$BA,$01 ; FF41
        .byte   $BF,$01,$BC,$01,$BA,$01,$BA,$01 ; FF49
        .byte   $BF,$01,$BC,$01,$BA,$01,$BA,$01 ; FF51
        .byte   $BF,$01,$BC,$01,$BA,$01,$BF,$01 ; FF59
        .byte   $FE,$01,$BF,$01,$BC,$01,$BA,$01 ; FF61
        .byte   $BF,$01,$BC,$01,$BA,$01,$BA,$01 ; FF69
        .byte   $BF,$01,$BC,$01,$BA,$01,$BA,$01 ; FF71
        .byte   $23,$84,$A5,$09,$02,$C2,$02,$C3 ; FF79
        .byte   $02,$C2,$02,$C3,$02,$BF,$04,$BC ; FF81
        .byte   $04,$0F,$03,$3A,$FF,$FF,$FF,$FF ; FF89
        .byte   $FF,$FF                         ; FF91
LFF93:  .byte   $85,$85,$AA,$AA,$AA,$E8,$0E,$28 ; FF93
        .byte   $42,$5C,$76,$90,$AA,$C4,$DE,$0C ; FF9B
        .byte   $47,$6D,$92,$CD,$8E,$F6,$C5,$F8 ; FFA3
        .byte   $45,$FB                         ; FFAB
LFFAD:  .byte   $F9,$F9,$F9,$F9,$F9,$F9,$FA,$FA ; FFAD
        .byte   $FA,$FA,$FA,$FA,$FA,$FA,$FA,$FB ; FFB5
        .byte   $FB,$FB,$FB,$FB,$FC,$FC,$FD,$FD ; FFBD
        .byte   $FE,$FE                         ; FFC5
LFFC7:  .byte   $8E,$8F,$90,$91,$92             ; FFC7
LFFCC:  .byte   $FF,$FF,$FF,$FF,$FF,$00,$00,$00 ; FFCC
