BITS    64                       ; Target processor mode

ELF_HEADER:
    e_indent:
        db  0x7F, 'ELF'          ; EI_MAG0, EI_MAG1, EI_MAG2, EI_MAG3: Magic number + ELF ASCII
        db  0x02                 ; EI_CLASS: Data encoding 64 bits
        db  0x01                 ; EI_DATA: Endianness (little)
        db  0x01                 ; EI_VERSION: ELF Version
        db  0x03                 ; EI_OSABI: : OS ABI Linux
        dq  0x00                 ; EI_ABIVERSION, EI_PAD: ABI Version + PAD
    dw  0x02                     ; e_type: type EXEC
    dw  0x3E                     ; e_machine: machine x86_64
    dd  0x01                     ; e_version: version
    dq  _start                   ; e_entry: entry point
    dq  PROGRAM_HEADER - $$      ; e_phoff: program header table offset
    dq  0x00                     ; e_shoff: section header table offset
    dd  0x00                     ; e_flags: flags
    dw  ehdr_size                ; e_ehsize: ELF header size
    dw  phdr_size                ; e_phentsize: program header table entry size
    dw  0x01                     ; e_phnum: program header entry number
ehdr_size   equ $ - ELF_HEADER

PROGRAM_HEADER:
    dd  0x01                     ; p_type: segment type PT_LOAD
    dd  0x05                     ; p_flags: flags PF_R | PF_X
    dq  0x00                     ; p_offset: file offset
    dq  $$                       ; p_vaddr: virtual address
    dq  $$                       ; p_paddr: physical address
    dq  filesize                 ; p_filesz: file image size
    dq  filesize                 ; p_memsz: memory image size
    dq  0x1000                   ; p_align: alignment
phdr_size   equ $ - PROGRAM_HEADER

org     0x400000                 ; Default address for 64 bits executables
_start:
    ; write(1, message, mlength)
    write:
        inc     al
        mov     dil, al
        mov     esi, message
        mov     dl, mlength
        syscall
    ; exit(0)
    exit:
        mov     al, 0x3c
        dec     dil
        syscall

message: db     "Hello, World!", byte `\n`
mlength  equ    $ - message
filesize equ    $ - _start
