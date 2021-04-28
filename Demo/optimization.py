import re

arith_op = ['+','-','*','/']
logic_op = ['<','>','<=','>=','==','!=']
rel_op = ['&&','||','>>','<<']
keywords = ['IF','FALSE','GOTO']
is_level = lambda s : bool(re.match(r"^L[0-9]*$", s))
is_temp = lambda s : bool(re.match(r"^T[0-9]*$", s))
is_id = lambda s : bool(re.match(r"^[A-Za-z][A-Za-z0-9_]*$", s))
is_num = lambda s: bool(re.match(r"^[-]?[0-9]*(\.)?[0-9]*$", s))
is_bool = lambda s: bool(re.match(r"^(True|False)$", s))



def check_if_identity(tokens):

    new_line = ''
    if( tokens[3] == '+' ):#a=b+c

        if( tokens[2] == '0' ):#b=0
            new_line = [tokens[0], '=', tokens[4]]#a=c
            new_line = ' '.join(new_line)

        elif( tokens[4] == '0' ):#c=0
            new_line = [tokens[0], '=', tokens[2]]#a=b
            new_line = ' '.join(new_line)

        else:
            new_line = ' '.join(tokens)#a=b+c

    elif( tokens[3] == '*' ):

        if( tokens[2] == '0' or tokens[4] == '0' ):
            new_line = [tokens[0], '=', '0']
            new_line = ' '.join(new_line)

        elif( tokens[2] == '1' ):
            new_line = [tokens[0], '=', tokens[4]]
            new_line = ' '.join(new_line)

        elif( tokens[4] == '1' ):
            new_line = [tokens[0], '=', tokens[2]]
            new_line = ' '.join(new_line)

        else:
            new_line = ' '.join(tokens)

    elif( tokens[3] == '/' and (tokens[2] == '0' and tokens[3] != '0')):

        new_line = [tokens[0], '=', '0']
        new_line = ' '.join(new_line)

    elif( tokens[3] == '&&'):

        if(tokens[2] == 'true'):
            new_line = [tokens[0], '=', tokens[4]]
            new_line = ' '.join(new_line)

        elif(tokens[4] == 'true'):
            new_line = [tokens[0], '=', tokens[2]]
            new_line = ' '.join(new_line)

        else:
            new_line = ' '.join(tokens)

    elif( tokens[3] == '||'):

        if(tokens[2] == 'false'):
            new_line = [tokens[0], '=', tokens[4]]
            new_line = ' '.join(new_line)

        elif(tokens[4] == 'false'):
            new_line = [tokens[0], '=', tokens[2]]
            new_line = ' '.join(new_line)

        else:
            new_line = ' '.join(tokens)

    else:
        new_line = ' '.join(tokens)

    return new_line

def live_var (all_lines):
    final=list()
    all_lines=[i.strip() for i in all_lines]
    for line in all_lines:
        line = line.strip('\n')
        line = line.strip()
        tokens = line.split(' ')

        if len(tokens) == 3 or len(tokens) == 5:

            rhs = tokens[0]
            #print(rhs)
            ind = all_lines.index(line)
            i=ind+1
            while i in range(len(all_lines)):
                    #print(all_lines[i])
                    nline=all_lines[i]
                    nline = nline.strip('\n')
                    nline = nline.strip()
                    ntokens = nline.split(' ')
                    #print("IF",ntokens[0][0])
                    if len(ntokens) == 3 and ntokens[2] == rhs:
                            final.append(line)
                            #print(final)
                            i=len(all_lines)+10
                    elif len(ntokens) == 2 and ntokens[0] == "PARAM" and ntokens[1] == rhs:
                            final.append(line)
                            #print(final)
                            i=len(all_lines)+10
                    elif len(ntokens) == 6 and ntokens[4] == rhs:
                            final.append(line)
                            #print(final)
                            i=len(all_lines)+10
                    elif len(ntokens) == 5 and (ntokens[2] == rhs or ntokens[4] == rhs):
                            final.append(line)
                            #print(final)
                            i=len(all_lines)+10
                    elif len(ntokens) == 4 and (ntokens[1] == rhs ):
                            final.append(line)
                            #print(final)
                            i=len(all_lines)+10
                    i+=1

        else:
            final.append(line)
    return final

def remove(all_lines):
    old = all_lines
    old = [i.strip() for i in old]
    f=1
    while f:
        all_lines =live_var(all_lines)
        if all_lines == old:
            f=0
        else:
            old = all_lines
    return all_lines

def dead_elimination (all_lines):
    final=list()
    pass1=[]
    all_lines=[i.strip() for i in all_lines]
    for line in all_lines:
        line = line.strip('\n')
        line = line.strip()
        tokens = line.split(' ')
        if line in pass1:
            #print(line)
            pass

        elif len(tokens) == 6 and tokens[2] == "return":
            ind = all_lines.index(line)
            i=ind+1
            while i in range(len(all_lines)):
                #print(all_lines[i])
                nline=all_lines[i]
                nline = nline.strip('\n')
                nline = nline.strip()
                ntokens = nline.split(' ')
                #print("IF",ntokens[0][0])
                if len(ntokens) == 2 and ntokens[0][0] == 'L':
                    final.append(line)
                    final.append(nline)
                    pass1.append(nline)
                    #print(final)
                    #print(pass1)
                    i=len(all_lines)+10

                else:
                    pass1.append(nline)
                    i+=1
        else:
            final.append(line)


    #print(final)
    return final


