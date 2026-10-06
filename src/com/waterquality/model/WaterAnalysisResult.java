package com.waterquality.model;

import java.util.List;

public final class WaterAnalysisResult {
    private final WaterSample sample;
    private final List<ParameterAssessment> assessments;
    private final int riskScore;
    private final String riskLevel;

    public WaterAnalysisResult(WaterSample sample,
            List<ParameterAssessment> assessments, int riskScore,
            String riskLevel) {
        this.sample = sample;
        this.assessments = assessments;
        this.riskScore = riskScore;
        this.riskLevel = riskLevel;
    }

    public WaterSample getSample() { return sample; }
    public List<ParameterAssessment> getAssessments() { return assessments; }
    public int getRiskScore() { return riskScore; }
    public String getRiskLevel() { return riskLevel; }
    public String getRiskCssClass() { return riskLevel.toLowerCase(java.util.Locale.ROOT); }
}
