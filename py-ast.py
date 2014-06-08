#!/usr/bin/python3

# This is a tangled file  -- DO NOT EDIT --  Edit in pyel.org

import ast
import sys

options = sys.argv[1:]
if len(options) != 1:
    print("invalid usage")
    exit()

#TODO: use *args

def l_str(x):
    return "(" + " ".join(map(str,x)) + ")"

def ll_str(x):
    if x == []:
        return "nil"
    elif type(x) == str:
        return x
    return "(" + " ".join(map(str,x)) + ")"
#    return " ".join(map(str,x))
#    return "(list " + " ".join(map(str,x)) + ")"
# commented out for 'assign'. cause problems elsewhere?

def untuple(x):
    return ll_str(x)
    if x == []:
        return "nil"
    elif type(x) == str:
        return x

def Module(body):
    return "\n".join(body)

def keyword(arg, value, lineno='nil', col_offset='nil'):
    return l_str(["(keyword ", arg, " ", value, lineno, col_offset, ")"])

def Param():
    return "'param"

def Load():
    return "'load"

def Store():
    return "'store"

def Expr(value, lineno='nil', col_offset='nil'): #?
    return value

def Import(names, lineno=None, col_offset='None'):
    return l_str(["import ",ll_str(names), lineno, col_offset])

def alias(name, asname):
    if asname: asname = "\"" + asname + "\""
    return l_str(["alias ", "\"" + name + "\"", asname or "nil"])

def ImportFrom(module, names, level, lineno=None, col_offset='None'):
    return l_str(["import-from ","\"" + module + "\"", ll_str(names), level, lineno, col_offset])

def Assign(targets, value, lineno='nil', col_offset='nil'):
    #    print("targets: ", targets)
    return l_str(["assign ", untuple(targets), value, lineno, col_offset])

def Attribute(value, attr, ctx, lineno='nil', col_offset='nil'):
    return l_str(["attribute ", value, "\"" + attr + "\"", ctx, lineno, col_offset])

def Num(n, lineno='nil', col_offset='nil'):
    return "(num " + str(n) +" " + str(lineno) + " " + str(col_offset) + ")"

def Name(id, ctx, lineno='nil', col_offset='nil'):
    return l_str(["name ", "\"" + id + "\"", ctx, lineno, col_offset])

def List(elts, ctx, lineno='nil', col_offset='nil'):
    return "(list " + ll_str(elts) + " " + ctx + " " + str(lineno) + " " +str(col_offset) +")"

def Dict(keys, values, lineno='nil', col_offset='nil'):
    return "(dict " + ll_str(keys) + " " + ll_str(values) + " " + str(lineno) + " " + str(col_offset) + ")"

def Tuple(elts, ctx, lineno='nil', col_offset='nil'):
    return l_str(["tuple ", ll_str(elts), ctx, lineno, col_offset])

def Str(s, lineno='nil', col_offset='nil'):
    return "(str \"" + str(s) +"\"" + " " + str(lineno) + " " + str(col_offset) + ")"

def Compare (left, ops, comparators, lineno='nil', col_offset='nil'):
      return l_str(["compare ", left, ll_str(ops), ll_str(comparators), lineno, col_offset ])

def Gt():
      return "\">\""
def Lt():
      return "\"<\""
def Eq():
      return "\"==\""
def NotEq ():
      return "\"!=\""
def LtE():
      return "\"<=\""
def GtE():
      return "\">=\""
def In():
      return "\"in\""
def NotIn():
      return "\"not-in\""
def Is():
      return "\"is\""

def If (test, body, orelse, lineno='nil', col_offset='nil'):
    return l_str(["if ",test, ll_str(body), ll_str(orelse), lineno, col_offset])

def Call(func, args, keywords, starargs, kwargs, lineno='nil', col_offset='nil'):
    return l_str(["call ", func, ll_str(args), ll_str(keywords), starargs or "nil" , kwargs or "nil", lineno, col_offset])

def While(test, body, orelse, lineno='nil', col_offset='nil'):
    return l_str(["while ", test, ll_str(body), ll_str(orelse), lineno, col_offset])

def arguments(args=None, vararg=None, varargannotation=None, kwonlyargs=None,
              kwarg=None, kwargannotation=None,defaults=None, kw_defaults=None):
    return ll_str(["(arguments ",
                   ll_str(args) or "nil",
                   vararg or "nil",
                   varargannotation or "nil",
                   ll_str(kwonlyargs) if kwonlyargs else "nil",
                   kwarg or "nil",
                   kwargannotation or "nil",
                   ll_str(defaults) or "nil",
                   ll_str(kw_defaults) if kw_defaults else "nil", ")"])
    #return l_str(["_arguments ",ll_str(args) or "nil",vararg or "nil",varargannotation or "nil", kwonlyargs or "nil", kwarg or "nil", kwargannotation or "nil", defaults or "nil", kw_defaults or "nil"])

