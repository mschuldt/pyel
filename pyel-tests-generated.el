(setq pyel-test-py-functions '("def pyel_test_rfind_method_214(n):
 x = 'asdf'
 y = 'abxabxab'
 if n == 1:
  return x.rfind('sd')

 if n == 2:
  return y.rfind('ab')" "def pyel_test_ljust_method_213():
 x = 'ab'
 return x.ljust(10)" "def pyel_test_rjust_method_212():
 x = 'ab'
 return x.rjust(10)" "def pyel_test_rpartition_method_211():
 x = 'abcdefghi'
 return x.rpartition('c')" "def pyel_test_partition_method_210():
 x = 'abcdefghi'
 return x.partition('c')" "def pyel_test_rsplit_method_209():
 x = 'a b c'
 y = x.rsplit()
 return y" "def pyel_test_rsplit_method_208(n):
 y = 'a x b x d x'.rsplit()
 if n == 1:
  return y

 if n == 2:
  return len(y)" "def pyel_test_lstrip_method_207():
 x = 'hello'
 return x.lstrip('hlo')" "def pyel_test_rstrip_method_206():
 x = 'hello'
 return x.rstrip('hlo')" "def pyel_test_startswith_method_205():
 x = 'abcde'
 return x.startswith('.')" "def pyel_test_swapcase_method_204():
 x = 'aaBB1'
 return x.swapcase()" "def pyel_test_title_method_203():
 x = '2dd'
 return x.title()" "def pyel_test_zfill_method_202():
 a = 'asdf'
 return a.zfill(10)" "def pyel_test_isalnum_method_201():
 x = '23'
 return x.isalnum()" "def pyel_test_isalpha_method_200():
 x = 'asd'
 return x.isalpha()" "def pyel_test_istitle_method_199(n):
 a = 'sldk'
 b = 'Dsldk'
 c = 'aDsldk'
 if n == 1:
  return a.istitle()

 if n == 2:
  return b.istitle()

 if n == 3:
  return c.istitle()" "def pyel_test_isupper_method_198(n):
 a = 'A'
 b = 'a'
 c = 'Aa'
 if n == 1:
  return a.isupper()

 if n == 2:
  return b.isupper()

 if n == 3:
  return c.isupper()" "def pyel_test_islower_method_197(n):
 a = 'A'
 b = 'a'
 c = 'Aa'
 if n == 1:
  return a.islower()

 if n == 2:
  return b.islower()

 if n == 3:
  return c.islower()" "def pyel_test_copy_method_196(n):
 x = {1:['one'],2:'two',3:'three'}
 y = x
 z = x.copy()
 if n == 1:
  return x is z

 if n == 2:
  return x[1] is z[1]" "def pyel_test_popitem_method_195(n):
 x = {1:'one',2:'two',3:'three'}
 y = x.popitem()
 if n == 1:
  return y

 if n == 2:
  return repr(x)" "def pyel_test_values_method_194(n):
 x = {1:'one',2:'two',3:'three'}
 y = {8 : 88}
 z = {}
 if n == 1:
  return x.values()

 if n == 2:
  return y.values()

 if n == 3:
  return z.values()" "def pyel_test_keys_method_193(n):
 x = {1:'one',2:'two',3:'three'}
 y = {8 : 88}
 z = {}
 if n == 1:
  return x.keys()

 if n == 2:
  return y.keys()

 if n == 3:
  return z.keys()" "def pyel_test_items_method_192(n):
 x = {1:'one',2:'two',3:'three'}
 y = {8 : 88}
 z = {}
 if n == 1:
  return x.items()

 if n == 2:
  return y.items()

 if n == 3:
  return z.items()" "def pyel_test_get_method_191(n):
 x = {1:'one',2:'two',3:'three'}
 if n == 1:
  return x[1]

 if n == 2:
  return x[1] == x.get(1)

 if n == 3:
  return x.get(3, 'd')

 if n == 4:
  return x.get(4, 'd')" "def pyel_test_strip_method_190():
 x = 'hello'
 return x.strip('hlo')" "def pyel_test_split_method_189():
 x = 'a b c'
 y = x.split()
 return y" "def pyel_test_split_method_188(n):
 y = 'a x b x d x'.split()
 if n == 1:
  return y

 if n == 2:
  return len(y)" "def pyel_test_upper_method_187(n):
 x = 'aB'
 y = x
 y = x.upper()
 if n == 1:
  return y

 if n == 2:
  return x" "def pyel_test_lower_method_186(n):
 x = 'aB'
 y = x
 y = x.lower()
 if n == 1:
  return y

 if n == 2:
  return x" "def pyel_test_reverse_method_185(n):
 x = [1,2,3]
 y = x
 x.reverse()
 if n == 1:
  return x

 if n == 2:
  return x is y" "def pyel_test_pop_method_184(n):
 x = [[1],'s',(2,), 1, 4]
 y = x
 a = x.pop()
 b = x.pop(0)
 c = x.pop(2)

 if n == 1:
  return a

 if n == 2:
  return b

 if n == 3:
  return c

 if n == 4:
  return x is y" "def pyel_test_pop_method_183(n):
 x = {1:'one',2:'two',3:'three'}
 y = x.pop(2)
 if n == 1:
  return y

 if n == 2:
  return repr(x)" "def pyel_test_extend_method_182(n):
 x = [1]
 y = x
 x.extend([1,'2',(3,)])
 if n == 1:
  return x is y

 if n == 2:
  return x" "def pyel_test_extend_method_181(n):
 x = [1]
 y = x
 x.extend((1,'2',(3,)))
 if n == 1:
  return x is y

 if n == 2:
  return x" "def pyel_test_extend_method_180(n):
 x = [1]
 y = x
 x.extend('extended')
 if n == 1:
  return x is y

 if n == 2:
  return x" "def pyel_test_extend_method_179(n):
 class a:
  x = 5
  def __iter__(self):
   return self
  def __next__(self):
   if self.x > 0:
    ret = str(self.x)
    self.x -= 1
    return ret
   raise StopIteration
 obj = a()
 x = [1]
 y = x
 x.extend(obj)
 if n == 1:
  return y is x

 if n == 2:
  return x" "def pyel_test_count_method_178(n):
 x = [1,2,3,3,[2],'s']
 if n == 1:
  return x.count(3)

 if n == 2:
  return x.count(2)

 if n == 3:
  return x.count([3,4])

 if n == 4:
  return x.count('s')" "def pyel_test_count_method_177(n):
 x = (1,2,3,3,[2],'s')
 if n == 1:
  return x.count(3)

 if n == 2:
  return x.count(2)

 if n == 3:
  return x.count([3,4])

 if n == 4:
  return x.count('s')" "def pyel_test_remove_method_176():
 x = [1,'2','2',(1,)]
 y = x
 x.remove('2')
 return x is y" "def pyel_test_remove_method_175():
 x = [1,'2','2',(1,)]
 x.remove('2')
 return x" "def pyel_test_remove_method_174():
 x = [1,'2','2',(1,)]
 x.remove(1)
 return x" "def pyel_test_remove_method_173():
 x = [1,'2','2',(1,)]
 x.remove((1,))
 return x" "def pyel_test_index_method_172(n):
 x = [1,(1,2),'5']
 if n == 1:
  return x.index(1)

 if n == 2:
  return x.index((1,2))

 if n == 3:
  return x.index('5')" "def pyel_test_index_method_171(n):
 x = 'importantstring'
 if n == 1:
  return x.index('t')

 if n == 2:
  return x.index('or')

 if n == 3:
  return x.index('g')

 if n == 4:
  return x.index(x)" "def pyel_test_index_method_170():
 x = 'str.ing'
 return x.index('.')" "def pyel_test_index_method_169(n):
 x = (1,2,'tree',(3,))
 if n == 1:
  return x.index(1)

 if n == 2:
  return x.index('tree')

 if n == 3:
  return x.index((3,))" "def pyel_test_find_method_168():
 x = 'asdf'
 return x.find('sd')" "def pyel_test_insert_167(n):
 x = [1,2,3]
 y = x
 x.insert(1,'hi')
 if n == 1:
  return x

 if n == 2:
  return x is y" "def pyel_test_append_166(n):
 a = [1,2,3]
 c = ['a','a']
 b = a
 a.append('hi')
 e = []
 e.append(3)
 if n == 1:
  return a

 if n == 2:
  return a is b

 if n == 3:
  a.append(c)
  return a is b

 if n == 4:
  a.append(c)
  return a[3] is c

 if n == 5:
  return e" "def pyel_test_hash_165():
 class a:
  x = 5
  def __hash__(self):
   return 1234
 o = a()
 return hash(o)" "def pyel_test_sum_function_164():
 class a:
  x = 5
  def __iter__(self):
   return self
  def __next__(self):
   if self.x > 0:
    ret =self.x
    self.x -= 1
    return ret
   raise StopIteration
 o = a()
 return sum(o)" "def pyel_test_any_function_163(n):
 class a:
  x = 5
  def __init__(self, s, e):
   self.start = s
   self.end = e
  def __iter__(self):
   self.current = self.start
   return self
  def __next__(self):
   if self.current < self.end:
    ret = self.current
    self.current += 1
    return ret
   raise StopIteration
 o = a(0,9)
 o2 = a(0,0)
 if n == 1:
  return any(o)

 if n == 2:
  return any(o2)" "def pyel_test_all_function_162(n):
 class a:
  x = 5
  def __init__(self, s, e):
   self.start = s
   self.end = e
  def __iter__(self):
   self.current = self.start
   return self
  def __next__(self):
   if self.current < self.end:
    ret = self.current
    self.current += 1
    return ret
   raise StopIteration
 o = a(1,9)
 o2 = a(-3,3)
 if n == 1:
  return all(o)

 if n == 2:
  return all(o2)" "def pyel_test_next_function_161(n):
 class c:
  x = 5
  def __iter__(self):
   return self
  def __next__(self):
   if self.x > 0:
    ret = str(self.x)
    self.x -= 1
    return ret
   raise StopIteration
 obj = c()
 it = iter(obj)
 a = next(it)
 b = next(it)
 if n == 1:
  return a

 if n == 2:
  return b" "def pyel_test_iter_function_160(n):
 class a:
  x = 5
  def __iter__(self):
   return self
  def __next__(self):
   if self.x > 0:
    ret = str(self.x)
    self.x -= 1
    return ret
   raise StopIteration
 obj = a()
 it = iter(a)
 x = it.__next__()
 x2 = it.__next__()
 if n == 1:
  return x

 if n == 2:
  return x2" "def pyel_test_iter_function_159(n):
 list_i = iter([1,2,3])
 tuple_i = iter(('1','2','3'))
 string_i = iter('str')
 dict_i = iter({1:'1', '5':5})
 s = 's2'
 string_i2 = iter(s)
 tuple_i2 = iter([[(2,4)]][0][0])
 string_i3 = iter('string')
 tuple_i3 = iter(('1','2','3'))
 if n == 1:
  return next(list_i)

 if n == 2:
  return next(list_i)

 if n == 3:
  return next(tuple_i)

 if n == 4:
  return next(string_i)

 if n == 5:
  return next(string_i)

 if n == 6:
  return next(dict_i)

 if n == 7:
  return next(string_i2)

 if n == 8:
  return next(tuple_i2)

 if n == 9:
  return [x for x in 'string']

 if n == 10:
  return [x for x in {1:'1', '5':5,(2,3):3}]" "def pyel_test_bool_function_158(n):
 class a():
  def bool(self):
   return False
 o1 = a()
 class b():
  def __bool__(self):
   return False
 o2 = b()
 class c():
  def __init__(self,n):
   self.len = n
  def __len__(self):
   return self.len
 o3 = c(0)
 o4 = c(3)
 if n == 1:
  return 'y' if bool(o1) else 'n'

 if n == 2:
  return 'y' if bool(o2) else 'n'

 if n == 3:
  return 'y' if bool(o3) else 'n'

 if n == 4:
  return 'y' if bool(o4) else 'n'" "def pyel_test_divmod_function_157():
 a = 412
 b = 13
 return divmod(a, b)" "def pyel_test_enumerate_function_156():
 class a:
  x = 5
  def __iter__(self):
   return self
  def __next__(self):
   if self.x > 0:
    ret = str(self.x)
    self.x -= 1
    return ret
   raise StopIteration
 obj = a()
 return enumerate(obj)" "def pyel_test_dict_function_155():
 a = [('ab'),['b', 5],('c',8)]
 x = dict(a)
 return repr(x)" "def pyel_test_dict_function_154():
 class a:
  x = 5
  def __iter__(self):
   return self
  def __next__(self):
   if self.x > 0:
    ret = self.x
    self.x -= 1
    return ret, ret**2
   raise StopIteration
 o = a()
 x = dict(o)
 return repr((x))" "def pyel_test_float_function_153(n):
 x = '3.1'
 y = ['4']
 z = 2
 a = 3.3
 if n == 1:
  return float(x)

 if n == 2:
  return float(y[0])

 if n == 3:
  return float(z)

 if n == 4:
  return float(a)" "def pyel_test_float_function_152():
 class test:
  def __float__(self):
   return 342.1
 o = test()
 return float(o)" "def pyel_test_int_function_151(n):
 x = '3'
 y = ['4']
 z = 2
 a = 3.3
 if n == 1:
  return int(x)

 if n == 2:
  return int(y[0])

 if n == 3:
  return int(z)

 if n == 4:
  return int(a)" "def pyel_test_int_function_150():
 class test:
  def __int__(self):
   return 342
 o = test()
 return int(o)" "def pyel_test_abs_function_149():
 class C:
  def __abs__(self):
   'doc'
   return 'hi'
 obj = C()
 return abs(obj)" "def pyel_test_type_148(n):
 class testc: pass
 x = testc()
 y = type(x)
 if n == 1:
  return repr(type(x))

 if n == 2:
  return y is testc" "def pyel_test_eval_147(n):
 x = 23
 a = 1
 b = 4
 s = 'a+b'
 if n == 1:
  return eval('x')

 if n == 2:
  return eval(s)" "def pyel_test_str_146():
 class strtest:
  def __init__ (self, n):
   self.x = n
  def __str__(self):
   return 'str' + str(self.x)
 obj = strtest(4)
 return str(obj)" "def pyel_test_tuple_function_145(n):
 a = [1]
 b = [a,1]
 c = list(b)
 if n == 1:
  return c is b

 if n == 2:
  return c == b

 if n == 3:
  return c[0] is a" "def pyel_test_tuple_function_144(n):
 a = [1]
 b = (a, 1)
 c = tuple(b)
 if n == 1:
  return c

 if n == 2:
  return c[0] is a" "def pyel_test_tuple_function_143(n):
 a = (1,)
 b = [a, 1]
 c = tuple(b)
 if n == 1:
  return c

 if n == 2:
  return c[0] is a" "def pyel_test_tuple_function_142(n):
 s = '123'
 l = [1,2,3]
 tu = (1,2,3,)
 d = {1:'1',2:'2',3:'3'}
 if n == 1:
  return tuple(s)

 if n == 2:
  return tuple(l)

 if n == 3:
  return tuple(tu)

 if n == 4:
  return tuple(d)" "def pyel_test_tuple_function_141():
 class a:
  x = 5
  def __iter__(self):
   return self
  def __next__(self):
   if self.x > 0:
    ret = str(self.x)
    self.x -= 1
    return ret
   raise StopIteration
 obj = a()
 return list(obj)" "def pyel_test_list_function_140(n):
 a = [1]
 b = [a,1]
 c = list(b)
 if n == 1:
  return c is b

 if n == 2:
  return c == b

 if n == 3:
  return c[0] is a" "def pyel_test_list_function_139(n):
 a = [1]
 b = (a, 1)
 c = list(b)
 if n == 1:
  return c

 if n == 2:
  return c[0] is a" "def pyel_test_list_function_138(n):
 s = '123'
 l = [1,2,3]
 tu = (1,2,3,)
 d = {1:'1',2:'2',3:'3'}
 if n == 1:
  return list(s)

 if n == 2:
  return list(l)

 if n == 3:
  return list(tu)

 if n == 4:
  return list(d)" "def pyel_test_list_function_137():
 class a:
  x = 5
  def __iter__(self):
   return self
  def __next__(self):
   if self.x > 0:
    ret = str(self.x)
    self.x -= 1
    return ret
   raise StopIteration
 obj = a()
 return list(obj)" "def pyel_test_len_function_136(n):
 a = [1,2,3,'5']
 b = []
 c = 'str'
 d = (1,2,3,4)
 if n == 1:
  return len(a)

 if n == 2:
  return len(b)

 if n == 3:
  return len(c)

 if n == 4:
  return len(d)" "def pyel_test_boolop_135(n):
 a = True
 b = False
 if n == 1:
  return a or b

 if n == 2:
  return False or b or True

 if n == 3:
  return a and b

 if n == 4:
  return False or 'a'" "def pyel_test_dict_comprehensions_134(n):
 x = {x: [y*y for y in range(x)] for x in range(20)}
 if n == 1:
  return hash_table_count(x)

 if n == 2:
  return x[3],x[5],x[10]" "def pyel_test_list_comprehensions_133(n):
 matrix = [[1, 2, 3, 4],[5, 6, 7, 8],[9, 10, 11, 12],]
 transposed = []
 for i in range(4):
  transposed.append([row[i] for row in matrix])
 if n == 1:
  return [[row[i] for row in matrix] for i in range(4)]

 if n == 2:
  return transposed" "def pyel_test_in_132(n):
 class tst():
  x = [1,2,3,4]
  def __contains__(self,e):
   return e in self.x
 x = tst()
 if n == 1:
  return 3 in x

 if n == 2:
  return 3 not in x

 if n == 3:
  return 2 in [x][0]" "def pyel_test_in_131(n):
 class tst2:
  x = [1,2,3,4]
  def __iter__(self):
   self.i = 0
   self.max = len(self.x)
   return self
  def __next__(self):
   i = self.i
   __i = i
   __m = self.max
   if i < self.max:
     ret = self.x[i]
     self.i = i+1
     return ret
   else:
    raise StopIteration
 o = tst2()
 if n == 1:
  return 3 in o

 if n == 2:
  return 33 not in o

 if n == 3:
  return 3 not in o

 if n == 4:
  return 33 in o" "def pyel_test_in_130(n):
 class tst3:
  x = [5,6,7,8]
  def __getitem__(self, index):
   if type(index) == int and index >= 0 and index < len(self.x):
    return self.x[index];
   else:
    raise IndexError
 o = tst3()
 x = []
 for i in range(10):
  if i in o:
   x.append(i)
 if n == 1:
  return 3 in o

 if n == 2:
  return 7 in o

 if n == 3:
  return 7 not in o

 if n == 4:
  return 12 not in o

 if n == 5:
  return x" "def pyel_test_try_129(n):
 a = ''
 try:
  1 / 0
  a = 'yes'
 except:
  a = 'no'

 b = ''
 try:
  b = 'a'
  [1,3][23]
 except:
  try:
   1/0
  except:
   b = 'ok'

 c = ''
 try:
  c = 'y'
 except:
  c = 'n'

 try:
  raise IndexError
  d = 2
 except IndexError:
  d = 2233
 except:
  d = 'no'


 if n == 1:
  return a

 if n == 2:
  return b

 if n == 3:
  return c

 if n == 4:
  return d" "def pyel_test_continue_128():
 l = [0]
 y = 8;
 while y > 0:
  y = y -1
  if y % 2 == 0:
   continue
  l.append(y)
 return l" "def pyel_test_continue_127():
 x = [0]
 c = 0
 while c < 3:
  c = c + 1
  y = 0
  while y < 5:
   y = y + 1
   if y % 2 == 0:
    x.append('c')
    continue
   x.append(y)
 return x" "def pyel_test_break_126():
 x = 0
 while x < 10:
  x = x + 1
  if x == 3:
   break
 return x" "def pyel_test_break_125():
 x = [0]
 c = 0
 while c < 3:
  c = c + 1
  y = 0
  while y < 10:
   y = y + 1
   x.append(y)
   if y == 3:
    x.append('b')
    break
 return x" "def pyel_test_aug_assign_124(n):
 x = 2
 if n == 1:
  x += 3
  return x

 if n == 2:
  x *= 3
  return x

 if n == 3:
  x -= 1
  return x

 if n == 4:
  x /= 4
  return x" "def pyel_test_aug_assign_123(n):
 x = [2,'s']
 if n == 1:
  x[0] += 3
  return x[0]

 if n == 2:
  x[0] *= 3
  return x[0]

 if n == 3:
  x[0] -= 1
  return x[0]

 if n == 4:
  x[0] /= 4
  return x[0]

 if n == 5:
  x[1] += 's'
  return x[1]" "def pyel_test_aug_assign_122(n):
 a = {1:4, 2:4, 3:4}
 a[1] += 3
 a[2] *= 4
 a[3] -= 4
 if n == 1:
  return a[1]

 if n == 2:
  return a[2]

 if n == 3:
  return a[3]" "def pyel_test_aug_assign_121():
 a = [1,3]
 a += [4,2]
 return a" "def pyel_test_aug_assign_120():
 v = (1,2)
 v += (3,3)
 return v" "def pyel_test_aug_assign_119():
 s = 'st'
 s += 'ring'
 return s" "def pyel_test_aug_assign_118(n):
 class a:
  x = 2
 if n == 1:
  a.x += 3
  return a.x

 if n == 2:
  a.x *= 3
  return a.x

 if n == 3:
  a.x -= 1
  return a.x

 if n == 4:
  a.x /= 4
  return a.x" "def pyel_test_aug_assign_117():
 class tst:
  x = 3
  def __iadd__(self, n):
   self.x = self.x + n
   return self
 o = tst()
 o += 2
 return o.x" "def pyel_test_usub_116():
 a = 2
 return -a" "def pyel_test_not_115(n):
 class c:
  def __init__(self, n):
   self.length = n
  def __len__(self):
   return self.length
 x = c(0)
 y = c(1)
 if n == 1:
  return not x

 if n == 2:
  return not x" "def pyel_test_lambda_114(n):
 f = lambda x,y: x+y
 f2 = lambda x,*rest: [x,rest]
 f3 = lambda x, *rest, **k : [x, rest, k]
 if n == 1:
  return f(1,2.3)

 if n == 2:
  return f2(1,2,3,4,'asd')

 if n == 3:
  return repr(f3(1,2,3,4,5,a__=1,b__=2))" "def pyel_test_global_113(n):
 x = 1
 y = 1
 def f():
  global x
  x = 3
  y = 2
 f()
 if n == 1:
  return x

 if n == 2:
  return y" "def pyel_test_for_loop_112():
 x = []
 for a in range(5):
  x.append(a)
 return x" "def pyel_test_for_loop_111():
 x = []
 for a,b in [[1,2],'34',(5,6)]:
  x.append([a,b])
 return x" "def pyel_test_for_loop_110():
 x = []
 for a,b,c,d in [[1,2,1,1],'34xa',(5,6,'a',1)]:
  x.append([a,b,c,d,a])
 return x" "def pyel_test_for_loop_109():
 n = 0
 for a in range(5):
  for b in range(5):
   n = n + a + b
 return n" "def pyel_test_for_loop_108():
 x = []
 for a in range(100):
  if (a % 2 == 0):
   continue
  if a > 10:
   break
  x.append(a)
 return x" "def pyel_test_for_loop_107():
 x = []
 for a in (1,2,3,4):
  x.append(2*a)
 return x" "def pyel_test_for_loop_106():
 x = []
 for a,b in ([1,2],'34',(5,6)):
  x.append([a,b])
 return x" "def pyel_test_for_loop_105():
 tup = make_vector(20,0)
 for i in range(10):
  tup[i] = i
 x = []
 tup = make_vector(20,0)
 for i in range(20):
  tup[i] = i;
 for a in tup:
  if (a % 2 == 0):
   continue
  if a > 10:
   break
  x.append(a)
 return x" "def pyel_test_for_loop_104():
 x = []
 for a in 'string':
  x.append(a)
 return x" "def pyel_test_for_loop_103(n):
 x = []
 c = 0
 def getstr():
  global c
  c+=1
  return 'qwerty'
 for a in getstr():
  x.append(a)
 if n == 1:
  return x

 if n == 2:
  return c" "def pyel_test_for_loop_102():
 class a:
  x = 5
  def __iter__(self):
   return self
  def __next__(self):
   if self.x > 0:
    ret = str(self.x)
    self.x -= 1
    return ret
   raise StopIteration
 obj = a()
 x = []
 for n in obj:
  x.append(n)
 return x" "def pyel_test_special_method_lookup_95(n):
 class adder:
  def __init__(self, n):
   self.x = n
  def __call__ (self, n):
   return self.x + n
 c = adder(10)
 d = adder(10)
 d.__call__ = lambda : 'hi'
 if n == 1:
  return c(6)

 if n == 2:
  return repr(c.__call__)

 if n == 3:
  return d.__call__" "def pyel_test_objects_94(n):
 class tclass():
  '''a test class'''
  cvar = 12
  def __init__(self, x):
   self.a = x + 10
  def get(self):
   return self.a
  def set(self,n):
   self.a = n
 x = tclass(4)
 if n == 1:
  return tclass.__name__

 if n == 2:
  return tclass.get

 if n == 3:
  return tclass.set

 if n == 4:
  return tclass.cvar

 if n == 5:
  tclass.v = 'hi'
  return tclass.v

 if n == 6:
  tclass.set(tclass, 23)
  return tclass.a

 if n == 7:
  tclass.set(tclass, 19)
  return tclass.get(tclass)

 if n == 8:
  tclass.add5 = lambda self: self.cvar + 5
  return tclass.add5

 if n == 9:
  return repr(x)

 if n == 10:
  return x.__class__ == tclass

 if n == 11:
  return x.__class__.__name__

 if n == 12:
  return x.a

 if n == 13:
  x.a = 2
  return x.a

 if n == 14:
  x.cvar = 4
  return  x.cvar, tclass.cvar

 if n == 15:
  x.set(10); y = x.get
  return y()

 if n == 16:
  tclass.sixmore = lambda self: self.a + 6
  y = x.sixmore
  x.a = 2
  return y()" "def pyel_test_objects_93(n):
 class one:
  def __init__(self,x):
   self.n = x
  def m(self):
   return self.n + 1
 class two:
  def __init__(self):
   self.other = one(5)
 x = two()
 if n == 1:
  return x.other.n

 if n == 2:
  return x.other.m()" "def pyel_test_subscript_92():
 a = '1X23'
 return a[1]" "def pyel_test_subscript_91():
 a = [1,2,3,4]
 return a[1]" "def pyel_test_subscript_90():
 a = (1,2,3,4)
 return a[1]" "def pyel_test_subscript_89():
 class a:
  def __getitem__ (self, value):
   return value + 4
 x = a()
 return x[1]" "def pyel_test_subscript_88(n):
 a = (1,2,3,4,5)
 if n == 1:
  return a[1:4]

 if n == 2:
  return a[:4]

 if n == 3:
  return a[2:]

 if n == 4:
  return a[:]" "def pyel_test_subscript_87(n):
 a = [1,2,3,4,5]
 if n == 1:
  return a[1:4]

 if n == 2:
  return a[:4]

 if n == 3:
  return a[2:]

 if n == 4:
  return a[:]" "def pyel_test_subscript_86(n):
 a = '012345678'
 if n == 1:
  return a[1:4]

 if n == 2:
  return a[:4]

 if n == 3:
  return a[2:]

 if n == 4:
  return a[:]" "def pyel_test_subscript_85(n):
 class a:
  def __getitem__ (self, value):
   return value.start + value.stop
 x = a()
 if n == 1:
  return x[1:2]

 if n == 2:
  return x[5:7]" "def pyel_test_subscript_84(n):
 def __add(a,b):
  return a+b
 a = [1,2,3,4]
 a[0] = __add(a[1],a[2])
 a[2] = 'str'
 if n == 1:
  return a[0]

 if n == 2:
  return a[2]" "def pyel_test_subscript_83(n):
 a = (1,2,3,4)
 a[0] = a[1] + a[2]
 a[2] = 'str'
 if n == 1:
  return a[0]

 if n == 2:
  return a[2]" "def pyel_test_subscript_82(n):
 class a:
  def __setitem__ (self, index, value):
   self.index = index
   self.value = value
 x = a()
 x[3] = 5
 if n == 1:
  return x.index

 if n == 2:
  return x.value" "def pyel_test_subscript_81(n):
 a = [1,2,3,4,5,6]
 if n == 1:
  a[1:4] = [5,4,'f']
  return a

 if n == 2:
  a[:3] = ['a',4,2.2]
  return a

 if n == 3:
  a[3:] = [3,3]
  return a" "def pyel_test_subscript_80():
 a = (1,2,3,4,5,6)
 a[1:4] = (5,4,'f')
 return a" "def pyel_test_subscript_79():
 a = (1,2,3,4,5,6)
 a[:3] = ('a',4,2.2)
 return a" "def pyel_test_subscript_78():
 a = (1,2,3,4,5,6)
 a[3:] = (3,3)
 return a" "def pyel_test_subscript_77():
 a = '123456'
 a[1:4] = '54f'
 return a" "def pyel_test_subscript_76():
 a = '123456'
 a[:3] = 'a42'
 return a" "def pyel_test_subscript_75():
 a = '123456'
 a[3:] = '33'
 return a" "def pyel_test_subscript_74(n):
 class a:
  def __setitem__ (self, index, value):
   self.start = index.start
   self.stop = index.stop
   self.step = index.step
   self.value = value
 x = a()
 x[2:3] = [1,2,3]
 if n == 1:
  return x.start

 if n == 2:
  return x.stop

 if n == 3:
  return x.value" "def pyel_test_subscript_73():
 a = [1,2,3,4,5,6]
 a[2] += 3
 return a" "def pyel_test_subscript_72():
 a = [1,2,3,4,5,6]
 b = [1,2,3,4,5,6]
 a[2] += b[3]
 return a" "def pyel_test_slice_object_71(n):
 o1 = slice(5)
 o2 = slice(1, 5)
 o3 = slice(2, 6, 7)
 if n == 1:
  return o1.start

 if n == 2:
  return o1.stop

 if n == 3:
  return o1.step

 if n == 4:
  return o2.start

 if n == 5:
  return o2.stop

 if n == 6:
  return o2.step

 if n == 7:
  return o3.start

 if n == 8:
  return o3.stop

 if n == 9:
  return o3.step" "def pyel_test_mod_op_70():
 a = 3
 b = 5
 return b % a" "def pyel_test_bin_ops_69(n):
 a = 3
 b = 5
 if n == 1:
  return a & b

 if n == 2:
  return a | b

 if n == 3:
  return a ^ b" "def pyel_test_div_op_68(n):
 a = 9
 b = 4
 if n == 1:
  return a / b

 if n == 2:
  return a // b" "def pyel_test_pow_op_67():
 n1 = 2
 n2 = 4
 return n1 ** n2" "def pyel_test_mult_op_66(n):
 n1 = 2
 n2 = 4
 s = 's'
 if n == 1:
  return n1 * n2

 if n == 2:
  return s * n1

 if n == 3:
  return n1 * s" "def pyel_test_sub_op_65():
 n1 = 5
 n2 = 3
 return n1 - n2" "def pyel_test_add_op_64(n):
 n1 = 2
 n2 = 5
 s1 = 'asd'
 s2 = 'df'
 l1 = [1]
 l2 = [3,'a']
 v1 = (1,2)
 v2 = (3,)
 if n == 1:
  return n1 + n2

 if n == 2:
  return s1 + s2

 if n == 3:
  return l1 + l2

 if n == 4:
  return v1 + v2" "def pyel_test_add_op_63():
 class test:
  def __init__(self, n):
   message('init')
   self.n = n*2
  def __add__(self, o):
   message('adding')
   return self.n + o.n
 x = test(5)
 y = test(2)
 return x + y" "def pyel_test_function_arguments_62(n):
 def func(__a,__b,c=1,d='two',*rest,**kwargs):
  return [__a,__b,c,d,rest,kwargs]
 if n == 1:
  return repr(func(1,2))

 if n == 2:
  return repr(func(1,2,3))

 if n == 3:
  return repr(func(1,2,3,4))

 if n == 4:
  return repr(func(1,2,3,4,5))

 if n == 5:
  return repr(func(1,2,3,4,5,6))

 if n == 6:
  return repr(func(1,2,3,4,5,6,x = 's'))

 if n == 7:
  return repr(func(1,2,3,4,5,6,x = 's',y = 23))

 if n == 8:
  return repr(func(x = 's',__b = 324,__a = 'n',))

 if n == 9:
  return repr(func(x = 's',__b = 324,__a = 'n',d = 2))" "def pyel_test_function_arguments_61(n):
 def test(a, *b, c=1, d, **e):
  return [a, b, c, d, e]
 if n == 1:
  return repr(test('x',1,2,3,_d=1.1,_xx=2.2,_yy=3.3))

 if n == 2:
  return repr(test('x',d=1.1))

 if n == 3:
  return repr(test('x'))

 if n == 4:
  return repr(test(d=1,c=2,a='x',e=4))

 if n == 5:
  return repr(test(1,2,3,4,5,6))" "def pyel_test_function_arguments_60(n):
 def test(a,b):
      return [a,b]
 if n == 1:
  return test(1,2)

 if n == 2:
  return test(b=4,a='s')" "def pyel_test_function_arguments_59(n):
 def test(a,b,c,d=1,dd=2,ddd=4,*restst, x=1,xx=32,xxx=43,**kwargs_):
  return [a,b,c,d,dd,ddd,restst,x,xx,xxx,kwargs_]
 if n == 1:
  return repr(test(1,2,3,999,888,777,1,2,3,43,4,5,x=3))

 if n == 2:
  return repr(test(1,2,3,999,888,777,1,2,3,43,4,5))" "def pyel_test_def_58(n):
 def a():
   return 0

 def b(a):
  return a

 def c(a,b,c):
  return a+b+c

 def d(a):
  if True:
   return a
  return 5
  somethingelse()

 def e(a=1.1):
  return a
 def f(*a):
  return a

 if n == 1:
  return a()

 if n == 2:
  return b(1)

 if n == 3:
  return c(1,2,3)

 if n == 4:
  return d(2)

 if n == 5:
  return e()

 if n == 6:
  return e(22)

 if n == 7:
  return f(1,3,5,6,8)" "def pyel_test_def_57(n):
 def a():
  'docstring'
  interactive()
  x = 1
  return 'hi'

 def b():
  return 2
 if n == 1:
  return commandp(quote(a))

 if n == 2:
  return commandp(quote(b))" "def pyel_test_while_56():
 x = 1
 a = 0
 while x < 10:
  a += x
  x += 1
 return a" "def pyel_test_while_55(n):
 def f():
  x = 1;
  while x < 10:
   return x
   x+=1
  return x

 def g():
  x = 1;
  while x < 10:
   x+=1
   return x
  return x
 if n == 1:
  return f()

 if n == 2:
  return g()" "def pyel_test_while_54():
 x = 1
 while x < 10:
  if x == 3:
   break
  x+=1
 return x" "def pyel_test_while_53():
 x = 0
 a=0
 while x < 10:
  x+=1
  if x%2 == 0:
   continue
  a+=1
 return a" "def pyel_test_call_52(n):
 def a(): return 4
 if n == 1:
  return a()

 if n == 2:
  x = a()
  return x" "def pyel_test_call_51():
 def f():
  return lambda: 3
 return f()()" "def pyel_test_call_50():
 def f(a):
  def g(b):
   return a + b
  return g
 return f(3)(4)" "def pyel_test_call_49():
 def f(x): return x + 1
 def g(x): return x + 2
 return f(g(1))" "def pyel_test_if_48():
 if True:
  x = 1
 else:
  x = 2
 return x" "def pyel_test_if_47():
 if False:
  x = 3
 else:
  x = 4
 return x" "def pyel_test_if_46():
 if len([1,2,3]) == 3:
  y = 1
  x = 5
 else:
  y = 1
  x = 6
 return x" "def pyel_test_if_45(n):
 def a():
  if True:
   return 1
  else:
   return 2

 def b():
  if True:
   return 1
   x()
  else:
   y()
   return 2

 def c():
  if 1 == 2:
   return 1
   x()
  else:
   x = b() + 1
   return 2

 def d():
  if 1 == 2:
   return 4
  else:
   if True:
    return 1.1
    x()
   return 2

 def e():
  if 1 == 1:
   if True:
    if [0][0] == 0:
     return 12
    x()
  else:
   y()
   return 2
 if n == 1:
  return a()

 if n == 2:
  return b()

 if n == 3:
  return c()

 if n == 4:
  return d()

 if n == 5:
  return e()" "def pyel_test_if_44():
 def test():
  if 1 == 3:
   return 12
  elif 3 == 5:
   return 123
  elif 2 == 2:
   return 234
  else:
   return 33
 return test()" "def pyel_test_if_43():
 def test():
  if False:
   return 2
   c()
  else:
   return 5
   e()
 return test()" "def pyel_test_compare_42():
 a = 'a'
 b = 'b'
 return a == b" "def pyel_test_compare_41():
 a = 'a'
 b = 'b'
 return a != b" "def pyel_test_compare_40():
 def a(): return 'a'
 b = 'b'
 return a()<=b<'t'<='zaaaz'" "def pyel_test_compare_39():
 a = [1]
 b = a
 return a is b" "def pyel_test_string_38():
 x = 'a'
 return x" "def pyel_test_Tuple_37(n):
 a = 1
 b = 3
 c = 4
 if n == 1:
  return (a, 4)

 if n == 2:
  return (a, (b, (c,4)))

 if n == 3:
  return ((((((((a))))))))

 if n == 4:
  return (a,)" "def pyel_test_dict_36(n):
 a = {'a':2, 'b':4}
 b = {2:a, 'b':4}
 c = {'a':2, 'b':4, 'c' : {'d' : 1,'e': 2,'f':{'g':3}}}
 d = {}
 if n == 1:
  return repr(a)

 if n == 2:
  return repr(b)

 if n == 3:
  return repr(c)

 if n == 4:
  return repr(d)

 if n == 5:
  return repr(c['c'])

 if n == 6:
  return repr(c['c']['f'])

 if n == 7:
  return c['c']['f']['g']" "def pyel_test_list_35(n):
 a = [1,2,'b']
 b = [1,[1,'3',a,[],3]]
 if n == 1:
  return a

 if n == 2:
  return b" "def pyel_test_attribute_34(n):
 class a:
  b = 3

 class b:
  x = a()

 class c:
  y =  b()
 o = b()
 o2 = c()
 if n == 1:
  return a.b

 if n == 2:
  return b.x.b

 if n == 3:
  return o.x.b

 if n == 4:
  return o2.y.x.b

 if n == 5:
  return c.y.x.b

 if n == 6:
  a.b = 2
  return a.b

 if n == 7:
  b.x.y = 2
  return b.x.y

 if n == 8:
  b.v = 4
  o2.y.v = b.v
  return o2.y.v

 if n == 9:
  o2.f = lambda x: x+1
  return o2.f(3)" "def pyel_test_assign_33():
 a = 1
 return a" "def pyel_test_assign_32():
 class a: pass
 a.b = 1
 return a.b" "def pyel_test_assign_22(n):
 a,b = 1,2
 if n == 1:
  return a

 if n == 2:
  return b" "def pyel_test_assign_21(n):
 x = [1,0,9]
 f = lambda: 3
 class C: pass
 C.a = 3
 a, C.v, x[2] = C.a,1.1, x[x[1]]
 if n == 1:
  return a

 if n == 2:
  return C.v

 if n == 3:
  return x[2]" "def pyel_test_assign_20(n):
 a = 1
 b = 2
 a,b= b,a
 if n == 1:
  return a

 if n == 2:
  return b" "def pyel_test_assign_19(n):
 a = [1,2]
 b = (3,4)
 x,y = a
 xx,yy = b
 if n == 1:
  return x

 if n == 2:
  return y

 if n == 3:
  return xx

 if n == 4:
  return yy" "def pyel_test_assign_18(n):
 class C:
  a = [11,22,33]
 x,y,z = C.a
 if n == 1:
  return x

 if n == 2:
  return y

 if n == 3:
  return z" "def pyel_test_assign_17():
 a = 1
 b = 2
 c = 3
 d = a,b,c
 return d" "def pyel_test_assign_1(n):
 class x:
  a = 1
 xx = x()
 l = [1,2,3]
 a = xx.a = l[1] = b = c = 9
 z = l[2] = xx.a
 if n == 1:
  return a

 if n == 2:
  return b

 if n == 3:
  return c

 if n == 4:
  return xx.a

 if n == 5:
  return l[1]

 if n == 6:
  return z

 if n == 7:
  return l[2]"))(ert-deftest pyel-rfind-method7 nil (equal (pyel-eval "def _pyel21312():
 'aaaxaaa'.rfind('x',3)
_pyel21312()") 3))
(ert-deftest pyel-rfind-method6 nil (equal (pyel-eval "def _pyel21312():
 'aaaxaaa'.rfind('x',4)
_pyel21312()") -1))
(ert-deftest pyel-rfind-method5 nil (equal (pyel-eval "def _pyel21312():
 'aaaxaaa'.rfind('x',2, 4)
_pyel21312()") 3))
(ert-deftest pyel-rfind-method4 nil (equal (pyel-eval "def _pyel21312():
 'aaaxaaa'.rfind('x',1, 3)
_pyel21312()") -1))
(ert-deftest pyel-rfind-method3 nil (equal (pyel-eval "def _pyel21312():
 'abcxebdxebdexed'.rfind('xe')
_pyel21312()") 12))
(ert-deftest pyel-ljust-method7 nil (equal (pyel-eval "def _pyel21312():
 'hi'.ljust(10)
_pyel21312()") "hi        "))
(ert-deftest pyel-ljust-method6 nil (equal (pyel-eval "def _pyel21312():
 'hi'.ljust(7, '_')
_pyel21312()") "hi_____"))
(ert-deftest pyel-ljust-method5 nil (equal (pyel-eval "def _pyel21312():
 'hi'.ljust(10)
_pyel21312()") "hi        "))
(ert-deftest pyel-ljust-method4 nil (equal (pyel-eval "def _pyel21312():
 'hi'.ljust(3, '_')
_pyel21312()") "hi_"))
(ert-deftest pyel-ljust-method3 nil (equal (pyel-eval "def _pyel21312():
 'hi'.ljust(7, '_')
_pyel21312()") "hi_____"))
(ert-deftest pyel-ljust-method2 nil (equal (pyel-eval "def _pyel21312():
 'hisldkjf'.ljust(3, '_')
_pyel21312()") "hisldkjf"))
(ert-deftest pyel-rjust-method7 nil (equal (pyel-eval "def _pyel21312():
 'hi'.rjust(10)
_pyel21312()") "        hi"))
(ert-deftest pyel-rjust-method6 nil (equal (pyel-eval "def _pyel21312():
 'hi'.rjust(7, '_')
_pyel21312()") "_____hi"))
(ert-deftest pyel-rjust-method5 nil (equal (pyel-eval "def _pyel21312():
 'hi'.rjust(10)
_pyel21312()") "        hi"))
(ert-deftest pyel-rjust-method4 nil (equal (pyel-eval "def _pyel21312():
 'hi'.rjust(3, '_')
_pyel21312()") "_hi"))
(ert-deftest pyel-rjust-method3 nil (equal (pyel-eval "def _pyel21312():
 'hi'.rjust(7, '_')
_pyel21312()") "_____hi"))
(ert-deftest pyel-rjust-method2 nil (equal (pyel-eval "def _pyel21312():
 'hisldkjf'.rjust(3, '_')
_pyel21312()") "hisldkjf"))
(ert-deftest pyel-rpartition-method5 nil (equal (pyel-eval "def _pyel21312():
 'abcdefghi'.rpartition('c')
_pyel21312()") ["ab" "c" "defghi"]))
(ert-deftest pyel-rpartition-method4 nil (equal (pyel-eval "def _pyel21312():
 'abcdefghi'.rpartition('cde')
_pyel21312()") ["ab" "cde" "fghi"]))
(ert-deftest pyel-rpartition-method3 nil (equal (pyel-eval "def _pyel21312():
 'abcdefghi'.rpartition('x')
_pyel21312()") ["abcdefghi" "" ""]))
(ert-deftest pyel-rpartition-method2 nil (equal (pyel-eval "def _pyel21312():
 'x'.rpartition('x')
_pyel21312()") ["" "x" ""]))
(ert-deftest pyel-partition-method5 nil (equal (pyel-eval "def _pyel21312():
 'abcdefghi'.partition('c')
_pyel21312()") ["ab" "c" "defghi"]))
(ert-deftest pyel-partition-method4 nil (equal (pyel-eval "def _pyel21312():
 'abcdefghi'.partition('cde')
_pyel21312()") ["ab" "cde" "fghi"]))
(ert-deftest pyel-partition-method3 nil (equal (pyel-eval "def _pyel21312():
 'abcdefghi'.partition('x')
_pyel21312()") ["abcdefghi" "" ""]))
(ert-deftest pyel-partition-method2 nil (equal (pyel-eval "def _pyel21312():
 'x'.partition('x')
_pyel21312()") ["" "x" ""]))
(ert-deftest pyel-rsplit-method3 nil (equal (pyel-eval "def _pyel21312():
 'a b c'.rsplit()
_pyel21312()") (quote ("a" "b" "c"))))
(ert-deftest pyel-lstrip-method3 nil (equal (pyel-eval "def _pyel21312():
 'hello'.lstrip('heo')
_pyel21312()") "llo"))
(ert-deftest pyel-lstrip-method2 nil (equal (pyel-eval "def _pyel21312():
 '      hello     '.lstrip()
_pyel21312()") "hello         "))
(ert-deftest pyel-rstrip-method3 nil (equal (pyel-eval "def _pyel21312():
 'hello'.rstrip('heo')
_pyel21312()") "hell"))
(ert-deftest pyel-rstrip-method2 nil (equal (pyel-eval "def _pyel21312():
 '      hello     '.rstrip()
_pyel21312()") "    hello"))
(ert-deftest pyel-splitlines-method4 nil (equal (pyel-eval "def _pyel21312():
 '''a
 b
 c

 '''.splitlines()
_pyel21312()") (quote ("a" "b" "c" ""))))
(ert-deftest pyel-splitlines-method3 nil (equal (pyel-eval "def _pyel21312():
 x =  '''a

 b
 c

 '''.splitlines()
_pyel21312()") (quote ("a" "" "" "b" "c" ""))))
(ert-deftest pyel-splitlines-method2 nil (equal (pyel-eval "def _pyel21312():
 ''.splitlines()
_pyel21312()") nil))
(ert-deftest pyel-splitlines-method1 nil (equal (pyel-eval "def _pyel21312():
 'asdf'.splitlines()
_pyel21312()") (quote ("asdf"))))
(ert-deftest pyel-startswith-method11 nil (equal (pyel-eval "def _pyel21312():
 'abcde'.startswith('bcd', 1, 2)
_pyel21312()") nil))
(ert-deftest pyel-startswith-method10 nil (equal (pyel-eval "def _pyel21312():
 'abcde'.startswith('bcd', 1, 3)
_pyel21312()") nil))
(ert-deftest pyel-startswith-method9 nil (equal (pyel-eval "def _pyel21312():
 'abcde'.startswith('bcd', 1, 4)
_pyel21312()") t))
(ert-deftest pyel-startswith-method8 nil (equal (pyel-eval "def _pyel21312():
 'abcde'.startswith('bcd', 1)
_pyel21312()") t))
(ert-deftest pyel-startswith-method7 nil (equal (pyel-eval "def _pyel21312():
 'abcde'.startswith('x', 1)
_pyel21312()") nil))
(ert-deftest pyel-startswith-method6 nil (equal (pyel-eval "def _pyel21312():
 'abcde'.startswith('abc')
_pyel21312()") t))
(ert-deftest pyel-startswith-method5 nil (equal (pyel-eval "def _pyel21312():
 '$abcde'.startswith('$abc')
_pyel21312()") t))
(ert-deftest pyel-startswith-method4 nil (equal (pyel-eval "def _pyel21312():
 'abcde'.startswith('.')
_pyel21312()") nil))
(ert-deftest pyel-startswith-method2 nil (equal (pyel-eval "def _pyel21312():
 'abcde'.startswith(('.', 'b'))
_pyel21312()") nil))
(ert-deftest pyel-startswith-method1 nil (equal (pyel-eval "def _pyel21312():
 'abcde'.startswith(('.', 'b','a'))
_pyel21312()") t))
(ert-deftest pyel-swapcase-method6 nil (equal (pyel-eval "def _pyel21312():
 'ab'.swapcase()
_pyel21312()") "AB"))
(ert-deftest pyel-swapcase-method5 nil (equal (pyel-eval "def _pyel21312():
 'aB'.swapcase()
_pyel21312()") "Ab"))
(ert-deftest pyel-swapcase-method4 nil (equal (pyel-eval "def _pyel21312():
 'aB1'.swapcase()
_pyel21312()") "Ab1"))
(ert-deftest pyel-swapcase-method3 nil (equal (pyel-eval "def _pyel21312():
 '11'.swapcase()
_pyel21312()") "11"))
(ert-deftest pyel-swapcase-method2 nil (equal (pyel-eval "def _pyel21312():
 ''.swapcase()
_pyel21312()") ""))
(ert-deftest pyel-title-method8 nil (equal (pyel-eval "def _pyel21312():
 'sldk'.title()
_pyel21312()") "Sldk"))
(ert-deftest pyel-title-method7 nil (equal (pyel-eval "def _pyel21312():
 's'.title()
_pyel21312()") "S"))
(ert-deftest pyel-title-method6 nil (equal (pyel-eval "def _pyel21312():
 ''.title()
_pyel21312()") ""))
(ert-deftest pyel-title-method5 nil (equal (pyel-eval "def _pyel21312():
 '2dd'.title()
_pyel21312()") "2Dd"))
(ert-deftest pyel-title-method4 nil (equal (pyel-eval "def _pyel21312():
 '2ddlkDd'.title()
_pyel21312()") "2Ddlkdd"))
(ert-deftest pyel-title-method3 nil (equal (pyel-eval "def _pyel21312():
 '23(23aaaaa'.title()
_pyel21312()") "23(23Aaaaa"))
(ert-deftest pyel-title-method2 nil (equal (pyel-eval "def _pyel21312():
 '343'.title()
_pyel21312()") "343"))
(ert-deftest pyel-zfill-method3 nil (equal (pyel-eval "def _pyel21312():
 '34'.zfill(5)
_pyel21312()") "00034"))
(ert-deftest pyel-zfill-method2 nil (equal (pyel-eval "def _pyel21312():
 '234789'.zfill(5)
_pyel21312()") "234789"))
(ert-deftest pyel-zfill-method1 nil (equal (pyel-eval "def _pyel21312():
 ''.zfill(5)
_pyel21312()") "00000"))
(ert-deftest pyel-isalnum-method6 nil (equal (pyel-eval "def _pyel21312():
 '0'isalnum()
_pyel21312()") t))
(ert-deftest pyel-isalnum-method5 nil (equal (pyel-eval "def _pyel21312():
 '0'isalnum()
_pyel21312()") t))
(ert-deftest pyel-isalnum-method4 nil (equal (pyel-eval "def _pyel21312():
 '0s'.isalnum()
_pyel21312()") nil))
(ert-deftest pyel-isalnum-method3 nil (equal (pyel-eval "def _pyel21312():
 ''.isalnum()
_pyel21312()") nil))
(ert-deftest pyel-isalnum-method2 nil (equal (pyel-eval "def _pyel21312():
 '0.1'.isalnum()
_pyel21312()") nil))
(ert-deftest pyel-isalpha-method6 nil (equal (pyel-eval "def _pyel21312():
 'a'.isalpha()
_pyel21312()") t))
(ert-deftest pyel-isalpha-method5 nil (equal (pyel-eval "def _pyel21312():
 'aBc'.isalpha()
_pyel21312()") t))
(ert-deftest pyel-isalpha-method4 nil (equal (pyel-eval "def _pyel21312():
 '2'.isalpha()
_pyel21312()") nil))
(ert-deftest pyel-isalpha-method3 nil (equal (pyel-eval "def _pyel21312():
 'a2B'.isalpha()
_pyel21312()") nil))
(ert-deftest pyel-isalpha-method2 nil (equal (pyel-eval "def _pyel21312():
 ''.isalpha()
_pyel21312()") nil))
(ert-deftest pyel-istitle-method4 nil (equal (pyel-eval "def _pyel21312():
 '2Dsldk'.istitle()
_pyel21312()") t))
(ert-deftest pyel-istitle-method3 nil (equal (pyel-eval "def _pyel21312():
 'DDsldk'.istitle()
_pyel21312()") nil))
(ert-deftest pyel-istitle-method2 nil (equal (pyel-eval "def _pyel21312():
 'LDKJ'.istitle()
_pyel21312()") nil))
(ert-deftest pyel-istitle-method1 nil (equal (pyel-eval "def _pyel21312():
 ''.istitle()
_pyel21312()") nil))
(ert-deftest pyel-isupper-method3 nil (equal (pyel-eval "def _pyel21312():
 'A1'.isupper()
_pyel21312()") t))
(ert-deftest pyel-isupper-method2 nil (equal (pyel-eval "def _pyel21312():
 'a1'.isupper()
_pyel21312()") nil))
(ert-deftest pyel-isupper-method1 nil (equal (pyel-eval "def _pyel21312():
 '11'.isupper()
_pyel21312()") nil))
(ert-deftest pyel-islower-method3 nil (equal (pyel-eval "def _pyel21312():
 'A1'.islower()
_pyel21312()") nil))
(ert-deftest pyel-islower-method2 nil (equal (pyel-eval "def _pyel21312():
 'a1'.islower()
_pyel21312()") t))
(ert-deftest pyel-islower-method1 nil (equal (pyel-eval "def _pyel21312():
 '11'.islower()
_pyel21312()") nil))
(ert-deftest pyel-strip-method3 nil (equal (pyel-eval "def _pyel21312():
 '
 hello  '.strip('heo')
_pyel21312()") "hello"))
(ert-deftest pyel-strip-method2 nil (equal (pyel-eval "def _pyel21312():
 'hello'.strip('heo')
_pyel21312()") "ll"))
(ert-deftest pyel-split-method3 nil (equal (pyel-eval "def _pyel21312():
 'a b c'.split()
_pyel21312()") (quote ("a" "b" "c"))))
(ert-deftest pyel-join-method3 nil (equal (pyel-eval "def _pyel21312():
 'X'.join(('f','g'))
_pyel21312()") "fXg"))
(ert-deftest pyel-join-method2 nil (equal (pyel-eval "def _pyel21312():
 ' '.join([str(x) for x in range(3)])
_pyel21312()") "0 1 2"))
(ert-deftest pyel-join-method1 nil (equal (pyel-eval "def _pyel21312():
 ''.join(['a','b']))
_pyel21312()") "ab"))
(ert-deftest pyel-count-method13 nil (equal (pyel-eval "def _pyel21312():
 'xxxxx'.count('x')
_pyel21312()") 5))
(ert-deftest pyel-count-method12 nil (equal (pyel-eval "def _pyel21312():
 'xxxx'.count('xx')
_pyel21312()") 2))
(ert-deftest pyel-count-method11 nil (equal (pyel-eval "def _pyel21312():
 'xxxx'.count('xxxx')
_pyel21312()") 1))
(ert-deftest pyel-count-method10 nil (equal (pyel-eval "def _pyel21312():
 'x.xx'.count('.')
_pyel21312()") 1))
(ert-deftest pyel-count-method1 nil (equal (pyel-eval "def _pyel21312():
 (1,1,1).count(1)
_pyel21312()") 3))
(ert-deftest pyel-find-method5 nil (equal (pyel-eval "def _pyel21312():
 'aaaxaaa'.find('x',3)
_pyel21312()") 3))
(ert-deftest pyel-find-method4 nil (equal (pyel-eval "def _pyel21312():
 'aaaxaaa'.find('x',4)
_pyel21312()") -1))
(ert-deftest pyel-find-method3 nil (equal (pyel-eval "def _pyel21312():
 'aaaxaaa'.find('x',2, 4)
_pyel21312()") 3))
(ert-deftest pyel-find-method2 nil (equal (pyel-eval "def _pyel21312():
 'aaaxaaa'.find('x',1, 3)
_pyel21312()") -1))
(ert-deftest pyel-hash3 nil (equal (pyel-eval "def _pyel21312():
 hash(3)
_pyel21312()") 3))
(ert-deftest pyel-hash2 nil (equal (pyel-eval "def _pyel21312():
 hash('3')
_pyel21312()") 63))
(ert-deftest pyel-sum-function7 nil (equal (pyel-eval "def _pyel21312():
 sum([1,2,3])
_pyel21312()") 6))
(ert-deftest pyel-sum-function6 nil (equal (pyel-eval "def _pyel21312():
 sum([])
_pyel21312()") 0))
(ert-deftest pyel-sum-function5 nil (equal (pyel-eval "def _pyel21312():
 sum((1,2,3))
_pyel21312()") 6))
(ert-deftest pyel-sum-function4 nil (equal (pyel-eval "def _pyel21312():
 sum(())
_pyel21312()") 0))
(ert-deftest pyel-sum-function3 nil (equal (pyel-eval "def _pyel21312():
 sum({1:'3',2:'32'})
_pyel21312()") 3))
(ert-deftest pyel-sum-function2 nil (equal (pyel-eval "def _pyel21312():
 sum({})
_pyel21312()") 0))
(ert-deftest pyel-any-function13 nil (equal (pyel-eval "def _pyel21312():
 any([[],False, 's',2])
_pyel21312()") t))
(ert-deftest pyel-any-function12 nil (equal (pyel-eval "def _pyel21312():
 any([[],False, '',0])
_pyel21312()") nil))
(ert-deftest pyel-any-function11 nil (equal (pyel-eval "def _pyel21312():
 any([])
_pyel21312()") nil))
(ert-deftest pyel-any-function10 nil (equal (pyel-eval "def _pyel21312():
 any(([],False, 's',2))
_pyel21312()") t))
(ert-deftest pyel-any-function9 nil (equal (pyel-eval "def _pyel21312():
 any(([],False, '',0))
_pyel21312()") nil))
(ert-deftest pyel-any-function8 nil (equal (pyel-eval "def _pyel21312():
 any(())
_pyel21312()") nil))
(ert-deftest pyel-any-function7 nil (equal (pyel-eval "def _pyel21312():
 any('s')
_pyel21312()") t))
(ert-deftest pyel-any-function6 nil (equal (pyel-eval "def _pyel21312():
 any('')
_pyel21312()") nil))
(ert-deftest pyel-any-function5 nil (equal (pyel-eval "def _pyel21312():
 any({0:4, 4:'', 1:'s'})
_pyel21312()") t))
(ert-deftest pyel-any-function4 nil (equal (pyel-eval "def _pyel21312():
 any({0:4, '':3, (): 2})
_pyel21312()") nil))
(ert-deftest pyel-any-function3 nil (equal (pyel-eval "def _pyel21312():
 any({})
_pyel21312()") nil))
(ert-deftest pyel-all-function13 nil (equal (pyel-eval "def _pyel21312():
 all([1,'s',2,4])
_pyel21312()") t))
(ert-deftest pyel-all-function12 nil (equal (pyel-eval "def _pyel21312():
 all([1,'s','',4])
_pyel21312()") nil))
(ert-deftest pyel-all-function11 nil (equal (pyel-eval "def _pyel21312():
 all([])
_pyel21312()") t))
(ert-deftest pyel-all-function10 nil (equal (pyel-eval "def _pyel21312():
 all((1,'s',2,4))
_pyel21312()") t))
(ert-deftest pyel-all-function9 nil (equal (pyel-eval "def _pyel21312():
 all((1,'s',(),4))
_pyel21312()") nil))
(ert-deftest pyel-all-function8 nil (equal (pyel-eval "def _pyel21312():
 all(())
_pyel21312()") t))
(ert-deftest pyel-all-function7 nil (equal (pyel-eval "def _pyel21312():
 all('s')
_pyel21312()") t))
(ert-deftest pyel-all-function6 nil (equal (pyel-eval "def _pyel21312():
 all('')
_pyel21312()") t))
(ert-deftest pyel-all-function5 nil (equal (pyel-eval "def _pyel21312():
 all({2:4, 4:'', 1:'s'})
_pyel21312()") t))
(ert-deftest pyel-all-function4 nil (equal (pyel-eval "def _pyel21312():
 all({2:4, 4:'', 1:'s', (): 2})
_pyel21312()") nil))
(ert-deftest pyel-all-function3 nil (equal (pyel-eval "def _pyel21312():
 all({})
_pyel21312()") t))
(ert-deftest pyel-bool-function13 nil (equal (pyel-eval "def _pyel21312():
 bool(2)
_pyel21312()") t))
(ert-deftest pyel-bool-function12 nil (equal (pyel-eval "def _pyel21312():
 bool(0)
_pyel21312()") nil))
(ert-deftest pyel-bool-function11 nil (equal (pyel-eval "def _pyel21312():
 bool([2,2])
_pyel21312()") t))
(ert-deftest pyel-bool-function10 nil (equal (pyel-eval "def _pyel21312():
 bool([])
_pyel21312()") nil))
(ert-deftest pyel-bool-function9 nil (equal (pyel-eval "def _pyel21312():
 bool((2,))
_pyel21312()") t))
(ert-deftest pyel-bool-function8 nil (equal (pyel-eval "def _pyel21312():
 bool(())
_pyel21312()") nil))
(ert-deftest pyel-bool-function7 nil (equal (pyel-eval "def _pyel21312():
 bool('s')
_pyel21312()") t))
(ert-deftest pyel-bool-function6 nil (equal (pyel-eval "def _pyel21312():
 bool('')
_pyel21312()") nil))
(ert-deftest pyel-bool-function5 nil (equal (pyel-eval "def _pyel21312():
 bool({})
_pyel21312()") nil))
(ert-deftest pyel-divmod-function7 nil (equal (pyel-eval "def _pyel21312():
 divmod(6, 2)
_pyel21312()") [3 0]))
(ert-deftest pyel-divmod-function6 nil (equal (pyel-eval "def _pyel21312():
 divmod(6, 4)
_pyel21312()") [1 2]))
(ert-deftest pyel-divmod-function5 nil (equal (pyel-eval "def _pyel21312():
 divmod(6.7, 4)
_pyel21312()") [1.0 2.7]))
(ert-deftest pyel-divmod-function4 nil (equal (pyel-eval "def _pyel21312():
 divmod(6.712, 4.1)
_pyel21312()") [1.0 2.612]))
(ert-deftest pyel-divmod-function3 nil (equal (pyel-eval "def _pyel21312():
 divmod(4.2, 2.1)
_pyel21312()") [2.0 0.0]))
(ert-deftest pyel-divmod-function2 nil (equal (pyel-eval "def _pyel21312():
 divmod(4, 2.1)
_pyel21312()") [1.0 1.9]))
(ert-deftest pyel-enumerate-function7 nil (equal (pyel-eval "def _pyel21312():
 enumerate(['a','b','c'])
_pyel21312()") (quote ((0 "a") (1 "b") (2 "c")))))
(ert-deftest pyel-enumerate-function6 nil (equal (pyel-eval "def _pyel21312():
 enumerate(('a','b','c'))
_pyel21312()") (quote ((0 "a") (1 "b") (2 "c")))))
(ert-deftest pyel-enumerate-function5 nil (equal (pyel-eval "def _pyel21312():
 enumerate('abc')
_pyel21312()") (quote ((0 "a") (1 "b") (2 "c")))))
(ert-deftest pyel-enumerate-function4 nil (equal (pyel-eval "def _pyel21312():
 enumerate(['a','b','c'],10)
_pyel21312()") (quote ((10 "a") (11 "b") (12 "c")))))
(ert-deftest pyel-enumerate-function3 nil (equal (pyel-eval "def _pyel21312():
 enumerate(('a','b','c'),10)
_pyel21312()") (quote ((10 "a") (11 "b") (12 "c")))))
(ert-deftest pyel-enumerate-function2 nil (equal (pyel-eval "def _pyel21312():
 enumerate('abc',10)
_pyel21312()") (quote ((10 "a") (11 "b") (12 "c")))))
(ert-deftest pyel-round-function4 nil (equal (pyel-eval "def _pyel21312():
 round(342.234)
_pyel21312()") 342))
(ert-deftest pyel-round-function3 nil (equal (pyel-eval "def _pyel21312():
 round(342.834)
_pyel21312()") 343))
(ert-deftest pyel-round-function2 nil (equal (pyel-eval "def _pyel21312():
 round(342.834,1)
_pyel21312()") 342.8))
(ert-deftest pyel-round-function1 nil (equal (pyel-eval "def _pyel21312():
 round(342.834,2)
_pyel21312()") 342.83))
(ert-deftest pyel-dict-function6 nil (equal (pyel-eval "def _pyel21312():
 repr(dict())
_pyel21312()") "{}"))
(ert-deftest pyel-dict-function5 nil (equal (pyel-eval "def _pyel21312():
 repr(dict(__a = 1,__b = 2,__c = 4))
_pyel21312()") "{--a: 1, --b: 2, --c: 4}"))
(ert-deftest pyel-dict-function4 nil (equal (pyel-eval "def _pyel21312():
 repr(dict([('a',3),('b', 5),('c',8)]))
_pyel21312()") "{\"a\": 3, \"b\": 5, \"c\": 8}"))
(ert-deftest pyel-dict-function3 nil (equal (pyel-eval "def _pyel21312():
 repr(dict((('a',3),('b', 5),('c',8))))
_pyel21312()") "{\"a\": 3, \"b\": 5, \"c\": 8}"))
(ert-deftest pyel-float-function9 nil (equal (pyel-eval "def _pyel21312():
 float('34')
_pyel21312()") 34.0))
(ert-deftest pyel-float-function8 nil (equal (pyel-eval "def _pyel21312():
 float('3.3')
_pyel21312()") 3.3))
(ert-deftest pyel-float-function7 nil (equal (pyel-eval "def _pyel21312():
 float(2)
_pyel21312()") 2.0))
(ert-deftest pyel-float-function6 nil (equal (pyel-eval "def _pyel21312():
 float(23.2)
_pyel21312()") 23.2))
(ert-deftest pyel-int-function9 nil (equal (pyel-eval "def _pyel21312():
 int('34')
_pyel21312()") 34))
(ert-deftest pyel-int-function8 nil (equal (pyel-eval "def _pyel21312():
 int('3.3')
_pyel21312()") 3))
(ert-deftest pyel-int-function7 nil (equal (pyel-eval "def _pyel21312():
 int(2)
_pyel21312()") 2))
(ert-deftest pyel-int-function6 nil (equal (pyel-eval "def _pyel21312():
 int(23.2)
_pyel21312()") 23))
(ert-deftest pyel-ord-function2 nil (equal (pyel-eval "def _pyel21312():
 ord('F')
_pyel21312()") 70))
(ert-deftest pyel-ord-function1 nil (equal (pyel-eval "def _pyel21312():
 ord('2')
_pyel21312()") 50))
(ert-deftest pyel-chr-function2 nil (equal (pyel-eval "def _pyel21312():
 chr(70)
_pyel21312()") "F"))
(ert-deftest pyel-chr-function1 nil (equal (pyel-eval "def _pyel21312():
 chr(50)
_pyel21312()") "2"))
(ert-deftest pyel-abs-function3 nil (equal (pyel-eval "def _pyel21312():
 abs(3)
_pyel21312()") 3))
(ert-deftest pyel-abs-function2 nil (equal (pyel-eval "def _pyel21312():
 abs(-3)
_pyel21312()") 3))
(ert-deftest pyel-type11 nil (equal (pyel-eval "def _pyel21312():
 type(t)
_pyel21312()") "<class 'bool'>"))
(ert-deftest pyel-type10 nil (equal (pyel-eval "def _pyel21312():
 type(3)
_pyel21312()") py-int))
(ert-deftest pyel-type9 nil (equal (pyel-eval "def _pyel21312():
 type(3.3)
_pyel21312()") py-float))
(ert-deftest pyel-type8 nil (equal (pyel-eval "def _pyel21312():
 type('3')
_pyel21312()") py-string))
(ert-deftest pyel-type7 nil (equal (pyel-eval "def _pyel21312():
 type([3])
_pyel21312()") py-list))
(ert-deftest pyel-type6 nil (equal (pyel-eval "def _pyel21312():
 type((3,))
_pyel21312()") py-tuple))
(ert-deftest pyel-type5 nil (equal (pyel-eval "def _pyel21312():
 type({3:'3'})
_pyel21312()") py-list))
(ert-deftest pyel-type4 nil (equal (pyel-eval "def _pyel21312():
 type('s') == str
_pyel21312()") t))
(ert-deftest pyel-type3 nil (equal (pyel-eval "def _pyel21312():
 type((3,)) == list
_pyel21312()") nil))
(ert-deftest pyel-pow-function5 nil (equal (pyel-eval "def _pyel21312():
 pow(2,5,5)
_pyel21312()") 2))
(ert-deftest pyel-pow-function4 nil (equal (pyel-eval "def _pyel21312():
 pow(3,7,20)
_pyel21312()") 7))
(ert-deftest pyel-pow-function3 nil (equal (pyel-eval "def _pyel21312():
 pow(3,7)
_pyel21312()") 2187))
(ert-deftest pyel-pow-function2 nil (equal (pyel-eval "def _pyel21312():
 pow(2,2)
_pyel21312()") 4))
(ert-deftest pyel-pow-function1 nil (equal (pyel-eval "def _pyel21312():
 pow(10,-2)
_pyel21312()") 0.01))
(ert-deftest pyel-bin-function2 nil (equal (pyel-eval "def _pyel21312():
 bin(123)
_pyel21312()") "0b1111011"))
(ert-deftest pyel-bin-function1 nil (equal (pyel-eval "def _pyel21312():
 bin(3456312)
_pyel21312()") "0b1101001011110100111000"))
(ert-deftest pyel-hex-function2 nil (equal (pyel-eval "def _pyel21312():
 hex(23)
_pyel21312()") "0x17"))
(ert-deftest pyel-hex-function1 nil (equal (pyel-eval "def _pyel21312():
 hex(123232332)
_pyel21312()") "0x758604c"))
(ert-deftest pyel-repr7 nil (equal (pyel-eval "def _pyel21312():
 repr('somestring')
_pyel21312()") "\"\\\"somestring\\\"\""))
(ert-deftest pyel-repr6 nil (equal (pyel-eval "def _pyel21312():
 repr(342)
_pyel21312()") "342"))
(ert-deftest pyel-repr5 nil (equal (pyel-eval "def _pyel21312():
 x = [1,2,'hi']
 repr(x)
_pyel21312()") "[1, 2, \"hi\"]"))
(ert-deftest pyel-repr4 nil (equal (pyel-eval "def _pyel21312():
 x = (1,'two',3)
 repr(x)
_pyel21312()") "(1, \"two\", 3)"))
(ert-deftest pyel-repr3 nil (equal (pyel-eval "def _pyel21312():
 x = {1: 'one', 5: 'five', 12: 'telve'}
 repr(x)
_pyel21312()") "{1: \"one\", 5: \"five\", 12: \"telve\"}"))
(ert-deftest pyel-repr2 nil (equal (pyel-eval "def _pyel21312():
 f = lambda : False
 repr(f)
_pyel21312()") "<function <lambda> at 0x18b071>"))
(ert-deftest pyel-repr1 nil (equal (pyel-eval "def _pyel21312():
 def __ff_(): pass
 repr(__ff_)
_pyel21312()") "<function --ff- at 0x18b071>"))
(ert-deftest pyel-str9 nil (equal (pyel-eval "def _pyel21312():
 str('somestring')
_pyel21312()") "\"somestring\""))
(ert-deftest pyel-str8 nil (equal (pyel-eval "def _pyel21312():
 str(\"'dstring'\")
_pyel21312()") "\"'dstring'\""))
(ert-deftest pyel-str7 nil (equal (pyel-eval "def _pyel21312():
 str(342)
_pyel21312()") "342"))
(ert-deftest pyel-str6 nil (equal (pyel-eval "def _pyel21312():
 x = [1,2,'hi']
 str(x)
_pyel21312()") "[1, 2, \"hi\"]"))
(ert-deftest pyel-str5 nil (equal (pyel-eval "def _pyel21312():
 x = (1,'two',3)
 str(x)
_pyel21312()") "(1, \"two\", 3)"))
(ert-deftest pyel-str4 nil (equal (pyel-eval "def _pyel21312():
 x = {1: 'one', 5: 'five', 12: 'telve'};
 str(x)
_pyel21312()") "{1: \"one\", 5: \"five\", 12: \"telve\"}"))
(ert-deftest pyel-str3 nil (equal (pyel-eval "def _pyel21312():
 f = lambda : False
 str(f)
_pyel21312()") "<function <lambda> at 0x18b071>"))
(ert-deftest pyel-str2 nil (equal (pyel-eval "def _pyel21312():
 def __ff_(): pass
 str(__ff_)
_pyel21312()") "<function --ff- at 0x18b071>"))
(ert-deftest pyel-tuple-function16 nil (equal (pyel-eval "def _pyel21312():
 tuple('string')
_pyel21312()") ["s" "t" "r" "i" "n" "g"]))
(ert-deftest pyel-tuple-function15 nil (equal (pyel-eval "def _pyel21312():
 tuple([1,2,'3',(2,)])
_pyel21312()") [1 2 "3" [2]]))
(ert-deftest pyel-tuple-function7 nil (equal (pyel-eval "def _pyel21312():
 tuple({1:'one', 2:'two', 3:'three'})
_pyel21312()") (quote [3 2 1])))
(ert-deftest pyel-tuple-function6 nil (equal (pyel-eval "def _pyel21312():
 tuple((1,2,3))
_pyel21312()") [1 2 3]))
(ert-deftest pyel-list-function14 nil (equal (pyel-eval "def _pyel21312():
 list('string')
_pyel21312()") (quote ("s" "t" "r" "i" "n" "g"))))
(ert-deftest pyel-list-function13 nil (equal (pyel-eval "def _pyel21312():
 list([1,2,'3',(2,)])
_pyel21312()") (quote (1 2 "3" [2]))))
(ert-deftest pyel-list-function7 nil (equal (pyel-eval "def _pyel21312():
 list({1:'one', 2:'two', 3:'three'})
_pyel21312()") (quote (3 2 1))))
(ert-deftest pyel-list-function6 nil (equal (pyel-eval "def _pyel21312():
 list((1,2,3))
_pyel21312()") (quote (1 2 3))))
(ert-deftest pyel-range-function4 nil (equal (pyel-eval "def _pyel21312():
 range(5)
_pyel21312()") (quote (0 1 2 3 4))))
(ert-deftest pyel-range-function3 nil (equal (pyel-eval "def _pyel21312():
 range(2,7)
_pyel21312()") (quote (2 3 4 5 6))))
(ert-deftest pyel-range-function2 nil (equal (pyel-eval "def _pyel21312():
 range(2,20,3)
_pyel21312()") (quote (2 5 8 11 14 17))))
(ert-deftest pyel-range-function1 nil (equal (pyel-eval "def _pyel21312():
 xrange(2,20,3)
_pyel21312()") (quote (2 5 8 11 14 17))))
(ert-deftest pyel-len-function3 nil (equal (pyel-eval "def _pyel21312():
 len('')
_pyel21312()") 0))
(ert-deftest pyel-len-function2 nil (equal (pyel-eval "def _pyel21312():
 len([3,4])
_pyel21312()") 2))
(ert-deftest pyel-len-function1 nil (equal (pyel-eval "def _pyel21312():
 len({1:'one', 2:'two'})
_pyel21312()") 2))
(ert-deftest pyel-conditional-expressions3 nil (equal (pyel-eval "def _pyel21312():
 1 if True else 0
_pyel21312()") 1))
(ert-deftest pyel-conditional-expressions2 nil (equal (pyel-eval "def _pyel21312():
 len((2,3)) if 's' else 3
_pyel21312()") 2))
(ert-deftest pyel-conditional-expressions1 nil (equal (pyel-eval "def _pyel21312():
 2 if '' else 4
_pyel21312()") 4))
(ert-deftest pyel-boolop8 nil (equal (pyel-eval "def _pyel21312():
 False or False
_pyel21312()") nil))
(ert-deftest pyel-boolop7 nil (equal (pyel-eval "def _pyel21312():
 3 and 's'
_pyel21312()") "s"))
(ert-deftest pyel-boolop6 nil (equal (pyel-eval "def _pyel21312():
 1 and 2 and 3
_pyel21312()") 3))
(ert-deftest pyel-boolop5 nil (equal (pyel-eval "def _pyel21312():
 False or []
_pyel21312()") nil))
(ert-deftest pyel-boolop4 nil (equal (pyel-eval "def _pyel21312():
 False or ()
_pyel21312()") []))
(ert-deftest pyel-boolop3 nil (equal (pyel-eval "def _pyel21312():
 '' or 's'
_pyel21312()") "s"))
(ert-deftest pyel-boolop2 nil (equal (pyel-eval "def _pyel21312():
 {} or 3
_pyel21312()") 3))
(ert-deftest pyel-boolop1 nil (equal (pyel-eval "def _pyel21312():
 d and ''
_pyel21312()") nil))
(ert-deftest pyel-dict-comprehensions3 nil (equal (pyel-eval "def _pyel21312():
 str({x:x*x for x in range(5)})
_pyel21312()") "{0: 0, 1: 1, 2: 4, 3: 9, 4: 16}"))
(ert-deftest pyel-list-comprehensions12 nil (equal (pyel-eval "def _pyel21312():
 [x*x for x in range(10)]
_pyel21312()") (quote (0 1 4 9 16 25 36 49 64 81))))
(ert-deftest pyel-list-comprehensions11 nil (equal (pyel-eval "def _pyel21312():
 [x*x for x in range(10) if x > 5]
_pyel21312()") (quote (36 49 64 81))))
(ert-deftest pyel-list-comprehensions10 nil (equal (pyel-eval "def _pyel21312():
 [x*x for x in range(10) if x > 5 if x < 8]
_pyel21312()") (quote (36 49))))
(ert-deftest pyel-list-comprehensions9 nil (equal (pyel-eval "def _pyel21312():
 [(x, y) for x in [1,2,3] for y in [3,1,4] if x != y]
_pyel21312()") (quote ([1 3] [1 4] [2 3] [2 1] [2 4] [3 1] [3 4]))))
(ert-deftest pyel-list-comprehensions6 nil (equal (pyel-eval "def _pyel21312():
 [x for x in range(30) if x %2 == 0]
_pyel21312()") (quote (0 2 4 6 8 10 12 14 16 18 20 22 24 26 28))))
(ert-deftest pyel-list-comprehensions5 nil (equal (pyel-eval "def _pyel21312():
 [[x,y] for x in range(5) for y in range(3)]
_pyel21312()") (quote ((0 0) (0 1) (0 2) (1 0) (1 1) (1 2) (2 0) (2 1) (2 2) (3 0) (3 1) (3 2) (4 0) (4 1) (4 2)))))
(ert-deftest pyel-list-comprehensions4 nil (equal (pyel-eval "def _pyel21312():
 [[x,y,z] for x in range(3) for y in range(3) for z in range(2)]
_pyel21312()") (quote ((0 0 0) (0 0 1) (0 1 0) (0 1 1) (0 2 0) (0 2 1) (1 0 0) (1 0 1) (1 1 0) (1 1 1) (1 2 0) (1 2 1) (2 0 0) (2 0 1) (2 1 0) (2 1 1) (2 2 0) (2 2 1)))))
(ert-deftest pyel-list-comprehensions3 nil (equal (pyel-eval "def _pyel21312():
 [[x,y,z] for x in range(5) if x == 3 for y in range(3) for z in range(2)]
_pyel21312()") (quote ((3 0 0) (3 0 1) (3 1 0) (3 1 1) (3 2 0) (3 2 1)))))
(ert-deftest pyel-list-comprehensions2 nil (equal (pyel-eval "def _pyel21312():
 [[x,y,z] for x in range(5) for y in range(3) for z in range(2) if (x+y+z)%2 == 0]
_pyel21312()") (quote ((0 0 0) (0 1 1) (0 2 0) (1 0 1) (1 1 0) (1 2 1) (2 0 0) (2 1 1) (2 2 0) (3 0 1) (3 1 0) (3 2 1) (4 0 0) (4 1 1) (4 2 0)))))
(ert-deftest pyel-list-comprehensions1 nil (equal (pyel-eval "def _pyel21312():
 [x+y for x in range(7) for y in range(9) if x%2==0 if y > 6]
_pyel21312()") (quote (7 8 9 10 11 12 13 14))))
(ert-deftest pyel-not-in10 nil (equal (pyel-eval "def _pyel21312():
 3 not in range(3)
_pyel21312()") nil))
(ert-deftest pyel-not-in9 nil (equal (pyel-eval "def _pyel21312():
 's' not in range(3)
_pyel21312()") t))
(ert-deftest pyel-not-in8 nil (equal (pyel-eval "def _pyel21312():
 's' not in [1,2,'s',3]
_pyel21312()") nil))
(ert-deftest pyel-not-in7 nil (equal (pyel-eval "def _pyel21312():
 1 not in [3,1,2]
_pyel21312()") nil))
(ert-deftest pyel-not-in6 nil (equal (pyel-eval "def _pyel21312():
 's' not in (4,2,'s','x')
_pyel21312()") nil))
(ert-deftest pyel-not-in5 nil (equal (pyel-eval "def _pyel21312():
 's' not in (4,2,'ss','x')
_pyel21312()") t))
(ert-deftest pyel-not-in4 nil (equal (pyel-eval "def _pyel21312():
 [1,2,3][1] in [1,3,[3,2,1]][2]
_pyel21312()") nil))
(ert-deftest pyel-not-in3 nil (equal (pyel-eval "def _pyel21312():
 's' not in 'string'
_pyel21312()") nil))
(ert-deftest pyel-not-in2 nil (equal (pyel-eval "def _pyel21312():
 'q' not in 'string'
_pyel21312()") t))
(ert-deftest pyel-not-in1 nil (equal (pyel-eval "def _pyel21312():
 'tri' not in 'string'
_pyel21312()") nil))
(ert-deftest pyel-in22 nil (equal (pyel-eval "def _pyel21312():
 3 in range(3)
_pyel21312()") t))
(ert-deftest pyel-in21 nil (equal (pyel-eval "def _pyel21312():
 's' in range(3)
_pyel21312()") nil))
(ert-deftest pyel-in20 nil (equal (pyel-eval "def _pyel21312():
 's' in [1,2,'s',3]
_pyel21312()") t))
(ert-deftest pyel-in19 nil (equal (pyel-eval "def _pyel21312():
 1 in [3,1,2]
_pyel21312()") t))
(ert-deftest pyel-in18 nil (equal (pyel-eval "def _pyel21312():
 's' in (4,2,'s','x')
_pyel21312()") t))
(ert-deftest pyel-in17 nil (equal (pyel-eval "def _pyel21312():
 's' in (4,2,'ss','x')
_pyel21312()") nil))
(ert-deftest pyel-in16 nil (equal (pyel-eval "def _pyel21312():
 [1,2,3][1] in [1,3,[3,2,1]][2]
_pyel21312()") t))
(ert-deftest pyel-in15 nil (equal (pyel-eval "def _pyel21312():
 's' in 'string'
_pyel21312()") t))
(ert-deftest pyel-in14 nil (equal (pyel-eval "def _pyel21312():
 'q' in 'string'
_pyel21312()") nil))
(ert-deftest pyel-in13 nil (equal (pyel-eval "def _pyel21312():
 'tri' in 'string'
_pyel21312()") t))
(ert-deftest pyel-usub2 nil (equal (pyel-eval "def _pyel21312():
 -1
_pyel21312()") -1))
(ert-deftest pyel-not6 nil (equal (pyel-eval "def _pyel21312():
 not 's'
_pyel21312()") nil))
(ert-deftest pyel-not5 nil (equal (pyel-eval "def _pyel21312():
 not ''
_pyel21312()") t))
(ert-deftest pyel-not4 nil (equal (pyel-eval "def _pyel21312():
 not []
_pyel21312()") t))
(ert-deftest pyel-not3 nil (equal (pyel-eval "def _pyel21312():
 not ()
_pyel21312()") t))
(ert-deftest pyel-not2 nil (equal (pyel-eval "def _pyel21312():
 not {}
_pyel21312()") t))
(ert-deftest pyel-not1 nil (equal (pyel-eval "def _pyel21312():
 not (2,)
_pyel21312()") nil))
(ert-deftest pyel-lambda1 nil (equal (pyel-eval "def _pyel21312():
 reduce(lambda a,b:a+b, range(2, 9))
_pyel21312()") 35))
(ert-deftest pyel-subscript7 nil (equal (pyel-eval "def _pyel21312():
 x.start
_pyel21312()") "2"))
(ert-deftest pyel-subscript6 nil (equal (pyel-eval "def _pyel21312():
 x.stop
_pyel21312()") "3"))
(ert-deftest pyel-subscript5 nil (equal (pyel-eval "def _pyel21312():
 x.value
_pyel21312()") "[1,2,3]"))
(ert-deftest pyel-subscript2 nil (equal (pyel-eval "def _pyel21312():
 [2,3,3][2]
_pyel21312()") 3))
(ert-deftest pyel-subscript1 nil (equal (pyel-eval "def _pyel21312():
 [1,2,(3,2,8)][2][2]
_pyel21312()") 8))
(ert-deftest pyel-mod-op2 nil (equal (pyel-eval "def _pyel21312():
 5 % 3
_pyel21312()") 2))
(ert-deftest pyel-bin-ops6 nil (equal (pyel-eval "def _pyel21312():
 3 & 5
_pyel21312()") 0))
(ert-deftest pyel-bin-ops5 nil (equal (pyel-eval "def _pyel21312():
 3 | 5
_pyel21312()") 7))
(ert-deftest pyel-bin-ops4 nil (equal (pyel-eval "def _pyel21312():
 3 ^ 5
_pyel21312()") 6))
(ert-deftest pyel-div-op4 nil (equal (pyel-eval "def _pyel21312():
 9 / 4
_pyel21312()") 2.25))
(ert-deftest pyel-div-op3 nil (equal (pyel-eval "def _pyel21312():
 9 // 4
_pyel21312()") 2))
(ert-deftest pyel-pow-op2 nil (equal (pyel-eval "def _pyel21312():
 3 ** 4
_pyel21312()") 81))
(ert-deftest pyel-mult-op6 nil (equal (pyel-eval "def _pyel21312():
 3 * 4
_pyel21312()") 12))
(ert-deftest pyel-mult-op5 nil (equal (pyel-eval "def _pyel21312():
 'a' * 3
_pyel21312()") "aaa"))
(ert-deftest pyel-mult-op4 nil (equal (pyel-eval "def _pyel21312():
 4*'b'
_pyel21312()") "bbbb"))
(ert-deftest pyel-sub-op2 nil (equal (pyel-eval "def _pyel21312():
 3 - 2
_pyel21312()") 1))
(ert-deftest pyel-add-op7 nil (equal (pyel-eval "def _pyel21312():
 1 + 2
_pyel21312()") 3))
(ert-deftest pyel-add-op6 nil (equal (pyel-eval "def _pyel21312():
 'a' + 'b'
_pyel21312()") "ab"))
(ert-deftest pyel-compare25 nil (equal (pyel-eval "def _pyel21312():
 1 == 1
_pyel21312()") t))
(ert-deftest pyel-compare24 nil (equal (pyel-eval "def _pyel21312():
 2 == 3
_pyel21312()") nil))
(ert-deftest pyel-compare22 nil (equal (pyel-eval "def _pyel21312():
 [1,3] == [1,3]
_pyel21312()") t))
(ert-deftest pyel-compare21 nil (equal (pyel-eval "def _pyel21312():
 [1,3] == [1,3,2]
_pyel21312()") nil))
(ert-deftest pyel-compare20 nil (equal (pyel-eval "def _pyel21312():
 (1,2) == (1,2)
_pyel21312()") t))
(ert-deftest pyel-compare19 nil (equal (pyel-eval "def _pyel21312():
 2 > 1
_pyel21312()") t))
(ert-deftest pyel-compare18 nil (equal (pyel-eval "def _pyel21312():
 'a' > 'b'
_pyel21312()") nil))
(ert-deftest pyel-compare17 nil (equal (pyel-eval "def _pyel21312():
 'z' > 'a'
_pyel21312()") t))
(ert-deftest pyel-compare16 nil (equal (pyel-eval "def _pyel21312():
 ['a'][0] >= ['z','a'][1]
_pyel21312()") t))
(ert-deftest pyel-compare15 nil (equal (pyel-eval "def _pyel21312():
 'aaax' > 'aaaa'
_pyel21312()") t))
(ert-deftest pyel-compare14 nil (equal (pyel-eval "def _pyel21312():
 'aaaa' > 'aaaa'
_pyel21312()") nil))
(ert-deftest pyel-compare13 nil (equal (pyel-eval "def _pyel21312():
 'aaaa' >= 'aaaa'
_pyel21312()") t))
(ert-deftest pyel-compare12 nil (equal (pyel-eval "def _pyel21312():
 1 != 1
_pyel21312()") nil))
(ert-deftest pyel-compare11 nil (equal (pyel-eval "def _pyel21312():
 1 != 2
_pyel21312()") t))
(ert-deftest pyel-compare9 nil (equal (pyel-eval "def _pyel21312():
 ['a'][0] != ['z','a'][1]
_pyel21312()") nil))
(ert-deftest pyel-compare8 nil (equal (pyel-eval "def _pyel21312():
 (3,4) == [3,4]
_pyel21312()") nil))
(ert-deftest pyel-compare7 nil (equal (pyel-eval "def _pyel21312():
 [9 == 1]
_pyel21312()") (quote (nil))))
(ert-deftest pyel-compare6 nil (equal (pyel-eval "def _pyel21312():
 ((1 == 1),)
_pyel21312()") [t]))
(ert-deftest pyel-compare5 nil (equal (pyel-eval "def _pyel21312():
 1<3<8
_pyel21312()") t))
(ert-deftest pyel-compare3 nil (equal (pyel-eval "def _pyel21312():
 [1] is [1]
_pyel21312()") nil))
(ert-deftest pyel-compare1 nil (equal (pyel-eval "def _pyel21312():
 1 is 1
_pyel21312()") t))
(ert-deftest pyel-string3 nil (equal (pyel-eval "def _pyel21312():
 'a'
_pyel21312()") "a"))
(ert-deftest pyel-string1 nil (equal (pyel-eval "def _pyel21312():
 ['a']
_pyel21312()") (quote ("a"))))
(ert-deftest pyel-Tuple5 nil (equal (pyel-eval "def _pyel21312():
 ()
_pyel21312()") []))
(ert-deftest pyel-list5 nil (equal (pyel-eval "def _pyel21312():
 []
_pyel21312()") nil))
(ert-deftest pyel-list4 nil (equal (pyel-eval "def _pyel21312():
 ['a',1,2]
_pyel21312()") (quote ("a" 1 2))))
(ert-deftest pyel-list1 nil (equal (pyel-eval "def _pyel21312():
 [[[1]]]
_pyel21312()") (quote (((1))))))
(ert-deftest pyel-num3 nil (equal (pyel-eval "def _pyel21312():
 3
_pyel21312()") 3))
(ert-deftest pyel-num2 nil (equal (pyel-eval "def _pyel21312():
 4.23
_pyel21312()") 4.23))
(ert-deftest pyel-num1 nil (equal (pyel-eval "def _pyel21312():
 3e2
_pyel21312()") 300.0))
(ert-deftest pyel-test-assign-1 nil (equal (pyel-eval "pyel_test_assign_1(1)") 9))
(ert-deftest pyel-test-assign-2 nil (equal (pyel-eval "pyel_test_assign_1(2)") 9))
(ert-deftest pyel-test-assign-3 nil (equal (pyel-eval "pyel_test_assign_1(3)") 9))
(ert-deftest pyel-test-assign-4 nil (equal (pyel-eval "pyel_test_assign_1(4)") 9))
(ert-deftest pyel-test-assign-5 nil (equal (pyel-eval "pyel_test_assign_1(5)") 9))
(ert-deftest pyel-test-assign-6 nil (equal (pyel-eval "pyel_test_assign_1(6)") 9))
(ert-deftest pyel-test-assign-7 nil (equal (pyel-eval "pyel_test_assign_1(7)") 9))
(ert-deftest pyel-test-assign-8 nil (equal (pyel-eval "pyel_test_assign_17()") [1 2 3]))
(ert-deftest pyel-test-assign-9 nil (equal (pyel-eval "pyel_test_assign_18(1)") 11))
(ert-deftest pyel-test-assign-10 nil (equal (pyel-eval "pyel_test_assign_18(2)") 22))
(ert-deftest pyel-test-assign-11 nil (equal (pyel-eval "pyel_test_assign_18(3)") 33))
(ert-deftest pyel-test-assign-12 nil (equal (pyel-eval "pyel_test_assign_19(1)") 1))
(ert-deftest pyel-test-assign-13 nil (equal (pyel-eval "pyel_test_assign_19(2)") 2))
(ert-deftest pyel-test-assign-14 nil (equal (pyel-eval "pyel_test_assign_19(3)") 3))
(ert-deftest pyel-test-assign-15 nil (equal (pyel-eval "pyel_test_assign_19(4)") 3))
(ert-deftest pyel-test-assign-16 nil (equal (pyel-eval "pyel_test_assign_20(1)") 2))
(ert-deftest pyel-test-assign-17 nil (equal (pyel-eval "pyel_test_assign_20(2)") 1))
(ert-deftest pyel-test-assign-18 nil (equal (pyel-eval "pyel_test_assign_21(1)") 3))
(ert-deftest pyel-test-assign-19 nil (equal (pyel-eval "pyel_test_assign_21(2)") 1.1))
(ert-deftest pyel-test-assign-20 nil (equal (pyel-eval "pyel_test_assign_21(3)") 1))
(ert-deftest pyel-test-assign-21 nil (equal (pyel-eval "pyel_test_assign_22(1)") 1))
(ert-deftest pyel-test-assign-22 nil (equal (pyel-eval "pyel_test_assign_22(2)") 2))
(ert-deftest pyel-test-assign-23 nil (equal (pyel-eval "pyel_test_assign_32()") 1))
(ert-deftest pyel-test-assign-24 nil (equal (pyel-eval "pyel_test_assign_33()") 1))
(ert-deftest pyel-test-attribute-1 nil (equal (pyel-eval "pyel_test_attribute_34(1)") 3))
(ert-deftest pyel-test-attribute-2 nil (equal (pyel-eval "pyel_test_attribute_34(2)") 3))
(ert-deftest pyel-test-attribute-3 nil (equal (pyel-eval "pyel_test_attribute_34(3)") 3))
(ert-deftest pyel-test-attribute-4 nil (equal (pyel-eval "pyel_test_attribute_34(4)") 3))
(ert-deftest pyel-test-attribute-5 nil (equal (pyel-eval "pyel_test_attribute_34(5)") 3))
(ert-deftest pyel-test-attribute-6 nil (equal (pyel-eval "pyel_test_attribute_34(6)") 2))
(ert-deftest pyel-test-attribute-7 nil (equal (pyel-eval "pyel_test_attribute_34(7)") 2))
(ert-deftest pyel-test-attribute-8 nil (equal (pyel-eval "pyel_test_attribute_34(8)") 4))
(ert-deftest pyel-test-attribute-9 nil (equal (pyel-eval "pyel_test_attribute_34(9)") 4))
(ert-deftest pyel-test-list-2 nil (equal (pyel-eval "pyel_test_list_35(1)") (quote (1 2 "b"))))
(ert-deftest pyel-test-list-3 nil (equal (pyel-eval "pyel_test_list_35(2)") (quote (1 (1 "3" (1 2 "b") nil 3)))))
(ert-deftest pyel-test-dict-1 nil (equal (pyel-eval "pyel_test_dict_36(1)") "{\"a\": 2, \"b\": 4}"))
(ert-deftest pyel-test-dict-2 nil (equal (pyel-eval "pyel_test_dict_36(2)") "{2: {\"a\": 2, \"b\": 4}, \"b\": 4}"))
(ert-deftest pyel-test-dict-3 nil (equal (pyel-eval "pyel_test_dict_36(3)") "{\"a\": 2, \"b\": 4, \"c\": {\"d\": 1, \"e\": 2, \"f\": {\"g\": 3}}}"))
(ert-deftest pyel-test-dict-4 nil (equal (pyel-eval "pyel_test_dict_36(4)") "{}"))
(ert-deftest pyel-test-dict-5 nil (equal (pyel-eval "pyel_test_dict_36(5)") "{\"d\": 1, \"e\": 2, \"f\": {\"g\": 3}}"))
(ert-deftest pyel-test-dict-6 nil (equal (pyel-eval "pyel_test_dict_36(6)") "{\"g\": 3}"))
(ert-deftest pyel-test-dict-7 nil (equal (pyel-eval "pyel_test_dict_36(7)") 3))
(ert-deftest pyel-test-Tuple-1 nil (equal (pyel-eval "pyel_test_Tuple_37(1)") [1 4]))
(ert-deftest pyel-test-Tuple-2 nil (equal (pyel-eval "pyel_test_Tuple_37(2)") [1 [3 [4 4]]]))
(ert-deftest pyel-test-Tuple-3 nil (equal (pyel-eval "pyel_test_Tuple_37(3)") (quote a)))
(ert-deftest pyel-test-Tuple-4 nil (equal (pyel-eval "pyel_test_Tuple_37(4)") [1]))
(ert-deftest pyel-test-string-2 nil (equal (pyel-eval "pyel_test_string_38()") "a"))
(ert-deftest pyel-test-compare-2 nil (equal (pyel-eval "pyel_test_compare_39()") t))
(ert-deftest pyel-test-compare-4 nil (equal (pyel-eval "pyel_test_compare_40()") t))
(ert-deftest pyel-test-compare-10 nil (equal (pyel-eval "pyel_test_compare_41()") t))
(ert-deftest pyel-test-compare-23 nil (equal (pyel-eval "pyel_test_compare_42()") nil))
(ert-deftest pyel-test-if-1 nil (equal (pyel-eval "pyel_test_if_43()") 5))
(ert-deftest pyel-test-if-2 nil (equal (pyel-eval "pyel_test_if_44()") 234))
(ert-deftest pyel-test-if-3 nil (equal (pyel-eval "pyel_test_if_45(1)") 1))
(ert-deftest pyel-test-if-4 nil (equal (pyel-eval "pyel_test_if_45(2)") 1))
(ert-deftest pyel-test-if-5 nil (equal (pyel-eval "pyel_test_if_45(3)") 2))
(ert-deftest pyel-test-if-6 nil (equal (pyel-eval "pyel_test_if_45(4)") 1.1))
(ert-deftest pyel-test-if-7 nil (equal (pyel-eval "pyel_test_if_45(5)") 12))
(ert-deftest pyel-test-if-8 nil (equal (pyel-eval "pyel_test_if_46()") 5))
(ert-deftest pyel-test-if-9 nil (equal (pyel-eval "pyel_test_if_47()") 4))
(ert-deftest pyel-test-if-10 nil (equal (pyel-eval "pyel_test_if_48()") 1))
(ert-deftest pyel-test-call-1 nil (equal (pyel-eval "pyel_test_call_49()") 4))
(ert-deftest pyel-test-call-2 nil (equal (pyel-eval "pyel_test_call_50()") 7))
(ert-deftest pyel-test-call-3 nil (equal (pyel-eval "pyel_test_call_51()") 3))
(ert-deftest pyel-test-call-4 nil (equal (pyel-eval "pyel_test_call_52(1)") 4))
(ert-deftest pyel-test-call-5 nil (equal (pyel-eval "pyel_test_call_52(2)") 4))
(ert-deftest pyel-test-while-1 nil (equal (pyel-eval "pyel_test_while_53()") 5))
(ert-deftest pyel-test-while-2 nil (equal (pyel-eval "pyel_test_while_54()") 3))
(ert-deftest pyel-test-while-3 nil (equal (pyel-eval "pyel_test_while_55(1)") 1))
(ert-deftest pyel-test-while-4 nil (equal (pyel-eval "pyel_test_while_55(2)") 2))
(ert-deftest pyel-test-while-5 nil (equal (pyel-eval "pyel_test_while_56()") 45))
(ert-deftest pyel-test-def-1 nil (equal (pyel-eval "pyel_test_def_57(1)") t))
(ert-deftest pyel-test-def-2 nil (equal (pyel-eval "pyel_test_def_57(2)") nil))
(ert-deftest pyel-test-def-3 nil (equal (pyel-eval "pyel_test_def_58(1)") 0))
(ert-deftest pyel-test-def-4 nil (equal (pyel-eval "pyel_test_def_58(2)") 1))
(ert-deftest pyel-test-def-5 nil (equal (pyel-eval "pyel_test_def_58(3)") 6))
(ert-deftest pyel-test-def-6 nil (equal (pyel-eval "pyel_test_def_58(4)") 2))
(ert-deftest pyel-test-def-7 nil (equal (pyel-eval "pyel_test_def_58(5)") 1.1))
(ert-deftest pyel-test-def-8 nil (equal (pyel-eval "pyel_test_def_58(6)") 22))
(ert-deftest pyel-test-def-9 nil (equal (pyel-eval "pyel_test_def_58(7)") [1 (\, 3) (\, 5) (\, 6) (\, 8)]))
(ert-deftest pyel-test-function_arguments-1 nil (equal (pyel-eval "pyel_test_function_arguments_59(1)") "[1, 2, 3, 999, 888, 777, [1, 2, 3, 43, 4, 5], 3, 32, 43, {}]"))
(ert-deftest pyel-test-function_arguments-2 nil (equal (pyel-eval "pyel_test_function_arguments_59(2)") "[1, 2, 3, 999, 888, 777, [1, 2, 3, 43, 4, 5], 1, 32, 43, {}]"))
(ert-deftest pyel-test-function_arguments-3 nil (equal (pyel-eval "pyel_test_function_arguments_60(1)") (quote (1 2))))
(ert-deftest pyel-test-function_arguments-4 nil (equal (pyel-eval "pyel_test_function_arguments_60(2)") (quote ("s" 4))))
(ert-deftest pyel-test-function_arguments-5 nil (equal (pyel-eval "pyel_test_function_arguments_61(1)") "[\"x\", [1, 2, 3], 1, nil, {-yy: 3.3, -xx: 2.2, -d: 1.1}]"))
(ert-deftest pyel-test-function_arguments-6 nil (equal (pyel-eval "pyel_test_function_arguments_61(2)") "[\"x\", nil, 1, 1.1, {}]"))
(ert-deftest pyel-test-function_arguments-7 nil (equal (pyel-eval "pyel_test_function_arguments_61(3)") "[\"x\", nil, 1, nil, {}]"))
(ert-deftest pyel-test-function_arguments-8 nil (equal (pyel-eval "pyel_test_function_arguments_61(4)") "[\"x\", (), 2, 1, {e: 4}]"))
(ert-deftest pyel-test-function_arguments-9 nil (equal (pyel-eval "pyel_test_function_arguments_61(5)") "[1, (2, 3, 4, 5, 6), 1, nil, {}]"))
(ert-deftest pyel-test-function_arguments-10 nil (equal (pyel-eval "pyel_test_function_arguments_62(1)") "[1, 2, 1, \"two\", [], {}]"))
(ert-deftest pyel-test-function_arguments-11 nil (equal (pyel-eval "pyel_test_function_arguments_62(2)") "[1, 2, 3, \"two\", [], {}]"))
(ert-deftest pyel-test-function_arguments-12 nil (equal (pyel-eval "pyel_test_function_arguments_62(3)") "[1, 2, 3, 4, [], {}]"))
(ert-deftest pyel-test-function_arguments-13 nil (equal (pyel-eval "pyel_test_function_arguments_62(4)") "[1, 2, 3, 4, [5], {}]"))
(ert-deftest pyel-test-function_arguments-14 nil (equal (pyel-eval "pyel_test_function_arguments_62(5)") "[1, 2, 3, 4, [5, 6], {}]"))
(ert-deftest pyel-test-function_arguments-15 nil (equal (pyel-eval "pyel_test_function_arguments_62(6)") "[1, 2, 3, 4, [5, 6], {x: \"s\"}]"))
(ert-deftest pyel-test-function_arguments-16 nil (equal (pyel-eval "pyel_test_function_arguments_62(7)") "[1, 2, 3, 4, [5, 6], {y: 23, x: \"s\"}]"))
(ert-deftest pyel-test-function_arguments-17 nil (equal (pyel-eval "pyel_test_function_arguments_62(8)") "[\"n\", 324, 1, \"two\", [], {x: \"s\"}]"))
(ert-deftest pyel-test-function_arguments-18 nil (equal (pyel-eval "pyel_test_function_arguments_62(9)") "[\"n\", 324, 1, 2, [], {x: \"s\"}]"))
(ert-deftest pyel-test-add_op-1 nil (equal (pyel-eval "pyel_test_add_op_63()") 14))
(ert-deftest pyel-test-add_op-2 nil (equal (pyel-eval "pyel_test_add_op_64(1)") 10))
(ert-deftest pyel-test-add_op-3 nil (equal (pyel-eval "pyel_test_add_op_64(2)") "asddf"))
(ert-deftest pyel-test-add_op-4 nil (equal (pyel-eval "pyel_test_add_op_64(3)") (quote (1 3 "a"))))
(ert-deftest pyel-test-add_op-5 nil (equal (pyel-eval "pyel_test_add_op_64(4)") [1 2 3]))
(ert-deftest pyel-test-sub_op-1 nil (equal (pyel-eval "pyel_test_sub_op_65()") 2))
(ert-deftest pyel-test-mult_op-1 nil (equal (pyel-eval "pyel_test_mult_op_66(1)") 8))
(ert-deftest pyel-test-mult_op-2 nil (equal (pyel-eval "pyel_test_mult_op_66(2)") "ss"))
(ert-deftest pyel-test-mult_op-3 nil (equal (pyel-eval "pyel_test_mult_op_66(3)") "ss"))
(ert-deftest pyel-test-pow_op-1 nil (equal (pyel-eval "pyel_test_pow_op_67()") 16))
(ert-deftest pyel-test-div_op-1 nil (equal (pyel-eval "pyel_test_div_op_68(1)") 2.25))
(ert-deftest pyel-test-div_op-2 nil (equal (pyel-eval "pyel_test_div_op_68(2)") 2))
(ert-deftest pyel-test-bin_ops-1 nil (equal (pyel-eval "pyel_test_bin_ops_69(1)") 0))
(ert-deftest pyel-test-bin_ops-2 nil (equal (pyel-eval "pyel_test_bin_ops_69(2)") 7))
(ert-deftest pyel-test-bin_ops-3 nil (equal (pyel-eval "pyel_test_bin_ops_69(3)") 6))
(ert-deftest pyel-test-mod_op-1 nil (equal (pyel-eval "pyel_test_mod_op_70()") 2))
(ert-deftest pyel-test-slice_object-1 nil (equal (pyel-eval "pyel_test_slice_object_71(1)") 0))
(ert-deftest pyel-test-slice_object-2 nil (equal (pyel-eval "pyel_test_slice_object_71(2)") 5))
(ert-deftest pyel-test-slice_object-3 nil (equal (pyel-eval "pyel_test_slice_object_71(3)") nil))
(ert-deftest pyel-test-slice_object-4 nil (equal (pyel-eval "pyel_test_slice_object_71(4)") 1))
(ert-deftest pyel-test-slice_object-5 nil (equal (pyel-eval "pyel_test_slice_object_71(5)") 5))
(ert-deftest pyel-test-slice_object-6 nil (equal (pyel-eval "pyel_test_slice_object_71(6)") nil))
(ert-deftest pyel-test-slice_object-7 nil (equal (pyel-eval "pyel_test_slice_object_71(7)") 2))
(ert-deftest pyel-test-slice_object-8 nil (equal (pyel-eval "pyel_test_slice_object_71(8)") 6))
(ert-deftest pyel-test-slice_object-9 nil (equal (pyel-eval "pyel_test_slice_object_71(9)") 7))
(ert-deftest pyel-test-subscript-3 nil (equal (pyel-eval "pyel_test_subscript_72()") (quote (1 2 7 4 5 6))))
(ert-deftest pyel-test-subscript-4 nil (equal (pyel-eval "pyel_test_subscript_73()") (quote (1 2 6 4 5 6))))
(ert-deftest pyel-test-subscript-8 nil (equal (pyel-eval "pyel_test_subscript_74(1)") "2"))
(ert-deftest pyel-test-subscript-9 nil (equal (pyel-eval "pyel_test_subscript_74(2)") "3"))
(ert-deftest pyel-test-subscript-10 nil (equal (pyel-eval "pyel_test_subscript_74(3)") "[1,2,3]"))
(ert-deftest pyel-test-subscript-11 nil (equal (pyel-eval "pyel_test_subscript_75()") "'a42336'"))
(ert-deftest pyel-test-subscript-12 nil (equal (pyel-eval "pyel_test_subscript_76()") "a42f56"))
(ert-deftest pyel-test-subscript-13 nil (equal (pyel-eval "pyel_test_subscript_77()") "154f56"))
(ert-deftest pyel-test-subscript-14 nil (equal (pyel-eval "pyel_test_subscript_78()") [1 2 3 3 3 6]))
(ert-deftest pyel-test-subscript-15 nil (equal (pyel-eval "pyel_test_subscript_79()") ["a" 4 2.2 4 5 6]))
(ert-deftest pyel-test-subscript-16 nil (equal (pyel-eval "pyel_test_subscript_80()") [1 5 4 "f" 5 6]))
(ert-deftest pyel-test-subscript-17 nil (equal (pyel-eval "pyel_test_subscript_81(1)") (quote (1 5 4 "f" 5 6))))
(ert-deftest pyel-test-subscript-18 nil (equal (pyel-eval "pyel_test_subscript_81(2)") (quote ("a" 4 2.2 4 5 6))))
(ert-deftest pyel-test-subscript-19 nil (equal (pyel-eval "pyel_test_subscript_81(3)") (quote (1 2 3 3 3 6))))
(ert-deftest pyel-test-subscript-20 nil (equal (pyel-eval "pyel_test_subscript_82(1)") 3))
(ert-deftest pyel-test-subscript-21 nil (equal (pyel-eval "pyel_test_subscript_82(2)") 5))
(ert-deftest pyel-test-subscript-22 nil (equal (pyel-eval "pyel_test_subscript_83(1)") 5))
(ert-deftest pyel-test-subscript-23 nil (equal (pyel-eval "pyel_test_subscript_83(2)") "str"))
(ert-deftest pyel-test-subscript-24 nil (equal (pyel-eval "pyel_test_subscript_84(1)") 5))
(ert-deftest pyel-test-subscript-25 nil (equal (pyel-eval "pyel_test_subscript_84(2)") "str"))
(ert-deftest pyel-test-subscript-26 nil (equal (pyel-eval "pyel_test_subscript_85(1)") "3"))
(ert-deftest pyel-test-subscript-27 nil (equal (pyel-eval "pyel_test_subscript_85(2)") "12"))
(ert-deftest pyel-test-subscript-28 nil (equal (pyel-eval "pyel_test_subscript_86(1)") "123"))
(ert-deftest pyel-test-subscript-29 nil (equal (pyel-eval "pyel_test_subscript_86(2)") "0123"))
(ert-deftest pyel-test-subscript-30 nil (equal (pyel-eval "pyel_test_subscript_86(3)") "2345678"))
(ert-deftest pyel-test-subscript-31 nil (equal (pyel-eval "pyel_test_subscript_86(4)") "012345678"))
(ert-deftest pyel-test-subscript-32 nil (equal (pyel-eval "pyel_test_subscript_87(1)") "[2,3,4]"))
(ert-deftest pyel-test-subscript-33 nil (equal (pyel-eval "pyel_test_subscript_87(2)") "[1,2,3,4]"))
(ert-deftest pyel-test-subscript-34 nil (equal (pyel-eval "pyel_test_subscript_87(3)") "[3,4,5]"))
(ert-deftest pyel-test-subscript-35 nil (equal (pyel-eval "pyel_test_subscript_87(4)") "[1,2,3,4,5]"))
(ert-deftest pyel-test-subscript-36 nil (equal (pyel-eval "pyel_test_subscript_88(1)") "(2,3,4)"))
(ert-deftest pyel-test-subscript-37 nil (equal (pyel-eval "pyel_test_subscript_88(2)") "(1,2,3,4)"))
(ert-deftest pyel-test-subscript-38 nil (equal (pyel-eval "pyel_test_subscript_88(3)") "(3,4,5)"))
(ert-deftest pyel-test-subscript-39 nil (equal (pyel-eval "pyel_test_subscript_88(4)") "(1,2,3,4,5)"))
(ert-deftest pyel-test-subscript-40 nil (equal (pyel-eval "pyel_test_subscript_89()") "5"))
(ert-deftest pyel-test-subscript-41 nil (equal (pyel-eval "pyel_test_subscript_90()") "2"))
(ert-deftest pyel-test-subscript-42 nil (equal (pyel-eval "pyel_test_subscript_91()") "2"))
(ert-deftest pyel-test-subscript-43 nil (equal (pyel-eval "pyel_test_subscript_92()") "X"))
(ert-deftest pyel-test-objects-1 nil (equal (pyel-eval "pyel_test_objects_93(1)") 5))
(ert-deftest pyel-test-objects-2 nil (equal (pyel-eval "pyel_test_objects_93(2)") 6))
(ert-deftest pyel-test-objects-3 nil (equal (pyel-eval "pyel_test_objects_94(1)") "tclass"))
(ert-deftest pyel-test-objects-4 nil (equal (pyel-eval "pyel_test_objects_94(2)") (lambda (self) (getattr self a))))
(ert-deftest pyel-test-objects-5 nil (equal (pyel-eval "pyel_test_objects_94(3)") (lambda (self n) (setattr self a n))))
(ert-deftest pyel-test-objects-6 nil (equal (pyel-eval "pyel_test_objects_94(4)") 12))
(ert-deftest pyel-test-objects-7 nil (equal (pyel-eval "pyel_test_objects_94(5)") "hi"))
(ert-deftest pyel-test-objects-8 nil (equal (pyel-eval "pyel_test_objects_94(6)") 23))
(ert-deftest pyel-test-objects-9 nil (equal (pyel-eval "pyel_test_objects_94(7)") 19))
(ert-deftest pyel-test-objects-10 nil (equal (pyel-eval "pyel_test_objects_94(8)") (lambda (self) nil (pyel-+ (getattr self cvar) 5))))
(ert-deftest pyel-test-objects-11 nil (equal (pyel-eval "pyel_test_objects_94(9)") "<class 'object'>"))
(ert-deftest pyel-test-objects-12 nil (equal (pyel-eval "pyel_test_objects_94(10)") t))
(ert-deftest pyel-test-objects-13 nil (equal (pyel-eval "pyel_test_objects_94(11)") "tclass"))
(ert-deftest pyel-test-objects-14 nil (equal (pyel-eval "pyel_test_objects_94(12)") 14))
(ert-deftest pyel-test-objects-15 nil (equal (pyel-eval "pyel_test_objects_94(13)") 2))
(ert-deftest pyel-test-objects-16 nil (equal (pyel-eval "pyel_test_objects_94(14)") [4 12]))
(ert-deftest pyel-test-objects-17 nil (equal (pyel-eval "pyel_test_objects_94(15)") 10))
(ert-deftest pyel-test-objects-18 nil (equal (pyel-eval "pyel_test_objects_94(16)") 8))
(ert-deftest pyel-test-special_method_lookup-1 nil (equal (pyel-eval "pyel_test_special_method_lookup_95(1)") 16))
(ert-deftest pyel-test-special_method_lookup-2 nil (equal (pyel-eval "pyel_test_special_method_lookup_95(2)") "<bound method adder.__call__ of adder object at 0x18b071>"))
(ert-deftest pyel-test-special_method_lookup-3 nil (equal (pyel-eval "pyel_test_special_method_lookup_95(3)") (lambda nil nil "hi")))
(ert-deftest pyel-test-for_loop-1 nil (equal (pyel-eval "pyel_test_for_loop_102()") (quote ("5" "4" "3" "2" "1"))))
(ert-deftest pyel-test-for_loop-2 nil (equal (pyel-eval "pyel_test_for_loop_103(1)") (quote ("q" "w" "e" "r" "t" "y"))))
(ert-deftest pyel-test-for_loop-3 nil (equal (pyel-eval "pyel_test_for_loop_103(2)") 1))
(ert-deftest pyel-test-for_loop-4 nil (equal (pyel-eval "pyel_test_for_loop_104()") (quote ("s" "t" "r" "i" "n" "g"))))
(ert-deftest pyel-test-for_loop-5 nil (equal (pyel-eval "pyel_test_for_loop_105()") (quote (1 3 5 7 9))))
(ert-deftest pyel-test-for_loop-6 nil (equal (pyel-eval "pyel_test_for_loop_106()") (quote ((1 2) ("3" "4") (5 6)))))
(ert-deftest pyel-test-for_loop-7 nil (equal (pyel-eval "pyel_test_for_loop_107()") (quote (2 4 6 8))))
(ert-deftest pyel-test-for_loop-8 nil (equal (pyel-eval "pyel_test_for_loop_108()") (quote (1 3 5 7 9))))
(ert-deftest pyel-test-for_loop-9 nil (equal (pyel-eval "pyel_test_for_loop_109()") 100))
(ert-deftest pyel-test-for_loop-10 nil (equal (pyel-eval "pyel_test_for_loop_110()") (quote ((1 2 1 1 1) ("3" "4" "x" "a" "3") (5 6 "a" 1 5)))))
(ert-deftest pyel-test-for_loop-11 nil (equal (pyel-eval "pyel_test_for_loop_111()") (quote ((1 2) ("3" "4") (5 6)))))
(ert-deftest pyel-test-for_loop-12 nil (equal (pyel-eval "pyel_test_for_loop_112()") (quote (0 1 2 3 4))))
(ert-deftest pyel-test-global-1 nil (equal (pyel-eval "pyel_test_global_113(1)") 3))
(ert-deftest pyel-test-global-2 nil (equal (pyel-eval "pyel_test_global_113(2)") 1))
(ert-deftest pyel-test-lambda-2 nil (equal (pyel-eval "pyel_test_lambda_114(1)") 3.3))
(ert-deftest pyel-test-lambda-3 nil (equal (pyel-eval "pyel_test_lambda_114(2)") (quote (1 (2 3 4 "asd")))))
(ert-deftest pyel-test-lambda-4 nil (equal (pyel-eval "pyel_test_lambda_114(3)") "[1, [2, 3, 4, 5], {b--: 2, a--: 1}]"))
(ert-deftest pyel-test-not-7 nil (equal (pyel-eval "pyel_test_not_115(1)") t))
(ert-deftest pyel-test-not-8 nil (equal (pyel-eval "pyel_test_not_115(2)") nil))
(ert-deftest pyel-test-usub-1 nil (equal (pyel-eval "pyel_test_usub_116()") -1))
(ert-deftest pyel-test-aug_assign-1 nil (equal (pyel-eval "pyel_test_aug_assign_117()") 5))
(ert-deftest pyel-test-aug_assign-2 nil (equal (pyel-eval "pyel_test_aug_assign_118(1)") 5))
(ert-deftest pyel-test-aug_assign-3 nil (equal (pyel-eval "pyel_test_aug_assign_118(2)") 6))
(ert-deftest pyel-test-aug_assign-4 nil (equal (pyel-eval "pyel_test_aug_assign_118(3)") 1))
(ert-deftest pyel-test-aug_assign-5 nil (equal (pyel-eval "pyel_test_aug_assign_118(4)") 0.5))
(ert-deftest pyel-test-aug_assign-6 nil (equal (pyel-eval "pyel_test_aug_assign_119()") "string"))
(ert-deftest pyel-test-aug_assign-7 nil (equal (pyel-eval "pyel_test_aug_assign_120()") [1 2 3 3]))
(ert-deftest pyel-test-aug_assign-8 nil (equal (pyel-eval "pyel_test_aug_assign_121()") (quote (1 3 4 2))))
(ert-deftest pyel-test-aug_assign-9 nil (equal (pyel-eval "pyel_test_aug_assign_122(1)") 7))
(ert-deftest pyel-test-aug_assign-10 nil (equal (pyel-eval "pyel_test_aug_assign_122(2)") 4))
(ert-deftest pyel-test-aug_assign-11 nil (equal (pyel-eval "pyel_test_aug_assign_122(3)") 0))
(ert-deftest pyel-test-aug_assign-12 nil (equal (pyel-eval "pyel_test_aug_assign_123(1)") 5))
(ert-deftest pyel-test-aug_assign-13 nil (equal (pyel-eval "pyel_test_aug_assign_123(2)") 6))
(ert-deftest pyel-test-aug_assign-14 nil (equal (pyel-eval "pyel_test_aug_assign_123(3)") 1))
(ert-deftest pyel-test-aug_assign-15 nil (equal (pyel-eval "pyel_test_aug_assign_123(4)") 0.5))
(ert-deftest pyel-test-aug_assign-16 nil (equal (pyel-eval "pyel_test_aug_assign_123(5)") "ss"))
(ert-deftest pyel-test-aug_assign-17 nil (equal (pyel-eval "pyel_test_aug_assign_124(1)") 5))
(ert-deftest pyel-test-aug_assign-18 nil (equal (pyel-eval "pyel_test_aug_assign_124(2)") 6))
(ert-deftest pyel-test-aug_assign-19 nil (equal (pyel-eval "pyel_test_aug_assign_124(3)") 1))
(ert-deftest pyel-test-aug_assign-20 nil (equal (pyel-eval "pyel_test_aug_assign_124(4)") 0.5))
(ert-deftest pyel-test-break-1 nil (equal (pyel-eval "pyel_test_break_125()") (quote (0 1 2 3 "b" 1 2 3 "b" 1 2 3 "b"))))
(ert-deftest pyel-test-break-2 nil (equal (pyel-eval "pyel_test_break_126()") 3))
(ert-deftest pyel-test-continue-1 nil (equal (pyel-eval "pyel_test_continue_127()") (quote (0 1 "c" 3 "c" 5 1 "c" 3 "c" 5 1 "c" 3 "c" 5))))
(ert-deftest pyel-test-continue-2 nil (equal (pyel-eval "pyel_test_continue_128()") (quote (0 7 5 3 1))))
(ert-deftest pyel-test-try-1 nil (equal (pyel-eval "pyel_test_try_129(1)") "no"))
(ert-deftest pyel-test-try-2 nil (equal (pyel-eval "pyel_test_try_129(2)") "ok"))
(ert-deftest pyel-test-try-3 nil (equal (pyel-eval "pyel_test_try_129(3)") "y"))
(ert-deftest pyel-test-try-4 nil (equal (pyel-eval "pyel_test_try_129(4)") 2233))
(ert-deftest pyel-test-in-1 nil (equal (pyel-eval "pyel_test_in_130(1)") nil))
(ert-deftest pyel-test-in-2 nil (equal (pyel-eval "pyel_test_in_130(2)") t))
(ert-deftest pyel-test-in-3 nil (equal (pyel-eval "pyel_test_in_130(3)") nil))
(ert-deftest pyel-test-in-4 nil (equal (pyel-eval "pyel_test_in_130(4)") t))
(ert-deftest pyel-test-in-5 nil (equal (pyel-eval "pyel_test_in_130(5)") (quote (5 6 7 8))))
(ert-deftest pyel-test-in-6 nil (equal (pyel-eval "pyel_test_in_131(1)") t))
(ert-deftest pyel-test-in-7 nil (equal (pyel-eval "pyel_test_in_131(2)") t))
(ert-deftest pyel-test-in-8 nil (equal (pyel-eval "pyel_test_in_131(3)") nil))
(ert-deftest pyel-test-in-9 nil (equal (pyel-eval "pyel_test_in_131(4)") nil))
(ert-deftest pyel-test-in-10 nil (equal (pyel-eval "pyel_test_in_132(1)") t))
(ert-deftest pyel-test-in-11 nil (equal (pyel-eval "pyel_test_in_132(2)") nil))
(ert-deftest pyel-test-in-12 nil (equal (pyel-eval "pyel_test_in_132(3)") t))
(ert-deftest pyel-test-list_comprehensions-7 nil (equal (pyel-eval "pyel_test_list_comprehensions_133(1)") (quote ((1 5 9) (2 6 10) (3 7 11) (4 8 12)))))
(ert-deftest pyel-test-list_comprehensions-8 nil (equal (pyel-eval "pyel_test_list_comprehensions_133(2)") (quote ((1 5 9) (2 6 10) (3 7 11) (4 8 12)))))
(ert-deftest pyel-test-dict_comprehensions-1 nil (equal (pyel-eval "pyel_test_dict_comprehensions_134(1)") 20))
(ert-deftest pyel-test-dict_comprehensions-2 nil (equal (pyel-eval "pyel_test_dict_comprehensions_134(2)") [(0 1 4) (0 1 4 9 16) (0 1 4 9 16 25 36 49 64 81)]))
(ert-deftest pyel-test-boolop-9 nil (equal (pyel-eval "pyel_test_boolop_135(1)") t))
(ert-deftest pyel-test-boolop-10 nil (equal (pyel-eval "pyel_test_boolop_135(2)") t))
(ert-deftest pyel-test-boolop-11 nil (equal (pyel-eval "pyel_test_boolop_135(3)") nil))
(ert-deftest pyel-test-boolop-12 nil (equal (pyel-eval "pyel_test_boolop_135(4)") "a"))
(ert-deftest pyel-test-len_function-4 nil (equal (pyel-eval "pyel_test_len_function_136(1)") 4))
(ert-deftest pyel-test-len_function-5 nil (equal (pyel-eval "pyel_test_len_function_136(2)") 0))
(ert-deftest pyel-test-len_function-6 nil (equal (pyel-eval "pyel_test_len_function_136(3)") 3))
(ert-deftest pyel-test-len_function-7 nil (equal (pyel-eval "pyel_test_len_function_136(4)") 4))
(ert-deftest pyel-test-list_function-1 nil (equal (pyel-eval "pyel_test_list_function_137()") (quote ("5" "4" "3" "2" "1"))))
(ert-deftest pyel-test-list_function-2 nil (equal (pyel-eval "pyel_test_list_function_138(1)") (quote ("1" "2" "3"))))
(ert-deftest pyel-test-list_function-3 nil (equal (pyel-eval "pyel_test_list_function_138(2)") (quote (1 2 3))))
(ert-deftest pyel-test-list_function-4 nil (equal (pyel-eval "pyel_test_list_function_138(3)") (quote (1 2 3))))
(ert-deftest pyel-test-list_function-5 nil (equal (pyel-eval "pyel_test_list_function_138(4)") (quote (3 2 1))))
(ert-deftest pyel-test-list_function-8 nil (equal (pyel-eval "pyel_test_list_function_139(1)") (quote ((1) 1))))
(ert-deftest pyel-test-list_function-9 nil (equal (pyel-eval "pyel_test_list_function_139(2)") t))
(ert-deftest pyel-test-list_function-10 nil (equal (pyel-eval "pyel_test_list_function_140(1)") nil))
(ert-deftest pyel-test-list_function-11 nil (equal (pyel-eval "pyel_test_list_function_140(2)") t))
(ert-deftest pyel-test-list_function-12 nil (equal (pyel-eval "pyel_test_list_function_140(3)") t))
(ert-deftest pyel-test-tuple_function-1 nil (equal (pyel-eval "pyel_test_tuple_function_141()") (quote ["5" "4" "3" "2" "1"])))
(ert-deftest pyel-test-tuple_function-2 nil (equal (pyel-eval "pyel_test_tuple_function_142(1)") ["1" "2" "3"]))
(ert-deftest pyel-test-tuple_function-3 nil (equal (pyel-eval "pyel_test_tuple_function_142(2)") [1 2 3]))
(ert-deftest pyel-test-tuple_function-4 nil (equal (pyel-eval "pyel_test_tuple_function_142(3)") [1 2 3]))
(ert-deftest pyel-test-tuple_function-5 nil (equal (pyel-eval "pyel_test_tuple_function_142(4)") [3 2 1]))
(ert-deftest pyel-test-tuple_function-8 nil (equal (pyel-eval "pyel_test_tuple_function_143(1)") (quote [[1] 1])))
(ert-deftest pyel-test-tuple_function-9 nil (equal (pyel-eval "pyel_test_tuple_function_143(2)") t))
(ert-deftest pyel-test-tuple_function-10 nil (equal (pyel-eval "pyel_test_tuple_function_144(1)") (quote ((1) 1))))
(ert-deftest pyel-test-tuple_function-11 nil (equal (pyel-eval "pyel_test_tuple_function_144(2)") t))
(ert-deftest pyel-test-tuple_function-12 nil (equal (pyel-eval "pyel_test_tuple_function_145(1)") nil))
(ert-deftest pyel-test-tuple_function-13 nil (equal (pyel-eval "pyel_test_tuple_function_145(2)") nil))
(ert-deftest pyel-test-tuple_function-14 nil (equal (pyel-eval "pyel_test_tuple_function_145(3)") t))
(ert-deftest pyel-test-str-1 nil (equal (pyel-eval "pyel_test_str_146()") "str4"))
(ert-deftest pyel-test-eval-1 nil (equal (pyel-eval "pyel_test_eval_147(1)") 23))
(ert-deftest pyel-test-eval-2 nil (equal (pyel-eval "pyel_test_eval_147(2)") 5))
(ert-deftest pyel-test-type-1 nil (equal (pyel-eval "pyel_test_type_148(1)") "<class 'testc'>"))
(ert-deftest pyel-test-type-2 nil (equal (pyel-eval "pyel_test_type_148(2)") t))
(ert-deftest pyel-test-abs_function-1 nil (equal (pyel-eval "pyel_test_abs_function_149()") "hi"))
(ert-deftest pyel-test-int_function-1 nil (equal (pyel-eval "pyel_test_int_function_150()") 342))
(ert-deftest pyel-test-int_function-2 nil (equal (pyel-eval "pyel_test_int_function_151(1)") 3))
(ert-deftest pyel-test-int_function-3 nil (equal (pyel-eval "pyel_test_int_function_151(2)") 4))
(ert-deftest pyel-test-int_function-4 nil (equal (pyel-eval "pyel_test_int_function_151(3)") 2))
(ert-deftest pyel-test-int_function-5 nil (equal (pyel-eval "pyel_test_int_function_151(4)") 3))
(ert-deftest pyel-test-float_function-1 nil (equal (pyel-eval "pyel_test_float_function_152()") 342.1))
(ert-deftest pyel-test-float_function-2 nil (equal (pyel-eval "pyel_test_float_function_153(1)") 3.1))
(ert-deftest pyel-test-float_function-3 nil (equal (pyel-eval "pyel_test_float_function_153(2)") 4.0))
(ert-deftest pyel-test-float_function-4 nil (equal (pyel-eval "pyel_test_float_function_153(3)") 2.0))
(ert-deftest pyel-test-float_function-5 nil (equal (pyel-eval "pyel_test_float_function_153(4)") 3.3))
(ert-deftest pyel-test-dict_function-1 nil (equal (pyel-eval "pyel_test_dict_function_154()") "{5: 25, 4: 16, 3: 9, 2: 4, 1: 1}"))
(ert-deftest pyel-test-dict_function-2 nil (equal (pyel-eval "pyel_test_dict_function_155()") "{\"a\": \"b\", \"b\": 5, \"c\": 8}"))
(ert-deftest pyel-test-enumerate_function-1 nil (equal (pyel-eval "pyel_test_enumerate_function_156()") (quote ((0 "5") (1 "4") (2 "3") (3 "2") (4 "1")))))
(ert-deftest pyel-test-divmod_function-1 nil (equal (pyel-eval "pyel_test_divmod_function_157()") [31 9]))
(ert-deftest pyel-test-bool_function-1 nil (equal (pyel-eval "pyel_test_bool_function_158(1)") "y"))
(ert-deftest pyel-test-bool_function-2 nil (equal (pyel-eval "pyel_test_bool_function_158(2)") "n"))
(ert-deftest pyel-test-bool_function-3 nil (equal (pyel-eval "pyel_test_bool_function_158(3)") "n"))
(ert-deftest pyel-test-bool_function-4 nil (equal (pyel-eval "pyel_test_bool_function_158(4)") "y"))
(ert-deftest pyel-test-iter_function-1 nil (equal (pyel-eval "pyel_test_iter_function_159(1)") 1))
(ert-deftest pyel-test-iter_function-2 nil (equal (pyel-eval "pyel_test_iter_function_159(2)") 2))
(ert-deftest pyel-test-iter_function-3 nil (equal (pyel-eval "pyel_test_iter_function_159(3)") "1"))
(ert-deftest pyel-test-iter_function-4 nil (equal (pyel-eval "pyel_test_iter_function_159(4)") "s"))
(ert-deftest pyel-test-iter_function-5 nil (equal (pyel-eval "pyel_test_iter_function_159(5)") "t"))
(ert-deftest pyel-test-iter_function-6 nil (equal (pyel-eval "pyel_test_iter_function_159(6)") "5"))
(ert-deftest pyel-test-iter_function-7 nil (equal (pyel-eval "pyel_test_iter_function_159(7)") "s"))
(ert-deftest pyel-test-iter_function-8 nil (equal (pyel-eval "pyel_test_iter_function_159(8)") 2))
(ert-deftest pyel-test-iter_function-9 nil (equal (pyel-eval "pyel_test_iter_function_159(9)") (quote ("s" "t" "r" "i" "n" "g"))))
(ert-deftest pyel-test-iter_function-10 nil (equal (pyel-eval "pyel_test_iter_function_159(10)") (quote ([2 3] "5" 1))))
(ert-deftest pyel-test-iter_function-11 nil (equal (pyel-eval "pyel_test_iter_function_160(1)") "5"))
(ert-deftest pyel-test-iter_function-12 nil (equal (pyel-eval "pyel_test_iter_function_160(2)") "4"))
(ert-deftest pyel-test-next_function-1 nil (equal (pyel-eval "pyel_test_next_function_161(1)") "5"))
(ert-deftest pyel-test-next_function-2 nil (equal (pyel-eval "pyel_test_next_function_161(2)") "4"))
(ert-deftest pyel-test-all_function-1 nil (equal (pyel-eval "pyel_test_all_function_162(1)") t))
(ert-deftest pyel-test-all_function-2 nil (equal (pyel-eval "pyel_test_all_function_162(2)") nil))
(ert-deftest pyel-test-any_function-1 nil (equal (pyel-eval "pyel_test_any_function_163(1)") t))
(ert-deftest pyel-test-any_function-2 nil (equal (pyel-eval "pyel_test_any_function_163(2)") nil))
(ert-deftest pyel-test-sum_function-1 nil (equal (pyel-eval "pyel_test_sum_function_164()") 15))
(ert-deftest pyel-test-hash-1 nil (equal (pyel-eval "pyel_test_hash_165()") 1234))
(ert-deftest pyel-test-append-1 nil (equal (pyel-eval "pyel_test_append_166(1)") (quote (1 2 3 "hi"))))
(ert-deftest pyel-test-append-2 nil (equal (pyel-eval "pyel_test_append_166(2)") t))
(ert-deftest pyel-test-append-3 nil (equal (pyel-eval "pyel_test_append_166(3)") t))
(ert-deftest pyel-test-append-4 nil (equal (pyel-eval "pyel_test_append_166(4)") t))
(ert-deftest pyel-test-append-5 nil (equal (pyel-eval "pyel_test_append_166(5)") (quote (3))))
(ert-deftest pyel-test-insert-1 nil (equal (pyel-eval "pyel_test_insert_167(1)") (quote (1 "hi" 2 3))))
(ert-deftest pyel-test-insert-2 nil (equal (pyel-eval "pyel_test_insert_167(2)") t))
(ert-deftest pyel-test-find_method-1 nil (equal (pyel-eval "pyel_test_find_method_168()") 1))
(ert-deftest pyel-test-index_method-1 nil (equal (pyel-eval "pyel_test_index_method_169(1)") 0))
(ert-deftest pyel-test-index_method-2 nil (equal (pyel-eval "pyel_test_index_method_169(2)") 2))
(ert-deftest pyel-test-index_method-3 nil (equal (pyel-eval "pyel_test_index_method_169(3)") 3))
(ert-deftest pyel-test-index_method-4 nil (equal (pyel-eval "pyel_test_index_method_170()") 3))
(ert-deftest pyel-test-index_method-5 nil (equal (pyel-eval "pyel_test_index_method_171(1)") 5))
(ert-deftest pyel-test-index_method-6 nil (equal (pyel-eval "pyel_test_index_method_171(2)") 3))
(ert-deftest pyel-test-index_method-7 nil (equal (pyel-eval "pyel_test_index_method_171(3)") 14))
(ert-deftest pyel-test-index_method-8 nil (equal (pyel-eval "pyel_test_index_method_171(4)") 0))
(ert-deftest pyel-test-index_method-9 nil (equal (pyel-eval "pyel_test_index_method_172(1)") 0))
(ert-deftest pyel-test-index_method-10 nil (equal (pyel-eval "pyel_test_index_method_172(2)") 1))
(ert-deftest pyel-test-index_method-11 nil (equal (pyel-eval "pyel_test_index_method_172(3)") 2))
(ert-deftest pyel-test-remove_method-1 nil (equal (pyel-eval "pyel_test_remove_method_173()") (quote (1 "2" "2"))))
(ert-deftest pyel-test-remove_method-2 nil (equal (pyel-eval "pyel_test_remove_method_174()") (quote ("2" "2" [1]))))
(ert-deftest pyel-test-remove_method-3 nil (equal (pyel-eval "pyel_test_remove_method_175()") (quote (1 "2" [1]))))
(ert-deftest pyel-test-remove_method-4 nil (equal (pyel-eval "pyel_test_remove_method_176()") t))
(ert-deftest pyel-test-count_method-2 nil (equal (pyel-eval "pyel_test_count_method_177(1)") 2))
(ert-deftest pyel-test-count_method-3 nil (equal (pyel-eval "pyel_test_count_method_177(2)") 1))
(ert-deftest pyel-test-count_method-4 nil (equal (pyel-eval "pyel_test_count_method_177(3)") 1))
(ert-deftest pyel-test-count_method-5 nil (equal (pyel-eval "pyel_test_count_method_177(4)") 1))
(ert-deftest pyel-test-count_method-6 nil (equal (pyel-eval "pyel_test_count_method_178(1)") 2))
(ert-deftest pyel-test-count_method-7 nil (equal (pyel-eval "pyel_test_count_method_178(2)") 1))
(ert-deftest pyel-test-count_method-8 nil (equal (pyel-eval "pyel_test_count_method_178(3)") 1))
(ert-deftest pyel-test-count_method-9 nil (equal (pyel-eval "pyel_test_count_method_178(4)") 1))
(ert-deftest pyel-test-extend_method-1 nil (equal (pyel-eval "pyel_test_extend_method_179(1)") t))
(ert-deftest pyel-test-extend_method-2 nil (equal (pyel-eval "pyel_test_extend_method_179(2)") (quote (1 "5" "4" "3" "2" "1"))))
(ert-deftest pyel-test-extend_method-3 nil (equal (pyel-eval "pyel_test_extend_method_180(1)") t))
(ert-deftest pyel-test-extend_method-4 nil (equal (pyel-eval "pyel_test_extend_method_180(2)") (quote (1 "e" "x" "t" "e" "n" "d" "e" "d"))))
(ert-deftest pyel-test-extend_method-5 nil (equal (pyel-eval "pyel_test_extend_method_181(1)") t))
(ert-deftest pyel-test-extend_method-6 nil (equal (pyel-eval "pyel_test_extend_method_181(2)") (quote (1 1 "2" [3]))))
(ert-deftest pyel-test-extend_method-7 nil (equal (pyel-eval "pyel_test_extend_method_182(1)") t))
(ert-deftest pyel-test-extend_method-8 nil (equal (pyel-eval "pyel_test_extend_method_182(2)") (quote (1 1 "2" [3]))))
(ert-deftest pyel-test-pop_method-1 nil (equal (pyel-eval "pyel_test_pop_method_183(1)") "two"))
(ert-deftest pyel-test-pop_method-2 nil (equal (pyel-eval "pyel_test_pop_method_183(2)") "{1: \"one\", 3: \"three\"}"))
(ert-deftest pyel-test-pop_method-3 nil (equal (pyel-eval "pyel_test_pop_method_184(1)") 4))
(ert-deftest pyel-test-pop_method-4 nil (equal (pyel-eval "pyel_test_pop_method_184(2)") (quote (1))))
(ert-deftest pyel-test-pop_method-5 nil (equal (pyel-eval "pyel_test_pop_method_184(3)") 1))
(ert-deftest pyel-test-pop_method-6 nil (equal (pyel-eval "pyel_test_pop_method_184(4)") t))
(ert-deftest pyel-test-reverse_method-1 nil (equal (pyel-eval "pyel_test_reverse_method_185(1)") (quote (3 2 1))))
(ert-deftest pyel-test-reverse_method-2 nil (equal (pyel-eval "pyel_test_reverse_method_185(2)") t))
(ert-deftest pyel-test-lower_method-1 nil (equal (pyel-eval "pyel_test_lower_method_186(1)") "ab"))
(ert-deftest pyel-test-lower_method-2 nil (equal (pyel-eval "pyel_test_lower_method_186(2)") "aB"))
(ert-deftest pyel-test-upper_method-1 nil (equal (pyel-eval "pyel_test_upper_method_187(1)") "AB"))
(ert-deftest pyel-test-upper_method-2 nil (equal (pyel-eval "pyel_test_upper_method_187(2)") "aB"))
(ert-deftest pyel-test-split_method-1 nil (equal (pyel-eval "pyel_test_split_method_188(1)") (quote ("a" "x" "b" "x" "d" "x"))))
(ert-deftest pyel-test-split_method-2 nil (equal (pyel-eval "pyel_test_split_method_188(2)") 6))
(ert-deftest pyel-test-split_method-4 nil (equal (pyel-eval "pyel_test_split_method_189()") (quote ("a" "b" "c"))))
(ert-deftest pyel-test-strip_method-1 nil (equal (pyel-eval "pyel_test_strip_method_190()") "e"))
(ert-deftest pyel-test-get_method-1 nil (equal (pyel-eval "pyel_test_get_method_191(1)") "one"))
(ert-deftest pyel-test-get_method-2 nil (equal (pyel-eval "pyel_test_get_method_191(2)") t))
(ert-deftest pyel-test-get_method-3 nil (equal (pyel-eval "pyel_test_get_method_191(3)") "three"))
(ert-deftest pyel-test-get_method-4 nil (equal (pyel-eval "pyel_test_get_method_191(4)") "d"))
(ert-deftest pyel-test-items_method-1 nil (equal (pyel-eval "pyel_test_items_method_192(1)") (quote ((3 "three") (2 "two") (1 "one")))))
(ert-deftest pyel-test-items_method-2 nil (equal (pyel-eval "pyel_test_items_method_192(2)") (quote ((8 88)))))
(ert-deftest pyel-test-items_method-3 nil (equal (pyel-eval "pyel_test_items_method_192(3)") nil))
(ert-deftest pyel-test-keys_method-1 nil (equal (pyel-eval "pyel_test_keys_method_193(1)") (quote (3 2 1))))
(ert-deftest pyel-test-keys_method-2 nil (equal (pyel-eval "pyel_test_keys_method_193(2)") (quote ((8)))))
(ert-deftest pyel-test-keys_method-3 nil (equal (pyel-eval "pyel_test_keys_method_193(3)") nil))
(ert-deftest pyel-test-values_method-1 nil (equal (pyel-eval "pyel_test_values_method_194(1)") (quote ("three" "two" "one"))))
(ert-deftest pyel-test-values_method-2 nil (equal (pyel-eval "pyel_test_values_method_194(2)") (quote (88))))
(ert-deftest pyel-test-values_method-3 nil (equal (pyel-eval "pyel_test_values_method_194(3)") nil))
(ert-deftest pyel-test-popitem_method-1 nil (equal (pyel-eval "pyel_test_popitem_method_195(1)") (quote (1 "one"))))
(ert-deftest pyel-test-popitem_method-2 nil (equal (pyel-eval "pyel_test_popitem_method_195(2)") "{2: \"two\", 3: \"three\"}"))
(ert-deftest pyel-test-copy_method-1 nil (equal (pyel-eval "pyel_test_copy_method_196(1)") nil))
(ert-deftest pyel-test-copy_method-2 nil (equal (pyel-eval "pyel_test_copy_method_196(2)") t))
(ert-deftest pyel-test-islower_method-4 nil (equal (pyel-eval "pyel_test_islower_method_197(1)") nil))
(ert-deftest pyel-test-islower_method-5 nil (equal (pyel-eval "pyel_test_islower_method_197(2)") t))
(ert-deftest pyel-test-islower_method-6 nil (equal (pyel-eval "pyel_test_islower_method_197(3)") nil))
(ert-deftest pyel-test-isupper_method-4 nil (equal (pyel-eval "pyel_test_isupper_method_198(1)") t))
(ert-deftest pyel-test-isupper_method-5 nil (equal (pyel-eval "pyel_test_isupper_method_198(2)") nil))
(ert-deftest pyel-test-isupper_method-6 nil (equal (pyel-eval "pyel_test_isupper_method_198(3)") nil))
(ert-deftest pyel-test-istitle_method-5 nil (equal (pyel-eval "pyel_test_istitle_method_199(1)") nil))
(ert-deftest pyel-test-istitle_method-6 nil (equal (pyel-eval "pyel_test_istitle_method_199(2)") t))
(ert-deftest pyel-test-istitle_method-7 nil (equal (pyel-eval "pyel_test_istitle_method_199(3)") nil))
(ert-deftest pyel-test-isalpha_method-1 nil (equal (pyel-eval "pyel_test_isalpha_method_200()") t))
(ert-deftest pyel-test-isalnum_method-1 nil (equal (pyel-eval "pyel_test_isalnum_method_201()") t))
(ert-deftest pyel-test-zfill_method-4 nil (equal (pyel-eval "pyel_test_zfill_method_202()") "000000asdf"))
(ert-deftest pyel-test-title_method-1 nil (equal (pyel-eval "pyel_test_title_method_203()") "2dd"))
(ert-deftest pyel-test-swapcase_method-1 nil (equal (pyel-eval "pyel_test_swapcase_method_204()") "AAbb1"))
(ert-deftest pyel-test-startswith_method-3 nil (equal (pyel-eval "pyel_test_startswith_method_205()") nil))
(ert-deftest pyel-test-rstrip_method-1 nil (equal (pyel-eval "pyel_test_rstrip_method_206()") "he"))
(ert-deftest pyel-test-lstrip_method-1 nil (equal (pyel-eval "pyel_test_lstrip_method_207()") "ello"))
(ert-deftest pyel-test-rsplit_method-1 nil (equal (pyel-eval "pyel_test_rsplit_method_208(1)") (quote ("a" "x" "b" "x" "d" "x"))))
(ert-deftest pyel-test-rsplit_method-2 nil (equal (pyel-eval "pyel_test_rsplit_method_208(2)") 6))
(ert-deftest pyel-test-rsplit_method-4 nil (equal (pyel-eval "pyel_test_rsplit_method_209()") (quote ("a" "b" "c"))))
(ert-deftest pyel-test-partition_method-1 nil (equal (pyel-eval "pyel_test_partition_method_210()") ["ab" "c" "defghi"]))
(ert-deftest pyel-test-rpartition_method-1 nil (equal (pyel-eval "pyel_test_rpartition_method_211()") ["ab" "c" "defghi"]))
(ert-deftest pyel-test-rjust_method-1 nil (equal (pyel-eval "pyel_test_rjust_method_212()") "        ab"))
(ert-deftest pyel-test-ljust_method-1 nil (equal (pyel-eval "pyel_test_ljust_method_213()") "ab        "))
(ert-deftest pyel-test-rfind_method-1 nil (equal (pyel-eval "pyel_test_rfind_method_214(1)") 1))
(ert-deftest pyel-test-rfind_method-2 nil (equal (pyel-eval "pyel_test_rfind_method_214(2)") 6))
(ert-deftest pyel-el-ast-test-assert-101 nil (string= (pyel "assert sldk()" nil nil t) "(assert  (call  (name  \"sldk\" 'load 1 7) nil nil nil nil 1 7) nil 1 0)
"))
(ert-deftest pyel-py-ast-test-assert-100 nil (equal (py-ast "assert sldk()") "Module(body=[Assert(test=Call(func=Name(id='sldk', ctx=Load()), args=[], keywords=[], starargs=None, kwargs=None), msg=None)])
"))
(ert-deftest pyel-transform-test-assert-99 nil (equal (pyel "assert sldk()") (quote (assert (pyel-fcall31 sldk) t nil))))
(ert-deftest pyel-el-ast-test-assert-98 nil (string= (pyel "assert adk,'messsage'" nil nil t) "(assert  (name  \"adk\" 'load 1 7) (str \"messsage\" 1 11) 1 0)
"))
(ert-deftest pyel-py-ast-test-assert-97 nil (equal (py-ast "assert adk,'messsage'") "Module(body=[Assert(test=Name(id='adk', ctx=Load()), msg=Str(s='messsage'))])
"))
(ert-deftest pyel-transform-test-assert-96 nil (equal (pyel "assert adk,'messsage'") (quote (assert adk t "messsage"))))
(ert-deftest pyel-el-ast-test-assign-31 nil (string= (pyel "a.b = c" nil nil t) "(assign  ((attribute  (name  \"a\" 'load 1 0) \"b\" 'store 1 0)) (name  \"c\" 'load 1 6) 1 0)
"))
(ert-deftest pyel-py-ast-test-assign-30 nil (equal (py-ast "a.b = c") "Module(body=[Assign(targets=[Attribute(value=Name(id='a', ctx=Load()), attr='b', ctx=Store())], value=Name(id='c', ctx=Load()))])
"))
(ert-deftest pyel-transform-test-assign-29 nil (equal (pyel "a.b = c") (quote (setattr a b c))))
(ert-deftest pyel-el-ast-test-assign-28 nil (string= (pyel "a.b.c = 1" nil nil t) "(assign  ((attribute  (attribute  (name  \"a\" 'load 1 0) \"b\" 'load 1 0) \"c\" 'store 1 0)) (num 1 1 8) 1 0)
"))
(ert-deftest pyel-py-ast-test-assign-27 nil (equal (py-ast "a.b.c = 1") "Module(body=[Assign(targets=[Attribute(value=Attribute(value=Name(id='a', ctx=Load()), attr='b', ctx=Load()), attr='c', ctx=Store())], value=Num(n=1))])
"))
(ert-deftest pyel-transform-test-assign-26 nil (equal (pyel "a.b.c = 1") (quote (setattr (getattr a b) c 1))))
(ert-deftest pyel-el-ast-test-assign-25 nil (string= (pyel "a.b = d.c" nil nil t) "(assign  ((attribute  (name  \"a\" 'load 1 0) \"b\" 'store 1 0)) (attribute  (name  \"d\" 'load 1 6) \"c\" 'load 1 6) 1 0)
"))
(ert-deftest pyel-py-ast-test-assign-24 nil (equal (py-ast "a.b = d.c") "Module(body=[Assign(targets=[Attribute(value=Name(id='a', ctx=Load()), attr='b', ctx=Store())], value=Attribute(value=Name(id='d', ctx=Load()), attr='c', ctx=Load()))])
"))
(ert-deftest pyel-transform-test-assign-23 nil (equal (pyel "a.b = d.c") (quote (setattr a b (getattr d c)))))
(ert-deftest pyel-el-ast-test-assign-16 nil (string= (pyel "a,b = a.e.e()" nil nil t) "(assign  ((tuple  ((name  \"a\" 'store 1 0) (name  \"b\" 'store 1 2)) 'store 1 0)) (call  (attribute  (attribute  (name  \"a\" 'load 1 6) \"e\" 'load 1 6) \"e\" 'load 1 6) nil nil nil nil 1 6) 1 0)
"))
(ert-deftest pyel-py-ast-test-assign-15 nil (equal (py-ast "a,b = a.e.e()") "Module(body=[Assign(targets=[Tuple(elts=[Name(id='a', ctx=Store()), Name(id='b', ctx=Store())], ctx=Store())], value=Call(func=Attribute(value=Attribute(value=Name(id='a', ctx=Load()), attr='e', ctx=Load()), attr='e', ctx=Load()), args=[], keywords=[], starargs=None, kwargs=None))])
"))
(ert-deftest pyel-transform-test-assign-14 nil (equal (pyel "a,b = a.e.e()") (quote (let ((__value__ (call-method (getattr a e) e))) (pyel-set2 a (pyel-subscript-load-index31 __value__ 0)) (pyel-set2 b (pyel-subscript-load-index31 __value__ 1))))))
(ert-deftest pyel-el-ast-test-assign-13 nil (string= (pyel "a[1:4], b[2], a.c = c" nil nil t) "(assign  ((tuple  ((subscript (name  \"a\" 'load 1 0) (slice (num 1 1 2) (num 4 1 4) nil) 'store 1 0) (subscript (name  \"b\" 'load 1 8) (index (num 2 1 10) nil nil) 'store 1 8) (attribute  (name  \"a\" 'load 1 14) \"c\" 'store 1 14)) 'store 1 0)) (name  \"c\" 'load 1 20) 1 0)
"))
(ert-deftest pyel-py-ast-test-assign-12 nil (equal (py-ast "a[1:4], b[2], a.c = c") "Module(body=[Assign(targets=[Tuple(elts=[Subscript(value=Name(id='a', ctx=Load()), slice=Slice(lower=Num(n=1), upper=Num(n=4), step=None), ctx=Store()), Subscript(value=Name(id='b', ctx=Load()), slice=Index(value=Num(n=2)), ctx=Store()), Attribute(value=Name(id='a', ctx=Load()), attr='c', ctx=Store())], ctx=Store())], value=Name(id='c', ctx=Load()))])
"))
(ert-deftest pyel-transform-test-assign-11 nil (equal (pyel "a[1:4], b[2], a.c = c") (quote (let ((__value__ c)) (pyel-subscript-store-slice3 a 1 4 nil (pyel-subscript-load-index31 __value__ 0)) (pyel-subscript-store-index15 b 2 (pyel-subscript-load-index31 __value__ 1)) (setattr a c (pyel-subscript-load-index31 __value__ 2))))))
(ert-deftest pyel-el-ast-test-assign-10 nil (string= (pyel "a = b = c" nil nil t) "(assign  ((name  \"a\" 'store 1 0) (name  \"b\" 'store 1 4)) (name  \"c\" 'load 1 8) 1 0)
"))
(ert-deftest pyel-py-ast-test-assign-9 nil (equal (py-ast "a = b = c") "Module(body=[Assign(targets=[Name(id='a', ctx=Store()), Name(id='b', ctx=Store())], value=Name(id='c', ctx=Load()))])
"))
(ert-deftest pyel-transform-test-assign-8 nil (equal (pyel "a = b = c") (quote (pyel-set2 a (pyel-set2 b c)))))
(ert-deftest pyel-el-ast-test-assign-7 nil (string= (pyel "a = b = c.e" nil nil t) "(assign  ((name  \"a\" 'store 1 0) (name  \"b\" 'store 1 4)) (attribute  (name  \"c\" 'load 1 8) \"e\" 'load 1 8) 1 0)
"))
(ert-deftest pyel-py-ast-test-assign-6 nil (equal (py-ast "a = b = c.e") "Module(body=[Assign(targets=[Name(id='a', ctx=Store()), Name(id='b', ctx=Store())], value=Attribute(value=Name(id='c', ctx=Load()), attr='e', ctx=Load()))])
"))
(ert-deftest pyel-transform-test-assign-5 nil (equal (pyel "a = b = c.e") (quote (pyel-set2 a (pyel-set2 b (getattr c e))))))
(ert-deftest pyel-el-ast-test-assign-4 nil (string= (pyel "a = b = c.e()" nil nil t) "(assign  ((name  \"a\" 'store 1 0) (name  \"b\" 'store 1 4)) (call  (attribute  (name  \"c\" 'load 1 8) \"e\" 'load 1 8) nil nil nil nil 1 8) 1 0)
"))
(ert-deftest pyel-py-ast-test-assign-3 nil (equal (py-ast "a = b = c.e()") "Module(body=[Assign(targets=[Name(id='a', ctx=Store()), Name(id='b', ctx=Store())], value=Call(func=Attribute(value=Name(id='c', ctx=Load()), attr='e', ctx=Load()), args=[], keywords=[], starargs=None, kwargs=None))])
"))
(ert-deftest pyel-transform-test-assign-2 nil (equal (pyel "a = b = c.e()") (quote (pyel-set2 a (pyel-set2 b (call-method c e))))))

(provide 'pyel-tests-generated)
