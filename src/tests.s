.global divide_by_zero
.type divide_by_zero, @function
divide_by_zero:
    xor %ecx, %ecx
    idiv %ecx
