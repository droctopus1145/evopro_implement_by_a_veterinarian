x=$1
echo "start script"
mkdir alphafold
mkdir input
mkdir output
echo "successfully create alphafold"
cd alphafold
for i in $(seq 1 $x);do
mkdir round${i}
cd round${i}
echo "successfully create round${i}"
mkdir dock single cut full_data
cd ..
echo " successfully create files in round${i}"
done;
echo "create all successfully"

