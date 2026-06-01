.global load_page_dir
.type load_page_dir, @function
load_page_dir:
    pushl %ebp
    movl %esp, %ebp

    mov 8(%ebp), %eax  
    mov %eax, %cr3       

    leave
    ret

.global enable_paging
.type enable_paging, @function
enable_paging:
    pushl %ebp
    movl %esp, %ebp

    mov %cr0, %eax
    orl $0x80000000, %eax
    mov %eax, %cr0

    leave
    ret

.global disable_paging
.type disable_paging, @function
disable_paging:
    pushl %ebp
    movl %esp, %ebp

    mov %cr0, %eax
    andl $0x7FFFFFFF, %eax
    mov %eax, %cr0

    leave
    ret
