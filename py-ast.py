
# This is a tangled file  -- DO NOT EDIT --  Edit in pyel.org

import ast

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


  
def keyword(arg, value):
    return l_str(["(keyword ", arg, " ", value, ")"])
      
def Print(dest, values, nl):
    print("Error, using python2.x upgrade to 3")
    exit()
      
def Param():
    return "'param"
    
def Load():
    return "'load"
    
def Store():
    return "'store"
    
def Expr(value): #?bug
    return value
    
def Import(names):
    return l_str(["import ",ll_str(names)])
    
def alias(name, asname):
    if asname: asname = "\"" + asname + "\""
    return l_str(["alias ", "\"" + name + "\"", asname or "nil"]) 
    
def ImportFrom(module, names, level):
    return l_str(["import-from ","\"" + module + "\"", ll_str(names), level])

def Assign(targets, value):
    #    print("targets: ", targets)
    return l_str(["assign ", untuple(targets), value])

def Attribute(value, attr, ctx):
    return l_str(["attribute ", value, "\"" + attr + "\"", ctx])

def Num(n):
    return "(num " + str(n) +")"

def Name(id, ctx):
    return l_str(["name ", "\"" + id + "\"", ctx])

def List(elts, ctx):
    return "(list " + ll_str(elts) + " " + ctx +")"

def Dict(keys, values):
    return "(dict " + ll_str(keys) + " " + ll_str(values) + ")"

def Tuple(elts, ctx):
    return l_str(["tuple ", ll_str(elts), ctx])

def Str(s):
    return "(str \"" + str(s) +"\")"



def Compare (left, ops, comparators):
      return l_str(["compare ", left, ll_str(ops), ll_str(comparators) ])
      
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
      return "\"in\"";
def NotIn():
      return "\"not-in\"";

def If (test, body, orelse):
    return l_str(["if ",test, ll_str(body), ll_str(orelse)])

def Call(func, args, keywords, starargs, kwargs):
    return l_str(["call ", func, ll_str(args), ll_str(keywords), starargs or "nil" , kwargs or "nil"])

def While(test, body, orelse):
    return l_str(["while ", test, ll_str(body), ll_str(orelse)])

def arguments(args=None, vararg=None, varargannotation=None, kwonlyargs=None,
              kwarg=None, kwargannotation=None,defaults=None, kw_defaults=None):
    return ll_str(["(arguments ",
                   ll_str(args) or "nil",
                   vararg or "nil",
                   varargannotation or "nil",
                   kwonlyargs or "nil",
                   kwarg or "nil",
                   kwargannotation or "nil",
                   ll_str(defaults) or "nil",
                   kw_defaults or "nil", ")"])
    #return l_str(["_arguments ",ll_str(args) or "nil",vararg or "nil",varargannotation or "nil", kwonlyargs or "nil", kwarg or "nil", kwargannotation or "nil", defaults or "nil", kw_defaults or "nil"])

def FunctionDef(name, args, body, decorator_list, returns):
     return " ".join(map(str, ["(def \"", name,"\"", ll_str(args), ll_str(body), decorator_list or "nil",returns or "nil",")"]))

    

def arg(arg,annotation):
    return "(arg \"" + arg + "\" " + " " + (annotation or "nil") + ")"

def BinOp(left, op, right):
    return l_str(["bin-op ", left, op, right])
      
def Add():
    return "+"

def Mult():
    return "*"
def Sub():
    return "-"
def Div():
    return "/"
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
      
def Index(value):
    return "(index " + value + ")"
      
def Subscript(value,slice,ctx):
    return ll_str(["subscript", value,slice,ctx])

def ClassDef (name, bases, keywords, starargs, kwargs, body, decorator_list):
  return ll_str(["classdef",
                 name,
                 ll_str(bases),
                 ll_str(keywords),
                 starargs or "nil",
                 kwargs or "nil",
                 ll_str(body),
                 ll_str(decorator_list)])

def Assert(test, msg):
    return ll_str(["assert ", test , msg or "nil"])



def For(target, iter, body, orelse):
    return l_str(["for ", target, iter, ll_str(body), ll_str(orelse)])

def Global(names):
  return l_str(['global', l_str(names)])

def Lambda(args, body):
    return ll_str(["lambda", ll_str(args),'('+ll_str(body)+')'])

def UnaryOp(op, operand):
    return l_str(["unary-op ", op, operand])

def Not():
    return "not"

def USub():
    return "usub"

def AugAssign(target, op, value):
    return l_str(['aug-assign', target, op, value])

def Return(value):
    return "(return " + str(value) + ")"

def Break():
    return "(break)"
    
def Continue():
    return "(continue)"

def ExceptHandler(type, name, body):
    return l_str(["except-handler", type or 'nil', name or 'nil', l_str(body)])

def TryExcept(body, handlers, orelse):
    return l_str(["try", l_str(body), l_str(handlers), l_str(orelse)])



#py-ast.py ends here

