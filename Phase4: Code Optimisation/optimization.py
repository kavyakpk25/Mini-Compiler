import re

arith_op = ['+','-','*','/']
logic_op = ['<','>','<=','>=','==','!=']
rel_op = ['&&','||','>>','<<']
keywords = ['IF','FALSE','GOTO','print']
is_level = lambda s : bool(re.match(r"^L[0-9]*$", s))
is_temp = lambda s : bool(re.match(r"^T[0-9]*$", s))
is_id = lambda s : bool(re.match(r"^[A-Za-z][A-Za-z0-9_]*$", s))
is_num = lambda s: bool(re.match(r"^[0-9]*(\.)?[0-9]*$", s))
is_bool = lambda s: bool(re.match(r"^(true|false)$", s))



def algebric_identity(tokens):

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

def dead_elimination (list_of_lines):
    final=list()
    list_of_lines=[i.strip() for i in list_of_lines]
    for line in list_of_lines:
        line = line.strip('\n')
        line = line.strip()
        tokens = line.split(' ')

        if len(tokens) == 6 and tokens[2] == "return":

            ind = list_of_lines.index(line)
            i=ind+1
            while i in range(len(list_of_lines)):
                    #print(list_of_lines[i])
                    nline=list_of_lines[i]
                    nline = nline.strip('\n')
                    nline = nline.strip()
                    ntokens = nline.split(' ')
                    #print("IF",ntokens[0][0])
                    if len(ntokens) == 2 and ntokens[0][0] == 'L':
                            final.append(line+"\n")
                            final.append(nline+"\n")
                            #print(final)
                            i=len(list_of_lines)+10

                    else:
                        i+=1
        else:
            final.append(line+"\n")



    return final





def const_FP(list_of_lines):

    flag1 = 1
    flag2 = 1

    const_fold_list, flag1 = constant_folding(list_of_lines)
    const_prop_list, flag2 = constant_propagation(const_fold_list)


    while( flag1 == 1 or flag2 == 1):

        const_fold_list, flag1 = constant_folding(const_prop_list,const_fold_list)
        const_prop_list, flag2 = constant_propagation(const_fold_list,const_prop_list)

    return const_prop_list



def constant_folding(list_of_lines, comp=[]):

    final_list=[] #has all the lines
    for line in list_of_lines:
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

                if ( not (is_id(tokens[2]) and is_id(tokens[4])) ):#if it dosent have any no check for algebric_identity
                    new_line = algebric_identity(tokens)
                    #print(new_line)
                    final_list.append(new_line)

                else:#it has only identifers so append to final
                    final_list.append(line)
        else:#if not an expression at all move forward
            final_list.append(line)

    if( list_of_lines == comp ):
        return (final_list, 0)
    else:
        return (final_list, 1)



def constant_propagation(list_of_lines,comp=[]):

    temp = dict()
    final_list = []
    for line in list_of_lines:

        line = line.strip('\n')
        line = line.strip()
        tokens = line.split()

        if( len(tokens) == 3 and tokens[1] == '=' and is_num(tokens[2]) ):

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

        else:

            final_list.append(line)

    if(final_list == comp):
        return (final_list, 0)
    else:
        return (final_list, 1)


def strength_reduction(list_of_lines, comp=[]):

    final_list = []
    for line in list_of_lines:

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

list_of_lines = f.readlines()
a=dead_elimination(list_of_lines)
a,f =strength_reduction(a);

a = const_FP(a)


for i in a:
    print(i)
    #print("--------------------------------------")
