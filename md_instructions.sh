##### Setting up the protein and the system ######
gmx pdb2gmx -f $1 -o pdb.gro -ignh		# ForceField 6, WaterModel 1, -ignh = ignore hydrogen in pdb and add it
gmx editconf -f pdb.gro -o pdb_box.gro -c -d 1.0 -bt dodecahedron		# For globular proteins
gmx solvate -cp pdb_box.gro -cs spc216.gro -o pdb_solv.gro -p topol.top		# Generate a box of solvent
# Copy file ions.mdp which has parameters to set up solvent ions
gmx grompp -f ions.mdp -c pdb_solv.gro -p topol.top -o ions.tpr			# Outputs mdrun.mdp file
gmx genion -s ions.tpr -o pdb_ions.gro -p topol.top -conc 0.1 -neutral		# -conc Concentration for the system, Choose solvent 13 - SOL

##### Energy minimization step #####
# Copy files minim.mdp and minim_cg.mdp
gmx grompp -f minim.mdp -c pdb_ions.gro -p topol.top -o em.tpr		# First run energy minimization with steepest descent algorithm
gmx mdrun -v -deffnm em							# 

gmx grompp -f minim_cg.mdp -c em.gro -p topol.top -o em1.tpr	# Now use a conjugated descent algorithm to optimize energy minimization
gmx mdrun -v -deffnm em1

# Copy folder to sapelo

##### Production runs #####
### Run in sapelo

### qsub.sh script ###
#PBS -S /bin/bash
#PBS -j oe
#PBS -q batch
#PBS -N mgat2_nknnode
#PBS -l nodes=1:ppn=12:gpus=1:nknnode
#PBS -l walltime=30:00:00:00

module load cuda/6.5.14/gcc/4.4.7
source /usr/local/apps/gromacs/5.0.2/gcc447-cuda65/bin/GMXRC
cd /home/rt33095/GT/Mgat2_md

### Volume Optimization ###
/usr/local/apps/gromacs/5.0.2/gcc447-cuda65/bin/grompp -f nvt.mdp -c em1.gro -p topol.top -o nvt.tpr
/usr/local/apps/gromacs/5.0.2/gcc447-cuda65/bin/mdrun -nt 12 -v -deffnm nvt -gpu_id 0

### Pressure Optimization ###
/usr/local/apps/gromacs/5.0.2/gcc447-cuda65/bin/grompp -f npt.mdp -c nvt.gro -t nvt.cpt -p topol.top -o npt.tpr
/usr/local/apps/gromacs/5.0.2/gcc447-cuda65/bin/mdrun -nt 12 -v -deffnm npt -gpu_id 0

### Production ###
/usr/local/apps/gromacs/5.0.2/gcc447-cuda65/bin/grompp -f md.mdp -c npt.gro -t npt.cpt -p topol.top -o prod.tpr
/usr/local/apps/gromacs/5.0.2/gcc447-cuda65/bin/mdrun -nt 12 -pin on -s prod.tpr -gpu_id 0

### End qsub.sh script ###

## Output:
# traj.trr file

## Copy folder to local  computer


## Get a file with list of atoms and molecules in the trajectory file
gmx trjconv -f traj.trr -s prod.tpr -o confout.gro # kill instantly to get confout.gro file


## Convert trajectory files to pdb
gmx trjconv -f traj.trr -s prod.tpr -fit rot+trans -o traj.pdb -skip 500

#################################################
### For specific things

## Use Ruan's script for better visualization of pdb in pymol
python ~/scripts/head_trj.py -n 1000 -t traj_order.pdb --split snapshots/
cd snapshots
cp ~/scripts/load_pdbs.py 	# Change the number of pdbs to appropriate num
pymol laod_pdbs.py

## To analyze water molecules along with protein
## Order atoms in trajectory files based on how close they are to selection
gmx trjorder -f traj.trr -s prod.tpr -o traj_order.trr -dt 20 # Select protein for first option then water
## Get the index file that you can select groups of atoms from
gmx make_ndx -f prod.tpr -o index.ndx # kill it instantly after running, obtain a index.ndx file with index and groups of atoms
## Create index with protein and wanted water
vi index.ndx # Create a new index [protein+500water] copy paste protein atoms then select first 500 water and add that to this index
## Convert trajectory files to pdb
gmx trjconv -f traj_order.trr -s prod.tpr -fit rot+trans -n index.ndx -o traj_order.pdb -skip 500

############################# NOTES ##############################################
# Use pdb2pqr to add Hydrogen if want to use a different pH system. The in pdb2gmx (1st step) don't use -ignh option to accept Hydrogen in the pdb file.
