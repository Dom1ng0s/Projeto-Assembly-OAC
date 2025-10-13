section .data
    message db 'Hello World!', 0

section .text
    global main
    extern printf

main:
    sub rsp, 40
    mov rcx, message
    call printf
    add rsp, 40
    ret

