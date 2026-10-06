package com.waterquality.service;

import com.waterquality.model.WaterAnalysisResult;
import com.waterquality.model.WaterSample;

public interface WaterAnalysisOperations {
    WaterAnalysisResult analyze(WaterSample sample);
}
