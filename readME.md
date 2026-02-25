
# 🖥️ Projeto Final - Organização e Arquitetura de Computadores (2025)

Este repositório contém o trabalho final da disciplina de Organização e Arquitetura de Computadores. O projeto é composto por um conjunto de programas desenvolvidos em linguagem Assembly (arquiteturas x86 e x86-64) para o sistema operacional Linux, demonstrando o uso de chamadas de sistema (syscalls), manipulação de strings, conversão de bases numéricas e operações aritméticas básicas.

## 📂 Estrutura do Repositório

O repositório contém os seguintes arquivos de código e configuração:

* **`HelloWorld.asm`**: Um programa introdutório em Assembly x86 (32 bits) que imprime a clássica mensagem "Hello, World!" no console utilizando a interrupção do kernel `int 0x80`.
* **`SomaEntrada.asm`**: O programa mais complexo do repositório, escrito em Assembly x86-64 (64 bits). Ele lê uma entrada de texto numérico digitada pelo usuário, converte a string para um número decimal (inteiro), adiciona o valor `1` ao número, converte o resultado de volta para string e o imprime na tela utilizando chamadas `syscall` modernas.
* **`Somador1Digito.asm`**: Um programa em Assembly x86 (32 bits) que realiza a soma de dois dígitos de um único caractere previamente definidos no código (neste caso, '5' e '0') e exibe o resultado formatado no terminal.

## 🚀 Como Executar

Os códigos foram escritos utilizando a sintaxe do montador **NASM** para ambientes Linux. Certifique-se de ter o `nasm` e o linker `ld` (parte do pacote `binutils`) instalados no seu sistema.

### Compilando programas de 64 bits (`SomaEntrada.asm`)
```bash
# 1. Montar o código-fonte gerando o arquivo objeto
nasm -f elf64 SomaEntrada.asm -o SomaEntrada.o

# 2. Linkar o arquivo objeto para criar o executável
ld SomaEntrada.o -o SomaEntrada

# 3. Executar
./SomaEntrada

```

### Compilando programas de 32 bits (`HelloWorld.asm` e `Somador1Digito.asm`)

```bash
# 1. Montar o código-fonte
nasm -f elf32 HelloWorld.asm -o HelloWorld.o

# 2. Linkar o arquivo objeto (requer suporte a 32 bits no sistema)
ld -m elf_i386 HelloWorld.o -o HelloWorld

# 3. Executar
./HelloWorld

```

*(Repita os mesmos passos para o `Somador1Digito.asm`)*

## 👨‍💻 Autor

**Davi Domingos de Oliveira**
Estudante do 3º período de Ciência da Computação na Universidade Federal de Alagoas (UFAL).

