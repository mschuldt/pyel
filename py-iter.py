# pyel iterator classes for built-in types

class py_list_iter:
    def __init__(self, lst):
        self.lst = lst
        self.length = length(lst)
    def __next__(self):
        lst = self.lst
        if lst:
            ret = car(lst)
            self.lst = cdr(lst)
            return ret
        else:
            raise StopIteration

class py_tuple_iter:
    def __init__(self, tup):
        self.tup = tup
        self.length = length(tup)
        self.i = 0
    def __next__(self):
        i = self.i
        if i < self.length:
            ret = aref(self.tup, i)
            self.i += 1
            return ret
        else:
            raise StopIteration

class py_string_iter:
    def __init__(self, str):
        self.s = str
        self.length = length(str)
        self.i = 0
    def __next__(self):
        i = self.i
        if i < self.length:
            ret = substring(self.s, i, i+1)
            self.i += 1
            return ret
        else:
            raise StopIteration

class py_dict_iter:
    def __init__(self, d):
        #self.keys = d.keys()
        self.keys = py_dict_keys(d)
        self.length = length(self.keys)
    def __next__(self):
        keys = self.keys
        if keys:
            ret = car(keys)
            self.keys = cdr(keys)
            return ret
        else:
            raise StopIteration


provide(`py_iter)
