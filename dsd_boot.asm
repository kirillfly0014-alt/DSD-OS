cat > dsd_boot.asm << 'EOF'
[org 0x7c00]
[bits 16]
start:
    mov ah, 0x01
    mov cx, 0x2000
    int 0x10
    mov ah, 0x06
    mov al, 0
    mov bh, 0x07
    mov cx, 0
    mov dx, 0x184f
    int 0x10
    mov si, msg_loading
    call print_string
    mov ax, 0x07e0
    mov es, ax
    mov bx, 0
    mov ah, 0x02
    mov al, 8
    mov ch, 0
    mov cl, 2
    mov dh, 0
    mov dl, 0
    int 0x13
    jmp 0x07e0:0
print_string:
    lodsb
    or al, al
    jz .done
    mov ah, 0x0e
    int 0x10
    jmp print_string
.done:
    ret
msg_loading db 'BOOT: DSD v1.0 Loading...', 0x0d, 0x0a, 0
times 510-($-$$) db 0
dw 0xaa55
EOF
