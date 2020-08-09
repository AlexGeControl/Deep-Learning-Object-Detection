#! /bin/bash
python /workspace/detectron2/demo/demo.py \
    --config-file /workspace/detectron2/configs/COCO-Detection/retinanet_R_50_FPN_1x.yaml \
    --input /workspace/data/coco/val2017/000000000785.jpg \
    --opts MODEL.WEIGHTS /workspace/models/pre-trained/COCO-Detection/retinanet_R_50_FPN_1x/190397773/model_final_bfca0b.pkl