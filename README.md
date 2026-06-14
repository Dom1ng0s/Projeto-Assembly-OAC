# 🖥️ Assembly x86/x86-64 — OAC

**Três programas em linguagem Assembly NASM para Linux: do Hello World à conversão decimal com aritmética de ponteiros**

[![NASM](https://img.shields.io/badge/NASM-Assembly-red?style=flat)](https://nasm.us)
[![Arquitetura](https://img.shields.io/badge/arch-x86%20%2F%20x86--64-blue?style=flat)](.)
[![Linux](https://img.shields.io/badge/OS-Linux-yellow?style=flat&logo=linux&logoColor=white)](.)
[![Licença](https://img.shields.io/badge/licença-MIT-green?style=flat)](LICENSE)

> Programar em Assembly significa falar diretamente com o processador — sem runtime, sem interpretador, sem abstrações.
> Cada syscall, cada registrador e cada byte de memória são responsabilidade do programador.

---

## Índice

1. [Programas](#programas)
2. [Requisitos](#requisitos)
3. [Como compilar e executar](#como-compilar-e-executar)
4. [Arquitetura e conceitos](#arquitetura-e-conceitos)
5. [Contexto acadêmico](#contexto-acadêmico)
6. [Licença](#licença)

---

## Programas

### 1. `HelloWorld.asm` — x86 32-bit · 17 linhas

O ponto de partida clássico: imprime "Hello, World!" usando a interrupção de kernel `int 0x80`.

**O que demonstra:** seções `.data` e `.text`, syscall `write` (eax=4) e `exit` (eax=1), passagem de argumentos via registradores `ebx/ecx/edx`.

```bash
$ ./HelloWorld
Hello, World!
```

---

### 2. `Somador1Digito.asm` — x86 32-bit · 40 linhas

Soma dois dígitos ASCII pré-definidos no código (`x = '5'`, `y = '0'`) e imprime o resultado formatado.

**O que demonstra:** manipulação de valores ASCII (subtrai `'0'` para converter dígito → inteiro, soma `'0'` para reconverter), duas chamadas `write` sequenciais — uma para o label de texto e outra para o dígito resultado.

```bash
$ ./Somador1Digito
sum of x and y is 5
```

> Para alterar os operandos, edite `x db '5'` e `y db '0'` na seção `.data`. Funciona apenas com dígitos de 0-9 cujo resultado não ultrapasse 9 (sem tratamento de carry).

---

### 3. `SomaEntrada.asm` — x86-64 · 123 linhas

O programa mais complexo do repositório. Lê um número inteiro digitado pelo usuário (como string), converte para decimal, soma 1 e imprime o resultado.

**O que demonstra:** syscalls modernas x86-64 (`syscall` em vez de `int 0x80`), seção `.bss` para buffers dinâmicos, pipeline completo de conversão `string → inteiro → operação aritmética → string`, uso de pilha (`PUSH/POP`) para inverter a ordem dos dígitos na serialização.

```bash
$ ./SomaEntrada
41
42
```

```bash
$ echo "99" | ./SomaEntrada
100
```

**Funções implementadas:**

| Função | Responsabilidade |
|---|---|
| `ler` | Lê string numérica do stdin com syscall `read` |
| `str_to_dec` | Converte string para inteiro (acumula dígitos em `rdx`) |
| `dec_to_str` | Converte inteiro para string (divide por 10, empilha dígitos, desempilha em ordem) |
| `escrever` | Imprime o buffer `saida` com syscall `write` |
| `exit` | Encerra com código 0 via syscall `exit` |

---

## Requisitos

- **NASM** (Netwide Assembler) — `sudo dnf install nasm` / `sudo apt install nasm`
- **ld** (GNU Linker) — parte do pacote `binutils`, normalmente já instalado
- **Linux 64-bit** para `SomaEntrada.asm`; Linux 32-bit ou 64-bit com suporte a IA-32 para os outros dois
  - Em sistemas 64-bit, instale o suporte a 32 bits: `sudo apt install gcc-multilib` / `sudo dnf install glibc-devel.i686`

---

## Como compilar e executar

### HelloWorld.asm (32-bit)

```bash
nasm -f elf32 HelloWorld.asm -o HelloWorld.o
ld -m elf_i386 HelloWorld.o -o HelloWorld
./HelloWorld
```

### Somador1Digito.asm (32-bit)

```bash
nasm -f elf32 Somador1Digito.asm -o Somador1Digito.o
ld -m elf_i386 Somador1Digito.o -o Somador1Digito
./Somador1Digito
```

### SomaEntrada.asm (64-bit)

```bash
nasm -f elf64 SomaEntrada.asm -o SomaEntrada.o
ld SomaEntrada.o -o SomaEntrada
./SomaEntrada
```

### Makefile sugerido

Copie e cole para compilar tudo de uma vez:

```makefile
all: HelloWorld Somador1Digito SomaEntrada

HelloWorld: HelloWorld.asm
	nasm -f elf32 HelloWorld.asm -o HelloWorld.o
	ld -m elf_i386 HelloWorld.o -o HelloWorld

Somador1Digito: Somador1Digito.asm
	nasm -f elf32 Somador1Digito.asm -o Somador1Digito.o
	ld -m elf_i386 Somador1Digito.o -o Somador1Digito

SomaEntrada: SomaEntrada.asm
	nasm -f elf64 SomaEntrada.asm -o SomaEntrada.o
	ld SomaEntrada.o -o SomaEntrada

clean:
	rm -f *.o HelloWorld Somador1Digito SomaEntrada
```

```bash
make all
make clean
```

---

## Arquitetura e conceitos

### Duas gerações de syscall no mesmo repositório

| Arquivo | Arquitetura | Chamada de kernel | Convenção |
|---|---|---|---|
| `HelloWorld.asm` | x86 (32-bit) | `int 0x80` | eax=nº syscall, ebx/ecx/edx=args |
| `Somador1Digito.asm` | x86 (32-bit) | `int 0x80` | idem |
| `SomaEntrada.asm` | x86-64 | `syscall` | rax=nº syscall, rdi/rsi/rdx=args |

### Syscalls utilizadas

| Syscall | 32-bit (eax) | 64-bit (rax) | Função |
|---|---|---|---|
| `read` | 3 | 0 | Lê bytes do stdin |
| `write` | 4 | 1 | Escreve bytes no stdout |
| `exit` | 1 | 60 | Encerra o processo |

### Algoritmo de `dec_to_str` (SomaEntrada.asm)

A conversão de inteiro para string em Assembly exige uma técnica de pilha para obter os dígitos na ordem correta:

```
Número: 124

Divisões sucessivas por 10:
  124 ÷ 10 → quociente 12, resto 4 → PUSH '4'
   12 ÷ 10 → quociente  1, resto 2 → PUSH '2'
    1 ÷ 10 → quociente  0, resto 1 → PUSH '1'

Desempilha (LIFO): '1' '2' '4' → "124\n"
```

---

## Contexto acadêmico

Trabalho final da disciplina de **Organização e Arquitetura de Computadores** no curso de Ciência da Computação da **Universidade Federal de Alagoas (UFAL)**, desenvolvido durante o **2º período** do curso. Objetivo: demonstrar compreensão do modelo de execução de baixo nível: registradores, segmentos de memória, syscalls e controle de fluxo sem abstrações de linguagem de alto nível.

---

## Licença

Distribuído sob a licença MIT. Veja o arquivo `LICENSE` para detalhes.

---

**Davi Domingos de Oliveira** — Estudante de CC · UFAL  
[![GitHub](https://img.shields.io/badge/GitHub-Dom1ng0s-181717?style=flat&logo=github)](https://github.com/Dom1ng0s)
[![LinkedIn](https://img.shields.io/badge/LinkedIn-davidomingosdeoliveira-0077B5?style=flat&logo=linkedin)](https://www.linkedin.com/in/davidomingosdeoliveira/)
