.pos 0x0
    irmovq Pino,%rsp # pinon alustukset
    irmovq Pino,%rbp
    irmovq $6601,%r8 #1. siemenluku
main:
    irmovq $0,%r14      #laskee satunnais lukujen määrän
    irmovq $1,%r11      #vakio 1
    irmovq $0,%r12
    irmovq $0,%r10      #vertailu nolla
    irmovq $1000,%rsi
potenssi:
    irmovq $0,%rax      #%r8 * %r8
    irmovq $1,%r9       #vertailubitti
    rrmovq %r8,%rbx     #rekisterin r8 arvo muistiin, jotta sitä voidaan käyttää
    rrmovq %r8,%rcx     #laskemiseen muokkaamatta kyseistä arvoa, useampi
    rrmovq %r8,%rdx     #muistipaikka käyttöön, jotta kertolasku voidaan suorittaa
loop1:
    andq %r9,%rcx       #katsotaan onko %r8 arvon binäärimuodossa 1 kohdalla %r9
    subq %r10,%rcx      #jos on niin hypätään summa funktioon
    jne summa           #hyppy summa funktioon
    subq %r9,%rdx       #verrataan onko %rdx:n suurin bitti suurempi kuin %r9 vertailubitti
    jl stop             #hyppy stop funktioon
    addq %r9,%r9        #siirretään bittivertailijaa yhden bitin verran vasemmalle eli %r9 * 2
    addq %rbx,%rbx      #siirretään kertojan bittejä yhden verran vasemmalle eli %rbx * 2
    rrmovq %r8,%rcx     #alustetaan %rcx, jotta voidaan tehdä vertailu uudella kierroksella
    rrmovq %r8,%rdx     #alustetaan %rdx, jotta voidaan tehdä vertailu uudella kierroksella
    jmp loop1           #kierros alusta

.pos 0x100
summa:                  #summa funktio
    addq %rbx,%rax      #summataan %rax 
    rrmovq %r8,%rcx     #alustetaan %rcx, jotta voidaan tehdä vertailu uudella kierroksella
    addq %r9,%r9        #siirretään bittivertailijaa yhden bitin verran vasemmalle eli %r9 * 2
    addq %rbx,%rbx      #siirretään kertojan bittejä yhden verran vasemmalle eli %rbx * 2
    jmp loop1           #palataan looppiin

.pos 0x200
stop:
    pushq %rax          #viedään %rax pinoon

jakolasku:
    irmovq $10000000,%rdi
loop2:
    subq %rdi,%rax
    jg loop2
    addq %rdi,%rax
    irmovq $1000000,%rdi
    jmp jakolasku2
    
jakolasku2:
    subq %rdi,%rax
    jg jakolasku2
    addq %rdi,%rax
    irmovq $100000,%rdi
    jmp siirto

.pos 0x300
siirto:
    subq %rdi,%rax
    jl siirto2
    addq %rsi,%r12
    jmp siirto
siirto2:
    addq %rdi,%rax
    irmovq $0,%rdi
    irmovq $10000,%r13
    subq %r13,%rax
    jl siirto3
    irmovq $100,%rsi
    addq %rsi,%r12
    jmp siirto2
siirto3:
    addq %r13,%rax
    irmovq $0,%r13
    irmovq $1000,%rdi
    subq %rdi,%rax
    jl siirto4
    irmovq $10,%rsi
    addq %rsi,%r12
    jmp siirto3
siirto4:
    addq %rdi,%rax
    irmovq $0,%rdi
    irmovq $100,%r13
    subq %r13,%rax
    jl siirto5
    irmovq $1,%rsi
    addq %rsi,%r12
    jmp siirto4
siirto5:
    halt

.pos 0x1000
Pino:
