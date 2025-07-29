x=$1
python ../protein_mpnn_run.py --pdb_path input/input${x}.pdb --out_folder output/output${x} --num_seq_per_target 10 --sampling_temp "0.1" --seed 9 --batch_size 5 --model_name v_48_020 