def FunctionDef(name, args, body, decorator_list, returns, lineno='nil', col_offset='nil'):
    return " ".join(map(str, ["(def \"", name,"\"", ll_str(args), ll_str(body), ll_str(decorator_list) or "nil",returns or "nil", lineno, col_offset, ")"]))

def arg(arg, annotation):
    return "(arg \"" + arg + "\" " + " " + (annotation or "nil") + ")"

def BinOp(left, op, right, lineno='nil', col_offset='nil'):
    return l_str(["bin-op ", left, op, right, lineno, col_offset])

def Add():
    return "+"
def Mult():
    return "*"
def Sub():
    return "-"
def Div():
    return "/"
def FloorDiv():
    return "//"
def Pow():
    return "**"
def BitXor():
    return "^"
def BitOr():
    return "|"
def BitAnd():
    return "&"
def Mod():
    return "%"

def Slice(lower, upper, step):
    step = step or "nil"
    lower = lower or 0
    upper = upper or "nil"
    return l_str(["slice", lower, upper, step])

def Index(value, lineno='nil', col_offset='nil'):
    return "(index " + value + " " + str(lineno) + " " + str(col_offset) + ")"

def Subscript(value, slice, ctx, lineno='nil', col_offset='nil'):
    return ll_str(["subscript", value, slice, ctx, lineno, col_offset])

def ClassDef (name, bases, keywords, starargs, kwargs, body, decorator_list, lineno='nil', col_offset='nil'):
  return ll_str(["classdef",
                 name,
                 ll_str(bases),
                 ll_str(keywords),
                 starargs or "nil",
                 kwargs or "nil",
                 ll_str(body),
                 ll_str(decorator_list),
                 lineno, col_offset])

def Assert(test, msg, lineno='nil', col_offset='nil'):
    return ll_str(["assert ", test , msg or "nil", lineno, col_offset])

def For(target, iter, body, orelse, lineno='nil', col_offset='nil'):
    return l_str(["for ", target, iter, ll_str(body), ll_str(orelse), lineno, col_offset])

def Global(names, lineno='nil', col_offset='nil'):
  return l_str(['global', l_str(names), lineno, col_offset])

def Nonlocal(names, lineno='nil', col_offset='nil'):
  return l_str(['global', l_str(names), lineno, col_offset])

def Lambda(args, body, lineno='nil', col_offset='nil'):
    return ll_str(["lambda", ll_str(args),'('+ll_str(body)+')', lineno, col_offset])

def UnaryOp(op, operand, lineno='nil', col_offset='nil'):
    return l_str(["unary-op ", op, operand, lineno, col_offset])

def Not():
    return "not"

def USub():
    return "usub"

def AugAssign(target, op, value, lineno='nil', col_offset='nil'):
    return l_str(['aug-assign', target, op, value, lineno, col_offset])

def Return(value, lineno='nil', col_offset='nil'):
    return "(return " + str(value) + " " + str(lineno) + " " + str(col_offset)+ ")"

def Break(lineno=None, col_offset=None):
    return l_str(["break", lineno, col_offset])

def Continue(lineno=None, col_offset=None):
    return l_str(["continue", lineno, col_offset])

def ExceptHandler(type, name, body, lineno='nil', col_offset='nil'):
    return l_str(["except-handler", type or 'nil', name or 'nil', l_str(body), lineno, col_offset])

def TryExcept(body, handlers, orelse, lineno='nil', col_offset='nil'):
    return l_str(["try", l_str(body), l_str(handlers), l_str(orelse), lineno, col_offset])

def comprehension(target, iter, ifs):
    return l_str(["comprehension", target, iter, l_str(ifs)])

def GeneratorExp(elt, generators, lineno='nil', col_offset='nil'):
    return l_str(["list-comp", elt, l_str(generators), lineno, col_offset])

def ListComp(elt, generators, lineno='nil', col_offset='nil'):
    return l_str(["list-comp", elt, l_str(generators), lineno, col_offset])

def DictComp(key, value, generators, lineno='nil', col_offset='nil'):
    return l_str(["dict-comp", key, value, l_str(generators), lineno, col_offset])

def SetComp(elt, generators, lineno='nil', col_offset='nil'):
    return "(unimplemented \"set comprehension\")"

def BoolOp(op, values, lineno='nil', col_offset='nil'):
    return l_str(["boolop", op, l_str(values), lineno, col_offset])
def Or():
    return "or"
def And():
    return "and"

def Pass(lineno=None, col_offset=None):
    return l_str(["pass", lineno, col_offset])

def IfExp (test, body, orelse, lineno='nil', col_offset='nil'):
    return l_str(["if-exp", test, body, orelse, lineno, col_offset])

def Raise(exc, cause, lineno='nil', col_offset='nil'):
    return l_str(["raise", exc, cause or "nil", lineno, col_offset])



def Print(dest, values, nl, lineno='nil', col_offset='nil'):
    print("Error: using python2, upgrade to python3")
    exit()







print(eval(ast.dump(ast.parse(open(options[0],'r').read()))))

#py-ast.py ends here


