x=$1
mkdir fix
python ../helper_scripts/parse_multiple_chains.py --input_path input/input${x} --output_path fix/input${x}.jsonl
python ../helper_scripts/assign_fixed_chains.py --input_path fix/input${x}.jsonl --output_path fix/input${x}_assigned.jsonl --chain_list 'A'
python ../helper_scripts/make_fixed_positions_dict.py --specify_non_fixed --position_list "5 6 7 8 9 10 11 12 13 14 15 16 17" --chain_list 'A' --input_path fix/input${x}.jsonl --output_path fix/input${x}_fixed_pos.jsonl
python ../protein_mpnn_run.py --jsonl_path fix/input${x}.jsonl --chain_id_jsonl fix/input${x}_assigned.jsonl --fixed_positions_jsonl fix/input${x}_fixed_pos.jsonl --out_folder output/output${x} --num_seq_per_target 10 --sampling_temp "0.1" --seed 9 --batch_size 5 --model_name v_48_020 
