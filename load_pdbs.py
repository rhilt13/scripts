from pymol import cmd

num_pdb = 167
loaded_num = 0
for file_prefix in range(num_pdb):
    loaded_num += 1
    cmd.load(str(file_prefix+1)+'.pdb',"mov")
cmd.show("cartoon", "")
cmd.mset("1 -%d"%loaded_num)
