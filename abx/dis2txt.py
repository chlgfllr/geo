# -*- coding: utf-8 -*-
"""
Created on Tue Jan  2 21:46:01 2018

@author: Thomas Schatz

Script to extract distances from an ABXpy '.task' file and associated
'.distances' file to an easier to read text format.

Output text file format:
    file_A onset_A offset_A file_B onset_B offset_B d(A,B)

Requirements: python 2.7+ or 3.5+, h5py, numpy, pandas

Usage: python dis2txt.py task_file distance_file out_txt_file
"""

import h5py
import numpy as np
import pandas


def dis2txt(task_file, distance_file, out_txt_file):
    distances = {}
    with h5py.File(task_file) as t, h5py.File(distance_file) as d:
        bys = t['bys'][...]
        for by in bys:
            pair_attrs = t['unique_pairs'].attrs[by]
            dis = d['distances']['data'][pair_attrs[1]:pair_attrs[2]][...]
            dis = np.reshape(dis, dis.shape[0])
            pairs = t['unique_pairs']['data'][pair_attrs[1]:pair_attrs[2]][...]
            pairs = np.reshape(pairs, pairs.shape[0])
            base = pair_attrs[0]
            A, B = pairs % base, pairs // base
            distances[by] = A, B, dis
    cols = ['file', 'onset', 'offset']
    dfs = []
    for by in bys:
        dis = distances[by]
        by_db = pandas.read_hdf(task_file, 'feat_dbs/' + by)
        df_A = by_db.loc[dis[0]]
        df_B = by_db.loc[dis[1]]
        df_A = df_A.reset_index(drop=True)
        df_B = df_B.reset_index(drop=True)
        df = pandas.DataFrame()
        df[['file_A', 'onset_A', 'offset_A']] = df_A[cols]
        df[['file_B', 'onset_B', 'offset_B']] = df_B[cols]
        df['d(A, B)'] = dis[2]
        dfs.append(df)
    df = pandas.concat(dfs)
    df.to_csv(out_txt_file, sep=" ")


if __name__ == '__main__':
    import argparse
    import os.path as path
    parser = argparse.ArgumentParser()
    parser.add_argument('task_file', help = "ABXpy '.task' file")
    parser.add_argument('distance_file', help = "ABXpy '.distances' file")
    parser.add_argument('out_txt_file', help = "Output text file")                 
    args = parser.parse_args()
    assert path.isfile(args.task_file), ("No such file "
                                         "{}".format(args.task_file))
    assert path.isfile(args.distance_file), ("No such file "
                                             "{}".format(args.distance_file))
    assert not(path.exists(args.out_txt_file)), \
           "Output path {} already occupied".format(args.out_text_file)        
    dis2txt(args.task_file, args.distance_file, args.out_txt_file)
