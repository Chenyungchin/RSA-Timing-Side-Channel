# write to prime_param.txt
with open('prime_param.txt', 'w+') as f_out:
    f_out.write('parameter [0: 16*NUM_OF_PRIME-1] PrimeArray = {\n')
    # read prime.txt
    with open('prime.txt') as f:
        txt = f.readlines()
        for id, line in enumerate(txt):
            # print(line)
            if (id == len(txt) - 1):
                f_out.write('    16\'d' + line[:-1] + '\n')
            else:
                f_out.write('    16\'d' + line[:-1] + ',\n')
        f.close()
    f_out.write('};')
    f_out.close()

