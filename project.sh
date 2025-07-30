echo "script start"
x=$1
for f in alphafold/round${x}/full_data/*;do
name=$(basename $f)
python -c '
import json
import pymol
from pymol import cmd
import csv
import os
string="'$name'"
number=string[9]#extract file number
print(number)
with open("'$f'", "r") as file:
    data=json.load(file)
average_plddt=sum(data["atom_plddts"])/len(data["atom_plddts"])
print(f"{number}_average_plddt:{average_plddt:.2f}")#caculate average_plddt

cif_path="alphafold/round'$x'/dock/dock"+number+".cif"
chainA="A"
chainB="B"
cutoff=4.0
weighted_pae=0
only_sidechain=True
if not os.path.exists(cif_path):
    print(f"cif_not_exist in {cif_path}")
else:
    cmd.load(cif_path)
    print(f"loaded in {cif_path}")
if only_sidechain:
    selA = f"(chain {chainA}) and not name N+CA+C+O"
    selB = f"(chain {chainB}) and not name N+CA+C+O"
else:
    selA = f"(chain {chainA})"
    selB = f"(chain {chainB})"
atomsA = cmd.get_model(selA).atom
atomsB = cmd.get_model(selB).atom
contacts = []
for a in atomsA:
    for b in atomsB:
        dx = a.coord[0] - b.coord[0]
        dy = a.coord[1] - b.coord[1]
        dz = a.coord[2] - b.coord[2]
        dist = (dx**2 + dy**2 + dz**2) ** 0.5

        if dist <= cutoff:
            weighted_pae+=(70-data["pae"][int(a.resi)-1][int(b.resi)-1]-data["pae"][int(b.resi)-1][int(a.resi)-1])/70
            #print(f"resi in a: {a.resi} in b : {b.resi}")
print(f"{number}_weighted_pae:{weighted_pae:.2f}")#caculate weighted pae

pymol.finish_launching()
cmd.load("alphafold/round'$x'/single/single"+number+".cif", "mol1")
cmd.load("alphafold/round'$x'/cut/cut"+number+".cif","mol2")
cmd.align("mol1","mol2")
rms_cur = cmd.rms_cur("mol1","mol2")
print(f"{number}_rmsd:{rms_cur:.2f}")
score=5*rms_cur-average_plddt/10-weighted_pae
print(f"{number}_score:{score:.2f}")
'
done;
echo "finish analyse"
