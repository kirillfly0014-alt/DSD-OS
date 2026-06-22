cat > stage2.asm << 'EOF'
[org 0x7e00]
[bits 16]

start:
    call cls
    call boot_screen

main_loop:
    call cls
    mov si, msg_main_menu
    call print_string
    mov si, prompt
    call print_string

    mov ah, 0x00
    int 0x16
    mov bl, al

    cmp bl, 'd'
    je cmd_dir
    cmp bl, 'D'
    je cmd_dir

    cmp bl, 'h'
    je cmd_help
    cmp bl, 'H'
    je cmd_help

    cmp bl, 'e'
    je cmd_exit
    cmp bl, 'E'
    je cmd_exit

    cmp bl, 's'
    je cmd_sysinfo
    cmp bl, 'S'
    je cmd_sysinfo

    cmp bl, 'r'
    je cmd_read_bad
    cmp bl, 'R'
    je cmd_read_bad

    mov si, msg_unknown
    call print_string
    jmp main_loop

cmd_dir:
    call disk_menu
    jmp main_loop

cmd_help:
    mov si, msg_help
    call print_string
    call wait_key
    jmp main_loop

cmd_exit:
    mov si, msg_exit
    call print_string
    jmp $

cmd_sysinfo:
    call show_sysinfo
    jmp main_loop

cmd_read_bad:
    call bsod_trigger
    jmp main_loop

boot_screen:
    call cls
    mov si, msg_boot_screen
    call print_string
    call delay
    call delay
    call delay
    ret

disk_menu:
    call cls
    mov si, msg_disk_header
    call print_string
    mov byte [disk_count], 1
    jmp .one_disk
.no_disks:
    mov si, msg_warning_triangle
    call print_string
    mov si, msg_no_disks
    call print_string
    call wait_key
    ret
.one_disk:
    mov si, msg_one_disk
    call print_string
    mov si, msg_one_disk_content
    call print_string
    call wait_key
    ret

show_sysinfo:
    call cls
    mov si, msg_sysinfo
    call print_string
    call wait_key
    ret

error_00110bis:
    call cls
    mov si, msg_00110bis
    call print_string
    call wait_key
    ret

bsod_trigger:
    call cls
    mov ah, 0x06
    mov al, 0
    mov bh, 0x00
    mov cx, 0
    mov dx, 0x184f
    int 0x10
    mov si, msg_bsod
    call print_string
    call wait_key
    ret

cls:
    mov ah, 0x06
    mov al, 0
    mov bh, 0x07
    mov cx, 0
    mov dx, 0x184f
    int 0x10
    mov ah, 0x02
    mov bh, 0
    mov dx, 0
    int 0x10
    ret

delay:
    mov cx, 0xffff
.delay_loop:
    loop .delay_loop
    ret

print_string:
    lodsb
    or al, al
    jz .done
    mov ah, 0x0e
    int 0x10
    jmp print_string
.done:
    ret

wait_key:
    mov ah, 0x00
    int 0x16
    ret

msg_main_menu db 0x0d, 0x0a, 'DSD v1.0 - Del Set Dos', 0x0d, 0x0a, 'Press: (D)IR, (H)ELP, (E)XIT, (S)YSINFO, (R)EAD_BAD', 0x0d, 0x0a, 0
prompt db 'C:\> ', 0
msg_unknown db 0x0d, 0x0a, 'Unknown key. Press D, H, E, S, R.', 0x0d, 0x0a, 0
msg_help db 0x0d, 0x0a, 'D - DIR (disk menu)', 0x0d, 0x0a, 'H - Help', 0x0d, 0x0a, 'E - Exit', 0x0d, 0x0a, 'S - Sysinfo', 0x0d, 0x0a, 'R - Read Bad (BSOD)', 0x0d, 0x0a, 0
msg_exit db 0x0d, 0x0a, 'Shutting down...', 0x0d, 0x0a, 0
msg_sysinfo db 0x0d, 0x0a, 'CPU: 8086', 0x0d, 0x0a, 'RAM: 640KB', 0x0d, 0x0a, 'Video: MDA', 0x0d, 0x0a, 'Brand: IBM PC/XT', 0x0d, 0x0a, 0
msg_disk_header db 0x0d, 0x0a, '=== DISK MENU ===', 0x0d, 0x0a, 0
msg_warning_triangle db 0x0d, 0x0a, '⚠️  WARNING: No disks!', 0x0d, 0x0a, 0
msg_no_disks db 0x0d, 0x0a, 'No Diskets.', 0x0d, 0x0a, '(Q to exit)', 0x0d, 0x0a, 0
msg_one_disk db 0x0d, 0x0a, '1 disk: DSD_BOOT.COM, README.TXT', 0x0d, 0x0a, 0
msg_one_disk_content db 0x0d, 0x0a, 'Press any key', 0x0d, 0x0a, 0
msg_00110bis db 0x0d, 0x0a, 'ERROR: 0x00110bis', 0x0d, 0x0a
             db 'Bad Installing System', 0x0d, 0x0a
             db 'Disk removed during installation.', 0x0d, 0x0a
             db 'Please insert the disk and restart.', 0x0d, 0x0a, 0
msg_bsod db 0x0d, 0x0a, ':(', 0x0d, 0x0a
         db 'Your system ran into a problem and needs to restart.', 0x0d, 0x0a
         db 'You are reading a corrupted file.', 0x0d, 0x0a
         db 'Never do that again.', 0x0d, 0x0a
         db 'Error Code: 0x002bs0d', 0x0d, 0x0a, 0
msg_boot_screen db 0x0d, 0x0a, '          DSD v1.0', 0x0d, 0x0a
                 db '   Del Set Dos', 0x0d, 0x0a
                 db 'Loading system...', 0x0d, 0x0a, 0

cmd_buffer times 64 db 0
disk_count db 0
EOF
