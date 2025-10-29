; -------------------------------
; SEÇÃO DE DADOS INICIAIS (.data)
; -------------------------------
section .data
    stringpronta: db "hello ,world!", 0xA  ; exemplo de string fixa (não usada no fluxo principal)
    len equ $ - stringpronta               ; calcula o tamanho da string

; -------------------------------
; SEÇÃO DE DADOS NÃO INICIALIZADOS (.bss)
; -------------------------------
section .bss
    entrada: resb 256   ; reserva 256 bytes para armazenar a entrada do usuário (string)
    saida:   resb 256   ; reserva 256 bytes para armazenar a saída (string convertida)
    max_len  equ 256     ; define constante para o tamanho máximo de leitura

; -------------------------------
; SEÇÃO DE CÓDIGO (.text)
; -------------------------------
section .text
    global _start        ; ponto de entrada do programa

; ===============================
; PONTO DE ENTRADA
; ===============================
_start:
    CALL ler             ; lê texto do teclado (string numérica)
    CALL str_to_dec      ; converte string para número decimal
    ADD rax,1            ; soma 1 ao número convertido
    CALL dec_to_str      ; converte número de volta para string
    CALL escrever        ; imprime o resultado na tela
    JMP exit             ; encerra o programa

; ===============================
; FUNÇÃO: ler
; Lê dados da entrada padrão (stdin)
; ===============================
ler:
    MOV rax,0x00         ; syscall read
    MOV rdi,0x00         ; descritor de arquivo 0 = stdin
    MOV rsi,entrada      ; endereço onde salvar a string lida
    MOV rdx,max_len      ; número máximo de bytes para ler
    SYSCALL              ; executa leitura (read)
    MOV rbx,rax          ; guarda a quantidade de bytes lidos (opcional)
    RET

; ===============================
; FUNÇÃO: str_to_dec
; Converte string numérica em número inteiro (ex: "123" → 123)
; Resultado final em RAX
; ===============================
str_to_dec:
    MOV rsi,entrada      ; ponteiro para o início da string de entrada
    MOV rcx,10           ; base decimal (10)
    XOR rdx,rdx          ; zera acumulador (valor final ficará aqui)
convert_loop:
    MOV al,[rsi]         ; lê um byte (caractere atual)
    CMP al,'9'           ; verifica se passou de '9'
    JG convert_done      ; se sim, fim da conversão
    CMP al,'0'           ; verifica se é menor que '0'
    JL convert_done      ; se sim, fim da conversão
    SUB al,'0'           ; converte caractere ASCII para valor numérico (ex: '3' -> 3)
    MOVZX rax, al        ; move valor para RAX (expande com zero)
    IMUL rdx,rcx         ; multiplica valor acumulado anterior por 10
    ADD rdx,rax          ; adiciona o novo dígito
    INC rsi              ; avança para o próximo caractere
    JMP convert_loop     ; repete até encontrar algo fora de '0'..'9'
convert_done:
    MOV rax,rdx          ; move resultado final para RAX
    RET

; ===============================
; FUNÇÃO: dec_to_str
; Converte número em RAX para string decimal (ex: 124 → "124\n")
; Resultado final armazenado em [saida]
; Número de bytes em R12
; ===============================
dec_to_str:
    MOV rdi,saida        ; ponteiro para o buffer de saída
    MOV rcx,10           ; base decimal (10)
    MOV r9,0             ; contador de dígitos (usado no desempilhamento)
convert_loop2:
    MOV rdx,0            ; zera RDX antes da divisão
    IDIV rcx             ; divide RAX por 10 → quociente em RAX, resto em RDX
    ADD rdx,'0'          ; converte o dígito numérico em caractere ASCII
    PUSH rdx             ; empilha o caractere (para inverter a ordem depois)
    INC r9               ; incrementa contador de dígitos
    CMP rax,0            ; verifica se o quociente é zero
    JNE convert_loop2    ; se não, continua dividindo
    MOV r12,r9           ; salva quantidade de dígitos em R12 (para o write)

; Desempilha os caracteres na ordem correta e grava em [saida]
reverse_loop:
    POP r10              ; desempilha um caractere
    MOV [rdi],r10b       ; grava no buffer de saída
    DEC r9               ; decrementa contador
    INC rdi              ; avança ponteiro de escrita
    CMP r9,0             ; terminou?
    JNE reverse_loop     ; se não, continua
    MOV byte [rdi],0xA   ; adiciona quebra de linha '\n' no final
    INC r12              ; soma 1 ao tamanho total
    RET

; ===============================
; FUNÇÃO: escrever
; Escreve o conteúdo de [saida] na tela (stdout)
; ===============================
escrever:
    MOV rax,0x01         ; syscall write
    MOV rdi,0x01         ; descritor 1 = stdout
    MOV rsi,saida        ; endereço da string a imprimir
    MOV rdx,r12          ; número de bytes a escrever
    SYSCALL              ; executa escrita
    RET

; ===============================
; FUNÇÃO: exit
; Encerra o programa com código de saída 0
; ===============================
exit:
    MOV rax,0x3c         ; syscall exit
    MOV rdi,0             ; código de saída 0
    SYSCALL
