# Projeto-Assembly-OAC

# Roteiro para Aula Curta: Introdução ao Assembly (Sintaxe Intel)

**Objetivo:** Em ~30-45 minutos, desmistificar o Assembly, mostrando como escrever um programa simples, manipulá-lo e "ver" a CPU em ação com um depurador.

**Ferramenta Principal:** Visual Studio com a extensão MASM (ou outra IDE com um depurador visual).

---

### Sumário da Aula

#### 1. **O Básico do Básico (5 minutos)**

* **O que é Assembly?**
    * Não é um bicho de sete cabeças! É apenas a "língua nativa" do seu processador.
    * Mostre a ponte: `Código C -> Compilador -> Assembly -> Código de Máquina`.
* **Por que aprender?**
    * Para entender o que o seu código *realmente* faz.
* **As Duas Coisas Mais Importantes:**
    * **Registradores:** As "variáveis" super-rápidas dentro da CPU (Ex: `RAX`, `RBX`, `RCX`).
    * **Memória (RAM):** O "grande armário" onde guardamos os dados.

#### 2. **Mão na Massa: Movendo Dados (15 minutos)**

* **A Instrução Mais Importante: `MOV`**
    * Regra de ouro da sintaxe Intel: `MOV destino, origem`.
    * Pense: "Mova a `origem` **PARA** o `destino`".
* **Exemplo Prático 1: Cálculo Simples**
    ```assembly
    ; main PROC
      mov rax, 10     ; Coloca o número 10 no registrador RAX
      mov rbx, 5      ; Coloca o número 5 no registrador RBX
      add rax, rbx    ; Soma RBX em RAX (RAX agora contém 15)
    ; main ENDP
    ```
* **✨ A Hora da Mágica: O Debugger! ✨**
    * **Passo 1:** Coloque um *breakpoint* (ponto de parada) na primeira linha `mov`.
    * **Passo 2:** Inicie a depuração (F5).
    * **Passo 3:** Abra a janela de **Registradores**.
    * **Passo 4:** Use **F11 (Step Into)** para executar uma instrução por vez e veja os valores de `RAX` e `RBX` mudarem ao vivo.
    * *(Este é o momento "A-ha!" da aula. Gaste tempo aqui!)*

#### 3. **Mão na Massa: Tomando Decisões (10 minutos)**

* **As Instruções de Decisão: `CMP` e `JNE`**
    * `CMP destino, origem`: Compara dois valores (semelhante ao `==` ou `>`).
    * `JNE etiqueta`: **J**ump if **N**ot **E**qual (Pula para uma parte do código se a comparação anterior não for igual).
* **Exemplo Prático 2: Um "if" simples**
    ```assembly
    ; main PROC
      mov rax, 10
      mov rbx, 10
      cmp rax, rbx    ; Compara RAX com RBX. São iguais?

      jne nao_sao_iguais ; Se NÃO forem iguais, pula para o label.

      ; Este código só executa se forem iguais
      mov rcx, 1      ; Coloca 1 em RCX para sinalizar "iguais"
      jmp fim_do_if   ; Pula para o final

    nao_sao_iguais:
      mov rcx, 0      ; Coloca 0 em RCX para sinalizar "diferentes"

    fim_do_if:
      ; ... continua o programa
    ; main ENDP
    ```
* **✨ A Mágica do Debugger (Parte 2) ✨**
    * Execute passo a passo com F11.
    * Veja a seta amarela (ponteiro de instrução) pular (ou não) na linha do `jne`. Isso mostra visualmente como o fluxo do programa é alterado.
    * Mude o valor de `RBX` para `5` e rode de novo para ver o outro caminho ser tomado.

#### 4. **Encerramento e Próximos Passos (5 minutos)**

* **Revisão Rápida:**
    * "Hoje nós escrevemos código que fala direto com a CPU."
    * "Usamos `MOV` para mover dados, `ADD` para somar e `CMP`/`JNE` para tomar uma decisão."
    * "O debugger nos permitiu espionar a CPU em tempo real!"
* **Pequeno Desafio (se quiserem praticar):**
    * "Modifiquem o segundo exemplo para usar `JE` (Jump if Equal) em vez de `JNE`."
    * "Crie um código que encontre o maior entre dois números."