def constant_folding(all_lines, comp=[]):

    final_list=[] #has all the lines
    for line in all_lines:
        line = line.strip('\n')
        line = line.strip()
        tokens = line.split(' ')
        #Sprint(tokens)
        if(len(tokens) == 5):#has to be an expression

            if( (tokens[3] in arith_op) and (is_num(tokens[2]) and is_num(tokens[4])) ):#evaluates arithmetic expression when operands are num

                new_line = [tokens[0], '=', str(eval(tokens[2]+tokens[3]+tokens[4]))]
                new_line = ' '.join(new_line)
                #print(new_line)
                final_list.append(new_line)

            elif( ((tokens[3] in logic_op) or (tokens[3] in rel_op) ) and (is_num(tokens[2]) and is_num(tokens[4])) ):#evaluates relational expression when operands are num

                if tokens[3] == "&&":
                    tokens[3] = " and "
                elif tokens[3] == "||":
                    tokens[3] = " or "

                new_line = [tokens[0], '=', str(eval(tokens[2]+tokens[3]+tokens[4]))]
                #print(new_line)
                new_line = ' '.join(new_line)
                final_list.append(new_line)

            else:#previou things can not have identity relation

                if ( not (is_id(tokens[2]) and is_id(tokens[4])) ):#if it dosent have any no check for check_if_identity
                    new_line = check_if_identity(tokens)
                    #print(new_line)
                    final_list.append(new_line)

                else:#it has only identifers so append to final
                    final_list.append(line)
        else:#if not an expression at all move forward
            final_list.append(line)

    if( all_lines == comp ):
        return (final_list, 0)
    else:
        return (final_list, 1)



def constant_propagation(all_lines,comp=[]):

    temp = dict()
    final_list = []
    for line in all_lines:

        line = line.strip('\n')
        line = line.strip()
        tokens = line.split()

        if( len(tokens) == 3 and tokens[1] == '=' and (is_num(tokens[2]) or tokens[2] == 'True' or tokens[2] == 'False')):

            temp[tokens[0]] = tokens[2]
            new_line = ' '.join(tokens)
            final_list.append(new_line)

        elif( len(tokens) == 3 and tokens[1] == '=' and tokens[2] in temp ):

            new_line = [tokens[0], '=', temp[tokens[2]]]
            new_line = ' '.join(new_line)
            final_list.append(new_line)

            temp[tokens[0]] = temp[tokens[2]]

        elif( len(tokens) == 5 ):

            if( tokens[2] in temp ):
                tokens[2] = temp[tokens[2]]

            if( tokens[4] in temp ):
                tokens[4] = temp[tokens[4]]

            if( tokens[0] in temp ):
                temp.pop(tokens[0])

            new_line = ' '.join(tokens)
            final_list.append(new_line)

        elif( len(tokens) == 4):
            if( tokens[1] in temp ):
                tokens[1] = temp[tokens[1]]
                #print("temp",tokens[1])
            new_line = ' '.join(tokens)
            final_list.append(new_line)


        else:
            final_list.append(line)

    if(final_list == comp):
        return (final_list, 0)
    else:
        return (final_list, 1)

def F_and_P(all_lines):

    f1 = 1
    f2 = 1

    const_fold_list, f1 = constant_folding(all_lines)
    const_prop_list, f2 = constant_propagation(const_fold_list)


    while( f1 == 1 or f2 == 1):

        const_fold_list, f1 = constant_folding(const_prop_list,const_fold_list)
        const_prop_list, f2 = constant_propagation(const_fold_list,const_prop_list)
        #print()

    return const_prop_list

def strength_reduction(all_lines, comp=[]):

    final_list = []
    for line in all_lines:

        line = line.strip('\n')
        line = line.strip()
        tokens = line.split(' ')

        if( len(tokens) == 5 ):

            #print("here")
            if( tokens[3] == '*' and tokens[4] == '2'):
                new_line = [tokens[0], '=', tokens[2], '+', tokens[2]]
                new_line = ' '.join(new_line)
                #print("mul" , new_line)
                final_list.append(new_line)

            elif( tokens[3] == '/' and tokens[4] == '2'):
                new_line = [tokens[0], '=', tokens[2], '>>', '1']
                new_line = ' '.join(new_line)
                final_list.append(new_line)

            else:
                final_list.append(line)
        else:
            final_list.append(line)


    if(final_list == comp):
        return (final_list, 0)
    else:
        return (final_list, 1)



filename = 'icg.txt'
f = open(filename, 'r')
all_lines = f.readlines()

a=remove(all_lines)
a=dead_elimination(a)
a,f=strength_reduction(a)
a=F_and_P(a)

for i in a:
    print(i)
    #print("--------------------------------------")
#a=dead_elimination(all_lines)
#a,f =strength_reduction(a);

#a = const_FP(a)
