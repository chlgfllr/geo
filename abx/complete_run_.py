#!/usr/bin/env python

"""This test contains a full run of the ABX pipeline with randomly
created database and features.

"""

import os

import ABXpy.task
import ABXpy.distances.distances as distances
import ABXpy.distances.metrics.cosine as cosine
import ABXpy.distances.metrics.dtw as dtw
import ABXpy.score as score
import ABXpy.misc.items as items
import ABXpy.analyze as analyze


def dtw_cosine_distance(x, y, normalized):
    return dtw.dtw(x, y, cosine.cosine_distance, normalized)

my_path = "/Users/chloe/geo/abx/"
my_folder = "pulm_by_speaker/"
def fullrun():
    item_file = my_path + my_folder + 'abx.item'
    feature_file = 'mono_items.h5f'
    distance_file = my_path + my_folder + 'abx.distance'
    scorefilename = my_path + my_folder + 'abx.score'
    taskfilename = my_path + my_folder + 'abx.abx'
    analyzefilename = my_path + my_folder + 'results.csv'

    # deleting pre-existing files
    for f in [distance_file, scorefilename, taskfilename, analyzefilename]:
        try:
            os.remove(f)
        except OSError:
            pass

#    # running the evaluation
#    items.generate_db_and_feat(3, 3, 5, item_file, 2, 2, feature_file)

    task = ABXpy.task.Task(item_file, on='pulm', by=['speaker'])
    task.generate_triplets(taskfilename)

    
    distances.compute_distances(
        feature_file, '/features/', taskfilename,
        distance_file, dtw_cosine_distance,
        normalized=True, n_cpu=1)

    score.score(taskfilename, distance_file, scorefilename)

    analyze.analyze(taskfilename, scorefilename, analyzefilename)


if __name__ == '__main__':
    fullrun()
