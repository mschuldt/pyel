
@interactive
def pyel_eval_buffer():
    eval(pyel(buffer_string()))

@interactive
def pyel_buffer(out_buff='*pyel-output*'):
    lisp = pyel_buffer_to_string()
    switch_to_buffer_other_window(out_buff)
    erase_buffer()
    lisp_interaction_mode()
    pyel_prettyprint(lisp)
    goto_char(1)


def back_to_open_paren():
    pc = 0 #paren count: +1 for open , -1 for close
    while not bobp() and pc != 1:
        backward_char()
        c = thing_at_point(quote(char))
        if ord(c) == 34: #a bug prevents writing "\""
            forward_char()
            backward_sexp()
        elif c == ')':
            pc -= 1
        elif c == '(':
            pc += 1
    if bobp() and not looking_at('('):
        return False
    else:
        return True
